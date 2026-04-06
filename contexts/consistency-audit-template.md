# Cross-Document Consistency Audit

> Run this audit at each gate boundary. The AI reviews all documents produced in the completed phase for internal consistency, contradictions, and gaps.

---

## Audit Prompt Template

*Insert the documents listed for each gate, then execute this prompt:*

```text
You are a Technical Program Manager performing a cross-document consistency audit. Review the following documents for internal consistency. For each issue found, report:

1. **Documents in conflict**: [Which two+ documents contradict]
2. **The conflict**: [What specifically is inconsistent]
3. **Severity**: BLOCKING (must fix before gate PASS) / WARNING (note and proceed)
4. **Recommended resolution**: [Which document should be authoritative]

Check for:
- Feature names/IDs that differ between documents
- Technical decisions in one doc that contradict ADRs
- API contracts in FEAT specs that don't match API Specification
- Data requirements that don't match Database Design
- NFR targets that are inconsistent across documents
- Security requirements that conflict with architecture decisions
- Requirement IDs (BR-XXX → FEAT-XXX → AIOU-XXX) that break traceability
- Scope items in one doc missing from another

BLOCKING issues: Feature missing from scope-lock but present in handoff, contradictory technical decisions, broken traceability chains.
WARNING issues: Minor naming inconsistencies, style differences, non-critical gaps.
```

---

## Gate-Specific Document Sets

### At Gate 1.5
Audit these documents together:
- `product-concept.md`
- `.ultimate-sdlc/specs/business/brd.md` (if exists)
- `.ultimate-sdlc/specs/features/feature-candidates.md`

### At Gate 3.5
Audit these documents together:
- `.ultimate-sdlc/specs/scope-lock.md`
- All `.ultimate-sdlc/specs/features/FEAT-XXX.md`
- All `.ultimate-sdlc/specs/aious/AIOU-XXX.md`
- `.ultimate-sdlc/specs/prd-crosscutting.md` (if exists)
- `.ultimate-sdlc/specs/architecture/api-specification.md` (if exists)
- `.ultimate-sdlc/specs/architecture/database-design.md` (if exists)
- `.ultimate-sdlc/specs/connectivity-matrix.md`

### At Gate 8
Audit these documents together:
- ALL .ultimate-sdlc/specs/* documents
- `.ultimate-sdlc/handoffs/planning-handoff.md`
- Cross-reference everything against `.ultimate-sdlc/specs/scope-lock.md`

### At Gate I4
Audit these documents together:
- `.ultimate-sdlc/specs/architecture/api-specification.md` (planned) vs implemented endpoints
- `.ultimate-sdlc/specs/architecture/database-design.md` (planned) vs implemented schema

### At Gate I8
Audit these documents together:
- `.ultimate-sdlc/handoffs/development-handoff.md` vs `.ultimate-sdlc/specs/wave-summary.md` (AIOU counts match)
- `.ultimate-sdlc/specs/connectivity-matrix.md` vs actual integration test results
- `.ultimate-sdlc/specs/operations/runbook.md` vs actual deployment config

---

## Audit Result Format

```markdown
## Consistency Audit — Gate [N]

**Auditor**: [AI model identifier]
**Date**: [ISO 8601]
**Documents reviewed**: [count]

### BLOCKING Issues
| # | Documents | Conflict | Resolution |
|---|-----------|----------|------------|
| 1 | [docs] | [conflict] | [fix] |

### WARNINGS
| # | Documents | Issue | Notes |
|---|-----------|-------|-------|
| 1 | [docs] | [issue] | [notes] |

**Audit verdict**: CLEAN / [N] BLOCKING issues must be resolved
```
