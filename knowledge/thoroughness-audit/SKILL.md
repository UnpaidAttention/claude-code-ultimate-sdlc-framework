---
name: thoroughness-audit
description: Evaluates features against 8 thoroughness criteria introduced in Phase 2.5. Covers complexity classification, deep-dive analysis (7 sections), FEAT sections 9-10, connectivity matrix, feature verification, run sizing, and PRH-008/009 compliance. Classifies features into implementation tiers (Fully/Partially/Not Yet Started) and generates gap reports with TG-XXX IDs and severity ratings. Supports retroactive deep-dive synthesis from existing specs and code. Used by /thoroughness-audit and /thoroughness-remediate workflows.
version: 1.0.0
---

# Thoroughness Audit Skill

## Purpose

Provide a systematic evaluation framework for assessing features against the thoroughness criteria introduced with Phase 2.5 (Feature Deep-Dive). Projects that began before these enhancements — or that bypassed Phase 2.5 — need a way to identify and quantify thoroughness gaps. This skill defines what to check, how to check it, and how to classify what's missing.

## The 8 Thoroughness Criteria

### Criterion 1: Feature Complexity Classification

| Field | Value |
|-------|-------|
| **What** | Every feature in scope-lock.md must have a Complexity column value (Simple/Moderate/Complex) |
| **Where** | `specs/scope-lock.md` — Complexity column |
| **Evaluation** | Parse scope-lock.md table. Check for a Complexity column. Each feature row must contain Simple, Moderate, or Complex. |
| **Severity** | Minor — metadata only, does not block implementation |

### Criterion 2: Deep-Dive Analysis

| Field | Value |
|-------|-------|
| **What** | Every feature must have a DIVE-XXX.md file with all 7 mandatory sections |
| **Where** | `specs/deep-dives/DIVE-{Feature-ID}.md` |
| **Evaluation** | Check file exists. Verify all 7 sections present: (1) Functional Analysis, (2) Component Inventory, (3) UI Placement & Navigation, (4) User Journey Map, (5) Cross-Feature Integration, (6) State & Data Flow, (7) Prerequisites. Verify component counts are exact numbers, not estimates. |
| **Severity** | Critical — without deep-dive, FEAT specs may be shallow and implementation misses components |

**7 Required Sections:**
1. Feature Functional Analysis — states, transitions, business rules
2. Complete Component Inventory — exact counts, wave assignments
3. UI Placement & Navigation — routes, entry points, layout
4. User Journey Map — primary + secondary + error journeys
5. Cross-Feature Integration Points — data sharing, shared components
6. State & Data Flow — data flow diagram, state management table
7. Prerequisite Components — must-exist, must-build-alongside, external

### Criterion 3: FEAT Sections 9-10

