---
name: sdlc-planning-phase-1-5
description: |
  Execute Planning Phase 1.5 - Deliberation. Multi-perspective evaluation of requirements to consolidate complete feature list, verify coverage, and confirm scope with user.
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
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/multi-perspective-analysis/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/risk-assessment/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/decision-making/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


<!-- NOTE: Command uses hyphens for consistency: /planning-phase-1-5 
     The aliases field accepts /planning-phase-1.5 as equivalent input. -->

# /planning-phase-1-5 - Deliberation

## Lens / Skills / Model
**Lens**: `[Requirements]` | **Model**: Claude Opus 4
> Apply RARV cycle, session protocol per council-planning.md

## Prerequisites

- Phase 1 (Discovery) must be complete
- Requirements documented in specs/ or .ultimate-sdlc/project-context.md

If prerequisites not met:
```
Phase 1 not complete. Run /planning-start first.
```

---

## Workflow

### Step 1: Update Project State

Update `.ultimate-sdlc/project-context.md`:
- Set `Active Council`: planning
- Set `Current Phase`: 1.5 - Deliberation
- Set `Status`: in_progress

### Step 2: Review Discovery Outputs

Read and understand:
- All requirements from Phase 1
- User personas and needs
- Constraints and limitations
- Success criteria

### Step 3: Feature Candidate Consolidation (THOROUGHNESS PROTOCOL)

**MANDATORY**: Before scope confirmation, ensure ALL features are captured. Every feature in the product concept must be identified — no exceptions.

**Step 3a: Consolidate Discovery Output**
- Import ALL features identified in Phase 1
- Number each feature for tracking
- Do NOT filter or prioritize yet - capture everything

**Step 3b: Dependency Analysis**
For each feature, ask:
- What other features must exist for this to work?
- Add any missing dependencies to the list
- Document the dependency relationships

### Agent: sdlc-requirements
Invoke via Agent tool with `subagent_type: "sdlc-requirements"`:
- **Provide**: All features from Step 3a, original product concept, user personas
- **Request**: Perform requirements gap analysis — identify missing functional areas, implicit requirements, dependency gaps, and cross-cutting concerns not yet captured
- **Apply**: Add any discovered gaps to the feature candidate list before proceeding

### Agent: sdlc-planner
Invoke via Agent tool with `subagent_type: "sdlc-planner"`:
- **Provide**: Complete feature candidate list from Steps 3a-3b, project type, constraints
- **Request**: Consolidate and deduplicate feature list, group by module/domain, verify completeness against project type preset categories
- **Apply**: Use consolidated list as the authoritative feature candidate set for user confirmation

**Step 3c: Gap Analysis Against Concept**
Re-read the original product concept with fresh eyes:
- Highlight every noun (potential entity/feature)
- Highlight every verb (potential action/feature)
- Cross-reference against current feature list
- Add any missing items

**Step 3d: "What's Missing?" Structured Review**

Answer these questions explicitly and document features for each:
1. How does a user first access the system? (Features: ___)
2. How does a user recover from errors? (Features: ___)
3. How does a user get help? (Features: ___)
4. How does an admin manage the system? (Features: ___)
5. How is data backed up/restored? (Features: ___)
6. How are updates/changes communicated? (Features: ___)
7. What happens at scale? (Features: ___)
8. What security measures protect users? (Features: ___)

**Step 3e: Feature Count Verification**

| Check | Count |
|-------|-------|
| Features explicitly mentioned in product concept | ___ |
| Features from user journeys | ___ |
| Features from standard categories review | ___ |
| Features from dependency analysis | ___ |
| **Total feature candidates** | ___ |

### Step 4: User Scope Confirmation (MANDATORY STOP)

**CRITICAL**: You MUST present the complete feature list to the user and STOP for confirmation. Do NOT proceed without explicit user approval.

Present to the user:

```markdown
## Feature Scope Confirmation

**Total features identified**: [count from Step 3e]

| # | Feature Name | Source |
|---|-------------|--------|
| 1 | [name] | Product concept / Gap analysis / Dependency / Category review |
| 2 | ... | ... |
| ... | ... | ... |

**Default**: ALL features above are in scope and will receive full planning
through all phases (Architecture, Feature Specs, AIOU Decomposition,
Supporting Specs, and Handoff).

**If you want to exclude any features**, list them now with your reason.
Otherwise, confirm "all in scope" to proceed.
```

