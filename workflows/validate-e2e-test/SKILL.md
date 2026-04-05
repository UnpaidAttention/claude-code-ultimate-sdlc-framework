---
name: validate-e2e-test
description: |
  End-to-end runtime testing with GUI-to-backend verification
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
- Read `~/.claude/skills/antigravity/knowledge/e2e-testing/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/runtime-verification/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/integration-testing/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/evidence-capture/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# Workflow: validate-e2e-test

> **Tech-Specific**: This workflow uses Electron/desktop app patterns (IPC, preload, main process, config files). Adapt layer names and storage types for your stack.

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply session protocol per `council-validation.md`
---

> Trigger: `/validate-e2e-test [feature-name]` or "E2E test [feature]"

## Description

Performs comprehensive end-to-end testing by ACTUALLY EXECUTING the application and verifying that GUI actions produce expected backend effects. **This workflow requires the application to be running** and uses runtime evidence, not code review.

## Why This Workflow Exists

AI models often claim features work based on code review alone, but physical testing reveals:
- Buttons that don't call their backend APIs
- Toggle switches that update UI but don't persist settings
- Forms that validate but don't submit data
- Features that work in frontend but fail in backend integration
- Configuration changes that don't survive app restart

**Code review cannot detect these issues.** Only runtime testing can.

## CRITICAL PRINCIPLE

```
A feature is NOT verified until:
1. The application is RUNNING
2. A human or automated action TRIGGERS the feature
3. The EXPECTED EFFECT is observed in the backend
4. The PERSISTENCE is confirmed (if applicable)
```

## Pre-Conditions

- [ ] Application is built and running
- [ ] Feature under test is accessible in the GUI
- [ ] Backend/database is accessible for verification
- [ ] Console/logs are visible for inspection
- [ ] Feature ID exists in `intent-map.md`
- [ ] Antigravity browser extension installed and connected (verify green status indicator in IDE) OR Playwright MCP configured — see `.reference/mcp-tool-guide.md`

## Steps

### Step 1: Verify Application is Running

**MANDATORY**: Confirm the application is actually running and accessible.

1. Start dev server via terminal (e.g., `npm run dev`, `yarn dev`, `python manage.py runserver`)
2. Verify the application responds by navigating via browser extension (`browser_navigate`) or Playwright MCP
3. Capture initial screenshot as baseline via `browser.capture_screenshot_and_save`

Use **Display Template** from `council-validation.md` to show: Application Status Check
[Paste any relevant startup logs]
```

### Screenshot
[Application Running Screenshot Artifact ID]
```

**If application NOT running**: Start it first, do NOT proceed with code review.

**Agent-native testing workflow**: For each feature test, navigate via browser extension → interact with UI element → verify backend effect via console/database → capture screenshot evidence → session video records the full test automatically.

### Step 2: Identify Test Scenarios

For the feature, define RUNTIME test scenarios:

Use **Display Template** from `council-validation.md` to show: E2E Test Scenarios: [Feature Name]

### Step 3: Execute Runtime Tests

**For EACH test scenario**, perform the ACTUAL test:

Use **Display Template** from `council-validation.md` to show: E2E Test Execution: E2E-XXX
[Console output / Database query result / API response]
#### 5. Verify Persistence (if applicable)

### Step 4: Trace Failed Tests

For ANY failed test, perform deep tracing:

Use **Display Template** from `council-validation.md` to show: Failure Analysis: E2E-XXX

### Step 5: Document Integration Points

Map all verified integration points:

Use **Display Template** from `council-validation.md` to show: Integration Point Map: [Feature Name]

### Step 6: Generate E2E Test Report

Use **Display Template** from `council-validation.md` to show: E2E Test Report: [Feature Name]

### Step 7: Update State Files

- Update `gap-analysis.md` with any integration gaps found
- Update `correction-log.md` with required fixes
- Update `completeness-matrix.md` E2E Testing dimension
- Update `validation-context.md` with test results

## Artifacts Generated

- **Application Running Artifact**: Proof app is running
- **Before/After Screenshot Artifacts**: UI state changes
- **Console Log Artifacts**: Backend evidence
- **Database State Artifacts**: Persistence evidence
- **E2E Test Report Artifact**: Complete test documentation

## Required Evidence Checklist

For a feature to pass E2E testing:

- [ ] Application was running during test
- [ ] Each UI action was physically performed
- [ ] UI response was captured (screenshot)
- [ ] Backend effect was verified (logs/database)
- [ ] Persistence was verified (if applicable)
- [ ] All failures have root cause identified
- [ ] Gaps logged for any failures

## Usage

```
/validate-e2e-test settings        # E2E test settings feature
/validate-e2e-test authentication  # E2E test auth flow
/validate-e2e-test "file explorer" # E2E test file explorer
/validate-e2e-test all             # E2E test all critical features
```

## Integration with Validation Flow

```
V3: Completeness Assessment
    ↓
/validate-e2e-test [feature]  ← NEW: Runtime verification
    ↓
V4: Prerequisites (now includes runtime verification)
    ↓
V5: Correction Planning (with E2E-identified gaps)
```

## Common Failure Patterns

| Pattern | Symptoms | Typical Cause |
|---------|----------|---------------|
| UI-Only Toggle | Toggle animates but setting not saved | Missing IPC call or handler |
| Form Ghost Submit | Form validates, "success" shown, no data | Missing API call or wrong endpoint |
| Stale State | Feature works but reverts on refresh | Frontend state not persisted |
| Silent Failure | No error, no effect | Exception swallowed, missing error handling |
| Channel Mismatch | Frontend calls, backend never receives | IPC channel name mismatch |

## E2E vs Code Review

| Aspect | Code Review | E2E Testing |
|--------|-------------|-------------|
| Detects missing handlers | Sometimes | Always |
| Detects channel mismatches | Rarely | Always |
| Detects persistence issues | Sometimes | Always |
| Detects integration gaps | Rarely | Always |
| Requires running app | No | Yes |
| Speed | Fast | Slower |
| Confidence | Low-Medium | High |

**Both are needed**, but E2E testing provides the definitive answer.
