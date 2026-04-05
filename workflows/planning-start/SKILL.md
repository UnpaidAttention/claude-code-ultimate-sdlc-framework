---
name: planning-start
description: |
  Initialize or resume Planning Council session. Guides through phases 1-8 with gates at 3.5 and 8.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/brainstorming/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/memory-system/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /planning-start - Begin Planning Council

## Arguments
| Argument | Required | Description |
|----------|----------|-------------|
| (none) | — | Session auto-detects state |

---

## Lens / Skills / Model
**Lens**: `[Requirements]` | **Model**: Claude Opus 4
> Apply RARV cycle, session protocol per council-planning.md

---

## Purpose

Start or resume the Planning Council. This council transforms requirements into implementation-ready specifications through 8 phases.

---

## Pre-Conditions

- `.ultimate-sdlc/project-context.md` must exist (run `/init` first if not)
- If resuming from another council, previous council must be complete

---

## Workflow

### Step 1: Session Setup

Follow **Session Protocol** from `council-planning.md`:
1. Read `.ultimate-sdlc/config.yaml` → extract `governance_mode`, `project_type`
2. Read `.ultimate-sdlc/project-context.md` → confirm Active Council, current phase
3. Read `~/.claude/skills/ultimate-sdlc/context/framework-overview.md`, `.reference/phase-guide.md`

### Step 2: Check Project State

Read `.ultimate-sdlc/project-context.md`:
- If `Active Council` is not "planning", check if transition is valid
- Identify current phase
- Read `Cycle Information` section → extract **Cycle Type** and **Cycle Intent**

### Step 2a: Cycle-Type Routing

**Read the Cycle Type from `.ultimate-sdlc/project-context.md` → `Cycle Information` → `Cycle Type`.**

| Cycle Type | Action |
|------------|--------|
| **Full** | Continue to Step 3 (full 8-phase planning) |
| **Feature** | Continue to Step 3, but apply **Feature Scope Protocol** (see below) |
| **Patch** | STOP. Display: "Patch cycles use abbreviated planning. Run `/patch-planning` instead." |
| **Maintenance** | STOP. Display: "Maintenance cycles use abbreviated planning. Run `/maintenance-planning` instead." |
| **Improvement** | STOP. Display: "Improvement cycles use abbreviated planning. Run `/improvement-planning` instead." |

**Feature Scope Protocol** (applies to Feature cycles throughout planning):

When the cycle type is **Feature**, planning is scoped to NEW features only:

1. **Read `cycle-baseline.md`** — This summarizes existing architecture, features, and tech debt
2. **Read `specs/feature-inventory.md`** (if exists) — This lists all existing features
3. **Read `.ultimate-sdlc/project-manifest.md`** — Cycle history and project identity
4. **Set planning context**:
   - Phase 1 (Discovery): Focus on understanding NEW feature requirements. Existing features are baseline — do not rediscover them. Reference `cycle-baseline.md` for what already exists.
   - Phase 2 (Architecture): Evaluate IF architectural changes are needed for new features. Read existing ADRs from `specs/adrs/`. Only create new ADRs for new decisions.
   - Phase 3 (Features): Only spec NEW features. Existing features in `specs/feature-inventory.md` are baseline.
   - Phase 3.5 (AIOU): Only decompose NEW features into AIOUs.
   - Phases 4-7: Only plan for NEW feature requirements (security, testing, infra, sprint).
   - Phase 8: Handoff covers only NEW features and their integration with existing codebase.

5. **Add to `.ultimate-sdlc/council-state/planning/WORKING-MEMORY.md`**:
   ```
   ### Cycle Context
   - Cycle Type: Feature
   - Cycle Intent: [from .ultimate-sdlc/project-context.md]
   - Existing Features: [count from feature-inventory.md]
   - Existing ADRs: [count from specs/adrs/]
   - Scope: NEW features only — existing codebase is baseline
   ```

**Full Cycle (cycle > 1) Note**: When the cycle type is Full but this is NOT cycle-001 (check `.ultimate-sdlc/project-manifest.md` cycle history), also read `cycle-baseline.md` for existing context. Full cycles may rebuild or majorly revise, but should still be aware of what exists.

### Step 3: Determine Mode

**If Phase is 1 and status is "not started":**
→ NEW SESSION - Go to Step 4

**If Phase is > 1 or status is "in progress":**
→ RESUME SESSION - Go to Step 5

### Step 4: New Session Setup

1. Update `.ultimate-sdlc/project-context.md`:
   - Set `Active Council`: planning
   - Set `Current Phase`: 1
   - Set `Status`: in_progress

2. Load Phase 1 skills if context budget allows (see UNIVERSAL-RULES §0.15):
   - `~/.claude/skills/ultimate-sdlc/knowledge/requirements-engineering/SKILL.md`
   - `~/.claude/skills/ultimate-sdlc/knowledge/brainstorming/SKILL.md`
   - `~/.claude/skills/ultimate-sdlc/knowledge/documentation-standards/SKILL.md`

3. Update `.ultimate-sdlc/progress.md` with new session entry

4. **Check for Product Concept**:
   - Look for `product-concept.md` in project root
   - If found → Go to Step 4A
   - If not found → Go to Step 4B

### Step 4A: Start with Product Concept

If `product-concept.md` exists:

1. Read and parse the file
2. **If Feature cycle**: Also read and display `cycle-baseline.md` summary — frame discovery around ADDING to existing product, not starting fresh
3. Display welcome with pre-loaded context:

