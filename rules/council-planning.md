# Planning Council Rules

Load when: `/council planning` or `/planning-*` commands

## Cycle-Type Awareness

For **Full** and **Feature** cycles, planning follows the full 8-phase progression below.
For **Patch**, **Maintenance**, and **Improvement** cycles, use abbreviated workflows:
- `/patch-planning` — Defect analysis, root cause, fix AIOUs
- `/maintenance-planning` — Impact analysis, update categorization, maintenance AIOUs
- `/improvement-planning` — Refactoring analysis, behavioral contracts, improvement AIOUs

These produce a `planning-handoff.md` compatible with standard Development Council workflows.

## Phase Progression

| Phase | Name | Key Deliverable |
|-------|------|-----------------|
| 1 | Discovery | idea-intake.md |
| 1→1.5 | Business Analysis | **brd.md** (Standard/Enterprise) |
| 1.5 | Deliberation | feature-candidates.md |
| **Gate 1.5** | Feature Completeness | **GATE** |
| 2 | Architecture | ADR-XXX documents, **database-design.md** (Standard/Enterprise) |
| 2.5 | Feature Deep-Dive | DIVE-XXX analysis |
| 3 | Features | FEAT-XXX specifications |
| 3→3.5 | Cross-Cutting Specs | **prd-crosscutting.md** (Standard/Enterprise) |
| 3.5 | AIOU Decomposition | AIOU specs + waves + **api-specification.md** (Standard/Enterprise) |
| **Gate 3.5** | AIOU Decomposition | **GATE** |
| 4 | Security | threat-model.md (enriched: STRIDE + trust zones + controls matrix) |
| 5 | Testing | test-plan.md (enriched: multi-level + performance + AI quality) |
| 6 | Infrastructure | infrastructure-spec.md + **ci-cd-spec.md** + **monitoring-plan.md** |
| 7 | Sprint Planning | sprint-plan.md (enriched: critical path + risk register + DoD) |
| 8 | Launch Ready | planning-handoff.md |

**Note**: Planning uses **batch mode** when feature count >=8. See Planning Batch Mode below. Development Council uses multi-run mode — see UNIVERSAL-RULES 0.14.

### Feed-Forward Reference Protocol

Before generating any deliverable, the agent MUST read all upstream documents listed in `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/document-dependencies.md § Per-Phase Required Inputs`. This ensures:
1. No contradictions with prior decisions
2. Correct terminology and ID references (BR-XXX, FEAT-XXX, AIOU-XXX)
3. NFR targets and constraints are respected downstream

**Violation**: Generating a document without reading its required inputs is a PRH violation (Premature Completion — PRH-005).

## Quality Gates

Gate criteria are defined in `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/gate-criteria.md` (single source of truth).
Mode-specific activation: see `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/governance-modes.md § Per-Council Phase Activation`.

- **Gate 1.5**: Feature Completeness → see `gate-criteria.md § Gate 1.5`
- **Gate 3.5**: AIOU Decomposition → see `gate-criteria.md § Gate 3.5`
- **Gate 8**: Launch Ready → see `gate-criteria.md § Gate 8`

## Session Protocol

Standard session start/resume sequence for all Planning Council workflows:

1. Read `.ultimate-sdlc/config.yaml` → extract `governance_mode`, `project_type`
2. Read `.ultimate-sdlc/project-context.md` → confirm Active Council = Planning, get current phase
3. Read `.ultimate-sdlc/council-state/planning/current-state.md` → get phase checklist
4. Read `.ultimate-sdlc/council-state/planning/WORKING-MEMORY.md` → check for incomplete tasks
5. **Feedback load** (per `rules/feedback-rules.md § Trigger R1` — Read feedback-rules.md first, then): Invoke `/sdlc-feedback-review` → load active feedback entries for `council: planning` or `council: any`. Apply their "How to apply" during this session. Record loaded IDs in WORKING-MEMORY.md under "Feedback loaded this session".
6. **If resuming**: Display resume summary from WORKING-MEMORY, continue from last position
7. **If new session**: Display welcome, proceed to current phase
8. Check governance_mode → skip non-applicable phases per `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/governance-modes.md`

## Pre-AIOU Feedback Filter (Phases 2.5 / 3 / 3.5)

Applies to the three AIOU-generating phases: Feature Deep-Dive, Feature Specs, AIOU Decomposition.

Before drafting any AIOU for a feature (or before defining its components in a DIVE), the agent MUST:

