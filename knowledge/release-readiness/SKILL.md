name: release-readiness
description: Final verification that software is ready for production release. Use during Validation Council Gate S2, when preparing launch checklists, verifying all quality gates passed, checking deployment prerequisites, and confirming documentation and rollback procedures are complete.

# Release Readiness

Final verification that software is ready for release.

## Purpose

Comprehensive checklist ensuring nothing is forgotten before release.

## Release Readiness Checklist

### 1. Code Quality
```markdown
## Code Quality Check

| Item | Status | Notes |
|------|--------|-------|
| All tests passing | [Pass/Fail] | |
| No critical linting errors | [Pass/Fail] | |
| Code coverage acceptable | [X]% | Target: [Y]% |
| No TODO/FIXME in release code | [Pass/Fail] | |
| No debug code | [Pass/Fail] | |
| No hardcoded secrets | [Pass/Fail] | |
```

### 2. Validation Complete
```markdown
## Validation Status

| Gate | Status | Evidence |
|------|--------|----------|
| V5 - Validation Complete | [Pass/Fail] | [Link to report] |
| C4 - Corrections Complete | [Pass/Fail] | [Link to log] |
| P4 - Production Ready | [Pass/Fail] | [Link to assessment] |
| E4 - Enhancement Complete | [Pass/Fail] | [Link to report] |

### Outstanding Issues
| Issue | Severity | Decision |
|-------|----------|----------|
| [Issue] | [Sev] | [Ship/Block/Known Issue] |
```

### 3. Testing Complete
```markdown
## Testing Status

| Test Type | Run | Passed | Failed | Skipped |
|-----------|-----|--------|--------|---------|
| Unit | [X] | [X] | [X] | [X] |
| Integration | [X] | [X] | [X] | [X] |
| E2E | [X] | [X] | [X] | [X] |
| Performance | [X] | [X] | [X] | [X] |
| Security | [X] | [X] | [X] | [X] |

### Test Evidence
- Full test run: [Link/Screenshot]
- Coverage report: [Link]
- Security scan: [Link]
```

### 4. Documentation Complete
```markdown
## Documentation Status

| Document | Status | Last Updated |
|----------|--------|--------------|
| README | [Complete/Needs Work] | [Date] |
| API Docs | [Complete/Needs Work] | [Date] |
| User Guide | [Complete/Needs Work] | [Date] |
| Changelog | [Complete/Needs Work] | [Date] |
| Release Notes | [Complete/Needs Work] | [Date] |

### Documentation Sign-off
- Technical accuracy: [Verified by]
- Examples working: [Verified by]
- Links valid: [Verified by]
```

### 5. Production Configuration
```markdown
## Production Config

| Item | Status | Notes |
|------|--------|-------|
| Environment variables set | [Yes/No] | |
| Secrets configured | [Yes/No] | |
| Database migrations ready | [Yes/No] | |
| Feature flags configured | [Yes/No] | |
| Monitoring enabled | [Yes/No] | |
| Alerting configured | [Yes/No] | |
| Backups configured | [Yes/No] | |
```

### 6. Deployment Ready
```markdown
## Deployment Checklist

| Item | Status | Notes |
|------|--------|-------|
| Build succeeds | [Pass/Fail] | |
| Staging deployment tested | [Pass/Fail] | |
| Rollback procedure documented | [Yes/No] | |
| Deployment window scheduled | [Yes/No] | [Date/Time] |
| Team notified | [Yes/No] | |
| On-call assigned | [Yes/No] | |
```

### 7. Communication Ready
```markdown
## Communication

| Item | Status | Notes |
|------|--------|-------|
| Release notes written | [Yes/No] | |
| Stakeholders informed | [Yes/No] | |
| User communication prepared | [Yes/No] | |
| Support team briefed | [Yes/No] | |
```

## Release Decision Matrix

### Go Criteria
All must be true:
- [ ] All critical tests passing
- [ ] No critical/high severity open issues
- [ ] All gates passed
- [ ] Documentation complete
- [ ] Deployment tested

### No-Go Triggers
Any of these blocks release:
- [ ] Critical bug discovered
- [ ] Security vulnerability found
- [ ] Data loss risk identified
- [ ] Regulatory compliance issue
- [ ] Key stakeholder blocker

### Known Issues Acceptance
```markdown
## Known Issues for This Release

| Issue | Severity | Workaround | Fix Timeline |
|-------|----------|------------|--------------|
| [Issue] | [Sev] | [Workaround] | [When fixed] |

Approved by: [Name]
Date: [Date]
```

## Release Verification

### Step 1: Final Test Run
```markdown
## Final Test Execution

**Date**: [Date]
**Run by**: [Who]

**Command**: `npm test && npm run e2e`

**Results**:
```
[Test output]
```

**Status**: [All Pass / Issues Found]
```

### Step 2: Staging Verification
```markdown
## Staging Verification

**Environment**: [Staging URL]
**Date**: [Date]
**Verified by**: [Who]

### Functional Verification
| Feature | Status | Notes |
|---------|--------|-------|
| [Feature 1] | [Pass/Fail] | |
| [Feature 2] | [Pass/Fail] | |

### Performance Verification
| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| [Metric] | [Target] | [Actual] | [Pass/Fail] |
```

### Step 3: Final Sign-off
```markdown
## Release Sign-off

**Version**: [Version number]
**Date**: [Date]

### Approvals
| Role | Name | Approved | Date |
|------|------|----------|------|
| Tech Lead | [Name] | [Yes/No] | [Date] |
| QA | [Name] | [Yes/No] | [Date] |
| Product | [Name] | [Yes/No] | [Date] |

### Release Decision
**Decision**: [GO / NO-GO]
**Reason**: [If NO-GO, why]
**Release Date**: [Scheduled date]
```

## Output Format

```markdown
# Release Readiness Report: v[X.Y.Z]

## Summary
- **Version**: [X.Y.Z]
- **Status**: [READY / NOT READY]
- **Target Date**: [Date]
- **Blocking Issues**: [X]

## Gate Status
| Gate | Status |
|------|--------|
| V5 Validation | [Pass/Fail] |
| C4 Corrections | [Pass/Fail] |
| P4 Production | [Pass/Fail] |
| E4 Enhancement | [Pass/Fail] |

## Test Results
- Tests: [X] passed, [Y] failed
- Coverage: [X]%
- Security: [Status]

## Checklist Summary
- [x] Code quality verified
- [x] Testing complete
- [x] Documentation current
- [x] Production configured
- [x] Deployment tested
- [x] Communication prepared

## Known Issues
[List or "None"]

## Sign-offs
[Names and dates]

## Release Decision
**[GO / NO-GO]**
```

## Quality Checklist

- [ ] All gates passed
- [ ] All tests passing
- [ ] Documentation complete
- [ ] Production configured
- [ ] Deployment tested
- [ ] Known issues documented
- [ ] Sign-offs obtained
- [ ] Release decision made
