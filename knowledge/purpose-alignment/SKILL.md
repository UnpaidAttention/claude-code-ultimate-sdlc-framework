name: purpose-alignment
description: |
  Validate that features serve their intended purpose and help users achieve goals.

  Use when: (1) Phase A1 requires purpose alignment assessment, (2) mapping user needs
  to feature implementations, (3) detecting purpose drift where features diverge from
  original intent, (4) scoring features on purpose clarity and goal achievement,
  (5) identifying over-engineering, under-delivery, or wrong abstractions.

# Purpose Alignment

Evaluates whether features actually serve their intended purpose and help users achieve their goals. Functionality alone is not enough—features must deliver meaningful value.

## Core Questions

For every feature, answer:

1. **What is this feature supposed to do?**
   - Stated purpose in requirements
   - User problem it addresses
   - Business goal it supports

2. **Does it actually do that?**
   - Can users achieve the goal?
   - Is the path to success clear?
   - Are obstacles minimized?

3. **Is it the right solution?**
   - Is there a better approach?
   - Are user needs truly met?
   - Does it create new problems?

## Purpose Alignment Assessment

### Step 1: Document Intended Purpose
```markdown
## Feature: [Name]

### Stated Purpose
[From requirements/stories]

### User Goal
[What user wants to accomplish]

### Success Criteria
[How we know it worked]
```

### Step 2: Evaluate Achievement
| Criterion | Met? | Evidence |
|-----------|------|----------|
| User can achieve goal | Y/N/Partial | |
| Path is efficient | Y/N/Partial | |
| No major obstacles | Y/N/Partial | |
| Purpose clearly served | Y/N/Partial | |

### Step 3: Identify Gaps
- What prevents full purpose achievement?
- What causes friction?
- What's missing?

## Purpose Drift Detection

### Signs of Purpose Drift
- Feature complexity exceeds user need
- Original goal obscured by additions
- Users don't use feature as intended
- Alternative workarounds common

### Purpose Drift Analysis
```markdown
## Purpose Drift: [Feature]

### Original Purpose
[What it was meant to do]

### Current State
[What it actually does]

### Drift Indicators
- [Indicator 1]
- [Indicator 2]

### Root Cause
[Why drift occurred]

### Recommendation
[Return to purpose or redefine]
```

## User Goal Mapping

### Goal Hierarchy
```
User Need (high-level)
    └── User Goal (specific)
        └── Task (actionable)
            └── Feature (implementation)
```

### Mapping Template
| User Need | User Goal | Task | Feature | Aligned? |
|-----------|-----------|------|---------|----------|
| [Need] | [Goal] | [Task] | [Feature] | Y/N |

## Purpose Alignment Matrix

Rate each feature:

| Feature | Purpose Clarity | Goal Achievement | Path Efficiency | Overall |
|---------|----------------|------------------|-----------------|---------|
| [Name] | 1-5 | 1-5 | 1-5 | Avg |

### Scoring Guide
- **5**: Perfectly aligned, exceeds expectations
- **4**: Well aligned, minor gaps
- **3**: Partially aligned, notable gaps
- **2**: Poorly aligned, major gaps
- **1**: Misaligned, fails purpose

## Common Misalignment Patterns

### Over-Engineering
Feature does more than needed, adding complexity without value.
- **Symptom**: Users confused by options
- **Fix**: Simplify to core purpose

### Under-Delivery
Feature doesn't fully address the need.
- **Symptom**: Users can't complete goal
- **Fix**: Add missing capabilities

### Wrong Abstraction
Feature addresses a different problem than intended.
- **Symptom**: Users don't use it for stated purpose
- **Fix**: Redesign or reframe

### Missing Context
Feature works but isn't discoverable when needed.
- **Symptom**: Users don't find it when they need it
- **Fix**: Improve discoverability, add contextual triggers

## Assessment Report Template

```markdown
## Purpose Alignment Report: [Feature]

### Executive Summary
[Overall alignment assessment]

### Purpose Analysis
- **Stated Purpose**: [Purpose]
- **User Goal**: [Goal]
- **Alignment Score**: [1-5]

### Achievement Assessment
- Goal fully achievable: [Yes/No/Partial]
- Path is efficient: [Yes/No/Partial]
- Evidence: [Observations]

### Gaps Identified
1. [Gap 1]
2. [Gap 2]

### Recommendations
1. [Recommendation 1]
2. [Recommendation 2]

### Priority
[Critical/High/Medium/Low]
```

## References

- See `references/goal-mapping-examples.md`
- See `references/alignment-case-studies.md`
