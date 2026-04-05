---
name: dev-ui-retheme
description: |
  Orchestrate a complete UI retheme across 5 phases — snapshot current theme, research direction, propose design system, implement changes, verify results. Auto-resumes from last incomplete phase.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /dev-ui-retheme - UI Theme Makeover (Orchestrator)

## Purpose

Apply a completely new visual theme to an existing, functionally complete UI. Changes the look and feel — colors, typography, spacing, borders, shadows, motion, layout treatments — while preserving all components, routes, interactions, and functionality.

**Use when**: The UI works correctly but you want a different visual identity. New brand direction, different aesthetic, evolved design language — without rebuilding any functionality.

**Key difference from other UI workflows**:
- `/dev-ui-audit` — finds and fills functional gaps (missing buttons, pages, interactions)
- `/dev-ui-polish` — removes AI slop patterns and replaces with better alternatives
- `/dev-ui-retheme` — complete visual transformation to a new design direction
- `/dev-ui-redesign` — archives everything and starts from scratch

---

## Lens / Skills / Model
**Lens**: `[UX]` + `[Quality]` | **Model**: claude-opus-4-6
> Apply RARV cycle, session protocol per `council-development.md`

## Phases

| # | Phase | Command | Artifact | Description |
|---|-------|---------|----------|-------------|
| 1 | Document Current Theme | `/dev-ui-retheme-snapshot` | `.ultimate-sdlc/council-state/development/current-theme-snapshot.md` | Extract design system, screenshot pages, create safety tag |
| 2 | Research New Direction | `/dev-ui-retheme-direction` | `.ultimate-sdlc/council-state/development/retheme-direction.md` | Present options, get user input, research direction |
| 3 | Propose New Design System | `/dev-ui-retheme-propose` | `.ultimate-sdlc/council-state/development/retheme-proposal.md` | Complete design system proposal with before/after comparison |
| 4 | Implement Theme | `/dev-ui-retheme-apply` | Code changes | Update tokens, styles, components, layouts in dependency order |
| 5 | Visual Verification | `/dev-ui-retheme-verify` | `.ultimate-sdlc/council-state/development/retheme-verification.md` | Build, test, screenshot comparison, consistency check |

---

## Execution Model — ONE Phase Per Invocation

**CRITICAL: Execute exactly ONE phase, then STOP and return control to the user.**

Do NOT cascade into the next phase after completing one. When a phase finishes:
1. Display the phase's completion summary
2. Tell the user the exact command to run next
3. STOP — do not detect the next incomplete phase and run it automatically

The user controls when each phase begins by invoking this orchestrator again or running the phase command directly.

---

## Auto-Resume Detection

Check for phase artifacts in order and route to the first incomplete phase:

1. If `.ultimate-sdlc/council-state/development/current-theme-snapshot.md` does NOT exist → run `/dev-ui-retheme-snapshot`
2. If `.ultimate-sdlc/council-state/development/retheme-direction.md` does NOT exist → run `/dev-ui-retheme-direction`
3. If `.ultimate-sdlc/council-state/development/retheme-proposal.md` does NOT exist → run `/dev-ui-retheme-propose`
4. If `.ultimate-sdlc/council-state/development/retheme-verification.md` does NOT exist:
   - If old theme values still present in frontend code → run `/dev-ui-retheme-apply`
   - If implementation appears complete → run `/dev-ui-retheme-verify`
5. If all artifacts exist → retheme complete, display summary

After determining the next phase: execute ONLY that phase, display its completion summary, then STOP.

---

## Prerequisites

- UI is functionally complete (all routes, interactions, CRUD operations work)
- Tests pass (baseline for regression detection)
- Git working tree is clean

If UI has functional gaps:
```
UI must be functionally complete before retheme.
Run /dev-ui-audit first to fill gaps, then /dev-ui-retheme.
Theme changes are visual — they require complete, working code to restyle.
```

---

## Completion Condition

- New design system is documented in `design-system.md`
- All frontend code uses new design tokens (0 old values remaining)
- All tests pass (no functionality regressions)
- Visual consistency check passes (no mixed old/new styles)
- Anti-Slop Scan passes on new theme
- Before/After screenshots available for comparison

---
