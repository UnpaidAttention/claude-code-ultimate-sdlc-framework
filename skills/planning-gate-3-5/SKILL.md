---
name: sdlc-planning-gate-3-5
description: |
  Verify Planning Gate 3.5 criteria. All features must be decomposed into AIOUs with wave assignments before proceeding.
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
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/aiou-decomposition/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/systematic-evaluation/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


# /planning-gate-3-5 - Gate 3.5 Verification

## Lens / Skills / Model
**Lens**: `[Architecture]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per council-planning.md

## Prerequisites

- Phase 3.5 (AIOU Decomposition) must be complete

If prerequisites not met:
```
Phase 3.5 not complete. Run /planning-phase-3-5 first.
```

---

## Purpose

Gate 3.5 ensures all features are properly decomposed before investing in security, testing, and infrastructure planning. This is a **BLOCKING** gate - development cannot begin without passing.

---

## Workflow

### Step 1: Load Gate 3.5 Criteria

Load criteria from `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/gate-criteria.md` § Planning Council Gates → Gate 3.5.

### Agent: sdlc-gate-keeper
Invoke via Agent tool with `subagent_type: "sdlc-gate-keeper"`:
- **Provide**: Gate 3.5 criteria from gate-criteria.md, scope-lock.md, all FEAT-XXX specs, all AIOU-XXX specs, wave-summary.md, connectivity-matrix.md, PRD cross-cutting specs, API specification
- **Request**: Verify ALL Gate 3.5 criteria — every feature has AIOUs, all AIOUs have acceptance criteria and wave assignments, no circular dependencies, FEAT-to-AIOU traceability complete, connectivity matrix covers all features. Return PASS/FAIL with detailed findings per criterion.
- **Apply**: Use gate-keeper's verdict as the authoritative gate decision. If FAIL, address cited gaps before re-evaluation.

Verify each criterion against the authoritative checklist. Run automated checks where applicable.

### Step 2: Generate Gate Report

Use **Display Template** from `council-planning.md` to show: Gate 3.5 Verification Report

### Step 3: Gate Decision

**If ALL criteria pass:**

```
## Gate 3.5: PASSED

All features properly decomposed into AIOUs with valid wave assignments.

**Next Step**: Run `/planning-supporting-specs` to continue to Supporting Specifications (Security, Testing, Infrastructure, Sprint Planning)
```

**If ANY criterion fails:**

Use **Display Template** from `council-planning.md` to show: Gate 3.5: FAILED

### Step 4: Update State

If PASS:
1. Update `.ultimate-sdlc/project-context.md`:
   - Set Gate 3.5: Passed

2. Update `.ultimate-sdlc/council-state/planning/current-state.md`:
   - Mark Gate 3.5 passed with timestamp

If FAIL:
1. Update `.ultimate-sdlc/council-state/planning/WORKING-MEMORY.md`:
   - Document issues found
   - Track what needs fixing

---
