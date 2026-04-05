name: requirements-engineering
description: Guides requirements gathering and documentation using elicitation techniques, INVEST criteria, and prioritization frameworks. Use when clarifying project scope, writing user stories, creating acceptance criteria, or establishing requirement traceability during discovery phases.

# Requirements Engineering

> Systematic approach to understanding and documenting what needs to be built.
> Good requirements are the foundation of successful projects.


## Core Principles

| Principle | Rule |
|-----------|------|
| **User-Centered** | Start with real user problems, not solutions |
| **Testable** | Every requirement must be verifiable |
| **Traceable** | Link requirements to source and implementation |
| **Prioritized** | Not all requirements are equal |
| **Evolving** | Requirements change; embrace it with process |


## When to Use

- Planning Phase 1 (Discovery)
- Clarifying project scope
- Writing specifications
- Breaking down features into user stories
- Creating acceptance criteria


## Elicitation Techniques

### Technique Selection Matrix

| Technique | Best For | Output | Effort |
|-----------|----------|--------|--------|
| **Stakeholder Interviews** | Understanding goals, constraints | Goals, pain points | Medium |
| **User Observation** | Current workflow understanding | Process maps | High |
| **Surveys/Questionnaires** | Broad input gathering | Quantitative data | Low |
| **Workshops** | Collaborative problem-solving | Shared understanding | Medium |
| **Document Analysis** | Existing system understanding | System constraints | Low |
| **Prototyping** | Validating UI/UX concepts | Visual requirements | High |
| **Competitive Analysis** | Market context | Feature benchmarks | Medium |

### Stakeholder Interview Guide

```markdown
## Interview Template

### Opening (5 min)
- Introduce yourself and purpose
- Explain how input will be used
- Ask permission to take notes

### Context (10 min)
- What is your role?
- How do you interact with [system/process]?
- What are your main goals?

### Current State (15 min)
- Walk me through a typical [task]
- What works well?
- What frustrates you?
- What takes too long?

### Future State (15 min)
- If you could change anything, what would it be?
- What would success look like?
- What constraints should we know about?

### Closing (5 min)
- What haven't I asked that I should?
- Who else should I talk to?
- May I follow up with questions?
```

### Discovery Questions by Domain

| Domain | Key Questions |
|--------|---------------|
| **Users** | Who are they? What do they need? What do they know? |
| **Business** | What's the value? What are the constraints? What's success? |
| **Technical** | What exists? What integrates? What are limitations? |
| **Operational** | Who supports? What's the SLA? How do we deploy? |


## Requirements Types

### Functional Requirements

What the system must do.

| Category | Examples |
|----------|----------|
| User actions | "User can create an account" |
| System responses | "System sends confirmation email" |
| Data processing | "System calculates total with tax" |
| Integrations | "System syncs with CRM every hour" |

### Non-Functional Requirements (NFRs)

How the system must perform.

| Category | Metric | Example |
|----------|--------|---------|
| **Performance** | Response time, throughput | "API responses < 200ms at p95" |
| **Scalability** | Load capacity | "Support 10,000 concurrent users" |
| **Availability** | Uptime | "99.9% availability (8.76h downtime/year)" |
| **Security** | Compliance, controls | "SOC 2 Type II compliant" |
| **Usability** | Task completion | "New user completes signup in < 2 min" |
| **Accessibility** | Standards | "WCAG 2.2 AA compliant" |
| **Maintainability** | Code quality | "80% test coverage minimum" |


## INVEST Criteria for User Stories

### Criteria Definition

| Letter | Criterion | Description | Warning Signs |
|--------|-----------|-------------|---------------|
| **I** | Independent | Can be developed in any order | "This depends on story X" |
| **N** | Negotiable | Details can be discussed | Overly specific implementation |
| **V** | Valuable | Delivers user/business value | "Technical refactoring" only |
| **E** | Estimable | Team can size the effort | "We have no idea" |
| **S** | Small | Fits in a sprint | "This will take months" |
| **T** | Testable | Clear pass/fail criteria | "User is satisfied" |

