---
name: sdlc-planning-phase-3
description: |
  Execute Planning Phase 3 - Features. Create detailed feature specifications (FEAT-XXX) with acceptance criteria.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/feature-spec/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/requirements-engineering/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/acceptance-criteria/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /planning-phase-3 - Features

## Lens / Skills / Model
**Lens**: `[Architecture]` + `[Quality]` | **Model**: Claude Opus 4
> Apply RARV cycle, session protocol per `council-planning.md`

This phase uses two lenses in sequence to ensure both functional and technical requirements are robust.

---

## Prerequisites

- Phase 2 (Architecture) must be complete
- System architecture defined
- ADRs created

If prerequisites not met:
```
Phase 2 not complete. Run /planning-phase-2 first.
```

---

## Workflow

### Step 1: Update Project State

Update `.ultimate-sdlc/project-context.md`:
- Set `Active Council`: planning
- Set `Current Phase`: 3 - Features
- Set `Status`: in_progress

### Step 2: Review Inputs

Read and understand:
- `specs/scope-lock.md` — the canonical list of ALL features to be planned
- `specs/deep-dives/DIVE-*.md` — Deep-dive analysis for all features (from Phase 2.5)
- `.ultimate-sdlc/council-state/planning/planning-tracker.md` — batch assignments (if batched)
- Architecture from Phase 2
- ADRs for technical constraints

**Scope Verification**: Count features in scope-lock.md. This is the number of FEAT specs that must be produced. No exceptions.

**Batch Awareness**: If `planning-tracker.md` exists, identify the current batch. Work ONLY on features assigned to the current batch. Complete ALL features in the batch before stopping.

### Step 3a: Draft Feature Specifications (Lens: `[Requirements]`)

**Lens**: `[Requirements]`

**Action Required**:
1. Apply `[Requirements]` lens from `~/.claude/skills/ultimate-sdlc/agents/`
2. APPLY the agent's domain expertise: Use "Core Principles" for decisions, "When to Use" for scope. Ignore personality descriptions. Framework rules (P0-P3) override agent guidelines..
3. LOAD the skills specified in the `skills_required` section of this workflow's frontmatter.
4. PROCEED to Step 1 after loading..

**Task**:
For each feature in `specs/scope-lock.md` (or current batch if batched), create a draft `specs/features/FEAT-XXX.md`. The focus is on capturing the user and business perspective. Every feature gets the same depth of specification — no feature receives abbreviated treatment regardless of perceived complexity or importance.

**Deep-Dive Integration**: For each feature, read its `specs/deep-dives/DIVE-XXX.md` and:
- Import Component Inventory into FEAT spec sections 4 (Data) and 6 (UI) and new section 9
- Import User Journey Map into section 2 (User Stories)
- Import Cross-Feature Integration Points into section 8 (Dependencies)
- Import Prerequisite Components into section 8 (Dependencies)
- Import Navigation & Placement into new section 10
- The deep-dive is the AUTHORITATIVE source — do not simplify or abbreviate its content

**Template**:
Use **Display Template** from `council-planning.md` to show: FEAT-XXX: [Feature Name]

### Step 3b: Validate and Refine Specifications (Lens: `[Architecture]`)

**Lens**: `[Architecture]`

**Action Required**:
1. Apply `[Architecture]` lens from `~/.claude/skills/ultimate-sdlc/agents/`
2. APPLY the agent's domain expertise: Use "Core Principles" for decisions, "When to Use" for scope. Ignore personality descriptions. Framework rules (P0-P3) override agent guidelines..
3. LOAD the skills specified in the `skills_required` section of this workflow's frontmatter.
4. PROCEED to Step 1 after loading..

**Task**:
After the drafts are created, review each `FEAT-XXX.md` file. The focus is on technical feasibility and implementation details.

1.  **Review each draft `FEAT-XXX.md` file.**
2.  **Add or refine the `Data Requirements`, `API Requirements`, and `Dependencies` sections.**
    Use **Display Template** from `council-planning.md` to show: Data Requirements
3.  **Add any `Open Questions` regarding technical implementation.**
4.  **Update the status in the file to `Status: Reviewed`.**


### Step 4: Validate INVEST Criteria

For each feature, verify:
- **I**ndependent: Can be developed separately
- **N**egotiable: Details can be discussed
- **V**aluable: Delivers user value
- **E**stimable: Can estimate effort
- **S**mall: Fits in a sprint
- **T**estable: Clear acceptance criteria

### Step 5: Feature Dependencies

Map dependencies between features:
- Which features must be built first?
- Which can be parallelized?
- Critical path identification

### Step 6: Phase Completion Criteria

**If batched** (planning-tracker.md exists):

Before completing the current batch, verify:
- [ ] All features in current batch have FEAT-XXX specs with `Status: Reviewed`
- [ ] All features in current batch have acceptance criteria
- [ ] INVEST criteria validated for current batch
- [ ] Dependencies mapped for current batch
- [ ] Update planning-tracker.md: mark current batch features as FEAT Spec ✅
- [ ] **Count check**: FEAT specs created this batch = features assigned to this batch

After completing a batch: **STOP** and notify user. Display:
```
Batch [N] of [total] complete.
Features spec'd this batch: [count]
Total features spec'd so far: [count] / [total in scope-lock.md]
Remaining batches: [count]

Run `/continue` to advance to the next batch, or `/planning-phase-3` to proceed directly.
```

**If NOT batched** (all features in single pass):

Before completing this phase, verify:
- [ ] All features in scope-lock.md have FEAT-XXX specs with `Status: Reviewed`
- [ ] All features have acceptance criteria
- [ ] INVEST criteria validated
- [ ] Dependencies mapped
- [ ] No orphan requirements
- [ ] **Count check**: Total FEAT-XXX.md files = total features in scope-lock.md

### Step 7: Complete Phase

When all criteria met (all batches complete, or single pass complete):

1. **Final scope verification**: Count FEAT-XXX.md files in `specs/features/`. This count MUST equal the feature count in `specs/scope-lock.md`. If mismatch → STOP and identify missing features.

2. Update `.ultimate-sdlc/project-context.md`:
   - Set Phase 3 status: Complete

3. Update `.ultimate-sdlc/council-state/planning/WORKING-MEMORY.md`:
   - Mark completed tasks
   - Record session learnings

4. Record metrics in `.metrics/tasks/planning/`

5. Display completion message:

Use **Display Template** from `council-planning.md` to show: Phase 3: Features - Complete

---