**Wait for user response.** Do NOT proceed until the user confirms.

- If user confirms all in scope → proceed with all features
- If user excludes specific features → document exclusions with user's stated reasons in `specs/features/feature-candidates.md`, remove from scope, proceed with remaining features
- If user wants to add features → add them to the list, re-present for confirmation

**PROHIBITED** (per PRH-007): Suggesting features to exclude, applying MoSCoW or priority categorization, implying some features are less important, using terms like "MVP", "core", "future phase", or "nice to have."

### Step 5: Risk Assessment

For each in-scope feature:
- Technical risk (complexity, unknowns)
- Resource risk (time, skills needed)
- Dependency risk (external factors)

### Step 5.5: Feature Complexity Classification (MANDATORY)

Classify each in-scope feature to inform analysis depth and batch grouping:

**Classification Criteria:**

| Factor | Simple (1pt) | Moderate (2pt) | Complex (3pt) |
|--------|-------------|----------------|---------------|
| UI Surfaces | 1 screen/component | 2-3 screens | 4+ screens or multi-step wizard |
| Data Entities | 0-1 entities | 2-3 entities | 4+ entities or complex relationships |
| Integration Points | None | 1-2 internal | External APIs or 3+ internal |
| Business Logic | Basic CRUD | Conditional logic | State machines, workflows, calculations |
| User Interactions | View/click | Forms, filters | Real-time, drag-drop, multi-step flows |

**Scoring:**
- 5-7 points: **Simple**
- 8-11 points: **Moderate**
- 12-15 points: **Complex**

**ALL features receive the full Feature Deep-Dive Analysis in Phase 2.5.** The classification informs batch grouping (keep Complex features in smaller batches) and development run prioritization.

**Output:** Add `Complexity` column to scope-lock.md.

### Step 6: Batch Planning (if applicable)

If total in-scope features ≥8, create `.ultimate-sdlc/council-state/planning/planning-tracker.md` per the schema in `council-planning.md § Planning Batch Mode`:
1. Group features into batches of 3-5 by module/domain
2. Present batch groupings to user for review
3. Document batch assignments in planning-tracker.md

If total in-scope features <8, skip this step (no batching needed).

### Step 7: Anti-Truncation Declaration (MANDATORY)

Before completing this phase, sign the following declaration:

```markdown
## Anti-Truncation Declaration

I confirm that:
- Every feature in the product concept has been identified
- The complete feature list was presented to the user for scope confirmation
- The user explicitly confirmed which features are in scope
- No features were excluded without the user's explicit direction
- Total features in scope: [count]
- Total features excluded by user: [count] (reasons documented)

Signed: [AI model] | Timestamp: [ISO 8601]
```

### Step 8: Phase Completion Criteria

Before completing this phase, verify:
- [ ] All features from product concept identified and numbered
- [ ] Complete feature list presented to user
- [ ] **User explicitly confirmed scope** (not AI-determined)
- [ ] Feature count from Step 3e matches confirmed scope + user exclusions
- [ ] Risks identified and documented
- [ ] All features classified by complexity (Simple/Moderate/Complex)
- [ ] Batch plan created (if ≥8 features)
- [ ] **Anti-truncation declaration signed**

### Step 9: Complete Phase

When all criteria met:

1. Update `.ultimate-sdlc/project-context.md`:
   - Set Phase 1.5 status: Complete

2. Update `.ultimate-sdlc/council-state/planning/WORKING-MEMORY.md`:
   - Mark completed tasks
   - Record session learnings
   - **Record total feature count and user-confirmed scope**

3. Record metrics in `.metrics/tasks/planning/`

4. Save feature candidates to `specs/features/feature-candidates.md`:
   - Include complete numbered list of ALL identified features
   - Mark each as: IN SCOPE (user confirmed) or EXCLUDED (user directed, with reason)
   - Include anti-truncation declaration

5. Display completion message:

Use **Display Template** from `council-planning.md` to show: Phase 1.5: Deliberation - Complete

---
