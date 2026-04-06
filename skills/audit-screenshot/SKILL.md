---
name: sdlc-audit-screenshot
description: |
  Capture screenshot evidence for defects and findings
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
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/evidence-capture/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/ui-ux-analysis/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/defect-logging/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


# Audit Screenshot Evidence Workflow

> Trigger: `/audit-screenshot [purpose]`

---

## Lens / Skills / Model
**Lens**: `[UX]` + `[Quality]` | **Model**: Claude Sonnet 4.5
> Apply RARV cycle, session protocol per `council-audit.md`

## Description

Captures screenshot evidence with proper annotation, context, and quality requirements. **Screenshots are the PRIMARY evidence in audit work.** This workflow ensures screenshots actually prove what they claim to prove.

## Why This Workflow Exists

AI agents often take useless screenshots:
- Screenshots of wrong area (doesn't show the issue)
- Screenshots without context (what are we looking at?)
- Screenshots at wrong time (before/after the issue, not during)
- Screenshots without annotation (which element has the problem?)

This workflow ensures screenshot evidence is actually useful.

## Pre-Conditions

- Application must be running and accessible
- Browser must be open to relevant page
- Purpose must be clear (what are we documenting?)

## Screenshot Types

| Type | Purpose | Requirements |
|------|---------|--------------|
| **Defect** | Document a bug | Show the defect state, annotate problem area |
| **Baseline** | Document correct state | Before making changes, for comparison |
| **Comparison** | Before/after evidence | Two screenshots showing change |
| **Flow** | Document user journey | Multiple screenshots showing steps |
| **State** | Document current state | Session start, checkpoint |

## Steps

### Step 1: Prepare the Screen

Before capturing:

1. **Navigate to correct location** - ensure you're on the right page/screen
2. **Set correct state** - reproduce the exact condition to document
3. **Remove noise** - close irrelevant popups, notifications
4. **Ensure visibility** - scroll so relevant content is visible
5. **Check timing** - capture at the RIGHT moment (during issue, not after)

### Step 2: Capture Screenshot

Use browser integration to capture:

```
// Capture full page
Screenshot: full page

// Capture visible viewport
Screenshot: viewport

// Capture specific element
Screenshot: element [selector]
```

**Quality Requirements:**

- [ ] Resolution is readable (no blurry text)
- [ ] Relevant content is visible (not cut off)
- [ ] No sensitive data visible (blur if needed)
- [ ] Timestamp visible or documented

### Step 3: Annotate Screenshot

**MANDATORY for defect screenshots:**

Add visual annotations to highlight:

1. **Red box/arrow** - Point to the problem area
2. **Text label** - Brief description of what's wrong
3. **Step number** - If part of a sequence

**Annotation Guidelines:**

| Element | Use When |
|---------|----------|
| Red rectangle | Highlight problematic UI element |
| Red arrow | Point to specific issue location |
| Red circle | Emphasize small details |
| Text callout | Explain what's wrong |
| Step number | Sequential flow documentation |

**Example Annotation Descriptions:**
- "Error message should not appear here"
- "Button is disabled when it should be enabled"
- "Text is truncated/cut off"
- "Wrong color - should be blue"
- "Missing element - 'Save' button expected here"

### Step 4: Add Context Metadata

Generate **Screenshot Artifact** with metadata:

Use **Display Template** from `council-audit.md` to show: Screenshot Evidence: [Purpose]

### Step 5: Verify Screenshot Quality

Before finalizing, verify:

| Check | Requirement |
|-------|-------------|
| Readable | All text is legible |
| Complete | Relevant area fully visible |
| Focused | Shows what it claims to show |
| Annotated | Problem area highlighted (for defects) |
| Contextual | Metadata explains what we're seeing |
| Timely | Captured at the right moment |
| Clean | No unrelated content distracting |

**If any check fails:** Retake the screenshot.

### Step 6: Link to Evidence

Connect screenshot to relevant documentation:

1. **For defects**: Reference in `defect-log.md` entry
2. **For features**: Reference in test execution notes
3. **For phases**: Reference in phase deliverables
4. **For gates**: Include in gate verification

## Screenshot Sequences (Flows)

For documenting user flows or multi-step issues:

Use **Display Template** from `council-audit.md` to show: Screenshot Sequence: [Flow Name]

## Before/After Comparisons

For documenting changes or fixes:

Use **Display Template** from `council-audit.md` to show: Comparison: [What Changed]

## Common Screenshot Mistakes (Avoid)

| Mistake | Problem | Solution |
|---------|---------|----------|
| Too zoomed out | Can't read text | Zoom to 100% or capture element |
| Wrong timing | Shows normal state, not error | Wait for error state, then capture |
| No annotation | Unclear what's wrong | Add red box/arrow to problem |
| Missing context | Don't know what page/feature | Include URL and description |
| Sensitive data | Exposes passwords/PII | Blur or use test data |
| Multiple issues | Confusing what to look at | One screenshot per issue |

## Artifacts Generated

- **Screenshot Artifact**: Annotated screenshot with metadata
- **Screenshot Sequence Artifact**: Multi-step flow documentation
- **Comparison Artifact**: Before/after evidence

## Usage

```
/audit-screenshot defect          # Capture defect evidence
/audit-screenshot baseline        # Capture baseline state
/audit-screenshot flow            # Start flow documentation
/audit-screenshot compare         # Capture for comparison
/audit-screenshot state           # Document current state
```

## Quick Checklist

Before any screenshot is considered valid evidence:

- [ ] Shows what it claims to show
- [ ] Annotated if documenting a defect
- [ ] Metadata explains context
- [ ] Linked to relevant documentation
- [ ] Quality is readable
- [ ] Captured at the right moment
