---
name: sdlc-audit-gate-a3
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
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/quality-assessment/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/defect-logging/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/systematic-evaluation/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


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

### Agent: gate-keeper
Invoke via Agent tool with `subagent_type: "sdlc-gate-keeper"`:
- **Provide**: Gate A3 criteria from `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/gate-criteria.md` § Audit Council Gates → Gate A3, A3 phase outputs (quality scorecard, defect log, recommendations), Security Checklist from § Standard Terms
- **Request**: Verify each Gate A3 criterion against evidence, complete security checklist, run automated checks where applicable, and produce PASS/FAIL determination with justification per criterion
- **Apply**: Use gate-keeper's determination for the gate decision below

### Step 1: Gate Verification

The gate-keeper agent performs the full gate verification including:
- Loading criteria from `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/gate-criteria.md` § Audit Council Gates → Gate A3
- Verifying each criterion against the authoritative checklist
- Completing the Security Checklist from § Standard Terms
- Running automated checks where applicable

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
