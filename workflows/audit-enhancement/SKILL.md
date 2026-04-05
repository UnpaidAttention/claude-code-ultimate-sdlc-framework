---
name: audit-enhancement
description: |
  Log enhancement idea discovered during audit
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
- Read `~/.claude/skills/antigravity/knowledge/creative-ideation/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/value-assessment/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/systematic-evaluation/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# Audit Enhancement Workflow

> Trigger: `/audit-enhancement`

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per `council-audit.md`

## Description

> **Intake Only.** This workflow logs enhancement *ideas* discovered during audit. Actual enhancement evaluation and implementation happens in the Validation Council (E1-E4).

Logs a new enhancement idea with proper documentation. Captures improvement opportunities discovered during audit for later processing by the Validation Council.

## Why This Workflow Exists

During testing and auditing, you'll discover opportunities for improvement that aren't defects—they're ideas for making the software better. Without a structured way to capture these, they get lost. This workflow ensures enhancement ideas are documented with enough context to be actionable.

## When to Use

Use `/audit-enhancement` when you discover:
- A feature that could work better
- A missing feature that would add value
- A UX improvement opportunity
- A performance optimization idea
- A workflow that could be streamlined
- A capability that competitors have

**Not for defects!** Use `/audit-defect` for actual bugs.

## Steps

### Step 1: Capture Context

Note the current state:
- What feature/area were you testing?
- What triggered this idea?
- Take a Screenshot Artifact if visual context helps

### Step 2: Gather Enhancement Details

Ask for (or document from observation):
- **Title**: Brief descriptive name
- **Category**:
  - UX Improvement
  - New Feature
  - Performance
  - Workflow
  - Integration
  - Accessibility
  - Other
- **Related Feature**: Which existing feature this relates to
- **Current State**: How it works now
- **Proposed Enhancement**: What could be better

### Step 3: Generate Enhancement ID

Read current enhancement count from `audit-context.md`:
- Assign next ID: ENH-XXX
- Increment counter

### Step 4: Assess Value

Evaluate the enhancement:

**User Impact** (1-5):
- 5: Dramatically improves experience
- 4: Significantly helps users
- 3: Noticeable improvement
- 2: Minor improvement
- 1: Marginal benefit

**Implementation Effort** (1-5):
- 1: Trivial (< 1 day)
- 2: Small (1-3 days)
- 3: Medium (1-2 weeks)
- 4: Large (2-4 weeks)
- 5: Major (> 1 month)

**Priority Score**: Impact / Effort (higher = better ROI)

### Step 5: Document Enhancement

Create an **Enhancement Artifact** and append to `enhancement-register.md`:

Use **Display Template** from `council-audit.md` to show: ENH-XXX: [Title]

### Step 6: Categorize for E-Track

Tag enhancement for Enhancement activities (→ Validation Council) processing:
- **E1 (Discovery)**: Raw opportunity, needs analysis
- **E2 (Ideation)**: Needs creative exploration
- **E3 (Proposal)**: Ready for formal proposal

### Step 7: Update Context

Update `audit-context.md`:
- Increment enhancement count
- Update category breakdown

Update `.antigravity/progress.md`:
Use **Display Template** from `council-audit.md` to show: Enhancement Captured: ENH-XXX

### Step 8: Announce

> "Enhancement ENH-XXX '[Title]' logged with priority score [X.X]. Continue testing?"

## Artifacts Generated

- **Enhancement Artifact**: Documented improvement idea
- **Screenshot Artifact**: (if visual context captured)

## Enhancement vs Defect Decision Guide

| Situation | Classification |
|-----------|----------------|
| It doesn't work as specified | **Defect** |
| It works but could be better | **Enhancement** |
| It's missing something required | **Defect** |
| It's missing something nice-to-have | **Enhancement** |
| Users can't complete their task | **Defect** |
| Users can complete task but it's tedious | **Enhancement** |
| It crashes or errors | **Defect** |
| It's slow but functional | **Enhancement** (usually) |

## Enhancement Categories Explained

| Category | Examples |
|----------|----------|
| **UX Improvement** | Better layout, clearer labels, improved flow |
| **New Feature** | Functionality that doesn't exist |
| **Performance** | Speed improvements, optimization |
| **Workflow** | Streamlined processes, fewer steps |
| **Integration** | Connect with other systems |
| **Accessibility** | Beyond WCAG compliance, inclusive design |
