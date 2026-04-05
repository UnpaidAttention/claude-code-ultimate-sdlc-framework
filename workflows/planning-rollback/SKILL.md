---
name: sdlc-planning-rollback
description: |
  Revert to a previous phase checkpoint
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rollback-procedures/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/checkpoint-management/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/systematic-evaluation/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# Planning Rollback

---

## Lens / Skills / Model
**Lens**: `[Requirements]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per council-planning.md

## When to Use
- Current phase has gone in wrong direction
- Major requirement change invalidates recent work
- User requests to restart from earlier phase
- Unrecoverable errors in deliverables

## Prerequisites
- `.ultimate-sdlc/project-context.md` must exist with phase history
- `.ultimate-sdlc/progress.md` should have checkpoint notes

## CRITICAL: Confirmation Required

**This workflow will discard work. Always confirm with user before proceeding.**

Ask: "This will rollback to Phase [X]. The following will be discarded: [list]. Continue? (yes/no)"

## Steps

1. **Identify Current State**
   - Read `.ultimate-sdlc/project-context.md` for current phase
   - Read `.ultimate-sdlc/progress.md` for recent work
   - List deliverables created since target rollback point

2. **Select Rollback Target**
   User specifies target phase, or choose from:
   - Previous phase (Phase N-1)
   - Last quality gate (3.5 or start)
   - Specific phase by number

3. **Document What Will Be Lost**
   Use **Display Template** from `council-planning.md` to show: Rollback Impact Assessment

4. **Get Explicit Confirmation**
   - Present impact assessment to user
   - Require explicit "yes" to proceed
   - If user declines, abort rollback

5. **Execute Rollback**

   a. **Archive current state** (safety backup):
   ```
   Create: archive/rollback-[timestamp]/
   Copy: All deliverables being discarded
   Copy: Current .ultimate-sdlc/project-context.md
   Copy: Current .ultimate-sdlc/progress.md
   ```

   b. **Update .ultimate-sdlc/project-context.md**:
   - Set current phase to target
   - Clear completed phases after target
   - Reset status to "in_progress"

   c. **Update .ultimate-sdlc/progress.md**:
   - Add rollback entry with timestamp
   - Note reason for rollback
   - Note what was archived

   d. **Remove or archive affected deliverables**:
   - Move to archive folder, don't delete

6. **Verify Rollback**
   - Confirm .ultimate-sdlc/project-context.md shows correct phase
   - Confirm .ultimate-sdlc/progress.md documents rollback
   - Confirm archived files are accessible

7. **Resume Work**
   - Load skills for target phase
   - Announce: "Rolled back to Phase [X]. Ready to resume."

## Output Format

Use **Display Template** from `council-planning.md` to show: Rollback Complete

## Recovery

If rollback was a mistake:
- Archived files are preserved in `archive/rollback-[timestamp]/`
- Can manually restore from archive
- Update .ultimate-sdlc/project-context.md and .ultimate-sdlc/progress.md accordingly
