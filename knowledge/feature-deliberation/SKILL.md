---
name: feature-deliberation
description: Provides framework for evaluating feature trade-offs and building stakeholder consensus. Use during MVP scoping decisions, feature prioritization sessions, resolving competing feature requests, post-discovery scope refinement, or Planning Phase 1.5 deliberation.
---

# Feature Deliberation

> Structured approach to feature evaluation, stakeholder alignment, and scope decisions. Ensures informed trade-offs with documented rationale.


## Core Principles

| Principle | Rule |
|-----------|------|
| **Evidence Over Opinion** | Decisions backed by data, not preferences |
| **Stakeholder Voice** | All relevant perspectives must be heard |
| **Explicit Trade-offs** | Every choice has costs; document them |
| **Reversibility Awareness** | Know which decisions are hard to undo |
| **MVP Discipline** | Minimum means minimum; resist feature creep |
| **Document Everything** | Decisions without rationale are technical debt |


## When to Use

- Planning Phase 1.5 (Deliberation)
- MVP scoping decisions
- Feature prioritization sessions
- Resolving competing feature requests
- Post-discovery scope refinement
- Sprint planning trade-offs


## Deliberation Process Framework

### Phase 1: Feature Collection

```markdown
## Feature Inventory

### Sources Gathered
- [ ] Discovery phase requirements
- [ ] Stakeholder interviews
- [ ] Competitor analysis
- [ ] Technical constraints
- [ ] User feedback/research

### Raw Feature List
| ID | Feature | Source | Initial Category |
|----|---------|--------|------------------|
| F-001 | User authentication | Requirements | Core |
| F-002 | Social login | Stakeholder | Nice-to-have |
| F-003 | Password recovery | Requirements | Core |
```

### Phase 2: Feature Categorization

| Category | Definition | Examples |
|----------|------------|----------|
| **Core** | Essential for MVP; product fails without it | Auth, core workflow |
| **Important** | Significantly improves value; strong case | Search, notifications |
| **Nice-to-have** | Enhances experience; not critical | Themes, social sharing |
| **Future** | Post-MVP consideration | Advanced analytics |
| **Out of Scope** | Explicitly not building | Enterprise features |

### Phase 3: Evaluation

For each feature, complete the evaluation matrix.

### Phase 4: Deliberation

Structured discussion with stakeholders.

### Phase 5: Decision Documentation

Record all decisions with rationale.


## Stakeholder Input Collection

### Stakeholder Identification

| Role | Input Type | Weight | Contact Method |
|------|------------|--------|----------------|
| Product Owner | Business priorities | High | Direct session |
| End Users | Pain points, needs | High | Surveys, interviews |
| Technical Lead | Feasibility, effort | High | Technical review |
| Business Sponsor | Budget, timeline | Medium | Status meetings |
| Support Team | Common issues | Medium | Feedback aggregation |
| Marketing | Market positioning | Low | Async review |

### Input Collection Template

```markdown
## Stakeholder Input: [Role/Name]

### Session Details
- Date: YYYY-MM-DD
- Duration: X minutes
- Facilitator: [Name]

### Key Points Raised
1. Point 1
2. Point 2

### Feature Preferences
| Feature | Support Level | Reasoning |
|---------|---------------|-----------|
| F-001 | Strong | "Critical for launch" |
| F-002 | Neutral | "Nice but not urgent" |
| F-003 | Against | "Too complex for MVP" |

### Concerns Expressed
- Concern 1
- Concern 2

### Quotes (verbatim)
> "Quote that captures key sentiment"
```

### Aggregation Matrix

| Feature | PO | Users | Tech | Sponsor | Support | Consensus |
|---------|-----|-------|------|---------|---------|-----------|
| F-001 | +++ | ++ | + | ++ | + | Strong Yes |
| F-002 | + | +++ | -- | - | ++ | Mixed |
| F-003 | ++ | + | + | + | + | Yes |

Legend: `+++` Strong support, `++` Support, `+` Mild support, `-` Mild against, `--` Against, `---` Strong against


## Trade-off Analysis Patterns

### Value vs Effort Matrix

```
High Value │  Quick Wins  │  Major Projects
           │  (Do First)  │  (Plan Carefully)
           │              │
───────────┼──────────────┼──────────────────
           │              │
Low Value  │  Fill-ins    │  Avoid / Defer
           │  (If Time)   │  (Question Need)
           │              │
           └──────────────┴──────────────────
             Low Effort      High Effort
```

### Multi-Factor Scoring

