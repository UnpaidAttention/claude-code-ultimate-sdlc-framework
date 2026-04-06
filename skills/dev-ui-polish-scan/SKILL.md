---
name: sdlc-dev-ui-polish-scan
description: |
  Phase 1 of UI Polish — systematically scan all frontend code for AI-generated design patterns (slop) across typography, color, layout, components, and copy.
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
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/systematic-evaluation/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


# /dev-ui-polish-scan - Phase 1: Anti-Slop Scan

---

## Lens / Skills / Model
**Lens**: `[UX]` + `[Quality]` | **Model**: claude-opus-4-6
> Apply RARV cycle, session protocol per `council-development.md`

## Prerequisites

- UI is functionally complete (all routes render, all interactions wired)
- `/dev-ui-verify` has passed OR `/dev-ui-audit` has completed

If UI is not functionally complete:
```
UI must be functionally complete before design polish.
Run /dev-ui-audit to find and fix completeness gaps first.
```

---

## Instructions

Systematically scan ALL frontend code for AI-generated design patterns. Record every finding with file paths and evidence.

### Step 1: Typography Scan

Search all CSS, Tailwind classes, and font declarations for:

```
- [ ] Inter font family → SLOP (most common AI default)
- [ ] Arial, Helvetica → SLOP (generic system fonts as primary)
- [ ] Roboto → SLOP (Google's default, overused by AI)
- [ ] system-ui as sole font stack → SLOP (no distinctive typography)
- [ ] sans-serif as sole fallback with no named font → SLOP
- [ ] Only one font family used (no display/body distinction) → SLOP
```

Search targets: `*.css`, `*.scss`, `*.tsx`, `*.ts`, `tailwind.config.*`, `globals.css`, font import statements, `@font-face` declarations, CSS `font-family` properties, Tailwind `fontFamily` config.

### Step 2: Color Scan

Search all color values for:

```
- [ ] Purple/violet as primary color (#7C3AED, #8B5CF6, purple-*) → SLOP
- [ ] Blue primary buttons (#3B82F6, blue-500) → SLOP (AI's "safe" choice)
- [ ] Gradient backgrounds (especially purple→blue, pink→purple) → SLOP
- [ ] Deep cyan / fintech blue as primary → SLOP (common AI "alternative" to purple)
- [ ] Hardcoded hex values not in design system → potential SLOP
- [ ] Only 2-3 colors used across entire app → SLOP (insufficient palette)
```

Search targets: CSS custom properties (`--color-*`), Tailwind theme colors, inline `style` attributes, `bg-*` / `text-*` classes, gradient declarations.

### Step 3: Layout Scan

Search page structures for:

```
- [ ] Standard Hero Split (left text / right image) on landing page → SLOP
- [ ] Bento grids as default layout → SLOP
- [ ] Centered-everything layout (all content center-aligned) → SLOP
- [ ] Evenly-spaced card grids (uniform size, uniform gap) → SLOP
- [ ] Generic three-column feature comparison → SLOP
- [ ] "Big heading + subtitle + CTA button" as only hero pattern → SLOP
```

Search targets: Page-level components, route files, layout components, hero sections, feature sections, landing pages.

### Step 4: Component Style Scan

Search component implementations for:

```
- [ ] Rounded corners everywhere (no sharp edges anywhere) → SLOP
- [ ] Gradient-only backgrounds (no textures, no solid colors) → SLOP
- [ ] Glassmorphism on every card → SLOP (AI's idea of "premium")
- [ ] Dark background + neon glow accents → SLOP
- [ ] All buttons same size and style → SLOP (no hierarchy)
- [ ] No hover state differentiation → SLOP
- [ ] Icons from mixed libraries → SLOP
- [ ] Emojis used as icons → SLOP
```

Search targets: Shared component files, button variants, card components, `backdrop-blur`, `shadow-*` classes, `rounded-*` classes, icon imports.

### Step 5: Copy Scan

Search text content for:

```
- [ ] "Orchestrate", "Empower", "Elevate", "Supercharge" → SLOP copy
- [ ] "Your [noun] journey starts here" → SLOP
- [ ] "Seamlessly", "Effortlessly", "Revolutionize" → SLOP
- [ ] Placeholder lorem ipsum still present → defect
```

Search targets: All `*.tsx`, `*.jsx` files containing visible text, `*.json` i18n files, content configuration files.

### Step 6: Compile Raw Results

For each finding, record:
- Category (typography / color / layout / component / copy)
- File path(s) where found
- Exact match (the code, class, or text found)
- Evidence (line numbers, screenshots if available)

---

## Output

Save raw scan results to `.ultimate-sdlc/council-state/development/ui-slop-scan.md`:

```markdown
# Anti-Slop Scan — Raw Results

## Scan Date: [date]
## Files Scanned: [count]

## Typography Findings
[List each finding with file paths and evidence]

## Color Findings
[List each finding with file paths and evidence]

## Layout Findings
[List each finding with file paths and evidence]

## Component Style Findings
[List each finding with file paths and evidence]

## Copy Findings
[List each finding with file paths and evidence]

## Totals
- Typography: [N]
- Color: [N]
- Layout: [N]
- Component: [N]
- Copy: [N]
- **Total raw findings**: [N]
```

---

## Completion Condition

- All 5 scan categories executed against the full frontend codebase
- Every finding recorded with file paths and evidence
- Raw results saved to `.ultimate-sdlc/council-state/development/ui-slop-scan.md`

---

## Next Step

```
## Phase 1 Complete: Anti-Slop Scan Finished

**Findings recorded**: [N] total across 5 categories
**Raw results saved to**: .ultimate-sdlc/council-state/development/ui-slop-scan.md

**Next step**: Run `/dev-ui-polish-report` to generate the structured slop report from raw scan results.
```

---

## Agent Invocations

### Agent: frontend-specialist
Invoke via Agent tool with `subagent_type: "sdlc-frontend-specialist"`:
- **Provide**: Full frontend codebase file paths, CSS/Tailwind configuration, component directories
- **Request**: Scan for AI-generated slop patterns across all 5 categories (typography, color, layout, component style, copy) — record every finding with file paths and evidence
- **Apply**: Compile raw findings into the scan artifact for structured reporting in Phase 2

---
