---
name: sdlc-dev-wave5-classify
description: |
  Classify Wave 5 AIOUs for optimal model routing when not done during planning
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
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/ui-classification/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/component-patterns/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/model-routing/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/systematic-evaluation/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


# Workflow: dev-wave5-classify

---

## Lens / Skills / Model
**Lens**: `[UX]` + `[Quality]` | **Model**: claude-opus-4-6
> Apply RARV cycle, session protocol, code review protocol per `council-development.md`

## Trigger

`/dev-wave5-classify` or automatically from `/dev-wave5-start` when classification is missing

## When to Use

- Wave 5 AIOUs exist but lack UI Classification fields
- Planning Council did not perform classification during Phase 3.5
- Need to determine which model should implement each UI component

## Prerequisites

- `planning-handoff.md` exists with Wave 5 AIOUs
- Each AIOU has scope and acceptance criteria defined

## Instructions

### Step 1: Load Classification Reference

Read the classification directive:
```
Read directives/wave5-ui-classification.md
```

### Step 2: Extract Wave 5 AIOUs

1. Read `planning-handoff.md`
2. Extract all Wave 5 (Phase I6) AIOUs
3. For each AIOU, collect:
   - AIOU ID
   - Name
   - Scope description
   - Acceptance criteria
   - Dependencies
   - Files to create/modify

### Step 3: Classify Each AIOU

For each Wave 5 AIOU, analyze and assign:

#### UI Model Classification

**Check for VISUAL indicators:**
- Mockup reference in scope
- Animation requirements (transitions, hover effects)
- Creative/marketing focus (landing pages, hero sections)
- Simple or no state management
- Primary concern is visual fidelity
- No forms or complex validation

**Check for LOGIC indicators:**
- Form inputs with validation
- Complex state management
- Multi-step wizards or flows
- Extensive error handling
- Data manipulation and display
- API integration
- Complex accessibility requirements

**Classification Decision:**
```
IF VISUAL indicators AND NOT LOGIC indicators → VISUAL (claude-opus-4-6)
IF LOGIC indicators AND NOT VISUAL indicators → LOGIC (Claude Opus 4.5)
IF BOTH significant indicators → HYBRID (Both models)
IF UNCLEAR → LOGIC (Claude handles uncertainty better)
```

#### UI Layer Assignment

| Layer | Assign When Component Is |
|-------|--------------------------|
| 1 | Design tokens, theme config, utility functions (cn(), spacing) |
| 2 | Atomic: Button, Input, Label, Icon, Badge, Spinner |
| 3 | Molecular: FormField, Card, ListItem, MenuItem, Alert |
| 4 | Structural: Header, Footer, Sidebar, PageShell, Navigation |
| 5 | Feature-specific: DataTable, Chart, SearchBar, Form, Modal |
| 6 | Full pages: DashboardPage, SettingsPage, ProfilePage |
| 7 | Cross-cutting: Navigation flows, global animations, polish |

#### UI Dependencies

Identify which other Wave 5 AIOUs this one depends on:
- Component imports (e.g., Form depends on FormField, Input, Button)
- Shared state or context providers
- Layout requirements

### Step 4: Validate Classifications

Before finalizing:

1. **Check layer dependencies**: Lower-layer components cannot depend on higher-layer ones
2. **Check for cycles**: UI Dependencies must form a valid DAG (no circular references)
3. **Verify HYBRID count**: Should be ~10-20% of total (rare)
4. **Review layer distribution**: Should have reasonable spread across layers

If issues found:
- Adjust layer assignments
- Break circular dependencies
- Justify HYBRID classifications

### Step 5: Create Classification Summary

Generate classification summary:

Use **Display Template** from `council-development.md` to show: Wave 5 AIOU Classification
Layer 1-2 (Foundation/Primitives)
    AIOU-XXX ──┐
    AIOU-YYY ──┼──▶ Layer 3 (Composites)
    AIOU-ZZZ ──┘         AIOU-AAA ──┐
                         AIOU-BBB ──┼──▶ Layer 4+ ...
```

### Execution Order

[Ordered list respecting layers and dependencies]
```

### Step 6: Update Planning Handoff

Add UI Classification fields to each Wave 5 AIOU in `planning-handoff.md`:

Use **Display Template** from `council-development.md` to show: UI Classification (Wave 5 Only)

### Step 7: Save to Wave 5 Context

Update or create `wave5-classification.md` with the full classification results.

### Step 8: Announce Classification Complete

Output:

Use **Display Template** from `council-development.md` to show: Wave 5 Classification Complete

## Classification Keywords Reference

### VISUAL Keywords
- animation, transition, hover, creative, mockup
- landing, visual, illustration, decorative
- hero, marketing, splash, onboarding

### LOGIC Keywords
- validation, form, wizard, multi-step, error handling
- state management, filter, sort, pagination, CRUD
- auth, permission, settings, configuration

### HYBRID Keywords (both present)
- interactive + dashboard
- visualization + drill-down
- animated + form
- gamified + progress tracking
- tutorial + animations

## Notes

- Classification during planning is preferred but not always done
- This workflow enables Development Council to classify when needed
- HYBRID should be rare (~10-20% of AIOUs)
- When unsure, default to LOGIC (Claude handles uncertainty better)
- Layer assignment is critical for execution order
- Always validate dependency graph for cycles

## Agent Invocations

### Agent: sdlc-frontend-specialist
Invoke via Agent tool with `subagent_type: "sdlc-frontend-specialist"`:
- **Provide**: Wave 5 AIOU list with scope descriptions, acceptance criteria, UI dependencies, component framework
- **Request**: Classify each AIOU complexity (VISUAL/LOGIC/HYBRID), assign UI layer (1-7), determine execution order, and validate dependency graph for cycles
- **Apply**: Use classification results in Steps 3-5 to populate the Wave 5 AIOU Classification summary and update planning handoff
