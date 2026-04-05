name: systematic-evaluation
description: |
  Apply structured frameworks for methodical quality assessment using scoring rubrics.

  Use when: (1) Phase A3 requires quality scorecard generation, (2) weighted criteria
  evaluation for decision making, (3) checklist-based feature completeness assessment,
  (4) comparing options with pros/cons analysis, (5) aggregating scores using
  averaging, weighted average, minimum score, or threshold count methods.

# Systematic Evaluation

Structured approaches to methodical quality assessment.

## Evaluation Frameworks

### Weighted Criteria Matrix

```markdown
## Evaluation: [Subject]

### Criteria Definition
| Criterion | Weight | Description |
|-----------|--------|-------------|
| Functionality | 30% | Does it work correctly? |
| Usability | 25% | Is it easy to use? |
| Performance | 20% | Is it fast enough? |
| Maintainability | 15% | Is it easy to maintain? |
| Security | 10% | Is it secure? |

### Scoring (1-5 scale)
| Option | Func | Usab | Perf | Maint | Sec | Weighted |
|--------|------|------|------|-------|-----|----------|
| A | 4 | 3 | 5 | 4 | 3 | 3.85 |
| B | 5 | 4 | 3 | 3 | 4 | 3.95 |
| C | 3 | 5 | 4 | 4 | 5 | 4.05 |

### Recommendation
Option C has highest weighted score.
```

## Checklist-Based Evaluation

### Feature Completeness

```markdown
## Feature Evaluation: [Feature Name]

### Core Functionality
- [ ] Primary use case works (1 point)
- [ ] Secondary use cases work (1 point)
- [ ] Error handling complete (1 point)
- [ ] Edge cases handled (1 point)
- [ ] Integration points work (1 point)

### Quality Attributes
- [ ] Performance acceptable (1 point)
- [ ] Security requirements met (1 point)
- [ ] Accessibility compliant (1 point)
- [ ] Documentation complete (1 point)
- [ ] Tests adequate (1 point)

### Score: X/10
```

### Quality Assessment Rubric

| Level | Score | Description |
|-------|-------|-------------|
| **Excellent** | 5 | Exceeds all requirements |
| **Good** | 4 | Meets all requirements |
| **Acceptable** | 3 | Meets most requirements |
| **Needs Work** | 2 | Meets some requirements |
| **Poor** | 1 | Fails to meet requirements |

## Systematic Review Process

### Step 1: Define Scope
- What is being evaluated?
- What criteria apply?
- What is the success threshold?

### Step 2: Gather Evidence
- Collect data for each criterion
- Document sources
- Note any gaps

### Step 3: Apply Criteria
- Score each criterion
- Use consistent scale
- Document reasoning

### Step 4: Synthesize Results
- Calculate totals
- Identify patterns
- Note outliers

### Step 5: Draw Conclusions
- Overall assessment
- Confidence level
- Recommendations

## Evaluation Templates

### Software Component Assessment

```markdown
## Component Evaluation: [Name]

### Overview
| Attribute | Value |
|-----------|-------|
| Purpose | [What it does] |
| Complexity | Low/Medium/High |
| Criticality | Low/Medium/High |

### Quality Scores (1-5)
| Dimension | Score | Notes |
|-----------|-------|-------|
| Correctness | | |
| Reliability | | |
| Efficiency | | |
| Maintainability | | |
| Security | | |
| **Average** | | |

### Findings
**Strengths:**
- [Strength 1]

**Weaknesses:**
- [Weakness 1]

### Recommendation
[Pass / Conditional Pass / Fail]
```

### Decision Evaluation

```markdown
## Decision Analysis: [Decision]

### Options
1. [Option A]
2. [Option B]
3. [Option C]

### Evaluation Criteria
| Criterion | A | B | C |
|-----------|---|---|---|
| Cost | | | |
| Risk | | | |
| Value | | | |
| Complexity | | | |
| Timeline | | | |

### Pros/Cons Analysis

**Option A:**
- Pros: [List]
- Cons: [List]

**Option B:**
- Pros: [List]
- Cons: [List]

### Recommendation
[Recommended option with reasoning]
```

## Aggregation Methods

### Averaging
Simple mean of all scores. Best when criteria are equally important.

### Weighted Average
Sum of (score × weight). Best when criteria have different importance.

### Minimum Score
Overall score = lowest individual score. Best for pass/fail gates.

### Threshold Count
Count of criteria meeting threshold. Best for checklists.

## Confidence Levels

| Level | Meaning | Use When |
|-------|---------|----------|
| **High** | Strong certainty | Abundant, quality evidence |
| **Medium** | Reasonable certainty | Adequate evidence |
| **Low** | Uncertain | Limited evidence |
| **Very Low** | Highly uncertain | Insufficient evidence |

Always report confidence with conclusions.
