---
name: dev-aiou
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
AG_HOME="${HOME}/.antigravity"
AG_PROJECT=".antigravity"
AG_SKILLS="${HOME}/.claude/skills/antigravity"

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
- Read `~/.claude/skills/antigravity/knowledge/clean-code/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/test-patterns/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/aiou-decomposition/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# /dev-aiou - Execute AIOU

## Arguments
| Argument | Required | Description |
|----------|----------|-------------|
| (none) | — | Session auto-detects state |

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocols per `~/.claude/skills/antigravity/rules/council-development.md`

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
- Check .antigravity/progress.md for completed AIOs
- Fail if any dependency incomplete
```

### 3. Implementation

```
IMPLEMENT following:
- Clean code principles
- Existing project patterns
- Acceptance criteria requirements
- Test coverage
```

### 4. Verification

```
VERIFY:
- [ ] All acceptance criteria pass
- [ ] Tests written and passing
- [ ] No linting errors
- [ ] Follows project conventions
```

### 5. Completion

```
UPDATE:
- Mark AIOU complete in .antigravity/progress.md
- Update .antigravity/council-state/development/current-state.md
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
