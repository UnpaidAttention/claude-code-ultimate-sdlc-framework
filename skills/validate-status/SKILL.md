---
name: sdlc-validate-status
description: |
  Quick status overview of current validation progress
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
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/status-reporting/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/progress-tracking/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/metrics-collection/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/systematic-evaluation/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


# Workflow: validate-status

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply session protocol per `council-validation.md`
---

Quick status overview of current validation progress.

## When User Says
`/validate-status` or "What's the validation status?"

## Instructions

Execute these steps:

### Step 1: Read Current State

Read these files:
- `validation-context.md` - for current phase and track
- `.ultimate-sdlc/progress.md` - for recent activity
- `intent-map.md` - count documented intents
- `correction-log.md` - count corrections made/verified
- `enhancement-proposals.md` - count proposals

### Step 2: Calculate Progress

For each track, determine status:
- **Not started**: Haven't entered this track yet
- **In progress**: Currently in this track
- **Complete**: All phases in track finished

Count metrics:
- Features identified (from intent-map.md)
- Intents documented (completed entries in intent-map.md)
- Gaps found (from gap analysis in intent-map.md)
- Corrections made (from correction-log.md)
- Corrections verified (verified entries in correction-log.md)
- Enhancements proposed (from enhancement-proposals.md)

### Step 3: Display Status

Output this format:

Use **Display Template** from `council-validation.md` to show: Validation Status

## Notes
- Keep output concise
- Highlight any blockers if present
- If files don't exist, report "Session not initialized - run /validate-start"
