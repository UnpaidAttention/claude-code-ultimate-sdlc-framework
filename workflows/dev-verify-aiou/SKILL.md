---
name: dev-verify-aiou
description: |
  Verify AIOU completion against acceptance criteria
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
- Read `~/.claude/skills/antigravity/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/acceptance-criteria/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/test-patterns/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/evidence-capture/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# Development Verify AIOU Workflow

> Trigger: `/dev-verify-aiou [AIOU-XXX]`

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4.5
> Apply RARV cycle, session protocols per `~/.claude/skills/antigravity/rules/council-development.md`

## Description

Verifies that an AIOU is truly complete before marking it done. Checks acceptance criteria, runs tests, and generates evidence artifacts. **An AIOU is NOT complete without passing this verification.**

## Why This Workflow Exists

AI agents frequently claim AIOUs are "complete" when they are not:
- Code written but not tested
- Tests written but failing
- Acceptance criteria partially met
- Build not verified

This workflow enforces rigorous verification with evidence.

## Pre-Conditions

- AIOU must be specified (e.g., AIOU-042)
- Implementation should be complete (code written)
- Code should be saved to files

## Steps

### Step 1: Load AIOU Specification

Read AIOU spec from `planning-handoff.md`:

Use **Display Template** from `council-development.md` to show: Verifying: AIOU-XXX

### Step 2: Verify Files Exist

Check that all expected files were created/modified:

// turbo
```bash
# List files that should exist
ls -la [expected files]

# Check files were recently modified
stat [expected files] | grep Modify
```

### Step 3: Verify Code Quality

```bash
# Check for incomplete markers
grep -r "TODO\|FIXME\|NotImplemented\|throw new Error.*not implemented" [files]
```

### Step 4: Run Build Verification

```bash
# Node.js - run related tests
npm test -- --findRelatedTests [aiou files]

# Or run specific test file
npm test -- [test file pattern]
```

**Test Requirements:**
- Tests must EXIST for the AIOU (not optional)
- Tests must PASS
- No skipped tests for core functionality

Generate **Test Result Artifact**:
Use **Display Template** from `council-development.md` to show: Test Results: AIOU-XXX
[test output]
```

### Coverage (if available)
- Lines: X%
- Branches: X%
- Functions: X%

### Test Summary
- Passed: X
- Failed: Y
- Skipped: Z
```

### Step 6: Verify Acceptance Criteria

For EACH acceptance criterion from the spec:

1. **Identify how to verify** - What proves this criterion is met?
2. **Execute verification** - Run test, check code, verify behavior
3. **Document evidence** - Screenshot, test output, code reference

Generate **Acceptance Criteria Artifact**:
Use **Display Template** from `council-development.md` to show: Acceptance Criteria Verification: AIOU-XXX

### Step 7: Generate AIOU Completion Artifact

If ALL checks pass, generate **AIOU Completion Artifact**:

Use **Display Template** from `council-development.md` to show: AIOU Completion Certificate: AIOU-XXX

### Step 8: Update State (Only if Verified)

**If ALL checks PASS:**
- Update `.antigravity/project-context.md` to mark AIOU complete
- Commit with message: `Complete AIOU-XXX: [description]`
- Save to Knowledge Base: `{PROJECT}-DEV-AIOU-XXX-COMPLETE`
- Announce: "AIOU-XXX VERIFIED COMPLETE ✅"

**If ANY check FAILS:**
- Do NOT update .antigravity/project-context.md
- Do NOT commit
- List specific failures
- Announce: "AIOU-XXX VERIFICATION FAILED ❌ - [reasons]"
- Provide remediation steps

## Artifacts Generated

- **Build Artifact**: Compilation proof
- **Test Result Artifact**: Test execution evidence
- **Acceptance Criteria Artifact**: Criteria verification
- **AIOU Completion Artifact**: Final certification (only if passed)

## Important

**An AIOU is NOT complete until this workflow passes.**

- Every acceptance criterion must be verified
- Tests must exist AND pass
- Build must succeed
- Evidence artifacts are MANDATORY

## Required Evidence for Completion

| Evidence | Required | Purpose |
|----------|----------|---------|
| Build Artifact | ✅ Yes | Proves code compiles |
| Test Result Artifact | ✅ Yes | Proves tests pass |
| Acceptance Criteria Artifact | ✅ Yes | Proves requirements met |
| AIOU Completion Artifact | ✅ Yes | Final certification |

**Missing any evidence = AIOU not complete**
