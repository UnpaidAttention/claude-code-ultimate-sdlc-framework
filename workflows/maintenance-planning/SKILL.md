---
name: maintenance-planning
description: |
  Abbreviated planning for maintenance cycles. Analyzes dependencies, security patches, and infrastructure changes, creates targeted AIOUs.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/infrastructure-design/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/risk-assessment/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /maintenance-planning - Maintenance Cycle Planning

---

## Lens / Skills / Model
**Lens**: `[Operations]` | **Model**: Claude Opus 4
> Apply RARV cycle, session protocol per council-development.md

## Arguments
| Argument | Required | Description |
|----------|----------|-------------|
| (none) | — | Session auto-detects state |

---

## Purpose

Abbreviated planning workflow for **Maintenance cycles** — focused on dependency updates, security patches, and infrastructure changes without the full 8-phase planning process.

**This replaces the full Planning Council for Maintenance cycle types.** It produces a `planning-handoff.md` compatible with existing development workflows.

**Pipeline**: `/maintenance-planning` → `/dev-scope-analysis` → `/dev-start` → ... → `/validate-start` → ...

**Skipped Councils**: Audit (maintenance goes directly from Development to Validation)

---

## Pre-Conditions

- `.ultimate-sdlc/project-context.md` must exist with `Cycle Type: Maintenance`
- `cycle-baseline.md` must exist (created by `/new-cycle`)
- `.ultimate-sdlc/project-manifest.md` must exist

---

## Workflow

### Step 1: Identify Maintenance Scope

Ask user what type of maintenance is needed:

Use **Display Template** from `council-development.md` to show: Maintenance Planning

### Step 2: Impact Analysis

Based on the maintenance type:

#### For Dependency Updates:
1. Read `package.json` (or equivalent) for current dependency versions
2. Run `npm outdated` or equivalent to identify updates available
3. Run `npm audit` or equivalent to identify security vulnerabilities
4. Categorize updates:
   - **Patch updates** (x.x.PATCH): Low risk, usually safe
   - **Minor updates** (x.MINOR.x): Medium risk, may need testing
   - **Major updates** (MAJOR.x.x): High risk, may need code changes

#### For Security Patches:
1. Identify specific CVEs or vulnerability advisories
2. Determine affected packages/components
3. Assess exposure (is the vulnerable code path actually used?)
4. Prioritize by severity (Critical > High > Medium > Low)

#### For Infrastructure Changes:
1. Identify what infrastructure components change
2. Map dependencies between components
3. Assess rollback strategy
4. Identify testing requirements

#### For Database Migrations:
1. Identify schema changes needed
2. Assess data migration requirements
3. Plan for backwards compatibility
4. Identify rollback strategy

Document findings:

Use **Display Template** from `council-development.md` to show: Impact Analysis

### Step 3: Create Maintenance AIOUs

For each maintenance task, create an AIOU:

Use **Display Template** from `council-development.md` to show: AIOU-MAINT-001: [Maintenance Task Title]

### Step 4: Generate Planning Handoff

Create `handoffs/planning-handoff.md`:

Use **Display Template** from `council-development.md` to show: Planning Handoff — Maintenance Cycle

### Step 5: Update State

1. Update `.ultimate-sdlc/project-context.md`: Mark Planning complete (abbreviated)
2. Update `.ultimate-sdlc/council-state/planning/current-state.md`: All phases complete
3. Update `.ultimate-sdlc/progress.md` with planning session summary

### Step 6: Route to Development

Use **Display Template** from `council-development.md` to show: Maintenance Planning Complete
Maintenance Planning [DONE] → Development [ ] → Validation [ ] → Close Cycle

---
