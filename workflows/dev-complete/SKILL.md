---
name: dev-complete
description: |
  Complete Development Council and generate handoff to Audit Council.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/test-patterns/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/handoff-protocols/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /dev-complete - Complete Development Council

## Arguments
| Argument | Required | Description |
|----------|----------|-------------|
| (none) | — | Session auto-detects state |

---

## Lens / Skills / Model
**Lens**: `[Architecture]` + `[Quality]` + `[Documentation]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per `council-development.md`

## Purpose

Verify Development Council completion, generate handoff document, and prepare for Audit Council.

---

## Pre-Conditions

- Gate I8 (Integration Complete) must pass
- All AIOUs must be implemented
- All tests must pass
- Build must succeed

---

## Workflow

### Step 1: Verify Gate I8

Check all Gate I8 criteria:

- [ ] All AIOUs marked complete in `.ultimate-sdlc/council-state/development/current-state.md`
- [ ] Build succeeds without errors
- [ ] All unit tests pass
- [ ] All integration tests pass
- [ ] Code coverage meets minimum threshold
- [ ] No critical linting errors
- [ ] Documentation is current
- [ ] Git repository is clean (all changes committed)

**If any criterion fails**: Stop and report what's missing.

### Step 2: Run Final Verification

Execute these commands:
// turbo
```bash
# Build
npm run build  # or equivalent

# Tests
npm run test

# Lint
npm run lint

# Coverage report
npm run test:coverage
```

### Step 3: Generate Handoff Document

```bash
git tag -a "development-complete" -m "Development Council complete - Gate I8 passed"
```

### Step 6: Report Completion


Use **Display Template** from `council-development.md` to show: Development Council Complete

---

## If Verification Fails

If build or tests fail:
1. Report specific failures
2. Keep Development Council active
3. Fix issues
4. Run `/dev-complete` again

---

## Notes

- This is a blocking checkpoint
- Software must be working before proceeding to Audit
- Tag allows rollback if needed
