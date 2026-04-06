---
name: gap-analysis
description: |
  Systematically identify gaps between current and ideal software state.
---

  Use when: (1) Phase A2 requires completeness audit, (2) discovering missing
  functional capabilities, (3) identifying usability gaps and friction points,
  (4) competitor benchmarking for feature gaps, (5) requirement comparison
  against implementation, (6) user feedback mining for unmet needs.

# Gap Analysis

Systematic identification of gaps between current software capabilities and user expectations, industry standards, or stated requirements.

## Gap Categories

### 1. Functional Gaps
Missing or incomplete capabilities.
- Features users expect but don't exist
- Features that exist but are incomplete
- Features that work but don't solve the real problem

### 2. Usability Gaps
Friction in user experience.
- Confusing workflows
- Poor discoverability
- Excessive complexity
- Missing guidance

### 3. Performance Gaps
Speed or efficiency issues.
- Slow response times
- Resource inefficiency
- Scalability limits
- Reliability issues

### 4. Integration Gaps
Missing connections.
- Unsupported platforms
- Missing APIs
- No data portability
- Lack of ecosystem connections

### 5. Documentation Gaps
Missing or inadequate guidance.
- Undocumented features
- Unclear instructions
- Missing examples
- Outdated content

### 6. Accessibility Gaps
Exclusion of users.
- WCAG non-compliance
- Missing assistive technology support
- Language limitations
- Device restrictions

## Gap Analysis Process

### Phase 1: Define Ideal State
```markdown
## Ideal State Definition

### User Goals
| Goal | Ideal Experience |
|------|------------------|
| [Goal] | [How it should work] |

### Feature Expectations
| Category | Expected Capabilities |
|----------|----------------------|
| [Category] | [Expectations] |

### Quality Standards
| Dimension | Target |
|-----------|--------|
| Performance | [Targets] |
| Usability | [Standards] |
| Security | [Requirements] |
```

### Phase 2: Assess Current State
```markdown
## Current State Assessment

### User Goals
| Goal | Current Experience | Gap? |
|------|-------------------|------|
| [Goal] | [How it works now] | Y/N |

### Feature Reality
| Category | Actual Capabilities | Gap? |
|----------|---------------------|------|
| [Category] | [What exists] | Y/N |

### Quality Reality
| Dimension | Actual | Gap? |
|-----------|--------|------|
| Performance | [Actual] | Y/N |
| Usability | [Actual] | Y/N |
```

### Phase 3: Identify Gaps
For each gap found:
```markdown
## Gap: [Title]

### Category
[Functional/Usability/Performance/Integration/Documentation/Accessibility]

### Current State
[What exists now]

### Expected State
[What should exist]

### Gap Description
[Clear description of the difference]

### Impact
[Who is affected and how]

### Severity
[Critical/Major/Minor/Cosmetic]
```

### Phase 4: Prioritize Gaps
Score and rank gaps for remediation.

## Gap Discovery Techniques

### Requirement Comparison
1. List all documented requirements
2. Check each against implementation
3. Note mismatches

| Requirement | Implemented? | Notes |
|-------------|--------------|-------|
| [Req 1] | Yes/Partial/No | [Notes] |

### User Journey Walkthrough
1. Define user goal
2. Attempt to achieve it
3. Note every obstacle, confusion, or failure

### Competitor Benchmarking
| Feature/Capability | Us | Competitor A | Competitor B | Gap? |
|--------------------|-----|--------------|--------------|------|
| [Capability] | ✓/✗ | ✓/✗ | ✓/✗ | [Notes] |

### Industry Standard Comparison
Compare against:
- Industry best practices
- Standard compliance (WCAG, SOC2, etc.)
- Common user expectations

### User Feedback Mining
Analyze:
- Support tickets
- Feature requests
- Complaints
- Workarounds users employ

## Gap Severity Classification

| Severity | Definition | Action |
|----------|------------|--------|
| **Critical** | Blocks user goal entirely | Must address immediately |
| **Major** | Significantly impairs experience | Address in next release |
| **Minor** | Causes inconvenience | Include in roadmap |
| **Cosmetic** | Noticed but minimal impact | Address as time permits |

## Gap Analysis Report Template

```markdown
# Gap Analysis Report

## Executive Summary
- Total gaps identified: [X]
- Critical: [X] | Major: [X] | Minor: [X]
- Priority areas: [List]

## Gap Inventory

### Critical Gaps
| ID | Gap | Category | Impact | Recommendation |
|----|-----|----------|--------|----------------|
| G-001 | [Gap] | [Category] | [Impact] | [Action] |

### Major Gaps
| ID | Gap | Category | Impact | Recommendation |
|----|-----|----------|--------|----------------|
| G-002 | [Gap] | [Category] | [Impact] | [Action] |

### Minor Gaps
| ID | Gap | Category | Impact | Recommendation |
|----|-----|----------|--------|----------------|
| G-003 | [Gap] | [Category] | [Impact] | [Action] |

## Recommendations

### Immediate Actions
1. [Action 1]
2. [Action 2]

### Short-term Roadmap
1. [Initiative 1]
2. [Initiative 2]

### Long-term Considerations
1. [Consideration 1]
2. [Consideration 2]
```

## References

- See `references/gap-analysis-examples.md`
- See `references/prioritization-criteria.md`
- See `references/remediation-planning.md`