1. Invoke `/sdlc-feedback-review --aiou <AIOU-ID>` (or filter by FEAT-ID if the AIOU doesn't exist yet).
2. Apply matched entries' "How to apply" guidance to the spec being drafted.
3. If feedback contradicts an upstream spec (BRD, ADR, FEAT): **spec wins** — flag the conflict to the user for reconciliation. Do NOT silently override either source.
4. Record which FB-NNN entries informed the AIOU in the AIOU spec under a new section `## Feedback Applied` (list IDs + one-line note).

This ensures corrections from prior cycles (carried forward as `pattern` entries) and from earlier in the current cycle actively shape AIOU definition rather than being re-learned during Development.

## Scope Integrity Principle

**ALL features provided by the user are in scope by default.** The AI MUST NOT exclude, deprioritize, or defer features without explicit user approval. There is no MVP scoping, no MoSCoW categorization, no priority tiers. Every feature in the product concept gets full planning through all phases.

If the user wants to exclude features, they must say so explicitly. The AI never suggests, implies, or creates a mechanism for reducing scope.

## Planning Batch Mode

When feature count >=8, Phases 2.5 (Feature Deep-Dive), 3 (Feature Specs), and 3.5 (AIOU Decomposition) execute in **batches** rather than attempting all features in a single pass.

**Batch Protocol:**

1. **Trigger**: Feature count in `.ultimate-sdlc/specs/scope-lock.md` >= 8
2. **Batch size**: 3-5 features per batch, grouped by module/domain (not arbitrary)
3. **Batched phases**: Phase 2.5 (Feature Deep-Dive), Phase 3 (Feature Specs), and Phase 3.5 (AIOU Decomposition)

**Rationale**: Smaller batches ensure the AI agent deeply focuses on each feature's complexity, components, and integration points. Context dilution across 15+ features is the primary cause of shallow specifications.
4. **Non-batched phases**: Phases 1, 1.5, 2 (cross-cutting discovery/architecture), Phases 4-7 (cross-cutting supporting specs), Phase 8 (handoff) — these execute once
5. **Tracking**: `.ultimate-sdlc/council-state/planning/planning-tracker.md` — lists every feature, its batch assignment, and spec completion status
6. **Session boundary = batch boundary**: Complete a batch → save progress → STOP → notify user of completion → user runs `/continue` (or the next applicable workflow) → next batch
7. **Phase 3 and 3.5 interleave per batch**: Each batch completes both FEAT specs AND AIOU decomposition before the next batch begins. This keeps context focused.

**Planning Tracker Schema:**

```markdown
## Planning Tracker

**Total Features**: ___ | **Batches**: ___ | **Current Batch**: ___

### Batch 1: [Module/Domain Name] (Features X-Y)
| Feature ID | Feature Name | FEAT Spec | AIOUs | Status |
|------------|-------------|-----------|-------|--------|
| F-001 | [Name] | done/pending | done/pending | complete/pending |

### Batch 2: [Module/Domain Name] (Features X-Y)
...
```

**Batch Completion Verification:**
- Before marking a batch complete: every feature in the batch has a FEAT-XXX.md AND at least one AIOU-XXX.md
- Before advancing to Phase 4: ALL batches complete. Verify total FEAT count and AIOU count against `.ultimate-sdlc/specs/scope-lock.md`
- If a batch is too large mid-session: STOP and request subdivision (same as Development's run recovery protocol)

## Thoroughness Protocol (T1-T5)

Used during Discovery (Phase 1) to ensure no features are silently missed. Referenced by planning-start.md — defined once here:

**T1**: Read the product concept / feature list completely
**T2**: Count total features explicitly
**T3**: Identify implicit features not explicitly stated
**T4**: Cross-reference against Feature Categories for `project_type` (see `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/project-presets.md`)
**T5**: Anti-Truncation Declaration — confirm every feature is accounted for

## Display Template

```markdown
## Planning Council - [Phase Name]

**Mode**: [governance_mode] | **Type**: [project_type]
**Phase**: [N] of [total for mode] | **Status**: [in_progress]
**Product Concept**: [Available | Not available]

[Phase-specific content follows]
```

## Focus Lenses

| Lens | Applied During |
|------|---------------|
| `[Requirements]` | Phases 1-1.5 |
| `[Architecture]` | Phases 2-3 |
| `[Security]` | Phase 4, all gates |
| `[Documentation]` | Phase 8, handoff generation |

## Feature Specification Matrix

Every feature MUST include the applicable sections:

| Section | All Types | Web-App Only | Library Only |
|---------|-----------|-------------|-------------|
| 1. Purpose | yes | yes | yes |
| 2. User Stories | yes (or use cases for libraries) | yes | Use cases |
| 3. Acceptance Criteria | yes | yes | yes |
| 4. Data Requirements | yes if applicable | yes | If applicable |
| 5. API Contracts | If applicable | yes | yes (public API) |
| 6. UI Requirements | If applicable | yes | no |
| 7. Edge Cases | yes | yes | yes |
| 8. Dependencies | yes | yes | yes |
| 9. Component Inventory | yes | yes | yes |
| 10. Navigation & Placement | If applicable | yes | no |
| 11. Security Test Scenarios | If handles input/auth/data | yes | yes |

## AIOU Size Guidelines

| Size | Duration | LOC | Max Files |
|------|----------|-----|-----------|
| XS | <1 hour | <50 | 1-2 |
| S | 1-2 hours | 50-150 | 2-3 |
| M | 2-4 hours | 150-400 | 3-5 |
| L | 4-8 hours | 400-800 | 5-7 |

AIOU > L size → MUST split

## Wave Organization

Waves are determined by `project_type` — see `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/project-presets.md` for type-specific wave structures. Default (web-app): Wave 0: Types & Interfaces → Wave 1: Utilities & Helpers → Wave 2: Data Layer → Wave 3: Services → Wave 4: API Layer → Wave 5: UI Components → Wave 6: Integration

## Handoff Requirements

planning-handoff.md MUST contain: Executive summary, Architecture summary, All feature specifications, Design direction, AIOU wave summary, All AIOU specifications, Security requirements, Infrastructure requirements, Appendices (ADRs, data models, API contracts)

Validate against `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/handoff-schemas/planning-handoff.schema.md`.

**Scope Coverage**: Handoff must cover every feature in `.ultimate-sdlc/specs/scope-lock.md`. Gate 8 verifies this.

## Recovery

If recovering mid-phase, verify last completed deliverable via WORKING-MEMORY.md and resume from that point. See `/recover` for full protocol.
