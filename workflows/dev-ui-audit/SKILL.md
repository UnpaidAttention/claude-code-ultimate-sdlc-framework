---
name: dev-ui-audit
description: |
  Non-destructive audit of existing UI. Orchestrates 6 phases to identify missing routes, unwired components, incomplete interactions — then plans and builds only what's missing. Does NOT delete existing code.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/component-patterns/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /dev-ui-audit - UI Completeness Audit (Non-Destructive)

## Purpose

Audit an existing UI for completeness gaps — missing routes, unwired buttons, incomplete interactions, absent CRUD operations — without deleting or replacing any existing code. Builds only what's missing.

**Use when**: The project already has UI components but they're incomplete. Pages exist but sub-pages don't. Buttons render but do nothing. Features are partially implemented.

**Key difference from `/dev-ui-redesign`**: This workflow PRESERVES all existing UI code. It finds gaps and fills them. Redesign archives and rebuilds.

---

## Lens / Skills / Model
**Lens**: `[UX]` + `[Quality]` | **Model**: Claude Opus 4
> Apply RARV cycle, session protocol per `council-development.md`

## Phases

| # | Phase | Command | Artifact | Description |
|---|-------|---------|----------|-------------|
| 1 | Inventory Existing UI | `/dev-ui-audit-scan` | `.ultimate-sdlc/council-state/development/ui-audit-existing-inventory.md` | Scan routes, components, design system |
| 2 | Build Target State | `/dev-ui-audit-target` | `.ultimate-sdlc/council-state/development/ui-audit-target-state.md` | Define what SHOULD exist from specs |
| 3 | Gap Analysis | `/dev-ui-audit-gaps` | `.ultimate-sdlc/council-state/development/ui-audit-report.md` | Compare existing vs. target |
| 4 | Implementation Plan | `/dev-ui-audit-plan` | `.ultimate-sdlc/council-state/development/ui-audit-plan.md` | Prioritized plan for closing gaps |
| 5 | Implement Gaps | `/dev-ui-audit-fix` | Code changes, tests | Build missing routes, wire components |
| 6 | Verify Completeness | `/dev-ui-audit-verify` | `.ultimate-sdlc/council-state/development/ui-audit-verification.md` | Full UI-V verification pass |

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

1. If `.ultimate-sdlc/council-state/development/ui-audit-existing-inventory.md` does NOT exist → run `/dev-ui-audit-scan`
2. If `.ultimate-sdlc/council-state/development/ui-audit-target-state.md` does NOT exist → run `/dev-ui-audit-target`
3. If `.ultimate-sdlc/council-state/development/ui-audit-report.md` does NOT exist → run `/dev-ui-audit-gaps`
4. If `.ultimate-sdlc/council-state/development/ui-audit-plan.md` does NOT exist → run `/dev-ui-audit-plan`
5. If `.ultimate-sdlc/council-state/development/ui-audit-verification.md` does NOT exist:
   - If implementation items remain in `ui-audit-plan.md` → run `/dev-ui-audit-fix`
   - If all items complete → run `/dev-ui-audit-verify`
6. If all artifacts exist → audit complete, display summary

After determining the next phase: execute ONLY that phase, display its completion summary, then STOP.

---

## Prerequisites

- Project has existing frontend code (pages, components exist)
- Backend APIs are functional (Gate I4 passed or equivalent)
- Feature specs exist in `specs/features/` (the agent needs to know what SHOULD exist)

If prerequisites not met:
```
UI Audit requires existing frontend code and feature specs.
Ensure Gate I4 has passed and specs/features/ contains feature specifications.
```

---

## Completion Condition

- All target routes exist and render content
- All target interactions are fully wired (4 layers)
- All CRUD operations are complete for all entities
- UI-V verification passes (0 CRITICAL, 0 HIGH)
- No existing code was deleted (only new code added, existing code connected)

---

## Summary Template

```
## UI Audit Complete

**Gaps Found**: [N] routes, [N] unwired components, [N] incomplete pages
**Gaps Fixed**: [N]/[N]
**Existing Code Preserved**: All original components untouched
**New Code Added**: [N] files created, [N] files modified

Next step: Run /dev-ui-polish to audit design quality and remove AI slop.
```

---
