---
name: sdlc-audit-t4
description: |
  Execute Audit Track T4 - Integration Testing. System integration and cross-component testing.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/integration-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/api-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/database-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /audit-t4 - Integration Testing

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per `council-audit.md`

## Prerequisites

- Gate T3 must be passed

If prerequisites not met:
```
Gate T3 not passed. Run /audit-gate-t3 first.
```

---

## Workflow

### Step 1: Update Project State

Update `.ultimate-sdlc/project-context.md`:
- Set `Current Phase`: T4 - Integration Testing
- Set `Status`: in_progress

### Step 2: Integration Test Areas

#### API Integration
- Frontend to backend communication
- API contract verification
- Error response handling

#### Database Integration
- Data persistence
- Transaction handling
- Concurrent access

#### External Services
- Third-party API integration
- Timeout handling
- Fallback behavior

#### Cross-Feature Integration
- Feature A + Feature B interactions
- Shared state consistency
- Event propagation

### Step 3: Execute Integration Tests

For each integration point:
1. Identify components involved
2. Define test scenarios
3. Execute tests
4. Document results

### Step 4: Phase Completion Criteria

- [ ] API integration verified
- [ ] Database integration verified
- [ ] External services tested
- [ ] Cross-feature integration tested
- [ ] Defects logged

### Step 5: Complete Phase

```
## T4: Integration Testing - Complete

**Integration Points Tested**: [X]
**Passed**: [Y]
**Failed**: [Z]

**Next Step**: Run `/audit-t5` to continue to Performance & Security
```

---
