---
name: sdlc-dev-aiou
description: |
  Execute a specific AIOU from the planning handoff. Follow acceptance criteria strictly.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/clean-code/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/test-patterns/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/aiou-decomposition/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /dev-aiou - Execute AIOU

## Arguments
| Argument | Required | Description |
|----------|----------|-------------|
| (none) | — | Session auto-detects state |

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocols per `~/.claude/skills/ultimate-sdlc/rules/council-development.md`

## CRITICAL RULES

1. **Check dependencies first** - All prerequisites must be complete
2. **Follow acceptance criteria** - Every criterion must pass
3. **Clean code standards** - Use clean-code skill
4. **Mark complete when done** - Update progress tracking

---

## Task

Execute a specific AIOU:

### 1. Load AIOU Specification

```
READ from planning-handoff.md:
- AIOU-XXX specification
- Purpose and scope
- Inputs and outputs
- Acceptance criteria
- File targets
```

### 2. Dependency Check

```
VERIFY all dependencies complete:
- Check .ultimate-sdlc/progress.md for completed AIOs
- Fail if any dependency incomplete
```

### 3. Wave-Aware Agent Selection

Based on the AIOU's wave assignment, invoke the appropriate specialist agent before implementation:

| Wave | Specialist Agent | Purpose |
|------|-----------------|---------|
| Wave 1 | (none) | Utilities are straightforward |
| Wave 2 | `sdlc-database-specialist` | Schema/migration design |
| Wave 3 | `sdlc-backend-specialist` | Service patterns and business logic |
| Wave 4 | `sdlc-api-designer` | Endpoint design and response matrix |
| Wave 5 | `sdlc-frontend-specialist` | Component architecture and UI patterns |
| Wave 6 | `sdlc-integration-tester` | E2E test design and integration strategy |

Invoke the specialist via Agent tool with `subagent_type` matching the table above:
- **Provide**: AIOU spec, acceptance criteria, relevant wave context, and dependency artifacts
- **Request**: Domain-specific design guidance for this AIOU's implementation
- **Apply**: Use the specialist's output as the implementation blueprint

Then ALWAYS invoke these two agents in sequence:

### Agent: sdlc-tdd-guide
Invoke via Agent tool with `subagent_type: "sdlc-tdd-guide"`:
- **Provide**: AIOU spec, acceptance criteria, specialist's design output, project test framework
- **Request**: Generate failing test cases for all acceptance criteria before implementation
- **Apply**: Write tests first (RED), implement to pass (GREEN), then refactor

### Agent: sdlc-code-reviewer
Invoke via Agent tool with `subagent_type: "sdlc-code-reviewer"`:
- **Provide**: Implemented code, test results, AIOU acceptance criteria, specialist's design output
- **Request**: Review against acceptance criteria, clean code standards, and wave-specific quality requirements
- **Apply**: Fix all CRITICAL and HIGH issues before marking AIOU complete

### 4. Implementation

```
IMPLEMENT following:
- Clean code principles
- Existing project patterns
- Acceptance criteria requirements
- Test coverage
```

### 5. Verification

```
VERIFY:
- [ ] All acceptance criteria pass
- [ ] Tests written and passing
- [ ] No linting errors
- [ ] Follows project conventions
```

### 6. Completion

```
UPDATE:
- Mark AIOU complete in .ultimate-sdlc/progress.md
- Update .ultimate-sdlc/council-state/development/current-state.md
- Report completion status
```

---

## Arguments

| Argument | Description |
|----------|-------------|
| AIOU-XXX | The AIOU identifier to execute |

---

## Usage

```
/dev-aiou AIOU-001
/dev-aiou AIOU-015
```
