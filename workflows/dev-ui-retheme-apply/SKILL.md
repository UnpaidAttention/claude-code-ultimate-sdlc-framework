---
name: dev-ui-retheme-apply
description: |
  "Phase 4 of UI Retheme: Implement approved design system — update tokens, global styles, components, layouts, and remaining hardcoded values in dependency order. Verifies build after each step."
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


# /dev-ui-retheme-apply - Phase 4: Implement Theme

## Lens / Skills / Model
**Lens**: `[UX]` + `[Quality]` | **Model**: claude-opus-4-6
> Apply RARV cycle, session protocol per `council-development.md`

## Prerequisites

- Phase 1 complete: `.antigravity/council-state/development/current-theme-snapshot.md` exists
- Phase 2 complete: `.antigravity/council-state/development/retheme-direction.md` exists
- Phase 3 complete: `.antigravity/council-state/development/retheme-proposal.md` exists with status APPROVED
- User has explicitly approved the design system proposal

If prerequisites not met:
```
Phase 4 requires an approved design system proposal.
Run /dev-ui-retheme-propose first and get user approval.
```

If proposal status is not APPROVED:
```
The design system proposal has not been approved.
Run /dev-ui-retheme-propose to present for user approval.
Do NOT implement without explicit user approval.
```

---

## Workflow

Execute the theme change in strict dependency order to minimize intermediate breakage. After each step, verify the build succeeds before moving to the next.

**Critical rule**: Preserve ALL functionality. Change ONLY visual treatment. No component restructuring, no route changes, no interaction modifications.

### Step 4.1: Update Design Tokens (foundation)

1. Read the approved proposal from `.antigravity/council-state/development/retheme-proposal.md`
2. Update `design-system.md` with the new theme (or create if it does not exist)
3. Update CSS variables / Tailwind config / theme configuration files:
   - Color tokens (all palette values)
   - Typography tokens (font families, size scale, weights)
   - Spacing tokens (if density is changing)
   - Border radius and shadow tokens
4. Update font imports (Google Fonts link, @font-face declarations, package imports)
5. Verify build succeeds:
```bash
npm run build
```

If build fails: fix token-level issues before proceeding. Do NOT continue with a broken build.

### Step 4.2: Update Global Styles

1. Update base styles (body background, default text color, link colors)
2. Update typography styles (headings h1-h6, body text, captions, labels)
3. Update global spacing if density changed
4. Update scrollbar styling, selection colors, focus outlines if theme affects them
5. Verify build succeeds:
```bash
npm run build
```

### Step 4.3: Update Component Library

1. Update shared/reusable components (Button, Input, Card, Modal, Dialog, Dropdown, Badge, etc.)
2. Update component variants (primary, secondary, ghost, outline, destructive)
3. Update component states (hover, focus, active, disabled, loading)
4. Update component-specific spacing, borders, shadows to match new tokens
5. Verify build succeeds and run component tests:
```bash
npm run build && npm test
```

### Step 4.4: Update Page Layouts

1. Update page layouts that the new theme changes (navigation style, sidebar, card layouts, headers, footers)
2. Preserve content structure and functionality — change only visual treatment
3. Update any page-specific color overrides to use new tokens
4. Verify all routes still render correctly:
```bash
npm run build
```

### Step 4.5: Eliminate Remaining Hardcoded Values

1. Search for any remaining old color hex values in frontend code:
   - Grep for old color values from `current-theme-snapshot.md`
   - Grep for hardcoded hex values that should use tokens
   - Grep for old font family names
   - Grep for old spacing values (if spacing changed)
2. Replace all found values with new design tokens
3. Verify zero old theme values remain in frontend code:
```bash
npm run build && npm test
```

### Step 4.6: Final Build Verification

Run full build and test suite:
```bash
npm run build && npm test && npm run lint
```

All must pass before proceeding to verification phase.

---

## Output

No separate artifact file — the output is the code changes themselves. The implementation modifies:
- Design token files (CSS variables, Tailwind config, theme files)
- Global style files
- Component files (shared/reusable components)
- Page layout files
- Any files with hardcoded old theme values

---

## Completion Condition

- All design tokens updated to new values
- Global styles reflect new theme
- All shared components use new tokens
- All page layouts use new tokens
- Zero old theme values remain in frontend code (verified by grep)
- Build succeeds cleanly (`npm run build`)
- All tests pass (`npm test`)
- Linter passes (`npm run lint`)
- No functionality was broken — only visual treatment changed

---

## Next Step

```
## Phase 4 Complete: Theme Implemented

**Files modified**: [N]
**Design tokens**: Updated
**Components**: Updated
**Pages**: Updated
**Old values remaining**: 0
**Build**: Passing
**Tests**: Passing

Next step: Run /dev-ui-retheme-verify for visual verification and consistency check.
```

---
