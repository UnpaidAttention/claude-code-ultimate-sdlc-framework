---
name: sdlc-planning-phase-3-5
description: |
  Execute Planning Phase 3.5 - AIOU Decomposition. Break features into Atomic Independently Ownable Units and assign to development waves.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/aiou-decomposition/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/dependency-management/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/wave-assignment/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /planning-phase-3-5 - AIOU Decomposition

## Lens / Skills / Model
**Lens**: `[Architecture]` | **Model**: Claude Opus 4
> Apply RARV cycle, session protocol per council-planning.md

## Prerequisites

- Phase 3 (Features) must be complete
- All FEAT-XXX specifications created

If prerequisites not met:
```
Phase 3 not complete. Run /planning-phase-3 first.
```

---

## Workflow

### Step 1: Update Project State

Update `.ultimate-sdlc/project-context.md`:
- Set `Active Council`: planning
- Set `Current Phase`: 3.5 - AIOU Decomposition
- Set `Status`: in_progress

### Step 2: Review Feature Specs

Read feature specifications:
- `specs/scope-lock.md` — canonical feature list
- `.ultimate-sdlc/council-state/planning/planning-tracker.md` — batch assignments (if batched)
- All `specs/features/FEAT-XXX.md` files (or current batch's FEAT files if batched)

**Scope Verification**: Every feature in scope-lock.md must have a FEAT spec. If any are missing, STOP and return to Phase 3.

**Batch Awareness**: If `planning-tracker.md` exists, identify the current batch. Decompose ONLY features assigned to the current batch. Complete ALL features in the batch before stopping.

### Step 2B: Generate Cross-Cutting Product Requirements

> **Governance check**: If `lightweight`, SKIP. If `standard` or `enterprise`, MANDATORY.

1. Read `templates/prd-crosscutting-template.md` for required structure
2. Read ALL `specs/features/FEAT-XXX.md` files
3. Read `product-concept.md` (Organizational Context, Constraints sections)
4. Generate `specs/prd-crosscutting.md`:
   - **Section 1 (NFRs)**: Synthesize performance, scalability, availability, security, compliance, accessibility, browser support, and i18n requirements from across all FEAT specs and product-concept constraints. Resolve conflicts (if FEAT-001 says <200ms and FEAT-005 says <500ms, use the stricter threshold).
   - **Section 2 (AI/ML)**: Consolidate all AI-powered features across FEAT specs. Define quality thresholds, fallback behavior, prompt management, and cost budget.
   - **Section 3 (Integrations)**: Consolidate all external system integrations. Define rate limits, error handling, and fallback behavior per integration.
   - **Section 4 (Release Phasing)**: Map FEAT-XXX specs to release phases per product-concept priorities.
   - **Section 5 (Open Questions)**: Aggregate unanswered questions from all FEAT specs.
5. Present summary to user for review of NFR targets
6. Update WORKING-MEMORY.md

### Step 3: Decompose into AIOUs

For each feature in scope-lock.md (or current batch if batched), create AIOUs in `specs/aious/`. Every feature gets thorough decomposition — no feature receives abbreviated treatment.

**AIOU Criteria:**
- **Atomic**: Single responsibility, cannot be split further meaningfully
- **Independent**: Can be developed without other incomplete AIOUs
- **Ownable**: One developer can complete it
- **Testable**: Clear completion criteria

**AIOU Format** (`specs/aious/AIOU-XXX.md`):

Use **Display Template** from `council-planning.md` to show: AIOU-XXX: [Unit Name]

After the Acceptance Criteria section of each AIOU spec, include when applicable:

### Security Test Scenarios (if AIOU handles user input, auth, or sensitive data)
- [ ] [Injection attempt test: describe what malicious input to test]
- [ ] [Auth bypass test: describe unauthorized access attempt]
- [ ] [Data leakage test: describe what should NOT appear in response/logs]

### Step 4: Wave Assignment

Assign each AIOU to a development wave:

| Wave | Focus | AIOU Types |
|------|-------|------------|
| 0 | Types & Interfaces | Type definitions, interfaces, contracts |
| 1 | Utilities & Helpers | Shared utilities, helper functions |
| 2 | Data Layer | Models, repositories, migrations |
| 3 | Services | Business logic, service layer |
| 4 | API Layer | Controllers, routes, middleware |
| 5 | UI Components | Frontend components, pages |
| 6 | Integration | E2E integration, final assembly |

### Step 5: Dependency Validation

Verify:
- No circular dependencies
- Wave N AIOUs only depend on Wave < N
- Critical path is reasonable

### Step 5.5: Generate Feature Connectivity Matrix

Create `specs/connectivity-matrix.md` documenting every cross-feature interaction identified during Phase 2.5 deep-dives:

```markdown
# Feature Connectivity Matrix

## Cross-Feature Interactions

| # | Feature A | Feature B | Interaction Type | Shared Component/Data | Verification Method |
|---|-----------|-----------|-----------------|----------------------|---------------------|
| 1 | [Feature-ID] | [Feature-ID] | Data sharing / UI integration / Shared component / Event | [what is shared] | [how to verify] |

## Shared Components Map

| Component | Used By Features | Wave | Notes |
|-----------|-----------------|------|-------|
| [name] | [Feature-ID list] | [wave] | [implementation notes] |

## Isolated Features

Features with no cross-feature dependencies (verified from deep-dive Section 5):
- [Feature-ID]: [Feature Name] — operates independently
```

**Source**: Aggregate cross-feature integration points from all `specs/deep-dives/DIVE-XXX.md` Section 5 entries.

**Completeness Check**: Every feature in `specs/scope-lock.md` must appear at least once in the matrix — either in a cross-feature interaction row or in the Isolated Features list.

### Step 6: Create Wave Summary

Create `specs/wave-summary.md`:

Use **Display Template** from `council-planning.md` to show: Wave Summary

### Step 6B: Generate API Design Specification

> **Governance check**: If `lightweight`, SKIP. If `standard` or `enterprise`, MANDATORY.

1. Read `templates/api-specification-template.md` for required structure
2. Read ALL `specs/features/FEAT-XXX.md` — extract "API Requirements" / "API Contracts" sections
3. Read `specs/architecture/database-design.md` — data model informs response schemas
4. Read relevant ADRs (API style, auth approach)
5. Generate `specs/architecture/api-specification.md`:
   - **Section 1 (Principles)**: Naming, versioning, pagination, filtering conventions per ADRs
   - **Section 2 (Auth)**: Auth flow, header format, role-based access per security ADR
   - **Section 3 (Endpoints)**: For EACH API endpoint across ALL FEAT specs: HTTP method + path, auth requirement, request schema, response schemas for ALL status codes (200, 400, 401, 403, 404, 500). Group by module/domain.
   - **Section 4 (WebSocket)**: If any FEAT spec requires real-time features
   - **Section 5 (Error Handling)**: Standard error envelope + error code registry
   - **Section 6 (Webhooks)**: If any FEAT spec requires outbound notifications
   - **Traceability table**: Map every endpoint to its FEAT-XXX and AIOU-XXX
6. Cross-reference: Verify every FEAT spec's API requirements appear in the specification
7. Update WORKING-MEMORY.md

### Step 7: Phase Completion Criteria

**If batched** (planning-tracker.md exists):

Before completing the current batch, verify:
- [ ] All features in current batch decomposed into AIOUs
- [ ] All AIOUs have acceptance criteria
- [ ] All AIOUs assigned to waves
- [ ] No circular dependencies within batch
- [ ] Wave assignments follow layer order
- [ ] Update planning-tracker.md: mark current batch features as AIOUs ✅
- [ ] **Count check**: Every FEAT in current batch has ≥1 AIOU
- [ ] Connectivity matrix updated with this batch's cross-feature interactions
- [ ] PRD cross-cutting specs created (or N/A if Lightweight)
- [ ] API specification created with all endpoints (or N/A if Lightweight)
- [ ] API endpoint ↔ FEAT traceability table complete

After completing a batch: **STOP** and notify user. Display:
```
Batch [N] of [total] complete (FEAT specs + AIOU decomposition).
Features decomposed this batch: [count]
AIOUs created this batch: [count]
Total features completed so far: [count] / [total in scope-lock.md]
Remaining batches: [count]

Run `/continue` to advance to the next batch, or `/planning-phase-3-5` to proceed directly.
```

**If NOT batched** (all features in single pass):

Before completing this phase, verify:
- [ ] All features in scope-lock.md decomposed into AIOUs
- [ ] All AIOUs have acceptance criteria
- [ ] All AIOUs assigned to waves
- [ ] No circular dependencies
- [ ] Wave assignments follow layer order
- [ ] Wave summary created
- [ ] Connectivity matrix created with all features represented
- [ ] **Count check**: Every feature in scope-lock.md has ≥1 AIOU
- [ ] PRD cross-cutting specs created (or N/A if Lightweight)
- [ ] API specification created with all endpoints (or N/A if Lightweight)
- [ ] API endpoint ↔ FEAT traceability table complete

### Step 8: Complete Phase

When all criteria met (all batches complete, or single pass complete):

1. **Final scope verification**: For every feature in `specs/scope-lock.md`, verify at least one AIOU-XXX.md exists in `specs/aious/` that references it. If any feature has zero AIOUs → STOP and decompose the missing features.

2. Create `specs/wave-summary.md` (after all batches complete):

Use **Display Template** from `council-planning.md` to show: Wave Summary

3. Update `.ultimate-sdlc/project-context.md`:
   - Set Phase 3.5 status: Complete

4. Update `.ultimate-sdlc/council-state/planning/WORKING-MEMORY.md`:
   - Mark completed tasks
   - Record session learnings

5. Record metrics in `.metrics/tasks/planning/`

6. Display completion message:

Use **Display Template** from `council-planning.md` to show: Phase 3.5: AIOU Decomposition - Complete

---
