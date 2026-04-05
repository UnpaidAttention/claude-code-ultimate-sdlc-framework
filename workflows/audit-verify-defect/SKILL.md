---
name: audit-verify-defect
description: |
  Verify defect documentation with evidence certificate
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
- Read `~/.claude/skills/antigravity/knowledge/defect-verification/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/evidence-capture/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/systematic-debugging/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# Audit Verify Defect Workflow

> Trigger: `/audit-verify-defect [DEF-XXX]`

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4.5
> Apply RARV cycle, session protocol per `council-audit.md`

## Description

Verifies that a logged defect is properly documented with reproducible evidence. **A defect is NOT properly logged until it passes this verification.** This prevents "theoretical bugs" from polluting the defect log.

## Why This Workflow Exists

AI agents often report defects based on assumptions rather than actual testing:
- "This probably fails when..." (never tested)
- "I noticed an issue..." (no screenshot)
- "The button seems broken..." (no reproduction steps)

This workflow enforces rigorous defect documentation with proof.

## Pre-Conditions

- Defect ID must be specified (e.g., DEF-042)
- Defect should already be in `defect-log.md`
- Application should be running and accessible

## Steps

### Step 1: Load Defect Details

Read defect entry from `defect-log.md`:

Use **Display Template** from `council-audit.md` to show: Verifying: DEF-XXX

### Step 2: Verify Screenshot Exists

**MANDATORY**: Check that Screenshot Artifact exists for this defect.

- If NO screenshot: **FAIL** - "Defect DEF-XXX has no visual evidence"
- Screenshot must show the ACTUAL defect state, not just the screen
- For behavioral issues: Browser Recording Artifact also required

### Step 3: Reproduce the Defect

**MANDATORY**: Actually reproduce the defect using documented steps.

1. Reset application to clean state (if needed)
2. Follow documented steps EXACTLY as written
3. Verify defect occurs as described

**Reproduction Outcomes:**

| Outcome | Action |
|---------|--------|
| Reproduced exactly | PASS - continue to Step 4 |
| Reproduced differently | Update steps, retake screenshot |
| Cannot reproduce | Mark as "Cannot Reproduce", investigate |
| Intermittent | Document conditions, mark as "Intermittent" |

### Step 4: Verify Steps to Reproduce

Check that reproduction steps are:

- [ ] **Complete**: All necessary preconditions listed
- [ ] **Accurate**: Steps actually lead to the defect
- [ ] **Specific**: No ambiguous instructions (not "click around until...")
- [ ] **Sequential**: Clear step order with numbering
- [ ] **Standalone**: Another tester can reproduce without asking questions

**Bad Steps (FAIL):**
```
1. Use the app
2. Something breaks
```

**Good Steps (PASS):**
```
1. Log in as user@example.com / password123
2. Navigate to Settings > Profile
3. Click "Edit Profile" button
4. Clear the "Name" field completely
5. Click "Save"
6. Error: Application crashes instead of showing validation message
```

### Step 5: Verify Expected vs Actual

Check that documentation includes:

- [ ] **Expected**: Clear statement of correct behavior
- [ ] **Actual**: Clear statement of what actually happens
- [ ] **Difference**: Obvious why this is a defect

### Step 6: Verify Severity Assignment

Cross-check severity against criteria:

| Severity | Criteria | Verify |
|----------|----------|--------|
| Critical | Crash, data loss, security hole | Does it actually crash/lose data/expose security flaw? |
| High | Major feature broken | Is this truly a core feature, not an edge case? |
| Medium | Impaired but workaround exists | Is there really a workaround? |
| Low | Cosmetic, minor | Is this truly cosmetic (no functional impact)? |

**If severity mismatch**: Update severity and document reason.

### Step 7: Generate Verification Artifact

**If ALL checks PASS:**

Use **Display Template** from `council-audit.md` to show: Defect Verification Certificate: DEF-XXX

**If ANY check FAILS:**

Use **Display Template** from `council-audit.md` to show: Defect Verification: DEF-XXX - INCOMPLETE

### Step 8: Update State

**If VERIFIED:**
- Mark defect as "Verified" in `defect-log.md`
- Save to Knowledge Base: `{PROJECT}-AUDIT-DEFECT-DEF-XXX-VERIFIED`
- Announce: "DEF-XXX VERIFIED - Ready for development"

**If NOT VERIFIED:**
- Mark defect as "Needs Work" in `defect-log.md`
- List specific issues
- Announce: "DEF-XXX NOT VERIFIED - [reasons]"

## Artifacts Generated

- **Defect Verification Artifact**: Proof of proper documentation
- **Screenshot Artifact**: (if new one captured during reproduction)
- **Browser Recording Artifact**: (if behavioral, captured during reproduction)

## Important

**A defect without verification is just a theory.**

- Every defect MUST be reproducible
- Every defect MUST have screenshot evidence
- Every defect MUST have complete reproduction steps
- "I think there's a bug" is NOT a valid defect

## Quick Verification Checklist

Before marking any defect as logged:

- [ ] Screenshot Artifact exists showing the defect
- [ ] I personally reproduced the defect
- [ ] Steps to reproduce are complete and accurate
- [ ] Another person could reproduce from my steps alone
- [ ] Expected and actual behavior are clearly different
- [ ] Severity matches the actual impact

## Usage

```
/audit-verify-defect DEF-042     # Verify specific defect
/audit-verify-defect all         # Verify all unverified defects
/audit-verify-defect recent      # Verify defects from current session
```
