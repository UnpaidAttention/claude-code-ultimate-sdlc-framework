name: regression-testing
description: |
  Verify existing functionality remains intact after changes through systematic re-testing.

  Use when: (1) Bug fixes need validation that they don't break related functionality,
  (2) New features require testing at integration points, (3) Refactoring requires full
  regression suite, (4) Release candidates need comprehensive regression coverage,
  (5) Dependency updates affect component behavior.

# Regression Testing

Ensuring changes don't break existing functionality.

## Regression Strategy

### When to Run Regression Tests

| Trigger | Scope | Priority |
|---------|-------|----------|
| **Bug Fix** | Related functionality | High |
| **New Feature** | Integration points | Medium |
| **Refactoring** | Full regression | High |
| **Dependency Update** | Affected components | Medium |
| **Release Candidate** | Full suite | Critical |

### Test Selection

#### Risk-Based Selection
Prioritize tests for:
1. **High-traffic features**: Most used functionality
2. **Revenue-critical paths**: Payment, checkout
3. **Integration points**: Where components connect
4. **Recently changed areas**: Higher defect probability
5. **Historical problem areas**: Previously buggy features

## Regression Suite Organization

```markdown
## Regression Suite

### P0 - Critical Path (Always Run)
| ID | Test | Last Pass | Status |
|----|------|-----------|--------|
| REG-001 | User login | 2024-01-01 | Active |
| REG-002 | Add to cart | 2024-01-01 | Active |
| REG-003 | Checkout | 2024-01-01 | Active |

### P1 - Core Features (Run on Major Changes)
| ID | Test | Last Pass | Status |
|----|------|-----------|--------|
| REG-010 | User registration | 2024-01-01 | Active |
| REG-011 | Search products | 2024-01-01 | Active |

### P2 - Secondary Features (Run on Full Regression)
| ID | Test | Last Pass | Status |
|----|------|-----------|--------|
| REG-020 | Edit profile | 2024-01-01 | Active |
| REG-021 | View order history | 2024-01-01 | Active |
```

## Execution Process

### Pre-Regression Checklist
- [ ] Baseline (previous version) behavior documented
- [ ] Test environment matches production config
- [ ] Test data reset to known state
- [ ] Change scope identified

### During Execution

```markdown
## Regression Run: [Date]

**Trigger**: [Bug fix / Feature / Release]
**Change**: [Brief description of what changed]
**Scope**: P0 only / P0-P1 / Full

### Results
| Suite | Total | Pass | Fail | Blocked |
|-------|-------|------|------|---------|
| P0 | 10 | 9 | 1 | 0 |
| P1 | 15 | 15 | 0 | 0 |
| P2 | 25 | 24 | 0 | 1 |

### Failures
| Test | Expected | Actual | Defect |
|------|----------|--------|--------|
| REG-003 | Checkout succeeds | 500 error | DEF-456 |

### Analysis
[Root cause of failures - regression or test issue?]
```

## Regression Defect Analysis

### Classification

| Category | Description | Action |
|----------|-------------|--------|
| **True Regression** | Working feature now broken | File high-priority defect |
| **Test Environment** | Test setup issue | Fix test, re-run |
| **Flaky Test** | Intermittent failure | Investigate test reliability |
| **Expected Change** | Intentional behavior change | Update test |

### Investigation Steps

When regression test fails:

1. **Verify failure is real**: Re-run test
2. **Check test validity**: Is test still relevant?
3. **Compare to baseline**: What changed?
4. **Identify root cause**: Code change or environment?
5. **Document findings**: Link to change that caused it

## Maintaining Regression Suite

### Suite Health Metrics

| Metric | Target | Current |
|--------|--------|---------|
| Execution time | < 30 min | [Current] |
| Flaky rate | < 2% | [Current] |
| Pass rate | > 95% | [Current] |
| Coverage | > 80% critical paths | [Current] |

### Maintenance Tasks
- [ ] Remove obsolete tests (features removed)
- [ ] Update tests for changed behavior
- [ ] Add tests for new features
- [ ] Fix or quarantine flaky tests
- [ ] Optimize slow tests
