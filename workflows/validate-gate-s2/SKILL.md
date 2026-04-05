---
name: sdlc-validate-gate-s2
description: |
  Verify FINAL Gate S2 criteria. Software must pass all criteria to be release ready.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/gate-verification/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/release-certification/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/completeness-matrix/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/handoff-protocols/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /validate-gate-s2 - FINAL Gate Verification

## Lens / Skills / Model
**Lens**: `[Architecture]` | **Model**: Claude Opus 4.5
> Apply RARV cycle, session protocol per council-validation.md

## Prerequisites

- S2 (Release Readiness) must be complete

If prerequisites not met:
```
S2 not complete. Run /validate-s2 first.
```

---

## Workflow

### Step 1: Final Gate Criteria Checklist

#### Criterion 1: All Previous Gates Passed
- [ ] Gate V5 (Validation) - PASSED
- [ ] Gate C4 (Correction) - PASSED
- [ ] Gate P4 (Production) - PASSED
- [ ] Gate E4 (Enhancement) - PASSED

#### Criterion 2: Documentation Complete
- [ ] All user documentation updated
- [ ] All technical documentation updated
- [ ] Changelog updated
- [ ] Release notes prepared

#### Criterion 3: Release Checklist Complete
- [ ] Code quality verified
- [ ] Infrastructure ready
- [ ] Monitoring configured
- [ ] Rollback procedure ready

#### Criterion 4: Validation Handoff
- [ ] validation-handoff.md generated
- [ ] All tracks documented
- [ ] Final metrics recorded

### Step 2: Gate Decision

**If ALL criteria pass:**

Use **Display Template** from `council-validation.md` to show: Gate S2: PASSED — Project Release Ready

**If ANY criterion fails:**

Use **Display Template** from `council-validation.md` to show: Gate S2: FAILED

---
