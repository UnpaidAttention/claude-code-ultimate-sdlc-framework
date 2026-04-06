---
name: sdlc-planning-handoff
description: |
  Generate final planning-handoff.md for Development Council
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/handoff-protocols/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/completeness-matrix/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# Planning Handoff Workflow

> Trigger: `/planning-handoff`

---

## Lens / Skills / Model
**Lens**: `[Requirements]` | **Model**: Claude Sonnet 4.5
> Apply RARV cycle, session protocol per council-planning.md

## Description
Generates the final `planning-handoff.md` document for the Development Council.

## Pre-Conditions
- All phases 1-8 must be complete
- All feature matrices must exist
- All AIOU specifications must exist
- All ADRs must be documented

## Steps

1. **Verify Completeness**
   - Check all phases marked complete
   - Verify feature matrices exist for all features
   - Verify AIOU specs exist for all units
   - Generate verification Checklist Artifact

2. **Compile Handoff Document**
   - Assemble all feature matrices
   - Assemble all AIOU specifications organized by wave (0-6)
   - Assemble all ADRs
   - Include tech stack decisions
   - Include security requirements

4. **Generate Handoff Structure**
   Use **Display Template** from `council-planning.md` to show: Planning Handoff: [Project Name]

5. **Final Review**
   - Generate Documentation Artifact with full handoff
   - Save to Knowledge Base
   - Mark project ready for Development Council

## Artifacts Generated
- Checklist Artifact: Handoff verification
- Documentation Artifact: Complete planning-handoff.md
