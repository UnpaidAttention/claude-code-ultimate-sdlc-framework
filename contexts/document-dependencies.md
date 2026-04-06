# Document Dependency Graph

> This file maps the feed-forward dependency chain between all planning and development documents. Each phase workflow MUST read its **Required Inputs** before generating outputs. Gates verify that dependencies are satisfied.

---

## Dependency Map

```text
product-concept.md (user input)
    │
    ├──→ .ultimate-sdlc/specs/business/brd.md [Phase 1→1.5]
    │       Requires: product-concept.md
    │
    ├──→ .ultimate-sdlc/specs/features/feature-candidates.md [Phase 1.5]
    │       Requires: product-concept.md, brd.md (if exists)
    │
    ├──→ .ultimate-sdlc/specs/scope-lock.md [Gate 1.5 PASS]
    │       Requires: feature-candidates.md
    │
    ├──→ .ultimate-sdlc/specs/adrs/ADR-XXX.md [Phase 2]
    │       Requires: scope-lock.md, product-concept.md (constraints)
    │
    ├──→ .ultimate-sdlc/specs/architecture/database-design.md [Phase 2]
    │       Requires: scope-lock.md, ADR-XXX.md (DB selection)
    │
    ├──→ .ultimate-sdlc/specs/deep-dives/DIVE-XXX.md [Phase 2.5]
    │       Requires: scope-lock.md, ADR-XXX.md
    │
    ├──→ .ultimate-sdlc/specs/features/FEAT-XXX.md [Phase 3]
    │       Requires: DIVE-XXX.md, scope-lock.md, brd.md (BR-XXX traceability)
    │
    ├──→ .ultimate-sdlc/specs/prd-crosscutting.md [Phase 3→3.5]
    │       Requires: All FEAT-XXX.md, scope-lock.md, product-concept.md
    │
    ├──→ .ultimate-sdlc/specs/aious/AIOU-XXX.md [Phase 3.5]
    │       Requires: FEAT-XXX.md, prd-crosscutting.md (NFR thresholds)
    │
    ├──→ .ultimate-sdlc/specs/architecture/api-specification.md [Phase 3.5]
    │       Requires: All FEAT-XXX.md (API sections), database-design.md, ADR-XXX.md
    │
    ├──→ .ultimate-sdlc/specs/connectivity-matrix.md [Phase 3.5]
    │       Requires: DIVE-XXX.md (Section 5), All AIOU-XXX.md
    │
    ├──→ .ultimate-sdlc/specs/wave-summary.md [Phase 3.5]
    │       Requires: All AIOU-XXX.md
    │
    ├──→ .ultimate-sdlc/specs/security/threat-model.md [Phase 4]
    │       Requires: ADR-XXX.md, api-specification.md, prd-crosscutting.md (Security NFRs)
    │
    ├──→ .ultimate-sdlc/specs/testing/test-plan.md [Phase 5]
    │       Requires: prd-crosscutting.md (NFR targets), api-specification.md, FEAT-XXX.md
    │
    ├──→ .ultimate-sdlc/specs/infrastructure/ [Phase 6]
    │       Requires: ADR-XXX.md, prd-crosscutting.md (Scalability/Availability NFRs)
    │       Outputs: ci-cd-spec.md, monitoring-plan.md
    │
    ├──→ .ultimate-sdlc/specs/sprint/sprint-plan.md [Phase 7]
    │       Requires: wave-summary.md, AIOU-XXX.md, brd.md (priorities)
    │
    ├──→ .ultimate-sdlc/handoffs/planning-handoff.md [Gate 8 PASS]
    │       Requires: ALL of the above
    │
    ├──→ [Development Waves 0-6]
    │       Wave 2 requires: database-design.md
    │       Wave 4 requires: api-specification.md
    │       Wave 5 requires: ui-design-plan.md, design-system.md
    │
    ├──→ .ultimate-sdlc/specs/operations/runbook.md [Dev Wave 6 / Post-Gate I8]
    │       Requires: api-specification.md, threat-model.md, monitoring-plan.md
    │
    └──→ docs/ (Tech Documentation Suite) [Post-Gate I8]
            Requires: api-specification.md, ADR-XXX.md, runbook.md, actual codebase
```

