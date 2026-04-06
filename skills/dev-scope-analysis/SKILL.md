---
name: sdlc-dev-scope-analysis
description: |
  Analyze AIOU scope and create run division plan for development. Executes after planning complete, before /dev-start.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/requirements-engineering/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/planning-orchestration/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /dev-scope-analysis - Development Run Division Planning

## Purpose

Analyze the AIOUs from planning-handoff.md to determine if development should be divided into multiple runs. Creates `.ultimate-sdlc/council-state/development/run-tracker.md` to track run progress.

**Core Principle**: "Do it right, or do it twice." - Large development efforts divided into manageable runs prevent AIOU truncation and ensure complete implementation.

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Opus 4
> Apply RARV cycle, session protocol, code review protocol per `council-development.md`

## Prerequisites

- Planning Council complete
- Gate 8 PASSED
- `handoffs/planning-handoff.md` exists with AIOU summary
- All AIOU specs exist in `specs/aious/`

If prerequisites not met:
```
Development scope analysis requires Planning Council complete.
Run /planning-gate-8 first to verify planning is ready for development.
```

---

## Workflow

### Step 1: Load AIOU Data

1. Read `handoffs/planning-handoff.md`
2. Extract all AIOUs from AIOU Summary by Wave section
3. For each AIOU, read `specs/aious/AIOU-XXX.md` to get size (XS/S/M/L)
4. Count total AIOUs and sizes

**Record**:
```
Total AIOUs: [X]
Size Distribution:
- XS: [n] AIOUs
- S: [n] AIOUs
- M: [n] AIOUs
- L: [n] AIOUs
```

### Step 2: Calculate Effort Units

Apply effort unit calculation:
- XS = 1 unit
- S = 2 units
- M = 4 units
- L = 8 units

**Calculate**:
```
Total Effort Units: (XS × 1) + (S × 2) + (M × 4) + (L × 8) = [Total]
```

Create effort assessment table:

| Feature | AIOUs | Size Distribution | Total Effort |
|---------|-------|-------------------|--------------|
| FEAT-001 | 5 | 2×S, 2×M, 1×L | 20 units |
| FEAT-002 | 3 | 1×XS, 2×S | 5 units |
| ... | ... | ... | ... |

### Step 3: Determine Run Division

Reference `.reference/scope-analysis-guide.md` for heuristics.

**Apply sizing rules**:

| Total Effort | Target Per Run | Resulting Runs |
|--------------|----------------|----------------|
| < 30 units | All in one run | 1 run |
| 30-60 units | ~20-25 units | 2-3 runs |
| 60-120 units | ~25-30 units | 3-5 runs |
| 120-250 units | ~30-40 units | 4-7 runs |
| 250+ units | ~35-45 units | 7-10 runs |

**Calculate**:
```
Total Effort Units: [X]
Target Effort Per Run: [Y]
Calculated Runs: [X / Y] = [N] runs
```

**Constraints check**:
- Minimum AIOUs per run: 3
- Maximum AIOUs per run: 15
- Maximum effort per run: 45 units
- Maximum L-sized AIOUs per run: 2
- Maximum total runs: 10
- Wave integrity: AIOUs of same wave should stay together when possible

### Step 4: Group AIOUs Into Runs

Group AIOUs following these principles (in priority order):

1. **Feature Cohesion** - Keep all AIOUs for a feature together
2. **Wave Progression** - Earlier waves before later waves
3. **Dependency Chains** - Dependent AIOUs in same run
4. **Balanced Effort** - No run >2x effort of another

**Wave Integrity Rule**: When grouping AIOUs, prioritize keeping AIOUs from the same wave together to maintain parallel execution opportunities.

Create run assignments:

| Run | Feature Focus | AIOUs | Effort Units |
|-----|---------------|-------|--------------|
| Run 1 | Foundation (FEAT-001, FEAT-002) | 10 | 35 |
| Run 2 | Core Features (FEAT-003, FEAT-004) | 12 | 40 |
| ... | ... | ... | ... |

### Step 5: Verify Assignment Completeness

**MANDATORY CHECK**:
- [ ] Every AIOU from planning-handoff.md is assigned to exactly one run
- [ ] No AIOU is duplicated across runs
- [ ] No AIOU is missing from all runs
- [ ] Total AIOUs across all runs = planning-handoff.md AIOU count
- [ ] Every feature has all its AIOUs assigned (no partial feature coverage)

```
AIOU Verification:
- AIOUs in planning-handoff.md: [X]
- AIOUs assigned to runs: [X]
- Match: YES/NO
```

