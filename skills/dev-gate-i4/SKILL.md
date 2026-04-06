---
name: sdlc-dev-gate-i4
description: |
  Verify Development Gate I4 criteria. Backend must be complete before proceeding to UI development.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/test-patterns/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/systematic-evaluation/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /dev-gate-i4 - Gate I4 Verification

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per `council-development.md`

## Prerequisites

- Wave 4 (API Layer) must be complete

If prerequisites not met:
```
Wave 4 not complete. Run /dev-wave-4 first.
```

---

## Purpose

Gate I4 ensures the backend is complete and stable before investing in UI development. This is a **BLOCKING** gate.

---

## Workflow

### Step 1: Load Gate I4 Criteria

**SCOPE**: In multi-run mode, verify criteria for current run's AIOUs only.

Load criteria from `~/.claude/skills/ultimate-sdlc/context/gate-criteria.md` § Development Council Gates → Gate I4.

Run automated verification:
// turbo
```bash
npm test
npm run lint
npm run coverage
npm audit
```

### Step 2: Generate Gate Report

Generate gate artifact using the **Gate Report Template** from `council-development.md`.
Include: wave completion table, test results, quality metrics, and gate status.

### Step 3: Gate Decision

**If ALL criteria pass:**

1. Update `.ultimate-sdlc/project-context.md`:
   - Set Gate I4: Passed (for current run)

2. Update `.ultimate-sdlc/council-state/development/current-state.md`:
   - Mark Gate I4 passed with timestamp

3. **If multi-run mode**, update `.ultimate-sdlc/council-state/development/run-tracker.md`:
   - Set Gate I4 status to ✅ for current run
   - Update waves 0-4 columns to Complete for current run's AIOUs
   - Verify no AIOUs were skipped or truncated

4. **If frontend project** (`project_type` is web-app or mobile-app):
   - Check if UI Design Phases are complete (look for `.ultimate-sdlc/council-state/development/ui-design-plan.md`)
   - If NOT complete: Display:
     ```
     Gate I4 PASSED. Backend complete.

     **UI Design Phases required before Wave 5.**
     This is the first Gate I4 pass — UI design research and planning must run now.
     Next step: /dev-ui-research (then /dev-ui-design-plan, then /dev-wave5-start)
     ```
   - If already complete (subsequent runs): Display:
     ```
     Gate I4 PASSED. Backend complete.
     UI Design Phases already complete from a prior run.
     Next step: /dev-wave5-start
     ```

5. **If NOT frontend project**: Display pass message: Gate I4 passed, next step `/dev-wave5-start` or `/dev-wave-6`

**If ANY criterion fails:**

List failures with remediation steps. Next step: fix issues, re-run `/dev-gate-i4`.

**If FAIL in multi-run mode:**
1. Update `.ultimate-sdlc/council-state/development/WORKING-MEMORY.md`:
   - Document issues found for current run
   - Track what needs fixing

2. Update `.ultimate-sdlc/council-state/development/run-tracker.md`:
   - Note gate failure for current run
   - Do NOT update wave completion columns until fixed

---