| Factor | Weight | F-001 | F-002 | F-003 |
|--------|--------|-------|-------|-------|
| User Value | 3x | 5 (15) | 3 (9) | 4 (12) |
| Business Value | 2x | 4 (8) | 5 (10) | 3 (6) |
| Technical Feasibility | 2x | 4 (8) | 2 (4) | 5 (10) |
| Time to Market | 1x | 3 (3) | 2 (2) | 5 (5) |
| Risk | -1x | 2 (-2) | 4 (-4) | 1 (-1) |
| **Total** | | **32** | **21** | **32** |

### Trade-off Documentation Template

```markdown
## Trade-off Analysis: [Decision Topic]

### Options Considered
1. **Option A**: [Description]
2. **Option B**: [Description]
3. **Option C**: [Description]

### Comparison Matrix
| Criterion | Option A | Option B | Option C |
|-----------|----------|----------|----------|
| Development Time | 2 weeks | 4 weeks | 1 week |
| User Experience | Good | Excellent | Acceptable |
| Maintenance Cost | Low | High | Medium |
| Scalability | Limited | High | Medium |
| Risk Level | Low | Medium | Low |

### Recommendation
**Option A** because:
1. Reason 1
2. Reason 2

### Trade-offs Accepted
- Accepting: [What we gain]
- Sacrificing: [What we give up]
- Mitigating: [How we reduce downsides]
```


## Consensus-Building Techniques

### Gradients of Agreement

| Level | Meaning | Action |
|-------|---------|--------|
| 1 - Wholehearted | "I love it" | Proceed |
| 2 - Agreement | "Sounds good" | Proceed |
| 3 - Support with reservations | "I can live with it" | Note concerns |
| 4 - Abstain | "I have no opinion" | Proceed |
| 5 - Disagree but will support | "I don't like it but won't block" | Document dissent |
| 6 - Disagree and want change | "I need X modified" | Negotiate |
| 7 - Block | "I cannot support this" | Must resolve |

### Consensus Check Template

```markdown
## Consensus Check: [Decision]

### Proposal
[Clear statement of what is being decided]

### Stakeholder Positions
| Stakeholder | Level | Notes |
|-------------|-------|-------|
| Product Owner | 2 | Fully supports |
| Tech Lead | 5 | Concerns about timeline |
| Designer | 3 | Prefers Option B aesthetic |

### Consensus Status
- **Level 1-4 (Proceed)**: X stakeholders
- **Level 5 (Dissent Noted)**: Y stakeholders
- **Level 6-7 (Must Address)**: Z stakeholders

### Resolution Path
[If not consensus, what steps to take]
```

### Dot Voting

For prioritizing many features:

```markdown
## Dot Voting Results

Each stakeholder: 5 dots
Total stakeholders: 4
Total dots: 20

| Feature | Dots | % | Rank |
|---------|------|---|------|
| F-001 Auth | 8 | 40% | 1 |
| F-003 Search | 5 | 25% | 2 |
| F-002 Social | 4 | 20% | 3 |
| F-005 Export | 2 | 10% | 4 |
| F-004 Themes | 1 | 5% | 5 |
```

### Disagree and Commit Protocol

When consensus cannot be reached:

1. Document all positions clearly
2. Identify the decision maker
3. Decision maker chooses with rationale
4. Dissenters acknowledge they will support execution
5. Set review checkpoint to evaluate decision


## Decision Documentation Templates

### Feature Decision Record

```markdown
## Decision: [Feature ID] - [Feature Name]

### Status
[MVP | Post-MVP | Out of Scope | Deferred]

### Context
[Why this decision needed to be made]

### Decision
[Clear statement of what was decided]

### Rationale
1. [Reason 1]
2. [Reason 2]
3. [Reason 3]

### Consequences
**Positive:**
- [Benefit 1]
- [Benefit 2]

**Negative:**
- [Drawback 1]
- [Drawback 2]

**Neutral:**
- [Implication 1]

### Alternatives Rejected
| Alternative | Why Rejected |
|-------------|--------------|
| Option B | Too expensive |
| Option C | Too risky |

### Stakeholder Sign-off
- [ ] Product Owner
- [ ] Technical Lead
- [ ] [Other relevant stakeholders]

### Review Date
[When to revisit this decision]
```

### MVP Scope Decision Record