**If NO**: Stop and reassign. Do not proceed with incomplete assignment.

### Step 6: Create Run Tracker

Create `.ultimate-sdlc/council-state/development/run-tracker.md` using template from `.reference/run-tracker-template-development.md`.

Populate:
1. Summary section with totals and size distribution
2. Run Overview table
3. Each run section with:
   - AIOU checklist (all ⏳ initially)
   - Wave progress table (all ⏳ initially, including UI-V column)
   - Gate status (all ⏳ initially)
   - Test summary (all ⏳ initially)
   - Completion verification checklist (all unchecked)
4. **If project has frontend** (`project_type` is web-app or mobile-app): UI Design Phases section with UI-R, UI-P, and per-run UI-V tracking (all ⏳ initially)
5. Global Integrity Check section (leave blank)

### Step 7: Present Summary for Confirmation

Display to user:

Use **Display Template** from `council-development.md` to show: Development Scope Analysis Complete

### Step 8: Handle Single-Run Projects

If calculated runs = 1:

Use **Display Template** from `council-development.md` to show: Development Scope Analysis Complete

Still create run-tracker.md with a single run for consistency and verification.

### Step 9: Update Project State

1. Update `.ultimate-sdlc/project-context.md`:
   - Note scope analysis complete
   - Record run count and total effort

2. Update `.ultimate-sdlc/council-state/development/WORKING-MEMORY.md`:
   - Record scope analysis results
   - Note run assignments

3. Create `.ultimate-sdlc/council-state/development/` directory if doesn't exist

4. Display completion:

```
Development scope analysis complete. Run tracker created.
Run `/dev-start` to begin Run 1.
```

---

## Run Division Algorithm

When total effort exceeds single-run limits (>15 AIOUs OR >45 effort units), divide into runs:

### Step 1: Calculate Total Effort
For each AIOU, sum effort using: XS=1, S=2, M=4, L=8, XL=16.
If total_effort ≤ 45 AND total_AIOUs ≤ 15: **Single run**. Skip to Step 5.

### Step 2: Group by Feature
Group AIOUs by parent FEAT-XXX. A feature's AIOUs should stay together in the same run.

### Step 3: Order Groups
Sort feature groups by earliest wave assignment (features with Wave 0 AIOUs first).
Within same wave: sort by dependency order (features with no dependencies first).

### Step 4: Pack into Runs
Initialize Run 1. For each feature group (in sorted order):
- If adding this group would exceed 15 AIOUs OR 45 effort units → start new Run
- Add group to current run
- **Exception**: If a single feature exceeds 15 AIOUs, it gets its own dedicated run. Flag for user review — the feature may need further AIOU decomposition.

### Step 5: Validate Dependencies
For each cross-run dependency (AIOU-A in Run N depends on AIOU-B in Run M):
- Verify M < N (dependency run must execute first)
- If circular dependency across runs: merge the two runs into one

### Step 6: Generate run-tracker.md
Output run assignments with:
- Run number, assigned features, AIOU checklist per run
- Effort total per run
- Cross-run dependencies noted
- Expected wave coverage per run

---

## Output Files

| File | Purpose |
|------|---------|
| `.ultimate-sdlc/council-state/development/run-tracker.md` | Tracks run progress, AIOU assignments, wave completion |

---

## Error Handling

**If AIOU count mismatch**:
- Stop immediately
- Report: "AIOU count mismatch: [X] in planning-handoff.md, [Y] assigned"
- Do not create run tracker until resolved

**If run count > 10**:
- Report: "Development scope may be too large. Consider splitting into separate phases or incremental releases."
- Recommend reviewing scope with stakeholders

**If feature has partial AIOU coverage**:
- Stop immediately
- Report: "Feature FEAT-XXX has [X] AIOUs in specs but only [Y] assigned to runs"
- Ensure all AIOUs for each feature are assigned before proceeding

**If average effort per AIOU > 6**:
- Report: "Very high effort AIOUs detected. Verify AIOU atomicity - large AIOUs may need decomposition."
- Recommend reviewing AIOU specs

---

## Agent Invocations

### Agent: sdlc-planner
Invoke via Agent tool with `subagent_type: "sdlc-planner"`:
- **Provide**: Planning handoff AIOUs, AIOU specs with sizes, feature dependencies, wave assignments
- **Request**: Calculate effort units, determine run division, group AIOUs into balanced runs respecting feature cohesion and wave progression
- **Apply**: Use scope and run division results in Steps 2-6 to create the run-tracker.md
