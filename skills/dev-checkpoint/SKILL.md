---
name: sdlc-dev-checkpoint
description: |
  Create a git checkpoint for safe rollback
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
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/git-operations/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/checkpoint-management/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


# Development Checkpoint Workflow

> Trigger: `/dev-checkpoint`

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocols per `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/rules/council-development.md`

## Description

Creates a git checkpoint (tag) at a known-good state. Enables safe rollback if future changes cause problems.

// turbo-all

## Why This Workflow Exists

AI agents may introduce bugs or make changes that break previously working code. Checkpoints provide:
- Safe rollback points
- Clear progress markers
- Audit trail of development
- Recovery from mistakes

## Pre-Conditions

- Git repository must be initialized
- Should have no failing tests (or document known failures)
- Working directory should be clean (or changes should be staged)

## Steps

### Step 1: Verify Clean State

// turbo
```bash
# Check for uncommitted changes
git status --short
```

### Step 2: Run Tests

```bash
# Verify tests pass before checkpoint
npm test
```

### Step 3: Determine Checkpoint Name

```bash
# Create annotated tag
git tag -a "[checkpoint-name]" -m "[description]"

# Verify tag created
git tag -l "[checkpoint-name]"
```

### Step 5: Document Checkpoint

### Notes

[Any context about this checkpoint]

### Step 7: Confirm Success

Announce:
> "Checkpoint '[name]' created successfully. You can rollback to this point using `/dev-rollback`."

## Artifacts Generated

- **Checkpoint Artifact**: State documentation

## Checkpoint Strategy

**Create checkpoints:**
- Before starting each wave
- After each wave completes
- After quality gates pass
- Before risky/complex AIOUs
- When something is "working" and you're about to change it

**Naming conventions:**
- Keep names descriptive but concise
- Include wave/AIOU numbers when relevant
- Use lowercase with hyphens
