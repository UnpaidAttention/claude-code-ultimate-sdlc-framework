---
name: risk-assessment
description: |
  Identify, analyze, and plan mitigation for project risks.
---

  Use when: (1) Starting Phase 1.5 Deliberation to assess project risks,
  (2) Evaluating technical decisions for potential downsides,
  (3) Creating risk registers and mitigation plans,
  (4) Prioritizing features based on risk/reward,
  (5) Planning contingencies for high-risk components.

# Risk Assessment

Systematic identification and mitigation planning for project risks.

## Overview

This skill provides:
- Risk identification frameworks
- Risk analysis and scoring
- Mitigation strategy development
- Risk register management
- Contingency planning

## Risk Categories

### Technical Risks
- Technology maturity/stability
- Integration complexity
- Performance requirements
- Scalability challenges
- Technical debt

### Schedule Risks
- Dependency delays
- Resource availability
- Scope creep
- Unknown unknowns

### Resource Risks
- Skill gaps
- Team availability
- Budget constraints
- Tool/license availability

### External Risks
- Third-party dependencies
- Regulatory changes
- Market changes
- Vendor stability

## Risk Scoring Matrix

### Probability Scale
| Score | Level | Description |
|-------|-------|-------------|
| 1 | Rare | < 10% chance |
| 2 | Unlikely | 10-30% chance |
| 3 | Possible | 30-60% chance |
| 4 | Likely | 60-90% chance |
| 5 | Almost Certain | > 90% chance |

### Impact Scale
| Score | Level | Description |
|-------|-------|-------------|
| 1 | Negligible | Minor inconvenience |
| 2 | Minor | Some rework needed |
| 3 | Moderate | Significant delay/cost |
| 4 | Major | Milestone missed |
| 5 | Severe | Project failure |

### Risk Score
```
Risk Score = Probability × Impact

1-4: Low (Accept/Monitor)
5-9: Medium (Mitigate)
10-15: High (Active mitigation required)
16-25: Critical (Escalate, consider stopping)
```

## Risk Register Template

```markdown
## Risk Register

| ID | Risk | Category | P | I | Score | Mitigation | Owner | Status |
|----|------|----------|---|---|-------|------------|-------|--------|
| R001 | [description] | Technical | 3 | 4 | 12 | [plan] | [name] | Open |
| R002 | [description] | Schedule | 2 | 3 | 6 | [plan] | [name] | Mitigating |
```

## Mitigation Strategies

### Avoid
- Change approach to eliminate risk
- Remove risky feature/component
- Use proven technology instead

### Transfer
- Use third-party service
- Insurance/contracts
- Outsource risky component

### Mitigate
- Reduce probability (better process)
- Reduce impact (fallback plan)
- Early prototyping/POC

### Accept
- Risk is low enough
- Mitigation cost > risk cost
- Document and monitor

## Risk-Based Decision Framework

When evaluating technical decisions:

1. **Identify alternatives**
2. **For each alternative, assess:**
   - Technical risks
   - Schedule risks
   - Resource risks
3. **Score each risk**
4. **Compare total risk profiles**
5. **Document decision with risk rationale**

## Contingency Planning

For high-risk items (score >= 10):

```markdown
## Contingency Plan: [Risk ID]

**Trigger Conditions**: [when to activate]

**Contingency Actions**:
1. [immediate action]
2. [follow-up action]

**Resources Required**: [what's needed]

**Communication Plan**: [who to notify]

**Recovery Timeline**: [expected duration]
```

## Deliverables

- Risk register (updated throughout project)
- Risk-scored decision records
- Contingency plans for critical risks
- Risk review meeting notes
