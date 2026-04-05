---
name: sdlc-dev-ui-audit-scan
description: |
  "Phase 1 of UI Audit: Inventory existing UI — scan routes, components, interactive elements, and design system tokens. Produces existing inventory artifact."
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


# /dev-ui-audit-scan - Phase 1: Inventory Existing UI

## Lens / Skills / Model
**Lens**: `[UX]` + `[Quality]` | **Model**: Claude Opus 4
> Apply RARV cycle, session protocol per `council-development.md`

## Prerequisites

- Project has existing frontend code (pages, components exist)
- Feature specs exist in `specs/features/`

If prerequisites not met:
```
Phase 1 requires existing frontend code and feature specs.
Ensure the project has pages/components and specs/features/ is populated.
```

---

## Workflow

### Step 1.1: Scan Existing Routes

1. Read the project's router configuration (React Router, Next.js pages/app directory, Vue Router, etc.)
2. Extract every declared route with its component
3. Build an **Existing Route Tree** showing what currently exists

### Step 1.2: Scan Existing Components

1. Search frontend directories for all component files
2. For each page component: identify interactive elements (buttons, forms, modals, menus, dropdowns)
3. For each interactive element: check if it has a handler (onClick, onSubmit, onChange) with actual logic (not empty functions)
4. Build an **Existing Interaction Inventory** documenting what's wired vs. what's rendered but non-functional

### Step 1.3: Scan Existing Design System

1. Check for `design-system.md` or equivalent (tailwind.config, theme file, CSS variables)
2. Extract current color palette, typography, spacing values
3. Document the existing design system (even if informal)

---

## Output Artifact

Save to `.ultimate-sdlc/council-state/development/ui-audit-existing-inventory.md`:

```markdown
# UI Audit — Existing Inventory

## Existing Route Tree
| Route | Component | Renders Content? | Notes |
|-------|-----------|-----------------|-------|
| /path | ComponentName | Yes/No/Partial | ... |

## Existing Interaction Inventory
| Page | Element | Type | Has Handler? | Handler Has Logic? | Status |
|------|---------|------|-------------|-------------------|--------|
| /path | Button text | button/form/modal/etc | Yes/No | Yes/No/Empty | WIRED/UNWIRED/MISSING |

## Existing Design System
- **Color palette**: [extracted values]
- **Typography**: [fonts, sizes, weights]
- **Spacing**: [spacing scale]
- **Source**: [file path(s)]

## Summary
- Routes: [N] total
- Interactive elements: [N] total ([X] wired, [Y] unwired, [Z] missing handlers)
- Design system: [formal/informal/none]
```

---

## Completion Condition

- All router configurations have been scanned
- Every page component has been inventoried for interactive elements
- Each interactive element has a wired/unwired/missing status
- Design system tokens are documented
- `.ultimate-sdlc/council-state/development/ui-audit-existing-inventory.md` exists and is complete

---

## Next Step

```
## Phase 1 Complete: Existing UI Inventoried

**Routes found**: [N]
**Interactive elements**: [N] ([X] wired, [Y] unwired)
**Design system**: [status]

Inventory saved to: .ultimate-sdlc/council-state/development/ui-audit-existing-inventory.md

Next step: Run /dev-ui-audit-target to build the target state.
```

---
