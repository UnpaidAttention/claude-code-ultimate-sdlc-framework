---
name: sdlc-validate-gate-v5
description: |
  Verify Validation Gate V5 criteria. Correction planning must be complete before correction track.
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
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/gate-verification/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/intent-documentation/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/gap-analysis/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/systematic-evaluation/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


# /validate-gate-v5 - Gate V5 Verification

## Lens / Skills / Model
**Lens**: `[Architecture]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per council-validation.md

## Prerequisites

- V5 (Correction Planning) must be complete

If prerequisites not met:
```
V5 not complete. Run /validate-v5 first.
```

---

## Workflow

### Agent: gate-keeper
Invoke via Agent tool with `subagent_type: "sdlc-gate-keeper"`:
- **Provide**: Gate V5 criteria from `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/gate-criteria.md` § Validation Council Gates → Gate V5, V-track phase outputs (intent map, gap report, completeness matrix, verification log, correction plan)
- **Request**: Verify each Gate V5 criterion against evidence, run automated checks where applicable, and produce PASS/FAIL determination with justification per criterion
- **Apply**: Use gate-keeper's determination for the gate decision below

### Step 1: Gate Verification

The gate-keeper agent performs the full gate verification including:
- Loading criteria from `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/gate-criteria.md` § Validation Council Gates → Gate V5
- Verifying each criterion against the authoritative checklist
- Running automated checks where applicable

### Step 2: Gate Decision

**If ALL criteria pass:**

Use **Display Template** from `council-validation.md` to show: Gate V5: PASSED

**If ANY criterion fails:**

```
## Gate V5: FAILED

Issues to resolve:
- [List failed criteria with details]

**Next Step**: Run `/validate-v5` to address issues, then re-run `/validate-gate-v5`
```

---
