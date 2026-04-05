---
name: sdlc-validate-verify-correction
description: |
  Verify correction with test evidence and certificate
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/correction-verification/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/evidence-capture/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/regression-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# Workflow: validate-verify-correction

> Trigger: `/validate-verify-correction [COR-XXX]`

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply session protocol per `council-validation.md`
---

## Description

Verifies that a correction is truly complete with proper before/after evidence. **A correction is NOT complete until it passes this verification.** This prevents "I think I fixed it" claims without proof.

## Why This Workflow Exists

AI agents often claim fixes are complete without proper verification:
- "I updated the code" (but didn't run it)
- "The issue should be resolved" (no test evidence)
- "I believe that fixes it" (uncertain language = unverified)

This workflow enforces rigorous verification with before/after proof.

## Pre-Conditions

- Correction ID must be specified (e.g., COR-042)
- Correction should already be in `correction-log.md`
- Code change should be implemented
- Application should be running and accessible

## Steps

### Step 1: Load Correction Details

Read correction entry from `correction-log.md`:

Use **Display Template** from `council-validation.md` to show: Verifying: COR-XXX

### Step 2: Verify Before Evidence Exists

**MANDATORY**: Check that Before Screenshot/Evidence Artifact exists.

- If NO before evidence: **Cannot verify** - recreate issue if possible, or flag as "Before state unknown"
- Before evidence must show:
  - The issue actually occurring
  - The specific behavior being corrected
  - Context (URL, state, inputs used)

### Step 3: Verify After Evidence Exists

**MANDATORY**: Check that After Screenshot/Evidence Artifact exists.

- If NO after evidence: Capture it NOW by testing the fix
- After evidence must show:
  - The same scenario as before
  - The corrected behavior
  - Same context (URL, state, inputs)

### Step 4: Compare Before/After

Side-by-side verification:

Use **Display Template** from `council-validation.md` to show: Before/After Comparison: COR-XXX

### Step 5: Run Verification Test

**MANDATORY**: Execute a test that proves the fix works.

Use **Display Template** from `council-validation.md` to show: Verification Test: COR-XXX
[Actual test output]
```

### Evidence
[Test Result Artifact ID]
```

If test FAILS: **Correction is NOT verified** - fix must be revised.

### Step 6: Check for Regressions

Verify the fix didn't break something else:

Use **Display Template** from `council-validation.md` to show: Regression Check: COR-XXX

If regressions found: **Correction is NOT verified** - must be fixed.

### Step 7: Generate Verification Certificate

**If ALL checks PASS:**

Use **Display Template** from `council-validation.md` to show: Correction Verification Certificate: COR-XXX

**If ANY check FAILS:**

Use **Display Template** from `council-validation.md` to show: Correction Verification: COR-XXX - INCOMPLETE

### Step 8: Update State

**If VERIFIED:**
- Mark correction as "Verified" in `correction-log.md`
- Save to Knowledge Base: `{PROJECT}-VALIDATE-CORRECTION-COR-XXX-VERIFIED`
- Announce: "COR-XXX VERIFIED - Before/After proof complete"

**If NOT VERIFIED:**
- Mark correction as "Needs Work" in `correction-log.md`
- List specific issues
- Announce: "COR-XXX NOT VERIFIED - [reasons]"

## Artifacts Generated

- **Before Screenshot Artifact**: Issue state (required)
- **After Screenshot Artifact**: Fixed state (required)
- **Test Result Artifact**: Verification test output (required)
- **Correction Verification Artifact**: Final certification

## Required Evidence Checklist

Before ANY correction can be marked complete:

- [ ] Before Screenshot exists showing the issue
- [ ] After Screenshot exists showing the resolution
- [ ] Before and After use same test scenario
- [ ] Verification test written and passes
- [ ] Regression check shows no new failures
- [ ] Verification Certificate generated

## Usage

```
/validate-verify-correction COR-042     # Verify specific correction
/validate-verify-correction all         # Verify all unverified corrections
/validate-verify-correction recent      # Verify corrections from current session
```

## Integration with Correction Protocol

The standard correction protocol (`/validate-correct`) should END with this verification:

```
1. Document issue
2. Identify root cause
3. Verify prerequisites
4. Plan fix
5. Capture BEFORE state ← /validate-before-after before
6. Implement fix
7. Capture AFTER state ← /validate-before-after after
8. Write verification test
9. Run verification test
10. Check regressions
11. VERIFY CORRECTION ← /validate-verify-correction
12. Log to correction-log.md (only if verified)
```
