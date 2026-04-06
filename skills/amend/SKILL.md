---
name: sdlc-amend
description: |
  Backtrack to amend a previous council's artifacts without restarting the full pipeline. Use when downstream work reveals upstream issues.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/documentation-standards/SKILL.md`


# /amend - Inter-Council Amendment

---

## Arguments
| Argument | Required | Description |
|----------|----------|-------------|
| `council` | Yes | Target council to amend: `planning`, `development`, `audit` |
| `reason` | Yes | Brief description of what needs to change |

---

## Purpose

Hot-fix pathway for targeted backtracking. When work in a downstream council reveals issues in an upstream council's artifacts, `/amend` allows surgical updates without restarting the full pipeline.

**This is NOT a full revert.** It modifies specific artifacts and returns to the current position.

---

## Valid Amendment Paths

| Current Council | Can Amend |
|----------------|-----------|
| Development | Planning (feature specs, AIOUs, architecture decisions) |
| Audit | Planning (feature specs), Development (code, tests) |
| Validation | Planning, Development, Audit |

You CANNOT amend a council you haven't completed yet.

---

## Amendment Steps

### Step 1: Read Config & Context

1. Read `.ultimate-sdlc/config.yaml` → extract current council, governance_mode
2. Read `.ultimate-sdlc/project-context.md` → confirm current position
3. Validate the target council has already been completed (or is current)

### Step 2: Document the Amendment

Create or append to `amendments-log.md` in project root:

Use **Display Template** from `the active council rules file` to show: Amendment [N]

### Step 3: Apply Changes

1. Navigate to the target council's artifacts
2. Make the surgical change — modify ONLY what the amendment requires
3. Update the amendment log with what was changed
4. Verify the change doesn't break downstream artifacts

### Step 4: Cascade Downstream

If the amendment changes:
- **Planning specs** → Check if Development Council artifacts are still valid
- **Code/tests** → Check if Audit findings are still valid
- **Audit results** → Check if Validation corrections are still appropriate

Document any downstream impacts in the amendment log.

### Step 5: Return to Current Position

1. Update `.ultimate-sdlc/project-context.md` with amendment note
2. Update `WORKING-MEMORY.md` with amendment context
3. Resume work at the current phase in the current council

---

## Constraints

- Amendments are **surgical** — change the minimum necessary
- Each amendment MUST be logged in `amendments-log.md`
- If the amendment is too large (> 5 files), consider `/rollback` instead
- Maximum 3 amendments per council transition — if you need more, the upstream work was insufficient
