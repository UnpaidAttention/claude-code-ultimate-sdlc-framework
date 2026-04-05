---
name: sdlc-ralph-corrections
description: |
  Process all pending corrections autonomously using Ralph Wiggum loop strategy
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/correction-management/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/tdd-methodology/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/root-cause-analysis/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# Workflow: ralph-corrections

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4.5
> Apply RARV cycle, session protocol per council-development.md

Process all pending corrections autonomously using the Ralph Wiggum plugin's continuous loop strategy with mandatory before/after verification.

## Trigger

`/ralph-corrections` or `/ralph-corrections --track [track]` or `/ralph-corrections --max-iterations N`

## When to Use

- Multiple corrections logged in `correction-log.md` need implementation
- Corrections have clear root cause analysis
- Fixes are well-defined with verification criteria
- You want hands-off batch processing of correction backlog

## When NOT to Use

- Corrections require architectural refactoring
- Root cause analysis is incomplete
- Corrections involve complex multi-system changes
- Security-critical corrections needing careful review

## Prerequisites

Before starting:
1. `correction-log.md` exists with documented corrections
2. Each correction has:
   - Root cause identified (not just symptoms)
   - Prerequisites verified
   - Clear correction plan
3. Application is running and accessible
4. Git checkpoint created
5. Ralph Wiggum plugin installed

## How Ralph Wiggum Works

The Ralph Wiggum plugin uses a **Stop hook** mechanism:
1. Claude works on corrections and attempts to complete/exit
2. The Stop hook intercepts the exit attempt
3. Hook checks for completion signal: `<promise>TEXT</promise>` in output
4. If not complete, the **same prompt is re-injected** and Claude continues
5. Claude "learns" by reading modified `correction-log.md`, before/after artifacts, and test results

**Key insight**: The prompt doesn't change between iterations - the correction statuses do.

## Instructions

### Step 1: Validate Correction Log

1. Read `correction-log.md`
2. Count corrections by status: PENDING, IN_PROGRESS, COMPLETE, BLOCKED
3. Filter by track if `--track` specified (V, C, P, E)
4. Verify each PENDING correction has root cause analysis

If no PENDING corrections found, report and exit.

### Step 2: Create Safety Checkpoint

```bash
git add -A && git commit -m "Pre-Ralph: Corrections starting point"
git tag ralph-corrections-start
```

### Step 3: Calculate Iteration Limit

```bash
/ralph-loop "You are processing corrections for the Software Validation & Perfection Council.

## YOUR TASK EACH ITERATION

1. READ STATE: Open correction-log.md and review correction statuses
   - Find the first correction with status PENDING or IN_PROGRESS
   - If ALL corrections show COMPLETE or BLOCKED, you are DONE

2. IF DONE: Output exactly: <promise>All corrections processed</promise>
   Then provide a summary with counts of complete vs blocked.

3. IF NOT DONE - PROCESS CURRENT CORRECTION (COR-XXX):

   a. PREPARE:
      - Read correction details and root cause from correction-log.md
      - Verify prerequisites still exist
      - Document the test scenario you will use for before/after

   b. CAPTURE BEFORE STATE:
      - Run /validate-before-after before COR-XXX
      - Execute the test scenario
      - Capture screenshot showing the issue
      - If cannot reproduce, mark as BLOCKED and move to next

   c. IMPLEMENT FIX:
      - Apply minimal fix addressing ROOT CAUSE (not symptoms)
      - Ensure fix matches the correction plan
      - Write/update verification test if needed

   d. CAPTURE AFTER STATE:
      - Run /validate-before-after after COR-XXX
      - Execute the SAME test scenario
      - Capture screenshot showing resolution

   e. VERIFY:
      - Run /validate-verify-correction COR-XXX
      - Check for Verification Certificate generation

4. AFTER VERIFICATION:
   - If Certificate generated: Update correction-log.md status to COMPLETE
     Commit with message 'Fix COR-XXX: [root cause summary]'
   - If FAILED: Track attempt count in .ultimate-sdlc/progress.md
     If 3 attempts exhausted, mark as BLOCKED with reason
     Move to the next correction

5. CHECK FOR REGRESSIONS: Run related tests after each fix

6. LOG PROGRESS: Update .ultimate-sdlc/progress.md with what you completed this iteration

## TRACK PRIORITY ORDER (if not filtered)
1. V-track corrections (V1-V5) - Validation issues
2. C-track corrections (C1-C4) - Correction track issues
3. P-track corrections (P1-P4) - Production issues
4. E-track corrections (E1-E4) - Enhancement issues

## CRITICAL RULES
- ONLY output <promise>All corrections processed</promise> when truly done
- Before/After evidence is MANDATORY - no exceptions
- Same test scenario must be used for both captures
- Fix ROOT CAUSE only - don't fix symptoms
- Never lie about completion - the hook detects the promise tag
- Read git log to see what previous iterations fixed

## COMPLETION SIGNAL
When no PENDING corrections remain (all are COMPLETE or BLOCKED):
<promise>All corrections processed</promise>" --max-iterations {CALCULATED_LIMIT}
```

### Step 5: Monitor Progress

```bash
   git log ralph-corrections-start..HEAD --oneline
   ```

2. **Run E2E tests** to verify no regressions:
   ```bash
   /validate-e2e-test all
   Display: Completion Signalsbash
# Process all pending corrections
/ralph-corrections

# Process only Validation track corrections
/ralph-corrections --track V

# Process with custom iteration limit
/ralph-corrections --max-iterations 60
```

## Notes

- The **same prompt** is re-injected each iteration - Claude learns from file changes
- Before/After evidence is MANDATORY - no exceptions
- Same test scenario must be used for both captures
- Root cause fix only - don't fix symptoms
- Blocked corrections need manual root cause review
- Run full E2E test after Ralph completes
- Review git log: `git log ralph-corrections-start..HEAD`
- Certificates stored in `verification/certificates/COR-XXX.md`
- Plugin state stored in `.claude/ralph-loop.local.md`
