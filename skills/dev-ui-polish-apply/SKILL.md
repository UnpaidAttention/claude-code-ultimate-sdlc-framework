---
name: sdlc-dev-ui-polish-apply
description: |
  Phase 5 of UI Polish — implement the approved remediation plan in order (typography, colors, components, layouts, copy), verifying build after each category.
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
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


# /dev-ui-polish-apply - Phase 5: Implement Remediation

---

## Lens / Skills / Model
**Lens**: `[UX]` + `[Quality]` | **Model**: claude-opus-4-6
> Apply RARV cycle, session protocol per `council-development.md`

## Prerequisites

- `.ultimate-sdlc/council-state/development/ui-polish-plan.md` must exist AND contain `## Status: APPROVED`

If prerequisite not met:
```
Approved remediation plan not found.
If plan exists but is not approved: present to user via /dev-ui-polish-plan.
If plan does not exist: run /dev-ui-polish-plan first.
Phase 5 requires explicit user approval before modifying source files.
```

---

## Instructions

Execute the remediation plan in strict order. Each category must be completed and verified before moving to the next.

### Step 1: Typography (First)

Typography cascades everywhere, so apply it first.

1. Update font imports (Google Fonts link, `@font-face`, or package install)
2. Update CSS variables (`--font-display`, `--font-body`, `--font-mono`)
3. Update Tailwind config (`fontFamily` settings)
4. Update any hardcoded `font-family` values in components
5. Verify: all text renders with new fonts, no FOUT/FOIT issues

**After typography changes:**
- Run build — must succeed
- Visually verify: text renders correctly at all sizes
- Check: no components overflow due to different font metrics

### Step 2: Colors (Second)

Colors apply through tokens, so update the source of truth first.

1. Update CSS custom properties in `globals.css` (or equivalent)
2. Update Tailwind theme colors if used
3. Update any hardcoded hex/rgb values in components per the plan
4. Remove gradient declarations flagged in the plan
5. Verify: contrast ratios meet WCAG AA (4.5:1 for normal text, 3:1 for large text)

**After color changes:**
- Run build — must succeed
- Visually verify: no invisible text, no broken contrast
- Check: dark mode still works if applicable

### Step 3: Component Styles (Third)

1. Update border radius strategy per the plan (e.g., sharp cards + rounded buttons)
2. Remove glassmorphism / backdrop-blur where flagged
3. Update elevation / shadow system
4. Standardize button hierarchy (primary, secondary, ghost variants)
5. Add hover state differentiation where missing
6. Standardize icon library (remove mixed imports)

**After component changes:**
- Run build — must succeed
- Visually verify: components look intentional, not default
- Check: interactive states (hover, focus, active) all work

### Step 4: Layouts (Fourth)

1. Restructure flagged page layouts per the plan
2. Replace hero sections with planned alternatives
3. Replace bento grids with content-appropriate layouts
4. Adjust responsive breakpoints if structure changed

**After layout changes:**
- Run build — must succeed
- Visually verify at 3 breakpoints: 375x812 (mobile), 768x1024 (tablet), 1920x1080 (desktop)
- Check: no overlapping elements, no broken scroll behavior

### Step 5: Copy (Last)

1. Replace flagged buzzwords and generic phrases per the plan
2. Update CTAs with action-specific language
3. Remove any remaining lorem ipsum
4. Verify: text fits containers (no overflow from longer replacements)

**After copy changes:**
- Run build — must succeed
- Verify: no truncated text, no broken layouts from text length changes

### Step 6: Screenshot Evidence (If Tools Available)

If Playwright MCP or browser tools are available:
1. Capture screenshots at 3 breakpoints (375x812, 768x1024, 1920x1080) for each modified page
2. Save to `.ultimate-sdlc/council-state/development/ui-polish-screenshots/`
3. Name format: `[page-name]-[breakpoint]-after.png`

If tools not available: note in output that manual visual verification was performed.

---

## Output

Update `.ultimate-sdlc/council-state/development/ui-polish-plan.md` with implementation status:

```markdown
## Implementation Log

### Typography — [COMPLETE / FAILED]
- Files modified: [list]
- Build: PASS
- Visual check: PASS

### Colors — [COMPLETE / FAILED]
- Files modified: [list]
- Build: PASS
- Contrast check: PASS

### Component Styles — [COMPLETE / FAILED]
- Files modified: [list]
- Build: PASS
- Visual check: PASS

### Layouts — [COMPLETE / FAILED]
- Files modified: [list]
- Build: PASS
- Responsive check: PASS (375 / 768 / 1920)

### Copy — [COMPLETE / FAILED]
- Files modified: [list]
- Build: PASS
- Text fit check: PASS

## Implementation Status: COMPLETE
```

---

## Completion Condition

- All 5 categories implemented in order
- Build succeeds after each category
- No visual regressions introduced
- Implementation log appended to the plan file

---

## Next Step

```
## Phase 5 Complete: Remediation Implemented

**Typography**: [COMPLETE/FAILED]
**Colors**: [COMPLETE/FAILED]
**Component Styles**: [COMPLETE/FAILED]
**Layouts**: [COMPLETE/FAILED]
**Copy**: [COMPLETE/FAILED]

Implementation log appended to: .ultimate-sdlc/council-state/development/ui-polish-plan.md

**Next step**: Run `/dev-ui-polish-verify` to run the final design consistency verification.
```

---

## Agent Invocations

### Agent: frontend-specialist
Invoke via Agent tool with `subagent_type: "sdlc-frontend-specialist"`:
- **Provide**: Approved remediation plan, current design token files, component file paths, build configuration
- **Request**: Implement remediation in dependency order (typography, colors, components, layouts, copy) — update tokens, global styles, component files, and verify build after each category
- **Apply**: Update implementation log in the plan file after each category completes

### Agent: code-reviewer
Invoke via Agent tool with `subagent_type: "sdlc-code-reviewer"`:
- **Provide**: All modified files from remediation implementation
- **Request**: Review changes for design token consistency, no hardcoded values, WCAG AA contrast compliance, and no functional regressions
- **Apply**: Address review findings before marking each category as COMPLETE

---
