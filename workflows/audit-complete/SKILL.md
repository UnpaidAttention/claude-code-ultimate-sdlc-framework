---
name: audit-complete
description: |
  Complete Audit Council and generate handoff to Validation Council.
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
- Read `~/.claude/skills/antigravity/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/completeness-matrix/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/handoff-protocols/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# /audit-complete - Complete Audit Council

## Arguments
| Argument | Required | Description |
|----------|----------|-------------|
| (none) | — | Session auto-detects state |

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per `council-audit.md`

## Purpose

Verify Audit Council completion, generate handoff document, and prepare for Validation Council.

---

## Pre-Conditions

- Both tracks (Testing, Audit) must be complete
- Gates T3, A2, and A3 must pass
- Quality scorecard must be generated

---

## Workflow

### Step 1: Verify All Tracks Complete

Check track completion:

**Testing Track (T1-T5)**:
- [ ] T1: Feature inventory complete
- [ ] T2: Functional testing complete
- [ ] T3: GUI analysis complete (GATE)
- [ ] T4: Integration testing complete
- [ ] T5: Performance & security testing complete

**Audit Track (A1-A3)**:
- [ ] A1: Purpose alignment verified
- [ ] A2: Completeness gap analysis done (GATE)
- [ ] A3: Quality scorecard generated (GATE)

> **Note**: Enhancement activities (E1-E4) are handled by the Validation Council, not checked here.

**If any criterion fails**: Stop and report what's missing.

### Step 2: Compile Audit Results

Gather from council state:
- Total defects found (by severity)
- Quality score
- Gap analysis results
- Enhancement ideas captured (for Validation Council handoff)

### Step 3: Generate Handoff Document

Create `handoffs/audit-handoff.md` with this structure:

Use **Display Template** from `council-audit.md` to show: Audit Council Handoff

### Step 4: Update State

1. Update `.antigravity/project-context.md`:
   - Mark Audit Council as complete
   - Add Gates T3, A2, A3 to "Gates Passed" table
   - Add audit-handoff.md to "Handoffs Generated" table

2. Update `.antigravity/progress.md`:
   - Add Audit Council completion entry

### Step 5: Report Completion

Use **Display Template** from `council-audit.md` to show: Audit Council - Complete
Use **Display Template** from `council-audit.md` to show: Audit Council Complete

---

## Notes

- Quality score should be at least 3/5 to proceed
- Critical defects should be addressed before Validation
- Handoff includes prioritized work for Validation Council
