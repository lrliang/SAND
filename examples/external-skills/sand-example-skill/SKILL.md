---
# === Required fields (fixed order) ===
sand_contract: "sandskill.v1"
name: "sand-example-skill"
version: "0.1.0"
description: "Example external Skill demonstrating sandskill.v1 contract compliance"
sdc_phase: "build"
entry_point: "SKILL.md"
requires:
  - file_read
  - file_write
inputs:
  - ".sand/intents/{intent_id}.yaml"
outputs:
  - ".sand/executions/EXE-{session_id}/example-output.yaml"
# === Optional fields (alphabetical) ===
author: "SAND Example"
human_oversight: "hip-2"
license: "MIT"
model_requirement:
  reasoning: "low"
  context_window: "128K"
sand_min_version: "0.1.0"
tags: ["example", "tutorial"]
---

# sand-example-skill

This is an example external Skill that demonstrates the `sandskill.v1` contract structure. Use it as a reference when building your own Skills.

## Usage

**[Step 1/1]** Read fully and follow `./steps/step-01-hello.md`

## Output

- `.sand/executions/EXE-{session_id}/example-output.yaml` — A simple output file demonstrating the Skill output pattern.
