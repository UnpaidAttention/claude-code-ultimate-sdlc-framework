---
name: sdlc-dev-gate-i8
description: |
  Verify Development Gate I8 criteria. Final gate before transitioning to Audit Council.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/quality-assessment/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/handoff-protocols/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/systematic-evaluation/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /dev-gate-i8 - Gate I8 Verification

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per `council-development.md`

## Prerequisites

- Wave 6 (Integration) must be complete

If prerequisites not met:
```
Wave 6 not complete. Run /dev-wave-6 first.
```

---

## Purpose

Gate I8 is the **FINAL** Development Council gate. Passing this gate:
1. Certifies all development is complete
2. Transitions control to Audit Council
3. Software is ready for systematic testing and audit

This is a **BLOCKING** gate.

---

## Workflow

### Step 1: Load Gate I8 Criteria

**SCOPE**: In multi-run mode, verify criteria for current run's AIOUs only.

Load criteria from `~/.claude/skills/ultimate-sdlc/context/gate-criteria.md` § Development Council Gates → Gate I8.

### Agent: sdlc-gate-keeper
Invoke via Agent tool with `subagent_type: "sdlc-gate-keeper"`:
- **Provide**: Gate I8 criteria from gate-criteria.md, all wave completion statuses (0-6), test results, coverage reports, build output, E2E test results, feature verification reports, AIOU completion artifacts, connectivity matrix results
- **Request**: Verify all Gate I8 criteria — full wave completion, test coverage, build success, E2E pass rate, feature verification, design quality (if frontend), and end-to-end traceability from scope-lock through implementation
- **Apply**: Use the gate-keeper's verdict as the gate decision. If FAIL, address all listed remediation items before re-running

### Agent: sdlc-security
Invoke via Agent tool with `subagent_type: "sdlc-security"`:
- **Provide**: Full codebase, dependency audit output, authentication/authorization implementation, API endpoints, environment configuration
- **Request**: Final security scan — dependency vulnerabilities, secrets in code, auth bypass risks, injection vulnerabilities, OWASP Top 10 compliance, and sensitive data exposure
- **Apply**: Fix all CRITICAL and HIGH security findings before Gate I8 can pass

For `project_type` with frontend: also verify design quality criteria from `gate-criteria.md` (criteria 9-16), including:
- Anti-slop compliance, design consistency, accessibility, visual QA evidence (criteria 9-12)
- UI design phases complete, UI wiring verification passed, navigation architecture complete, interactive elements wired (criteria 13-16)
- Check for `.ultimate-sdlc/council-state/development/ui-verify-run-*.md` reports with PASS verdict

Run automated verification:
// turbo
```bash
npm test
npm run build
npm run lint
npm run coverage
npm audit
```

### Step 2: Generate Development Handoff

Create `handoffs/development-handoff.md` following the schema in `handoffs/development-handoff.schema.md`.
Include: wave summary, test results, build information, known issues, and audit focus areas.

### Step 3: Generate Gate Report

Generate gate artifact using the **Gate Report Template** from `council-development.md`.
Include: wave completion, test summary, build status, and gate decision.

### Step 4: Gate Decision

**If ALL criteria pass:**

1. Update `.ultimate-sdlc/project-context.md`:
   - Set `Development Council`: Complete (for current run)
   - Set `Gate I8`: Passed (for current run)
   - Set `Active Council`: audit (ready)

2. Update `.ultimate-sdlc/council-state/development/current-state.md`:
   - Mark Gate I8 passed with timestamp

3. **If multi-run mode**, update `.ultimate-sdlc/council-state/development/run-tracker.md`:
   - Set Gate I8 status to ✅ for current run
   - Update all wave columns to Complete for current run
   - **Mark current run as COMPLETED**
   - Verify all AIOUs in current run passed all waves (no skipped AIOUs)

4. **Run Completion Check** (multi-run mode only):
   - If MORE runs remain: Inform user to start next run
   - If this is the FINAL run: Proceed to consolidation

5. Display pass message using **Display Template** from `council-development.md`:
   - Single-run or final run: Gate I8 passed, next step `/audit-start`
   - Multi-run (not final): Run complete, next step `/dev-start` to begin next run

**Multi-Run Mode - Final Run Consolidation:**

When the final run passes Gate I8:
1. Verify ALL runs show COMPLETED in run-tracker.md
2. Verify total AIOUs = count from planning-handoff.md
3. Generate consolidated development-handoff.md covering all runs
4. Mark Development Council as fully complete

**If ANY criterion fails:**

List failures with remediation steps. Next step: fix issues, re-run `/dev-gate-i8`.

**If FAIL in multi-run mode:**
1. Update `.ultimate-sdlc/council-state/development/WORKING-MEMORY.md`:
   - Document issues found for current run
   - Track what needs fixing

2. Update `.ultimate-sdlc/council-state/development/run-tracker.md`:
   - Note gate failure for current run
   - Do NOT mark run as complete
   - Keep run status as "In Progress"

---
