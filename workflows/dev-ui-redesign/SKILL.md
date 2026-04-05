---
name: dev-ui-redesign
description: |
  Reset and restart UI development on an existing project. Archives current UI artifacts and code, then re-executes the full UI pipeline (research, design plan, implementation, verification).
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
- Read `~/.claude/skills/antigravity/knowledge/frontend-design/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/ui-ux-pro-max/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/architecture-principles/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# /dev-ui-redesign - UI Redesign

## Purpose

Restart frontend UI development from scratch on a project that already has UI components. This workflow archives the existing UI artifacts and code, resets the UI phase tracking, and routes through the complete UI pipeline: research → design plan → implementation → verification.

**Use when**: The existing UI is fundamentally inadequate — poor design, broken navigation, unwired components, inconsistent styling — and incremental fixes are less efficient than a fresh approach. This is a UI-specific reset; backend code (Waves 0-4) is preserved.

---

## Lens / Skills / Model
**Lens**: `[UX]` + `[Architecture]` | **Model**: Claude Opus 4
> Apply RARV cycle, session protocol per `council-development.md`

## Arguments

| Argument | Required | Description |
|----------|----------|-------------|
| `--scope` | No | `full` (default) = all UI components. `feature FEAT-XXX` = only specified feature's UI. |
| `--keep-design-system` | No | Preserve existing `design-system.md`, `ui-design-research.md`, AND `ui-design-plan.md` (skip UI-R and UI-P entirely). Useful when all design artifacts are fine but implementation is broken. |
| `--keep-research` | No | Preserve existing `ui-design-research.md` (skip UI-R). Useful when research is valid but the plan or implementation needs rework. |

---

## Prerequisites

- `.antigravity/project-context.md` exists with Active Council = Development
- Backend Waves 0-4 are complete (at least one run has passed Gate I4)
- Project has frontend (`project_type` is web-app or mobile-app)
- Git working tree is clean (no uncommitted changes)

If prerequisites not met:
```
UI Redesign requires:
- Active Development Council with Gate I4 passed
- Frontend project type (web-app or mobile-app)
- Clean git working tree (commit or stash pending changes)
```

---

## Workflow

### Step 1: Assess Current State

1. Read `.antigravity/project-context.md` — confirm development council is active, get current wave/run
2. Read `.antigravity/council-state/development/run-tracker.md` — identify which runs have completed Wave 5
3. Inventory existing UI artifacts:
   - `design-system.md` — exists? Y/N
   - `.antigravity/council-state/development/ui-design-research.md` — exists? Y/N
   - `.antigravity/council-state/development/ui-design-plan.md` — exists? Y/N
   - `.antigravity/council-state/development/ui-verify-run-*.md` — which runs have verification reports?
   - `wave5-context.md` — exists? Y/N
   - `wave5-classification.md` — exists? Y/N
   - `visual-qa/` — exists? Y/N
4. Scan for existing UI component files:
   - Search for frontend component directories (e.g., `src/components/`, `src/pages/`, `src/app/`, `app/`)
   - Count files that would be affected
   - Estimate scope of removal

### Step 2: Present Redesign Plan to User

Display the assessment and ask for confirmation:

```
## UI Redesign Assessment

**Current State:**
- Wave 5 completed for runs: [list or "none"]
- UI design artifacts: [list which exist]
- UI component files found: [count] files in [directories]

**Redesign Scope**: [full / feature FEAT-XXX]

**What will be archived/removed:**
- UI design artifacts: [list] → archived to .ui-redesign-archive/
- UI component code: [count] files → removed from codebase
- Wave 5 status in run tracker → reset to ⏳ PENDING
- UI-V verification reports → archived
- Visual QA evidence → archived

**What will be preserved:**
- Backend code (Waves 0-4): untouched
- Gate I4 status: preserved
- Design system: [preserved if --keep-design-system / archived otherwise]
- Design research: [preserved if --keep-research / archived otherwise]
- Test files: preserved (will need updating after new UI is built)

**After archive, the UI pipeline will restart:**
1. /dev-ui-research [if not --keep-research]
2. /dev-ui-design-plan [if not --keep-design-system]
3. /dev-wave5-start (for each run with Wave 5 AIOUs)
4. /dev-ui-verify (per run)

