# Governance Modes

## Purpose

Scale framework governance to project size. Small projects get lightweight process; large projects get full governance. The mode is set during `/init` or `/new-cycle` and stored in `.ultimate-sdlc/config.yaml → governance_mode`.

---

## Mode Definitions

| Mode | Feature Count | Planning | Development | Audit | Validation |
|------|--------------|----------|-------------|-------|------------|
| **Lightweight** | <8 features | Combined (1 phase + 1 gate) | Single pass, no multi-run | Abbreviated: T1-T2, A1-A2, 1 gate | Abbreviated: V1-V3, C1-C2, S2 |
| **Standard** | 8-25 features | Full 8 phases, 3 gates | Multi-run available | Full: T1-T5, A1-A3, E1-E3 | Full: all 5 tracks |
| **Enterprise** | 25+ features | Full + formal ADRs mandatory | Multi-run mandatory | Full + external security scans | Full + penetration testing |

---

## Playbook Document Requirements per Mode

| Document | Location | Lightweight | Standard | Enterprise |
|----------|----------|------------|----------|------------|
| BRD | `.ultimate-sdlc/specs/business/brd.md` | ❌ Skip | ✅ Required | ✅ Required |
| PRD Cross-Cutting | `.ultimate-sdlc/specs/prd-crosscutting.md` | ❌ Skip | ✅ Required | ✅ Required |
| Database Design | `.ultimate-sdlc/specs/architecture/database-design.md` | ❌ Skip | ✅ Required | ✅ Required |
| API Specification | `.ultimate-sdlc/specs/architecture/api-specification.md` | ❌ Skip | ✅ Required | ✅ Required |
| CI/CD Spec (detailed) | `.ultimate-sdlc/specs/infrastructure/ci-cd-spec.md` | ❌ Skip | ✅ Required | ✅ Required |
| Monitoring Plan | `.ultimate-sdlc/specs/infrastructure/monitoring-plan.md` | ❌ Skip | ✅ Required | ✅ Required |
| Runbook | `.ultimate-sdlc/specs/operations/runbook.md` | ❌ Skip | ⚠️ Recommended | ✅ Required |
| Tech Docs Suite | `docs/` | ⚠️ Recommended | ✅ Required | ✅ Required |
| Consistency Audits | At gates | ❌ Skip | ✅ Required | ✅ Required |

**⚠️ Recommended** = Generate unless user explicitly opts out. Not a gate-blocking requirement.

---

## Mode Detection

Set automatically during `/init` or `/new-cycle` based on feature count:

1. Count features from `.ultimate-sdlc/project-manifest.md` (feature inventory) or `product-concept.md`
2. Apply thresholds above
3. Store in `.ultimate-sdlc/config.yaml → governance_mode`
4. User can override: `/init --mode enterprise` or `/new-cycle --mode lightweight`

---

## Lightweight Mode Details

### Planning (Combined)
- **Single phase**: Discovery + Architecture + Feature Specs + AIOU Decomposition (combined)
- **Single gate**: Launch Ready (Gate 8 — abbreviated checklist)
- **Output**: `planning-handoff.md` with all 8 sections (same schema, less ceremony)
- **No separate deliberation phase** — features are small enough to scope directly
- **Playbook documents skipped** — BRD, PRD Cross-Cutting, Database Design, API Specification, CI/CD Spec, Monitoring Plan, Runbook, Consistency Audits are all skipped. Features are small enough that per-feature FEAT specs and the planning handoff are sufficient.
- **Optional enrichments** — User can request any playbook document even in Lightweight mode by asking for it explicitly.

### Development
- **No multi-run** — all AIOUs fit in a single pass
- **Same wave order** (0-1 → 2 → 3 → 4 → I4 → 5 → 6 → I8)
- **Gates still mandatory** — quality floor doesn't change with project size

### Audit (Abbreviated)
- **Testing Track**: T1 (Inventory) + T2 (Functional) only
- **Audit Track**: A1 (Purpose Alignment) + A2 (Completeness) only
- **Single gate**: A2 (Completeness)
- **Enhancement Track**: Skipped (project is small enough that enhancements go to next cycle)

### Validation (Abbreviated)
- **Validation Track**: V1-V3 only (Intent + Gaps + Completeness)
- **Correction Track**: C1-C2 only (Targeted Corrections + Edge Cases)
- **Production/Enhancement Tracks**: Skipped
- **Synthesis Track**: S2 only (Release Readiness)
- **Gates**: V5 (abbreviated) + S2

---

## Standard Mode Details

Full pipeline as documented in council rules. This is the default behavior — all phases, gates, and tracks active. Multi-run available when thresholds are met in Development Council.

---

## Enterprise Mode Details

Everything in Standard, plus:

- **Planning**: Formal ADRs mandatory for every significant decision (not just recommended)
- **Development**: Multi-run mandatory regardless of AIOU count (structured subdivision always)
- **Audit**: External security scan tool required at T5 (not just recommended)
- **Validation**: Penetration testing required at P4 (not just OWASP checklist)
- **All gates**: Require explicit user sign-off (not just AI self-verification)