### INVEST Checklist

```markdown
## Story: [Title]

### I - Independent
- [ ] No hard dependencies on other unfinished stories
- [ ] Can be developed, tested, and released alone

### N - Negotiable
- [ ] Describes what, not how
- [ ] Room for discussion on implementation

### V - Valuable
- [ ] Clear user or business benefit stated
- [ ] Stakeholder agrees it's worth doing

### E - Estimable
- [ ] Team understands scope
- [ ] Acceptance criteria are clear
- [ ] No major unknowns

### S - Small
- [ ] Can complete in one sprint
- [ ] If larger, can be split

### T - Testable
- [ ] Acceptance criteria are specific
- [ ] Can write automated tests
- [ ] QA can verify completion
```

### User Story Template

```markdown
## User Story

**As a** [type of user]
**I want** [goal/desire]
**So that** [benefit/value]

### Acceptance Criteria

Given [precondition]
When [action]
Then [expected result]

### Notes

- Technical considerations
- Design requirements
- Out of scope items

### Definition of Done

- [ ] Code complete and reviewed
- [ ] Tests passing
- [ ] Documentation updated
- [ ] Deployed to staging
- [ ] Product owner approved
```


## Acceptance Criteria Patterns

### Given-When-Then (Gherkin)

```gherkin
Feature: User Registration

Scenario: Successful registration with valid email
  Given I am on the registration page
  And I have not registered before
  When I enter a valid email "user@example.com"
  And I enter a password meeting requirements
  And I click "Register"
  Then I should see a success message
  And I should receive a confirmation email
  And my account should be created with "pending" status

Scenario: Registration fails with existing email
  Given I am on the registration page
  And "user@example.com" is already registered
  When I enter email "user@example.com"
  And I click "Register"
  Then I should see error "Email already in use"
  And no new account should be created
```

### Rule-Based Criteria

```markdown
## Password Requirements

The password must:
- Be at least 12 characters long
- Contain at least one uppercase letter
- Contain at least one lowercase letter
- Contain at least one number
- Contain at least one special character (!@#$%^&*)
- Not be in the list of common passwords
- Not contain the user's email address
```

### Boundary Conditions

| Field | Min | Max | Empty Allowed | Format |
|-------|-----|-----|---------------|--------|
| Username | 3 chars | 30 chars | No | Alphanumeric, underscore |
| Email | 5 chars | 255 chars | No | Valid email format |
| Age | 13 | 120 | Yes | Integer |
| Bio | 0 chars | 500 chars | Yes | UTF-8 text |


## Traceability Matrix

### Matrix Structure

| Req ID | Requirement | Source | Priority | Stories | Tests | Status |
|--------|-------------|--------|----------|---------|-------|--------|
| REQ-001 | User can register | Stakeholder interview | Must | US-101, US-102 | TC-001, TC-002 | Done |
| REQ-002 | User can login | Business requirement | Must | US-103 | TC-003 | In Progress |
| REQ-003 | User can reset password | Support feedback | Should | US-104 | TC-004 | Planned |

### Traceability Benefits

| Benefit | Description |
|---------|-------------|
| **Impact analysis** | See what's affected by changes |
| **Coverage verification** | Ensure all requirements are implemented |
| **Test completeness** | Map tests to requirements |
| **Audit compliance** | Demonstrate due diligence |

### Maintaining Traceability

| Practice | Implementation |
|----------|----------------|
| Unique IDs | REQ-XXX format for all requirements |
| Bidirectional links | Requirements link to stories and vice versa |
| Status tracking | Update as implementation progresses |
| Change history | Document requirement changes |


## Prioritization Frameworks

### MoSCoW Method

| Priority | Definition | Guidance |
|----------|------------|----------|
| **Must** | Critical for release | Without these, release fails |
| **Should** | Important but not critical | High value, can workaround |
| **Could** | Nice to have | Include if time permits |
| **Won't** | Not this time | Explicitly out of scope |

### MoSCoW Distribution

