---
name: sdlc-dev-parallel
description: |
  Execute parallel AIOU development with safety checks
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/parallel-execution/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/file-ownership/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/git-operations/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# Development Parallel Execution Workflow

> Trigger: `/dev-parallel`

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: claude-opus-4-6
> Apply RARV cycle, session protocols per `~/.claude/skills/ultimate-sdlc/rules/council-development.md`

## Description
Spawns parallel agents in Manager View to execute multiple independent AIOUs simultaneously. **Includes safety guardrails to prevent merge conflicts and coordination failures.**

## Why Safety Guardrails Matter

Parallel execution without proper safeguards leads to:
- Merge conflicts that waste time
- Inconsistent implementations
- Race conditions in shared code
- Lost work due to conflicting changes

This workflow enforces strict isolation and coordination.

## Pre-Conditions
- Current wave must have multiple AIOUs
- AIOUs must not have dependencies on each other
- Git working directory must be clean
- **File ownership map must be generated (see Step 1)**

## Steps

### Step 1: Generate File Ownership Map (MANDATORY)

**Before ANY parallel execution**, create a file ownership map:

Use **Display Template** from `council-development.md` to show: File Ownership Map: Wave [N]

**Conflict Detection:**
- If ANY file appears in "Files to Modify" for multiple AIOUs: **CONFLICT**
- Conflicting AIOUs MUST be serialized, not parallelized

Generate **File Ownership Artifact**:
Use **Display Template** from `council-development.md` to show: Parallel Safety Check: Wave [N]

**If conflicts exist:**
- Do NOT proceed with parallel execution
- Either serialize the conflicting AIOUs OR
- Refactor to eliminate shared file modifications

### Step 2: Identify Parallel AIOUs
- Read current wave AIOUs from `.ultimate-sdlc/project-context.md`
- Filter to AIOUs with no inter-dependencies
- Verify each AIOU's external dependencies are met
- **Verify File Ownership Artifact shows no conflicts**

### Step 3: Create Shared Dependencies First

**BEFORE parallel execution**, complete any shared code:

1. Identify types/interfaces used by multiple AIOUs
2. Implement shared types in SINGLE-THREADED mode
3. Commit shared code
4. Create checkpoint: `pre-parallel-wave-{N}`
5. ONLY THEN proceed to parallel execution

### Step 4: Prepare Parallel Execution
- Create branch for each AIOU: `aiou/AIOU-XXX`
- Verify branches are from same commit (checkpoint)
- Generate Plan Artifact showing parallel structure

### Step 5: Spawn Manager View Agents
- Open Ultimate SDLC Manager View
- For each parallel AIOU:
  - Spawn new agent instance
  - Assign AIOU specification
  - **Assign file ownership list (from Step 1)**
  - Set model based on AIOU type:
    - UI work → claude-opus-4-6
    - Other → Claude Sonnet 4.5

**Agent Constraints:**
- Each agent may ONLY modify files in its ownership list
- Each agent must READ (not modify) shared dependencies
- If agent needs to modify unassigned file: STOP and request reassignment

### Step 6: Monitor Progress
- Track each agent's status in Manager View
- Watch for conflicts or blockers
- **If any agent reports file conflict: PAUSE ALL AGENTS**
- Coordinate shared resource access

### Step 7: Sequential Merge Protocol

Merge agents ONE AT A TIME (not all at once):

Use **Display Template** from `council-development.md` to show: Merge Order for Wave [N]

For each merge:
1. Review Code Diff Artifact
2. Run FULL test suite (not just AIOU tests)
3. Generate Test Result Artifact
4. If tests pass: Merge and continue
5. **If tests fail: STOP merging, fix issue first**

### Step 8: Verify Integration
- Run full test suite after ALL merges
- Generate Integration Test Artifact
- Resolve any integration issues
- Create checkpoint: `post-parallel-wave-{N}`

## Artifacts Generated
- **File Ownership Artifact**: Conflict analysis (MANDATORY)
- **Plan Artifact**: Parallel execution structure
- **Code Diff Artifacts**: One per AIOU
- **Test Result Artifacts**: Per-merge verification
- **Integration Test Artifact**: Final verification

## Safety Guardrails Summary

| Guardrail | Purpose | Enforcement |
|-----------|---------|-------------|
| File Ownership Map | Prevent conflicts | BLOCK parallel if conflicts |
| Shared Code First | Consistent dependencies | Complete before parallel |
| Branch Isolation | Prevent interference | Each AIOU on own branch |
| Sequential Merge | Catch issues early | One at a time with tests |
| Full Test Suite | Verify integration | After each merge |

## Best Practices
- **Limit to 3-4 parallel agents** for manageability
- **Prefer AIOUs that modify different files** (use ownership map)
- **Complete shared types/interfaces first** in single-threaded mode
- **Never modify same file in parallel** - always serialize
- **Run full tests after EACH merge** - not just at the end

## Rollback Protocol

If parallel execution causes problems:
1. Do NOT attempt to fix while other agents running
2. STOP all parallel agents
3. Rollback to `pre-parallel-wave-{N}` checkpoint
4. Analyze what went wrong
5. Re-plan with proper serialization
6. Try again with corrected approach

## Failure Modes to Prevent

| Failure | Prevention |
|---------|------------|
| Merge conflicts | File ownership map |
| Type mismatches | Shared types first |
| Test failures after merge | Sequential merge with tests |
| Lost work | Branch per AIOU + checkpoints |
| Inconsistent state | Full test suite after each merge |
