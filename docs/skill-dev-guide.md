# SAND Skill Developer Guide

This guide covers everything you need to build, validate, and submit a SAND Skill that complies with the `sandskill.v1` contract.

## What is a SAND Skill?

A SAND Skill is a self-contained, AI-executable workflow package. Each Skill guides an AI agent through a structured sequence of steps to accomplish a specific task within the SAND Development Cycle (SDC). Skills are the executable building blocks of the SAND methodology.

## Quick Start

Generate a new Skill skeleton:

```bash
scripts/sand-skill-init.sh sand-my-skill
```

This creates a directory with the required structure. Edit the generated files, then validate:

```bash
scripts/sand-skill-validate.sh sand-my-skill/
```

## Directory Structure

Every Skill follows this layout:

```
sand-my-skill/
├── SKILL.md           # Entry point (required) — frontmatter + activation body
├── customize.toml     # Workflow customization (required)
├── steps/             # Step files (required directory)
│   ├── step-01-name.md
│   └── step-02-name.md
├── data/              # Reference data files (optional)
│   └── rules.yaml
└── templates/         # Output templates (optional)
    └── report.yaml
```

| Component | Purpose |
|-----------|---------|
| **SKILL.md** | Declares the Skill contract (YAML frontmatter) and provides the activation entry point |
| **customize.toml** | Configures workflow behavior: prepend/append steps, persistent facts, completion hooks |
| **steps/** | Sequential step files executed by the AI agent |
| **data/** | Static reference data consumed by step files (e.g., rule tables, checklists) |
| **templates/** | Output templates that step files populate and write to `.sand/` |

## SKILL.md Frontmatter

The frontmatter is a YAML block between `---` markers. Fields must appear in the exact order shown below.

### Required Fields (Fixed Order)

```yaml
---
sand_contract: "sandskill.v1"     # Must be exactly "sandskill.v1"
name: "sand-my-skill"             # Pattern: sand-{kebab-case}
version: "0.1.0"                  # SemVer: MAJOR.MINOR.PATCH
description: "What this Skill does"  # Non-empty string
sdc_phase: "build"                # One of: assess, intent, orchestrate, build,
                                  #         validate, operate, learn, governance
entry_point: "SKILL.md"           # File that starts execution
requires:                         # At least 1 capability from:
  - file_read                     #   file_read, file_write, shell_exec,
  - file_write                    #   network_access, agent_subprocess, mcp_support
inputs:                           # Input file paths (glob patterns OK)
  - ".sand/intents/{intent_id}.yaml"
outputs:                          # Output file paths
  - ".sand/executions/EXE-{session_id}/report.yaml"
---
```

### Optional Fields (Alphabetical Order)

```yaml
author: "Your Name"
human_oversight: "hip-2"          # hip-1 (autonomous), hip-2 (review), hip-3 (supervised)
license: "MIT"
model_requirement:
  reasoning: "medium"             # low, medium, high
  context_window: "128K"
sand_min_version: "0.1.0"
tags: ["category", "keyword"]
```

## Step Files

Step files live in `steps/` and must be named `step-NN-descriptive-name.md` (e.g., `step-01-collect-input.md`).

### Required 6-Section Structure

Every step file must contain these sections in order:

```markdown
# Step N: Title

## MANDATORY EXECUTION RULES (READ FIRST):
(Numbered list of rules the AI agent must follow)

## YOUR TASK:
(One-paragraph description of what to accomplish)

## EXECUTION SEQUENCE:
(Numbered subsections with detailed instructions)

## SUCCESS METRICS:
(Bullet list of conditions that indicate successful completion)

## FAILURE MODES:
(Known failure scenarios and recovery actions)

## NEXT STEP:
(Pointer to next step file, or "complete" for the final step)
```

### Step Chaining

Each step's `NEXT STEP` section points to the next file:

```markdown
## NEXT STEP:
Read fully and follow `./step-02-process.md`
```

The final step declares completion instead of chaining.

## customize.toml

Controls workflow activation behavior:

```toml
[workflow]
activation_steps_prepend = []     # Steps to run before activation
activation_steps_append = []      # Steps to run after greeting
persistent_facts = [              # Context loaded for entire workflow
  "file:{sand-root}/docs/my-theory.md",
]
on_complete = ""                  # Command to run on completion
```

Use `file:{sand-root}/path` to reference project files as persistent context. Use `file:{project-root}/path` for user project files.

## Validation

Run the validator before submitting:

```bash
scripts/sand-skill-validate.sh path/to/your-skill/
```

The validator checks:
- SKILL.md exists with valid YAML frontmatter
- All 9 required fields present with correct values and patterns
- `name` follows `sand-{kebab-case}` pattern
- `version` follows SemVer format
- `sdc_phase` is a valid SDC phase
- `requires` contains valid capabilities
- `entry_point` file exists
- `steps/` directory exists with properly named files

A **PASS** result means your Skill meets the contract. Fix any **FAIL** items before submission.

## Submission Process

1. **Develop** your Skill following this guide
2. **Validate** with `sand-skill-validate.sh` — fix all FAIL items
3. **Test** by running the Skill in your AI IDE to confirm it works end-to-end
4. **Submit** via pull request to the SAND repository
5. **Review** — maintainers verify contract compliance and Skill quality
6. **Publish** — approved Skills are added to the registry

## Reference Example

See `examples/external-skills/sand-example-skill/` for a minimal working Skill that passes validation. Use it as a starting point or compare it against your own Skill for structural guidance.
