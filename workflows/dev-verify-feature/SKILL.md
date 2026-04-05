---
name: dev-verify-feature
description: |
  Verify complete feature implementation after all feature AIOUs are done. Checks component inventory completeness, user journey coverage, navigation placement, and cross-feature connections.
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
- Read `~/.claude/skills/antigravity/knowledge/integration-testing/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/evidence-capture/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/systematic-evaluation/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# /dev-verify-feature - Feature Integration Checkpoint

> Trigger: `/dev-verify-feature [FEAT-XXX]` — run after the LAST AIOU for a feature completes.

---

## Lens / Skills / Model
**Lens**: `[Quality]` + `[Architecture]` | **Model**: Claude Opus 4
> Apply RARV cycle, session protocols per `~/.claude/skills/antigravity/rules/council-development.md`

## Purpose

Verifies that a complete feature works end-to-end after all its AIOUs are implemented. While `/dev-verify-aiou` checks individual units, this workflow checks the feature as a whole — ensuring nothing was lost between AIOU boundaries.

## Why This Workflow Exists

AI agents implement AIOUs individually but never check if the complete feature works:
- Individual AIOUs pass but the feature doesn't function end-to-end
- Components from the deep-dive are missing (fell between AIOU boundaries)
- User journeys are broken at handoff points between AIOUs
- Cross-feature integration points are unimplemented
- Navigation paths don't work as documented

This workflow enforces feature-level verification with evidence.

## Pre-Conditions

- Feature must be specified (e.g., FEAT-001)
- ALL AIOUs for this feature must be complete (verified via `/dev-verify-aiou`)
- Feature spec, deep-dive, and connectivity matrix must exist

## Steps

### Step 1: Load Feature Context

Read all feature artifacts:

1. `specs/features/FEAT-XXX.md` — Feature specification
2. `specs/deep-dives/DIVE-XXX.md` — Deep-dive analysis (authoritative component list)
3. All AIOU specs for this feature from `specs/aious/`
4. `specs/connectivity-matrix.md` — Cross-feature interactions

**Pre-check**: Confirm all AIOUs for this feature have passed `/dev-verify-aiou`. If any AIOU is incomplete → STOP and list incomplete AIOUs.

### Step 2: Verify Component Inventory Completeness

Using the Component Inventory from `DIVE-XXX.md` Section 2:

| # | Component (from deep-dive) | Expected Type | Implemented? | File Path | Notes |
|---|---------------------------|---------------|-------------|-----------|-------|
| 1 | [name] | [type] | ✅/❌ | [path] | |
| 2 | ... | ... | ... | ... | |

**Verification method**: For each component in the deep-dive inventory:
- Search the codebase for the implementation file
- Verify the file exists and contains the expected functionality
- Record the file path as evidence

**PASS criteria**: 100% of components from the deep-dive are implemented. Missing components = FAIL.

### Step 3: Verify User Journey

Using the User Journey Map from `DIVE-XXX.md` Section 4:

**Primary Journey Verification:**

| Step | User Action | Expected Response | Verified? | Evidence |
|------|------------|-------------------|-----------|----------|
| 1 | [from deep-dive] | [from deep-dive] | ✅/❌ | [how verified] |

**Secondary Journey Verification:**
- Verify each documented secondary journey

**Error Journey Verification:**
- Verify each documented error scenario produces the expected error UI and recovery path

**Verification method**: Trace through the code path for each journey step. Where possible, run the application and test manually or via E2E tests.

**PASS criteria**: All primary journey steps work. All documented error journeys produce correct error handling.

### Step 4: Verify Navigation & Placement

Using Navigation & Placement from `DIVE-XXX.md` Section 3 AND `.antigravity/council-state/development/ui-design-plan.md` (if exists):

- [ ] Feature is accessible at documented route/URL
- [ ] Navigation path works (e.g., Sidebar → Settings → Notifications)
- [ ] All documented entry points reach the feature
- [ ] Access level enforced (auth/role checks)
- [ ] Screen layout matches documented structure
- [ ] **If ui-design-plan.md exists**: All navigation map entries for this feature's pages are wired correctly (cross-reference navigation architecture section)
- [ ] **If ui-design-plan.md exists**: All interactive elements from the inventory for this feature are functional (buttons have handlers, forms submit, modals open/close)

**For non-UI features**: Mark as N/A.

### Step 5: Verify Cross-Feature Connections

Using `specs/connectivity-matrix.md`, find all rows involving this feature:

| # | Connected Feature | Interaction | Implemented? | Evidence |
|---|------------------|-------------|-------------|----------|
| 1 | [Feature-ID] | [from matrix] | ✅/❌ | [how verified] |

**Verification method**: For each documented interaction:
- Confirm the shared component/data mechanism exists
- Verify data flows in the documented direction
- Test the interaction point

**PASS criteria**: All connectivity matrix entries for this feature are implemented.

### Step 6: Run Feature-Level Tests

```bash
# Run all tests related to this feature
# Adapt command to project's test framework
npm test -- --grep "[feature-name]"
# Or run test files for all feature AIOUs
npm test -- [list of AIOU test files]
```

**PASS criteria**: All feature-related tests pass. No skipped tests for core functionality.

### Step 7: Generate Feature Verification Report

If ALL checks pass:

```markdown
## Feature Verification Report: FEAT-XXX — [Feature Name]

### Component Inventory: PASS
- Deep-dive components: [X] | Implemented: [X]/[X] (100%)

### User Journey: PASS
- Primary journey steps: [X]/[X] verified
- Secondary journeys: [X]/[X] verified
- Error journeys: [X]/[X] verified

### Navigation & Placement: PASS (or N/A)
- Route accessible: YES | Nav path works: YES | Entry points: [X]/[X]

### Cross-Feature Connections: PASS
- Matrix interactions: [X]/[X] verified

### Tests: PASS
- Feature tests: [X] passing | 0 failing | 0 skipped

### FEATURE VERIFICATION: PASS ✅
Verified by: [AI model] | Timestamp: [ISO 8601]
```

### Step 8: Update State

**If ALL checks PASS:**
- Save verification report to `.antigravity/council-state/development/feature-verifications/FEAT-XXX-verified.md`
- Update WORKING-MEMORY.md: record feature verification PASS
- Announce: "FEAT-XXX VERIFIED COMPLETE ✅"

**If ANY check FAILS:**
- Do NOT save a passing report
- List specific failures with remediation steps
- Announce: "FEAT-XXX VERIFICATION FAILED ❌"
- Provide: which components are missing, which journey steps break, which connections are unimplemented
- The failing feature blocks Wave 6 integration AIOUs that depend on it

---

## Important

**A feature is NOT verified until this workflow passes.**

- Every component from the deep-dive must be implemented
- Every documented user journey must work
- Every connectivity matrix entry must be implemented
- Feature verification failures block Wave 6 integration AIOUs

**Mandatory for ALL features.** Run this after the last AIOU for each feature completes, before Wave 6 begins.
