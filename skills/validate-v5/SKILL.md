---
name: sdlc-validate-v5
description: |
  Execute Validation Track V5 - Correction Planning. Create detailed correction plan for identified gaps.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/correction-planning/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/prioritization/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/tdd-methodology/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/systematic-evaluation/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /validate-v5 - Correction Planning

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Opus 4.5
> Apply RARV cycle, session protocol per council-validation.md

## Prerequisites

- V4 (Prerequisite Verification) must be complete

If prerequisites not met:
```
V4 not complete. Run /validate-v4 first.
```

---

## Workflow

### Step 1: Update Project State

Update `.ultimate-sdlc/project-context.md`:
- Set `Current Phase`: V5 - Correction Planning
- Set `Status`: in_progress

### Agent: planner
Invoke via Agent tool with `subagent_type: "sdlc-planner"`:
- **Provide**: Gap report from V2, completeness matrix from V3, defect log, verification results from V4
- **Request**: Prioritize corrections — score each by user impact, technical risk, effort, and dependencies; create sequenced correction plan with dependency ordering
- **Apply**: Use planner's prioritized output as the correction plan for the C-track

### Step 2: Prioritize Corrections

Score each correction:

| Factor | Weight |
|--------|--------|
| User Impact | 40% |
| Technical Risk | 30% |
| Effort Required | 20% |
| Dependencies | 10% |

Create priority ranking:
Use **Display Template** from `council-validation.md` to show: Correction Priority

### Step 3: Create Correction Plan

For each correction, document:

Use **Display Template** from `council-validation.md` to show: Correction: [Name]

### Step 4: Phase Completion Criteria

- [ ] All corrections prioritized
- [ ] Correction plan documented
- [ ] Testing requirements identified
- [ ] Ready for correction track

### Step 5: Complete Phase

Use **Display Template** from `council-validation.md` to show: V5: Correction Planning - Complete

---
