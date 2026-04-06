---
name: sdlc-audit-gate-a2
description: |
  Verify Audit Gate A2 criteria. Completeness assessment must be done before quality assessment.
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
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/completeness-matrix/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/gap-analysis/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/systematic-evaluation/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


# /audit-gate-a2 - Gate A2 Verification

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per `council-audit.md`

## Prerequisites

- A2 (Completeness) must be complete

If prerequisites not met:
```
A2 not complete. Run /audit-a2 first.
```

---

## Workflow

### Agent: gate-keeper
Invoke via Agent tool with `subagent_type: "sdlc-gate-keeper"`:
- **Provide**: Gate A2 criteria from `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/gate-criteria.md` § Audit Council Gates → Gate A2, A2 phase outputs (completeness matrix, gap analysis, security requirements verification), Security Checklist from § Standard Terms
- **Request**: Verify each Gate A2 criterion against evidence, complete security checklist, run automated checks where applicable, and produce PASS/FAIL determination with justification per criterion
- **Apply**: Use gate-keeper's determination for the gate decision below

### Step 1: Gate Verification

The gate-keeper agent performs the full gate verification including:
- Loading criteria from `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/gate-criteria.md` § Audit Council Gates → Gate A2
- Verifying each criterion against the authoritative checklist
- Completing the Security Checklist from § Standard Terms
- Running automated checks where applicable

### Step 2: Gate Decision

**If ALL criteria pass:**

```
## Gate A2: PASSED

Completeness assessment complete.

**Next Step**: Run `/audit-a3` to continue to Quality Assessment
```

**If ANY criterion fails:**

```
## Gate A2: FAILED

Issues to resolve:
- [List issues]

**Next Step**: Run `/audit-a2` to address issues, then re-run `/audit-gate-a2`
```

---
