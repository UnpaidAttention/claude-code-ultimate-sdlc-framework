---
name: validate-v3
description: |
  Execute Validation Track V3 - Completeness Assessment. Build completeness matrix against requirements.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/completeness-matrix/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/multi-lens-analysis/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/traceability/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/systematic-evaluation/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /validate-v3 - Completeness Assessment

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Opus 4.5
> Apply RARV cycle, session protocol per council-validation.md

## Prerequisites

- V2 (Gap Analysis) must be complete

If prerequisites not met:
```
V2 not complete. Run /validate-v2 first.
```

---

## Workflow

### Step 1: Update Project State

Update `.ultimate-sdlc/project-context.md`:
- Set `Current Phase`: V3 - Completeness Assessment
- Set `Status`: in_progress

### Step 2: Build Completeness Matrix

Create `.ultimate-sdlc/council-state/validation/completeness-matrix.md`:

Use **Display Template** from `council-validation.md` to show: Completeness Matrix

### Step 3: Multi-Lens Analysis

Apply multiple analysis perspectives:

1. **User Lens**: Can users accomplish their goals?
2. **Developer Lens**: Is the code maintainable?
3. **Operations Lens**: Is it deployable and monitorable?
4. **Security Lens**: Are security requirements met?
5. **Performance Lens**: Are performance targets met?

### Step 4: Phase Completion Criteria

- [ ] Completeness matrix built for all features
- [ ] Requirement traceability documented
- [ ] Multi-lens analysis complete
- [ ] Missing items identified and documented

### Step 5: Complete Phase

```
## V3: Completeness Assessment - Complete

**Features Analyzed**: [X]
**Overall Completeness**: [Y]%
**Items Needing Work**: [Z]

**Next Step**: Run `/validate-v4` to continue to Prerequisite Verification
```

---
