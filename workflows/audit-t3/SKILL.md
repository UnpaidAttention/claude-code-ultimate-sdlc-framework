---
name: audit-t3
description: |
  Execute Audit Track T3 - GUI Analysis. UI/UX analysis, screenshots, and usability assessment.
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
- Read `~/.claude/skills/antigravity/knowledge/ui-ux-analysis/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/accessibility-testing/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/usability-assessment/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/visual-design-review/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# /audit-t3 - GUI Analysis

## Lens / Skills / Model
**Lens**: `[UX]` + `[Quality]` | **Model**: Claude Opus 4
> Apply RARV cycle, session protocol per `council-audit.md`

## Prerequisites

- T2 (Functional Testing) must be complete

If prerequisites not met:
```
T2 not complete. Run /audit-t2 first.
```

---

## Workflow

### Step 1: Update Project State

Update `.antigravity/project-context.md`:
- Set `Active Council`: audit
- Set `Current Phase`: T3 - GUI Analysis
- Set `Status`: in_progress

### Step 2: Screen Inventory

Document all screens/pages:

| Screen | Purpose | Priority |
|--------|---------|----------|
| [Screen name] | [What it does] | [High/Med/Low] |

### Step 3: Screenshot Documentation

For each screen, use agent-native capture methods:

**Using Antigravity browser extension (primary):**
1. Start dev server via terminal (if not already running)
2. Navigate to each screen via `browser_navigate`
3. Capture screenshot via `browser.capture_screenshot_and_save`
4. For responsive testing, resize viewport and capture at each breakpoint:
   - Mobile: `browser_resize_window(375, 812)` → capture
   - Tablet: `browser_resize_window(768, 1024)` → capture
   - Desktop: `browser_resize_window(1920, 1080)` → capture
5. Record full navigation flow as WebP video for walkthrough evidence

**Using Playwright MCP (secondary):**
- Navigate via `browser_navigate` → capture via `browser_take_screenshot`

**Fallback:** Request user provide screenshots — see `.reference/screenshot-capture-guide.md`

Save to `.antigravity/council-state/audit/screenshots/`
Name format: `T3-[screen-name]-[state].png`

### Step 4: Navigation Flow Analysis

Map user journeys:

```
Home → Login → Dashboard → Feature A → Result
                    ↓
              Feature B → Result
```

Verify:
- [ ] All navigation paths work
- [ ] Back button behavior correct
- [ ] Breadcrumbs accurate (if present)
- [ ] Deep links work

### Step 5: Usability Assessment

Evaluate each screen for:

#### Visual Design
- [ ] Consistent styling
- [ ] Readable typography
- [ ] Appropriate spacing
- [ ] Visual hierarchy clear

#### User Experience
- [ ] Intuitive layout
- [ ] Clear call-to-actions
- [ ] Helpful feedback messages
- [ ] Loading states present

#### Accessibility
- [ ] Keyboard navigation
- [ ] Screen reader compatibility
- [ ] Color contrast adequate
- [ ] Focus indicators visible
- [ ] Lighthouse accessibility audit (use Lighthouse MCP `lighthouse_audit` or `npx lighthouse <url> --output=json` for automated checks: color contrast, ARIA attributes, focus management)

#### Responsiveness
- [ ] Mobile layout works
- [ ] Tablet layout works
- [ ] Desktop layout works

### Step 6: Log Usability Issues

For each issue found:
- Severity: [Critical/High/Medium/Low]
- Screen: [Where it occurs]
- Description: [What's wrong]
- Recommendation: [How to fix]

### Step 7: Phase Completion Criteria

Before completing this phase, verify:
- [ ] All screens documented with screenshots
- [ ] Navigation flows mapped
- [ ] Accessibility issues identified
- [ ] Usability issues logged

### Step 8: Complete Phase

When all criteria met:

Use **Display Template** from `council-audit.md` to show: T3: GUI Analysis - Complete

---
