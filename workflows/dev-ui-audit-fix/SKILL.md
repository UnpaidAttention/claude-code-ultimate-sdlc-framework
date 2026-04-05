---
name: dev-ui-audit-fix
description: |
  "Phase 5 of UI Audit: Implement all gaps from the approved plan — missing routes, unwired components, incomplete pages. Follows Component Interaction Depth Rule (all 4 layers)."
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
- Read `~/.claude/skills/antigravity/knowledge/frontend-design/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/ui-ux-pro-max/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/component-patterns/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/clean-code/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# /dev-ui-audit-fix - Phase 5: Implement Gaps

## Lens / Skills / Model
**Lens**: `[UX]` + `[Quality]` | **Model**: Claude Opus 4
> Apply RARV cycle, session protocol, code review protocol per `council-development.md`

## Prerequisites

- Phase 4 complete: `.antigravity/council-state/development/ui-audit-plan.md` exists
- User has reviewed and approved the implementation plan

If prerequisites not met:
```
Phase 5 requires an approved implementation plan from Phase 4.
Run /dev-ui-audit-plan first, then get user approval before proceeding.
```

---

## Workflow

### Step 5.1: Load Implementation Context

1. Read `.antigravity/council-state/development/ui-audit-plan.md` — the approved plan
2. Read `.antigravity/council-state/development/ui-audit-existing-inventory.md` — existing design system tokens
3. Read `.antigravity/council-state/development/ui-audit-report.md` — gap details
4. Read `.antigravity/council-state/development/ui-audit-target-state.md` — target interaction maps

### Step 5.2: Implement Priority 1 — Missing Routes

For each missing route in the plan:
1. Create the page component
2. Register the route in the router configuration
3. Implement following the Component Interaction Depth Rule (all 4 layers):
   - **Layer 1**: Visual rendering (component structure, layout)
   - **Layer 2**: User interaction (event handlers, state management)
   - **Layer 3**: Data integration (API calls, data fetching)
   - **Layer 4**: Edge cases (loading, error, empty states)
4. Follow the Feature Interaction Map for the complete flow
5. Apply existing design system tokens (match current UI appearance)
6. Write tests per the AIOU Execution Protocol
7. Verify the route renders correctly and all interactions work
8. Update plan status: `PENDING` → `DONE`

### Step 5.3: Implement Priority 2 — Unwired Components

For each unwired component in the plan:
1. Locate the existing element in code
2. Implement the missing handler/modal/form/API integration
3. Apply all 4 layers of the Component Interaction Depth Rule
4. Wire to existing API endpoints
5. Write tests
6. Verify the interaction works end-to-end
7. Update plan status: `PENDING` → `DONE`

### Step 5.4: Implement Priority 3 — Incomplete Pages

For each incomplete page in the plan:
1. Locate the existing page shell
2. Add the missing content sections
3. Apply all 4 layers
4. Wire to data sources
5. Write tests
6. Verify completeness
7. Update plan status: `PENDING` → `DONE`

### Step 5.5: Progress Tracking

After completing each item, update `.antigravity/council-state/development/ui-audit-plan.md`:
- Change item status from `PENDING` to `DONE`
- If an item cannot be completed, mark as `BLOCKED` with reason

---

## Key Rules

- **Non-destructive**: Do NOT delete or replace any existing code. Only add new code and connect existing elements.
- **Design consistency**: Use existing design system tokens. New components must visually match the existing UI.
- **All 4 layers**: Every implementation must cover visual, interaction, data, and edge-case layers. No partial implementations.
- **Test each item**: Write tests before marking an item as DONE.
- **Commit incrementally**: Commit after each priority group (or more frequently for large groups).

---

## Completion Condition

- All items in `.antigravity/council-state/development/ui-audit-plan.md` are marked `DONE` (or `BLOCKED` with documented reason)
- All new code follows existing design system
- Tests pass for all implemented gaps
- No existing code was deleted

---

## Next Step

```
## Phase 5 Complete: Gaps Implemented

**Priority 1 (Missing Routes)**: [X]/[Y] done
**Priority 2 (Unwired Components)**: [X]/[Y] done
**Priority 3 (Incomplete Pages)**: [X]/[Y] done
**Blocked items**: [N] (see plan for details)

Next step: Run /dev-ui-audit-verify to verify all gaps are closed.
```

---
