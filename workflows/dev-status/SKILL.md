---
name: sdlc-dev-status
description: |
  Quick status overview of development progress
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


# Workflow: dev-status

Quick status overview of development progress.

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol, code review protocol per `council-development.md`

## When User Says
`/dev-status` or "What's the development status?"

## Instructions

Execute these steps:

### Step 1: Read Current State

Read these files:
- `.ultimate-sdlc/project-context.md` - for current wave and AIOU statuses
- `.ultimate-sdlc/progress.md` - for session notes and blockers
- `planning-handoff.md` - for AIOU specifications reference

If files don't exist, respond: "No development session found. Run `/dev-start` to begin."

### Step 2: Run Health Check

Run these commands:
// turbo
```bash
# Check git status
git status --short

# Run tests (if available)
npm test --passWithNoTests 2>/dev/null || echo "Tests: Check manually"
```

### Step 3: Determine Wave Progress

For each wave, determine status:
- **Complete**: All wave AIOUs implemented and verified
- **In Progress**: Currently working in this wave
- **Pending**: Haven't reached this wave yet

### Step 4: Check for Gates

If current wave is 3 or approaching I8 (gate phases):
- Note gate requirements
- Recommend running `/dev-gate-i4` or `/dev-gate-i8` before advancing

### Step 5: Display Status

Output this format:

Use **Display Template** from `council-development.md` to show: Development Status

### Step 6: Recommend Skills

Based on current wave, tell user which skills should be loaded:
- Look up in `.reference/skills-index.md`
- Note the agent for this wave
- Note the model for this wave

### Step 7: Ask User

End with: "Would you like to continue with [next AIOU] or work on something specific?"

## Notes
- Keep output concise
- Highlight blockers prominently
- If at gate wave, emphasize verification requirements
- Recommend parallel opportunities if multiple independent AIOUs exist
