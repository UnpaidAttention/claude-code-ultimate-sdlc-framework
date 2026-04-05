---
name: new-cycle
description: |
  Start a new development cycle on an existing project. Archives previous cycle state and creates fresh state files for new work (features, patches, maintenance, improvements).
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/project-setup/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/requirements-engineering/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/planning-orchestration/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /new-cycle - Start a New Development Cycle

---

## Lens / Skills / Model
**Lens**: `[Requirements]` | **Model**: Claude Opus 4
> Apply RARV cycle, session protocol per council-development.md

## Arguments
| Argument | Required | Description |
|----------|----------|-------------|
| (none) | — | Session auto-detects state |

---

## Purpose

This is the **primary re-entry point** for the Ultimate SDLC Framework after initial development. It enables ongoing use of the framework for:
- Adding new features to a completed product
- Fixing bugs and patching defects
- Performing maintenance (dependency updates, infrastructure changes)
- Improving code quality (refactoring, performance optimization, tech debt reduction)
- Building new major versions

**How it works**: Archives the previous cycle's state files into `.cycles/`, creates fresh state files at the root level, and routes to the appropriate starting workflow based on cycle type. Existing workflows continue to read state from the same root-level paths — they simply find fresh state there.

---

## Pre-Flight Check

### Check 1: Project Manifest Exists

If `.ultimate-sdlc/project-manifest.md` does NOT exist:
- Check for codebase indicators (`src/`, `package.json`, `go.mod`, `requirements.txt`, `Cargo.toml`, etc.)
  - **If codebase exists**: "Existing codebase detected but no project manifest. Run `/adopt` first to onboard this project to the framework."
  - **If nothing exists**: "No project found. Run `/init` to start a new project from scratch."
- STOP.

### Check 2: Previous Cycle State

If `.ultimate-sdlc/project-context.md` exists (previous cycle state still at root level):

1. Read `.ultimate-sdlc/project-context.md` and check the `Status` field and `Active Council`
2. **If Status indicates completion** (all councils complete, Gate S2 passed, or marked Release Ready):
   - Display: "Previous cycle completed. Archiving automatically before starting new cycle."
   - Execute **Auto-Archive Protocol** (see below)
3. **If Status indicates in-progress work** (any council active, gates not all passed):
   - Display warning:
     ```
     Previous cycle is still in progress.

     Current Position: [Active Council] - [Current Phase]
     Status: [Status]

     Options:
     1. Close the previous cycle anyway (work will be archived as-is)
     2. Resume the previous cycle instead (run /continue or /status)
     3. Cancel
     ```
   - Wait for user choice before proceeding

---

## Auto-Archive Protocol

When archiving a previous cycle's state:

### Step A1: Determine Cycle Number and Name

1. Read `.ultimate-sdlc/project-manifest.md` → get `Cycle History` table
2. Determine next cycle number (count of existing cycles + 1)
3. Previous cycle = last entry in the Cycle History table
4. If no Cycle History entries exist (first cycle from /init), use: `cycle-001-initial-build`

### Step A2: Create Archive Directory

```
mkdir -p .cycles/cycle-{NNN}-{previous-slug}/council-state
mkdir -p .cycles/cycle-{NNN}-{previous-slug}/handoffs
mkdir -p .cycles/cycle-{NNN}-{previous-slug}/specs
```

### Step A3: Move State Files to Archive

Move these files/directories INTO the archive:

| Source (Root) | Destination (Archive) |
|---|---|
| `.ultimate-sdlc/project-context.md` | `.cycles/cycle-{NNN}/cycle-context.md` |
| `.ultimate-sdlc/progress.md` | `.cycles/cycle-{NNN}/.ultimate-sdlc/progress.md` |
| `.ultimate-sdlc/council-state/planning/` | `.cycles/cycle-{NNN}/.ultimate-sdlc/council-state/planning/` |
| `.ultimate-sdlc/council-state/development/` | `.cycles/cycle-{NNN}/.ultimate-sdlc/council-state/development/` |
| `.ultimate-sdlc/council-state/audit/` | `.cycles/cycle-{NNN}/.ultimate-sdlc/council-state/audit/` |
| `.ultimate-sdlc/council-state/validation/` | `.cycles/cycle-{NNN}/.ultimate-sdlc/council-state/validation/` |
| `handoffs/*` | `.cycles/cycle-{NNN}/handoffs/` |
| `.memory/` | `.cycles/cycle-{NNN}/.memory/` |
| `.metrics/` | `.cycles/cycle-{NNN}/.metrics/` |

**Do NOT move** (these persist across cycles):
- `.ultimate-sdlc/project-manifest.md` — Project identity
- `product-concept.md` — Original vision
- `specs/` — Accumulated specifications (project-level)
- `~/.claude/skills/ultimate-sdlc/` — Framework files
- `~/.claude/skills/ultimate-sdlc/context/` — Framework context
- `.reference/` — Framework reference
- `.ultimate-sdlc/config.yaml` — Framework config
- `CLAUDE.md`, `README.md`, `ARCHITECTURE.md` — Framework docs
- Source code (`src/`, `app/`, etc.)

