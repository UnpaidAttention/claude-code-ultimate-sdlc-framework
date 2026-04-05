---
name: dev-ui-polish
description: |
  Orchestrate the 6-phase anti-slop audit and design remediation process. Auto-detects current phase and routes to first incomplete phase.
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
- Read `~/.claude/skills/antigravity/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# /dev-ui-polish - Anti-Slop Audit & Design Remediation (Orchestrator)

## Purpose

Orchestrate the full UI polish process: scan for AI-generated design slop, report findings, research alternatives, plan remediation, implement changes, and verify consistency. Each phase is independently invocable.

**Use when**: The UI is functionally complete but looks like generic AI output — default fonts, purple gradients, bento grids, identical component styling to every other AI-generated app.

**Prerequisite**: UI must be functionally complete. Run `/dev-ui-audit` first if gaps exist. This workflow changes visual design, NOT functionality.

---

## Lens / Skills / Model
**Lens**: `[UX]` + `[Quality]` | **Model**: claude-opus-4-6
> Apply RARV cycle, session protocol per `council-development.md`

## Prerequisites

- UI is functionally complete (all routes render, all interactions wired, all CRUD operations work)
- `/dev-ui-verify` has passed OR `/dev-ui-audit` has completed
- `design-system.md` exists (even if informal)

If UI is not functionally complete:
```
UI must be functionally complete before design polish.
Run /dev-ui-audit to find and fix completeness gaps first.
Design polish changes visuals — it requires working code to polish.
```

---

## Phase Overview

| Phase | Command | Description | Output |
|-------|---------|-------------|--------|
| 1 | `/dev-ui-polish-scan` | Anti-Slop Scan | `.antigravity/council-state/development/ui-slop-scan.md` |
| 2 | `/dev-ui-polish-report` | Generate Slop Report | `.antigravity/council-state/development/ui-slop-report.md` |
| 3 | `/dev-ui-polish-research` | Research Design Alternatives | `.antigravity/council-state/development/ui-polish-alternatives.md` |
| 4 | `/dev-ui-polish-plan` | Remediation Plan (HARD STOP for approval) | `.antigravity/council-state/development/ui-polish-plan.md` |
| 5 | `/dev-ui-polish-apply` | Implement Remediation | Modified source files |
| 6 | `/dev-ui-polish-verify` | Design Consistency Verification | `.antigravity/council-state/development/ui-polish-report.md` (final) |

---

## Execution Model — ONE Phase Per Invocation

**CRITICAL: Execute exactly ONE phase, then STOP and return control to the user.**

Do NOT cascade into the next phase after completing one. When a phase finishes:
1. Display the phase's completion summary
2. Tell the user the exact command to run next
3. STOP — do not detect the next incomplete phase and run it automatically

The user controls when each phase begins by invoking this orchestrator again or running the phase command directly.

---

## Workflow: Auto-Detect and Route

### Step 1: Detect Current Phase

Check for phase artifacts to determine progress:

1. If `.antigravity/council-state/development/ui-slop-scan.md` does NOT exist → Route to **Phase 1**: `/dev-ui-polish-scan`
2. If `.antigravity/council-state/development/ui-slop-report.md` does NOT exist → Route to **Phase 2**: `/dev-ui-polish-report`
3. If `.antigravity/council-state/development/ui-polish-alternatives.md` does NOT exist → Route to **Phase 3**: `/dev-ui-polish-research`
4. If `.antigravity/council-state/development/ui-polish-plan.md` does NOT exist → Route to **Phase 4**: `/dev-ui-polish-plan`
5. If `.antigravity/council-state/development/ui-polish-plan.md` exists but does NOT contain `## Status: APPROVED` → Route to **Phase 4** (awaiting approval)
6. If `.antigravity/council-state/development/ui-polish-plan.md` does NOT contain `## Implementation Status: COMPLETE` → Route to **Phase 5**: `/dev-ui-polish-apply`
7. If `.antigravity/council-state/development/ui-polish-report.md` does NOT contain `## Final Verification: PASS` → Route to **Phase 6**: `/dev-ui-polish-verify`
8. If `.antigravity/council-state/development/ui-polish-report.md` contains `## Final Verification: PASS` → **Complete**

### Step 2: Display Status and Route

Display current state:

```
## UI Polish Progress

Phase 1 — Anti-Slop Scan:        [COMPLETE / PENDING]
Phase 2 — Slop Report:           [COMPLETE / PENDING]
Phase 3 — Research Alternatives:  [COMPLETE / PENDING]
Phase 4 — Remediation Plan:      [COMPLETE / PENDING / AWAITING APPROVAL]
Phase 5 — Implement Remediation: [COMPLETE / PENDING]
Phase 6 — Verification:          [COMPLETE / PENDING]

→ Next: /dev-ui-polish-[phase] — [description]
```

### Step 3: Execute Next Phase

Run the detected next phase command. After it completes, display its completion summary and the next command to run, then STOP. Do NOT automatically proceed to the following phase.

---

## Completion Condition

- Phase 6 verification passes with 0 slop findings
- All design tokens updated and consistent
- WCAG AA contrast maintained
- All existing functionality still works (tests pass)
- No mixed old/new styles across the application

---

## Summary Template

```
## UI Polish Complete

**Slop findings identified**: [N]
**Findings remediated**: [N]/[N]
**Design changes**:
- Typography: [old] → [new]
- Primary color: [old] → [new]
- Layout changes: [N] pages
- Component style changes: [N] components
- Copy changes: [N] text items

All functionality preserved — only visual design changed.
```

---
