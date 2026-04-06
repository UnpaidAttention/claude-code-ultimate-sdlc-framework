---
name: sdlc-planning-feature
description: |
  Create comprehensive 8-section feature matrix specification
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/feature-spec/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/aiou-decomposition/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/edge-case-handling/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# Planning Feature Matrix Workflow

> Trigger: `/planning-feature`

---

## Lens / Skills / Model
**Lens**: `[Requirements]` | **Model**: Claude Opus 4.5
> Apply RARV cycle, session protocol per council-planning.md

## Description

Creates a comprehensive 8-section feature matrix for a single feature. Ensures consistent, high-quality feature specifications that can be properly decomposed into AIOUs.

## Why This Workflow Exists

Feature specifications are the foundation of implementation. Incomplete or inconsistent specs lead to rework and quality issues. This workflow enforces the 8-section format that captures everything needed for successful implementation.

## Pre-Conditions

- Should be in Phase 3 (Features)
- Feature should be identified from requirements

## Steps

### Step 1: Enter Plan Mode

Switch to **Plan Mode** for thorough feature analysis. This ensures:
- Deep thinking about the feature
- Complete coverage of all sections
- Artifact generation for review

### Step 2: Gather Feature Information

Ask user for (or extract from requirements):
- Feature name
- Brief description
- Related user stories
- Related module/domain grouping

### Step 3: Create 8-Section Matrix

Generate a **Documentation Artifact** with this exact format:

Use **Display Template** from `council-planning.md` to show: Feature: [Feature Name]

#### 1. Overview & Priority
- **Description**: [Brief description]
- **Module/Domain**: [Related module or domain grouping]
- **Related Requirements**: [List]

#### 2. User Stories & Acceptance Criteria

```gherkin
Given [context]
When [action]
Then [expected result]
```

#### 3. Data Requirements

```json
// Request
{}

// Response
{}
```

#### 4. API Endpoints
- `[METHOD] /api/[endpoint]` — [Description]

#### 5. UI/UX Requirements

#### 6. Edge Cases & Error Handling

#### 7. Dependencies & Integration Points

#### 8. AIOU Candidates
### Step 4: Verify Completeness

Before finalizing, verify:
- [ ] All 8 sections are complete
- [ ] User stories have acceptance criteria
- [ ] Data model is clear
- [ ] API endpoints are defined
- [ ] UI requirements are actionable
- [ ] Edge cases are identified
- [ ] Dependencies are mapped
- [ ] AIOU candidates are reasonable

### Step 5: Save Feature Matrix

- Save to `specs/features/[feature-name].md` or append to features document
- Update `.ultimate-sdlc/progress.md` with completion
- Update feature count in `.ultimate-sdlc/project-context.md`

### Step 6: Knowledge Base

Save useful patterns to Knowledge Base:
- Domain-specific terminology
- Common edge cases for this type of feature
- API patterns used

## Artifacts Generated

- **Documentation Artifact**: Complete 8-section feature matrix

## Tips for Quality

1. **Be specific** - Vague specs lead to rework
2. **Think about errors** - What can go wrong?
3. **Consider scale** - Will this work at 10x volume?
4. **Trace to requirements** - Every feature needs a "why"
5. **Think about testing** - How will QA verify this?
