---
name: sdlc-validate-p2
description: |
  Execute Production Track P2 - Failure Mode Analysis. Identify and mitigate potential failure modes.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/fmea-analysis/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/risk-assessment/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/resilience-engineering/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/failure-mitigation/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /validate-p2 - Failure Mode Analysis

## Lens / Skills / Model
**Lens**: `[Operations] + [Performance]` | **Model**: Claude Opus 4.5
> Apply RARV cycle, session protocol per council-validation.md

## Prerequisites

- P1 (Operational Assessment) must be complete

If prerequisites not met:
```
P1 not complete. Run /validate-p1 first.
```

---

## Workflow

### Step 1: Update Project State

Update `.ultimate-sdlc/project-context.md`:
- Set `Current Phase`: P2 - Failure Mode Analysis
- Set `Status`: in_progress

### Step 2: FMEA Process

Conduct Failure Mode and Effects Analysis:

Use **Display Template** from `council-validation.md` to show: Failure Mode Analysis

### Step 3: Failure Scenarios

Analyze key failure scenarios:

#### Infrastructure Failures
- Database unavailable
- Cache failure
- Network partition
- Disk full

#### Application Failures
- Memory leak
- Deadlock
- Infinite loop
- Unhandled exception

#### External Failures
- Third-party API down
- Payment processor failure
- Email service failure

### Step 4: Mitigation Implementation

For high-RPN failure modes:

Use **Display Template** from `council-validation.md` to show: Mitigation: [Failure Mode]

### Step 5: Phase Completion Criteria

- [ ] FMEA completed for all components
- [ ] High-RPN items mitigated
- [ ] Detection mechanisms in place
- [ ] Runbooks created for critical failures

### Step 6: Complete Phase

```
## P2: Failure Mode Analysis - Complete

**Failure Modes Analyzed**: [X]
**High RPN (>100)**: [Y]
**Mitigations Implemented**: [Z]

**Next Step**: Run `/validate-p3` to continue to Performance Optimization
```

---