Proceed with UI redesign? (yes/no)
```

**HARD STOP**: Wait for explicit user confirmation before proceeding. Do NOT proceed on assumption.

### Step 3: Create Git Safety Branch

```bash
git checkout -b pre-ui-redesign-backup
git checkout -  # return to original branch
```

This creates a recovery point. If the redesign goes badly, the user can restore from this branch.

### Step 4: Archive Existing UI Artifacts

Create archive directory: `.ui-redesign-archive/[timestamp]/`

**Archive (move, don't delete) these files if they exist:**

```
.ui-redesign-archive/[timestamp]/
├── design-system.md                    (unless --keep-design-system)
├── ui-design-research.md               (unless --keep-research)
├── ui-design-plan.md
├── wave5-context.md
├── wave5-classification.md
├── ui-verify-run-*.md
└── visual-qa/                          (entire directory)
```

**Method**: Move files to archive directory. Do NOT delete — the user may want to reference old designs.

### Step 5: Remove Existing UI Component Code

**Scope: full (default)**

1. Identify UI component directories based on project structure:
   - Read `specs/architecture/` or project structure docs to identify frontend directories
   - Common patterns: `src/components/`, `src/pages/`, `src/app/`, `app/(routes)/`, `src/views/`
   - Also check: `src/styles/` (custom styles, not framework config), `src/hooks/` (UI-specific hooks)

2. For each identified UI directory/file:
   - Check if it contains ONLY UI code (not shared utilities used by backend)
   - If mixed: remove only the UI-specific files, preserve shared code
   - Archive removed files to `.ui-redesign-archive/[timestamp]/code/`

3. **DO NOT remove**:
   - `tailwind.config.*` or CSS framework config (these will be updated, not removed)
   - Shared types/interfaces used by backend AND frontend
   - API client/fetch utilities (these connect UI to backend — preserve)
   - Test files (will be updated, not removed)
   - `package.json` or dependency configs
   - Backend code, API routes, server-side code

4. After removal, verify the backend still builds:
   ```bash
   # Adapt to project's build command
   npm run build  # or equivalent
   ```
   - If build fails due to missing frontend imports in backend: fix the imports (usually removing unused import lines)

**Scope: feature FEAT-XXX**

1. Read `specs/features/FEAT-XXX.md` and `specs/deep-dives/DIVE-XXX.md` to identify feature-specific UI components
2. Remove ONLY those components
3. Preserve all other features' UI code
4. Archive removed files

### Step 6: Reset Run Tracker

Update `.antigravity/council-state/development/run-tracker.md`:

1. **UI Design Phases section**:
   - Set `UI Research` to ⏳ PENDING (unless `--keep-research`)
   - Set `UI Design Plan` to ⏳ PENDING (unless `--keep-design-system`)
   - Set `Design System` to ⏳ PENDING (unless `--keep-design-system`)

2. **Per-Run UI Wiring Verification**:
   - Reset ALL runs' UI-V status to ⏳ PENDING

3. **Per-Run Wave Progress tables**:
   - For runs in scope: reset W5 UI column to ⏳ for all AIOUs
   - For runs in scope: reset UI-V column to ⏳ for all AIOUs
   - For runs in scope: reset W6 Integration column to ⏳ (integration must re-run with new UI)
   - Preserve W0-W4 columns (backend is untouched)

4. **Per-Run Gate Status**:
   - Gate I4: preserved (backend hasn't changed)
   - Gate I8: reset to ⏳ PENDING (must re-verify with new UI)

5. **Per-Run AIOU Checklist**:
   - Wave 5 AIOUs: reset status to ⏳
   - Wave 6 AIOUs: reset status to ⏳
   - Wave 0-4 AIOUs: preserved as ✅

6. **Per-Run Completion Verification**:
   - Uncheck all items (run is no longer complete)
   - Reset run status from ✅ COMPLETED to 🔄 IN-PROGRESS

### Step 7: Reset Project State

1. Update `.antigravity/project-context.md`:
   - Set Current Wave back to the appropriate point:
     - If `--keep-design-system`: Wave 5 (ready for implementation)
     - If `--keep-research`: UI-P (ready for design planning)
     - Otherwise: UI-R (ready for design research)
   - Add note: "UI Redesign initiated [date]"

2. Update `.antigravity/council-state/development/WORKING-MEMORY.md`:
   - Add entry documenting the redesign:
     ```
     ### UI Redesign — [date]
     - Scope: [full / feature FEAT-XXX]
     - Archived to: .ui-redesign-archive/[timestamp]/
     - Safety branch: pre-ui-redesign-backup
     - Preserved: [list what was kept]
     - Next step: [UI-R / UI-P / Wave 5]
     ```

### Step 8: Commit Archive and Reset

```bash
git add -A
git commit -m "UI Redesign: Archive existing UI and reset for fresh implementation

