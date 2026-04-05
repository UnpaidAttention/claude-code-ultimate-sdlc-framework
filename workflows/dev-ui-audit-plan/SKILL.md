---
name: dev-ui-audit-plan
description: |
  "Phase 4 of UI Audit: Create prioritized implementation plan for closing UI gaps. Presents plan to user for review before implementation proceeds."
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
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# /dev-ui-audit-plan - Phase 4: Gap Implementation Plan

## Lens / Skills / Model
**Lens**: `[UX]` + `[Quality]` | **Model**: Claude Opus 4
> Apply RARV cycle, session protocol per `council-development.md`

## Prerequisites

- Phase 3 complete: `.antigravity/council-state/development/ui-audit-report.md` exists

If prerequisites not met:
```
Phase 4 requires the gap analysis from Phase 3.
Run /dev-ui-audit-gaps first to identify gaps.
```

---

## Workflow

### Step 4.1: Categorize Gaps by Priority

Read `.antigravity/council-state/development/ui-audit-report.md` and organize gaps into implementation priorities:

**Priority 1: Missing Routes** — Create pages that don't exist. These are structural gaps.

**Priority 2: Unwired Components** — Connect existing visual elements to functionality. The UI exists but does nothing.

**Priority 3: Incomplete Pages** — Add missing content to existing shells. The page exists but is empty or partial.

### Step 4.2: Build Implementation Plan

For each gap, define a specific implementation task with dependencies.

### Step 4.3: Present to User

Display the plan and **wait for user approval** before proceeding. The user may reorder, remove, or modify items.

---

## Output Artifact

Save to `.antigravity/council-state/development/ui-audit-plan.md`:

```markdown
# UI Gap Implementation Plan

## Priority 1: Missing Routes (create pages that don't exist)
| # | Route | What to Build | Depends On | Status |
|---|-------|---------------|-----------|--------|
| 1 | /path | [Description of page and its functionality] | [Dependencies] | PENDING |

## Priority 2: Unwired Components (connect existing elements to functionality)
| # | Page | Element | What to Build | Depends On | Status |
|---|------|---------|---------------|-----------|--------|
| 1 | /path | [Element] | [What needs to be wired: modal, form, API call, etc.] | [Dependencies] | PENDING |

## Priority 3: Incomplete Pages (add missing content to existing shells)
| # | Page | What's Missing | What to Build | Status |
|---|------|---------------|---------------|--------|
| 1 | /path | [What's missing] | [What to build] | PENDING |

## Effort Estimate
- Missing routes: [N] pages to create
- Unwired components: [N] elements to connect
- Incomplete pages: [N] pages to fill
- Total implementation items: [N]
```

---

## User Review Gate

After saving the plan, present it to the user:

```
## UI Gap Implementation Plan Ready for Review

**Missing routes**: [N] pages to create
**Unwired components**: [N] elements to connect
**Incomplete pages**: [N] pages to fill
**Total items**: [N]

Plan saved to: .antigravity/council-state/development/ui-audit-plan.md

Please review the plan. You can:
- Approve as-is → proceed with /dev-ui-audit-fix
- Reorder priorities
- Remove items you don't want implemented
- Add items that were missed

Awaiting your approval before implementation begins.
```

**Do NOT proceed to Phase 5 without explicit user approval.**

---

## Completion Condition

- Every gap from the audit report has a corresponding implementation task
- Tasks are ordered by priority with dependencies identified
- Effort estimate is provided
- Plan has been presented to user
- `.antigravity/council-state/development/ui-audit-plan.md` exists and is complete

---

## Next Step

After user approves:
```
Next step: Run /dev-ui-audit-fix to implement the approved plan.
```

---
