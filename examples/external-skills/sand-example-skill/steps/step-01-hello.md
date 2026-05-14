# Step 1: Hello World

## MANDATORY EXECUTION RULES (READ FIRST):

1. COMPLETE this step fully before moving to the next
2. DO NOT skip any section or instruction
3. RECORD all outputs in the specified format

## YOUR TASK:

Demonstrate the basic Skill execution pattern by collecting user input and producing a structured output file.

## EXECUTION SEQUENCE:

### 1. Greet the user

Display a welcome message:

```
Hello from sand-example-skill!
This is a demonstration of the sandskill.v1 contract.
```

### 2. Collect input

Ask the user for their name and a short message.

### 3. Generate output

Create the output file at `.sand/executions/EXE-{session_id}/example-output.yaml`:

```yaml
skill_name: "sand-example-skill"
user_name: "{collected name}"
message: "{collected message}"
timestamp: "{ISO-8601}"
status: "completed"
```

## SUCCESS METRICS:

- Welcome message displayed
- User input collected
- Output file created with correct structure

## FAILURE MODES:

- `.sand/executions/` directory not found -> Create it
- User cancels input -> Record status as "cancelled"

## NEXT STEP:

This is the only step. Skill execution is complete.
