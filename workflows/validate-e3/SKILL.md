---
name: validate-e3
description: |
  Execute Enhancement Track E3 - Enhancement Implementation. Implement approved enhancements.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/enhancement-implementation/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/tdd-methodology/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/implementation-patterns/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /validate-e3 - Enhancement Implementation

## Lens / Skills / Model
**Lens**: `[Architecture]` + `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per council-validation.md

## Prerequisites

- E2 (Innovation Opportunities) must be complete

If prerequisites not met:
```
E2 not complete. Run /validate-e2 first.
```

---

## Workflow

### Step 1: Update Project State

Update `.ultimate-sdlc/project-context.md`:
- Set `Current Phase`: E3 - Enhancement Implementation
- Set `Status`: in_progress

### Step 2: Enhancement Backlog

Create implementation backlog from approved enhancements:

Use **Display Template** from `council-validation.md` to show: Enhancement Backlog

### Step 3: Implementation Process

For each enhancement:

1. **Design**
   - Define approach
   - Identify files to modify
   - Plan testing strategy

2. **Implement**
   - Write tests first (TDD)
   - Implement changes
   - Verify functionality

3. **Document**
   - Update documentation
   - Add inline comments
   - Update changelog

### Step 4: Enhancement Documentation

Use **Display Template** from `council-validation.md` to show: Enhancement: [Name]

### Step 5: Phase Completion Criteria

- [ ] All selected enhancements implemented
- [ ] Tests passing
- [ ] Documentation updated
- [ ] No regressions introduced

### Step 6: Complete Phase

```
## E3: Enhancement Implementation - Complete

**Enhancements Implemented**: [X]
**Tests Added**: [Y]
**Documentation Updated**: ✅

**Next Step**: Run `/validate-e4` to continue to UX Polish
```

---