---

## Per-Phase Required Inputs

| Phase | Required Inputs (MUST read before generating) |
|-------|-----------------------------------------------|
| 1 (Discovery) | `product-concept.md` |
| 1→1.5 (BRD) | `product-concept.md` |
| 1.5 (Deliberation) | `product-concept.md`, `.ultimate-sdlc/specs/business/brd.md` (if Standard/Enterprise) |
| 2 (Architecture) | `.ultimate-sdlc/specs/scope-lock.md`, `product-concept.md` (constraints section) |
| 2.5 (Deep-Dive) | `.ultimate-sdlc/specs/scope-lock.md`, `.ultimate-sdlc/specs/adrs/ADR-XXX.md`, `.ultimate-sdlc/specs/architecture/database-design.md` |
| 3 (Features) | `.ultimate-sdlc/specs/deep-dives/DIVE-XXX.md`, `.ultimate-sdlc/specs/scope-lock.md`, `.ultimate-sdlc/specs/business/brd.md` (BR-XXX IDs) |
| 3→3.5 (PRD Cross-Cutting) | All `.ultimate-sdlc/specs/features/FEAT-XXX.md`, `.ultimate-sdlc/specs/scope-lock.md` |
| 3.5 (AIOUs) | All `FEAT-XXX.md`, `.ultimate-sdlc/specs/prd-crosscutting.md`, `.ultimate-sdlc/specs/architecture/database-design.md` |
| 3.5 (API Spec) | All `FEAT-XXX.md` API sections, `.ultimate-sdlc/specs/architecture/database-design.md` |
| 4 (Security) | `.ultimate-sdlc/specs/adrs/ADR-XXX.md`, `.ultimate-sdlc/specs/architecture/api-specification.md`, `.ultimate-sdlc/specs/prd-crosscutting.md` §1 Security |
| 5 (Testing) | `.ultimate-sdlc/specs/prd-crosscutting.md` (NFR targets), `.ultimate-sdlc/specs/architecture/api-specification.md`, `FEAT-XXX.md` |
| 6 (Infrastructure) | `.ultimate-sdlc/specs/adrs/ADR-XXX.md`, `.ultimate-sdlc/specs/prd-crosscutting.md` §1 Scalability/Availability |
| 7 (Sprint) | `.ultimate-sdlc/specs/wave-summary.md`, `AIOU-XXX.md`, `.ultimate-sdlc/specs/business/brd.md` (priorities) |
| 8 (Launch Ready) | ALL above documents |
| Dev Wave 2 | `.ultimate-sdlc/specs/architecture/database-design.md` |
| Dev Wave 4 | `.ultimate-sdlc/specs/architecture/api-specification.md` |
| Dev Wave 5 | `.ultimate-sdlc/council-state/development/ui-design-plan.md`, `design-system.md` |
| Dev Wave 6 | `.ultimate-sdlc/specs/connectivity-matrix.md`, `.ultimate-sdlc/specs/operations/runbook.md` (generate if missing) |
| Post-Gate I8 | `templates/tech-docs-checklist.md`, all specs, actual codebase |

---

## Governance Mode Overrides

| Document | Lightweight | Standard | Enterprise |
|----------|------------|----------|------------|
| BRD (`.ultimate-sdlc/specs/business/brd.md`) | OPTIONAL | REQUIRED | REQUIRED |
| PRD Cross-Cutting (`.ultimate-sdlc/specs/prd-crosscutting.md`) | OPTIONAL | REQUIRED | REQUIRED |
| Database Design (`.ultimate-sdlc/specs/architecture/database-design.md`) | OPTIONAL | REQUIRED | REQUIRED |
| API Specification (`.ultimate-sdlc/specs/architecture/api-specification.md`) | OPTIONAL | REQUIRED | REQUIRED |
| Runbook (`.ultimate-sdlc/specs/operations/runbook.md`) | OPTIONAL | RECOMMENDED | REQUIRED |
| Tech Docs Suite (`docs/`) | RECOMMENDED | REQUIRED | REQUIRED |

*OPTIONAL = Skip if <8 features and user doesn't request it.*
*RECOMMENDED = Generate unless user explicitly opts out.*
*REQUIRED = Must exist for gate to pass.*
