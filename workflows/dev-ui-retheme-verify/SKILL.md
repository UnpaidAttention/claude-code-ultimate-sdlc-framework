---
name: sdlc-dev-ui-retheme-verify
description: |
  "Phase 5 of UI Retheme: Visual verification — build and test, screenshot comparison, consistency check, anti-slop audit, WCAG contrast verification. Produces retheme-verification artifact."
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /dev-ui-retheme-verify - Phase 5: Visual Verification

## Lens / Skills / Model
**Lens**: `[UX]` + `[Quality]` | **Model**: claude-opus-4-6
> Apply RARV cycle, session protocol per `council-development.md`

## Prerequisites

- Phase 1-4 complete:
  - `.ultimate-sdlc/council-state/development/current-theme-snapshot.md` exists
  - `.ultimate-sdlc/council-state/development/retheme-direction.md` exists
  - `.ultimate-sdlc/council-state/development/retheme-proposal.md` exists with status APPROVED
  - Theme implementation complete (build and tests pass)

If prerequisites not met:
```
Phase 5 requires theme implementation to be complete.
Run /dev-ui-retheme-apply first.
```

---

## Workflow

### Step 5.1: Build and Test

Run the full verification suite:

```bash
npm run build   # Verify clean build
npm test        # Verify no regressions — all tests must pass
npm run lint    # Verify no style issues
```

If any fail: fix issues before proceeding. All three must pass cleanly.

### Step 5.2: Screenshot Comparison

If Playwright MCP or screenshot tool available:
1. Capture every major page at desktop (1920px) and mobile (375px)
2. Save to `.ultimate-sdlc/council-state/development/retheme-after/`
3. Compare against `.ultimate-sdlc/council-state/development/retheme-before/`:
   - Changes should be visual only
   - Layout structure should be preserved (unless layout changes were part of the approved proposal)
   - No pages should be broken or missing content

If no screenshot tool available:
- List every major route and note that manual visual comparison is recommended
- Document expected visual changes per page

### Step 5.3: Consistency Check

Verify complete theme consistency across the entire application:

- [ ] ALL colors reference new design tokens (no old hex values, no hardcoded colors)
- [ ] ALL text uses new typography (no pages with old fonts)
- [ ] ALL components use new styles (no mixed old/new button styles, card styles, etc.)
- [ ] ALL pages are visually cohesive (consistent theme across the entire app)
- [ ] No functionality was broken (all tests pass, all interactions work)
- [ ] All interactive states work (hover, focus, active, disabled)

For each check, grep the frontend codebase to verify:
```bash
# Search for old color values (from current-theme-snapshot.md)
# Search for old font family names
# Search for hardcoded hex values that should be tokens
```

### Step 5.4: WCAG AA Contrast Verification

Verify contrast ratios meet WCAG AA standards with the new colors:

| Combination | Required Ratio | Actual Ratio | Status |
|-------------|---------------|--------------|--------|
| Body text on page background | 4.5:1 | X.X:1 | PASS/FAIL |
| Body text on card/surface | 4.5:1 | X.X:1 | PASS/FAIL |
| Secondary text on page background | 4.5:1 | X.X:1 | PASS/FAIL |
| Link text on page background | 4.5:1 | X.X:1 | PASS/FAIL |
| Button text on primary | 4.5:1 | X.X:1 | PASS/FAIL |
| Large headings on page background | 3:1 | X.X:1 | PASS/FAIL |
| Placeholder text on input background | 4.5:1 | X.X:1 | PASS/FAIL |

If any combination fails: adjust the affected token in the design system and re-verify.

### Step 5.5: Anti-Slop Verification

Run the Anti-Slop Scan methodology from `/dev-ui-polish` Phase 1 against the new theme. The new theme must NOT introduce slop patterns:

- No default AI fonts (Inter, Roboto as sole choice without rationale)
- No purple gradient defaults
- No generic card/bento grid patterns that don't serve the content
- No excessive rounded corners or shadows that add no value
- Typography has intentional hierarchy (not uniform sizing)

### Step 5.6: Update Design System

Update `design-system.md` with the final new theme as the canonical design system. This is the source of truth going forward.

---

## Output Artifact

Save to `.ultimate-sdlc/council-state/development/retheme-verification.md`:

```markdown
# Retheme Verification Report

## Build & Test Results
- **Build**: PASS / FAIL
- **Tests**: PASS / FAIL ([N] passing, [N] failing)
- **Lint**: PASS / FAIL

## Screenshot Comparison
- **Before**: .ultimate-sdlc/council-state/development/retheme-before/
- **After**: .ultimate-sdlc/council-state/development/retheme-after/
- **Pages compared**: [N]
- **Visual-only changes**: YES / NO (if NO, list structural changes)

## Consistency Check
- [ ] All colors use new tokens: PASS / FAIL
- [ ] All text uses new typography: PASS / FAIL
- [ ] All components use new styles: PASS / FAIL
- [ ] All pages visually cohesive: PASS / FAIL
- [ ] All functionality preserved: PASS / FAIL
- [ ] All interactive states work: PASS / FAIL
- **Old theme values remaining**: [0 / list of remaining values]

## WCAG AA Contrast
| Combination | Ratio | Status |
|-------------|-------|--------|
| [text on bg combinations] | X.X:1 | PASS/FAIL |
- **Overall**: PASS / FAIL

## Anti-Slop Scan
- **Slop patterns found**: [0 / list]
- **Overall**: PASS / FAIL

## Summary

**Previous theme**: [description]
**New theme**: [name/description]

**Changes applied**:
- Typography: [old fonts] → [new fonts]
- Primary color: [old] → [new]
- [Other key changes]

**Files modified**: [N]
**Tests**: All passing
**Functionality**: All preserved — visual only changes

**Recovery**: git checkout pre-retheme-baseline

**design-system.md**: Updated with final new theme
```

---

## Completion Condition

- Build, tests, and lint all pass
- Before/After screenshots captured (or manual comparison documented)
- Consistency check passes: 0 old theme values remaining, no mixed styles
- WCAG AA contrast verification passes for all text/background combinations
- Anti-Slop Scan passes: new theme does not introduce slop patterns
- `design-system.md` updated with final new theme
- `.ultimate-sdlc/council-state/development/retheme-verification.md` exists and is complete

---

## Completion Summary

```
## Theme Makeover Complete

**Previous theme**: [description]
**New theme**: [name/description]

**Changes applied**:
- Typography: [old fonts] → [new fonts]
- Primary color: [old] → [new]
- [Other key changes]

**Verification**:
- Build: PASS
- Tests: All passing
- Lint: PASS
- Consistency: 0 old values remaining
- WCAG AA: All combinations pass
- Anti-Slop: No slop patterns

**Files modified**: [N]
**Functionality**: All preserved — visual only changes

**Recovery**: git checkout pre-retheme-baseline

Before/After screenshots: .ultimate-sdlc/council-state/development/retheme-before/ and retheme-after/
Verification report: .ultimate-sdlc/council-state/development/retheme-verification.md
```

---
