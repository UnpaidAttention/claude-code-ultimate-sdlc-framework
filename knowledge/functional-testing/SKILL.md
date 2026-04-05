name: functional-testing
description: Provides systematic functional testing techniques including boundary analysis, equivalence partitioning, and defect documentation. Use during Audit Track T2 phase, when verifying feature implementations against specifications, regression testing, pre-release validation, or integration point verification.

# Functional Testing

> Comprehensive methodology for verifying that software features work correctly according to specifications, using systematic test design techniques.


## Core Principles

| Principle | Rule |
|-----------|------|
| Requirements-Based | Every test traces to a requirement |
| Systematic | Use formal techniques, not ad-hoc testing |
| Reproducible | Tests can be repeated with same results |
| Independent | Tests do not depend on execution order |
| Complete | Cover happy paths, errors, and edge cases |
| Documented | Results and defects are thoroughly logged |


## When to Use

- Audit Track T2 (Functional Testing Phase)
- Verifying feature implementations against specifications
- Regression testing after code changes
- Pre-release quality validation
- User acceptance testing preparation
- Integration point verification


## Test Case Design Techniques

### 1. Equivalence Partitioning

Divides input data into partitions where all values should behave the same way.

**Concept**:
```
Input Domain → [Invalid Partition 1] [Valid Partition] [Invalid Partition 2]

Example: Age field (valid: 18-120)
├── Invalid Partition 1: < 18 (pick: 15)
├── Valid Partition: 18-120 (pick: 45)
└── Invalid Partition 2: > 120 (pick: 150)
```

**Application Table**:

| Field | Type | Invalid Low | Valid | Invalid High |
|-------|------|-------------|-------|--------------|
| Age | Number | < 18 | 18-120 | > 120 |
| Email | Format | no @ | valid@domain.com | multiple @ |
| Password | Length | < 8 chars | 8-128 chars | > 128 chars |
| Quantity | Integer | < 1 | 1-100 | > 100 |

**Test Design Rules**:
- Select ONE representative value from each partition
- Invalid partitions need at least one test each
- Valid partitions may need multiple values for ranges

### 2. Boundary Value Analysis

Tests at the edges of equivalence partitions where defects cluster.

**Boundary Points**:
```
For range [min, max]:
├── Below minimum: min - 1 (invalid)
├── At minimum: min (valid)
├── Just above minimum: min + 1 (valid)
├── Nominal value: (min + max) / 2 (valid)
├── Just below maximum: max - 1 (valid)
├── At maximum: max (valid)
└── Above maximum: max + 1 (invalid)
```

**Example: Quantity Field (valid: 1-100)**:

| Boundary | Value | Expected Result |
|----------|-------|-----------------|
| Below min | 0 | Error: "Minimum quantity is 1" |
| At min | 1 | Success |
| Above min | 2 | Success |
| Nominal | 50 | Success |
| Below max | 99 | Success |
| At max | 100 | Success |
| Above max | 101 | Error: "Maximum quantity is 100" |

**String Length Boundaries**:

| Field | Min | Max | Test Values |
|-------|-----|-----|-------------|
| Username | 3 | 20 | "", "ab", "abc", "abcd", 19 chars, 20 chars, 21 chars |
| Password | 8 | 128 | 7 chars, 8 chars, 9 chars, 127 chars, 128 chars, 129 chars |
| Bio | 0 | 500 | "", 1 char, 499 chars, 500 chars, 501 chars |

### 3. Decision Table Testing

For complex business logic with multiple conditions and actions.

**Structure**:
```
Conditions:        | Rule 1 | Rule 2 | Rule 3 | Rule 4 |
-------------------|--------|--------|--------|--------|
Condition 1        |   T    |   T    |   F    |   F    |
Condition 2        |   T    |   F    |   T    |   F    |
-------------------|--------|--------|--------|--------|
Actions:           |        |        |        |        |
Action 1           |   X    |        |   X    |        |
Action 2           |   X    |   X    |        |        |
```

**Example: Shipping Cost Calculator**:

| Conditions | R1 | R2 | R3 | R4 | R5 | R6 |
|------------|----|----|----|----|----|----|
| Order >= $50 | T | T | T | F | F | F |
| Premium Member | T | F | F | T | F | F |
| Heavy Items | - | T | F | - | T | F |
| **Actions** | | | | | | |
| Free Shipping | X | | X | X | | |
| Standard Rate | | | | | | X |
| Heavy Rate | | X | | | X | |

