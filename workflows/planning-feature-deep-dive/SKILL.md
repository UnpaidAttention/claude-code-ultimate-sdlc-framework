---
name: planning-feature-deep-dive
description: |
  Execute Planning Phase 2.5 - Feature Deep-Dive Analysis. Structured deep analysis of EVERY feature before FEAT specs are written. Produces component inventories, user journeys, navigation maps, and cross-feature integration points.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/feature-deep-dive/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/requirements-engineering/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/multi-perspective-analysis/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /planning-feature-deep-dive - Feature Deep-Dive Analysis

## Lens / Skills / Model
**Lens**: `[Requirements]` + `[Architecture]` | **Model**: Claude Opus 4
> Apply RARV cycle, session protocol per council-planning.md

## Prerequisites

- Phase 2 (Architecture) must be complete
- `specs/scope-lock.md` must exist with all features listed
- System architecture defined (ADRs from Phase 2)

If prerequisites not met:
```
Phase 2 not complete. Run /planning-phase-2 first.
```

---

## Purpose

This phase forces structured deep analysis of EVERY feature before FEAT specs are written. It ensures no feature is shallowly specified by requiring 7 mandatory analysis sections per feature. The deep-dive output becomes the authoritative source for Phase 3 FEAT specs.

**Process ONE feature at a time.** Each feature receives the full 7-section analysis regardless of complexity classification.

---

## Workflow

### Step 1: Update Project State

Update `.ultimate-sdlc/project-context.md`:
- Set `Active Council`: planning
- Set `Current Phase`: 2.5 - Feature Deep-Dive Analysis
- Set `Status`: in_progress

### Step 2: Review Inputs

Read and understand:
- `specs/scope-lock.md` — canonical feature list with complexity classifications
- `.ultimate-sdlc/council-state/planning/planning-tracker.md` — batch assignments (if batched)
- Architecture from Phase 2 (ADRs, system design)
- `.ultimate-sdlc/project-context.md` — project type and constraints

**Scope Verification**: Count features in scope-lock.md. This is the number of DIVE analyses that must be produced. No exceptions.

**Batch Awareness**: If `planning-tracker.md` exists, identify the current batch. Analyze ONLY features assigned to the current batch. Complete ALL features in the batch before stopping.

### Step 3: Feature Deep-Dive Analysis

For each feature in scope-lock.md (or current batch if batched), create a deep-dive analysis file `specs/deep-dives/DIVE-[Feature-ID].md`.

**Process ONE feature at a time.** Complete all 7 sections for a feature before moving to the next.

---

#### Section 1: Feature Functional Analysis

Document the complete functional behavior of the feature:

**Step-by-Step Flow:**
1. Map the primary functional flow from trigger to completion
2. Document each step with: Action → System Response → State Change
3. Include branching paths (conditionals, error paths)

**Feature States & Transitions:**
- List every state the feature can be in (e.g., idle, loading, active, error, disabled)
- Map transitions between states with triggers
- Document state persistence requirements

**Business Rules:**
- List every business rule that governs this feature's behavior
- Include validation rules, calculation formulas, access control rules
- Document rule exceptions and edge cases

---

#### Section 2: Complete Component Inventory

List EVERY component required to implement this feature. No vague estimates — exact counts.

| # | Component Name | Type | Description | Wave |
|---|---------------|------|-------------|------|
| 1 | [name] | UI Component / Service / API Endpoint / Data Entity / Hook / Validator / Utility | [what it does] | [0-6] |

**Component Categories (enumerate ALL):**
- **UI Components**: Pages, forms, modals, cards, lists, buttons, navigation elements
- **Services**: Business logic services, data transformation services
- **API Endpoints**: REST/GraphQL endpoints with method and path
- **Data Entities**: Database models, schemas, types/interfaces
- **Supporting Components**: Hooks, validators, utilities, middleware, error handlers

**Total Component Count**: ___ (this number must be referenced during development)

---

#### Section 3: UI Placement & Navigation

> Skip this section for non-UI features (backend-only, CLI tools). Mark as "N/A — no UI surface."

- **Route/URL**: Exact path (e.g., `/dashboard/settings/notifications`)
- **Navigation Path**: How user reaches this feature (e.g., Sidebar → Settings → Notifications tab)
- **Parent Page**: Which page/layout contains this feature
- **Access Level**: Who can access (public, authenticated, admin, specific role)
- **Entry Points**: All ways to reach this feature (nav menu, direct URL, link from another feature, notification)
- **Screen Layout Description**: Describe the layout structure (sidebar + main content, full-width, modal overlay, etc.)
- **Related Screens**: Other screens this feature links to or is linked from

---

#### Section 4: User Journey Map

