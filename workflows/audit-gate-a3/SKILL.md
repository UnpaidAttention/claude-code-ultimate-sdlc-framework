---
name: audit-gate-a3
description: |
  Verify Audit Gate A3 criteria. Quality assessment must be complete before enhancement track.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/quality-assessment/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/defect-logging/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/systematic-evaluation/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /audit-gate-a3 - Gate A3 Verification

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per `council-audit.md`

## Prerequisites

- A3 (Quality Assessment) must be complete

If prerequisites not met:
```
A3 not complete. Run /audit-a3 first.
```

---

## Workflow

### Step 1: Load Gate A3 Criteria

Load criteria from `~/.claude/skills/ultimate-sdlc/context/gate-criteria.md` § Audit Council Gates → Gate A3.

Verify each criterion against the authoritative checklist. Run automated checks where applicable.

### Step 1.5: Security Checklist

Complete the Security Checklist from `~/.claude/skills/ultimate-sdlc/context/gate-criteria.md` § Standard Terms.

### Step 2: Gate Decision

**If ALL criteria pass:**

```
## Gate A3: PASSED

Quality assessment complete.

**Next Step**: Run `/audit-complete` to finalize the Audit Council. Enhancement activities continue in the Validation Council.
```

**If ANY criterion fails:**

```
## Gate A3: FAILED

Issues to resolve:
- [List issues]

**Next Step**: Run `/audit-a3` to address issues, then re-run `/audit-gate-a3`
```

---