**Test Cases from Decision Table**:
```markdown
TC-DT-001: Premium member, order >= $50 → Free shipping
TC-DT-002: Non-premium, order >= $50, heavy → Heavy shipping rate
TC-DT-003: Non-premium, order >= $50, light → Free shipping
TC-DT-004: Premium member, order < $50 → Free shipping
TC-DT-005: Non-premium, order < $50, heavy → Heavy shipping rate
TC-DT-006: Non-premium, order < $50, light → Standard shipping rate
```

### 4. State Transition Testing

For systems with defined states and transitions.

**State Diagram Elements**:
```
[State] --event[guard]/action--> [Next State]

Example: Order Status
[Draft] --submit--> [Pending]
[Pending] --approve--> [Approved]
[Pending] --reject--> [Rejected]
[Approved] --ship--> [Shipped]
[Shipped] --deliver--> [Delivered]
[Any] --cancel[if not shipped]--> [Cancelled]
```

**State Transition Table**:

| Current State | Event | Guard | Action | Next State |
|---------------|-------|-------|--------|------------|
| Draft | submit | valid data | notify_reviewer | Pending |
| Draft | submit | invalid data | show_errors | Draft |
| Pending | approve | has_authority | notify_submitter | Approved |
| Pending | reject | has_authority | notify_submitter | Rejected |
| Approved | ship | items_available | create_shipment | Shipped |
| Shipped | deliver | confirmed | close_order | Delivered |
| Draft/Pending/Approved | cancel | not_shipped | refund | Cancelled |

**Test Scenarios**:
- **Valid Path**: Draft → Pending → Approved → Shipped → Delivered
- **Rejection Path**: Draft → Pending → Rejected
- **Cancellation Path**: Draft → Pending → Cancelled
- **Invalid Transition**: Shipped → Cancelled (should fail)

### 5. Use Case Testing

Testing based on user scenarios and workflows.

**Use Case Template**:
```markdown
**UC-001: User Login**

**Actor**: Registered User
**Precondition**: User has valid account
**Trigger**: User navigates to login page

**Main Flow**:
1. System displays login form
2. User enters email and password
3. User clicks "Login" button
4. System validates credentials
5. System creates session
6. System redirects to dashboard

**Alternative Flows**:
- 4a. Invalid credentials → Show error, allow retry
- 4b. Account locked → Show lockout message
- 4c. Unverified email → Prompt verification

**Postcondition**: User is authenticated with active session
```


## Test Case Documentation

### Standard Test Case Template

```markdown
## TC-[Module]-[Number]: [Descriptive Name]

**Metadata**
| Field | Value |
|-------|-------|
| Feature | FEAT-XXX |
| Priority | Critical / High / Medium / Low |
| Type | Functional / Boundary / State / Integration |
| Automation | Manual / Automated / Candidate |
| Last Updated | YYYY-MM-DD |

**Preconditions**:
- [ ] System state requirement 1
- [ ] Test data requirement 2
- [ ] User permissions requirement 3

**Test Data**:
| Variable | Value | Notes |
|----------|-------|-------|
| email | test@example.com | Valid format |
| password | TestPass123! | Meets complexity |

**Steps**:
| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | Navigate to /login | Login form displayed |
| 2 | Enter email: test@example.com | Email field populated |
| 3 | Enter password: TestPass123! | Password field masked |
| 4 | Click "Login" button | Request submitted |
| 5 | Wait for response | Redirected to /dashboard |

**Expected Result**:
- User session created
- Dashboard displays user name
- Login timestamp recorded

**Actual Result**: [Fill during execution]

**Status**: [ ] Pass  [ ] Fail  [ ] Blocked  [ ] Skipped

**Notes**: [Any observations during execution]
```

### Test Case Prioritization

| Priority | Criteria | Examples |
|----------|----------|----------|
| Critical | Core functionality, data integrity | Login, payment, data save |
| High | Major features, business rules | Search, filtering, reports |
| Medium | Secondary features, edge cases | Sorting, pagination, exports |
| Low | UI polish, convenience features | Tooltips, animations |


## Test Coverage Metrics

### Coverage Types

| Metric | Formula | Target |
|--------|---------|--------|
| Requirement Coverage | Tests with req links / Total requirements | 100% |
| Feature Coverage | Features with tests / Total features | 100% |
| Happy Path Coverage | Happy path tests / Total features | 100% |
| Error Path Coverage | Error tests / Identified error conditions | 80% |
| Boundary Coverage | Boundary tests / Identified boundaries | 90% |
| State Coverage | States tested / Total states | 100% |
| Transition Coverage | Transitions tested / Total transitions | 100% |

### Coverage Matrix Template

