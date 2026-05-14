#!/usr/bin/env bash
set -euo pipefail

# SAND Skill Scaffolding Tool
# Generates a sandskill.v1 compliant Skill directory skeleton.
# Usage: sand-skill-init.sh <skill-name>

# --- Color support ---
if [[ -z "${NO_COLOR:-}" ]] && [[ -t 1 ]]; then
  GREEN='\033[0;32m'; RED='\033[0;31m'; BOLD='\033[1m'; RESET='\033[0m'
else
  GREEN=''; RED=''; BOLD=''; RESET=''
fi

# --- Argument validation ---
if [[ $# -ne 1 ]]; then
  echo -e "${RED}Error: Expected exactly 1 argument: <skill-name>${RESET}"
  echo "Usage: $0 <skill-name>"
  echo "Example: $0 sand-my-custom-skill"
  exit 2
fi

SKILL_NAME="$1"

if ! [[ "$SKILL_NAME" =~ ^sand-[a-z][a-z0-9-]*$ ]]; then
  echo -e "${RED}Error: Skill name must match pattern: sand-{kebab-case}${RESET}"
  echo "  Got: $SKILL_NAME"
  echo "  Expected: sand-<lowercase-letters-digits-dashes>"
  echo "  Example: sand-my-custom-skill"
  exit 2
fi

# --- Check directory does not already exist ---
if [[ -d "$SKILL_NAME" ]]; then
  echo -e "${RED}Error: Directory '$SKILL_NAME' already exists.${RESET}"
  exit 1
fi

# --- Create directory structure ---
echo -e "${BOLD}SAND Skill Scaffolding${RESET}"
echo "========================"
echo "Creating: ${SKILL_NAME}/"
echo ""

mkdir -p "${SKILL_NAME}/steps"

# --- Generate SKILL.md ---
cat > "${SKILL_NAME}/SKILL.md" << SKILL_EOF
---
# === Required fields (fixed order) ===
sand_contract: "sandskill.v1"
name: "${SKILL_NAME}"
version: "0.1.0"
description: "TODO: One-line description of this Skill"
sdc_phase: "build"  # TODO: Change to correct SDC phase (assess/intent/orchestrate/build/validate/operate/learn/governance)
entry_point: "SKILL.md"
requires:
  - file_read
  - file_write
inputs:
  - "TODO: Declare input file paths"
outputs:
  - "TODO: Declare output file paths"
# === Optional fields (alphabetical) ===
author: ""
human_oversight: "hip-2"
license: "MIT"
model_requirement:
  reasoning: "medium"
  context_window: "128K"
sand_min_version: "0.1.0"
tags: []
---

# ${SKILL_NAME}

TODO: Describe what this Skill does.

## Usage

**[Step 1/N]** Read fully and follow \`./steps/step-01-TODO.md\`
SKILL_EOF

# --- Generate customize.toml ---
cat > "${SKILL_NAME}/customize.toml" << 'TOML_EOF'
# Skill workflow customization
# 3-layer merge: base -> team -> user

[workflow]

activation_steps_prepend = []
activation_steps_append = []
persistent_facts = []
on_complete = ""
TOML_EOF

# --- Create steps placeholder ---
touch "${SKILL_NAME}/steps/.gitkeep"

# --- Output success ---
echo -e "  ${GREEN}✓${RESET} SKILL.md      — sandskill.v1 frontmatter template"
echo -e "  ${GREEN}✓${RESET} customize.toml — workflow configuration template"
echo -e "  ${GREEN}✓${RESET} steps/         — step files directory (empty)"
echo ""
echo "Done! Next steps:"
echo "  1. Edit SKILL.md — fill in description, sdc_phase, inputs, outputs"
echo "  2. Create step files in steps/ (e.g., step-01-your-step.md)"
echo "  3. Run: scripts/sand-skill-validate.sh ${SKILL_NAME}/"
