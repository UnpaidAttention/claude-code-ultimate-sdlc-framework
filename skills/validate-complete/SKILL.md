---
name: sdlc-validate-complete
description: |
  Complete Validation Council and mark project as release-ready.
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
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/gate-verification/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/completeness-matrix/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/release-management/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/handoff-protocols/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


# /validate-complete - Complete Validation Council

## Arguments
| Argument | Required | Description |
|----------|----------|-------------|
| (none) | — | Session auto-detects state |

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply session protocol per `council-validation.md`
---

## Purpose

Verify Validation Council completion, generate final handoff, and mark project as RELEASE READY.

---

## Pre-Conditions

- All five tracks must be complete
- All gates (V5, C4, P4, E4, S2) must pass
- Final release checklist must be satisfied

---

## Workflow

### Step 1: Verify All Tracks Complete

Check track completion:

**Validation Track (V1-V5)**:
- [ ] V1: Intent extraction complete
- [ ] V2: Gap analysis complete
- [ ] V3: Completeness assessment complete
- [ ] V4: Prerequisite verification complete
- [ ] V5: Correction planning complete (GATE)

**Correction Track (C1-C4)**:
- [ ] C1: Targeted corrections applied
- [ ] C2: Edge cases handled
- [ ] C3: Verification testing passed
- [ ] C4: Regression validation passed (GATE)

**Production Track (P1-P4)**:
- [ ] P1: Operational assessment complete
- [ ] P2: Failure mode analysis complete
- [ ] P3: Performance optimization complete
- [ ] P4: Security hardening complete (GATE)

**Enhancement Track (E1-E4)**:
- [ ] E1: Feature richness evaluated
- [ ] E2: Innovation opportunities assessed
- [ ] E3: Enhancements implemented
- [ ] E4: UX polish complete (GATE)

**Synthesis Track (S1-S2)**:
- [ ] S1: Documentation updated
- [ ] S2: Release readiness verified (GATE)

**If any criterion fails**: Stop and report what's missing.

### Step 2: Final Release Checklist

Verify all items:

**Code Quality**:
- [ ] Build passes
- [ ] All tests pass
- [ ] No critical or high defects open
- [ ] Code coverage meets threshold

**Documentation**:
- [ ] README is current
- [ ] API documentation complete
- [ ] User documentation complete
- [ ] Deployment guide exists

**Security**:
- [ ] Security audit passed
- [ ] No known vulnerabilities
- [ ] Secrets properly managed
- [ ] HTTPS configured

**Operations**:
- [ ] Monitoring configured
- [ ] Logging configured
- [ ] Backup strategy defined
- [ ] Rollback procedure documented

### Step 3: Generate Final Handoff

Create `handoffs/validation-handoff.md` with this structure:

Use **Display Template** from `council-validation.md` to show: Validation Council Handoff - RELEASE READY

### Step 4: Update State

1. Update `.ultimate-sdlc/project-context.md`:
   - Mark Validation Council as complete
   - Add all gates to "Gates Passed" table
   - Add validation-handoff.md to "Handoffs Generated" table
   - Set Status: RELEASE READY

2. Update `.ultimate-sdlc/progress.md`:
   - Add Validation Council completion entry
   - Add release ready timestamp

### Step 5: Create Release Tag

```bash
git tag -a "v1.0.0-release-ready" -m "Validation Council complete - Release Ready"
```

### Step 6: Report Completion

Use **Display Template** from `council-validation.md` to show: Validation Council - Complete
Use **Display Template** from `council-validation.md` to show: VALIDATION COUNCIL COMPLETE
Planning ──────► Development ──────► Audit ──────► Validation ──────► RELEASE
   [X]              [X]              [X]             [X]               [X]
```

### Final Statistics
- Total Phases/Waves/Tracks: [count]
- Total Gates Passed: [count]
- Time to Completion: [duration]
- Final Quality Score: X/5

### Councils Summary
| Council | Phases | Gates | Status |
|---------|--------|-------|--------|
| Planning | 8 | 2 | Complete |
| Development | 7 | 2 | Complete |
| Audit | 11 | 3 | Complete |
| Validation | 19 | 5 | Complete |

---

### What Now?

The software has passed all quality gates and is ready for release.

**To Deploy**:
Follow the deployment guide in the documentation.

**To Start New Version**:
Run `/init` in a new project directory.

---

Congratulations on completing the Ultimate SDLC Framework!
```

---

## Notes

- This is the final checkpoint
- All previous work is preserved in handoff documents
- Git tag allows exact reproduction of release state
- Framework journey is complete

## Agent Invocations

### Agent: sdlc-gate-keeper
Invoke via Agent tool with `subagent_type: "sdlc-gate-keeper"`:
- **Provide**: All track completion checklists from Step 1, gate statuses (V5, C4, P4, E4, S2), release checklist from Step 2
- **Request**: Verify all validation gates pass and final release checklist is satisfied with no blocking issues
- **Apply**: Gate verification determines whether the project proceeds to release or stops with missing items

### Agent: sdlc-documentation
Invoke via Agent tool with `subagent_type: "sdlc-documentation"`:
- **Provide**: Validation results across all tracks, gate verification status, release checklist, quality metrics
- **Request**: Generate the final validation-to-release handoff document with complete statistics and release certification
- **Apply**: Use generated handoff in Step 3 to create handoffs/validation-handoff.md
