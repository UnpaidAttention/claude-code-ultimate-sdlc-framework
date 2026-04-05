---
name: audit-status
description: |
  Quick status overview of audit progress
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


# Workflow: audit-status

Quick status overview of audit progress.

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per `council-audit.md`

## When User Says
`/audit-status` or "What's the audit status?"

## Instructions

Execute these steps:

### Step 1: Read Current State

Read these files:
- `audit-context.md` - for current phase and defect counts
- `.ultimate-sdlc/progress.md` - for session notes and blockers
- `defect-log.md` - for all defects found
- `planning-handoff.md` (if available) - for feature list

If files don't exist, respond: "No audit session found. Run `/audit-start` to begin."

### Step 2: Calculate Metrics

From the loaded files, calculate:
- Features tested vs total
- Defects by severity (Critical, High, Medium, Low)
- Phase completion percentage
- Enhancement ideas count

### Step 3: Determine Phase Progress

For each phase, determine status:
- **Complete**: Phase deliverables finished
- **In Progress**: Currently working in this phase
- **Pending**: Haven't reached this phase yet

### Step 4: Check for Gates

If current phase is T3 or A2 (gate phases):
- Note gate requirements
- Recommend running `/audit-gate-t3`, `/audit-gate-a2`, or `/audit-gate-a3` as appropriate

### Step 5: Display Status

Output this format:

Use **Display Template** from `council-audit.md` to show: Audit Status

### Step 6: Recommend Skills

Based on current phase, tell user which skills should be loaded:
- Look up in `.reference/skills-index.md`
- Note the agent for this phase
- Note the model for this phase
- Note the thinking mode for this phase

### Step 7: Thinking Mode Reminder

For current track, announce thinking mode:
- **Testing Track**: Systematic, methodical
- **Audit Track**: Critical analysis
- **Enhancement activities (→ Validation)**: Creative ideation

### Step 8: Ask User

End with: "Would you like to continue testing [current feature] or work on something specific?"

## Notes
- Keep output concise
- Highlight defect counts prominently
- If at gate phase, emphasize verification requirements
- Recommend `/audit-think` to switch thinking modes if needed
