---
name: dev-ui-polish-plan
description: |
  Phase 4 of UI Polish — create specific remediation plan with exact replacements for each finding, then present to user for approval (HARD STOP).
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
- Read `~/.claude/skills/antigravity/knowledge/frontend-design/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/ui-ux-pro-max/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/component-patterns/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# /dev-ui-polish-plan - Phase 4: Remediation Plan

---

## Lens / Skills / Model
**Lens**: `[UX]` + `[Quality]` | **Model**: claude-opus-4-6
> Apply RARV cycle, session protocol per `council-development.md`

## Prerequisites

- `.antigravity/council-state/development/ui-slop-report.md` must exist (Phase 2 complete)
- `.antigravity/council-state/development/ui-polish-alternatives.md` must exist (Phase 3 complete)

If prerequisite not met:
```
Design alternatives not found. Run /dev-ui-polish-research first.
Phase 4 requires the researched alternatives from Phase 3.
```

---

## Instructions

### Step 1: Load Inputs

Read:
- `.antigravity/council-state/development/ui-slop-report.md` — the findings to remediate
- `.antigravity/council-state/development/ui-polish-alternatives.md` — the researched alternatives
- `design-system.md` — current design system

### Step 2: Select Best Alternatives

For each finding category, select the best-fit alternative from the research. Prioritize:
1. Cohesion — all selections must work together as a unified design language
2. Feasibility — prefer options that require fewer file changes
3. Distinctiveness — the result must not look like generic AI output

### Step 3: Build Typography Replacement Table

```markdown
## Typography Replacements
| Current | Replacement | Rationale | Files Affected |
|---------|-------------|-----------|----------------|
| [current font (body)] | [new font] | [why] | [count] files |
| [current font (headings)] | [new font] | [why] | [count] files |
| [current font (mono)] | [new font] | [why] | [count] files |
```

Include: Google Fonts import URL, Tailwind config changes, CSS variable updates.

### Step 4: Build Color Replacement Table

```markdown
## Color Replacements
| Current | Replacement | CSS Variable | Files Affected |
|---------|-------------|-------------|----------------|
| [hex] ([name]) | [hex] ([name]) | --color-[token] | [count] files |
```

Include: full palette mapping (primary scale, secondary, accent, neutrals), contrast ratios for each text/background combination.

### Step 5: Build Layout Replacement Table

```markdown
## Layout Replacements
| Page | Current Layout | New Layout | Rationale |
|------|---------------|-----------|-----------|
| [page name] | [current structure] | [new structure] | [why this serves the content better] |
```

### Step 6: Build Component Style Replacement Table

```markdown
## Component Style Replacements
| Current Pattern | Replacement | Rationale |
|----------------|-------------|-----------|
| [current pattern] | [new pattern] | [why] |
```

### Step 7: Build Copy Replacement Table

```markdown
## Copy Replacements
| Current | Replacement | Rationale |
|---------|-------------|-----------|
| "[current text]" | "[new text]" | [why this is better] |
```

### Step 8: HARD STOP — Present to User

**This step is MANDATORY. Do not proceed to Phase 5 without explicit user approval.**

Present the complete remediation plan to the user. Display:
1. Summary of total changes per category
2. The full replacement tables
3. Estimated scope of file changes
4. Ask explicitly: "Approve this remediation plan? (yes / yes with changes / no)"

**If user approves**: Add `## Status: APPROVED` to the plan file and instruct to run `/dev-ui-polish-apply`.
**If user requests changes**: Update the plan per feedback, re-present, repeat until approved.
**If user declines**: Add `## Status: DECLINED` and stop the polish process.

---

## Output

Save remediation plan to `.antigravity/council-state/development/ui-polish-plan.md`:

```markdown
# Design Remediation Plan

## Plan Date: [date]
## Source: ui-slop-report.md + ui-polish-alternatives.md

## Change Summary
- Typography changes: [N] files
- Color changes: [N] files
- Layout changes: [N] pages
- Component style changes: [N] components
- Copy changes: [N] text items
- **Total estimated file changes**: [N]

## Typography Replacements
[Table from Step 3]

### Font Import Changes
[Exact import URLs / config changes]

## Color Replacements
[Table from Step 4]

### Contrast Verification
[Text/background pairs with ratios]

## Layout Replacements
[Table from Step 5]

## Component Style Replacements
[Table from Step 6]

## Copy Replacements
[Table from Step 7]

## Status: [PENDING / APPROVED / DECLINED]
```

---

## Completion Condition

- Every finding from the slop report has a specific replacement defined
- Each replacement includes: current value, new value, files affected, rationale
- Contrast ratios verified for all color changes
- Plan presented to user and explicitly approved
- `## Status: APPROVED` present in the plan file

---

## Next Step

Run `/dev-ui-polish-apply` to implement the approved remediation plan.

---
