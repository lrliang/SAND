# sand-example-skill

A minimal example of an external SAND Skill that complies with the `sandskill.v1` contract.

## Directory Structure

```
sand-example-skill/
├── SKILL.md           # Entry point with sandskill.v1 frontmatter
├── customize.toml     # Workflow customization (empty for this example)
├── steps/
│   └── step-01-hello.md   # Single step: greet user + produce output
└── README.md          # This file
```

## How to Run

1. Open `SKILL.md` in your AI-capable IDE (Claude Code, Cursor, etc.)
2. Follow the activation instructions — the IDE will guide you through `step-01-hello.md`
3. The Skill collects a name and message, then outputs to `.sand/executions/`

## How to Validate

Run the SAND Skill validator to confirm this example meets the contract:

```bash
scripts/sand-skill-validate.sh examples/external-skills/sand-example-skill/
```

Expected result: **PASS** with all checks green.

## Use as Template

To create your own Skill based on this example:

1. Run `scripts/sand-skill-init.sh sand-your-skill-name` to generate a fresh skeleton
2. Compare with this example for patterns and conventions
3. See `docs/skill-dev-guide.md` for the complete developer guide
