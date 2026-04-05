---
name: audit-t2
description: |
  Execute Audit Track T2 - Functional Testing. Systematic functional testing of all features.
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Agent
  - AskUserQuestion
---

## Preamble (run first)

```bash
# Detect project state
AG_HOME="${HOME}/.Ultimate SDLC"
AG_PROJECT=".ultimate-sdlc"
AG_SKILLS="${HOME}/.claude/skills/ultimate-sdlc"

# Check if project is initialized
if [ -d "$AG_PROJECT" ]; then
  echo "PROJECT: initialized"
  # Read current state
  if [ -f "$AG_PROJECT/project-context.md" ]; then
    COUNCIL=$(grep -A1 "## Active Council" "$AG_PROJECT/project-context.md" | tail -1 | tr -d ' ')
    PHASE=$(grep -A1 "## Current Phase" "$AG_PROJECT/project-context.md" | tail -1 | tr -d ' ')
    STATUS=$(grep -A1 "## Status" "$AG_PROJECT/project-context.md" | tail -1 | tr -d ' ')
    echo "COUNCIL: $COUNCIL"
    echo "PHASE: $PHASE"  
    echo "STATUS: $STATUS"
  fi
else
  echo "PROJECT: not initialized (run /init first)"
fi

# Read global config
if [ -f "$AG_HOME/config.yaml" ]; then
  GOV_MODE=$(grep "governance_mode:" "$AG_HOME/config.yaml" | awk '{print $2}')
  PROJ_TYPE=$(grep "project_type:" "$AG_HOME/config.yaml" | awk '{print $2}')
  echo "GOVERNANCE: ${GOV_MODE:-standard}"
  echo "PROJECT_TYPE: ${PROJ_TYPE:-web-app}"
fi
```

After the preamble runs, use the detected state to verify prerequisites for this workflow.

## Knowledge Skills

Load these knowledge skills for reference during this workflow:
- Read `~/.claude/skills/ultimate-sdlc/knowledge/functional-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/test-case-design/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/defect-logging/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /audit-t2 - Functional Testing

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per `council-audit.md`

## Prerequisites

- T1 (Inventory) must be complete

If prerequisites not met:
```
T1 not complete. Run /audit-start first.
```

---

## Workflow

### Step 1: Update Project State

Update `.ultimate-sdlc/project-context.md`:
- Set `Active Council`: audit
- Set `Current Phase`: T2 - Functional Testing
- Set `Status`: in_progress

### Step 2: Review Test Inventory

From T1 outputs:
- Feature catalogue
- Test case inventory
- Priority matrix

### Step 3: Execute Functional Tests

For each feature:

1. **Positive Tests**
   - Happy path scenarios
   - Expected inputs produce expected outputs

2. **Negative Tests**
   - Invalid inputs
   - Error handling verification

3. **Boundary Tests**
   - Edge cases
   - Limits and constraints

4. **State Tests**
   - Different system states
   - Concurrent operations

### Step 4: Document Results

For each test case:

Use **Display Template** from `council-audit.md` to show: Test: [Test Name]

### Step 5: Log Defects

For each failure, create defect entry:
- Use `/audit-defect` to log
- Include reproduction steps
- Attach screenshots if applicable

### Step 6: Phase Completion Criteria

Before completing this phase, verify:
- [ ] All high-priority test cases executed
- [ ] All critical features tested
- [ ] Defects logged with severity
- [ ] Test results documented

### Step 7: Complete Phase

When all criteria met:

Use **Display Template** from `council-audit.md` to show: T2: Functional Testing - Complete

---
