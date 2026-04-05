---
name: audit-think
description: |
  Switch between cognitive thinking modes for audit tasks
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/critical-analysis/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/creative-ideation/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/intuitive-reasoning/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/systematic-evaluation/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# Thinking Mode Selection

Switch between cognitive thinking modes for different audit tasks.

---

## Lens / Skills / Model
**Lens**: `[Quality]` + `[Security]` | **Model**: Claude Opus 4.5
> Apply RARV cycle, session protocol per `council-audit.md`

## Available Modes

| Mode | Skill | Best For |
|------|-------|----------|
| **Critical** | critical-analysis | Challenging assumptions, evaluating evidence, finding flaws |
| **Creative** | creative-ideation | Generating ideas, lateral thinking, novel solutions |
| **Intuitive** | intuitive-reasoning | Pattern recognition, holistic assessment, gut checks |
| **Systematic** | systematic-evaluation | Structured scoring, methodical evaluation, matrices |

## Trigger
```
/audit-think [mode]
```

Examples:
- `/audit-think critical`
- `/audit-think creative`
- `/audit-think intuitive`
- `/audit-think systematic`

## Mode Details

### Critical Thinking Mode
```
Load: ~/.claude/skills/ultimate-sdlc/knowledge/critical-analysis/SKILL.md
Model: Claude Opus 4.5

Approach:
- Challenge every assumption
- Demand evidence for claims
- Look for logical fallacies
- Identify hidden risks
- Question "obvious" solutions

Use during:
- A1 (Purpose Alignment) - Is the feature really needed?
- T2 (Functional) - Are test results actually valid?
- Defect triage - Is this really a defect?
```

### Creative Thinking Mode
```
Load: ~/.claude/skills/ultimate-sdlc/knowledge/creative-ideation/SKILL.md
Model: Claude Opus 4.5

Approach:
- Generate multiple alternatives
- "What if...?" scenarios
- Combine unrelated concepts
- Challenge constraints
- Embrace wild ideas first, filter later

Use during:
- E2 (Creative Ideation) - New feature ideas
- Problem solving - Stuck on a difficult issue
- Enhancement proposals - Novel improvements
```

### Intuitive Thinking Mode
```
Load: ~/.claude/skills/ultimate-sdlc/knowledge/intuitive-reasoning/SKILL.md
Model: Claude Opus 4.5

Approach:
- Trust pattern recognition
- Holistic "feel" of quality
- User experience gut check
- "Something's off" exploration
- Experienced-based judgment

Use during:
- T3 (GUI Analysis) - Does this feel right?
- E1 (Opportunity Discovery) - What's missing?
- Initial assessment - First impressions
```

### Systematic Thinking Mode
```
Load: ~/.claude/skills/ultimate-sdlc/knowledge/systematic-evaluation/SKILL.md
Model: Claude Opus 4.5

Approach:
- Follow structured frameworks
- Score against criteria
- Weighted evaluations
- Checklists and matrices
- Objective measurements

Use during:
- A3 (Quality Assessment) - Scorecard generation
- Gate verification - Pass/fail criteria
- Completeness checks - Coverage analysis
```

## Mode Switching Protocol

1. **Announce Mode Change**
   ```
   Switching to [MODE] thinking mode.
   Loading: ~/.claude/skills/ultimate-sdlc/knowledge/[skill]/SKILL.md
   ```

2. **Apply Mode Lens**
   - Approach current task through the selected mode's perspective
   - Use mode-specific techniques and questions

3. **Document Mode-Specific Findings**
   Use **Display Template** from `council-audit.md` to show: [MODE] Analysis: [Subject]

4. **Return to Default**
   After task complete, return to balanced approach unless staying in mode is beneficial.

## Multi-Mode Analysis

For complex assessments, apply multiple modes sequentially:

Use **Display Template** from `council-audit.md` to show: Multi-Mode Assessment: [Feature]

## Quick Reference

| Phase | Recommended Mode |
|-------|------------------|
| T1 Inventory | Systematic |
| T2 Functional | Critical |
| T3 GUI | Intuitive + Systematic |
| T4 Integration | Critical |
| T5 Performance | Systematic |
| A1 Purpose | Critical |
| A2 Completeness | Systematic |
| A3 Quality | Systematic + Critical |

> E-track modes (Intuitive, Creative, Systematic) apply in the **Validation Council** (E1-E4).

## Output

After mode switch:
```
Thinking mode activated: [MODE]
Skill loaded: [skill path]
Model: Claude Opus 4.5

Ready for [MODE] analysis. Current task: [context]
```
