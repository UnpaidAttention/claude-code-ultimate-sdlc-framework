---
name: sdlc-close-cycle
description: |
  Close and archive the current development cycle. Merges specs to project level, updates manifest, and prepares for next cycle.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/planning-orchestration/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /close-cycle - Close and Archive Current Cycle

---

## Lens / Skills / Model
**Lens**: `[Requirements]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per council-development.md

## Arguments
| Argument | Required | Description |
|----------|----------|-------------|
| (none) | — | Session auto-detects state |

---

## Purpose

Close the current development cycle by:
1. Verifying completion status (or confirming early closure)
2. Archiving all cycle state into `.cycles/`
3. Merging new specifications into project-level `specs/`
4. Extracting learnings for future cycles
5. Updating the project manifest
6. Preparing the workspace for the next cycle

---

## Workflow

### Step 1: Read Current State

Read these files:
- `.ultimate-sdlc/project-context.md` — Current position, cycle info
- `.ultimate-sdlc/project-manifest.md` — Project identity, cycle history
- `.ultimate-sdlc/council-state/{active-council}/current-state.md` — Council progress

Extract:
- Cycle ID and type
- Current council and phase
- Whether all gates have passed
- Whether the cycle reached its terminal state

### Step 2: Verify Completion

**If cycle is complete** (Gate S2 passed for Full/Feature cycles, or appropriate final gate for abbreviated cycles):
- Display: "Cycle [ID] completed successfully. Proceeding to archive."
- Go to Step 3.

**If cycle is NOT complete:**
Use **Display Template** from `council-development.md` to show: Cycle Not Yet Complete

Wait for user choice. If "Close anyway", proceed to Step 3 with a note about early closure.

### Step 3: Generate Cycle Summary

Create a summary of what was accomplished in this cycle:

Use **Display Template** from `council-development.md` to show: Cycle Summary — [Cycle ID]

### Step 4: Archive Cycle State

Execute the same archive protocol as `/new-cycle` Auto-Archive:

#### 4a: Create Archive Directory

```bash
mkdir -p .cycles/{cycle-id}/council-state
mkdir -p .cycles/{cycle-id}/handoffs
mkdir -p .cycles/{cycle-id}/specs
```

#### 4b: Copy Specs Snapshot to Archive

```bash
cp -r specs/ .cycles/{cycle-id}/specs/
```

#### 4c: Move State Files to Archive

| Source (Root) | Destination (Archive) |
|---|---|
| `.ultimate-sdlc/project-context.md` | `.cycles/{cycle-id}/cycle-context.md` |
| `.ultimate-sdlc/progress.md` | `.cycles/{cycle-id}/.ultimate-sdlc/progress.md` |
| `cycle-baseline.md` | `.cycles/{cycle-id}/cycle-baseline.md` |
| `.ultimate-sdlc/council-state/planning/` | `.cycles/{cycle-id}/.ultimate-sdlc/council-state/planning/` |
| `.ultimate-sdlc/council-state/development/` | `.cycles/{cycle-id}/.ultimate-sdlc/council-state/development/` |
| `.ultimate-sdlc/council-state/audit/` | `.cycles/{cycle-id}/.ultimate-sdlc/council-state/audit/` |
| `.ultimate-sdlc/council-state/validation/` | `.cycles/{cycle-id}/.ultimate-sdlc/council-state/validation/` |
| `handoffs/*` | `.cycles/{cycle-id}/handoffs/` |
| `.memory/` | `.cycles/{cycle-id}/.memory/` |
| `.metrics/` | `.cycles/{cycle-id}/.metrics/` |

**Do NOT move**: `.ultimate-sdlc/project-manifest.md`, `product-concept.md`, `specs/`, `~/.claude/skills/ultimate-sdlc/`, `~/.claude/skills/ultimate-sdlc/context/`, `.reference/`, `.ultimate-sdlc/config.yaml`, source code.

#### 4d: Save Cycle Summary

Write the cycle summary from Step 3 to `.cycles/{cycle-id}/CYCLE-SUMMARY.md`.

### Step 5: Merge Specs to Project Level

Ensure project-level `specs/` reflects all work done:

1. **Features**: All `FEAT-*.md` files should already be in `specs/features/` at root
2. **AIOUs**: All `AIOU-*.md` files should already be in `specs/aious/`
3. **ADRs**: All `ADR-*.md` files should already be in `specs/adrs/`
4. **Feature Inventory**: Update `specs/feature-inventory.md`:
   - Add any new features built in this cycle
   - Mark any features that were modified/updated
   - Note any features that were removed

If `specs/feature-inventory.md` doesn't exist, create it:

Use **Display Template** from `council-development.md` to show: Feature Inventory

### Step 6: Extract Learnings

If `.memory/semantic/patterns.md` or `.memory/semantic/anti-patterns.md` contain entries from this cycle:

1. Copy significant entries to a project-level learning file
2. Create/update `.cycles/project-learnings.md`:

Use **Display Template** from `council-development.md` to show: Project Learnings (Accumulated Across Cycles)

### Step 7: Update Project Manifest

Update `.ultimate-sdlc/project-manifest.md`:

1. Move cycle from "Active" to "Completed" in Cycle History
2. Add completion date
3. Add cycle summary (1-2 sentences)
4. Update feature count
5. Update Known Technical Debt section if applicable
6. Clear Active Cycle field

### Step 8: Clean Up Root

After archiving, the root should be clean of cycle-specific state:

**Should exist at root**:
- `.ultimate-sdlc/project-manifest.md` — Project identity
- `product-concept.md` — Original vision
- `specs/` — Accumulated specifications
- `.cycles/` — Archived cycles
- `~/.claude/skills/ultimate-sdlc/`, `~/.claude/skills/ultimate-sdlc/context/`, `.reference/` — Framework
- `.ultimate-sdlc/config.yaml`, `CLAUDE.md`, `README.md`, `ARCHITECTURE.md` — Framework docs
- Source code directories

**Should NOT exist at root** (archived to .cycles/):
- `.ultimate-sdlc/project-context.md`
- `.ultimate-sdlc/progress.md`
- `cycle-baseline.md`
- `.ultimate-sdlc/council-state/` (with contents)
- `handoffs/` (with contents)
- `.memory/`
- `.metrics/`

If any state files remain due to errors, warn the user.

### Step 9: Display Completion

Use **Display Template** from `council-development.md` to show: Cycle Closed

---

## Arguments

| Argument | Effect |
|----------|--------|
| (none) | Interactive closure with verification |
| `--force` | Close without completion verification |

---

## Error Handling

### If state files already partially archived
- Check what's been moved vs what remains
- Complete the archival for remaining files
- Don't duplicate files in archive

### If .cycles/ directory creation fails
- Inform user of permission/space issues
- Suggest manual resolution

### If cycle-id can't be determined
- Fall back to timestamp-based naming: `cycle-YYYYMMDD-HHMM`
- Note in manifest that naming is approximate

---
