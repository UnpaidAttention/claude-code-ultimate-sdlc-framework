---
name: planning-gate-8
description: |
  Verify Planning Gate 8 criteria. Final gate before transitioning to Development Council.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/completeness-matrix/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/handoff-protocols/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/systematic-evaluation/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /planning-gate-8 - Gate 8 Verification

## Lens / Skills / Model
**Lens**: `[Architecture]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per council-planning.md

## Prerequisites

- Phase 8 (Launch Ready) must be complete
- planning-handoff.md must exist

If prerequisites not met:
```
Phase 8 not complete. Run /planning-phase-8 first.
```

---

## Purpose

Gate 8 is the **FINAL** Planning Council gate. Passing this gate:
1. Certifies planning is complete
2. Transitions control to Development Council
3. Locks planning artifacts (changes require formal process)

This is a **BLOCKING** gate - development cannot begin without passing.

---

## Workflow

### Step 1: Gate Criteria Checklist

Verify each criterion:

#### Criterion 1: All Phases Complete
- [ ] Phase 1 (Discovery): Complete
- [ ] Phase 1.5 (Deliberation): Complete
- [ ] Phase 2 (Architecture): Complete
- [ ] Phase 3 (Features): Complete
- [ ] Phase 3.5 (AIOU Decomposition): Complete
- [ ] Gate 3.5: Passed
- [ ] Phases 4-7 (Supporting Specs): Complete
- [ ] Phase 8 (Launch Ready): Complete

#### Criterion 2: Artifacts Complete
- [ ] All FEAT-XXX specs exist
- [ ] All AIOU-XXX specs exist
- [ ] All ADRs exist
- [ ] Wave summary exists
- [ ] planning-handoff.md exists

#### Criterion 3: Quality Standards
- [ ] All features have acceptance criteria
- [ ] All AIOUs are testable
- [ ] No critical open questions
- [ ] Security requirements documented
- [ ] Test strategy defined

#### Criterion 4: Handoff Completeness
- [ ] planning-handoff.md contains all required sections
- [ ] All referenced files exist
- [ ] Technology stack clearly defined
- [ ] Sprint timeline reasonable

### Step 2: Generate Gate Report

Use **Display Template** from `council-planning.md` to show: Gate 8 Verification Report

### Step 3: Gate Decision

**If ALL criteria pass:**

1. Update `.ultimate-sdlc/project-context.md`:
   - Set `Planning Council`: Complete
   - Set `Gate 8`: Passed
   - Set `Active Council`: development (ready)

2. Update `.ultimate-sdlc/council-state/planning/current-state.md`:
   - Mark Gate 8 passed with timestamp

3. Display:

Use **Display Template** from `council-planning.md` to show: Gate 8: PASSED

**If ANY criterion fails:**

Use **Display Template** from `council-planning.md` to show: Gate 8: FAILED

If FAIL:
1. Update `.ultimate-sdlc/council-state/planning/WORKING-MEMORY.md`:
   - Document issues found
   - Track what needs fixing

---
