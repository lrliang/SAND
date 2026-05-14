#!/usr/bin/env bash
set -euo pipefail

# SAND Skill Contract Validator
# Validates a Skill directory against sandskill.v1 contract requirements.
# Usage: sand-skill-validate.sh <skill-directory>

# --- Color support ---
if [[ -z "${NO_COLOR:-}" ]] && [[ -t 1 ]]; then
  GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[0;33m'; BOLD='\033[1m'; RESET='\033[0m'
else
  GREEN=''; RED=''; YELLOW=''; BOLD=''; RESET=''
fi

# --- Counters ---
PASS_COUNT=0
FAIL_COUNT=0
WARN_COUNT=0

pass() { echo -e "  ${GREEN}[PASS]${RESET} $1"; PASS_COUNT=$((PASS_COUNT + 1)); }
fail() { echo -e "  ${RED}[FAIL]${RESET} $1"; FAIL_COUNT=$((FAIL_COUNT + 1)); }
warn() { echo -e "  ${YELLOW}[WARN]${RESET} $1"; WARN_COUNT=$((WARN_COUNT + 1)); }

# --- Argument validation ---
if [[ $# -ne 1 ]]; then
  echo -e "${RED}Error: Expected exactly 1 argument: <skill-directory>${RESET}"
  echo "Usage: $0 <skill-directory>"
  exit 2
fi

SKILL_DIR="${1%/}"  # Remove trailing slash if present

echo -e "${BOLD}SAND Skill Validator${RESET}"
echo "========================"
echo "Validating: ${SKILL_DIR}/"
echo ""

# --- Check 0: Directory exists ---
if [[ ! -d "$SKILL_DIR" ]]; then
  fail "Directory not found: ${SKILL_DIR}"
  echo ""
  echo -e "${RED}Result: FAIL (directory does not exist)${RESET}"
  exit 1
fi

# --- Check 1: SKILL.md exists ---
SKILL_FILE="${SKILL_DIR}/SKILL.md"
if [[ -f "$SKILL_FILE" ]]; then
  pass "SKILL.md exists"
else
  fail "SKILL.md not found at ${SKILL_FILE}"
  echo ""
  echo -e "${RED}Result: FAIL (cannot continue without SKILL.md)${RESET}"
  exit 1
fi

# --- Extract YAML frontmatter ---
# Frontmatter is between first and second '---' lines
FRONTMATTER=$(awk '/^---$/{n++; next} n==1{print} n>=2{exit}' "$SKILL_FILE")

if [[ -z "$FRONTMATTER" ]]; then
  fail "YAML frontmatter not found (expected content between --- markers)"
  echo ""
  echo -e "${RED}Result: FAIL (no frontmatter to validate)${RESET}"
  exit 1
else
  pass "YAML frontmatter present"
fi

# --- Helper: extract field value from frontmatter ---
get_field() {
  local field="$1"
  local raw
  raw=$(echo "$FRONTMATTER" | grep -m1 "^${field}:" | sed "s/^${field}:[[:space:]]*//" || true)
  # Strip surrounding double quotes
  raw=$(echo "$raw" | sed 's/^"//' | sed 's/"[[:space:]]*#.*$//' | sed 's/"$//')
  # Strip inline YAML comments for unquoted values (e.g., build  # comment)
  raw=$(echo "$raw" | sed 's/[[:space:]][[:space:]]*#.*$//')
  echo "$raw"
}

# --- Check 2: Required fields exist ---
REQUIRED_FIELDS=(sand_contract name version description sdc_phase entry_point requires inputs outputs)
for field in "${REQUIRED_FIELDS[@]}"; do
  if echo "$FRONTMATTER" | grep -q "^${field}:"; then
    pass "${field} field present"
  else
    fail "${field} field missing (required by sandskill.v1)"
  fi
done

# --- Check 3: sand_contract value ---
CONTRACT=$(get_field "sand_contract")
if [[ "$CONTRACT" == "sandskill.v1" ]]; then
  pass "sand_contract = \"sandskill.v1\""
else
  fail "sand_contract = \"${CONTRACT}\" (expected \"sandskill.v1\")"
fi

# --- Check 4: name pattern ---
NAME=$(get_field "name")
if [[ "$NAME" =~ ^sand-[a-z][a-z0-9-]*$ ]]; then
  pass "name matches pattern (${NAME})"
else
  fail "name \"${NAME}\" does not match ^sand-[a-z][a-z0-9-]*$"
fi

# --- Check 5: version SemVer ---
VERSION=$(get_field "version")
if [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  pass "version matches SemVer (${VERSION})"
else
  fail "version \"${VERSION}\" does not match SemVer pattern"
fi

# --- Check 6: description non-empty ---
DESC=$(get_field "description")
if [[ -n "$DESC" ]] && [[ "$DESC" != "\"\"" ]]; then
  pass "description is non-empty"
else
  fail "description is empty"
fi

# --- Check 7: sdc_phase enum ---
PHASE=$(get_field "sdc_phase")
VALID_PHASES="assess intent orchestrate build validate operate learn governance"
if echo "$VALID_PHASES" | grep -qw "$PHASE"; then
  pass "sdc_phase is valid (${PHASE})"
else
  fail "sdc_phase \"${PHASE}\" not in valid enum: ${VALID_PHASES}"
fi

# --- Check 8: entry_point file exists ---
ENTRY=$(get_field "entry_point")
if [[ -f "${SKILL_DIR}/${ENTRY}" ]]; then
  pass "entry_point file exists (${ENTRY})"
else
  fail "entry_point file not found: ${SKILL_DIR}/${ENTRY}"
fi

# --- Helper: extract array items from a YAML field ---
# Uses sed to extract lines between "field:" and the next top-level key
get_array_items() {
  local field="$1"
  local in_field=false
  local items=""
  while IFS= read -r line; do
    if [[ "$line" =~ ^${field}: ]]; then
      in_field=true
      continue
    fi
    if $in_field; then
      if [[ "$line" =~ ^[[:space:]]*- ]]; then
        local val
        val=$(echo "$line" | sed 's/^[[:space:]]*-[[:space:]]*//' | sed 's/[[:space:]]*$//' | sed 's/^"//' | sed 's/"$//')
        if [[ -n "$items" ]]; then
          items="${items}"$'\n'"${val}"
        else
          items="${val}"
        fi
      elif [[ "$line" =~ ^[a-zA-Z#] ]]; then
        break
      fi
    fi
  done <<< "$FRONTMATTER"
  echo "$items"
}

# --- Check 9: requires has valid capabilities ---
VALID_CAPS="file_read file_write shell_exec network_access agent_subprocess mcp_support"
REQ_ITEMS=$(get_array_items "requires")
REQ_COUNT=0
if [[ -n "$REQ_ITEMS" ]]; then
  REQ_COUNT=$(echo "$REQ_ITEMS" | wc -l | tr -d ' ')
fi

if [[ "$REQ_COUNT" -ge 1 ]]; then
  ALL_VALID=true
  while IFS= read -r cap; do
    if ! echo "$VALID_CAPS" | grep -qw "$cap"; then
      fail "requires contains invalid capability: ${cap}"
      ALL_VALID=false
    fi
  done <<< "$REQ_ITEMS"
  if $ALL_VALID; then
    pass "requires has ${REQ_COUNT} valid capability(s)"
  fi
else
  fail "requires must have at least 1 capability"
fi

# --- Check 10: inputs/outputs are present (warn if empty) ---
INPUT_ITEMS=$(get_array_items "inputs")
INPUT_COUNT=0
if [[ -n "$INPUT_ITEMS" ]]; then
  INPUT_COUNT=$(echo "$INPUT_ITEMS" | wc -l | tr -d ' ')
fi
if [[ "$INPUT_COUNT" -ge 1 ]]; then
  pass "inputs has ${INPUT_COUNT} declaration(s)"
else
  warn "inputs array is empty"
fi

OUTPUT_ITEMS=$(get_array_items "outputs")
OUTPUT_COUNT=0
if [[ -n "$OUTPUT_ITEMS" ]]; then
  OUTPUT_COUNT=$(echo "$OUTPUT_ITEMS" | wc -l | tr -d ' ')
fi
if [[ "$OUTPUT_COUNT" -ge 1 ]]; then
  pass "outputs has ${OUTPUT_COUNT} declaration(s)"
else
  warn "outputs array is empty"
fi

# --- Check 11: customize.toml exists ---
if [[ -f "${SKILL_DIR}/customize.toml" ]]; then
  pass "customize.toml exists"
else
  warn "customize.toml not found (recommended for workflow customization)"
fi

# --- Check 12: steps/ directory ---
if [[ -d "${SKILL_DIR}/steps" ]]; then
  pass "steps/ directory exists"

  # Check step file naming convention
  STEP_FILES=$(find "${SKILL_DIR}/steps" -name "step-[0-9][0-9]-*.md" -type f 2>/dev/null || true)
  STEP_COUNT=0
  if [[ -n "$STEP_FILES" ]]; then
    STEP_COUNT=$(echo "$STEP_FILES" | wc -l | tr -d ' ')
  fi

  if [[ "$STEP_COUNT" -ge 1 ]]; then
    pass "step files follow naming convention (${STEP_COUNT} file(s))"
  else
    # Check if there are any .md files with wrong naming
    BAD_FILES=$(find "${SKILL_DIR}/steps" -name "*.md" -type f 2>/dev/null | grep -v "step-[0-9][0-9]-" || true)
    if [[ -n "$BAD_FILES" ]]; then
      warn "step files exist but don't match step-NN-name.md pattern"
    else
      warn "steps/ directory has no step files yet"
    fi
  fi
else
  warn "steps/ directory not found"
fi

# --- Summary ---
echo ""
TOTAL=$((PASS_COUNT + FAIL_COUNT + WARN_COUNT))
if [[ "$FAIL_COUNT" -eq 0 ]]; then
  echo -e "${GREEN}Result: PASS${RESET} (${PASS_COUNT} passed, ${WARN_COUNT} warnings)"
  exit 0
else
  echo -e "${RED}Result: FAIL${RESET} (${PASS_COUNT} passed, ${FAIL_COUNT} failed, ${WARN_COUNT} warnings)"
  exit 1
fi
