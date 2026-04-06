---
name: sdlc-dev-wave-1
description: |
  Execute Development Wave 1 - Utilities and Helpers. Implement shared utility functions and helper modules.
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
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/test-patterns/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/tdd-workflow/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


# /dev-wave-1 - Utilities & Helpers

## Lens / Skills / Model
**Lens**: `[Architecture]` + `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol, code review protocol per `council-development.md`

## Prerequisites

- Wave 0 (Types & Interfaces) must be complete

If prerequisites not met:
```
Wave 0 not complete. Run /dev-start first.
```

---

## Workflow

### Step 1: Update Project State

Update `.ultimate-sdlc/project-context.md`:
- Set `Active Council`: development
- Set `Current Wave`: 1 - Utilities & Helpers
- Set `Status`: in_progress

### Step 2: Review Wave 1 AIOUs

**SCOPE**: In multi-run mode, process only current run's AIOUs.

Read from `specs/wave-summary.md` and `specs/aious/`:
- List all Wave 1 AIOUs (filtered by run if multi-run)
- Understand dependencies
- Note acceptance criteria

**Feature Context Loading** (per council-development.md § Feature Context Loading Protocol):
For each AIOU in this wave, read the parent FEAT spec and deep-dive.
Record feature context in WORKING-MEMORY.md before beginning implementation.

### Step 3: Implementation Pattern

For each Wave 1 AIOU:

1. **Read AIOU spec** - Understand requirements
2. **Write tests first** (TDD)

   ### Agent: sdlc-tdd-guide
   Invoke via Agent tool with `subagent_type: "sdlc-tdd-guide"`:
   - **Provide**: AIOU spec, acceptance criteria, file targets, and project test framework
   - **Request**: Generate failing test cases for all acceptance criteria before implementation
   - **Apply**: Integrate generated tests, confirm they fail (RED), then implement to pass (GREEN)

3. **Implement utility**
4. **Run tests** - Verify passing
5. **Self-review** - Check quality

   ### Agent: sdlc-code-reviewer
   Invoke via Agent tool with `subagent_type: "sdlc-code-reviewer"`:
   - **Provide**: Implemented code, AIOU acceptance criteria, and test results
   - **Request**: Review code against acceptance criteria, clean code standards, and edge case coverage
   - **Apply**: Fix all CRITICAL and HIGH issues before marking AIOU complete

6. **Commit** - Atomic commit with AIOU reference

### Step 4: Common Wave 1 Components

Typical utilities include:
- Date/time helpers
- String manipulation
- Validation functions
- Error classes
- Logging utilities
- Configuration helpers
- Environment utilities

### Step 5: Quality Standards

Each utility must:
- [ ] Have JSDoc/docstring documentation
- [ ] Have unit tests with >80% coverage
- [ ] Handle edge cases
- [ ] Follow project coding standards
- [ ] Be pure functions where possible

### Step 6: Wave Completion Criteria

**SCOPE**: In multi-run mode, verify only current run's AIOUs.

Before completing this wave, verify:
- [ ] All Wave 1 AIOUs **in current run** implemented
- [ ] All tests passing
- [ ] Test coverage meets target
- [ ] Code reviewed (parallel-code-review)
- [ ] No linting errors
- [ ] Committed with proper messages
- [ ] **If multi-run**: Run tracker Wave 1 column updated for all AIOUs

### Step 7: Complete Wave

When all criteria met:

1. Update `.ultimate-sdlc/project-context.md`:
   - Set Wave 1 status: Complete

2. Update `.ultimate-sdlc/council-state/development/WORKING-MEMORY.md`:
   - Mark completed AIOUs
   - Record session learnings

3. Record metrics in `.metrics/tasks/development/`

4. Create git checkpoint:
   ```bash
   git tag wave-1-complete
   ```

5. Display completion message:

```
## Wave 1: Utilities & Helpers - Complete

**AIOUs Completed**: [X]
**Tests**: [Y] passing
**Coverage**: [Z]%

**Wave completion security check**: Run `npm audit --audit-level=high` (or stack equivalent). If high/critical findings: fix before proceeding. Run `gitleaks detect --no-git` on files modified in this wave.

**Next Step**: Run `/dev-wave-2` to continue to Data Layer
```

---

## Code Review Integration

After completing each AIOU, apply parallel 3-reviewer code review:
- Dispatch 3 reviewers (Security, Quality, Logic focus)
- If unanimous approval, run Devil's Advocate review
- Fix all Critical and High issues before marking complete

---
