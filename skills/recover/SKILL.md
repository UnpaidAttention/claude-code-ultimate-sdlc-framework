---
name: sdlc-recover
description: |
  Recover from interrupted session. Diagnoses state, identifies incomplete work, and guides resumption.
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
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/state-diagnosis/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/conflict-resolution/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/recovery-procedures/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/session-management/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


# /recover - Session Recovery Workflow

---
## Lens Selection

**Agent Selection by Council** (read from .ultimate-sdlc/project-context.md `Active Council` field):

| Active Council | Lead Agent |
|----------------|------------|
| Planning | `[Requirements]` |
| Development | `[Architecture]` + `[Quality]` |
| Audit | `[UX]` + `[Quality]` |
| Validation | `[Requirements]` + `[Quality]` |
| (unknown/missing) | `[Requirements]` (fallback) |

**If .ultimate-sdlc/project-context.md is corrupted or unreadable**: Use `[Requirements]` lens as fallback.

---

## Purpose

Recover from an interrupted session by:
1. Diagnosing current state
2. Identifying incomplete work
3. Resolving state conflicts
4. Guiding safe resumption

---

## When to Use

- Session crashed or was forcibly terminated
- Context window overflowed mid-task
- User returns after extended break
- State files appear inconsistent
- WORKING-MEMORY.md shows in-progress tasks from previous session
- State files from a previous cycle appear to be interfering (run `/new-cycle` instead if starting fresh work)

---

## Recovery Steps

### Step 1: Gather State Information

Read all state files and compare:

Use **Display Template** from `the active council rules file` to show: State Diagnosis

### Step 2: Identify Conflicts

Check for inconsistencies:

| Check | Expected | Actual | Conflict? |
|-------|----------|--------|-----------|
| .ultimate-sdlc/project-context.md phase matches current-state.md | Same phase | [actual] | YES/NO |
| WORKING-MEMORY.md tasks align with phase | All tasks for current phase | [actual] | YES/NO |
| .ultimate-sdlc/progress.md last entry matches .ultimate-sdlc/project-context.md | Same phase | [actual] | YES/NO |
| In-progress tasks in WORKING-MEMORY.md | None (clean end) or few | [actual] | YES/NO |

### Step 3: Diagnose Interruption Type

Based on state analysis:

**Type A: Clean Exit**
- No in-progress tasks
- State files consistent
- Action: Resume normally with `/status`

**Type B: Mid-Task Interruption**
- In-progress tasks in WORKING-MEMORY.md
- State files consistent
- Action: Verify task completion, then resume

**Type C: State Conflict**
- State files inconsistent
- Action: Resolve conflict, then resume

**Type D: Unknown State**
- Files missing or corrupted
- Action: Manual recovery required

### Step 4: Execute Recovery

#### For Type A (Clean Exit)

Use **Display Template** from `the active council rules file` to show: Recovery: Clean Exit Detected

#### For Type B (Mid-Task Interruption)

Use **Display Template** from `the active council rules file` to show: Recovery: Interrupted Task Detected

#### For Type C (State Conflict)

Use **Display Template** from `the active council rules file` to show: Recovery: State Conflict Detected

#### For Type D (Unknown State)

Use **Display Template** from `the active council rules file` to show: Recovery: Unknown State - Manual Recovery Required

#### For Type E (Mid-Run Recovery)

When recovering in multi-run mode (run-tracker.md exists with multiple runs):

Use **Display Template** from `the active council rules file` to show: Recovery: Mid-Run Interruption Detected

### Step 5: Update State After Recovery

After recovery action determined:

1. **Update WORKING-MEMORY.md**:
   - Clear stale in-progress tasks
   - Add recovery note to Session Learnings

2. **Update .ultimate-sdlc/progress.md**:
   - Add recovery session entry
   - Document what was recovered

3. **Commit state**:
   ```bash
   git add .ultimate-sdlc/project-context.md .ultimate-sdlc/progress.md .ultimate-sdlc/council-state/
   git commit -m "recovery: restored state after interrupted session"
   ```

### Step 6: Resume Normal Operation

Use **Display Template** from `the active council rules file` to show: Recovery Complete — resuming normal operation.

Route to the appropriate next workflow based on the recovery type and current council state.

---

## Flow Diagram

```
/recover
  │
  ├─→ Gather state from all files
  │
  ├─→ Identify conflicts/interruption type
  │
  ├─→ Type A (clean): Resume normally
  │
  ├─→ Type B (mid-task): Verify completion, resume
  │
  ├─→ Type C (conflict): Resolve, resume
  │
  ├─→ Type D (unknown): Manual recovery
  │
  └─→ Type E (mid-run): Scope to current run, resume from last AIOU
```

## Agent Invocations

### Agent: sdlc-debugger
Invoke via Agent tool with `subagent_type: "sdlc-debugger"`:
- **Provide**: State file contents (project-context.md, progress.md, WORKING-MEMORY.md, current-state.md), git log, interruption symptoms
- **Request**: Diagnose state inconsistencies, identify interruption type (A-E), and recommend specific recovery actions
- **Apply**: Use state diagnosis in Steps 2-4 to determine the correct recovery path and resolve conflicts
