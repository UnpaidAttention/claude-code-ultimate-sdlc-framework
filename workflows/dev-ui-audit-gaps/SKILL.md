---
name: dev-ui-audit-gaps
description: |
  "Phase 3 of UI Audit: Gap analysis — compare existing UI inventory against target state to identify missing routes, unwired components, and CRUD gaps."
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/frontend-design/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/ui-ux-pro-max/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/component-patterns/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /dev-ui-audit-gaps - Phase 3: Gap Analysis

## Lens / Skills / Model
**Lens**: `[UX]` + `[Quality]` | **Model**: Claude Opus 4
> Apply RARV cycle, session protocol per `council-development.md`

## Prerequisites

- Phase 1 complete: `.ultimate-sdlc/council-state/development/ui-audit-existing-inventory.md` exists
- Phase 2 complete: `.ultimate-sdlc/council-state/development/ui-audit-target-state.md` exists

If prerequisites not met:
```
Phase 3 requires both the existing inventory (Phase 1) and target state (Phase 2).
Run /dev-ui-audit-scan and /dev-ui-audit-target first.
```

---

## Workflow

### Step 3.1: Compare Routes

For every route in the Target Route Tree, check against the Existing Route Tree:
- Does the route exist?
- Does the component exist?
- Does it render actual content (not an empty shell)?

### Step 3.2: Compare Interactions

For every interaction in the Target Feature Interaction Maps, check against the Existing Interaction Inventory:
- Does the trigger element exist?
- Does it have a handler with logic?
- Does the full flow work (trigger→completion)?

### Step 3.3: Compare CRUD Operations

For every cell in the Target CRUD Matrix, check if the operation is implemented:
- API call exists?
- UI for the operation exists?
- Full flow works (form/button → API → response → UI update)?

---

## Output Artifact

Save to `.ultimate-sdlc/council-state/development/ui-audit-report.md`:

```markdown
# UI Completeness Gap Analysis

## Route Gaps
| Target Route | Exists? | Component Exists? | Renders Content? | Status |
|-------------|---------|-------------------|-----------------|--------|
| /path | Yes/No | Yes/No | Yes/No/Partial | OK/MISSING/INCOMPLETE |

## Interaction Gaps
| Feature | Interaction | Target | Current State | Gap |
|---------|------------|--------|---------------|-----|
| [Feature] | [Action] | [Expected behavior] | [What currently happens] | UNWIRED/MISSING/OK |

## CRUD Gaps
| Entity | Create | Read List | Read Detail | Update | Delete | Search | Filter | Sort |
|--------|--------|-----------|-------------|--------|--------|--------|--------|------|
| [Entity] | OK/GAP | OK/GAP | OK/GAP | OK/GAP | OK/GAP | OK/GAP | OK/GAP | OK/GAP |

## Summary
- Routes: [X] target | [Y] exist | [Z] missing | [W] incomplete
- Interactions: [X] target | [Y] fully wired | [Z] render-only | [W] missing
- CRUD operations: [X] target | [Y] complete | [Z] missing
```

---

## Completion Condition

- Every target route has been checked against existing inventory
- Every target interaction has been verified for wiring status
- Every CRUD operation has been checked for completeness
- Gap counts are accurate and documented
- `.ultimate-sdlc/council-state/development/ui-audit-report.md` exists and is complete

---

## Next Step

```
## Phase 3 Complete: Gaps Identified

**Route gaps**: [Z] missing, [W] incomplete out of [X] target
**Interaction gaps**: [Z] unwired, [W] missing out of [X] target
**CRUD gaps**: [Z] missing out of [X] target

Gap analysis saved to: .ultimate-sdlc/council-state/development/ui-audit-report.md

Next step: Run /dev-ui-audit-plan to create the implementation plan.
```

---
