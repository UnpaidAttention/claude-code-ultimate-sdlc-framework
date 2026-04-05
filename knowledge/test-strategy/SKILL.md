name: test-strategy
description: |
  Plan comprehensive testing approach for software projects.

  Use when: (1) Creating test plans during Phase 6,
  (2) Defining coverage targets and test types,
  (3) Planning test automation strategy,
  (4) Allocating testing resources and tools,
  (5) Designing acceptance criteria for features.

# Test Strategy

Comprehensive test planning and strategy development.

## Overview

This skill provides:
- Test type selection and coverage
- Test automation strategy
- Test environment planning
- Coverage target setting
- Test data management

## Test Pyramid

```
          /\
         /  \      E2E Tests (10%)
        /----\     - Critical user journeys
       /      \    - Slow, expensive
      /--------\   Integration Tests (20%)
     /          \  - API contracts
    /------------\ - Component interaction
   /              \Unit Tests (70%)
  /----------------\- Fast, isolated
                    - High coverage
```

## Test Types

### Unit Tests
- **Scope**: Individual functions/methods
- **Speed**: Milliseconds
- **Coverage Target**: 80%+
- **Tools**: Jest, pytest, JUnit

### Integration Tests
- **Scope**: Component interactions
- **Speed**: Seconds
- **Coverage Target**: Critical paths
- **Tools**: Supertest, pytest, TestContainers

### End-to-End Tests
- **Scope**: Full user journeys
- **Speed**: Minutes
- **Coverage Target**: Happy paths + critical errors
- **Tools**: Playwright, Cypress, Selenium

### Performance Tests
- **Types**: Load, stress, soak, spike
- **Metrics**: Response time, throughput, error rate
- **Tools**: k6, JMeter, Locust

### Security Tests
- **Types**: SAST, DAST, dependency scanning
- **Scope**: OWASP Top 10
- **Tools**: Snyk, OWASP ZAP, SonarQube

## Test Strategy Template

```markdown
## Test Strategy

### Objectives
- [quality goals]
- [coverage targets]
- [risk mitigation]

### Test Types and Coverage

| Type | Scope | Target | Tools | Automation |
|------|-------|--------|-------|------------|
| Unit | All modules | 80% | [tool] | CI |
| Integration | APIs, DB | Critical paths | [tool] | CI |
| E2E | User journeys | Happy paths | [tool] | Nightly |
| Performance | [endpoints] | [SLAs] | [tool] | Weekly |
| Security | Full app | OWASP Top 10 | [tool] | PR + Weekly |

### Test Environments

| Environment | Purpose | Data | Refresh |
|-------------|---------|------|---------|
| Local | Dev testing | Mock/Seed | On demand |
| CI | Automated tests | Seed | Per build |
| Staging | E2E, UAT | Anonymized prod | Weekly |
| Perf | Load testing | Generated | Per test |

### Test Data Strategy
- Unit: Fixtures/factories
- Integration: Seed scripts
- E2E: Test accounts
- Performance: Generated data sets

### Automation Strategy
- All unit/integration tests automated
- E2E for critical paths only
- Performance tests on schedule
- Security scans in CI pipeline

### Entry/Exit Criteria

**Entry (ready to test)**:
- [ ] Code complete
- [ ] Unit tests passing
- [ ] Deployed to test environment

**Exit (ready to release)**:
- [ ] All tests passing
- [ ] Coverage targets met
- [ ] No critical/high defects
- [ ] Performance SLAs met
- [ ] Security scan clean

### Risk-Based Testing
| Risk Area | Extra Testing |
|-----------|---------------|
| [area] | [additional tests] |
```

## Coverage Guidance

### What to Cover
- All public APIs
- Business logic
- Error handling
- Edge cases
- Security controls

### What NOT to Over-Test
- Framework code
- Simple getters/setters
- Generated code
- Third-party libraries

## Acceptance Criteria Testing

Each feature's acceptance criteria should map to tests:

```markdown
## Feature: User Login

### Acceptance Criteria → Tests
| Criteria | Test Type | Test Case |
|----------|-----------|-----------|
| User can login with email/password | E2E | test_login_success |
| Invalid password shows error | Integration | test_login_invalid_password |
| Account locks after 5 failures | Unit | test_account_lockout |
```

## Deliverables

- Test strategy document
- Coverage targets by module
- Test environment specifications
- Test automation roadmap
- Acceptance test mapping