```markdown
## MVP Scope Decision

### Date
YYYY-MM-DD

### Participants
- Name (Role)
- Name (Role)

### MVP Definition
[1-2 sentence description of what MVP delivers]

### Features Included
| ID | Feature | Rationale |
|----|---------|-----------|
| F-001 | User Auth | Core functionality |
| F-003 | Basic Search | User expectation |

### Features Excluded
| ID | Feature | Rationale | Revisit |
|----|---------|-----------|---------|
| F-002 | Social Login | Not essential | Sprint 3 |
| F-004 | Advanced Search | Complexity | Post-launch |

### Scope Boundaries
**In Scope:**
- Item 1
- Item 2

**Explicitly Out of Scope:**
- Item 1 (reason)
- Item 2 (reason)

### Success Criteria
- [ ] Criterion 1
- [ ] Criterion 2

### Risks Accepted
| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Risk 1 | Medium | High | Plan B |
```


## Conflict Resolution Strategies

### Conflict Types and Approaches

| Conflict Type | Approach | Escalation Path |
|---------------|----------|-----------------|
| Technical disagreement | Data-driven evaluation | Architect decision |
| Priority dispute | Stakeholder voting | Product Owner |
| Resource constraint | Trade-off analysis | Sponsor decision |
| Timeline pressure | Scope reduction | Joint negotiation |
| Quality vs Speed | Risk assessment | Team consensus |

### Resolution Framework

```
1. IDENTIFY
   - What exactly is the conflict?
   - Who are the parties?
   - What are the stakes?

2. UNDERSTAND
   - Each party states position
   - Each party states underlying interests
   - Find common ground

3. GENERATE OPTIONS
   - Brainstorm alternatives
   - Consider hybrid approaches
   - Identify creative solutions

4. EVALUATE
   - Score options against criteria
   - Identify acceptable solutions
   - Check for consensus

5. DECIDE
   - If consensus: document and proceed
   - If no consensus: escalate to decision maker
   - Document dissent respectfully

6. COMMIT
   - All parties agree to support decision
   - Set checkpoint for review
   - Move forward constructively
```

### Mediation Template

```markdown
## Conflict Resolution: [Topic]

### Parties
- Party A: [Name/Role]
- Party B: [Name/Role]

### Conflict Summary
[Objective description of disagreement]

### Party A Position
- Position: [What they want]
- Interests: [Why they want it]
- Concerns: [What they're worried about]

### Party B Position
- Position: [What they want]
- Interests: [Why they want it]
- Concerns: [What they're worried about]

### Common Ground
- [Shared interest 1]
- [Shared interest 2]

### Options Generated
1. Option 1
2. Option 2
3. Option 3

### Resolution
[Agreed approach]

### Follow-up
- [ ] Action item 1
- [ ] Review date set
```


## Priority Calculation Formula

### Standard Formula

```
Priority Score = (Value × 2) - Effort - Risk
```

### Extended Formula (for complex decisions)

```
Priority Score = (UserValue × 3 + BusinessValue × 2)
                 - (Effort × 2 + Risk × 1.5)
                 + (StrategicAlignment × 1)
```

### Score Interpretation

| Score Range | Interpretation | Action |
|-------------|----------------|--------|
| 8-10 | Must have | MVP inclusion |
| 5-7 | Should have | Strong candidate |
| 2-4 | Could have | Consider if time |
| < 2 | Won't have | Defer or drop |


## Quality Checks

| Check | Question |
|-------|----------|
| **Coverage** | Have all stakeholders been heard? |
| **Documentation** | Are all decisions documented with rationale? |
| **Trade-offs** | Are trade-offs explicit and accepted? |
| **Consensus** | Is there sufficient agreement to proceed? |
| **Reversibility** | Do we know which decisions are hard to change? |
| **Scope** | Is MVP scope clearly bounded? |


## Anti-Patterns

| Pattern | Problem | Fix |
|---------|---------|-----|
| HiPPO decisions | Highest Paid Person's Opinion dominates | Use structured voting |
| Analysis paralysis | Endless deliberation | Set time limits |
| Scope creep via consensus | "Just one more feature" | Strict MVP discipline |
| Undocumented decisions | No rationale trail | Decision records required |
| False consensus | Silence = agreement | Explicit position checks |
| Revisiting decisions | Relitigating settled issues | Decision lock with review dates |
| Ignoring dissent | Minority concerns dismissed | Document and address |


## Questions to Ask

### MVP Scoping
- What's the smallest version that provides value?
- What can we learn from an early release?
- What's the cost of adding this later?
- What's the risk of not having this now?

### Trade-off Evaluation
- What are we optimizing for?
- What are we willing to sacrifice?
- Is this decision reversible?
- What's the worst-case outcome?

### Stakeholder Alignment
- Who will be most affected by this decision?
- Whose support is essential?
- Who might block this?
- Who needs to be informed?


## Related Skills

- planning-orchestration - Phase flow context
- requirements-analysis - Input to deliberation
- risk-assessment - Informing trade-offs
- stakeholder-management - Input gathering
