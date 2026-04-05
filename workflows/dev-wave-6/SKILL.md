---
name: dev-wave-6
description: |
  Execute Development Wave 6 - Integration. Full system integration, E2E testing, and final assembly.
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
- Read `~/.claude/skills/antigravity/knowledge/integration-testing/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/e2e-testing/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/clean-code/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# /dev-wave-6 - Integration

## Lens / Skills / Model
**Lens**: `[Architecture]` + `[Quality]` + `[Operations]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol, code review protocol per `council-development.md`

## Prerequisites

- Wave 5 (UI Components) must be complete
- **If frontend project**: UI Wiring Verification (`/dev-ui-verify`) must have PASSED for this run. Check for `.antigravity/council-state/development/ui-verify-run-[N].md` with PASS verdict.

If prerequisites not met:
```
Wave 5 not complete. Complete Wave 5 first.
```

If Wave 5 is complete but UI-V has not passed:
```
UI Wiring Verification required before Wave 6.
Run /dev-ui-verify to verify navigation, interactive elements, and state completeness.
```

---

## Workflow

### Step 1: Update Project State

Update `.antigravity/project-context.md`:
- Set `Active Council`: development
- Set `Current Wave`: 6 - Integration
- Set `Status`: in_progress

### Step 2: Review Wave 6 AIOUs

**SCOPE**: In multi-run mode, process only current run's AIOUs.

**Feature Verification Pre-Check (MANDATORY):**
Before starting Wave 6, verify that ALL features (in current run) have passed `/dev-verify-feature`. Check `.antigravity/council-state/development/feature-verifications/` for FEAT-XXX-verified.md files.

If any feature has NOT been verified:
```
⚠️ BLOCKED: Feature verification incomplete.
Unverified features: [list]
Run /dev-verify-feature [FEAT-XXX] for each unverified feature before proceeding.
```
STOP until all features pass verification.

Read from `specs/wave-summary.md` and `specs/aious/`:
- List all Wave 6 AIOUs (filtered by run if multi-run)
- Understand integration requirements
- Review E2E test requirements

### Step 3: Integration Activities

#### System Assembly
- Connect frontend to backend
- Configure environment variables
- Set up production-like configuration
- Verify all services communicate

#### E2E Testing
- Implement E2E test suite
- Cover critical user journeys
- Test across browsers (if applicable)
- Verify mobile responsiveness (if applicable)

#### Integration Verification
- API contract validation
- Data flow verification
- Error handling across layers
- Performance baseline

### Step 3.5: Cross-Feature Connectivity Verification

Load `specs/connectivity-matrix.md` as a structured verification checklist.

For each documented interaction in the matrix:

| # | Feature A | Feature B | Interaction | Verification Method | Result |
|---|-----------|-----------|-------------|---------------------|--------|
| 1 | [from matrix] | [from matrix] | [from matrix] | [from matrix] | PASS/FAIL |

**Verification process:**
1. Read the connectivity matrix
2. For each interaction row, verify at TWO levels:
   - **Happy path**: Execute the documented interaction with valid data → verify correct result
   - **Error path**: Simulate Feature B returning an error (e.g., 500, timeout, empty response) → verify Feature A handles it gracefully (no crash, appropriate error message, valid state maintained)
3. Record PASS/FAIL with evidence (test output, code reference, manual verification)
4. For shared components: verify the component is used by ALL documented consumers

**PASS criteria**: 100% pass rate required at BOTH levels (happy path AND error path). Any FAIL blocks Wave 6 completion. An interaction that works on the happy path but crashes on error = FAIL.

**If failures detected**: Document each failure with:
- Which interaction failed
- Root cause (missing code, wrong data flow, broken connection)
- Remediation steps
- Estimated effort to fix

Fix all connectivity failures before proceeding to E2E testing.

### Step 4: E2E Test Coverage

Ensure E2E tests cover:

Use **Display Template** from `council-development.md` to show: Critical User Journeys

### Step 5: Quality Standards

Integration must verify:
- [ ] All features work end-to-end
- [ ] Performance acceptable
- [ ] Error messages user-friendly
- [ ] Logging and monitoring working
- [ ] Security controls functioning
- [ ] Build produces deployable artifact

### Step 6: Wave Completion Criteria

**SCOPE**: In multi-run mode, verify only current run's AIOUs.

Before completing this wave, verify:
- [ ] All Wave 6 AIOUs **in current run** implemented
- [ ] All E2E tests passing
- [ ] Full integration verified
- [ ] Build succeeds
- [ ] Code reviewed (parallel-code-review)
- [ ] Ready for audit
- [ ] **If multi-run**: Run tracker Wave 6 column updated for all AIOUs

### Step 7: Complete Wave

When all criteria met:

1. Update `.antigravity/project-context.md`:
   - Set Wave 6 status: Complete

2. Update `.antigravity/council-state/development/WORKING-MEMORY.md`:
   - Mark completed AIOUs
   - Record session learnings

3. Record metrics in `.metrics/tasks/development/`

4. Create git checkpoint:
   ```bash
   git tag wave-6-complete
   ```

5. Display completion message:

```
## Wave 6: Integration - Complete

**AIOUs Completed**: [X]
**E2E Tests**: [Y] passing
**Integration Status**: Verified

**Wave completion security check**: Run `npm audit --audit-level=high` (or stack equivalent). If high/critical findings: fix before proceeding. Run `gitleaks detect --no-git` on files modified in this wave.

**Next Step**: Run `/dev-gate-i8` to verify Gate I8 and complete Development Council
```

---

## Code Review Integration

After completing each AIOU, apply parallel 3-reviewer code review:
- Dispatch 3 reviewers (Security, Quality, Logic focus)
- If unanimous approval, run Devil's Advocate review
- Fix all Critical and High issues before marking complete

---
