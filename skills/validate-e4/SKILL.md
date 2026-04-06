---
name: sdlc-validate-e4
description: |
  Execute Enhancement Track E4 - UX Polish. Final user experience polish and refinement.
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
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/ux-polish/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/accessibility-standards/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/ui-ux-analysis/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/visual-consistency/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


# /validate-e4 - UX Polish

## Lens / Skills / Model
**Lens**: `[UX]` | **Model**: Claude Opus 4.5
> Apply RARV cycle, session protocol per council-validation.md

## Prerequisites

- E3 (Enhancement Implementation) must be complete

If prerequisites not met:
```
E3 not complete. Run /validate-e3 first.
```

---

## Workflow

### Step 1: Update Project State

Update `.ultimate-sdlc/project-context.md`:
- Set `Current Phase`: E4 - UX Polish
- Set `Status`: in_progress

### Agent: ux
Invoke via Agent tool with `subagent_type: "sdlc-ux"`:
- **Provide**: All screens/pages, design system, accessibility standards, user journey maps
- **Request**: Conduct final usability review — identify remaining UX friction, inconsistent patterns, missing feedback states, and accessibility gaps
- **Apply**: Add UX findings to the polish checklist

### Agent: frontend-specialist
Invoke via Agent tool with `subagent_type: "sdlc-frontend-specialist"`:
- **Provide**: Frontend source code, screenshots, design system specs
- **Request**: Conduct anti-slop verification — identify AI-generated placeholder text, generic copy, inconsistent styling, unused components, and visual artifacts that indicate unfinished work
- **Apply**: Add anti-slop findings to the polish implementation list

### Step 2: UX Review Checklist

Complete UX polish checklist:

Use **Display Template** from `council-validation.md` to show: UX Polish Checklist

### Step 3: Polish Implementation

For each polish item, capture before/after evidence:

Use **Display Template** from `council-validation.md` to show: Polish: [Item]

### Step 4: Final UX Walkthrough

Conduct final UX walkthrough using the browser extension to navigate all paths:

1. **Happy Path** - Main user journey smooth
2. **Error Path** - Errors handled gracefully
3. **Edge Cases** - Unusual scenarios handled
4. **Empty States** - Empty views appropriate
5. **First Use** - Onboarding clear

Use browser extension to navigate each path, capturing screenshots at each step via `browser.capture_screenshot_and_save`. Record the full walkthrough as a WebP video artifact (automatic with browser extension). If browser extension unavailable, use Playwright MCP or request user to perform the walkthrough.

### Step 5: Phase Completion Criteria

- [ ] UX checklist complete
- [ ] All polish items addressed
- [ ] Final walkthrough passed
- [ ] Screenshots updated

### Step 6: Complete Phase

```
## E4: UX Polish - Complete

**Polish Items Addressed**: [X]
**UX Score**: [Y]/10
**Accessibility Score**: [Z]/10

**Next Step**: Run `/validate-gate-e4` to verify Gate E4 criteria
```

---
