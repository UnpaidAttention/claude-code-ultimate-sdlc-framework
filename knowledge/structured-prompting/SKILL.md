---
name: structured-prompting
description: Use when dispatching subagents or starting new council phases to ensure consistent context transfer
---

# Structured Prompting for Subagents

## Purpose

Ensure every subagent receives complete, consistent context when dispatched. Prevents context loss during handoffs and phase transitions.

## When to Use

- Dispatching a subagent for a specific task
- Starting a new council phase
- Handing off between councils
- Resuming work after session break

## Prompt Template

```markdown
## Context

**Council**: [Planning|Development|Audit|Validation]
**Phase**: [Current phase number and name]
**Task**: [Specific task being delegated]

## Background

[2-3 sentences about what led to this task]

## Objective

[Single clear sentence stating what needs to be accomplished]

## Success Criteria

- [ ] [Measurable criterion 1]
- [ ] [Measurable criterion 2]
- [ ] [Measurable criterion 3]

## Constraints

- [Technical constraint]
- [Process constraint]
- [Quality requirement]

## Resources

- **Spec**: [Path to relevant spec if applicable]
- **Related Files**: [List of files to reference]
- **Previous Work**: [Reference to related completed work]

## Expected Output

[Describe what artifact or state change is expected]

## Handoff Instructions

When complete:
1. Update WORKING-MEMORY.md with outcome
2. [Additional handoff step if needed]
```

## Example: Dispatching Development Subagent

```markdown
## Context

**Council**: Development
**Phase**: Phase 2 - Wave Execution
**Task**: Implement user authentication feature (AIOU-023)

## Background

Planning Council completed Phase 4 with approved specs. This AIOU handles
JWT-based authentication as the first feature in Wave 1.

## Objective

Implement JWT authentication following spec at specs/aious/AIOU-023.md

## Success Criteria

- [ ] All acceptance criteria from AIOU-023 pass
- [ ] Unit tests achieve >80% coverage
- [ ] Integration tests pass
- [ ] No security vulnerabilities (OWASP top 10)

## Constraints

- Use existing database connection patterns in src/db/
- Follow error handling patterns established in src/utils/errors.ts
- Must complete within current wave timeframe

## Resources

- **Spec**: specs/aious/AIOU-023.md
- **Related Files**: src/auth/, src/middleware/
- **Previous Work**: ADR-005 (authentication approach decision)

## Expected Output

- Implemented auth module in src/auth/
- Test files in tests/auth/
- Updated API documentation
- Commit with message referencing AIOU-023

## Handoff Instructions

When complete:
1. Update council-state/development/WORKING-MEMORY.md
2. Mark AIOU-023 as complete in progress.md
3. Run full test suite and document results
```

## Minimal Template (Quick Tasks)

For simple, well-defined tasks:

```markdown
**Task**: [What to do]
**Context**: [Council] Council, Phase [N]
**Success**: [How we know it's done]
**Output**: [What to produce]
```

## Integration with RARV

After subagent completes, verify using RARV cycle:

1. **Reason**: Did subagent understand the task correctly?
2. **Act**: Review the produced artifact
3. **Reflect**: Does output meet success criteria?
4. **Verify**: Run tests, check against spec

## Common Mistakes

| Mistake | Impact | Prevention |
|---------|--------|------------|
| Vague objective | Subagent guesses intent | Use single clear sentence |
| Missing constraints | Violates patterns | List all known constraints |
| No success criteria | Cannot verify completion | Make criteria measurable |
| Missing resources | Subagent searches blindly | List all relevant files |

## Council-Specific Extensions

### Planning Council

Add to template:
- **Stakeholders**: Who needs to approve
- **Dependencies**: What must exist first

### Development Council

Add to template:
- **Testing Requirements**: Specific test types needed
- **Code Patterns**: Reference existing patterns to follow

### Audit Council

Add to template:
- **Test Matrix Reference**: Link to test matrix
- **Coverage Requirements**: Minimum thresholds

### Validation Council

Add to template:
- **Layer Checklist**: Which of 8 layers to verify
- **Screenshot Requirements**: Before/after needed?
