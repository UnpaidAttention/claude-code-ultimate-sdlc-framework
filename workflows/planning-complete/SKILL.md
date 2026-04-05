---
name: sdlc-planning-complete
description: |
  Complete Planning Council and generate handoff to Development Council.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/completeness-matrix/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/handoff-protocols/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /planning-complete - Complete Planning Council

## Arguments
| Argument | Required | Description |
|----------|----------|-------------|
| (none) | — | Session auto-detects state |

---

## Lens / Skills / Model
**Lens**: `[Requirements]` + `[Documentation]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per council-planning.md

## Purpose

Verify Planning Council completion, generate handoff document, and prepare for Development Council.

---

## Pre-Conditions

- Gate 8 (Launch Ready) must pass
- All required artifacts must exist

---

## Workflow

### Step 1: Verify Gate 8

Check all Gate 8 criteria:

- [ ] All phases 1-8 marked complete in `.ultimate-sdlc/project-context.md`
- [ ] All features have FEAT-XXX specifications in `specs/features/`
- [ ] All features decomposed into AIOUs in `specs/aious/`
- [ ] Architecture decisions documented in `specs/adrs/`
- [ ] Security threat model exists
- [ ] Testing strategy documented
- [ ] Infrastructure plan exists
- [ ] Sprint assignments complete

**If any criterion fails**: Stop and report what's missing.

### Step 2: Generate Handoff Document

Create `handoffs/planning-handoff.md` with this structure:

Use **Display Template** from `council-planning.md` to show: Planning Council Handoff

### Step 3: Update State

1. Update `.ultimate-sdlc/project-context.md`:
   - Mark Planning Council as complete
   - Add Gate 8 to "Gates Passed" table
   - Add planning-handoff.md to "Handoffs Generated" table

2. Update `.ultimate-sdlc/progress.md`:
   - Add Planning Council completion entry

### Step 4: Report Completion

Use **Display Template** from `council-planning.md` to show: Planning Council - Complete
Use **Display Template** from `council-planning.md` to show: Planning Council Complete

---

## Rollback

If issues are found after completion:
- Edit `.ultimate-sdlc/project-context.md` to reopen Planning Council
- Fix issues
- Run `/planning-complete` again

---

## Notes

- This is a blocking checkpoint - cannot proceed without passing
- Handoff document is the contract between Planning and Development
- All information needed for development should be in the handoff
