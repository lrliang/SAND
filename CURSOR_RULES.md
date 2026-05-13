# SAND Framework — Cursor Rules

SAND (Scaled AI-Native Development) is an executable panoramic methodology framework. This file configures Cursor IDE for working with SAND Skills.

## Skill Location

SAND Skills are in `sand/skills/`. Each Skill directory contains a `SKILL.md` entry point with a `sandskill.v1` contract in its YAML frontmatter.

## Available Skills (Phase 1)

- `sand/skills/sand-assess-maturity/` — 7-dimension maturity assessment
- `sand/skills/sand-create-intent/` — Structured intent statement creation
- `sand/skills/sand-validate-delivery/` — Three-channel delivery validation

## Running a Skill

Open the `SKILL.md` file in any Skill directory and follow the activation instructions.

## Path Conventions

- `{sand-root}` resolves to this repository root
- `.sand/` is the runtime artifacts directory (in the user's project)
- All YAML artifacts use 2-space indentation, UTF-8 encoding, LF line endings

## Schemas and Templates

- `schemas/` — JSON Schema definitions (use for validation and IDE autocomplete)
- `templates/` — YAML starter templates for new artifacts

## Architecture Rules

- Skills must follow `sandskill.v1` contract (`schemas/sandskill.v1.schema.json`)
- All audit events append to `.sand/audits/audit.jsonl`
- Paths in Skills use `{sand-root}/` or `.sand/` anchors — never absolute paths
- YAML format: 2-space indent, `true`/`false`, `null`, multi-line arrays
