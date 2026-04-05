---
name: validate-v4
description: |
  Execute Validation Track V4 - Prerequisite Verification. Verify all prerequisites for corrections are in place.
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
AG_HOME="${HOME}/.antigravity"
AG_PROJECT=".antigravity"
AG_SKILLS="${HOME}/.claude/skills/antigravity"

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
- Read `~/.claude/skills/antigravity/knowledge/prerequisite-verification/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/dependency-analysis/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/blocker-resolution/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/systematic-validation/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# /validate-v4 - Prerequisite Verification

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Opus 4.5
> Apply RARV cycle, session protocol per council-validation.md

## Prerequisites

- V3 (Completeness Assessment) must be complete

If prerequisites not met:
```
V3 not complete. Run /validate-v3 first.
```

---

## Workflow

### Step 1: Update Project State

Update `.antigravity/project-context.md`:
- Set `Current Phase`: V4 - Prerequisite Verification
- Set `Status`: in_progress

### Step 2: Identify Correction Prerequisites

For each gap/incompleteness identified:

1. **Dependency Analysis**
   - What must exist before this can be fixed?
   - What other fixes depend on this?
   - What order should corrections follow?

2. **Resource Assessment**
   - Are required APIs/services available?
   - Is test data available?
   - Are credentials/access configured?

3. **Blocker Identification**
   - What blocks this correction?
   - Can blockers be removed?
   - What's the mitigation plan?

### Step 3: Create Dependency Graph

Document correction dependencies:

Use **Display Template** from `council-validation.md` to show: Correction Dependencies

### Step 4: Phase Completion Criteria

- [ ] All correction prerequisites identified
- [ ] Dependency graph created
- [ ] Blockers documented with resolutions
- [ ] Correction order determined

### Step 5: Complete Phase

```
## V4: Prerequisite Verification - Complete

**Corrections Identified**: [X]
**Blockers Found**: [Y]
**Blockers Resolved**: [Z]

**Next Step**: Run `/validate-v5` to continue to Correction Planning
```

---
