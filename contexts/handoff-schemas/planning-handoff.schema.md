# Planning Handoff Schema

> **Source of Truth**: This schema is the canonical reference for planning handoff validation. Gate 8 criteria in `gate-criteria.md` reference this file. All section counts and requirements are defined here.

## Required Sections (8 total)

A valid `planning-handoff.md` MUST contain ALL of these sections:

### 1. Executive Summary
**Required fields**:
- [ ] Project name
- [ ] One-paragraph description
- [ ] Key objectives (bulleted list, minimum 3 items)
- [ ] Success criteria (bulleted list, minimum 3 items)

### 2. Architecture Summary
**Required fields**:
- [ ] System diagram or description
- [ ] Technology stack
- [ ] Key architectural decisions (reference ADRs)
- [ ] Integration points
- [ ] Database Design reference (`.ultimate-sdlc/specs/architecture/database-design.md`) — or N/A if Lightweight
- [ ] API Specification reference (`.ultimate-sdlc/specs/architecture/api-specification.md`) — or N/A if Lightweight

### 2b. Business Requirements (Standard/Enterprise only)
**Required fields**:
- [ ] BRD reference (`.ultimate-sdlc/specs/business/brd.md`)
- [ ] Key business objectives summary (top 5 from BRD)
- [ ] BR-XXX → FEAT-XXX traceability confirmation

### 3. Feature Specifications
**Required fields**:
- [ ] List of all features with FEAT-XXX references
- [ ] Each feature has: name, description, acceptance criteria
- [ ] Priority order or grouping

### 4. Design Direction
**Required fields**:
- [ ] Visual identity statement (one paragraph describing the intended look/feel/personality)
- [ ] Typography selections (display font, body font, mono font — with rationale for each)
- [ ] Color palette (primary, secondary, accent, neutral — with OKLCH values, HSL fallback, and rationale tied to product meaning)
- [ ] Spatial composition strategy (layout approach, grid system, whitespace philosophy)
- [ ] Motion design language (animation purpose, timing character, interaction style)
- [ ] Design references (2-3 reference sites/apps that capture the intended aesthetic)
- [ ] Anti-convergence check: "What makes this UI unforgettable?" (one sentence answer)

### 5. AIOU Wave Summary
**Required fields**:
- [ ] Total AIOU count
- [ ] AIOUs per wave (Wave 0 through Wave 6)
- [ ] Wave dependency summary
- [ ] Estimated complexity distribution

### 6. Security Requirements
**Required fields**:
- [ ] Authentication requirements
- [ ] Authorization model
- [ ] Data protection requirements
- [ ] Threat model reference
- [ ] Security checklist status
- [ ] Trust zone diagram reference
- [ ] Security controls matrix reference
- [ ] Attack surface analysis reference

### 7. Infrastructure Requirements
**Required fields**:
- [ ] Deployment environment
- [ ] Resource requirements
- [ ] Scaling considerations
- [ ] Monitoring requirements
- [ ] NFR targets summary (from `.ultimate-sdlc/specs/prd-crosscutting.md` §1 — performance, scalability, availability)
- [ ] CI/CD pipeline spec reference (`.ultimate-sdlc/specs/infrastructure/ci-cd-spec.md`) — or N/A if Lightweight
- [ ] Monitoring plan reference (`.ultimate-sdlc/specs/infrastructure/monitoring-plan.md`) — or N/A if Lightweight
- [ ] SLI/SLO definitions

### 8. Verification & Sign-off
**Required fields**:
- [ ] Verification agent: [AI model identifier]
- [ ] Verification timestamp: [ISO 8601]
- [ ] Verification method: [Artifact-based / Command-based / Manual review]
- [ ] Confirmation: "All phases 1-8 complete" — evidence: [link to current-state.md showing all phases checked]
- [ ] Confirmation: "Gate 8 passed" — evidence: [link to gate checklist with all criteria PASS]
- [ ] List of any deferred items (with target phase)
- [ ] Planning lead sign-off: [Agent ID]

---

## Validation Checklist

```markdown
## Planning Handoff Validation

### Content Present
- [ ] Executive Summary present and complete
- [ ] Architecture Summary present and complete
- [ ] Feature Specifications present (count: ___)
- [ ] Design Direction present and complete
- [ ] AIOU Wave Summary present (total AIOUs: ___)
- [ ] Security Requirements present and complete
- [ ] Infrastructure Requirements present and complete
- [ ] Sign-off section present and signed

- [ ] Business Requirements present (Standard/Enterprise): YES/NO/N/A
- [ ] Database Design referenced: YES/NO/N/A
- [ ] API Specification referenced: YES/NO/N/A
- [ ] NFR targets in Infrastructure section: YES/NO/N/A
- [ ] Consistency audit result: CLEAN/N/A

**VALIDATION STATUS**: VALID / INVALID
```
