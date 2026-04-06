---
name: sdlc-dev-ui-audit-target
description: |
  "Phase 2 of UI Audit: Build the target state — define what SHOULD exist based on feature specs. Produces target route tree, interaction maps, and CRUD matrix."
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/component-patterns/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /dev-ui-audit-target - Phase 2: Build Target State

## Lens / Skills / Model
**Lens**: `[UX]` + `[Quality]` | **Model**: Claude Opus 4
> Apply RARV cycle, session protocol per `council-development.md`

## Prerequisites

- Phase 1 complete: `.ultimate-sdlc/council-state/development/ui-audit-existing-inventory.md` exists
- Feature specs exist in `specs/features/`
- Deep-dives exist in `specs/deep-dives/`

If prerequisites not met:
```
Phase 2 requires the existing inventory from Phase 1.
Run /dev-ui-audit-scan first to inventory existing UI.
```

---

## Workflow

### Step 2.1: Build Target Route Tree

Using feature specs and deep-dives, build the COMPLETE Route Tree per `/dev-ui-design-plan` Step 3a methodology — recursive decomposition to leaf level. Every page, sub-page, tab, wizard step.

### Step 2.2: Build Target Feature Interaction Maps

For every feature, create Feature Interaction Maps per `/dev-ui-design-plan` Step 5 — every user action traced trigger→completion. Include CRUD Completeness Matrix for all data entities.

### Step 2.3: Build Target Interactive Element Inventory

Complete inventory of every button, form, modal, menu, dropdown, filter, sort control per `/dev-ui-design-plan` Step 5b.

---

## Output Artifact

Save to `.ultimate-sdlc/council-state/development/ui-audit-target-state.md`:

```markdown
# UI Audit — Target State

## Target Route Tree
| Route | Purpose | Parent Feature | Required Components |
|-------|---------|---------------|-------------------|
| /path | Description | FEAT-XXX | ComponentA, ComponentB |

## Feature Interaction Maps

### FEAT-XXX: [Feature Name]
| User Action | Trigger Element | Expected Behavior | Completion State |
|------------|----------------|-------------------|-----------------|
| [action] | [button/link/etc] | [what happens] | [end state] |

[Repeat for every feature]

## CRUD Completeness Matrix
| Entity | Create | Read List | Read Detail | Update | Delete | Search | Filter | Sort |
|--------|--------|-----------|-------------|--------|--------|--------|--------|------|
| [Entity] | Required/N/A | Required/N/A | ... | ... | ... | ... | ... | ... |

## Target Interactive Element Inventory
| Page | Element | Type | Required Behavior |
|------|---------|------|------------------|
| /path | Element text | button/form/modal/etc | [full expected behavior] |

## Summary
- Target routes: [N]
- Target interactions: [N]
- Target CRUD operations: [N]
- Data entities: [N]
```

---

## Completion Condition

- Every feature spec has a corresponding set of target routes
- Every feature has a complete interaction map (trigger→completion)
- CRUD matrix covers all data entities
- Interactive element inventory includes every expected control
- `.ultimate-sdlc/council-state/development/ui-audit-target-state.md` exists and is complete

---

## Next Step

```
## Phase 2 Complete: Target State Defined

**Target routes**: [N]
**Target interactions**: [N]
**Data entities with CRUD**: [N]

Target state saved to: .ultimate-sdlc/council-state/development/ui-audit-target-state.md

Next step: Run /dev-ui-audit-gaps to compare existing vs. target.
```

---
