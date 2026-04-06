---
name: sdlc-validate-c2
description: |
  Execute Correction Track C2 - Edge Case Implementation. Handle edge cases and boundary conditions.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/edge-case-handling/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/tdd-methodology/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/boundary-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /validate-c2 - Edge Case Implementation

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per council-validation.md

## Prerequisites

- C1 (Targeted Corrections) must be complete

If prerequisites not met:
```
C1 not complete. Run /validate-c1 first.
```

---

## Workflow

### Step 1: Update Project State

Update `.ultimate-sdlc/project-context.md`:
- Set `Current Phase`: C2 - Edge Case Implementation
- Set `Status`: in_progress

### Agent: tdd-guide
Invoke via Agent tool with `subagent_type: "sdlc-tdd-guide"`:
- **Provide**: Feature specs, current test suites, edge case categories below, boundary conditions
- **Request**: Design boundary tests for each edge case category — empty inputs, max lengths, special characters, race conditions, pagination limits, and numeric bounds; write test cases before implementation
- **Apply**: Use generated test cases as the test-first scaffold for edge case implementation

### Step 2: Edge Case Categories

Address edge cases by category:

#### Input Edge Cases
- Empty inputs
- Maximum length inputs
- Special characters
- Invalid formats
- Null/undefined values

#### State Edge Cases
- Race conditions
- Concurrent modifications
- Session expiry
- Network failures

#### Boundary Edge Cases
- List limits (0, 1, max)
- Pagination boundaries
- Date/time boundaries
- Numeric limits

#### User Edge Cases
- First-time users
- Returning users
- Multiple sessions
- Permission changes

### Step 3: Edge Case Documentation

For each edge case handled:

Use **Display Template** from `council-validation.md` to show: Edge Case: [Name]

### Step 4: Phase Completion Criteria

- [ ] All identified edge cases addressed
- [ ] Tests added for each edge case
- [ ] Documentation updated
- [ ] No regression in existing functionality

### Step 5: Complete Phase

Use **Display Template** from `council-validation.md` to show: C2: Edge Case Implementation - Complete

---