```
Recommended distribution for a release:
┌────────────────────────────────────────┐
│ Must Have: 60%                         │
├────────────────────────────────────────┤
│ Should Have: 20%                       │
├────────────────────────────────────────┤
│ Could Have: 20%                        │
└────────────────────────────────────────┘

"Won't Have" items go to backlog for future consideration
```

### Value vs Effort Matrix

```
            │ High Value
            │
    Quick   │   Strategic
    Wins    │   Priorities
            │
────────────┼────────────────
            │
    Fill    │   Reconsider
    Ins     │   or Defer
            │
            │ Low Value
     Low Effort ──────► High Effort
```

| Quadrant | Action |
|----------|--------|
| **Quick Wins** | Do first - high value, low effort |
| **Strategic** | Plan carefully - high value, high effort |
| **Fill Ins** | Do when capacity allows |
| **Reconsider** | Question if worth doing |

### WSJF (Weighted Shortest Job First)

```
WSJF = Cost of Delay / Job Duration

Cost of Delay = User Value + Time Criticality + Risk Reduction

Higher WSJF = Higher Priority
```

| Factor | Score 1 | Score 5 | Score 10 |
|--------|---------|---------|----------|
| User Value | Minor improvement | Good feature | Critical need |
| Time Criticality | Anytime | Quarter deadline | Immediate |
| Risk Reduction | Low risk | Medium risk | High risk |


## Requirements Attributes

### Standard Attributes

| Attribute | Description | Example |
|-----------|-------------|---------|
| **ID** | Unique identifier | REQ-AUTH-001 |
| **Title** | Brief name | User Registration |
| **Description** | Detailed explanation | Full text |
| **Priority** | MoSCoW or numeric | Must |
| **Source** | Who requested | Product Owner |
| **Rationale** | Why needed | Reduce support tickets |
| **Status** | Current state | Approved |
| **Version** | Change tracking | 1.2 |

### Status Workflow

```
Draft → Under Review → Approved → In Progress → Implemented → Verified
                ↓                       ↓
            Rejected               On Hold
```


## Validation Questions

### Requirement Quality Checklist

| Question | Red Flag If No |
|----------|----------------|
| Is it testable? | Cannot verify completion |
| Is it necessary? | Feature creep |
| Is it unambiguous? | Different interpretations |
| Is it consistent? | Contradicts other requirements |
| Is it feasible? | Cannot implement |
| Is it traceable? | Unknown origin/purpose |
| Is it current? | Outdated information |

### Common Ambiguity Words

| Avoid | Use Instead |
|-------|-------------|
| "Fast" | "< 200ms response time" |
| "Easy" | "Complete in < 3 clicks" |
| "Intuitive" | "No training required" |
| "Flexible" | "Supports formats X, Y, Z" |
| "Robust" | "Handles 1000 concurrent users" |
| "User-friendly" | "Meets WCAG 2.2 AA" |


## Quality Checks

| Check | Question |
|-------|----------|
| **Completeness** | Are all functional areas covered? |
| **Consistency** | Do requirements contradict each other? |
| **Testability** | Can each requirement be verified? |
| **Traceability** | Is the source documented? |
| **Feasibility** | Is implementation realistic? |
| **Priority** | Is relative importance clear? |


## Anti-Patterns

| Pattern | Problem | Fix |
|---------|---------|-----|
| **Solution masquerading as requirement** | Limits options | Focus on the problem/need |
| **Gold plating** | Unnecessary features | Validate with stakeholders |
| **Vague requirements** | Unverifiable | Use specific, measurable criteria |
| **Missing NFRs** | System won't meet expectations | Explicitly capture quality attributes |
| **No prioritization** | Everything is "critical" | Use MoSCoW or value/effort matrix |
| **Requirements freeze** | Can't adapt to learning | Embrace iterative refinement |


## Related Skills

| Need | Skill |
|------|-------|
| Documentation | `@[skills/documentation-standards]` |
| Architecture | `@[skills/architecture-principles]` |
| Security requirements | `@[skills/security-planning]` |
