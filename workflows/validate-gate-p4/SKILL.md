---
name: validate-gate-p4
description: |
  Verify Production Gate P4 criteria. Production readiness must be verified before enhancement track.
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
- Read `~/.claude/skills/antigravity/knowledge/gate-verification/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/production-readiness/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/security-verification/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/performance-verification/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# /validate-gate-p4 - Gate P4 Verification

## Lens / Skills / Model
**Lens**: `[Architecture]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per council-validation.md

## Prerequisites

- P4 (Security Hardening) must be complete

If prerequisites not met:
```
P4 not complete. Run /validate-p4 first.
```

---

## Workflow

### Step 1: Load Gate P4 Criteria

Load criteria from `~/.claude/skills/antigravity/context/gate-criteria.md` § Validation Council Gates → Gate P4.

Verify each criterion against the authoritative checklist. Run automated checks where applicable.

### Step 2: Gate Decision

**If ALL criteria pass:**

Use **Display Template** from `council-validation.md` to show: Gate P4: PASSED

**If ANY criterion fails:**

```
## Gate P4: FAILED

Issues to resolve:
- [List failed criteria with details]

**Next Step**: Address issues and re-run `/validate-gate-p4`
```

---
