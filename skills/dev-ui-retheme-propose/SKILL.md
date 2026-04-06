---
name: sdlc-dev-ui-retheme-propose
description: |
  "Phase 3 of UI Retheme: Propose complete new design system — color palette, typography, spacing, component styles, before/after comparison. Requires explicit user approval before implementation."
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
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


# /dev-ui-retheme-propose - Phase 3: Propose New Design System

## Lens / Skills / Model
**Lens**: `[UX]` + `[Quality]` | **Model**: claude-opus-4-6
> Apply RARV cycle, session protocol per `council-development.md`

## Prerequisites

- Phase 1 complete: `.ultimate-sdlc/council-state/development/current-theme-snapshot.md` exists
- Phase 2 complete: `.ultimate-sdlc/council-state/development/retheme-direction.md` exists

If prerequisites not met:
```
Phase 3 requires the theme snapshot and direction research.
Run /dev-ui-retheme-snapshot and /dev-ui-retheme-direction first.
```

---

## Workflow

### Step 3.1: Review Inputs

Read and synthesize:
- `.ultimate-sdlc/council-state/development/current-theme-snapshot.md` — what exists now
- `.ultimate-sdlc/council-state/development/retheme-direction.md` — where we're going
- `design-system.md` if it exists — formal design system structure

### Step 3.2: Create Complete New Design System

Following the direction established in Phase 2, create a complete design system covering:

**Color Palette**:
- Primary color with hover, active, light, dark variants
- Secondary and accent colors with variants
- Semantic colors (success, warning, error, info) with variants
- Neutral scale (background, surface, border, text levels)
- Verify all text/background combinations meet WCAG AA contrast (4.5:1 for normal text, 3:1 for large text)

**Typography**:
- Display font — name, rationale, fallback stack
- Body font — name, rationale, fallback stack
- Monospace font — name, fallback stack
- Complete size scale (xs through 4xl or equivalent)
- Weight scale, line heights, letter spacing

**Spacing**:
- Updated spacing system if density is changing
- Component padding and margin conventions

**Borders & Shadows**:
- Border radius scale
- Shadow scale (sm, md, lg, xl)
- Border colors and widths

**Component Style Direction**:
- Buttons: treatment (sharp/rounded, solid/outline, gradient/flat), states
- Cards: treatment (bordered/elevated, padding, radius)
- Inputs: treatment (bordered/underline, focus states, label style)
- Navigation: treatment (sidebar/top, color scheme, active indicators)

### Step 3.3: Build Before/After Comparison

Create a comparison table for every major design element:

| Element | Current | Proposed | Change Rationale |
|---------|---------|----------|------------------|
| Primary color | [old hex] | [new hex] | [why] |
| Body font | [old font] | [new font] | [why] |
| Card style | [old desc] | [new desc] | [why] |
| Button radius | [old value] | [new value] | [why] |
| Shadow style | [old] | [new] | [why] |
| ... | ... | ... | ... |

### Step 3.4: Present for User Approval

Present the complete proposal to the user with the before/after comparison.

```
## New Design System Proposal: [Theme Name]

[Visual direction summary — 2-3 sentences]

[Before/After comparison table]

[Key highlights — the 3-5 most impactful changes]

Please review the complete proposal in:
.ultimate-sdlc/council-state/development/retheme-proposal.md

**Do you approve this design system for implementation?**
- Approve as-is → I'll proceed with /dev-ui-retheme-apply
- Approve with changes → Tell me what to adjust
- Reject → Tell me what direction to take instead
```

**HARD STOP** — Do NOT proceed to implementation without explicit user approval. If the user requests changes, revise the proposal and present again.

---

## Output Artifact

Save to `.ultimate-sdlc/council-state/development/retheme-proposal.md`:

