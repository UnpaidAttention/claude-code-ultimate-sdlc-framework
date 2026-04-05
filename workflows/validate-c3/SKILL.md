---
name: validate-c3
description: |
  Execute Correction Track C3 - Verification Testing. Verify all corrections work as expected.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/test-execution/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification layer-verification/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/regression-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /validate-c3 - Verification Testing

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per council-validation.md

## Prerequisites

- C2 (Edge Case Implementation) must be complete

If prerequisites not met:
```
C2 not complete. Run /validate-c2 first.
```

---

## Workflow

### Step 1: Update Project State

Update `.ultimate-sdlc/project-context.md`:
- Set `Current Phase`: C3 - Verification Testing
- Set `Status`: in_progress

### Step 2: Verification Test Plan

For each correction:

Use **Display Template** from `council-validation.md` to show: Verification: [Correction Name]

### Step 3: Execute Verification Tests

1. **Unit Tests**
   - Run all unit tests
   - Verify coverage meets requirements
   - Document any failures

2. **Integration Tests**
   - Run integration test suite
   - Verify cross-component functionality
   - Document any failures

3. **Manual Verification**
   - Test each correction manually
   - Verify before/after matches expectation
   - Document any discrepancies

### Step 4: Failure Handling

If verification fails:
1. Document failure in correction-log.md
2. Return to C1/C2 to fix
3. Re-run verification

### Step 5: Phase Completion Criteria

- [ ] All corrections verified
- [ ] Unit test suite passes
- [ ] Integration test suite passes
- [ ] Manual verification complete
- [ ] No failures outstanding

### Step 6: Complete Phase

Use **Display Template** from `council-validation.md` to show: C3: Verification Testing - Complete

---
