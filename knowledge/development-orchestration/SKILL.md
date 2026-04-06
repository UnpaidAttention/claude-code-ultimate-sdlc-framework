---
name: development-orchestration
description: Orchestrates Development Council waves and coordinates AIOU execution. Use when running Development Council.
---

# Development Orchestration

Coordinating the Development Council's wave-based execution.

## When to use this skill

- Running Development Council sessions
- Executing AIOU waves
- Managing integration gates

## Wave Structure

| Wave | Focus | Dependencies |
|------|-------|--------------|
| 0 | Types & Interfaces | None |
| 1 | Utilities | Wave 0 |
| 2 | Data Layer | Wave 0, 1 |
| 3 | Services | Wave 2 |
| 4 | API Layer | Wave 3 (GATE I4) |
| 5 | UI Components | Wave 4 |
| 6 | Integration | All (GATE I8) |

## AIOU Execution Protocol

### For Each AIOU:

1. **Read specification** from planning handoff
2. **Check dependencies** - all prerequisites complete?
3. **Implement** following clean-code principles
4. **Test** against acceptance criteria
5. **Mark complete** in progress.md

### Parallel Execution
- AIOs within same wave can run parallel
- Different features can progress independently
- Shared interfaces must complete first

## Quality Checks

### Per-AIOU
- [ ] Acceptance criteria met
- [ ] Tests written and passing
- [ ] Code follows conventions
- [ ] No new warnings/errors

### Per-Wave
- [ ] All AIOs in wave complete
- [ ] Integration points verified
- [ ] No regressions

## Gate Requirements

**Gate I4 (API Layer)**
- All services implemented
- API contracts match specs
- Integration tests pass

**Gate I8 (Full Integration)**
- End-to-end flows working
- Performance acceptable
- Ready for Audit Council

## Agent Coordination

| Wave | Primary Agents |
|------|---------------|
| 0-1 | lead-developer |
| 2 | backend-engineer, data-engineer |
| 3 | backend-engineer |
| 4 | backend-engineer, api-designer |
| 5 | frontend-engineer |
| 6 | lead-developer, devops-engineer |
