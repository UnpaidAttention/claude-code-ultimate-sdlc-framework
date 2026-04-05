---
name: sdlc-audit-a2
description: |
  Execute Audit Track A2 - Completeness. Gap analysis and missing functionality assessment.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/completeness-matrix/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/gap-analysis/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/systematic-evaluation/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /audit-a2 - Completeness

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Opus 4
> Apply RARV cycle, session protocol per `council-audit.md`

## Prerequisites

- A1 (Purpose Alignment) must be complete

If prerequisites not met:
```
A1 not complete. Run /audit-a1 first.
```

---

## Workflow

### Step 1: Update Project State

Update `.ultimate-sdlc/project-context.md`:
- Set `Current Phase`: A2 - Completeness
- Set `Status`: in_progress

### Step 2: Feature Completeness Matrix

| Feature | Specified | Implemented | Complete | Notes |
|---------|-----------|-------------|----------|-------|
| FEAT-001 | Yes | Yes | [%] | [Notes] |
| FEAT-002 | Yes | Partial | [%] | [Missing items] |

### Step 3: Acceptance Criteria Verification

For each feature:
- [ ] All acceptance criteria met
- [ ] Edge cases handled
- [ ] Error scenarios covered

### Step 3a: Security Requirements Verification

Read `specs/security/threat-model.md` and verify implementation:

| Threat | Planned Mitigation | Implemented? | Evidence |
|--------|-------------------|-------------|----------|
| [From STRIDE] | [From threat model] | YES/NO | [File:line or test name] |

Read AIOU security annotations (added in Planning Phase 4 Step A5) and verify:

| AIOU | Security Requirement | Implemented? | Evidence |
|------|---------------------|-------------|----------|
| AIOU-XXX | [Requirement] | YES/NO | [File:line or test name] |

**PASS criteria**: 100% of planned security mitigations implemented. 100% of AIOU security requirements implemented. Any gaps -> log as SEC-HIGH defect.

### Step 4: Gap Analysis

Document gaps:

Use **Display Template** from `council-audit.md` to show: Gap Report

### Step 5: Phase Completion Criteria

- [ ] All features verified against specs
- [ ] Acceptance criteria checked
- [ ] Gap analysis complete
- [ ] Missing functionality documented

### Step 6: Complete Phase

Use **Display Template** from `council-audit.md` to show: A2: Completeness - Complete

---