```markdown
| Feature | Happy Path | Error Paths | Boundaries | States | Overall |
|---------|------------|-------------|------------|--------|---------|
| Login | 3/3 | 5/6 | 4/4 | N/A | 92% |
| Registration | 2/2 | 4/5 | 6/6 | N/A | 92% |
| Order Process | 4/4 | 6/8 | 3/3 | 8/10 | 84% |
| Payment | 2/2 | 8/8 | 5/5 | 4/4 | 100% |
```

### Minimum Coverage Requirements

| Test Phase | Happy Path | Errors | Boundaries | States |
|------------|------------|--------|------------|--------|
| Unit Testing | 100% | 70% | 80% | 90% |
| Integration | 100% | 60% | 60% | 80% |
| System Testing | 100% | 80% | 70% | 100% |
| Regression | 100% | 50% | 50% | 80% |


## Defect Logging Standards

### Defect Report Template

```markdown
## DEF-[Number]: [Brief Description]

**Metadata**
| Field | Value |
|-------|-------|
| Severity | Critical / Major / Minor / Cosmetic |
| Priority | P0 / P1 / P2 / P3 |
| Status | Open / In Progress / Fixed / Verified / Closed |
| Found In | Version/Build number |
| Environment | OS, Browser, Device |
| Assigned To | Developer name |
| Test Case | TC-XXX (if applicable) |

**Summary**:
One-line description of the defect behavior.

**Steps to Reproduce**:
1. Specific step 1
2. Specific step 2
3. Specific step 3

**Expected Result**:
What should happen according to requirements.

**Actual Result**:
What actually happened.

**Evidence**:
- Screenshot: [link]
- Video: [link]
- Logs: [attached]

**Workaround**: [If any exists]

**Additional Context**:
- Frequency: Always / Intermittent / Once
- Impact: [Users/features affected]
- Related: DEF-XXX, TC-YYY
```

### Severity Classification

| Severity | Definition | Examples | SLA |
|----------|------------|----------|-----|
| Critical | System unusable, data loss, security breach | Cannot login, payment fails, data corruption | 4 hours |
| Major | Feature broken, no workaround | Search returns wrong results, export fails | 24 hours |
| Minor | Feature impaired, workaround exists | Slow performance, UI misalignment | 1 week |
| Cosmetic | Visual issue, no functional impact | Typo, color mismatch, spacing | Backlog |

### Defect Lifecycle

```
[New] → [Triaged] → [Assigned] → [In Progress] → [Fixed] → [Verified] → [Closed]
                ↘           ↗
                 [Rejected]
                     ↓
              [Won't Fix/Duplicate]
```

### Defect Triage Checklist

- [ ] Can defect be reproduced?
- [ ] Is severity accurately assigned?
- [ ] Is there sufficient detail to investigate?
- [ ] Are screenshots/logs attached?
- [ ] Is it linked to test case and feature?
- [ ] Are similar defects checked for duplicates?
- [ ] Is environment information complete?


## Testing Checklists

### Feature Testing Checklist

```markdown
## Feature: [Feature Name]

### Functional Tests
- [ ] Happy path works end-to-end
- [ ] All input fields validate correctly
- [ ] Required field validation
- [ ] Input format validation (email, phone, etc.)
- [ ] Boundary values handled
- [ ] Error messages are clear and helpful
- [ ] Success messages display correctly

### Data Tests
- [ ] Data saves correctly to database
- [ ] Data retrieves correctly
- [ ] Data updates correctly
- [ ] Data deletes correctly (if applicable)
- [ ] Data relationships maintained
- [ ] Concurrent modification handled

### Security Tests
- [ ] Authentication required where expected
- [ ] Authorization enforced (role-based)
- [ ] Input sanitization (XSS prevention)
- [ ] SQL/NoSQL injection prevented
- [ ] Sensitive data masked/encrypted

### Error Handling Tests
- [ ] Invalid input handled gracefully
- [ ] Network errors handled
- [ ] Timeout errors handled
- [ ] Server errors display user-friendly message
- [ ] Validation errors highlight specific fields

### State Tests
- [ ] Initial state correct
- [ ] State transitions work correctly
- [ ] Invalid transitions prevented
- [ ] State persists across page refresh
- [ ] State syncs across tabs/devices (if applicable)

### Integration Tests
- [ ] API contracts honored
- [ ] Third-party integrations work
- [ ] Webhooks/callbacks received
- [ ] Event emissions correct
```

### Regression Testing Checklist

