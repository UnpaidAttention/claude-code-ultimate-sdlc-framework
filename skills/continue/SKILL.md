---
name: sdlc-continue
description: |
  Auto-advance through framework phases. Reads state, determines next step, executes it. Pauses at gates and council transitions.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /continue - Auto-Advance Framework

---

## Lens / Skills / Model
**Lens**: Dynamic (per target workflow) | **Model**: Claude Sonnet 4
> Conductor workflow. Apply RARV cycle, session protocols per `~/.claude/skills/ultimate-sdlc/rules/the active council rules file`

## Arguments
| Argument | Required | Description |
|----------|----------|-------------|
| (none) | — | Session auto-detects state |

---

## Purpose

Automatically advance through the framework without requiring manual workflow invocation. Reads project state, determines the next step, and executes it — pausing only at:
- **Gate failures** (must fix before continuing)
- **Council transitions** (user confirms before entering next council)
- **Context budget limits** (saves state, instructs user to re-run)

---

## Workflow

### Step 1: Read Project State

Read these files to determine current position:

1. `.ultimate-sdlc/project-context.md` — Active council, current phase, status
2. `.ultimate-sdlc/council-state/{active-council}/current-state.md` — Detailed phase progress
3. `.ultimate-sdlc/council-state/{active-council}/WORKING-MEMORY.md` — Session context
4. `.ultimate-sdlc/progress.md` — Recent activity (last 3 entries)
5. **Development only**: `.ultimate-sdlc/council-state/development/run-tracker.md` — Multi-run progress

If `.ultimate-sdlc/project-context.md` does not exist:
→ Check if `.ultimate-sdlc/project-manifest.md` exists:
  - **If manifest exists but no .ultimate-sdlc/project-context.md**: "No active cycle. Run `/new-cycle` to start a new development cycle."
  - **If neither exists**: "Project not initialized. Run `/init` to start a new project, or `/adopt` to onboard an existing codebase."
→ STOP.

---

### Step 2: Determine Current Position

From the state files, extract:
- **Active Council**: Planning / Development / Audit / Validation
- **Current Phase/Wave/Track**: The identifier (e.g., "Phase 3", "Wave 2", "T3")
- **Status**: in_progress / complete / blocked
- **Cycle Type**: Full / Feature / Patch / Maintenance / Improvement (from .ultimate-sdlc/project-context.md `Cycle Information` section)
- **Active Councils**: Which councils are active for this cycle type
- **Last completed step**: What was the most recent phase/wave/track marked complete?

If status is **blocked**:
→ Display the blocker from .ultimate-sdlc/project-context.md
→ STOP. Instruct user to resolve the blocker first.

---

### Step 3: Determine Next Workflow

Use the navigation table below to map current position → next workflow.

**Planning Council:**

| Current Phase | Next Workflow |
|---------------|---------------|
| Phase 1 | `/planning-phase-1-5` |
| Phase 1.5 | `/planning-gate-1-5` |
| Gate 1.5 Passed | `/planning-phase-2` |
| Phase 2 | `/planning-feature-deep-dive` → (check batch mode) |
| Phase 2.5 (batch incomplete) | `/planning-feature-deep-dive` (next batch) |
| Phase 2.5 (all batches done) | `/planning-phase-3` → (check batch mode) |
| Phase 3 (batch incomplete) | `/planning-phase-3` (next batch) |
| Phase 3 (all batches done) | `/planning-phase-3-5` → (check batch mode) |
| Phase 3.5 (batch incomplete) | `/planning-phase-3-5` (next batch) |
| Phase 3.5 (all batches done) | `/planning-gate-3-5` |
| Gate 3.5 Passed | `/planning-supporting-specs` |
| Phases 4-7 | `/planning-phase-8` |
| Phase 8 | `/planning-gate-8` |
| Gate 8 Passed | → **Council Transition** (see below) |

**Development Council:**

| Current Wave | Next Workflow |
|--------------|---------------|
| Wave 0 | `/dev-wave-1` |
| Wave 1 | `/dev-wave-2` |
| Wave 2 | `/dev-wave-3` |
| Wave 3 | `/dev-wave-4` |
| Wave 4 | `/dev-gate-i4` |
| Gate I4 Passed | `/dev-wave5-start` |
| Wave 5 | `/dev-wave-6` |
| Wave 6 | `/dev-gate-i8` |
| Gate I8 Passed | → Check run tracker (see below) |

