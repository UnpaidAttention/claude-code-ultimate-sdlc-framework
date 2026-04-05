name: completeness-matrix
description: Evaluate features across 10 quality dimensions for comprehensive completeness assessment. Use during Audit Council Phase A2, when scoring feature quality, assessing gaps across functional, error-handling, edge-case, validation, accessibility, performance, security, logging, documentation, and testing dimensions.

# Completeness Matrix

Evaluate features across multiple dimensions to ensure comprehensive quality.

## Purpose

Go beyond "does it work" to evaluate completeness across all quality dimensions.

## The 10 Dimensions

### 1. Functional Completeness
Does the feature do everything it should?

| Check | Score |
|-------|-------|
| Core functionality works | 0-100 |
| All use cases covered | 0-100 |
| All user stories achievable | 0-100 |
| All acceptance criteria met | 0-100 |

### 2. Error Handling
Does it fail gracefully?

| Check | Score |
|-------|-------|
| Errors caught appropriately | 0-100 |
| Error messages helpful | 0-100 |
| Recovery paths exist | 0-100 |
| No silent failures | 0-100 |

### 3. Edge Case Coverage
Are boundaries handled?

| Check | Score |
|-------|-------|
| Empty/null inputs handled | 0-100 |
| Boundary values handled | 0-100 |
| Concurrent access safe | 0-100 |
| Timeout scenarios handled | 0-100 |

### 4. Input Validation
Are inputs verified?

| Check | Score |
|-------|-------|
| All inputs validated | 0-100 |
| Type checking done | 0-100 |
| Range checking done | 0-100 |
| Sanitization complete | 0-100 |

### 5. Accessibility
Can everyone use it?

| Check | Score |
|-------|-------|
| WCAG Level A compliance | 0-100 |
| Keyboard navigable | 0-100 |
| Screen reader compatible | 0-100 |
| Color contrast adequate | 0-100 |

### 6. Performance
Is it fast enough?

| Check | Score |
|-------|-------|
| Response time acceptable | 0-100 |
| No unnecessary operations | 0-100 |
| Caching where appropriate | 0-100 |
| Scalability considered | 0-100 |

### 7. Security
Is it safe?

| Check | Score |
|-------|-------|
| Authentication proper | 0-100 |
| Authorization checked | 0-100 |
| Injection prevented | 0-100 |
| Data protected | 0-100 |

### 8. Logging/Observability
Can we see what's happening?

| Check | Score |
|-------|-------|
| Key actions logged | 0-100 |
| Errors logged with context | 0-100 |
| Debugging possible | 0-100 |
| Metrics available | 0-100 |

### 9. Documentation
Is usage clear?

| Check | Score |
|-------|-------|
| Usage documented | 0-100 |
| API documented | 0-100 |
| Edge cases documented | 0-100 |
| Examples provided | 0-100 |

### 10. Test Coverage
Is it tested?

| Check | Score |
|-------|-------|
| Unit tests exist | 0-100 |
| Integration tests exist | 0-100 |
| Edge cases tested | 0-100 |
| Error paths tested | 0-100 |

## Scoring Guide

| Score | Meaning |
|-------|---------|
| 90-100 | Excellent - exceeds expectations |
| 70-89 | Good - meets requirements |
| 50-69 | Adequate - functional but gaps |
| 30-49 | Poor - significant issues |
| 0-29 | Critical - major failures |

## Assessment Process

### Step 1: Prepare Assessment
```markdown
Feature: [Name]
Assessor: [Agent/Role]
Date: [Date]
```

### Step 2: Score Each Dimension
For each dimension:
1. Review the checks
2. Gather evidence
3. Assign score with justification

```markdown
## Dimension: [Name]

| Check | Score | Evidence | Notes |
|-------|-------|----------|-------|
| [Check 1] | [X] | [evidence] | [notes] |

**Dimension Score**: [X]/100
**Justification**: [Why this score]
```

### Step 3: Compile Matrix
```markdown
## Completeness Matrix: [Feature]

| Dimension | Score | Status |
|-----------|-------|--------|
| Functional Completeness | [X] | [Excellent/Good/Adequate/Poor/Critical] |
| Error Handling | [X] | |
| Edge Case Coverage | [X] | |
| Input Validation | [X] | |
| Accessibility | [X] | |
| Performance | [X] | |
| Security | [X] | |
| Logging | [X] | |
| Documentation | [X] | |
| Test Coverage | [X] | |

**Overall Score**: [Average]/100
**Lowest Dimension**: [Dimension] at [Score]
```

### Step 4: Identify Weaknesses
```markdown
## Weakness Analysis

### Critical Weaknesses (Score < 30)
| Dimension | Score | Issue | Impact |
|-----------|-------|-------|--------|
| [dim] | [X] | [what's wrong] | [impact] |

### High Priority (Score 30-49)
| Dimension | Score | Issue | Impact |
|-----------|-------|-------|--------|

### Medium Priority (Score 50-69)
| Dimension | Score | Issue | Impact |
|-----------|-------|-------|--------|
```

### Step 5: Create Improvement Plan
```markdown
## Improvement Plan

| Priority | Dimension | Current | Target | Action |
|----------|-----------|---------|--------|--------|
| 1 | [dim] | [X] | [Y] | [specific action] |
| 2 | [dim] | [X] | [Y] | [specific action] |
```

## Quick Assessment Template

For rapid assessment:

```markdown
## Quick Completeness: [Feature]

| Dim | Score | Note |
|-----|-------|------|
| Functional | [X] | |
| Errors | [X] | |
| Edge Cases | [X] | |
| Validation | [X] | |
| A11y | [X] | |
| Perf | [X] | |
| Security | [X] | |
| Logging | [X] | |
| Docs | [X] | |
| Tests | [X] | |

**Overall**: [X]/100
**Focus**: [Lowest dimension]
```

## Output Format

```markdown
# Completeness Matrix: [Feature Name]

## Summary
- **Overall Score**: [X]/100
- **Status**: [Excellent/Good/Adequate/Poor/Critical]
- **Weakest Dimension**: [Name] ([Score])
- **Strongest Dimension**: [Name] ([Score])

## Detailed Scores

### Functional Completeness: [X]/100
[Evidence and justification]

### Error Handling: [X]/100
[Evidence and justification]

[Continue for all 10 dimensions]

## Weakness Analysis
| Priority | Dimension | Score | Issue |
|----------|-----------|-------|-------|
| 1 | [dim] | [X] | [issue] |

## Improvement Recommendations
1. [Specific recommendation for top weakness]
2. [Specific recommendation for second weakness]

## Conclusion
[Summary of completeness status and key actions needed]
```

## Quality Checklist

- [ ] All 10 dimensions assessed
- [ ] Evidence provided for each score
- [ ] Weaknesses identified and prioritized
- [ ] Improvement actions specified
- [ ] Overall status accurately reflects reality