Archived UI artifacts and components to .ui-redesign-archive/[timestamp]/
Backend code (Waves 0-4) preserved. Run tracker reset for Wave 5+.
Safety branch: pre-ui-redesign-backup"
```

### Step 9: Route to Next Phase

Based on flags:

**Default (no flags)**:
```
## UI Redesign Complete — Ready for Fresh UI Development

**Archived**: [count] UI files + [count] design artifacts
**Safety branch**: pre-ui-redesign-backup
**Backend**: Untouched (Gate I4 still valid)

The UI pipeline will now restart from scratch:

Next step: Run /dev-ui-research to begin design research.
Then: /dev-ui-design-plan → /dev-wave5-start → /dev-ui-verify

To restore the previous UI: git checkout pre-ui-redesign-backup
```

**With --keep-research**:
```
Next step: Run /dev-ui-design-plan to create a fresh design plan.
Design research preserved from previous iteration.
```

**With --keep-design-system**:
```
Next step: Run /dev-wave5-start to begin UI implementation.
Design system and research preserved from previous iteration.
```

---

## Recovery

If the redesign needs to be undone:

```bash
# Option 1: Full restore from safety branch
git checkout pre-ui-redesign-backup

# Option 2: Restore just the archived files
cp -r .ui-redesign-archive/[timestamp]/* .

# Option 3: Restore specific files
cp .ui-redesign-archive/[timestamp]/design-system.md .
```

The safety branch preserves the EXACT state before the redesign, including all UI code and artifacts.

---

## Feature-Scoped Redesign Notes

When using `--scope feature FEAT-XXX`:

- Only that feature's UI components are removed from the codebase
- Other features' UI code is preserved
- **Design plan modification**: In `ui-design-plan.md`, the agent:
  1. Finds all page layout sections belonging to FEAT-XXX (by matching `Parent feature: FEAT-XXX`)
  2. Replaces those sections' content with `<!-- REDESIGN: Re-plan this page for FEAT-XXX -->`
  3. Finds all navigation map entries sourced from FEAT-XXX pages and marks them with `<!-- REDESIGN -->`
  4. Finds all interactive element inventory entries on FEAT-XXX pages and marks them with `<!-- REDESIGN -->`
  5. Leaves all other features' plan sections intact
- **Design system and research are preserved** (not reset)
- **Re-planning**: Run `/dev-ui-design-plan` — the workflow detects `<!-- REDESIGN -->` markers and regenerates only those sections, preserving all unmarked sections
- **Re-implementation**: During Wave 5, only FEAT-XXX's AIOUs are re-implemented (reset to ⏳ in run tracker)
- **Re-verification**: UI-V runs for all affected runs (any run containing FEAT-XXX)

This enables targeted UI rework without disrupting the rest of the application's frontend.

---

## Error Handling

**If git working tree is not clean:**
```
Uncommitted changes detected. Commit or stash your changes before running /dev-ui-redesign.
This ensures the safety branch captures a known-good state.
```

**If backend build fails after UI removal:**
- Search for imports of removed UI components in backend/shared code
- Remove or update those imports
- Re-run build to verify
- If build still fails: the removed code may have been shared (not UI-only). Restore from archive and narrow the removal scope.

**If no UI components are found:**
- The project may not have implemented Wave 5 yet
- Display: "No UI component code found. Run /dev-ui-research to start UI development."
- Skip Steps 4-5 (nothing to archive/remove), proceed to Step 6 (reset tracker)

---
