---
name: sdlc-audit-start
description: |
  Initialize or resume Audit Council session. Guides through 2 tracks (Testing, Audit) with gates at T3, A2, A3.
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
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/audit-orchestration/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/navigation-flow/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/test-case-design/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


# /audit-start - Begin Audit Council

## Arguments
| Argument | Required | Description |
|----------|----------|-------------|
| (none) | — | Session auto-detects state |

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per `council-audit.md`

### Additional Lens: `[UX]` — activated when `project_type` has frontend

**Additional Lens**: `[UX]` — activated when `project_type` has frontend

**Action Required**: Read and incorporate this agent's perspective for GUI/usability work.
---

## Purpose

Start or resume the Audit Council. This council systematically tests and audits software through 2 sequential tracks.

**NOTE:** This workflow IS the T1 (Inventory) phase. There is no separate `/audit-t1` command.
- Running `/audit-start` performs T1 inventory work (Step 5)
- After completing T1 in this workflow, run `/audit-t2` to continue

**Track Execution Order:**
1. Testing Track (T1→T2→T3→T4→T5) - This track first
2. Audit Track (A1→A2→A3) - After T5 complete
> **Note:** Enhancement activities (E1-E4) are in the Validation Council, not Audit.

---

## Pre-Conditions

- `.ultimate-sdlc/project-context.md` must exist (run `/init` first if not)
- Development Council must be complete (Gate I8 passed)
- `handoffs/development-handoff.md` must exist

---

## Workflow

### Step 1: Load Framework Context

Read these files:
- `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/framework-overview.md` - Understand the overall process
- `.reference/phase-guide.md` - Detailed track and phase information
- `.reference/skills-index.md` - Skills to load for each phase

### Step 2: Check Project State

Read `.ultimate-sdlc/project-context.md`:
- If `Active Council` is not "audit", check if transition is valid
- Verify Development Council (Gate I8) is marked complete
- Identify current track and phase
- Read `Cycle Information` section → extract **Cycle Type** and **Cycle Intent**

### Step 2a: Cycle-Scoped Audit

**Read the Cycle Type from `.ultimate-sdlc/project-context.md`.**

**Note**: Patch and Maintenance cycles skip the Audit Council entirely (routed by `/continue`). If this workflow is reached during a Patch/Maintenance cycle, display: "Patch/Maintenance cycles skip Audit. Run `/validate-start` instead."

For non-initial cycles that DO include Audit:

| Cycle Type | Audit Scope |
|------------|-------------|
| **Full** | Full audit of entire application |
| **Feature** | **Primary**: Audit new features thoroughly. **Secondary**: Regression check on existing features that interact with new ones. Do not re-audit unchanged, isolated features. |
| **Improvement** | **Primary**: Verify no regressions in existing functionality. **Secondary**: Verify refactored code meets same quality bar. Behavioral contracts from planning must be verified. |

**Add to `.ultimate-sdlc/council-state/audit/WORKING-MEMORY.md`**:
```
### Cycle Context
- Cycle Type: [type]
- Audit Scope: [FULL / NEW+REGRESSION / REGRESSION-ONLY per table above]
- Cycle Intent: [from .ultimate-sdlc/project-context.md]
```

