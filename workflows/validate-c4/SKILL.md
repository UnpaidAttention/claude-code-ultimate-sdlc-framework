---
name: validate-c4
description: |
  Execute Correction Track C4 - Regression Validation. Ensure no regressions introduced by corrections.
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
AG_HOME="${HOME}/.antigravity"
AG_PROJECT=".antigravity"
AG_SKILLS="${HOME}/.claude/skills/antigravity"

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
- Read `~/.claude/skills/antigravity/knowledge/regression-testing/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/test-execution/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/smoke-testing/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/root-cause-analysis/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# /validate-c4 - Regression Validation

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per council-validation.md

## Prerequisites

- C3 (Verification Testing) must be complete

If prerequisites not met:
```
C3 not complete. Run /validate-c3 first.
```

---

## Workflow

### Step 1: Update Project State

Update `.antigravity/project-context.md`:
- Set `Current Phase`: C4 - Regression Validation
- Set `Status`: in_progress

### Step 2: Regression Test Suite

Run full regression test suite:

1. **Full Test Suite**
   // turbo
   ```bash
   # Run all tests
   npm test  # or appropriate test command
   ```

2. **E2E Test Suite**
   // turbo
   ```bash
   # Run end-to-end tests
   npm run test:e2e  # or appropriate command
   ```

3. **Integration Tests**
   // turbo
   ```bash
   # Run integration tests
   npm run test:integration
   Display: Step 3: Regression Analysis
## C4: Regression Validation - Complete

**Test Results**:
- Full Suite: [Pass]/[Total]
- E2E Tests: [Pass]/[Total]
- Smoke Tests: [Pass]/[Total]

**Regressions Found**: [X]
**Regressions Fixed**: [Y]

**Next Step**: Run `/validate-gate-c4` to verify Gate C4 criteria
```

---
