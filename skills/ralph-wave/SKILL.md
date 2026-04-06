---
name: sdlc-ralph-wave
description: |
  Execute an entire wave autonomously using Ralph Wiggum loop strategy
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/wave-execution/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/tdd-methodology/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/implementation-patterns/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# Workflow: ralph-wave

---

## Lens / Skills / Model
**Lens**: `[Architecture]` + `[Quality]` | **Model**: claude-opus-4-6
> Model choice: claude-opus-4-6 is used for wave execution due to larger context window for sustained AIOU processing.
> Apply RARV cycle, session protocol per council-development.md

Execute an entire development wave autonomously using the Ralph Wiggum plugin's continuous loop strategy.

## Trigger

`/ralph-wave [wave-number]` or `/ralph-wave [wave-number] --max-iterations N`

## When to Use

- Multiple AIOUs in a wave need implementation
- AIOUs are mechanical/well-defined (clear acceptance criteria)
- You want hands-off execution while wave completes
- Wave does NOT require judgment calls or architectural decisions

## When NOT to Use

- Complex AIOUs requiring architectural decisions
- Wave 5 (UI) - requires visual judgment, use claude-opus-4-6 interactively
- Gate waves (3, I8) - gates require explicit verification and approval
- When you need to make design choices mid-implementation

## Prerequisites

Before starting:
1. `planning-handoff.md` exists with wave specifications
2. All prior waves completed
3. `.ultimate-sdlc/project-context.md` shows current wave status
4. Git checkpoint created: `pre-wave-{N}`
5. Ralph Wiggum plugin installed

## How Ralph Wiggum Works

The Ralph Wiggum plugin uses a **Stop hook** mechanism:
1. Claude works on the task and attempts to complete/exit
2. The Stop hook intercepts the exit attempt
3. Hook checks for completion signal: `<promise>TEXT</promise>` in output
4. If not complete, the **same prompt is re-injected** and Claude continues
5. Claude "learns" by reading modified files, git history, and test results

**Key insight**: The prompt doesn't change between iterations - the codebase does.

## Instructions

### Step 1: Validate Wave

1. Read `.ultimate-sdlc/project-context.md` to confirm wave number
2. Read `planning-handoff.md` for wave AIOUs
3. Verify all dependency waves complete
4. Count total AIOUs in wave

If prerequisites not met, STOP and report what's missing.

### Step 2: Create Safety Checkpoint

```bash
git add -A && git commit -m "Pre-Ralph: Wave {N} starting point"
git tag ralph-wave-{N}-start
```

### Step 3: Calculate Iteration Limit

```bash
/ralph-loop "You are executing Wave {N} of the Software Development Council.

## YOUR TASK EACH ITERATION

1. READ STATE: Open .ultimate-sdlc/project-context.md and find AIOUs for Wave {N}
   - Identify the first AIOU with status PENDING or IN_PROGRESS
   - If ALL Wave {N} AIOUs show status VERIFIED, you are DONE

2. IF DONE: Output exactly: <promise>Wave {N} complete</promise>
   Then provide a summary of completed AIOUs.

3. IF NOT DONE - IMPLEMENT CURRENT AIOU:
   a. Run /dev-search-patterns AIOU-XXX (MANDATORY - find reusable code)
   b. Read the AIOU spec from planning-handoff.md
   c. Implement the code following existing patterns
   d. Write tests (3-8 per AIOU)
   e. Run /dev-build and capture output
   f. Run /dev-test and capture output
   g. Run /dev-verify-aiou AIOU-XXX

4. AFTER VERIFICATION:
   - If VERIFIED: Commit with message 'Complete AIOU-XXX: [description]'
     Update .ultimate-sdlc/project-context.md to mark AIOU as VERIFIED
   - If FAILED: Attempt fix (you have up to 3 attempts tracked in .ultimate-sdlc/progress.md)
     If still failing after 3 attempts, mark as BLOCKED in .ultimate-sdlc/project-context.md
     and move to the next AIOU

5. LOG PROGRESS: Update .ultimate-sdlc/progress.md with what you accomplished this iteration

## CRITICAL RULES
- ONLY output <promise>Wave {N} complete</promise> when ALL AIOUs are truly VERIFIED
- Never lie about completion - the hook detects the promise tag
- If blocked AIOUs exist but others remain, continue with remaining AIOUs
- Read git log to see what previous iterations accomplished

## COMPLETION SIGNAL
When all Wave {N} AIOUs show VERIFIED in .ultimate-sdlc/project-context.md:
<promise>Wave {N} complete</promise>" --max-iterations {CALCULATED_LIMIT}
```

### Step 5: Monitor Progress

```bash
   git log ralph-wave-{N}-start..HEAD --oneline
   ```

2. **Verify integration**:
   ```bash
   /dev-test
   ```

3. **If gate wave**, run gate verification:
   ```bash
   /dev-gate
   Display: Completion Signalsbash
# Execute Wave 2 with auto-calculated iterations
/ralph-wave 2

# Execute Wave 3 with explicit iteration limit
/ralph-wave 3 --max-iterations 75
```

## Notes

- The **same prompt** is re-injected each iteration - Claude learns from file changes
- Creates checkpoint before starting - safe to rollback with `git reset --hard ralph-wave-{N}-start`
- Blocked AIOUs don't stop the wave - continues to next
- Always run `/dev-test` after wave completes to verify integration
- Gate waves (3, I8) still require explicit `/dev-gate` after Ralph completes
- Plugin state stored in `.claude/ralph-loop.local.md`