```markdown
## Regression Suite: [Release Version]

### Critical Paths
- [ ] User registration
- [ ] User login/logout
- [ ] Password reset
- [ ] Core feature 1: [Name]
- [ ] Core feature 2: [Name]
- [ ] Payment processing (if applicable)
- [ ] Data export (if applicable)

### Recent Changes
- [ ] Feature A: [specific tests]
- [ ] Bug fix B: [verification tests]
- [ ] Refactor C: [affected area tests]

### Integration Points
- [ ] External API A
- [ ] External API B
- [ ] Database operations
- [ ] File storage operations

### Cross-Browser (if web)
- [ ] Chrome latest
- [ ] Firefox latest
- [ ] Safari latest
- [ ] Edge latest

### Cross-Device (if responsive)
- [ ] Desktop (1920x1080)
- [ ] Tablet (768x1024)
- [ ] Mobile (375x667)
```


## Test Execution Process

### Pre-Execution Setup

```markdown
1. Environment Verification
   - [ ] Test environment deployed
   - [ ] Correct version installed
   - [ ] Test data seeded
   - [ ] External services available

2. Test Preparation
   - [ ] Test cases reviewed
   - [ ] Test data prepared
   - [ ] Test accounts created
   - [ ] Browser/device ready

3. Documentation Ready
   - [ ] Requirements accessible
   - [ ] Test case document open
   - [ ] Defect template ready
   - [ ] Screenshot tool available
```

### Execution Tracking

| Test ID | Status | Executor | Date | Defects |
|---------|--------|----------|------|---------|
| TC-001 | Pass | JD | 2024-01-15 | - |
| TC-002 | Fail | JD | 2024-01-15 | DEF-042 |
| TC-003 | Blocked | JD | 2024-01-15 | DEF-041 |
| TC-004 | Skip | - | - | N/A (out of scope) |

### Post-Execution Reporting

```markdown
## Test Execution Report

**Execution Summary**
| Metric | Count | Percentage |
|--------|-------|------------|
| Total Tests | 50 | 100% |
| Passed | 42 | 84% |
| Failed | 5 | 10% |
| Blocked | 2 | 4% |
| Skipped | 1 | 2% |

**Defects Found**: 5
- Critical: 0
- Major: 2
- Minor: 2
- Cosmetic: 1

**Release Recommendation**:
[ ] Ready for release
[X] Ready with known issues
[ ] Not ready - critical defects

**Notes**:
[Summary of findings, risks, and recommendations]
```


## Quality Checks

| Check | Question |
|-------|----------|
| Traceability | Does every test link to a requirement? |
| Coverage | Are all features and scenarios tested? |
| Reproducibility | Can tests be repeated with same results? |
| Independence | Do tests work in any execution order? |
| Clarity | Are test steps unambiguous? |
| Completeness | Are expected results specific and verifiable? |
| Efficiency | Are there redundant or duplicate tests? |
| Maintainability | Will tests need updates when code changes? |


## Anti-Patterns

| Pattern | Problem | Fix |
|---------|---------|-----|
| Happy Path Only | Misses error conditions | Add error and boundary tests |
| Test Everything | Wastes time on trivial cases | Focus on risk-based testing |
| Vague Expected Results | Cannot determine pass/fail | Specify exact expected values |
| Environment Dependent | Tests fail in different environments | Use test data, mock externals |
| Test Data Hardcoded | Brittle tests, conflicts | Use factories, unique values |
| No Traceability | Cannot verify coverage | Link tests to requirements |
| Manual Only | Slow, inconsistent | Automate repetitive tests |
| Untriaged Defects | Backlog grows unmanaged | Regular triage meetings |


## Test Data Management

### Test Data Strategies

| Strategy | When to Use | Example |
|----------|-------------|---------|
| Static Data | Reference data, config | Country codes, status values |
| Generated Data | Unique values needed | `user_${uuid}@test.com` |
| Fixtures | Complex object graphs | Seeded database state |
| Factories | Dynamic test objects | `createTestUser(overrides)` |
| Snapshots | API response verification | Saved expected responses |

### Test Data Isolation

```javascript
// Good: Isolated test data
describe('User Service', () => {
  let testUser;

  beforeEach(async () => {
    testUser = await createTestUser();
  });

  afterEach(async () => {
    await deleteTestUser(testUser.id);
  });

  it('should update user email', async () => {
    const newEmail = `updated_${Date.now()}@test.com`;
    await userService.updateEmail(testUser.id, newEmail);
    const updated = await userService.getById(testUser.id);
    expect(updated.email).toBe(newEmail);
  });
});
```


## Related Skills

- **test-patterns**: Unit and integration test patterns
- **aiou-decomposition**: Understanding what to test per AIOU
- **code-review-checklist**: Reviewing test quality
- **defect-triage**: Managing and prioritizing defects
- **test-automation**: Converting manual tests to automated
