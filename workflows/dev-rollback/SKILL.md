---
name: dev-rollback
description: |
  Rollback to a previous git checkpoint
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
- Read `~/.claude/skills/antigravity/knowledge/git-operations/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/checkpoint-management/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/systematic-debugging/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# Development Rollback Workflow

> Trigger: `/dev-rollback`

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Opus 4.5
> Apply RARV cycle, session protocols per `~/.claude/skills/antigravity/rules/council-development.md`

## Description

Rolls back to a previous checkpoint when current state is broken or unsalvageable. Use when errors persist after multiple fix attempts.

## Why This Workflow Exists

The CLAUDE.md specifies: "If stuck after 3 attempts: document issue, rollback to checkpoint, ask user." This workflow implements that recovery procedure safely.

## When to Use

- Tests failing and can't be fixed after 3 attempts
- Code is in a broken state
- Wrong architectural approach taken
- Need to abandon current AIOU approach
- Merge conflicts that are too complex

## ⚠️ Warning

**Rollback destroys uncommitted changes.** This workflow will:
- Document the current state (what went wrong)
- Reset to a previous known-good state
- Lose any work not committed

## Steps

### Step 1: Document Current State

Before rolling back, capture what went wrong:

Ask user:
- What was being attempted?
- What went wrong?
- What fixes were tried?

Create a **Failure Report Artifact**:

Use **Display Template** from `council-development.md` to show: Rollback Report

### Step 2: List Available Checkpoints

// turbo
```bash
# Show available checkpoints
git tag -l --sort=-creatordate | head -20
```

### Step 3: Select Checkpoint

```bash
# Stash any changes (just in case)
git stash push -m "pre-rollback-stash-[timestamp]"

# Reset to checkpoint
git reset --hard [checkpoint-tag]

# Verify state
git log -1 --oneline
git status
```

### Step 6: Verify Rollback

// turbo
```bash
# Run tests to confirm good state
npm test
```

### Step 7: Update State Files

```bash
git stash list
git stash show -p stash@{0}
git stash pop  # Apply and remove
```
