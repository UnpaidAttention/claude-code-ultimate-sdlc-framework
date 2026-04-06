---
name: intent-extraction
description: Extract and analyze user intent from requirements, feature requests, and existing code. Use during Discovery phase, when decomposing ambiguous requirements, clarifying stakeholder needs, establishing feature acceptance criteria, or determining what a feature SHOULD do before validating what it DOES.
---

# Intent Extraction

Extract what features SHOULD do from all available sources.

## Purpose

Before validating implementation, establish clear intent. What is this feature supposed to do?

## Sources of Intent

### Primary Sources
1. **Specifications/PRDs** - Formal requirements
2. **User Stories** - Behavior expectations
3. **Acceptance Criteria** - Pass/fail conditions
4. **API Documentation** - Contract definitions

### Secondary Sources
5. **Code Comments** - Developer intent notes
6. **Commit Messages** - Change rationale
7. **Test Descriptions** - Expected behaviors
8. **Error Messages** - Implied expectations

### Implicit Sources
9. **Code Structure** - Architectural intent
10. **Naming Conventions** - Semantic meaning
11. **Similar Features** - Pattern expectations
12. **Industry Standards** - Common behaviors

## Extraction Process

### Step 1: Identify the Feature
```markdown
Feature: [Name]
Type: [UI Component / API Endpoint / Service / Utility / etc.]
Location: [file:line or module]
```

### Step 2: Gather Sources
```markdown
Sources consulted:
- [ ] Specification/PRD
- [ ] User stories
- [ ] API documentation
- [ ] Code comments
- [ ] Test descriptions
- [ ] Similar features
```

### Step 3: Extract Core Intent
```markdown
## Core Intent

**Primary Purpose**: [One sentence - what is this feature for?]

**User Benefit**: [Why does this feature exist?]

**Success Criteria**: [How do we know it's working?]
```

### Step 4: Document User Story
```markdown
## User Story

As a [user type]
I want to [action/goal]
So that [benefit/outcome]

**Actors**: [Who uses this?]
**Triggers**: [What initiates this?]
**Preconditions**: [What must be true before?]
**Postconditions**: [What should be true after?]
```

### Step 5: List Acceptance Criteria
```markdown
## Acceptance Criteria

### Functional
- [ ] AC-001: [Specific testable criterion]
- [ ] AC-002: [Specific testable criterion]

### Error Handling
- [ ] AC-ERR-001: [How errors should be handled]

### Edge Cases
- [ ] AC-EDGE-001: [Edge case handling]

### Performance
- [ ] AC-PERF-001: [Performance expectation]

### Security
- [ ] AC-SEC-001: [Security requirement]
```

### Step 6: Define Expected Behaviors
```markdown
## Expected Behaviors

| Scenario | Input | Expected Output | Notes |
|----------|-------|-----------------|-------|
| Happy path | [valid input] | [expected result] | |
| Invalid input | [invalid input] | [error handling] | |
| Edge case | [boundary input] | [expected handling] | |
| Error condition | [error trigger] | [graceful failure] | |
```

### Step 7: Identify Edge Cases
```markdown
## Edge Cases

| Edge Case | Expected Handling |
|-----------|------------------|
| Empty input | [behavior] |
| Maximum values | [behavior] |
| Minimum values | [behavior] |
| Null/undefined | [behavior] |
| Concurrent access | [behavior] |
| Timeout | [behavior] |
| Network failure | [behavior] |
```

### Step 8: Note Implicit Requirements
```markdown
## Implicit Requirements

Derived from context/industry standards:
1. [Implicit requirement 1] - Source: [where derived from]
2. [Implicit requirement 2] - Source: [where derived from]

Assumptions made:
1. [Assumption 1] - Rationale: [why assumed]
2. [Assumption 2] - Rationale: [why assumed]
```

## Output Format

```markdown
# Intent Map: [Feature Name]

## Overview
- **Feature**: [Name]
- **Type**: [Category]
- **Location**: [file:line]
- **Intent Source Quality**: [High/Medium/Low] - [explanation]

## Core Intent
**Purpose**: [What it should do]
**User**: [Who uses it]
**Benefit**: [Why it exists]

## User Story
As a [user type]
I want to [action]
So that [benefit]

## Acceptance Criteria
| ID | Criterion | Category | Priority |
|----|-----------|----------|----------|
| AC-001 | [criterion] | Functional | Must |
| AC-002 | [criterion] | Error | Must |

## Expected Behaviors
| Scenario | Input | Expected Output |
|----------|-------|-----------------|
| [scenario] | [input] | [output] |

## Edge Cases
| Case | Expected Handling |
|------|------------------|
| [case] | [handling] |

## Implicit Requirements
| Requirement | Source | Confidence |
|-------------|--------|------------|
| [requirement] | [source] | High/Medium/Low |

## Open Questions
- [Question needing clarification]
```

## Common Pitfalls

### Pitfall: Assuming Intent from Implementation
Don't derive intent solely from code. Code may be wrong.

### Pitfall: Missing Edge Cases
Actively seek boundary conditions. Don't wait for them to appear.

### Pitfall: Vague Acceptance Criteria
"It should work" is not testable. Be specific.

### Pitfall: Ignoring Error Handling Intent
Error handling is part of intent, not an afterthought.

## Quality Checklist

- [ ] Intent source documented
- [ ] User story complete (who, what, why)
- [ ] Acceptance criteria testable
- [ ] Edge cases identified
- [ ] Error handling expectations documented
- [ ] Performance expectations noted
- [ ] Security requirements captured
- [ ] Implicit requirements made explicit
