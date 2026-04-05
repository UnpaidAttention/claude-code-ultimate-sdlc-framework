---
name: validate-e2
description: |
  Execute Enhancement Track E2 - Innovation Opportunities. Identify innovation and differentiation opportunities.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/creative-ideation/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/innovation-discovery/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/brainstorming/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/roadmap-planning/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /validate-e2 - Innovation Opportunities

## Lens / Skills / Model
**Lens**: `[Requirements]` | **Model**: Claude Opus 4.5
> Apply RARV cycle, session protocol per council-validation.md

## Prerequisites

- E1 (Feature Richness) must be complete

If prerequisites not met:
```
E1 not complete. Run /validate-e1 first.
```

---

## Workflow

### Step 1: Update Project State

Update `.ultimate-sdlc/project-context.md`:
- Set `Current Phase`: E2 - Innovation Opportunities
- Set `Status`: in_progress

### Step 2: Innovation Ideation

Generate innovation ideas:

Use **Display Template** from `council-validation.md` to show: Innovation Opportunities

### Step 3: Idea Evaluation

Evaluate innovation ideas:

Use **Display Template** from `council-validation.md` to show: Innovation Evaluation

### Step 4: Innovation Roadmap

Create innovation roadmap:

Use **Display Template** from `council-validation.md` to show: Innovation Roadmap

### Step 5: Phase Completion Criteria

- [ ] Innovation ideas generated
- [ ] Ideas evaluated and scored
- [ ] Roadmap created
- [ ] Selected innovations for this release

### Step 6: Complete Phase

```
## E2: Innovation Opportunities - Complete

**Ideas Generated**: [X]
**Selected for This Release**: [Y]
**Added to Roadmap**: [Z]

**Next Step**: Run `/validate-e3` to continue to Enhancement Implementation
```

---
