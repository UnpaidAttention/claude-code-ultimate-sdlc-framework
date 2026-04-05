---
name: sdlc-dev-test
description: |
  Run tests and capture results with evidence artifact
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/test-patterns/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/tdd-workflow/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/error-handling/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# Development Test Workflow

> Trigger: `/dev-test`

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocols per `~/.claude/skills/ultimate-sdlc/rules/council-development.md`

## Description

Runs the test suite and generates a comprehensive test report. Use for quick verification without full wave transition.

// turbo-all

## Why This Workflow Exists

Tests should be run frequently during development, not just at wave boundaries. This workflow makes testing easy and produces artifacts for verification.

## Steps

### Step 1: Determine Test Scope

Ask user (or infer from context):
- **All tests**: Full test suite
- **Unit tests only**: Fast feedback
- **Integration tests only**: Cross-component verification
- **Specific file/pattern**: Targeted testing
- **Coverage report**: With coverage metrics

### Step 2: Run Tests

Based on scope, execute:

**All Tests:**
// turbo
```bash
npm test
```

**Unit Tests Only:**
// turbo
```bash
npm test -- --testPathPattern="unit|\.spec\."
```

**Integration Tests Only:**
// turbo
```bash
npm test -- --testPathPattern="integration|\.int\."
```

**With Coverage:**
// turbo
```bash
npm test -- --coverage
```

**Specific Pattern:**
// turbo
```bash
npm test -- --testPathPattern="[pattern]"
```

### Step 3: Analyze Results

**Likely Cause**: [Analysis]
**Suggested Fix**: [Recommendation]

---

### Flaky Tests (if detected)

[Tests that sometimes pass/fail]

### Performance Notes

- Slowest test: [name] ([X]ms)
- Tests over 1s: [count]

### Recommendations

[Based on results:]
- [ ] Fix failing tests before proceeding
- [ ] Improve coverage in [area]
- [ ] Review slow tests for optimization

### Step 5: Handle Failures

If tests fail:

1. **Analyze each failure**
   - Read error message
   - Identify likely cause
   - Suggest fix

2. **Categorize failures**
   - Actual bugs (code is wrong)
   - Test bugs (test is wrong)
   - Environment issues (config/setup)

3. **Recommend action**
   - Fix and re-run
   - Skip if known issue
   - Rollback if widespread failure

### Step 6: Update State

Update `.ultimate-sdlc/progress.md`:
Use **Display Template** from `council-development.md` to show: Test Run: [timestamp]

### Step 7: Announce Results

**If all pass:**
> "✅ All [X] tests passing. Coverage at [Y]%. Ready to continue."

**If failures:**
> "❌ [X] tests failing. See Test Result Artifact for details and recommended fixes."

## Artifacts Generated

- **Test Result Artifact**: Comprehensive test report

## Testing Best Practices

1. **Run tests frequently** - Don't wait for wave boundaries
2. **Fix failures immediately** - Don't accumulate debt
3. **Watch coverage trends** - Should stay above 80%
4. **Review slow tests** - May indicate code problems
5. **Don't skip without reason** - Document why tests are skipped

## Quick Commands Reference

| Need | Command |
|------|---------|
| All tests | `npm test` |
| Watch mode | `npm test -- --watch` |
| Single file | `npm test -- path/to/test.ts` |
| With coverage | `npm test -- --coverage` |
| Verbose | `npm test -- --verbose` |
