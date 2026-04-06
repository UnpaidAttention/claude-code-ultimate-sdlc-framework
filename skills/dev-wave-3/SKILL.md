---
name: sdlc-dev-wave-3
description: |
  Execute Development Wave 3 - Services. Implement business logic services and domain operations.
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Agent
  - AskUserQuestion
---

## Preamble (run first)

```bash
# Detect project state
AG_HOME="${HOME}/.Ultimate SDLC"
AG_PROJECT=".ultimate-sdlc"
AG_SKILLS="${HOME}/.claude/skills/ultimate-sdlc"

# Check if project is initialized
if [ -d "$AG_PROJECT" ]; then
  echo "PROJECT: initialized"
  # Read current state
  if [ -f "$AG_PROJECT/project-context.md" ]; then
    COUNCIL=$(grep -A1 "## Active Council" "$AG_PROJECT/project-context.md" | tail -1 | tr -d ' ')
    PHASE=$(grep -A1 "## Current Phase" "$AG_PROJECT/project-context.md" | tail -1 | tr -d ' ')
    STATUS=$(grep -A1 "## Status" "$AG_PROJECT/project-context.md" | tail -1 | tr -d ' ')
    echo "COUNCIL: $COUNCIL"
    echo "PHASE: $PHASE"  
    echo "STATUS: $STATUS"
  fi
else
  echo "PROJECT: not initialized (run /init first)"
fi

# Read global config
if [ -f "$AG_HOME/config.yaml" ]; then
  GOV_MODE=$(grep "governance_mode:" "$AG_HOME/config.yaml" | awk '{print $2}')
  PROJ_TYPE=$(grep "project_type:" "$AG_HOME/config.yaml" | awk '{print $2}')
  echo "GOVERNANCE: ${GOV_MODE:-standard}"
  echo "PROJECT_TYPE: ${PROJ_TYPE:-web-app}"
fi
```

After the preamble runs, use the detected state to verify prerequisites for this workflow.

## Knowledge Skills

Load these knowledge skills for reference during this workflow:
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/clean-code/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/architecture-principles/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/test-patterns/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/api-patterns/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


# /dev-wave-3 - Services

## Lens / Skills / Model
**Lens**: `[Architecture]` + `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol, code review protocol per `council-development.md`

## Prerequisites

- Wave 2 (Data Layer) must be complete

If prerequisites not met:
```
Wave 2 not complete. Run /dev-wave-2 first.
```

---

## Workflow

### Step 1: Update Project State

Update `.ultimate-sdlc/project-context.md`:
- Set `Active Council`: development
- Set `Current Wave`: 3 - Services
- Set `Status`: in_progress

### Step 2: Review Wave 3 AIOUs

**SCOPE**: In multi-run mode, process only current run's AIOUs.

Read from `specs/wave-summary.md` and `specs/aious/`:
- List all Wave 3 AIOUs (filtered by run if multi-run)
- Understand business logic requirements
- Review relevant feature specs

**Feature Context Loading** (per council-development.md § Feature Context Loading Protocol):
For each AIOU in this wave, read the parent FEAT spec and deep-dive.
Record feature context in WORKING-MEMORY.md before beginning implementation.

### Step 3: Service Architecture

Follow clean architecture:

```
┌─────────────────────────────────────┐
│           API Layer (Wave 4)         │
└─────────────────┬───────────────────┘
                  │
┌─────────────────▼───────────────────┐
│         Service Layer (Wave 3)       │
│  - Business logic                    │
│  - Domain operations                 │
│  - Use cases                         │
└─────────────────┬───────────────────┘
                  │
┌─────────────────▼───────────────────┐
│         Data Layer (Wave 2)          │
└─────────────────────────────────────┘
```

### Step 4: Implementation Pattern

For each service:

1. **Define service interface**

   ### Agent: sdlc-backend-specialist
   Invoke via Agent tool with `subagent_type: "sdlc-backend-specialist"`:
   - **Provide**: AIOU spec, feature requirements, data layer interfaces from Wave 2, architecture ADRs
   - **Request**: Design service interface, dependency injection strategy, business validation rules, and error handling patterns
   - **Apply**: Use the specialist's service design as the blueprint for implementation

2. **Write unit tests** (TDD)

   ### Agent: sdlc-tdd-guide
   Invoke via Agent tool with `subagent_type: "sdlc-tdd-guide"`:
   - **Provide**: Service interface definition, AIOU acceptance criteria, business validation rules
   - **Request**: Generate failing test cases covering business logic, error paths, edge cases, and dependency mocking
   - **Apply**: Integrate tests, confirm RED, then implement to GREEN

3. **Implement service**
   - Single responsibility
   - Dependency injection
   - Business validation
   - Error handling
4. **Run tests** - Verify passing
5. **Self-review** - Check quality

   ### Agent: sdlc-code-reviewer
   Invoke via Agent tool with `subagent_type: "sdlc-code-reviewer"`:
   - **Provide**: Implemented service code, test results, AIOU acceptance criteria
   - **Request**: Review for SRP violations, leaky abstractions, missing error handling, and direct DB access
   - **Apply**: Fix all CRITICAL and HIGH issues before marking AIOU complete

6. **Commit**

### Step 5: Common Wave 3 Components

Typical services include:
- User service
- Authentication service
- Business domain services
- Notification service
- External integration services

### Step 6: Quality Standards

Each service must:
- [ ] Follow single responsibility principle
- [ ] Use dependency injection
- [ ] Have comprehensive unit tests
- [ ] Handle all error cases
- [ ] Log appropriately
- [ ] Not contain controller/API logic
- [ ] Not directly access database (use repositories)

### Step 7: Wave Completion Criteria

**SCOPE**: In multi-run mode, verify only current run's AIOUs.

Before completing this wave, verify:
- [ ] All Wave 3 AIOUs **in current run** implemented
- [ ] All unit tests passing
- [ ] Test coverage meets target
- [ ] No business logic in repositories
- [ ] Code reviewed (parallel-code-review)
- [ ] Committed with proper messages
- [ ] **If multi-run**: Run tracker Wave 3 column updated for all AIOUs

### Step 8: Complete Wave

When all criteria met:

1. Update `.ultimate-sdlc/project-context.md`:
   - Set Wave 3 status: Complete

2. Update `.ultimate-sdlc/council-state/development/WORKING-MEMORY.md`:
   - Mark completed AIOUs
   - Record session learnings

3. Record metrics in `.metrics/tasks/development/`

4. Create git checkpoint:
   ```bash
   git tag wave-3-complete
   ```

5. Display completion message:

```
## Wave 3: Services - Complete

**AIOUs Completed**: [X]
**Services Created**: [Y]
**Tests**: [N] passing
**Coverage**: [Z]%

**Wave completion security check**: Run `npm audit --audit-level=high` (or stack equivalent). If high/critical findings: fix before proceeding. Run `gitleaks detect --no-git` on files modified in this wave.

**Next Step**: Run `/dev-wave-4` to continue to API Layer
```

---

## Code Review Integration

After completing each AIOU, apply parallel 3-reviewer code review:
- Dispatch 3 reviewers (Security, Quality, Logic focus)
- If unanimous approval, run Devil's Advocate review
- Fix all Critical and High issues before marking complete

---