**For Feature cycles**: When creating the feature inventory (T1), distinguish between:
- **New features** (from this cycle's planning handoff) — full audit
- **Existing features** (from `specs/feature-inventory.md`) — regression check only
- **Unchanged features** (no interaction with new code) — skip unless time permits

### Step 3: Verify Development Handoff

Check if `handoffs/development-handoff.md` exists:
- **If exists**: Parse it for implementation details
- **If not exists**: Stop with error: "Development handoff not found. Complete Development Council first with `/dev-start`."

### Step 4: Determine Mode

**If Track is Testing/T1 and status is "not started":**
→ NEW SESSION - Go to Step 5

**If any track is in progress:**
→ RESUME SESSION - Go to Step 6

### Agent: requirements
Invoke via Agent tool with `subagent_type: "sdlc-requirements"`:
- **Provide**: `specs/scope-lock.md`, `specs/feature-inventory.md`, `handoffs/development-handoff.md`
- **Request**: Verify feature inventory against scope-lock — identify any features missing from implementation or not in scope-lock
- **Apply**: Integrate findings into T1 feature catalogue before proceeding

### Step 5: New Session Setup

1. Update `.ultimate-sdlc/project-context.md`:
   - Set `Active Council`: audit
   - Set `Current Track`: Testing
   - Set `Current Phase`: T1
   - Set `Status`: in_progress

2. Parse `handoffs/development-handoff.md`:
   - Extract feature list
   - Extract component inventory
   - Extract test coverage info

3. Create `.ultimate-sdlc/council-state/audit/current-state.md`:
   - Initialize track statuses
   - Create empty defect log
   - Create empty enhancement register

4. Verify software accessibility:
   - Confirm application is accessible
   - Test login/authentication if required
   - Take screenshot of initial state
   - Document test environment details

5. Load T1 Skills (from `.reference/skills-index.md`):
   - Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/audit-orchestration/SKILL.md`
   - Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/navigation-flow/SKILL.md`

6. Update `.ultimate-sdlc/progress.md` with new session entry

7. Display welcome:
Use **Display Template** from `council-audit.md` to show: Audit Council - T1: Inventory

**After completing inventory work, update `.ultimate-sdlc/project-context.md`:** Set Phase: T2. Then run `/audit-t2` to continue.

> **T1 Complete marker**: The T1 phase ends when the feature catalogue is produced and displayed. Do not continue to T2 in the same session — run `/audit-t2` separately.

### Step 6: Resume Session

1. Read `.ultimate-sdlc/project-context.md` for current track and phase
2. Read `.ultimate-sdlc/progress.md` for last session notes
3. Read `.ultimate-sdlc/council-state/audit/current-state.md` for detailed state
4. Read `.ultimate-sdlc/council-state/audit/defect-log.md` for defects found
5. Load skills for current phase:
   - Look up phase in `.reference/skills-index.md`
   - Read each skill from `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/<skill-name>/SKILL.md`

6. Verify software accessibility:
   - Confirm application is still accessible
   - Verify test credentials work

7. Display status:
Use **Display Template** from `council-audit.md` to show: Audit Council - Resumed

---

## Track Navigation

### When T1 complete:
Run `/audit-t2` to continue to Functional Testing

### Direct Phase Entry
**Testing Track:**
- T2: `/audit-t2` (Functional Testing)
- T3: `/audit-t3` (GUI Analysis)
- Gate T3: `/audit-gate-t3` (Gate Verification)
- T4: `/audit-t4` (Integration Testing)
- T5: `/audit-t5` (Performance & Security)

**Audit Track:**
- A1: `/audit-a1` (Purpose Alignment)
- A2: `/audit-a2` (Completeness)
- Gate A2: `/audit-gate-a2` (Gate Verification)
- A3: `/audit-a3` (Quality Assessment)
- Gate A3: `/audit-gate-a3` (Gate Verification)

> Enhancement activities (E1-E4) are in the **Validation Council**, not Audit.

### To log defect:
Use `/audit-defect`

### To view status:
Use `/status`

---

## Track Quick Reference

**Execution Order:** Testing Track → Audit Track

### Testing Track (T1-T5) - FIRST
| Phase | Name | Key Output | Gate | Command |
|-------|------|------------|------|---------|
| T1 | Inventory | Feature catalogue | - | `/audit-start` (embedded) |
| T2 | Functional Testing | Test results | - | `/audit-t2` |
| T3 | GUI Analysis | Usability report | GATE | `/audit-t3` → `/audit-gate-t3` |
| T4 | Integration Testing | Integration results | - | `/audit-t4` |
| T5 | Performance & Security | Performance report | - | `/audit-t5` |

### Audit Track (A1-A3) - AFTER T5 COMPLETE
| Phase | Name | Key Output | Gate | Command |
|-------|------|------------|------|---------|
| A1 | Purpose Alignment | Alignment report | - | `/audit-a1` |
| A2 | Completeness | Gap analysis | GATE | `/audit-a2` → `/audit-gate-a2` |
| A3 | Quality Assessment | Quality scorecard | GATE | `/audit-a3` → `/audit-gate-a3` |

---

## Gate Criteria

See `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/gate-criteria.md` § Audit Council Gates for full criteria:
- **Gate T3** (after GUI Analysis)
- **Gate A2** (after Completeness)
- **Gate A3** (after Quality Assessment)

---

## Handoff

When all tracks complete:
- Generate `handoffs/audit-handoff.md`
- Update `.ultimate-sdlc/project-context.md` to mark Audit complete
- Instruct user to run `/validate-start`

---
