---
name: planning-gate-1-5
description: |
  Verify Planning Gate 1.5 criteria. All features identified, user-confirmed scope, anti-truncation declaration signed. Generates scope-lock.md on PASS.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/completeness-matrix/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/feature-deliberation/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/systematic-evaluation/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /planning-gate-1-5 - Gate 1.5 Verification

## Lens / Skills / Model
**Lens**: `[Architecture]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per council-planning.md

## Prerequisites

- Phase 1.5 (Deliberation) must be complete

If prerequisites not met:
```
Phase 1.5 not complete. Run /planning-phase-1-5 first.
```

---

## Purpose

Gate 1.5 ensures **ALL features** are identified before investing in architecture and detailed design. This is a **BLOCKING** gate that enforces the "no feature truncation" principle.

**Critical**: This gate prevents the common AI failure mode of silently omitting features to simplify scope. ALL features from the product concept must be accounted for.

---

## Workflow

### Step 1: Load Gate 1.5 Criteria

Load criteria from `~/.claude/skills/ultimate-sdlc/context/gate-criteria.md` § Planning Council Gates → Gate 1.5.

Verify each criterion against the authoritative checklist. Run automated checks where applicable.

### Step 2: Generate Gate Report

Use **Display Template** from `council-planning.md` to show: Gate 1.5 Verification Report

### Step 3: Gate Decision

**If ALL criteria pass:**

1. Update `.ultimate-sdlc/project-context.md`:
   - Set Gate 1.5: Passed

2. Update `.ultimate-sdlc/council-state/planning/current-state.md`:
   - Mark Gate 1.5 passed with timestamp

3. **Generate `specs/scope-lock.md`** (MANDATORY on PASS):

```markdown
# Scope Lock — [Project Name]

Generated: [ISO 8601] | Gate 1.5: PASSED
Total Features In Scope: [count]

**This file is the canonical list of all features that MUST be planned.**
All downstream phases (3, 3.5, 4-7, 8) verify their output against this list.
Features cannot be removed from this list without explicit user approval.

## In-Scope Features

| # | Feature ID | Feature Name | Module/Domain | Complexity |
|---|-----------|-------------|---------------|------------|
| 1 | F-001 | [name] | [module] | Simple/Moderate/Complex |
| 2 | F-002 | [name] | [module] | Simple/Moderate/Complex |
| ... | ... | ... | ... | ... |

## User-Excluded Features (if any)

| # | Feature Name | User's Reason | Excluded At |
|---|-------------|---------------|-------------|
| — | [name] | [user's stated reason] | Phase 1.5 |
```

4. Display:

Use **Display Template** from `council-planning.md` to show: Gate 1.5: PASSED

**If ANY criterion fails:**

Use **Display Template** from `council-planning.md` to show: Gate 1.5: FAILED

### Step 4: Update State

If PASS:
1. Update `.ultimate-sdlc/council-state/planning/current-state.md`:
   - Mark Phase 1.5: Complete
   - Mark Gate 1.5: Passed with timestamp
2. Verify `specs/scope-lock.md` was generated with correct feature count

If FAIL:
1. Update `.ultimate-sdlc/council-state/planning/WORKING-MEMORY.md`:
   - Document issues found
   - Track what needs fixing

---
