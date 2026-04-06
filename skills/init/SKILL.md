---
name: sdlc-init
description: |
  Initialize a new project with the Ultimate SDLC Framework. Creates all state files and guides to Planning Council.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/conversation-manager/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/memory-system/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /init - Initialize New Project

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocols per `~/.claude/skills/ultimate-sdlc/rules/the active council rules file`

## Arguments
| Argument | Required | Description |
|----------|----------|-------------|
| `project-name` | No | Project name (skips name prompt if provided) |
| `--mode` | No | Override governance mode: `lightweight`, `standard`, `enterprise` |

---

## Purpose

This is the **entry point** for the Ultimate SDLC Framework when starting a **brand new project**. It creates all necessary state files, the project manifest, and prepares for Planning Council.

**For existing projects or subsequent development cycles, use these instead:**
- `/adopt` — Onboard an existing codebase to the framework
- `/new-cycle` — Start a new development cycle on an already-initialized project

**Two initialization paths are supported:**
1. **With Product Concept**: If a `product-concept.md` file exists (from AI Innovation Council or similar), the framework will read and use it
2. **Guided Creation**: If no product concept exists, the AI will guide you through creating one

---

## Pre-Flight Check

Before initializing, verify:
1. This is the project root directory
2. No existing `.ultimate-sdlc/project-manifest.md` or `.ultimate-sdlc/project-context.md`

**If `.ultimate-sdlc/project-manifest.md` exists** (project already adopted/initialized):
```
This project is already set up with the framework.
- To start a new development cycle: Run /new-cycle
- To check current state: Run /status
- To resume work: Run /continue
```

**If `.ultimate-sdlc/project-context.md` exists but no `.ultimate-sdlc/project-manifest.md`** (legacy initialization):
```
⚠️ Project has existing framework state but no project manifest.
Use /status to see current state, or /new-cycle to start a new cycle.
```

**If source code exists** (`src/`, `app/`, `package.json`, etc.) **but no framework files**:
```
Existing codebase detected but no framework files found.
Use /adopt to onboard this existing project to the framework.
Use /init only for brand new projects with no existing code.
```

---

## Initialization Steps

### Step 1: Check for Product Concept

**Search for `product-concept.md` in the project directory.**

#### Path A: Product Concept Found

If `product-concept.md` exists:

1. **Read and parse the file** to extract:
   - Product/Project Name
   - Vision statement
   - Problem being solved
   - Target users/personas
   - Core features/capabilities
   - Success metrics
   - Constraints/requirements

2. **Display confirmation:**
Use **Display Template** from `the active council rules file` to show: 📋 Product Concept Found

3. **If confirmed**, use extracted information and skip to Step 3.

#### Path B: No Product Concept Found

If `product-concept.md` does NOT exist:

Use **Display Template** to show the appropriate status
Use **Display Template** from `the active council rules file` to show: 🚀 Welcome to the Ultimate SDLC Framework!

**If Option 1 (Create Product Concept)** → Go to Step 2A
**If Option 2 (Quick Start)** → Go to Step 2B

### Step 2A: Guided Product Concept Creation

Walk the user through creating a comprehensive product concept:

Use **Display Template** from `the active council rules file` to show: 💡 Let's Build Your Product Concept

After receiving the problem statement, continue:

Use **Display Template** from `the active council rules file` to show: Question 2: The Vision

Continue with:

Use **Display Template** from `the active council rules file` to show: Question 3: Target Users

Use **Display Template** from `the active council rules file` to show: Question 4: Core Features

Use **Display Template** from `the active council rules file` to show: Question 5: Success Metrics

Use **Display Template** from `the active council rules file` to show: Question 6: Constraints & Requirements

Use **Display Template** from `the active council rules file` to show: Question 7: Project Type

**After all questions answered:**

1. **Generate `product-concept.md`** in the project root:

Use **Display Template** from `the active council rules file` to show: Product Concept: [Product Name]

2. **Display for confirmation:**
Use **Display Template** from `the active council rules file` to show: 📄 Product Concept Created

3. Continue to Step 3.

### Step 2B: Quick Start (Basic Info)

For users who want to skip detailed concept creation:

Use **Display Template** from `the active council rules file` to show: ⚡ Quick Start

Continue to Step 3 with basic info only (no product-concept.md created).

### Step 3: Detect Governance Mode

Governance mode is auto-detected from feature count (or overridden by `--mode` argument):

1. Count features from `product-concept.md` (or user-provided list)
2. Apply thresholds: `<8 → lightweight`, `8-25 → standard`, `>25 → enterprise`
3. Write to `.ultimate-sdlc/config.yaml → governance_mode`
4. Write project type to `.ultimate-sdlc/config.yaml → project_type`

Use **Display Template** to show the appropriate status
Use **Display Template** from `the active council rules file` to show: ⚙️ Configuration

### Step 4: Create Directory Structure

Only create directories needed for initialization. Other councils create their own dirs on activation.

```bash
mkdir -p .ultimate-sdlc/council-state/planning
mkdir -p handoffs
mkdir -p specs/features
mkdir -p specs/aious
mkdir -p specs/adrs
mkdir -p .cycles
```

### Step 5: Create Project Manifest

Create `.ultimate-sdlc/project-manifest.md` in the project root with:
- Project name, type, creation date
- Reference to `product-concept.md` (if exists)
- Cycle history section (initially: cycle-001)
- Framework version

### Step 6: Create Project Context

Copy `templates/.ultimate-sdlc/project-context.md` → `.ultimate-sdlc/project-context.md` in project root. Populate:
- Active Council: planning
- Current Phase: 1
- Status: not_started
- Cycle Information: cycle-001, type = Full (or as determined)

### Step 7: Create Config

Write `.ultimate-sdlc/config.yaml` with:
- `governance_mode`: from Step 3 detection
- `project_type`: from user input or product concept
- Council configurations per framework defaults

### Step 8: Create Progress and Working Memory

1. Copy `templates/.ultimate-sdlc/progress.md` → `.ultimate-sdlc/progress.md`
2. Copy `templates/working-memory.md` → `.ultimate-sdlc/council-state/planning/WORKING-MEMORY.md`

### Step 9: Read Config Protocol

Read `~/.claude/skills/ultimate-sdlc/context/config-reader.md` to understand how config values are used by workflows.

### Step 10: Display Welcome

Use **Display Template** from `the active council rules file` to show: 🎉 Initialization Complete

Include:
- Project name and type
- Governance mode and why it was selected
- Next step: `/planning-start`
- Quick reference commands (`/status`, `/continue`)

**To begin, run:** `/planning-start`

---

## Error Handling

**If template files not found:**
```
❌ Error: Template files not found.
Checking: templates/.ultimate-sdlc/project-context.md, templates/.ultimate-sdlc/progress.md, templates/working-memory.md
```

**If product-concept.md is malformed or incomplete:**
```
⚠️ Warning: product-concept.md found but appears incomplete.
Missing sections: [list missing sections]
```

Present options:
1. Continue anyway with available information
2. Complete the missing sections now
3. Start fresh with guided creation

**WAIT** for user to select an option before proceeding.

---

## Agent Invocations

### Agent: sdlc-planner
Invoke via Agent tool with `subagent_type: "sdlc-planner"`:
- **Provide**: Product concept (if exists), user responses from guided creation, project type, feature count
- **Request**: Guide project setup — validate product concept completeness, determine governance mode, and prepare the project for Planning Council entry
- **Apply**: Use setup guidance in Steps 1-3 to validate inputs and configure the project correctly
