---
name: status
description: |
  Display current project and council status across the unified framework.
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
- Read `~/.claude/skills/antigravity/knowledge/status-reporting/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/progress-tracking/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/metrics-collection/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/systematic-evaluation/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# /status - Show Status

---

## Lens / Skills / Model
**Lens**: none (read-only utility) | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per the active council rules file

## Arguments
| Argument | Required | Description |
|----------|----------|-------------|
| (none) | — | Session auto-detects state |

---

## Purpose

Display the current state of the project across all four councils.

---

## Workflow

### Step 1: Check Initialization

Check if `.antigravity/project-context.md` exists:
- **If not exists**:
  - Check if `.antigravity/project-manifest.md` exists:
    - **If manifest exists**: Display "No active cycle. Run `/new-cycle` to start a new development cycle."
    - **If neither exists**: Display "Project not initialized. Run `/init` to start a new project, or `/adopt` to onboard an existing codebase."
- **If exists**: Continue to Step 2

### Step 2: Load State

Read these files:
- `.antigravity/project-context.md` - Main state (includes Cycle Information section)
- `.antigravity/project-manifest.md` - Project identity and cycle history (if exists)
- `.antigravity/progress.md` - Session history
- Council-specific state (based on active council):
  - Planning: `.antigravity/council-state/planning/current-state.md`
  - Development: `.antigravity/council-state/development/current-state.md`
  - Audit: `.antigravity/council-state/audit/current-state.md`
  - Validation: `.antigravity/council-state/validation/current-state.md`

### Step 3: Display Status

Display using the format below.

---

## Status Display Format

Use **Display Template** from `the active council rules file` to show: Project Status
Planning → Development → Audit → Validation → CLOSE CYCLE
   [X]         [ ]         [ ]       [ ]
```

Note: For Patch/Maintenance cycles, Audit is skipped:
```
Planning → Development → Validation → CLOSE CYCLE
   [X]         [ ]          [ ]
Use **Display Template** to show: [Active Council Name] Details

---

## Council-Specific Details

### If Planning Council Active:

Show:
- Phase checklist (1 through 8)
- Current phase details
- Features defined count
- ADRs written count
- AIOUs created count

### If Development Council Active:

Show:
- Wave checklist (0 through 6)
- Current wave AIOUs
- AIOUs completed vs total
- Build status
- Test status

### If Audit Council Active:

Show:
- Track status (Testing, Audit, Enhancement)
- Current phase within track
- Defect counts by severity
- Quality score if available

### If Validation Council Active:

Show:
- Track status (all 5 tracks)
- Corrections pending/completed
- Verification status
- Release readiness percentage

---

## If No Active Council

If project is initialized but no council is active:

Use **Display Template** from `the active council rules file` to show: Project Status

## If No Active Cycle

If `.antigravity/project-manifest.md` exists but `.antigravity/project-context.md` does not (between cycles):

Use **Display Template** from `the active council rules file` to show: Project Status

---

## Notes

- Always read fresh state from files
- Show blockers prominently if any exist
- Include relevant next command to run
