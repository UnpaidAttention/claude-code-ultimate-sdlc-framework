---
name: audit-a1
description: |
  Execute Audit Track A1 - Purpose Alignment. Critically analyze if the implemented features align with the stated product purpose.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/purpose-alignment/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/critical-analysis/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/multi-lens-analysis/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /audit-a1 - Purpose Alignment

---
## Prerequisites Check

**CRITICAL**: This phase cannot begin until the Testing (T1-T5) phase group is complete.

1.  **Verify T5 Completion**: Check `.ultimate-sdlc/council-state/audit/current-state.md`.
2.  **Look for**: `Phase T5: Performance & Security` marked as `[x] Complete`.
3.  **If not complete, STOP and display the following message:**
    ```
    PREREQUISITE FAILED: Audit phase A1 cannot begin until all Testing phases (T1-T5) are complete.
    Please complete the Testing track and try again.
    Current status: Phase T5 is not yet marked as complete.
    ```
4.  **Do not proceed with this workflow until the prerequisite is met.**

---

## Lens / Skills / Model
**Lens**: `[Quality]` + `[Security]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per `council-audit.md`

## Workflow

### Step 1: Update Project State

Update `.ultimate-sdlc/project-context.md`:
- Set `Current Phase`: A1 - Purpose Alignment
- Set `Status`: in_progress

### Step 2: Review Inputs

- `product-concept.md`
- `planning-handoff.md`
- `development-handoff.md`

### Step 3: Analyze Alignment

For each major feature:
- Does it directly support the core purpose?
- Does it align with user personas?
- Are there any unintended consequences?
- Does it add unnecessary complexity?

### Step 4: Document Findings

Create `.ultimate-sdlc/council-state/audit/alignment-report.md`:

Use **Display Template** from `council-audit.md` to show: Purpose Alignment Report

### Step 5: Complete Phase

```
## A1: Purpose Alignment - Complete

**Next Step**: Run `/audit-a2` to continue to Completeness analysis.
```
