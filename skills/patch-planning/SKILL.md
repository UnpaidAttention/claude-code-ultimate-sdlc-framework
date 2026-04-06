---
name: sdlc-patch-planning
description: |
  Abbreviated planning for patch/bugfix cycles. Analyzes defects, creates targeted fix AIOUs, and generates a lightweight planning handoff.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/requirements-engineering/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/systematic-debugging/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/aiou-decomposition/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /patch-planning - Patch Cycle Planning

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Opus 4
> Apply RARV cycle, session protocol per council-development.md

## Arguments
| Argument | Required | Description |
|----------|----------|-------------|
| (none) | — | Session auto-detects state |

---

## Purpose

Abbreviated planning workflow for **Patch cycles** — focused on analyzing defects and creating targeted fix AIOUs without the full 8-phase planning process.

**This replaces the full Planning Council for Patch cycle types.** It produces a `planning-handoff.md` that the Development Council can consume, maintaining compatibility with existing development workflows.

**Pipeline**: `/patch-planning` → `/dev-scope-analysis` → `/dev-start` → ... → `/validate-start` → ...

**Skipped Councils**: Audit (patches go directly from Development to Validation)

---

## Pre-Conditions

- `.ultimate-sdlc/project-context.md` must exist with `Cycle Type: Patch`
- `cycle-baseline.md` must exist (created by `/new-cycle`)
- `.ultimate-sdlc/project-manifest.md` must exist

---

## Workflow

### Step 1: Gather Defect Information

**If user provided defect descriptions in `/new-cycle`**:
- Read `cycle-baseline.md` for defect details
- Parse each defect into structured format

**If defect-log.md exists from previous audit cycle**:
- Read archived defect-log from `.cycles/` if referenced
- Identify open/unresolved defects

**If neither — ask user**:
Use **Display Template** from `council-development.md` to show: Patch Planning — Defect Analysis

### Step 2: Defect Analysis

For each defect:

1. **Locate affected code**: Search the codebase for files related to the defect
2. **Identify root cause**: Analyze the code to determine the likely cause
3. **Assess impact**: What other features or components could be affected by the fix?
4. **Determine fix approach**: What needs to change?

Create a defect analysis document:

Use **Display Template** from `council-development.md` to show: Defect Analysis

### Step 3: Create Fix AIOUs

For each defect, create an AIOU specification in `specs/aious/`:

Use **Display Template** from `council-development.md` to show: AIOU-FIX-001: Fix [Defect Title]

### Step 4: Architecture Impact Assessment (Light)

Quick check — does any fix require architectural changes?

- If NO: Note "No architectural impact" and skip ADR creation
- If YES: Create a brief ADR for the change:
  Use **Display Template** from `council-development.md` to show: ADR-XXX: [Architectural change for fix]

### Step 5: Generate Planning Handoff

Create `handoffs/planning-handoff.md` in the abbreviated format:

Use **Display Template** from `council-development.md` to show: Planning Handoff — Patch Cycle

### Step 6: Update State

1. Update `.ultimate-sdlc/project-context.md`:
   - Mark Planning as complete
   - Note: "Abbreviated planning (Patch cycle)"

2. Update `.ultimate-sdlc/council-state/planning/current-state.md`:
   - Mark all phases as complete (abbreviated)

3. Update `.ultimate-sdlc/progress.md` with planning session summary

### Step 7: Route to Development

Use **Display Template** from `council-development.md` to show: Patch Planning Complete
Patch Planning [DONE] → Development [ ] → Validation [ ] → Close Cycle

---

## Agent Invocations

### Agent: sdlc-debugger
Invoke via Agent tool with `subagent_type: "sdlc-debugger"`:
- **Provide**: Defect descriptions from cycle-baseline.md or user input, affected code areas, reproduction information
- **Request**: Analyze each defect to identify root cause, assess impact on other components, and determine fix approach
- **Apply**: Use bug analysis results in Step 2 defect analysis for each defect's root cause and fix approach

### Agent: sdlc-planner
Invoke via Agent tool with `subagent_type: "sdlc-planner"`:
- **Provide**: Defect analysis results, fix approaches, architecture impact assessment, AIOU specs
- **Request**: Plan patch cycle — create fix AIOUs with proper wave assignments, generate planning handoff, and determine if architectural changes are needed
- **Apply**: Use patch planning results in Steps 3-5 to create AIOU specs and the planning handoff document
