---
name: sdlc-validate-before-after
description: |
  Capture before/after evidence for corrections
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/evidence-capture/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/screenshot-analysis/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# Workflow: validate-before-after

---

## Lens / Skills / Model
**Lens**: `[Quality]` + `[UX]` | **Model**: Claude Sonnet 4
> Apply session protocol per `council-validation.md`
---

> Trigger: `/validate-before-after [before|after] [COR-XXX]`

## Description

Captures before or after state evidence for a correction. **Both BEFORE and AFTER evidence are MANDATORY for any correction to be verified.** This workflow ensures evidence is captured at the right moment with proper documentation.

## Why This Workflow Exists

Corrections often fail verification because:
- Before state not captured (can't prove what was wrong)
- After state not captured (can't prove it's fixed)
- Evidence captured incorrectly (different scenarios, missing context)
- Evidence is ambiguous (doesn't clearly show the issue/fix)

This workflow ensures evidence is captured properly and can be compared.

## Pre-Conditions

- For BEFORE: Issue must be reproducible right now
- For AFTER: Fix must be implemented
- Correction ID should be assigned (COR-XXX)
- Application must be running

## Steps

### Step 1: Identify Capture Type

Determine if capturing BEFORE or AFTER:

| Mode | When to Use | What to Capture |
|------|-------------|-----------------|
| `before` | Before implementing fix | Issue state, failure behavior |
| `after` | After implementing fix | Fixed state, correct behavior |

### Step 2: Document Test Scenario

**CRITICAL**: Use IDENTICAL scenario for both before and after.

Use **Display Template** from `council-validation.md` to show: Test Scenario: COR-XXX

**Save this scenario** - it MUST be used for both captures.

### Step 3: Reproduce Current State

**For BEFORE capture:**
1. Execute test scenario steps exactly
2. Trigger the issue
3. Wait for issue to manifest
4. Capture at the MOMENT of failure

**For AFTER capture:**
1. Execute SAME test scenario steps exactly
2. Execute the same trigger
3. Wait for expected (fixed) behavior
4. Capture showing correct behavior

### Step 4: Capture Evidence

Take Screenshot/Recording at the critical moment:

**What to capture:**
- The relevant UI/output showing the state
- Any error messages (for BEFORE)
- Success indicators (for AFTER)
- Console output if relevant
- Network response if relevant

**Screenshot Quality Requirements:**
- [ ] Clearly shows the relevant area
- [ ] Annotated to highlight key element
- [ ] Readable text (not blurry)
- [ ] Context visible (know what screen we're on)

### Step 5: Generate Evidence Artifact

**For BEFORE state:**

Use **Display Template** from `council-validation.md` to show: Before State Evidence: COR-XXX

**For AFTER state:**

Use **Display Template** from `council-validation.md` to show: After State Evidence: COR-XXX

### Step 6: Link Evidence

Connect evidence to correction:

1. Update `correction-log.md` with artifact references
2. Save to Knowledge Base with correction ID
3. Verify both BEFORE and AFTER exist for the correction

### Step 7: Validate Evidence Pair

If BOTH before and after exist, validate:

Use **Display Template** from `council-validation.md` to show: Evidence Pair Validation: COR-XXX

## Evidence Pair Requirements

For a correction to be verified, BOTH captures must exist:

| Evidence | Required Fields | Purpose |
|----------|-----------------|---------|
| BEFORE | Scenario, Screenshot, Issue Description | Prove issue existed |
| AFTER | Same Scenario, Screenshot, Fix Description | Prove issue resolved |

**Without BOTH**: Correction CANNOT be verified.

## Common Mistakes (Avoid)

| Mistake | Problem | Solution |
|---------|---------|----------|
| Different scenarios | Can't compare | Document scenario FIRST, use for both |
| Before captured too late | Issue might be partially fixed | Capture BEFORE any code changes |
| After captured wrong state | Doesn't show the fix | Ensure fix is deployed, same scenario |
| Missing annotations | Unclear what to look at | Always annotate key elements |
| Missing context | Don't know where this is | Include URL, user, application state |

## Artifacts Generated

- **Before Screenshot Artifact**: Issue state with annotations
- **After Screenshot Artifact**: Fixed state with annotations
- **Evidence Pair Artifact**: Validation of matching scenarios

## Usage

```
/validate-before-after before COR-042    # Capture issue state
/validate-before-after after COR-042     # Capture fixed state
/validate-before-after check COR-042     # Check if pair is complete
```

## Integration with Correction Protocol

```
┌─────────────────────────────────────────────────────┐
│                  Correction Flow                     │
├─────────────────────────────────────────────────────┤
│ 1. Identify issue                                    │
│ 2. Document scenario                                 │
│ 3. ▶ /validate-before-after before COR-XXX ◀        │
│ 4. Implement fix                                     │
│ 5. ▶ /validate-before-after after COR-XXX ◀         │
│ 6. ▶ /validate-verify-correction COR-XXX ◀          │
│ 7. Mark complete (only if verified)                  │
└─────────────────────────────────────────────────────┘
```

## Quick Checklist

Before capturing BEFORE:
- [ ] Scenario documented
- [ ] Issue is reproducible right now
- [ ] No fix applied yet
- [ ] Ready to capture at moment of failure

Before capturing AFTER:
- [ ] Same scenario as BEFORE
- [ ] Fix is fully implemented
- [ ] Application restarted/reloaded if needed
- [ ] Ready to capture at moment of success

## Agent Invocations

### Agent: sdlc-code-reviewer
Invoke via Agent tool with `subagent_type: "sdlc-code-reviewer"`:
- **Provide**: Before/after evidence pair, code diff between captures, test scenario documentation
- **Request**: Review the before/after diff to confirm the change is minimal, targeted, and free of unintended side effects
- **Apply**: Use diff review findings in Step 7 evidence pair validation
