---
name: parallel-code-review
description: Use when code needs review before commit or merge to catch issues through diverse perspectives
---

# Parallel 3-Reviewer Code Review

## Purpose

Catch issues that single-reviewer misses by using three heterogeneous reviewers in parallel with blind review and devil's advocate for unanimous approvals.

## When to Use

- Before merging feature branches
- After completing AIOUs
- Before phase transitions involving code
- When code touches security-critical paths

## The Process

```
    ┌─────────────────────────────────────────┐
    │           Code Ready for Review          │
    └─────────────────┬───────────────────────┘
                      │
         ┌────────────┼────────────┐
         │            │            │
         ▼            ▼            ▼
    ┌─────────┐  ┌─────────┐  ┌─────────┐
    │Reviewer │  │Reviewer │  │Reviewer │
    │    A    │  │    B    │  │    C    │
    │(Security)│  │(Quality)│  │(Logic) │
    └────┬────┘  └────┬────┘  └────┬────┘
         │            │            │
         └────────────┼────────────┘
                      ▼
              ┌──────────────┐
              │ Merge Reviews│
              │  (Blind)     │
              └──────┬───────┘
                     │
              ┌──────┴──────┐
              │  Unanimous? │
              └──────┬──────┘
                     │
           ┌─────────┴─────────┐
           │                   │
           ▼                   ▼
    ┌─────────────┐     ┌─────────────┐
    │Devil's      │     │ Aggregate   │
    │Advocate     │     │ Findings    │
    │Review       │     │             │
    └──────┬──────┘     └──────┬──────┘
           │                   │
           └─────────┬─────────┘
                     ▼
              ┌──────────────┐
              │ Final Report │
              └──────────────┘
```

## Reviewer Roles

### Reviewer A: Security Focus

Look for:
- Input validation gaps
- Authentication/authorization issues
- Injection vulnerabilities (SQL, XSS, command)
- Sensitive data exposure
- Insecure dependencies
- Cryptographic weaknesses

### Reviewer B: Code Quality Focus

Look for:
- Code style consistency
- DRY violations
- Test coverage gaps
- Documentation completeness
- Error handling patterns
- Performance concerns

### Reviewer C: Logic & Correctness Focus

Look for:
- Business logic errors
- Edge case handling
- Race conditions
- State management issues
- Integration correctness
- Spec compliance

## Review Template

Each reviewer completes independently:

```markdown
## Code Review - Reviewer [A/B/C]

**Focus Area**: [Security/Quality/Logic]
**Files Reviewed**: [List of files]
**Commit Range**: [SHA range]

### Findings

#### Critical (Must Fix)
- [ ] [Finding with file:line reference]

#### High (Should Fix)
- [ ] [Finding with file:line reference]

#### Medium (Consider Fixing)
- [ ] [Finding with file:line reference]

#### Low (Nice to Have)
- [ ] [Finding with file:line reference]

### Strengths

- [What was done well]

### Verdict

[ ] APPROVE - No blocking issues
[ ] REQUEST CHANGES - Has blocking issues
[ ] NEEDS DISCUSSION - Requires team input
```

## Blind Review Process

1. **Dispatch three reviewers in parallel** with same code but different focus
2. **Collect reviews independently** - reviewers don't see each other's findings
3. **Merge after all complete** - aggregate findings by severity
4. **Remove duplicates** - same issue found by multiple reviewers counts once
5. **Flag consensus** - issues found by 2+ reviewers get priority

## Devil's Advocate Protocol

Triggered when all three reviewers approve unanimously.

**Purpose**: Challenge groupthink, find what everyone missed.

```markdown
## Devil's Advocate Review

**Trigger**: Unanimous APPROVE from all reviewers

### Challenge Areas

1. **What edge cases weren't tested?**
2. **What could fail under load?**
3. **What assumptions are we making?**
4. **What would an attacker try?**
5. **What happens when dependencies fail?**

### Findings

[Any issues discovered]

### Final Verdict

[ ] CONFIRM APPROVAL - No new issues
[ ] REQUEST CHANGES - Found blocking issue
```

## Severity Definitions

| Severity | Definition | Blocking |
|----------|------------|----------|
| Critical | Security vulnerability, data loss risk | Yes |
| High | Significant bug, major quality issue | Yes |
| Medium | Minor bug, code smell, missing test | No |
| Low | Style issue, documentation gap | No |

## Aggregated Report Format

```markdown
# Code Review Summary

**Code**: [Description/PR]
**Reviewers**: A (Security), B (Quality), C (Logic)
**Devil's Advocate**: [Yes/No]

## Verdict: [APPROVED / CHANGES REQUESTED]

## Blocking Issues (Must Fix)

| Issue | Severity | Found By | File:Line |
|-------|----------|----------|-----------|
| [Issue] | Critical | A,C | src/auth.ts:45 |
| [Issue] | High | B | tests/api.test.ts:12 |

## Non-Blocking Issues

| Issue | Severity | Found By | File:Line |
|-------|----------|----------|-----------|
| [Issue] | Medium | A | src/utils.ts:88 |

## Consensus Findings

Issues found by 2+ reviewers (high confidence):
- [Issue] (found by A, C)

## Strengths Noted

- [Strength from reviews]

## Next Steps

1. [ ] Fix critical issues
2. [ ] Fix high issues
3. [ ] Consider medium issues
4. [ ] Re-review after fixes
```

## Integration with Development Council

### When to Apply

- **End of Wave**: Review all code from completed wave
- **AIOU Completion**: Review before marking AIOU done
- **Before Handoff**: Review before passing to Audit Council

### Workflow Integration

```
AIOU Implementation
        │
        ▼
    Self-Review (RARV)
        │
        ▼
    Unit Tests Pass
        │
        ▼
    3-Reviewer Review  ← This skill
        │
        ▼
    Fix Issues (if any)
        │
        ▼
    Mark AIOU Complete
```

## Common Mistakes

| Mistake | Impact | Prevention |
|---------|--------|------------|
| Same focus all reviewers | Blind spots | Assign distinct focus areas |
| Reviewers see each other | Anchoring bias | Merge only after all complete |
| Skip devil's advocate | False confidence | Always run for unanimous |
| Ignore medium issues | Tech debt accumulates | Track and schedule |

## Quick Reference

```
1. Dispatch 3 reviewers in parallel (Security, Quality, Logic)
2. Each reviews independently (blind)
3. Merge findings after all complete
4. If unanimous APPROVE → Devil's Advocate
5. Aggregate report with severity blocking rules
6. Fix Critical + High before approval
```