**Audit Council:**

| Current Phase | Next Workflow |
|---------------|---------------|
| T1 | `/audit-t2` |
| T2 | `/audit-t3` |
| T3 | `/audit-gate-t3` |
| Gate T3 Passed | `/audit-t4` |
| T4 | `/audit-t5` |
| T5 | `/audit-a1` |
| A1 | `/audit-a2` |
| A2 | `/audit-gate-a2` |
| Gate A2 Passed | `/audit-a3` |
| A3 | `/audit-gate-a3` |
| Gate A3 Passed | `/audit-e1` |
| E1 | `/audit-e2` |
| E2 | `/audit-e3` |
| E3 Complete | → **Council Transition** (see below) |

**Validation Council:**

| Current Phase | Next Workflow |
|---------------|---------------|
| V1 | `/validate-v2` |
| V2 | `/validate-v3` |
| V3 | `/validate-v4` |
| V4 | `/validate-v5` |
| V5 | `/validate-gate-v5` |
| Gate V5 Passed | `/validate-c1` |
| C1 | `/validate-c2` |
| C2 | `/validate-c3` |
| C3 | `/validate-c4` |
| C4 | `/validate-gate-c4` |
| Gate C4 Passed | `/validate-p1` |
| P1 | `/validate-p2` |
| P2 | `/validate-p3` |
| P3 | `/validate-p4` |
| P4 | `/validate-gate-p4` |
| Gate P4 Passed | `/validate-e1` |
| E1 | `/validate-e2` |
| E2 | `/validate-e3` |
| E3 | `/validate-e4` |
| E4 | `/validate-gate-e4` |
| Gate E4 Passed | `/validate-s1` |
| S1 | `/validate-s2` |
| S2 | `/validate-gate-s2` |
| Gate S2 Passed | **RELEASE READY** |

---

### Step 3a: Gate Handling

If the next workflow is a **gate** (contains "gate" in the name):

1. **Read** the gate workflow file from `~/.claude/skills/ultimate-sdlc/workflows/`
2. **Execute** gate verification steps inline
3. **If PASS**: Update state files, continue to the next phase (loop back to Step 3)
4. **If FAIL**: STOP immediately. Display:
   ```
   ❌ GATE FAILED: [Gate Name]

   Failed Criteria:
   - [criterion 1]: [reason]
   - [criterion 2]: [reason]

   Fix the above issues, then run `/continue` to retry the gate.
   ```

---

### Step 3b: Council Transitions

At council boundaries, check the **Cycle Type** to determine the correct next council:

**Full / Feature Cycle Transitions:**

| From | To | Action |
|------|----|--------|
| Planning (Gate 8 passed) | Development | Display transition summary, instruct: "Run `/dev-start` to begin Development Council" |
| Development (all runs complete) | Audit | Display transition summary, instruct: "Run `/audit-start` to begin Audit Council" |
| Audit (E3 complete) | Validation | Display transition summary, instruct: "Run `/validate-start` to begin Validation Council" |
| Validation (Gate S2 passed) | Release | Display: "**CYCLE COMPLETE**. Run `/close-cycle` to archive this cycle, then `/new-cycle` for the next." |

**Patch / Maintenance Cycle Transitions** (Audit skipped):

| From | To | Action |
|------|----|--------|
| Planning complete | Development | Display transition summary, instruct: "Run `/dev-start` to begin Development Council" |
| Development (all runs complete) | Validation | Display transition summary, instruct: "Run `/validate-start` to begin Validation Council (Audit skipped for this cycle type)" |
| Validation (Gate S2 passed) | Release | Display: "**CYCLE COMPLETE**. Run `/close-cycle` to archive this cycle, then `/new-cycle` for the next." |

**Improvement Cycle Transitions:**

| From | To | Action |
|------|----|--------|
| Planning complete | Development | Display transition summary, instruct: "Run `/dev-start` to begin Development Council" |
| Development (all runs complete) | Audit | Display transition summary, instruct: "Run `/audit-start` to begin Audit Council (verify no regressions)" |
| Audit (E3 complete) | Validation | Display transition summary, instruct: "Run `/validate-start` to begin Validation Council" |
| Validation (Gate S2 passed) | Release | Display: "**CYCLE COMPLETE**. Run `/close-cycle` to archive this cycle, then `/new-cycle` for the next." |

