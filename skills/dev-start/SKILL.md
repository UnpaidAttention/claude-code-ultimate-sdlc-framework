---
name: sdlc-dev-start
description: |
  Initialize or resume Development Council session. Guides through waves 0-6 with gates at I4 and I8.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/typescript-expert/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/clean-code/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/architecture-principles/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/memory-system/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /dev-start - Begin Development Council

## Arguments
| Argument | Required | Description |
|----------|----------|-------------|
| (none) | — | Session auto-detects state from `.ultimate-sdlc/project-context.md` |

---

## Lens / Skills / Model
**Lens**: `[Architecture]` + `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol, code review protocol per `council-development.md`

**Additional Lens**: `[UX]` — activated for Wave 5 when `project_type` has frontend

---

## Purpose

Start or resume the Development Council. This council transforms planning specifications into working software through 7 waves.

> **IMPORTANT**: `/dev-start` initializes the development session AND begins Wave 0 (Types & Interfaces) implementation. After displaying the welcome message, immediately proceed to implement the first Wave 0 AIOU. Do NOT present a menu of options, do NOT suggest commands like "Start AIOU-001" or "Initialize project", and do NOT ask the user what to do next. The next action is always: begin implementing the first pending Wave 0 AIOU.

---

## Pre-Conditions

- `.ultimate-sdlc/project-context.md` must exist (run `/init` first if not)
- Planning Council must be complete (Gate 8 passed)
- `handoffs/planning-handoff.md` must exist

---

## Workflow

### Step 1: Session Setup

Follow **Session Protocol** from `council-development.md`:
1. Read `.ultimate-sdlc/config.yaml` → extract `governance_mode`, `project_type`
2. Read `.ultimate-sdlc/project-context.md` → confirm Active Council, current wave

### Step 2: Check Project State

Read `.ultimate-sdlc/project-context.md`:
- If `Active Council` is not "development", check if transition is valid
- Verify Planning Council (Gate 8) is marked complete OR abbreviated planning is complete
- Identify current wave
- Read `Cycle Information` section → extract **Cycle Type** and **Cycle Intent**

### Step 2a: Cycle Context for Development

**Read the Cycle Type from `.ultimate-sdlc/project-context.md`.**

For **all non-initial cycles** (cycle number > 1 in `.ultimate-sdlc/project-manifest.md`):

1. **Existing codebase detected**: Source code already exists. Development EXTENDS the existing codebase — do NOT recreate project structure, types, or utilities that already exist.
2. **Read `cycle-baseline.md`** (if exists): Understand existing architecture, tech stack, and patterns.
3. **Scope by cycle type**:

| Cycle Type | Development Scope |
|------------|-------------------|
| **Full** | May rebuild/majorly revise. Read existing code first. |
| **Feature** | ADD new features to existing codebase. Extend existing types, models, services. Do not recreate existing functionality. |
| **Patch** | FIX specific defects listed in planning handoff. Minimal code changes. Do not refactor working code. |
| **Maintenance** | UPDATE dependencies, config, infrastructure. Do not change business logic unless required by updates. |
| **Improvement** | REFACTOR existing code per behavioral contracts. No new features. Existing tests must continue passing. |

4. **Add to `.ultimate-sdlc/council-state/development/WORKING-MEMORY.md`**:
   ```
   ### Cycle Context
   - Cycle Type: [type]
   - Cycle Intent: [from .ultimate-sdlc/project-context.md]
   - Existing Codebase: YES
   - Development Scope: [EXTEND / FIX / UPDATE / REFACTOR per table above]
   ```

**For initial cycles** (cycle-001): Proceed as normal — building from scratch.

### Step 3: Verify Planning Handoff

Check if `handoffs/planning-handoff.md` exists:
- **If exists**: Parse it for AIOU specifications
- **If not exists**: Stop with error: "Planning handoff not found. Complete Planning Council first with `/planning-start`."

### Step 4: Determine Mode

**Check if run-tracker.md exists:**

**If NO run tracker AND this is first development start:**
→ SCOPE ANALYSIS NEEDED - Display:
```
Development scope analysis required before starting.
Run `/dev-scope-analysis` to create run tracker, then return to `/dev-start`.

