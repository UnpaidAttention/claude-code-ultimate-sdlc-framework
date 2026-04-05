---
name: rollback
description: |
  Roll back development to a specific wave completion point. Use when a wave introduces fundamental issues that require reverting.
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
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/clean-code/SKILL.md`


# /rollback - Development Wave Rollback

---

## Arguments
| Argument | Required | Description |
|----------|----------|-------------|
| `wave` | Yes | Target wave to roll back to (e.g., `3` to revert to post-Wave 3 state) |

---

## Purpose

When a wave introduces fundamental issues (wrong architecture, broken dependencies, irrecoverable technical debt), `/rollback` restores the codebase and state to a previous wave's completion point.

**Use sparingly.** This discards completed work. Consider `/amend` first for targeted fixes.

---

## Prerequisites

- Must be in Development Council
- Target wave must have been completed
- Git tags from wave completion must exist (format: `wave-N-complete`)

---

## Rollback Steps

### Step 1: Confirm Scope

Use **Display Template** to show the rollback status
Use **Display Template** from `council-development.md` to show: ⚠️ Rollback Confirmation

**WAIT for user confirmation before proceeding.**

### Step 2: Git Rollback

1. Check for git tag: `wave-[N]-complete`
2. If tag exists: `git reset --hard wave-[N]-complete`
3. If tag doesn't exist: Display available tags, ask user to choose

### Step 3: State File Rollback

1. Update `.antigravity/council-state/development/current-state.md`:
   - Reset current wave to [N+1] (next wave to implement)
   - Uncheck waves after [N]
2. Update `.antigravity/council-state/development/WORKING-MEMORY.md`:
   - Clear entries related to discarded waves
   - Add rollback note with reason
3. If multi-run: Update `run-tracker.md` to reflect rolled-back state

### Step 4: Log the Rollback

Append to `.antigravity/progress.md`:

Use **Display Template** from `council-development.md` to show: ⚠️ ROLLBACK — [Date]

### Step 5: Resume

Use **Display Template** to show the rollback status
Use **Display Template** from `council-development.md` to show: Rollback Complete

---

## Constraints

- Only available in Development Council
- Cannot rollback past Wave 0-1 (types/utilities are foundational)
- User confirmation is MANDATORY — never auto-rollback
- Git tags must exist; if not, rollback is not possible
