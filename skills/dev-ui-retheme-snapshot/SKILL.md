---
name: sdlc-dev-ui-retheme-snapshot
description: |
  "Phase 1 of UI Retheme: Document current theme — extract design system tokens, screenshot every major page, create git safety tag. Produces current-theme-snapshot artifact."
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
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/frontend-design/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/ui-ux-pro-max/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/component-patterns/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


# /dev-ui-retheme-snapshot - Phase 1: Document Current Theme

## Lens / Skills / Model
**Lens**: `[UX]` + `[Quality]` | **Model**: claude-opus-4-6
> Apply RARV cycle, session protocol per `council-development.md`

## Prerequisites

- UI is functionally complete (all routes, interactions, CRUD operations work)
- Tests pass (baseline for regression detection)
- Git working tree is clean

If prerequisites not met:
```
Phase 1 requires a functionally complete UI with passing tests and clean git state.
Run /dev-ui-audit first if there are functional gaps.
```

---

## Workflow

### Step 1.1: Extract Current Design System

1. Read `design-system.md` if it exists
2. If no formal design system: scan the codebase and extract:
   - CSS variables (custom properties from `:root` or theme files)
   - Tailwind config values (colors, fonts, spacing, extend blocks)
   - Font families, sizes, weights, and line heights
   - Color values (primary, secondary, accent, semantic, neutrals)
   - Spacing scale
   - Border radii, shadows, transitions
   - Component patterns (button styles, card styles, input styles)
3. Document all extracted values with their source file paths

### Step 1.2: Screenshot Current State

If Playwright MCP or screenshot tool available:
- Capture every major page at desktop (1920px) and mobile (375px)
- Save to `.ultimate-sdlc/council-state/development/retheme-before/`

If no screenshot tool available:
- Note that manual screenshots are recommended before proceeding
- List every major page URL/route for user reference

This creates the "before" reference for Phase 5 comparison.

### Step 1.3: Create Baseline Safety Tag

```bash
git add -A && git commit -m "Pre-retheme: baseline checkpoint"
git tag pre-retheme-baseline
```

This tag provides a one-command recovery path: `git checkout pre-retheme-baseline`

---

## Output Artifact

Save to `.ultimate-sdlc/council-state/development/current-theme-snapshot.md`:

```markdown
# Current Theme Snapshot

## Design System Source
- **Source file(s)**: [file paths]
- **Framework**: [Tailwind / CSS Variables / Styled Components / etc.]

## Color Palette
| Token | Value | Usage |
|-------|-------|-------|
| --primary | #XXXXXX | Primary actions, links |
| --secondary | #XXXXXX | Secondary elements |
| ... | ... | ... |

## Typography
| Role | Font Family | Size | Weight | Line Height |
|------|-------------|------|--------|-------------|
| Display | ... | ... | ... | ... |
| Body | ... | ... | ... | ... |
| Mono | ... | ... | ... | ... |

## Spacing Scale
[Extracted spacing values]

## Borders & Shadows
| Token | Value |
|-------|-------|
| border-radius | ... |
| shadow-sm | ... |
| shadow-md | ... |

## Component Patterns
### Buttons
[Current button styles — colors, radii, padding, variants]

### Cards
[Current card styles]

### Inputs
[Current input styles]

### Navigation
[Current nav styles]

## Screenshots
- Location: .ultimate-sdlc/council-state/development/retheme-before/
- Pages captured: [list]
- Captured at: [timestamp]

## Safety Tag
- Tag: `pre-retheme-baseline`
- Recovery: `git checkout pre-retheme-baseline`
```

---

## Completion Condition

- All design tokens and visual properties have been extracted and documented
- Screenshots captured (or manual screenshot instruction provided)
- Git tag `pre-retheme-baseline` created
- `.ultimate-sdlc/council-state/development/current-theme-snapshot.md` exists and is complete

---

## Next Step

```
## Phase 1 Complete: Current Theme Documented

**Design system**: [formal/informal/extracted]
**Colors**: [N] tokens documented
**Fonts**: [font names]
**Screenshots**: [N] pages captured
**Safety tag**: pre-retheme-baseline

Snapshot saved to: .ultimate-sdlc/council-state/development/current-theme-snapshot.md

Next step: Run /dev-ui-retheme-direction to research the new theme direction.
```

---

## Agent Invocations

### Agent: frontend-specialist
Invoke via Agent tool with `subagent_type: "sdlc-frontend-specialist"`:
- **Provide**: Frontend codebase, CSS/Tailwind configuration, component directories, design-system.md (if exists)
- **Request**: Document the current theme comprehensively — extract all design tokens (colors, typography, spacing, borders, shadows), identify component style patterns, and catalog source file paths
- **Apply**: Integrate extracted theme data into the current-theme-snapshot artifact

---