**STOP** at council transitions. The user must explicitly invoke the next council's start workflow.

---

### Step 3c: Planning Batch Handling

When advancing through Phase 2.5, Phase 3, or Phase 3.5 in batch mode:

1. **Read** `.ultimate-sdlc/council-state/planning/planning-tracker.md`
2. **Check** if there are more batches remaining for the current phase
3. **If more batches**: Mark current batch complete in planning-tracker. Advance to next batch. Re-execute the same phase workflow (Phase 2.5, 3, or 3.5) for the next batch's features.
4. **If final batch of Phase 2.5**: Mark Phase 2.5 complete. Advance to Phase 3, reset to Batch 1.
5. **If final batch of Phase 3**: Mark Phase 3 complete. Advance to Phase 3.5, reset to Batch 1.
6. **If final batch of Phase 3.5**: Mark Phase 3.5 complete. Advance to Gate 3.5.
6. **Batch boundary = session boundary**: After each batch completes, STOP and notify user. Instruct user to run `/continue` to advance to the next batch (or the next phase if all batches are done).

**Note**: Phases 2.5, 3, and 3.5 can interleave per batch (see `council-planning.md § Planning Batch Mode`). If the planning-tracker shows all three phases run per batch, each batch completes deep-dives, then FEAT specs, then AIOUs before advancing to the next batch.

---

### Step 3d: Development Multi-Run Handling

After Development Gate I8 passes for a run:

1. **Read** `.ultimate-sdlc/council-state/development/run-tracker.md`
2. **Check** if there are more runs remaining
3. **If more runs**: Mark current run complete in run-tracker, advance to next run. Reset wave progress to Wave 0. Continue with `/dev-wave-1`.
4. **If final run**: Mark all runs complete. Run `/dev-complete` to generate handoff. Then → Council Transition to Audit.

---

### Step 4: Execute Next Workflow

Once the next workflow is determined:

1. **Read** the workflow file from `~/.claude/skills/ultimate-sdlc/workflows/{workflow-name}.md`
2. **Follow** its instructions:
   - Load the specified agent
   - Load the specified skills (from `skills_required` frontmatter)
   - Execute all steps in order
3. **When complete**: Update state files (.ultimate-sdlc/project-context.md, current-state.md, .ultimate-sdlc/progress.md)
4. **Loop** back to Step 3 to determine the next workflow

---

### Step 5: Session End

If approaching the context budget limit (estimated >80% consumed):

1. **Save** current state to:
   - `.ultimate-sdlc/council-state/{active-council}/WORKING-MEMORY.md` — What was being worked on
   - `.ultimate-sdlc/project-context.md` — Updated position
   - `.ultimate-sdlc/progress.md` — Session log entry
2. **Display**:
   ```
   ⚠️ Context budget approaching limit. State saved.

   **Progress this session:**
   - Started: [council] / [phase]
   - Reached: [council] / [phase]
   - Phases completed: [count]

   **To resume:** Run `/continue`
   ```
3. **STOP**.

---

## Arguments

| Argument | Effect |
|----------|--------|
| (none) | Auto-advance from current position |
| `--dry-run` | Show what would execute next without executing |
| `--to [phase]` | Advance until reaching the specified phase, then stop |

### Dry Run Mode

If `--dry-run` is passed:
1. Execute Steps 1-3 only
2. Display:
   ```
   Next workflow: /[workflow-name]
   Agent: [agent-name]
   Skills: [skill-list]
   ```
3. STOP without executing.

---

## Notes

- `/continue` is a **conductor**, not a replacement for individual workflows. It reads and executes existing workflow files.
- State files are the source of truth. `/continue` never skips steps — it always reads state first.
- Gates are always verified, never auto-passed.
- Council transitions always require user confirmation.
- The navigation table matches `status.md` — keep them in sync.
- **Cycle awareness**: `/continue` respects the cycle type from `.ultimate-sdlc/project-context.md`. For abbreviated cycle types (Patch, Maintenance), it skips inactive councils at transitions.
- After the final gate passes (Gate S2 or equivalent), `/continue` directs users to `/close-cycle` and `/new-cycle` instead of a terminal "RELEASE READY" state.

---
