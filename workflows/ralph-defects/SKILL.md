---
name: ralph-defects
description: |
  Process and fix all open defects autonomously using Ralph Wiggum loop strategy
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/defect-management/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/root-cause-analysis/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/systematic-debugging/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# Workflow: ralph-defects

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4.5
> Apply RARV cycle, session protocol per council-development.md

Process and resolve all open defects autonomously using the Ralph Wiggum plugin's continuous loop strategy.

## Trigger

`/ralph-defects` or `/ralph-defects --severity [level]` or `/ralph-defects --max-iterations N`

## When to Use

- Multiple defects logged in `defect-log.md` need fixing
- Defects are well-documented with clear reproduction steps
- Fixes are mechanical (clear cause and solution)
- You want hands-off batch processing of defect backlog

## When NOT to Use

- Defects require architectural changes
- Root cause is unclear or needs investigation
- Defects involve complex user flows requiring judgment
- Critical/security defects that need careful review

## Prerequisites

Before starting:
1. `defect-log.md` exists with documented defects
2. Each defect has:
   - Clear steps to reproduce
   - Screenshot evidence
   - Passed `/audit-verify-defect`
3. Application is running and accessible
4. Git checkpoint created
5. Ralph Wiggum plugin installed

## How Ralph Wiggum Works

The Ralph Wiggum plugin uses a **Stop hook** mechanism:
1. Claude works on fixing defects and attempts to complete/exit
2. The Stop hook intercepts the exit attempt
3. Hook checks for completion signal: `<promise>TEXT</promise>` in output
4. If not complete, the **same prompt is re-injected** and Claude continues
5. Claude "learns" by reading modified `defect-log.md`, git commits, and test results

**Key insight**: The prompt doesn't change between iterations - the defect statuses do.

## Instructions

### Step 1: Validate Defect Log

1. Read `defect-log.md`
2. Count defects by status: OPEN, IN_PROGRESS, RESOLVED, BLOCKED
3. Filter by severity if `--severity` specified
4. Verify each OPEN defect has required evidence

If no OPEN defects found, report and exit.

### Step 2: Create Safety Checkpoint

```bash
git add -A && git commit -m "Pre-Ralph: Defect fixing starting point"
git tag ralph-defects-start
```

### Step 3: Calculate Iteration Limit

```bash
/ralph-loop "You are fixing defects for the Software Audit Council.

## YOUR TASK EACH ITERATION

1. READ STATE: Open defect-log.md and review defect statuses
   - Find the first defect with status OPEN or IN_PROGRESS
   - If ALL defects show RESOLVED or BLOCKED, you are DONE

2. IF DONE: Output exactly: <promise>All defects processed</promise>
   Then provide a summary of resolved vs blocked defects.

3. IF NOT DONE - FIX CURRENT DEFECT (DEF-XXX):
   a. Read the defect details and reproduction steps
   b. REPRODUCE the defect (MANDATORY - must verify it exists)
   c. Capture screenshot showing the issue: /audit-screenshot
   d. Identify the root cause (not just symptoms)
   e. Implement minimal fix addressing root cause
   f. Capture 'after' screenshot showing resolution
   g. Run /audit-verify-defect DEF-XXX

4. AFTER VERIFICATION:
   - If VERIFIED: Update defect-log.md status to RESOLVED
     Commit with message 'Fix DEF-XXX: [brief description]'
     Update audit-context.md defect counts
   - If FAILED: Track attempt count in .ultimate-sdlc/progress.md
     If 3 attempts exhausted, mark as BLOCKED in defect-log.md with reason
     Move to the next defect

5. LOG PROGRESS: Update .ultimate-sdlc/progress.md with what you fixed this iteration

## SEVERITY PRIORITY ORDER
Process defects in this order:
1. Critical (system unusable, data loss)
2. High (major feature broken)
3. Medium (feature impaired)
4. Low (cosmetic, minor)

## CRITICAL RULES
- ONLY output <promise>All defects processed</promise> when truly done
- MUST reproduce defect before attempting fix (Reproduction-First Protocol)
- Never lie about completion - the hook detects the promise tag
- If some defects blocked but others remain OPEN, continue fixing
- Read git log to see what previous iterations fixed

## COMPLETION SIGNAL
When no OPEN defects remain in defect-log.md (all are RESOLVED or BLOCKED):
<promise>All defects processed</promise>" --max-iterations {CALCULATED_LIMIT}
```

### Step 5: Monitor Progress

```bash
   git log ralph-defects-start..HEAD --oneline
   Display: Completion Signalsbash
# Fix all open defects
/ralph-defects

# Fix only High and Critical defects
/ralph-defects --severity High

# Fix with custom iteration limit
/ralph-defects --max-iterations 50
```

## Notes

- The **same prompt** is re-injected each iteration - Claude learns from `defect-log.md` changes
- Each defect MUST be reproduced before fixing (Reproduction-First Protocol)
- Screenshot evidence required for both before and after states
- Blocked defects don't stop processing - continues to next
- Run full test suite after Ralph completes
- Review git log: `git log ralph-defects-start..HEAD`
- Plugin state stored in `.claude/ralph-loop.local.md`
