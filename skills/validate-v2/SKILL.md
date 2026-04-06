---
name: sdlc-validate-v2
description: |
  Execute Validation Track V2 - Gap Analysis. Identify gaps between intent and implementation.
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
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/gap-analysis/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/systematic-evaluation/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/intent-analysis/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/categorization/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


# /validate-v2 - Gap Analysis

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Opus 4.5
> Apply RARV cycle, session protocol per council-validation.md

## Prerequisites

- V1 (Intent Extraction) must be complete

If prerequisites not met:
```
V1 not complete. Run /validate-start first to complete Intent Extraction.
```

---

## Workflow

### Step 1: Update Project State

Update `.ultimate-sdlc/project-context.md`:
- Set `Current Phase`: V2 - Gap Analysis
- Set `Status`: in_progress

### Agent: requirements
Invoke via Agent tool with `subagent_type: "sdlc-requirements"`:
- **Provide**: Intent map from V1, implementation code, test results, acceptance criteria
- **Request**: Conduct intent vs implementation gap analysis — for each documented intent, trace to implementation and identify where behavior diverges from stated purpose
- **Apply**: Populate gap documentation table with findings before proceeding to categorization

### Step 2: Gap Analysis Process

For each documented intent from V1:

1. **Implementation Review**
   - Locate the implementing code
   - Trace execution paths
   - Identify state changes

2. **Gap Identification**
   - Does implementation match intent?
   - Are edge cases covered?
   - Are error conditions handled?

3. **Gap Documentation**
   ```markdown
   | Gap ID | Feature | Intent | Actual Behavior | Severity |
   |--------|---------|--------|-----------------|----------|
   | GAP-001 | [Feature] | [Expected] | [Actual] | [Critical/High/Medium/Low] |
   Display: Step 3: Gap Categorization
## V2: Gap Analysis - Complete

**Gaps Identified**: [X]
**Critical Gaps**: [Y]
**High Priority Gaps**: [Z]

**Next Step**: Run `/validate-v3` to continue to Completeness Assessment
```

---
