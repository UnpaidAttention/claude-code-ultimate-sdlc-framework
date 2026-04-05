---
name: validate-p1
description: |
  Execute Production Track P1 - Operational Assessment. Assess operational readiness for production.
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
- Read `~/.claude/skills/antigravity/knowledge/operational-readiness/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/monitoring-observability/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/deployment-procedures/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# /validate-p1 - Operational Assessment

## Lens / Skills / Model
**Lens**: `[Operations] + [Performance]` | **Model**: Claude Opus 4.5
> Apply RARV cycle, session protocol per council-validation.md

## Prerequisites

- Gate C4 must be passed

If prerequisites not met:
```
Gate C4 not passed. Run /validate-gate-c4 first.
```

---

## Workflow

### Step 1: Update Project State

Update `.antigravity/project-context.md`:
- Set `Current Track`: Production
- Set `Current Phase`: P1 - Operational Assessment
- Set `Status`: in_progress

### Step 2: Deployment Readiness

Assess deployment requirements:

Use **Display Template** from `council-validation.md` to show: Deployment Checklist

### Step 3: Monitoring & Observability

Assess monitoring setup:

Use **Display Template** from `council-validation.md` to show: Monitoring Assessment

### Step 4: Operational Procedures

Document operational procedures:

- Deployment procedure
- Rollback procedure
- Incident response procedure
- Backup/restore procedure

### Step 5: Phase Completion Criteria

- [ ] Deployment readiness assessed
- [ ] Monitoring setup verified
- [ ] Operational procedures documented
- [ ] Issues identified and documented

### Step 6: Complete Phase

```
## P1: Operational Assessment - Complete

**Readiness Score**: [X]/10
**Critical Issues**: [Y]
**Blocking Issues**: [Z]

**Next Step**: Run `/validate-p2` to continue to Failure Mode Analysis
```

---