---

## How Workflows Use Modes

Workflows check the mode via `.ultimate-sdlc/config.yaml → governance_mode`:

- **Phase workflows**: Skip non-active phases in Lightweight mode
- **Gate workflows**: Use abbreviated checklists in Lightweight mode (same pass/fail, fewer criteria)
- **`/continue`**: Navigation table adapts to active phases per mode
- **`/status`**: Shows only active phases for current mode

If `governance_mode` is not set in `.ultimate-sdlc/config.yaml`, default to **Standard**.

---

## Mode Change Mid-Cycle

Modes can be changed mid-cycle if scope changes significantly:

- **Upgrade** (Lightweight → Standard): Safe at any point. New phases become available.
- **Downgrade** (Standard → Lightweight): Safe only before entering the phase that would be skipped. Cannot skip a phase already in progress.

Update `.ultimate-sdlc/config.yaml → governance_mode` and run `/status` to see adjusted plan.

---

## Project Type Interaction

Governance mode and project type are independent but interact:

| Combination | Effect |
|-------------|--------|
| Lightweight + CLI-tool | Minimal planning → 5-wave dev (Config→Core→Commands→Tests→Packaging) → abbreviated audit/validation |
| Standard + Web-app | Full planning → 7-wave dev (Types→Data→Services→API→UI→Integration) → full audit/validation |
| Enterprise + API-service | Full planning with ADRs → 6-wave dev (Config→Data→Services→API→Tests→Deploy) → full audit/validation with security scans |

Project type determines **what** is done (wave content, verification layers, feature categories).
Governance mode determines **how much** is done (phase count, gate count, ceremony level).

See `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/project-presets.md` for full project-type-specific configuration.
See `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/config-reader.md` for how workflows consume these values.

---

## Per-Council Phase Activation

### Planning Council

| Phase | Lightweight | Standard | Enterprise |
|-------|------------|----------|------------|
| Phase 1 (Discovery) | ✅ Combined with 1.5 | ✅ | ✅ |
| Gate 1.5 | ❌ Skip | ✅ | ✅ |
| Phase 2 (Architecture) | ✅ Abbreviated | ✅ | ✅ + formal ADRs |
| Phase 3 (Features + AIOUs) | ✅ Combined with 3.5 | ✅ | ✅ |
| Gate 3.5 | ❌ Skip | ✅ | ✅ |
| Phases 4-7 (Supporting) | ❌ Skip | ✅ | ✅ Full |
| Gate 8 | ✅ Simplified | ✅ | ✅ |

### Development Council

| Element | Lightweight | Standard | Enterprise |
|---------|------------|----------|------------|
| Scope analysis | ❌ Skip (<50 units) | ✅ | ✅ |
| Waves | Per project_type preset | Per project_type preset | Per project_type preset |
| Gate I4 | ❌ Skip | ✅ | ✅ |
| Gate I8 | ✅ | ✅ | ✅ |
| Code review evidence | Advisory | Advisory | Mandatory at every wave |

### Audit Council

| Phase | Lightweight | Standard | Enterprise |
|-------|------------|----------|------------|
| T1 (Inventory) | ✅ Combined with T2 | ✅ | ✅ |
| T2 (Functional) | ✅ Combined with T1 | ✅ | ✅ |
| T3 (GUI Analysis) | ❌ Skip | ✅ if frontend | ✅ |
| Gate T3 | ❌ Skip | ✅ if frontend | ✅ |
| T4, T5 | ❌ Skip | ✅ | ✅ |
| A1 (Purpose Alignment) | ✅ Combined A1-A3 | ✅ | ✅ |
| A2, A3 | ✅ Combined | ✅ | ✅ + external scans |
| Gate A3 | ✅ Simplified | ✅ | ✅ |

### Validation Council

| Phase | Lightweight | Standard | Enterprise |
|-------|------------|----------|------------|
| V1-V3 (Review) | ✅ Quick review | ✅ | ✅ |
| V4-V5 | ❌ Skip | ✅ | ✅ |
| Gate V5 | ❌ Skip | ✅ | ✅ |
| C1-C2 (Corrections) | ✅ Fix issues | ✅ | ✅ |
| C3-C4 | ❌ Skip | ✅ | ✅ |
| Gate C4 | ✅ | ✅ | ✅ |
| P1-P4 (Production) | ❌ Skip | ✅ | ✅ + pen testing |
| Gate P4 | ❌ Skip | ✅ | ✅ |
| E1-E4 (Enhancement) | ❌ Skip | ✅ | ✅ |
| Gate E4 | ❌ Skip | ❌ | ✅ |
| S1-S2 (Synthesis) | ✅ Release only | ✅ | ✅ |
| Gate S2 | ✅ | ✅ | ✅ |

