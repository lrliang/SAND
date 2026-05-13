# SAND Framework — Claude Code Configuration

SAND (Scaled AI-Native Development) is an executable panoramic methodology framework for AI-native software development transformation. Skills are the executable form of SAND's methodology — they guide structured human-AI collaboration through the SAND Development Cycle (SDC).

## SAND Skills

SAND Skills are located in `sand/skills/`. Each Skill follows the `sandskill.v1` contract defined in `schemas/sandskill.v1.schema.json`.

### Available Skills (Phase 1)

| Skill | SDC Phase | Description |
|-------|-----------|-------------|
| `sand-assess-maturity` | Assess | 7-dimension maturity assessment with radar chart and improvement pathways |
| `sand-create-intent` | Intent | Structured intent statement creation with CLEAR quality check |
| `sand-validate-delivery` | Validate | Three-channel parallel validation (contract, security, architecture) |

### Running a Skill

To run a SAND Skill, navigate to its directory under `sand/skills/` and follow the `SKILL.md` entry point.

## Path Conventions

- `{sand-root}` — resolves to this repository's root directory
- `.sand/` — runtime artifacts directory (created in the user's project, not in this repo)
- Skill-internal paths use relative references from the Skill directory

## Schemas and Templates

- `schemas/` — JSON Schema definitions for all SAND artifacts
- `templates/` — YAML templates for initializing new artifacts

## Key Architecture Decisions

- **Zero infrastructure**: `git clone` and an AI-capable IDE is all you need
- **Model agnostic**: Skills declare capability requirements, not model names
- **File-system state**: All state managed via YAML frontmatter and `.sand/` directory
- **sandskill.v1 contract**: 18-month forward compatibility commitment for Skill developers