Use **Display Template** from `council-planning.md` with:
- Phase Name: Discovery
- Product Concept: Available
- **Lens**: `[Requirements]`

Include summary of product-concept.md contents (product name, vision, problem, users, features, metrics, constraints).

Ask user to confirm the product concept is accurate before proceeding.

3. **Execute Thoroughness Protocol** (MANDATORY after initial review):

   Follow **Thoroughness Protocol (T1-T5)** from `council-planning.md`.
   Use **Feature Categories** for the current `project_type` from `~/.claude/skills/ultimate-sdlc/context/project-presets.md`.

### Step 4B: Start Without Product Concept

If `product-concept.md` does NOT exist:

Display welcome:
Use **Display Template** from `council-planning.md` with:
- Phase Name: Discovery
- Product Concept: Not available
- **Lens**: `[Requirements]`

Guide user through requirements gathering. Suggest creating `product-concept.md` for structured input.

After gathering initial requirements through conversation, **Execute Thoroughness Protocol** (MANDATORY):

Follow **Thoroughness Protocol (T1-T5)** from `council-planning.md`.
Use **Feature Categories** for the current `project_type` from `~/.claude/skills/ultimate-sdlc/context/project-presets.md`.

### Step 4C: Generate Business Requirements Document (BRD)

> **Governance check**: Read `.ultimate-sdlc/config.yaml → governance_mode`. If `lightweight`, SKIP this step (BRD is optional). If `standard` or `enterprise`, this step is MANDATORY.

1. Read `~/.claude/skills/ultimate-sdlc/context/document-dependencies.md` — confirm BRD dependencies are satisfied (product-concept.md exists)
2. Read `templates/brd-template.md` for the required structure
3. Generate `specs/business/brd.md` using the product concept as input:
   - **Section 2 (Business Objectives)**: Extract from product-concept.md Vision + Problem Statement + Success Metrics
   - **Section 3 (Stakeholder Analysis)**: Derive from product-concept.md Target Users + Organizational Context
   - **Section 5 (Functional Requirements)**: Create BR-XXX IDs for each business capability implied by Core Features
   - **Section 7 (Integration Requirements)**: Extract from Organizational Context → Existing Technology Environment
   - **Section 9 (ROI Analysis)**: Use Success Metrics + Constraints to estimate
   - Flag all assumptions with `[ASSUMPTION: ...]`
4. Present BRD summary to user for review
5. Update `.ultimate-sdlc/council-state/planning/WORKING-MEMORY.md` with BRD status
6. Record in `.ultimate-sdlc/progress.md`: "BRD generated: specs/business/brd.md"

### Step 5: Resume Session

1. Read `.ultimate-sdlc/project-context.md` for current phase
2. Read `.ultimate-sdlc/progress.md` for last session notes
3. Read `.ultimate-sdlc/council-state/planning/current-state.md` for detailed state
4. Load skills for current phase:
   - Look up phase in `.reference/skills-index.md`
   - Read each skill from `~/.claude/skills/ultimate-sdlc/knowledge/<skill-name>/SKILL.md`

5. Display status:
Use **Display Template** from `council-planning.md` to show: Planning Council - Resumed

---

## Phase Navigation

### When Phase 1 complete:
Run `/planning-phase-1-5` to continue to Deliberation

### Direct Phase Entry
- Phase 1.5: `/planning-phase-1-5` (Deliberation)
- **Gate 1.5**: `/planning-gate-1-5` (Feature Completeness Gate)
- Phase 2: `/planning-phase-2` (Architecture)
- Phase 3: `/planning-phase-3` (Features)
- Phase 3.5: `/planning-phase-3-5` (AIOU Decomposition)
- Gate 3.5: `/planning-gate-3-5` (Gate Verification)
- Phases 4-7: `/planning-supporting-specs` (Security, Testing, Infrastructure, Sprint)
- Phase 8: `/planning-phase-8` (Launch Ready)
- Gate 8: `/planning-gate-8` (Final Gate)

### To view status:
Use `/status`

---

## Phase Quick Reference

| Phase | Name | Key Output |
|-------|------|------------|
| 1 | Discovery | Requirements documented |
| 1.5 | Deliberation | Feature scope confirmed |
| **Gate 1.5** | Feature Completeness | **GATE** - All features identified |
| 2 | Architecture | ADRs written |
| 2.5 | Feature Deep-Dive | DIVE-XXX analysis (all features) |
| 3 | Features | FEAT-XXX specifications |
| 3.5 | AIOU Decomposition | **GATE** - AIOUs with waves |
| 4-7 | Supporting Specs | Security, Testing, Infra, Sprint |
| 8 | Launch Ready | **GATE** - planning-handoff.md |

**Note**: Planning uses batch mode when feature count ≥8 (Phases 2.5, 3, + 3.5 are batched). See `council-planning.md § Planning Batch Mode`. Multi-run division is used in the Development Council.

---

## Handoff

When Phase 8 gate passes:
- Generate `handoffs/planning-handoff.md`
  - **If Feature cycle**: Handoff must clearly state scope (new features only) and reference existing codebase as baseline
  - **If Full cycle (non-initial)**: Handoff must reference `cycle-baseline.md` for existing context
- `specs/business/brd.md` (if Standard/Enterprise mode — BR-XXX IDs referenced by FEAT specs)
- Update `.ultimate-sdlc/project-context.md` to mark Planning complete
- Instruct user to run `/dev-start`

---
