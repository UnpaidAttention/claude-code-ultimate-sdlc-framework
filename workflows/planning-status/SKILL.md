---
name: planning-status
description: |
  Quick status overview of current planning progress
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/status-reporting/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/progress-tracking/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/metrics-collection/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/systematic-evaluation/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# Workflow: planning-status

---

## Lens / Skills / Model
**Lens**: `[Requirements]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per council-planning.md

## When User Says
`/planning-status` or "What's the planning status?"

## Instructions

Execute these steps:

### Step 1: Read Current State

Read these files:
- `.ultimate-sdlc/project-context.md` - for current phase and project info
- `.ultimate-sdlc/progress.md` - for session notes and blockers

If files don't exist, respond: "No planning session found. Run `/planning-start` to begin."

### Step 2: Determine Phase Progress

For each phase, determine status:
- **Complete**: Phase deliverables exist and are finished
- **In Progress**: Currently in this phase
- **Pending**: Haven't reached this phase yet

### Step 3: Check for Gates

If current phase is 3.5 or 8 (gate phases):
- Note gate requirements
- Recommend running `/planning-verify` then `/planning-gate` before proceeding

### Step 4: Display Status

Output this format:

Use **Display Template** from `council-planning.md` to show: Planning Status

### Step 5: Recommend Skills

Based on current phase, tell user which skills should be loaded:
- Look up in `.reference/skills-index.md`
- Note the agent for this phase

### Step 6: Ask User

End with: "Would you like to continue with [current work] or work on something specific?"

## Notes
- Keep output concise
- Highlight blockers prominently
- If at gate phase, emphasize verification requirements
