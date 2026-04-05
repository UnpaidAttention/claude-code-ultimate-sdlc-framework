---
name: validate-c1
description: |
  Execute Correction Track C1 - Targeted Corrections. Implement priority corrections with before/after documentation.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/correction-management/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/tdd-methodology/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification layer-verification/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /validate-c1 - Targeted Corrections

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per council-validation.md

## Prerequisites

- Gate V5 must be passed

If prerequisites not met:
```
Gate V5 not passed. Run /validate-gate-v5 first.
```

---

## Workflow

### Step 1: Update Project State

Update `.ultimate-sdlc/project-context.md`:
- Set `Current Track`: Correction
- Set `Current Phase`: C1 - Targeted Corrections
- Set `Status`: in_progress

### Step 2: Before/After Protocol

**CRITICAL**: For EVERY correction:

1. **Document BEFORE state**
   - Take screenshot if UI-related
   - Log current behavior
   - Record test results

2. **Implement correction**
   - Follow correction plan
   - Write/update tests first (TDD)
   - Make minimal changes

3. **Document AFTER state**
   - Take screenshot if UI-related
   - Verify new behavior
   - Record test results

4. **Log in correction-log.md**
   Use **Display Template** from `council-validation.md` to show: Correction: [Name]

### Step 3: Verification Layer Verification

For each correction, verify through all 8 layers:

1. **UI Layer**: Visual rendering correct
2. **Event Layer**: User interactions work
3. **Frontend State**: State updates properly
4. **API Layer**: API calls succeed
5. **Backend Layer**: Business logic correct
6. **Service Layer**: External services work
7. **Persistence Layer**: Data saved correctly
8. **Restart Layer**: Survives application restart

### Step 4: Priority Execution

Work through corrections in priority order:
- P1 (Critical) - ALL must be completed
- P2 (High) - ALL should be completed

### Step 5: Phase Completion Criteria

- [ ] All P1 corrections implemented
- [ ] All P2 corrections implemented
- [ ] Before/after documented for each
- [ ] verification layer verification completed
- [ ] All tests passing

### Step 6: Complete Phase

```
## C1: Targeted Corrections - Complete

**Corrections Implemented**: [X]
**P1 Complete**: [Y]/[Total P1]
**P2 Complete**: [Z]/[Total P2]

**Next Step**: Run `/validate-c2` to continue to Edge Case Implementation
```

---
