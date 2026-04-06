---
name: critical-analysis
description: |
  Apply rigorous logical analysis and Socratic questioning to evaluate software quality.
---

  Use when: (1) Challenging assumptions about features or architecture, (2) detecting
  logical fallacies in design decisions, (3) evaluating evidence strength for claims,
  (4) surfacing implicit assumptions, (5) applying the six Socratic question types
  (clarifying, assumptions, evidence, perspectives, implications, questioning).

# Critical Analysis

Rigorous analytical thinking for objective software quality assessment. Challenges assumptions, evaluates evidence, and identifies logical flaws through systematic questioning.

## Critical Thinking Foundations

### Core Principles
1. **Question everything**: No assumption is sacred
2. **Demand evidence**: Claims require support
3. **Consider alternatives**: There's always another explanation
4. **Acknowledge uncertainty**: What don't we know?
5. **Follow logic**: Conclusions must follow from premises

## Socratic Method

### The Six Question Types

#### 1. Clarifying Questions
- What do you mean by...?
- Can you give an example?
- How does this relate to...?
- What is the main point?

**Apply to software:**
- What exactly is this feature supposed to do?
- What problem is this solving?
- Who is the user for this?

#### 2. Probing Assumptions
- What are we assuming here?
- Why do we believe that?
- What if that's not true?
- Is that always the case?

**Apply to software:**
- Why do we assume users will find this?
- What if the network is slow?
- Are we assuming too much technical knowledge?

#### 3. Probing Evidence
- What evidence supports this?
- Is that evidence reliable?
- Is there enough evidence?
- What evidence would disprove this?

**Apply to software:**
- What data shows users need this?
- How do we know this approach works?
- Have we tested this assumption?

#### 4. Exploring Perspectives
- What would X think about this?
- What's the alternative viewpoint?
- Who might disagree and why?
- What are we not seeing?

**Apply to software:**
- How would a new user experience this?
- What would a security expert say?
- How do competitors solve this?

#### 5. Probing Implications
- What follows from this?
- What are the consequences?
- What would happen if...?
- How does this affect...?

**Apply to software:**
- What breaks if this fails?
- What happens at scale?
- How does this affect performance?

#### 6. Questioning the Question
- Why is this question important?
- Is this the right question?
- What question should we ask?
- What are we missing?

**Apply to software:**
- Are we solving the right problem?
- Is this the right level of abstraction?
- What are we overlooking?

## Assumption Analysis Framework

### Step 1: Surface Assumptions
List all assumptions (explicit and implicit):

```markdown
## Assumption Inventory: [Feature/Decision]

### Explicit Assumptions
- [Stated assumption 1]
- [Stated assumption 2]

### Implicit Assumptions
- [Unstated belief 1]
- [Unstated belief 2]

### Technical Assumptions
- [Technical assumption 1]

### User Assumptions
- [User behavior assumption 1]
```

### Step 2: Evaluate Each Assumption

| Assumption | Evidence For | Evidence Against | Confidence | Risk if Wrong |
|------------|--------------|------------------|------------|---------------|
| [Assumption] | [Support] | [Counter] | High/Med/Low | [Impact] |

### Step 3: Challenge Critical Assumptions
For each low-confidence, high-risk assumption:
- How can we validate this?
- What would disprove it?
- What's the alternative?

## Logical Fallacy Detection

### Common Fallacies in Software

#### Appeal to Authority
"We should do X because [company] does it."
- Counter: Does their context match ours?

#### Confirmation Bias
Only seeking evidence that supports the decision.
- Counter: What evidence would contradict this?

#### Sunk Cost Fallacy
"We've invested too much to change."
- Counter: What's best going forward, ignoring past investment?

#### False Dichotomy
"We must choose A or B."
- Counter: Are there other options?

#### Hasty Generalization
"It worked in one case, so it will work everywhere."
- Counter: Is the sample representative?

#### Appeal to Novelty
"It's new, so it must be better."
- Counter: What makes the new approach actually better?

#### Appeal to Tradition
"We've always done it this way."
- Counter: Is this still the best approach?

## Evidence Evaluation

### Quality Criteria

| Criterion | Questions |
|-----------|-----------|
| **Relevance** | Does this evidence actually relate to the claim? |
| **Sufficiency** | Is there enough evidence to support the conclusion? |
| **Accuracy** | Is the evidence correct and current? |
| **Authority** | Is the source credible and knowledgeable? |
| **Objectivity** | Is the source unbiased? |

### Evidence Strength Rating
- **Strong**: Multiple reliable sources, directly relevant
- **Moderate**: Some reliable sources, reasonably relevant
- **Weak**: Limited sources, tangentially relevant
- **Absent**: No supporting evidence

## Critical Analysis Template

```markdown
## Critical Analysis: [Subject]

### Summary
[What is being analyzed]

### Key Claims
1. [Claim 1]
2. [Claim 2]

### Assumption Analysis
| Assumption | Valid? | Evidence | Risk |
|------------|--------|----------|------|
| [Assumption] | Y/N/Uncertain | [Evidence] | [Risk] |

### Logical Analysis
- Fallacies identified: [List]
- Logic gaps: [List]

### Evidence Assessment
- Evidence quality: [Strong/Moderate/Weak]
- Missing evidence: [What's needed]

### Alternative Explanations
1. [Alternative 1]
2. [Alternative 2]

### Conclusions
- Confidence level: [High/Medium/Low]
- Key uncertainties: [List]
- Recommendations: [Actions]
```

## References

- See `references/socratic-examples.md`
- See `references/fallacy-catalog.md`
- See `references/evidence-evaluation-guide.md`
