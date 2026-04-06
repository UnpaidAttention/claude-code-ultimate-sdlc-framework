---
name: sdlc-release
description: |
  Final release certification. Verify all gates passed and generate release documentation.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/release-management/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/gate-verification/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/completeness-matrix/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /release - Release Certification

---

## Lens / Skills / Model
**Lens**: `[Quality]` + `[Security]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per the active council rules file

## Arguments
| Argument | Required | Description |
|----------|----------|-------------|
| (none) | — | Session auto-detects state |

---

## CRITICAL RULES

1. **All gates must pass** - No exceptions
2. **All defects resolved** - No P0/P1 open
3. **Documentation complete** - All docs updated

---

## Task

Certify release readiness:

### 1. Gate Verification

```
VERIFY all gates:
- [ ] Planning Gate 3.5 (AIOU Decomposition)
- [ ] Planning Gate 8 (Launch Ready)
- [ ] Development Gate I4 (API Layer)
- [ ] Development Gate I8 (Integration)
- [ ] Validation Gate V5 (Correction Planning)
- [ ] Validation Gate C4 (Regression Validation)
- [ ] Validation Gate P4 (Security Hardening)
- [ ] Validation Gate E4 (UX Polish)
- [ ] Validation Gate S2 (Release Readiness)
```

### 2. Defect Summary

```
CHECK defect-log.md:
- [ ] No P0 (Critical) defects open
- [ ] No P1 (High) defects open
- [ ] P2/P3 documented as known issues (if any)
```

### 3. Documentation Check

```
VERIFY exists and complete:
- [ ] planning-handoff.md
- [ ] development-handoff.md
- [ ] audit-handoff.md
- [ ] defect-log.md (all resolved)
- [ ] validation-handoff.md
```

### 4. Generate Release Certificate

Use **Display Template** from `the active council rules file` to show: Release Certificate

---

## Usage

```
/release
/release v1.0.0
```

## Agent Invocations

### Agent: sdlc-gate-keeper
Invoke via Agent tool with `subagent_type: "sdlc-gate-keeper"`:
- **Provide**: All gate statuses from project-context.md, defect summary from defect-log.md, documentation checklist
- **Request**: Perform final release verification confirming all gates passed, no P0/P1 defects open, and all handoff documents exist
- **Apply**: Gate verification determines whether the Release Certificate is generated or release is blocked

### Agent: sdlc-operations
Invoke via Agent tool with `subagent_type: "sdlc-operations"`:
- **Provide**: Release version, deployment guide, rollback procedures, monitoring configuration
- **Request**: Validate release checklist including deployment readiness, monitoring setup, and operational runbook completeness
- **Apply**: Include operations validation in the Release Certificate
