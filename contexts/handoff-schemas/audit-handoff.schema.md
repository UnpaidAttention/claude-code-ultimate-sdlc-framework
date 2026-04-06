# Audit Handoff Schema

## Required Sections

A valid `audit-handoff.md` MUST contain ALL of these sections:

### 1. Audit Summary
**Required fields**:
- [ ] Total features audited
- [ ] Total test cases executed
- [ ] Pass/fail summary

### 2. Quality Scorecard
**Required fields**:
- [ ] All 6 dimensions scored (1-5 each):
  - Functionality
  - Reliability
  - Usability
  - Performance
  - Security
  - Maintainability
- [ ] Overall weighted score
- [ ] Release recommendation

### 3. Defect Summary
**Required fields**:
- [ ] Total defects found
- [ ] Defects by severity (P0, P1, P2, P3)
- [ ] Reference to defect-log.md

### 4. Accessibility Report
**Required fields**:
- [ ] WCAG 2.2 AA compliance status
- [ ] Critical accessibility issues (must be 0)
- [ ] Accessibility recommendations

### 5. Performance Report
**Required fields**:
- [ ] Key performance metrics
- [ ] Performance against requirements
- [ ] Performance recommendations

### 6. Security Audit Summary
**Required fields**:
- [ ] Security audit checklist completed (sections 3.1-3.13)
- [ ] Sections passed: ___/13 | Failed: ___ | N/A: ___
- [ ] SEC-CRITICAL findings: ___ (must be 0)
- [ ] SEC-HIGH findings resolved: ___
- [ ] SEC-MEDIUM findings carried to Validation: ___
- [ ] Security requirements traceability: ___% of threats mitigated
- [ ] Security test coverage: security tests exist for ___% of input entry points

### 7. Verification Summary
**Required fields**:
- [ ] Verification agent: [AI model identifier]
- [ ] Verification timestamp: [ISO 8601]
- [ ] Verification method: [Artifact-based / Command-based / Manual review]
- [ ] Confirmation: "All phase groups complete (T1-T5, A1-A3, E1-E3)" — evidence: [link to current-state.md showing all phases checked]
- [ ] Confirmation: "Gate A3 passed" — evidence: [link to gate checklist with all criteria PASS]
- [ ] Audit lead sign-off: [Agent ID]

---

## Companion Document: defect-log.md

A valid `defect-log.md` MUST have for each defect:

- [ ] Defect ID (format: DEF-XXX)
- [ ] Title
- [ ] Severity (P0/P1/P2/P3)
- [ ] Description
- [ ] Steps to reproduce
- [ ] Expected vs actual behavior
- [ ] Screenshot reference
- [ ] Status (Open/Fixed/Verified)

---

## Validation Checklist

```markdown
## Audit Handoff Validation

- [ ] Audit Summary present (features audited: ___)
- [ ] Quality Scorecard complete (overall score: ___)
- [ ] Defect Summary present (total defects: ___)
- [ ] defect-log.md exists and has all defects
- [ ] Accessibility Report present (critical issues: ___)
- [ ] Performance Report present
- [ ] Security Audit Summary present (SEC-CRITICAL: ___)
- [ ] Sign-off present and signed

**VALIDATION STATUS**: VALID / INVALID
```