### Step A4: Merge Specs to Project Level

Before moving cycle-specific specs to archive, merge new ones to project-level `specs/`:

1. Copy any new `specs/features/FEAT-*.md` files to archive (already at root, so just leave project-level copies)
2. Copy any new `specs/aious/AIOU-*.md` files to archive
3. Copy any new `specs/adrs/ADR-*.md` files — ADRs accumulate at project level
4. Update `specs/feature-inventory.md` with features built in this cycle (create if doesn't exist)

**Note**: `specs/` at root level is the accumulated truth. Cycle archives get a snapshot copy for historical reference.

### Step A5: Copy Specs Snapshot to Archive

```
cp -r specs/ .cycles/cycle-{NNN}/specs/
```

This creates a point-in-time snapshot of all specs as of this cycle's completion.

### Step A6: Update Project Manifest

Add completed cycle entry to `.ultimate-sdlc/project-manifest.md` Cycle History table.

---

## Workflow

### Step 1: Gather Context

Read these files to understand the project:
- `.ultimate-sdlc/project-manifest.md` — Project identity, tech stack, cycle history
- `specs/feature-inventory.md` — What features exist (if file exists)
- `specs/adrs/` — Architecture decisions still in effect (list files, read key ones)

### Step 2: Define Cycle Intent

Ask the user:

Use **Display Template** from `council-development.md` to show: New Development Cycle

Wait for user response with cycle description and type selection.

### Step 3: Create Fresh State Files

After user confirms cycle intent and type:

#### 3a: Determine Cycle Identifier

```
Cycle Number: [next sequential number]
Cycle Slug: [2-4 word slug from user's description, kebab-case]
Cycle ID: cycle-{NNN}-{slug}
```

#### 3b: Create Directory Structure

```bash
mkdir -p .ultimate-sdlc/council-state/planning
mkdir -p .ultimate-sdlc/council-state/development
mkdir -p .ultimate-sdlc/council-state/audit
mkdir -p .ultimate-sdlc/council-state/validation/screenshots
mkdir -p handoffs
mkdir -p .memory/episodic/planning
mkdir -p .memory/episodic/development
mkdir -p .memory/episodic/audit
mkdir -p .memory/episodic/validation
mkdir -p .memory/semantic
mkdir -p .memory/procedural
mkdir -p .metrics/tasks/planning
mkdir -p .metrics/tasks/development
mkdir -p .metrics/tasks/audit
mkdir -p .metrics/tasks/validation
mkdir -p .metrics/summaries/weekly
```

### Step 3c: Create .ultimate-sdlc/project-context.md

```markdown
| [NNN] | cycle-{NNN}-{slug} | [Type] | Active | [today] → ... | [user's intent summary] |
```

Set Active Cycle in manifest to the new cycle.

### Step 5: Import Relevant Context

For non-Full cycle types, generate additional context from previous work:

**For Feature cycles:**
- Read existing `specs/features/` to understand current feature set
- Identify gaps in `specs/feature-inventory.md`

**For Patch cycles:**
- If user provides specific bug descriptions, note them in cycle-baseline.md
- If a `defect-log.md` exists from previous audit, check for open defects

**For Maintenance cycles:**
- Run dependency check commands if applicable (npm audit, pip check, etc.)
- Note findings in cycle-baseline.md

**For Improvement cycles:**
- Read previous audit quality scorecard if available (from archived cycles)
- Note areas for improvement in cycle-baseline.md

### Step 6: Route to Starting Workflow

Based on cycle type, instruct the user:

| Cycle Type | Starting Workflow | Message |
|-----------|-------------------|---------|
| Full | `/planning-start` | "Full development cycle initialized. Run `/planning-start` to begin Planning Council Phase 1: Discovery." |
| Feature | `/planning-start` | "Feature cycle initialized. Run `/planning-start` to begin planning new features. The Planning Council will use your cycle baseline alongside the original product concept." |
| Patch | `/patch-planning` | "Patch cycle initialized. Run `/patch-planning` to begin defect analysis and create targeted fix AIOUs." |
| Maintenance | `/maintenance-planning` | "Maintenance cycle initialized. Run `/maintenance-planning` to begin impact analysis." |
| Improvement | `/improvement-planning` | "Improvement cycle initialized. Run `/improvement-planning` to begin analysis and create improvement AIOUs." |

### Step 7: Display Summary

Use **Display Template** from `council-development.md` to show: New Cycle Created

---

## Arguments

| Argument | Effect |
|----------|--------|
| (none) | Interactive cycle creation |
| `--type [type]` | Pre-select cycle type (full/feature/patch/maintenance/improvement) |
| `--intent "[description]"` | Pre-set cycle intent |

---

## Error Handling

### If .cycles/ directory has issues
- Create it if it doesn't exist
- If permission errors, inform user

### If previous cycle state files are corrupted
- Attempt to archive what exists
- Create fresh state regardless
- Note corruption in .ultimate-sdlc/progress.md

### If .ultimate-sdlc/project-manifest.md is malformed
- Attempt to parse what exists
- If unrecoverable, offer to regenerate from available information

---
