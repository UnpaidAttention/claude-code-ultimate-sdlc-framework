---
name: dev-wave5-status
description: |
  Show Wave 5 UI development status with model distribution and layer progress
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
- Read `~/.claude/skills/antigravity/knowledge/status-reporting/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/progress-tracking/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/metrics-collection/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/systematic-evaluation/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# Workflow: dev-wave5-status

---

## Lens / Skills / Model
**Lens**: `[UX]` + `[Quality]` | **Model**: claude-opus-4-6
> Apply RARV cycle, session protocol, code review protocol per `council-development.md`

## Trigger

`/dev-wave5-status` or `/dev-status` when in Wave 5

## Prerequisites

- Wave 5 initialized via `/dev-wave5-start`
- `wave5-context.md` exists

## Instructions

### Step 1: Read Wave 5 Context

Read `wave5-context.md` to get:
- Current AIOU
- Current model
- Completed AIOUs
- Pending AIOUs
- Layer progress

### Step 1.5: Read UI Design Phase Status

Read `.antigravity/council-state/development/run-tracker.md` and check:
- UI Research (UI-R): PENDING / COMPLETE
- UI Design Plan (UI-P): PENDING / COMPLETE
- UI Wiring Verification (UI-V) for current run: PENDING / COMPLETE / NOT YET RUN
- Design artifacts loaded: `design-system.md` exists? `ui-design-plan.md` exists?

### Step 2: Calculate Statistics

Compute:
- Total AIOUs
- Completed count
- Pending count
- Completion percentage
- AIOUs by model type (VISUAL/LOGIC/HYBRID)
- AIOUs by layer (1-7)

### Step 3: Identify Current State

Determine:
- Current AIOU in progress (if any)
- Current model being used
- Next AIOU in queue
- Blocked AIOUs (if any)

### Step 4: Generate Status Report

Output:

Use **Display Template** from `council-development.md` to show: Wave 5 (UI) Status

### UI Design Phases
UI Research: [✅ COMPLETE / ⏳ PENDING]
UI Design Plan: [✅ COMPLETE / ⏳ PENDING]
UI Wiring Verification: [✅ PASS / ⏳ NOT YET RUN / ❌ FAILED]
Design System: [Loaded / Missing]

### Implementation Progress
[====================>                    ] 52% Complete
### Current Work
Layer Progress:
  L1-2: ████████████ 100% ✓
  L3:   ████████░░░░  67%
  L4:   ████░░░░░░░░  33%
  L5:   ░░░░░░░░░░░░   0%
  L6:   ░░░░░░░░░░░░   0%
  L7:   ░░░░░░░░░░░░   0%
### Execution Queue

## Compact Mode

`/dev-wave5-status --compact`:

Use **Display Template** from `council-development.md` to show: Wave 5: 52% Complete (13/25 AIOUs)

## Arguments

| Argument | Description |
|----------|-------------|
| `--compact` | Show compact single-screen status |
| `--queue` | Show full execution queue |
| `--completed` | Show all completed AIOUs |
| `--blocked` | Show blocked AIOUs only |

## Notes

- This workflow provides Wave 5 specific status
- Shows model distribution and remaining switches
- Layer progress indicates execution phase
- Use `/dev-status` for overall project status
- Model switch warnings help plan work sessions
