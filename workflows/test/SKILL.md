---
name: sdlc-test
description: |
  Test-Driven Development command. Follows RED-GREEN-REFACTOR cycle with Iron Law enforcement.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/tdd-methodology/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/test-engineering/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/systematic-debugging/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /test - Test-Driven Development

## Arguments
| Argument | Required | Description |
|----------|----------|-------------|
| (none) | — | Session auto-detects state |

---

## Purpose

This command implements Test-Driven Development (TDD) for creating, running, and fixing tests.

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per the active council rules file

## The Iron Law

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

Write code before the test? Delete it. Start over.

**No exceptions:**
- Don't keep it as "reference"
- Don't "adapt" it while writing tests
- Delete means delete

---

## Sub-commands

```
/test                - Run all tests
/test [file/feature] - Generate tests using TDD for specific target
/test coverage       - Show test coverage report
/test watch          - Run tests in watch mode
/test fix            - Fix failing tests using systematic debugging
```

---

## TDD Workflow: Red-Green-Refactor

### RED - Write Failing Test

1. Write ONE minimal test showing what should happen
2. **Run the test** - Verify it fails
3. **Confirm failure reason** - Must fail because feature is missing, not typos

Requirements:
- One behavior per test
- Clear descriptive name
- Real code (no mocks unless unavoidable)

### GREEN - Write Minimal Code

1. Write the SIMPLEST code to pass the test
2. **Run the test** - Verify it passes
3. **Check other tests** - Must still pass

Don't add features, refactor other code, or "improve" beyond the test.

### REFACTOR - Clean Up

After green only:
- Remove duplication
- Improve names
- Extract helpers

**Keep tests green. Don't add behavior.**

---

## Verification Steps (MANDATORY)

### After RED phase:
```bash
npm test path/to/test.test.ts
```
Confirm:
- Test fails (not errors)
- Failure message is expected
- Fails because feature missing (not typos)

### After GREEN phase:
```bash
npm test
### Output Format

**Running test...**
```
FAIL: expected X, got undefined
```
✅ Test fails correctly - feature missing

### GREEN Phase - Minimal Implementation

```typescript
// Implementation
```

**Running test...**
```
PASS
```
✅ Test passes - all tests green

### REFACTOR Phase

[Any cleanup performed]

**Running all tests...**
```
All tests passing
```

### Verification Checklist
- [x] Test failed before implementation
- [x] Test failed for expected reason
- [x] Wrote minimal code to pass
- [x] All tests pass
- [x] Output pristine
```

---

## Test Anti-Patterns to Avoid

### ❌ Testing Mock Behavior
Don't assert on mock elements - test real component behavior

### ❌ Test-Only Methods in Production
Don't add methods to production classes that are only used by tests

### ❌ Mocking Without Understanding
Understand dependencies before mocking - mock at the right level

### ❌ Incomplete Mocks
Mock the COMPLETE data structure as it exists in reality

### ❌ Tests as Afterthought
Testing is part of implementation, not optional follow-up

---

## Common Rationalizations (Don't Fall For These)

| Excuse | Reality |
|--------|---------|
| "Too simple to test" | Simple code breaks. Test takes 30 seconds. |
| "I'll test after" | Tests passing immediately prove nothing. |
| "Already manually tested" | Ad-hoc ≠ systematic. No record, can't re-run. |
| "TDD will slow me down" | TDD faster than debugging. |

---

## Examples

```
/test src/services/auth.service.ts
/test user registration flow
/test fix
/test coverage
```

---

## Related Skills

- `systematic-debugging` - For debugging failing tests
- `verification-before-completion` - Verify work before claiming complete
- `playwright-skill` - For E2E testing
- `test-fixing` - For fixing broken tests

---

## Key Principles

- **Test first, code second** - Always
- **Watch test fail** - Proves it tests something
- **Minimal implementation** - Just enough to pass
- **One behavior per test** - Keep focused
- **Describe behavior** - Not implementation details
