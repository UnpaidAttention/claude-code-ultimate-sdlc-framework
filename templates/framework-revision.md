---
id: FR-NNN
name: <short-slug>
description: <one-line summary of the proposed framework change>
status: proposed
# one of: proposed | accepted | rejected | deferred | applied
created: <ISO 8601 timestamp>
author: framework-retro-<cycle-id>
evidence: []
# feedback entry IDs that motivated this proposal, e.g. [FB-003, FB-007, FB-012]
target_file: <path relative to framework repo root>
# e.g. rules/council-development.md OR skills/dev-wave-3/SKILL.md
target_section: <section header>
# e.g. "Session Protocol" OR "§ Code Review Protocol"
impact: low
# one of: low | medium | high
# low: clarifies existing behavior | medium: adds new check | high: changes control flow
reversibility: easy
# one of: easy | moderate | hard
reviewed_by: null
reviewed_at: null
applied_at: null
applied_commit: null
---

# [FR-NNN] <Title>

## Current state

<!-- Excerpt from the target file showing what's there now. Keep short — one block. -->

```markdown
<exact excerpt from target_file>
```

## Proposed change

<!-- The suggested edit. Show as a diff or as the proposed replacement block. -->

```diff
- <lines being removed>
+ <lines being added>
```

## Rationale

<!-- Why this change? Draw a straight line from the feedback evidence to this edit. -->

## Evidence trail

| FB ID | Observation | How it motivates this change |
|-------|-------------|------------------------------|
| FB-NNN | <one-line> | <connection> |
| FB-MMM | <one-line> | <connection> |

<!-- Per FBP-005: a proposal needs >=2 corroborating feedback entries unless the single
entry describes a framework-level bug (e.g. a rule that contradicts INTEGRITY-RULES). -->

## Risk assessment

- **Blast radius:** <what parts of the framework or user projects could be affected>
- **Reversibility:** <easy / moderate / hard to roll back; reference a prior commit>
- **Conflicts with PRH rules?** <no | yes — if yes, explain how this proposal RESPECTS PRH>
- **Conflicts with existing rules?** <no | yes — list which rules and how to reconcile>

## Recommended next action

- [ ] User reads this proposal
- [ ] User applies the diff to `<target_file>` if accepted
- [ ] Commit message: `framework-revision: FR-NNN <title>`
- [ ] Update this file: set `status: applied`, `applied_at`, `applied_commit`
- [ ] If rejected: set `status: rejected`, keep file as historical record of considered-and-declined changes

## Deletion Proposals (MANDATORY — ≥1 required)

Every retro MUST propose at least one of:

### Option A: Retire a rule/criterion

- **Target**: [file path + section/rule ID]
- **Rationale**: [why this rule can be removed without harm]
- **Hit-rate evidence**: [if a gate criterion — cite times_evaluated and times_failed from gate-hit-rate.md]
- **Risk**: [what could go wrong if deleted]
- **Mitigation**: [how other rules cover the gap]

### Option B: Explicit retention justification

If no rule can be deleted, list the 3 least-used rules from the current cycle and justify why each MUST remain:

1. **Rule**: [path + ID] | **Justification**: [why still needed]
2. **Rule**: [path + ID] | **Justification**: [why still needed]
3. **Rule**: [path + ID] | **Justification**: [why still needed]

Option B is acceptable for the first 3 cycles; after that, Option A is required. Framework accretion without retirement is a red flag.

## Agent must NOT

- [ ] Apply this edit automatically (FR-3, proposal-only rule)
- [ ] Write to the framework repo directory
- [ ] Treat this proposal as authoritative until `status: applied`
