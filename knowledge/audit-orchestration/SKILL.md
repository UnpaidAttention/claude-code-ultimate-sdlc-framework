---
name: audit-orchestration
description: Orchestrates Audit Council tracks and coordinates quality assessment. Use when running Audit Council.
---

# Audit Orchestration

Coordinating the Audit Council's testing and review tracks.

## When to use this skill

- Running Audit Council sessions
- Executing test tracks
- Generating audit reports

## Track Overview

### Testing Track (T1-T5)

| Phase | Name | Purpose |
|-------|------|---------|
| T1 | Feature Inventory | Map all features |
| T2 | Functional Testing | Test each feature |
| T3 | GUI Analysis | Evaluate UX/UI |
| T4 | Integration Testing | Test workflows |
| T5 | Performance & Security | Non-functional testing |

### Audit Track (A1-A3)

| Phase | Name | Purpose |
|-------|------|---------|
| A1 | Code Review | Quality assessment |
| A2 | Architecture Review | Design evaluation |
| A3 | Documentation Review | Docs completeness |

### Enhancement Track (E1-E3)

| Phase | Name | Purpose |
|-------|------|---------|
| E1 | Opportunity Identification | Find improvements |
| E2 | Prioritization | Rank enhancements |
| E3 | Documentation | Log proposals |

## Defect Classification

| Severity | Definition | Action |
|----------|------------|--------|
| P0 | System unusable | Block release |
| P1 | Major feature broken | Fix before release |
| P2 | Minor issue | Fix if time permits |
| P3 | Cosmetic/enhancement | Future consideration |

## Testing Protocol

### For Each Feature (T2):
1. Execute happy path
2. Test edge cases
3. Test error conditions
4. Verify UI/UX
5. Log any defects

### Defect Logging
```markdown
### DEF-XXX: [Title]

**Severity**: P0-P3
**Feature**: FEAT-XXX
**Steps**: 1. Step 1...
**Expected**: What should happen
**Actual**: What happens
```

## Output Documents

- `audit-handoff.md`: Overall findings and handoff to Validation
- `defect-log.md`: All defects found
- `enhancement-log.md`: Improvement opportunities

## Agent Coordination

| Track | Primary Agents |
|-------|---------------|
| T1-T2 | test-lead, qa-engineer |
| T3 | ux-reviewer |
| T4 | integration-tester |
| T5 | performance-analyst, security-auditor |
| A1-A3 | code-reviewer, documentation-reviewer |
| E1-E3 | enhancement-analyst |