Document step-by-step user interactions for primary, secondary, AND error journeys.

**Primary Journey:**

| Step | User Action | System Response | UI Change |
|------|------------|-----------------|-----------|
| 1 | [what user does] | [what system does] | [what changes on screen] |
| 2 | ... | ... | ... |

**Secondary Journeys** (alternate paths, optional flows):

| Journey | Steps | Trigger |
|---------|-------|---------|
| [name] | [step-by-step as above] | [what triggers this path] |

**Error Journeys** (what happens when things go wrong):

| Error Scenario | User Sees | Recovery Path |
|---------------|-----------|---------------|
| [what goes wrong] | [error message/UI] | [how user recovers] |

---

#### Section 5: Cross-Feature Integration Points

Document every interaction between this feature and other features:

| # | Other Feature | Direction | Shared Data/Component | Mechanism | Notes |
|---|--------------|-----------|----------------------|-----------|-------|
| 1 | [Feature-ID] | This→Other / Other→This / Bidirectional | [what is shared] | [API call, shared state, event, prop, etc.] | [details] |

**UI Integration Points**: Where this feature's UI touches other features' UI (shared layouts, embedded components, navigation links)

**Shared Components**: Components used by both this feature and others (list the component and all consumers)

**If no cross-feature interactions**: Document explicitly: "This feature operates independently — no cross-feature data sharing or UI integration points identified."

---

#### Section 6: State & Data Flow

**Data Flow Diagram** (text-based):
```
[Source] → [Transform] → [Destination]
```

**State Management:**

| State Item | Source | Consumers | Update Trigger | Persistence |
|-----------|--------|-----------|----------------|-------------|
| [name] | [where created] | [who reads it] | [what causes update] | Local/Session/Server |

**Data Transformations**: Document any data format conversions, aggregations, or derivations this feature performs.

---

#### Section 7: Prerequisite Components

**Must Exist Before Implementation** (from earlier waves or other features):
- List specific types, interfaces, utilities, services, or data models that must be in place

**Must Be Built Alongside** (same wave, tightly coupled):
- List components that must be developed together to avoid broken states

**External Dependencies** (third-party libraries, APIs, services):
- List with version requirements if applicable

---

### Step 4: Quality Check Per Feature

After completing all 7 sections for a feature, verify:
- [ ] Component Inventory has exact counts (no "several" or "various")
- [ ] User Journey covers primary, secondary, AND error paths
- [ ] Cross-Feature Integration is documented (even if "none")
- [ ] All components have wave assignments
- [ ] State management is specific (not "managed by state store")
- [ ] Navigation path is concrete (not "accessible from dashboard")

### Step 5: Phase Completion Criteria

**If batched** (planning-tracker.md exists):

Before completing the current batch, verify:
- [ ] All features in current batch have DIVE-XXX.md files
- [ ] All 7 sections completed per feature
- [ ] Component counts are explicit numbers
- [ ] All user journeys documented (primary + secondary + error)
- [ ] Cross-feature integration points documented
- [ ] Update planning-tracker.md: mark current batch features as Deep-Dive ✅
- [ ] **Count check**: DIVE files created this batch = features assigned to this batch

After completing a batch: **STOP** and notify user. Display:
```
Batch [N] of [total] complete (Feature Deep-Dive Analysis).
Features analyzed this batch: [count]
Total components inventoried: [count across all features in batch]
Cross-feature integration points found: [count]
Total features analyzed so far: [count] / [total in scope-lock.md]
Remaining batches: [count]

Run `/continue` to advance to the next batch, or `/planning-feature-deep-dive` to proceed directly.
```

**If NOT batched** (all features in single pass):

Before completing this phase, verify:
- [ ] All features in scope-lock.md have DIVE-XXX.md files
- [ ] All 7 sections completed per feature
- [ ] Component counts are explicit numbers
- [ ] All user journeys documented
- [ ] Cross-feature integration points documented
- [ ] **Count check**: Total DIVE files = total features in scope-lock.md

### Step 6: Complete Phase

When all criteria met (all batches complete, or single pass complete):

1. **Final scope verification**: Count DIVE-XXX.md files in `specs/deep-dives/`. This count MUST equal the feature count in `specs/scope-lock.md`. If mismatch → STOP and identify missing features.

2. Update `.ultimate-sdlc/project-context.md`:
   - Set Phase 2.5 status: Complete

3. Update `.ultimate-sdlc/council-state/planning/WORKING-MEMORY.md`:
   - Mark completed tasks
   - Record session learnings
   - **Record total component count across all features**

4. Record metrics in `.metrics/tasks/planning/`

5. Display completion message:

Use **Display Template** from `council-planning.md` to show: Phase 2.5: Feature Deep-Dive Analysis - Complete

---
