---
name: audit-report
description: |
  Generate comprehensive final audit report
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/report-generation/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/systematic-evaluation/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# Audit Final Report Workflow

> Trigger: `/audit-report`

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per `council-audit.md`

## Description
Generates the comprehensive final audit report after all phases complete.

## Pre-Conditions
- All Testing phases (T1-T5) complete
- All Audit phases (A1-A3) complete
- Enhancement ideas captured (for Validation Council)
- All defects logged and categorized

## Steps

1. **Verify Completeness**
   - Check all 11 phases marked complete
   - Verify all artifacts generated
   - Count total defects by severity
   - Generate verification Checklist Artifact

2. **Compile Testing Summary**
   - Gather T1 Feature Inventory
   - Summarize T2 Functional test results
   - Include T3 GUI analysis findings
   - List T4 Integration issues
   - Report T5 Performance/Security results

3. **Compile Audit Summary**
   - A1 Purpose Alignment Matrix
   - A2 Gap Analysis findings
   - A3 Quality Scorecard

4. **Compile Enhancement Proposals**
   - E1 Opportunity Register
   - E2 Creative Ideas (filtered)
   - E3 Prioritized Proposals

5. **Generate Executive Summary**
   - Overall quality assessment
   - Critical findings requiring immediate attention
   - Key recommendations
   - Enhancement roadmap

6. **Create Final Report Structure**
   Use **Display Template** from `council-audit.md` to show: Audit Report: [Project Name]

7. **Save and Export**
   - Generate Documentation Artifact
   - Save key findings to Knowledge Base
   - Mark audit complete

## Artifacts Generated
- Checklist Artifact: Completeness verification
- Documentation Artifact: Full audit report
- Report Artifact: Executive summary