Note: The development scope analysis calculates its own run count independently
from AIOU effort units. It does not reference the planning council's run count.
```

**If run tracker exists OR scope analysis not needed (small project):**

**If Wave is 0 and status is "not started" (new run or new project):**
→ NEW SESSION - Go to Step 5

**If Wave is > 0 or status is "in progress" (resuming):**
→ RESUME SESSION - Go to Step 6

**If all runs show COMPLETED:**
→ DEVELOPMENT COMPLETE - Display:
```
All development runs complete.
If returning to add more features, run `/dev-scope-analysis` to create new runs.
Otherwise, proceed to `/audit-start` for the Audit Council.
```

### Step 5: New Session Setup

1. Update `.ultimate-sdlc/project-context.md`:
   - Set `Active Council`: development
   - Set `Current Wave`: 0
   - Set `Status`: in_progress
   - **If multi-run**: Note current run number

2. **If multi-run mode**: Update `.ultimate-sdlc/council-state/development/run-tracker.md`:
   - Set current run status to 🔄 IN-PROGRESS
   - Record start date for current run

3. Parse `handoffs/planning-handoff.md`:
   - **If multi-run**: Extract ONLY the AIOUs assigned to current run (from run-tracker.md)
   - **If single-run**: Extract all AIOUs grouped by wave
   - Extract architecture decisions
   - Extract tech stack requirements

4. Create/Update `.ultimate-sdlc/council-state/development/current-state.md`:
   - List AIOUs for current run with status "pending"
   - Record wave assignments
   - **If multi-run**: Note run number and scope

5. Initialize project structure (**first run of initial cycle only**):
   - **If existing codebase** (non-initial cycle): SKIP project initialization. The codebase already exists. Instead:
     - Run `git status` to verify clean state
     - Run existing build command to verify codebase compiles
     - Run existing tests to verify baseline passes
     - Create git checkpoint: `pre-cycle-[NNN]-wave-0`
   - **If no existing codebase** (initial cycle):
     - Set up directory structure per architecture
     - Initialize package.json or equivalent
     - Install base dependencies
     - Set up testing framework
     - Create git checkpoint: `pre-wave-0`

6. Load Wave 0 Skills (from `.reference/skills-index.md`):
   - Read `~/.claude/skills/ultimate-sdlc/knowledge/typescript-expert/SKILL.md`
   - Read `~/.claude/skills/ultimate-sdlc/knowledge/clean-code/SKILL.md`
   - Read `~/.claude/skills/ultimate-sdlc/knowledge/architecture/SKILL.md`

7. Update `.ultimate-sdlc/progress.md` with new session entry

8. Display welcome using **Display Template** from `council-development.md` with:
   - Wave: 0 (Types & Interfaces)
   - **Lens**: `[Architecture]` + `[Quality]`
   - AIOUs: from handoff (filtered by run if multi-run)
   - If multi-run: include run number, focus, and effort units

### Step 5a: Begin Wave 0 Implementation (Mandatory — Do Not Skip)

> **CRITICAL**: After displaying the welcome message above, IMMEDIATELY begin implementing the first Wave 0 AIOU. Do NOT:
> - Present a menu of options (e.g., "Start AIOU-001", "Initialize project", "Show details")
> - Ask the user what they want to do next
> - Suggest commands for the user to run
> - Wait for further user input
>
> The workflow continues directly into implementation. Identify the first pending Wave 0 AIOU and begin the AIOU Execution Protocol (read spec → search patterns → implement → test → commit).

### Step 6: Resume Session

1. Read `.ultimate-sdlc/project-context.md` for current wave
2. Read `.ultimate-sdlc/progress.md` for last session notes
3. Read `.ultimate-sdlc/council-state/development/current-state.md` for AIOU statuses
4. **If multi-run mode**: Read `.ultimate-sdlc/council-state/development/run-tracker.md`:
   - Identify current run (status = IN-PROGRESS)
   - Load only AIOUs assigned to this run
   - Identify last completed wave for this run
5. Read `handoffs/planning-handoff.md` for AIOU specifications
6. Load skills for current wave:
   - Look up wave in `.reference/skills-index.md`
   - Read each skill from `~/.claude/skills/ultimate-sdlc/knowledge/<skill-name>/SKILL.md`

7. Verify repository state:
   - Run `git status`
   - Run build to verify state
   - Run tests to verify state

8. Display resume status using **Display Template** from `council-development.md` with:
   - Current wave and progress table (use wave structure from `~/.claude/skills/ultimate-sdlc/context/project-presets.md` for `project_type`)
   - **Lens**: per current wave
   - Next AIOU to implement
   - If multi-run: include run progress

### Step 6a: Resume Implementation (Mandatory — Do Not Skip)

> **CRITICAL**: After displaying the resume status above, IMMEDIATELY continue implementing the next pending AIOU shown in "Next AIOU". Do NOT present a menu of options or ask the user what to do. Continue the AIOU Execution Protocol from where the last session left off.

---

## Wave Navigation

### When Wave 0 complete:
Run `/dev-wave-1` to continue to Utilities & Helpers

### Direct Wave Entry
- Wave 1: `/dev-wave-1` (Utilities & Helpers)
- Wave 2: `/dev-wave-2` (Data Layer)
- Wave 3: `/dev-wave-3` (Services)
- Wave 4: `/dev-wave-4` (API Layer)
- Gate I4: `/dev-gate-i4` (Gate Verification)
- UI-R: `/dev-ui-research` (UI Design Research — once, after first Gate I4)
- UI-P: `/dev-ui-design-plan` (UI Design Plan — after UI-R)
- Wave 5: `/dev-wave5-start` (UI Components — requires UI-R + UI-P)
- UI-V: `/dev-ui-verify` (UI Wiring Verification — after Wave 5)
- Wave 6: `/dev-wave-6` (Integration — requires UI-V pass)
- Gate I8: `/dev-gate-i8` (Final Gate)
- UI Audit: `/dev-ui-audit` (orchestrator) or phases: `/dev-ui-audit-scan` → `-target` → `-gaps` → `-plan` → `-fix` → `-verify`
- UI Polish: `/dev-ui-polish` (orchestrator) or phases: `/dev-ui-polish-scan` → `-report` → `-research` → `-plan` → `-apply` → `-verify`
- UI Retheme: `/dev-ui-retheme` (orchestrator) or phases: `/dev-ui-retheme-snapshot` → `-direction` → `-propose` → `-apply` → `-verify`
- UI Redesign: `/dev-ui-redesign` (Restart UI from scratch — any time after Gate I4)

### To verify AIOU completion:
Use `/dev-verify-aiou`

### To view status:
Use `/status`

---

## Wave Quick Reference

| Step | Name | Key Output | Gate/Check |
|------|------|------------|------------|
| Wave 0 | Types & Interfaces | Type definitions | - |
| Wave 1 | Utilities & Helpers | Utility functions | - |
| Wave 2 | Data Layer | Database/storage | - |
| Wave 3 | Services | Business logic | - |
| Wave 4 | API Layer | API endpoints | GATE I4 |
| UI-R | UI Design Research | Design research doc | - |
| UI-P | UI Design Plan | Design plan + system | Review gate |
| Wave 5 | UI Components | Frontend UI | - |
| UI-V | UI Wiring Verify | Verification report | Must pass |
| Wave 6 | Integration | Full system | GATE I8 |

---

## Gate Criteria

Refer to `~/.claude/skills/ultimate-sdlc/context/gate-criteria.md` for:
- **Gate I4** criteria (after Wave 4)
- **Gate I8** criteria (after Wave 6)

---

## Handoff

When Gate I8 passes:
- Generate `handoffs/development-handoff.md`
- Update `.ultimate-sdlc/project-context.md` to mark Development complete
- Instruct user to run `/audit-start`

---

## Code Review Integration

Follow **Code Review Protocol** from `council-development.md` after each AIOU.

---

## Agent Invocations

### Agent: sdlc-planner
Invoke via Agent tool with `subagent_type: "sdlc-planner"`:
- **Provide**: Planning handoff, run-tracker (if exists), project-context.md, cycle type and intent
- **Request**: Validate run planning completeness and determine whether /dev-scope-analysis is needed before development begins
- **Apply**: Use planning validation in Step 4 to decide between new session setup or scope analysis redirect

### Agent: sdlc-architecture
Invoke via Agent tool with `subagent_type: "sdlc-architecture"`:
- **Provide**: Planning handoff architecture decisions, tech stack requirements, existing codebase (if non-initial cycle)
- **Request**: Review architecture decisions and validate they are implementable with the current tech stack and codebase state
- **Apply**: Use architecture review in Step 5 to inform project structure initialization and Wave 0 implementation
