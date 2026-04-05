---
name: dev-ui-polish-verify
description: |
  Phase 6 of UI Polish — re-run the anti-slop scan to verify 0 findings remain, verify design token consistency, WCAG AA contrast, and no mixed old/new styles.
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
- Read `~/.claude/skills/antigravity/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/systematic-evaluation/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# /dev-ui-polish-verify - Phase 6: Design Consistency Verification

---

## Lens / Skills / Model
**Lens**: `[UX]` + `[Quality]` | **Model**: claude-opus-4-6
> Apply RARV cycle, session protocol per `council-development.md`

## Prerequisites

- `.antigravity/council-state/development/ui-polish-plan.md` must contain `## Implementation Status: COMPLETE` (Phase 5 complete)

If prerequisite not met:
```
Remediation implementation not complete.
Run /dev-ui-polish-apply to implement the approved plan first.
Phase 6 verifies the results of Phase 5 implementation.
```

---

## Instructions

### Step 1: Re-Run Anti-Slop Scan

Execute the full scan from Phase 1 against the updated codebase. This is a pass/fail gate.

**Typography scan**: Search for any remaining flagged font families (Inter, Arial, Roboto, system-ui as sole stack).

**Color scan**: Search for any remaining flagged color values (purple primary, blue-500 buttons, gradient backgrounds, hardcoded hex values not in design tokens).

**Layout scan**: Search for any remaining flagged layout patterns (hero splits, bento grids, centered-everything).

**Component style scan**: Search for any remaining flagged component patterns (rounded-everything, glassmorphism, dark+neon, mixed icon libraries).

**Copy scan**: Search for any remaining flagged copy patterns (buzzwords, generic CTAs, lorem ipsum).

**Result**: Count total remaining findings. Target: **0 findings**.

### Step 2: Design Token Consistency

Verify all colors in the codebase reference design tokens:

1. Search for hardcoded hex values (`#[0-9a-fA-F]{3,8}`) in component files
2. Search for hardcoded `rgb()` / `hsl()` values in component files
3. Search for Tailwind color classes that bypass the theme (e.g., `bg-blue-500` instead of `bg-primary`)
4. Every color in components must trace back to a CSS variable or Tailwind theme token

**Result**: List any hardcoded colors found. Target: **0 hardcoded colors** (except in the token definition files themselves).

### Step 3: Typography Consistency

Verify typography uses the new font pairing consistently:

1. All font-family declarations reference the design system fonts
2. No mixed old/new font references
3. Display font used for headings, body font used for body text (no cross-contamination)
4. Font weights are intentional (not all `font-bold` or all `font-normal`)

**Result**: List any inconsistencies. Target: **0 typography inconsistencies**.

### Step 4: WCAG AA Contrast Verification

For every text/background color combination:

1. Normal text (< 18px): contrast ratio >= 4.5:1
2. Large text (>= 18px bold or >= 24px): contrast ratio >= 3:1
3. UI components and graphical objects: contrast ratio >= 3:1
4. Check both light and dark modes if applicable

**Result**: List any failing contrast pairs. Target: **0 contrast failures**.

### Step 5: Mixed Style Detection

Verify no remnants of old styles coexist with new styles:

1. Search for old primary color values anywhere in the codebase
2. Search for old font family names in any CSS or config
3. Search for old component patterns (e.g., glassmorphism if it was removed)
4. Verify every page uses the updated design system consistently

**Result**: List any mixed old/new style instances. Target: **0 mixed styles**.

### Step 6: Build and Test Verification

1. Run full build — must succeed with no warnings related to styling
2. Run existing tests — all must pass (this workflow changes visuals, not functionality)
3. If screenshot tools available: capture final state at 3 breakpoints for key pages

---

## Output

Save final verification report to `.antigravity/council-state/development/ui-polish-report.md`:

```markdown
# UI Polish — Final Verification Report

## Verification Date: [date]
## Source: Post-remediation codebase

## Anti-Slop Re-Scan
- Typography findings: [N] (target: 0)
- Color findings: [N] (target: 0)
- Layout findings: [N] (target: 0)
- Component style findings: [N] (target: 0)
- Copy findings: [N] (target: 0)
- **Total remaining findings**: [N]

## Design Token Consistency
- Hardcoded colors in components: [N] (target: 0)
- [List any found]

## Typography Consistency
- Font inconsistencies: [N] (target: 0)
- [List any found]

## WCAG AA Contrast
- Failing contrast pairs: [N] (target: 0)
- [List any found with ratios]

## Mixed Style Detection
- Old/new style remnants: [N] (target: 0)
- [List any found]

## Build & Tests
- Build: PASS / FAIL
- Tests: PASS / FAIL ([N] passed, [N] failed)

## Final Verification: [PASS / FAIL]
```

**PASS criteria**: 0 slop findings, 0 hardcoded colors, 0 typography inconsistencies, 0 contrast failures, 0 mixed styles, build passes, tests pass.

**If FAIL**: List all remaining issues and display the following to the user:

```
## Phase 6 Verification: FAIL

**Remaining issues**: [N] total
[List each remaining issue with category and severity]

These issues must be fixed before polish is complete.

**Next step**: Run `/dev-ui-polish-apply` for targeted fixes, then re-run `/dev-ui-polish-verify`.
```

---

## Completion Condition

- `## Final Verification: PASS` written to the report
- 0 slop findings on re-scan
- All design tokens consistent
- WCAG AA contrast verified
- No mixed old/new styles
- Build succeeds, all tests pass

---

## Process Complete

When verification passes, the UI polish process is complete. **You MUST display the following to the user**:

```
## UI Polish Complete

**Slop findings identified**: [N from Phase 2]
**Findings remediated**: [N]/[N]
**Verification**: PASS — 0 remaining findings

Design changes applied:
- Typography: [old] → [new]
- Primary color: [old] → [new]
- Layout changes: [N] pages
- Component style changes: [N] components
- Copy changes: [N] text items

All functionality preserved — only visual design changed.
```

---
