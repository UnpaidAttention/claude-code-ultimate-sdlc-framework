name: multi-lens-analysis
description: Analyze software through 5 stakeholder perspectives (end-user, developer, business, operations, security) to overcome AI's narrow focus. Use during Audit Council Phase A1-A2, when evaluating feature completeness from multiple viewpoints, or when ensuring all stakeholder needs are considered.

# Multi-Lens Analysis

View software through 5 perspectives to overcome AI's narrow focus.

## Purpose

AI-generated code often optimizes for one perspective (usually developer convenience) while missing others. Multi-lens analysis ensures all stakeholder views are considered.

## The 5 Lenses

### 1. User Lens
*"What does the end user experience?"*

#### Questions
- Is it intuitive to use?
- Is the feedback clear?
- Are errors understandable?
- Is it accessible to all users?
- Is there delight in the experience?
- Can users recover from mistakes?

#### Assessment Areas
| Area | Rating | Notes |
|------|--------|-------|
| Intuitiveness | 1-5 | Can new users figure it out? |
| Feedback | 1-5 | Does user know what's happening? |
| Error messages | 1-5 | Are errors helpful, not cryptic? |
| Accessibility | 1-5 | WCAG compliance? |
| Efficiency | 1-5 | Minimum steps to goal? |
| Delight | 1-5 | Any pleasant surprises? |

### 2. Operations Lens
*"Can we run this in production?"*

#### Questions
- Can we monitor it?
- Can we debug issues?
- Can we see metrics?
- Can we recover from failures?
- Are there runbooks?
- Can we scale it?

#### Assessment Areas
| Area | Rating | Notes |
|------|--------|-------|
| Logging | 1-5 | Adequate for debugging? |
| Monitoring | 1-5 | Key metrics available? |
| Alerting | 1-5 | Will we know when it fails? |
| Recovery | 1-5 | Can we restore service? |
| Runbooks | 1-5 | Documented procedures? |
| Scalability | 1-5 | Can handle growth? |

### 3. Security Lens
*"Can this be exploited?"*

#### Questions
- Is authentication proper?
- Is authorization checked?
- Are inputs validated?
- Are secrets protected?
- Is data encrypted?
- Does it follow OWASP guidelines?

#### Assessment Areas
| Area | Rating | Notes |
|------|--------|-------|
| Authentication | 1-5 | Identity verified properly? |
| Authorization | 1-5 | Permissions checked? |
| Input validation | 1-5 | All inputs validated? |
| Data protection | 1-5 | Sensitive data secured? |
| Secret management | 1-5 | Credentials safe? |
| OWASP compliance | 1-5 | Top 10 addressed? |

### 4. Performance Lens
*"Is it fast and efficient?"*

#### Questions
- Is response time acceptable?
- Does it handle load?
- Is caching used appropriately?
- Are queries optimized?
- Are resources used efficiently?
- Will it scale?

#### Assessment Areas
| Area | Rating | Notes |
|------|--------|-------|
| Response time | 1-5 | Meets targets? |
| Throughput | 1-5 | Handles expected load? |
| Caching | 1-5 | Appropriate caching? |
| Query efficiency | 1-5 | N+1 problems? |
| Resource usage | 1-5 | CPU/memory efficient? |
| Scalability | 1-5 | Scales horizontally? |

### 5. Business Lens
*"Does it deliver value?"*

#### Questions
- Does it achieve the stated goal?
- Does it serve the user need?
- Is it aligned with business objectives?
- Does it provide ROI?
- Is it maintainable long-term?
- Does it create technical debt?

#### Assessment Areas
| Area | Rating | Notes |
|------|--------|-------|
| Goal achievement | 1-5 | Does what it's supposed to? |
| User value | 1-5 | Solves real problem? |
| Business alignment | 1-5 | Supports objectives? |
| Maintainability | 1-5 | Easy to update? |
| Technical debt | 1-5 | Creates/reduces debt? |
| Future-proofing | 1-5 | Adapts to change? |

## Analysis Process

### Step 1: Identify Feature
```markdown
Feature: [Name]
Description: [Brief description]
Primary stakeholders: [Who uses/maintains this]
```

### Step 2: Apply Each Lens
For each lens:
```markdown
## [Lens Name] Analysis

### Questions Addressed
1. [Question]: [Answer]
2. [Question]: [Answer]

### Assessment
| Area | Rating | Evidence | Gap |
|------|--------|----------|-----|
| [Area] | [1-5] | [Evidence] | [Gap if < 4] |

### Lens Score: [X]/30 (sum of ratings)
### Key Findings:
- [Finding 1]
- [Finding 2]

### Recommendations:
- [Action 1]
- [Action 2]
```

### Step 3: Compare Lenses
```markdown
## Cross-Lens Comparison

| Lens | Score | Status |
|------|-------|--------|
| User | [X]/30 | [Strong/Adequate/Weak] |
| Operations | [X]/30 | |
| Security | [X]/30 | |
| Performance | [X]/30 | |
| Business | [X]/30 | |

### Imbalances
[Note any significant imbalances between lenses]

### Blind Spots
[Areas that appear weak across multiple lenses]
```

### Step 4: Prioritize Actions
```markdown
## Priority Actions

| Priority | Lens | Issue | Action |
|----------|------|-------|--------|
| 1 | [Lens] | [Issue] | [Action] |
| 2 | [Lens] | [Issue] | [Action] |
```

## Lens Balance Indicators

### Healthy Balance
- All lenses score 20+ out of 30
- No lens is more than 10 points below another
- No critical gaps (rating 1) in any area

### Warning Signs
- One lens dominates (30) while others lag (<15)
- Security lens below 20
- Operations lens below 15 for production code
- Business lens disconnected from others

### Red Flags
- Security lens below 15
- Operations lens below 10 for production
- User lens below 15 for user-facing features
- Any area rated 1

## Output Format

```markdown
# Multi-Lens Analysis: [Feature Name]

## Summary
| Lens | Score | Status |
|------|-------|--------|
| User | [X]/30 | |
| Operations | [X]/30 | |
| Security | [X]/30 | |
| Performance | [X]/30 | |
| Business | [X]/30 | |

**Overall Balance**: [Balanced/Imbalanced]
**Weakest Lens**: [Name] ([Score])
**Critical Gaps**: [List or None]

## User Lens ([X]/30)
[Key findings and recommendations]

## Operations Lens ([X]/30)
[Key findings and recommendations]

## Security Lens ([X]/30)
[Key findings and recommendations]

## Performance Lens ([X]/30)
[Key findings and recommendations]

## Business Lens ([X]/30)
[Key findings and recommendations]

## Cross-Lens Insights
[Patterns and blind spots across lenses]

## Priority Actions
| Priority | Lens | Action | Impact |
|----------|------|--------|--------|
| 1 | [Lens] | [Action] | [Impact] |
```

## Quality Checklist

- [ ] All 5 lenses applied
- [ ] Each lens has 6 areas assessed
- [ ] Evidence provided for ratings
- [ ] Gaps identified per lens
- [ ] Cross-lens comparison done
- [ ] Blind spots identified
- [ ] Actions prioritized