```markdown
# Proposed New Theme — [Theme Name]

## Status: [PENDING APPROVAL / APPROVED / APPROVED WITH CHANGES]

## Visual Direction
[2-3 sentences describing the new aesthetic and why it fits the product]

## Color Palette

### Primary: [name] — [hex value]
| Variant | Value | Usage |
|---------|-------|-------|
| primary | #XXXXXX | Primary actions, links |
| primary-hover | #XXXXXX | Hover state |
| primary-active | #XXXXXX | Active/pressed state |
| primary-light | #XXXXXX | Backgrounds, badges |
| primary-dark | #XXXXXX | Dark mode, emphasis |

### Secondary: [name] — [hex value]
[Same variant structure]

### Accent: [name] — [hex value]
[Same variant structure]

### Semantic Colors
| Role | Default | Light | Dark |
|------|---------|-------|------|
| Success | #XXXXXX | #XXXXXX | #XXXXXX |
| Warning | #XXXXXX | #XXXXXX | #XXXXXX |
| Error | #XXXXXX | #XXXXXX | #XXXXXX |
| Info | #XXXXXX | #XXXXXX | #XXXXXX |

### Neutrals
| Token | Value | Usage |
|-------|-------|-------|
| bg-primary | #XXXXXX | Page background |
| bg-surface | #XXXXXX | Card/panel background |
| border | #XXXXXX | Default borders |
| text-primary | #XXXXXX | Main text |
| text-secondary | #XXXXXX | Secondary text |
| text-muted | #XXXXXX | Hints, placeholders |

## Typography

### Display: [font name]
- **Rationale**: [why this font]
- **Fallback**: [fallback stack]
- **Source**: [Google Fonts / local / etc.]

### Body: [font name]
- **Rationale**: [why this font]
- **Fallback**: [fallback stack]
- **Source**: [Google Fonts / local / etc.]

### Mono: [font name]
- **Fallback**: [fallback stack]

### Size Scale
| Token | Size | Line Height | Usage |
|-------|------|-------------|-------|
| text-xs | ... | ... | Captions, labels |
| text-sm | ... | ... | Secondary text |
| text-base | ... | ... | Body text |
| text-lg | ... | ... | Subheadings |
| text-xl | ... | ... | Section headings |
| text-2xl | ... | ... | Page headings |
| text-3xl | ... | ... | Hero text |
| text-4xl | ... | ... | Display text |

## Spacing
[Updated spacing system or "No change from current"]

## Borders & Shadows
| Token | Value |
|-------|-------|
| radius-sm | ... |
| radius-md | ... |
| radius-lg | ... |
| radius-full | ... |
| shadow-sm | ... |
| shadow-md | ... |
| shadow-lg | ... |
| shadow-xl | ... |

## Component Style Direction

### Buttons
[Treatment description — shape, fill, hover behavior, variants]

### Cards
[Treatment description — elevation vs border, padding, radius]

### Inputs
[Treatment description — border style, focus state, label position]

### Navigation
[Treatment description — layout, color scheme, active indicators]

## Before / After Comparison
| Element | Current | Proposed | Change Rationale |
|---------|---------|----------|------------------|
| ... | ... | ... | ... |

## Contrast Verification
| Combination | Ratio | WCAG AA |
|-------------|-------|---------|
| text-primary on bg-primary | X.X:1 | PASS/FAIL |
| text-secondary on bg-primary | X.X:1 | PASS/FAIL |
| primary on bg-primary | X.X:1 | PASS/FAIL |
| ... | ... | ... |
```

---

## Completion Condition

- Complete design system proposal covers all categories (colors, typography, spacing, borders, shadows, component styles)
- Before/After comparison table is complete
- WCAG AA contrast has been verified for all text/background combinations
- User has been presented the proposal
- User has explicitly approved (status updated to APPROVED)
- `.ultimate-sdlc/council-state/development/retheme-proposal.md` exists and is complete

---

## Next Step

```
## Phase 3 Complete: Design System Approved

**Theme**: [theme name]
**Key changes**: [top 3-4 changes]
**User approval**: [APPROVED / APPROVED WITH CHANGES]

Proposal saved to: .ultimate-sdlc/council-state/development/retheme-proposal.md

Next step: Run /dev-ui-retheme-apply to implement the new theme.
```

---

## Agent Invocations

### Agent: frontend-specialist
Invoke via Agent tool with `subagent_type: "sdlc-frontend-specialist"`:
- **Provide**: Current theme snapshot, retheme direction, design system requirements (color palette, typography, spacing, component styles)
- **Request**: Propose a complete new design system — define all token values, verify WCAG AA contrast for every text/background combination, build before/after comparison table, assess implementation feasibility
- **Apply**: Integrate the proposed design system into the retheme-proposal artifact for user approval

---