| Field | Value |
|-------|-------|
| **What** | FEAT specs must include Section 9 (Component Inventory) and Section 10 (Navigation & Access) |
| **Where** | `specs/features/FEAT-{ID}.md` — Sections 9 and 10 |
| **Evaluation** | Parse each FEAT spec. Check for Section 9 with component table (# / Name / Type / Wave) and total count. Check for Section 10 with route, navigation path, entry points. |
| **Severity** | Major — missing spec artifact that development depends on |

### Criterion 4: Connectivity Matrix

| Field | Value |
|-------|-------|
| **What** | A cross-feature connectivity matrix documenting all inter-feature interactions |
| **Where** | `specs/connectivity-matrix.md` |
| **Evaluation** | Check file exists. Verify it contains a matrix with features on both axes. Each cell should document interaction type (data, UI, event, none) and direction. Verify every feature from scope-lock.md appears in the matrix. |
| **Severity** | Critical — without this, Wave 6 integration has no roadmap |

### Criterion 5: Feature Verification

| Field | Value |
|-------|-------|
| **What** | Each fully-implemented feature must have a verification record confirming all components built |
| **Where** | `council-state/development/feature-verifications/FEAT-{ID}-verified.md` |
| **Evaluation** | Check file exists for each fully-implemented feature. Verify it references the component inventory from DIVE/FEAT and confirms each component was implemented. |
| **Severity** | Critical — applies to Fully Implemented features only |

### Criterion 6: Run Sizing

| Field | Value |
|-------|-------|
| **What** | No development run exceeds 15 AIOUs or 45 effort units |
| **Where** | `council-state/development/run-tracker.md` |
| **Evaluation** | Parse run-tracker if it exists. For each run, sum AIOU count and effort. Flag any run exceeding limits. If no run-tracker exists, check total AIOU count — if >15, a run-tracker should exist. |
| **Severity** | Major — oversized runs lead to context overflow and missed work |

### Criterion 7: PRH-008 Compliance (Feature Simplification Prohibition)

| Field | Value |
|-------|-------|
| **What** | Every component listed in a feature's DIVE/FEAT component inventory must be implemented — no silent omissions |
| **Where** | Cross-reference DIVE/FEAT component inventory against actual codebase |
| **Evaluation** | For each fully-implemented feature: count components in DIVE Section 2 / FEAT Section 9. Count implemented components. Any shortfall = PRH-008 violation. |
| **Severity** | Critical — applies to Fully Implemented features only |

### Criterion 8: PRH-009 Compliance (Connectivity Omission Prohibition)

| Field | Value |
|-------|-------|
| **What** | Every non-"none" cell in the connectivity matrix must have a corresponding implementation |
| **Where** | Cross-reference `specs/connectivity-matrix.md` against actual integration code |
| **Evaluation** | For each documented interaction in the matrix: verify the integration exists in code (shared state, API calls, events, etc.). Any documented-but-unimplemented connection = PRH-009 violation. |
| **Severity** | Critical — applies to Fully Implemented features only |

---

## Implementation Status Tiers

Features are classified into tiers based on development progress. The tier determines which criteria apply.

### Tier A: Fully Implemented
All development waves complete for this feature's AIOUs. All 8 criteria apply.

| Criteria | Applied |
|----------|---------|
| 1. Complexity Classification | Yes |
| 2. Deep-Dive Analysis | Yes |
| 3. FEAT Sections 9-10 | Yes |
| 4. Connectivity Matrix | Yes |
| 5. Feature Verification | Yes |
| 6. Run Sizing | Yes |
| 7. PRH-008 Compliance | Yes |
| 8. PRH-009 Compliance | Yes |

### Tier B: Partially Implemented
Some AIOUs started or complete, but feature not fully done. Criteria 1-6 apply (spec completeness + sizing). Code compliance criteria (7-8) deferred until implementation complete.

| Criteria | Applied |
|----------|---------|
| 1-6 | Yes |
| 7-8 | Deferred — evaluate after implementation complete |

### Tier C: Not Yet Started
No AIOUs begun. Only spec-side criteria apply (1-5). Run sizing (6) deferred until runs planned.

| Criteria | Applied |
|----------|---------|
| 1-5 | Yes |
| 6-8 | Deferred — evaluate after development begins |

---

## Retroactive Deep-Dive Analysis Protocol

When a feature has no DIVE file but has a FEAT spec and possibly code, synthesize a retroactive deep-dive from available evidence.

### Source Priority
1. FEAT spec (primary — most structured)
2. AIOU specs in `specs/aious/` (implementation details)
3. Existing codebase (if partially/fully implemented)
4. Architecture documents (ADRs, system design)

### Synthesis Process

For each of the 7 DIVE sections:

1. **Extract** — Pull relevant information from available sources
2. **Infer** — Fill gaps using architecture context and code analysis
3. **Flag** — Mark anything without direct evidence as `[UNCERTAIN]`
4. **Count** — Produce exact component counts even if inferred from code

### Output Format

The retroactive analysis is embedded in the audit report (not written to a DIVE file). Format:

```markdown
#### Retroactive Deep-Dive: FEAT-XXX — [Feature Name]

**Sources Used**: FEAT spec, AIOU-001/002/003, codebase (src/features/xxx/)
**Confidence**: High/Medium/Low

**Section 1: Functional Analysis**
[synthesized content]

**Section 2: Component Inventory**
| # | Component | Type | Wave | Source | Status |
|---|-----------|------|------|--------|--------|
| 1 | ... | ... | ... | FEAT spec | [UNCERTAIN] / Confirmed |

**Total Components**: NN (NN confirmed, NN [UNCERTAIN])

[...sections 3-7...]
```

Items marked `[UNCERTAIN]` require user validation during remediation.

---

## Gap Report Format

Each gap receives a unique ID and structured fields.

### Gap ID Convention
`TG-XXX` where XXX is a sequential three-digit number (TG = Thoroughness Gap).

### Per-Gap Fields

| Field | Description |
|-------|-------------|
| **ID** | TG-XXX |
| **Feature** | FEAT-XXX — Feature Name |
| **Criterion** | 1-8 with name |
| **Severity** | Critical / Major / Minor |
| **Current State** | What exists now |
| **Expected State** | What should exist per the criterion |
| **Remediation Type** | Spec (artifact creation/update) or Code (implementation work) |
| **Estimated Effort** | S (< 30 min), M (30-120 min), L (> 2 hours) |

### Example

```markdown
| Field | Value |
|-------|-------|
| ID | TG-001 |
| Feature | FEAT-003 — User Authentication |
| Criterion | 2 — Deep-Dive Analysis |
| Severity | Critical |
| Current State | No DIVE-003.md file exists |
| Expected State | DIVE-003.md with all 7 sections, exact component counts |
| Remediation Type | Spec |
| Estimated Effort | M |
```

---

## Severity Classification

| Severity | Definition | Examples |
|----------|-----------|----------|
| **Critical** | Blocks verification or compromises implementation integrity. Must fix before claiming feature complete. | Missing DIVE file, missing connectivity matrix, PRH-008/009 violations, missing feature verification |
| **Major** | Missing spec artifact that development depends on. Should fix before next development wave. | Missing FEAT S9-10, oversized runs, missing complexity classification with >15 features |
| **Minor** | Metadata gap only. Fix when convenient. | Missing complexity classification (< 15 features) |
