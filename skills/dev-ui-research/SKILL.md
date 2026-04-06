---
name: sdlc-dev-ui-research
description: |
  Conduct UI design research using external platforms before any frontend implementation. Executes once after first Gate I4 pass.
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
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/frontend-design/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/ui-ux-pro-max/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


# /dev-ui-research - UI Design Research Phase

## Purpose

Research UI design approaches, gather visual inspiration, and analyze reference applications BEFORE any frontend implementation begins. This phase ensures the agent builds from informed design decisions rather than generic defaults.

**Core Principle**: "Design is research, not decoration." — The agent must investigate before it builds.

---

## Lens / Skills / Model
**Lens**: `[UX]` + `[Quality]` | **Model**: claude-opus-4-6
> Apply RARV cycle, session protocol per `council-development.md`

## Prerequisites

- At least one run has passed Gate I4 (backend APIs exist)
- `handoffs/planning-handoff.md` exists with Design Direction (Section 4)
- Feature specs exist in `specs/features/`
- Deep-dives exist in `specs/deep-dives/`
- `.ultimate-sdlc/council-state/development/run-tracker.md` shows UI Design Phases status = PENDING

If prerequisites not met:
```
UI Research requires Gate I4 to have passed for at least one run.
Complete backend development first, then return to /dev-ui-research.
```

---

## Workflow

### Step 1: Load Design Context

1. Read `handoffs/planning-handoff.md` Section 4 (Design Direction):
   - Visual identity statement
   - Typography selections
   - Color palette
   - Spatial composition strategy
   - Motion design language
   - Design references
   - Anti-convergence answer

2. Read ALL `specs/features/FEAT-XXX.md` files to compile a list of every page/view the application requires.

3. Read ALL `specs/deep-dives/DIVE-XXX.md` files to extract component inventories and user journeys.

4. Produce a **Page Inventory**:

```
Pages/Views identified:
1. [Page name] — [purpose] — from FEAT-XXX
2. [Page name] — [purpose] — from FEAT-XXX
...
Total pages: [N]
```

### Step 2: Dribbble Design Research

**Platform**: https://dribbble.com/

For each major page type identified in Step 1:

1. **Search** with targeted queries:
   - `[application type] [page type] UI design` (e.g., "SaaS dashboard UI design")
   - `[page type] [design direction keywords]` (e.g., "settings page minimal dark")
   - `[component type] design` for key components (e.g., "data table design", "sidebar navigation")

2. **Extract** from search results:
   - Layout patterns: grid structure, content zones, visual hierarchy
   - Color treatments: palette usage, contrast approaches, background treatments
   - Typography: font size hierarchy, weight usage, heading styles
   - Component styles: button treatments, card designs, input styles, navigation patterns
   - Responsive indicators: how layouts adapt across viewport hints

3. **Document** per page type:
   - 2-3 strongest design references found (describe what makes them strong)
   - Specific patterns worth adopting for this application
   - What to avoid (patterns that conflict with the design direction)

**Completion check**: Every page type has at least 2 design references documented.

### Step 3: Spline Community Research

**Platform**: https://app.spline.design/community

1. Browse community for interactive elements relevant to the application:
   - Hero sections and interactive backgrounds
   - Data visualizations and animated charts
   - Loading animations and micro-interactions
   - 3D product viewers (if applicable)

2. Assess whether 3D/interactive elements are appropriate for this application:
   - Does the design direction call for depth and interactivity? → Research further
   - Is this a data-heavy utility app? → 3D likely inappropriate, document as N/A
   - Is this a marketing/consumer product? → 3D could elevate the design

3. Document:
   - Relevant interactive patterns found (or "N/A — 3D not appropriate for this application")
   - Animation styles observed that match the design direction's motion language

### Step 4: Google Stitch Exploration

**Platform**: https://stitch.withgoogle.com/

1. **If Stitch MCP is available** (scan environment for `generate_screen_from_text` tool — `wave5-context.md` does not exist yet during UI-R):
   - Generate 2-3 prototype screens for the application's primary pages
   - Use the planning handoff's design direction as the prompt basis
   - Extract design patterns from generated screens
   - If Stitch produces a DESIGN.md: save as supplementary reference in `.ultimate-sdlc/council-state/development/stitch-references/` (not as the canonical design system)

2. **If Stitch web tool is accessible** (via WebFetch/WebSearch):
   - Research available design patterns and templates
   - Document relevant patterns for the application type

3. **If Stitch is not available**:
   - Document: "Stitch not available — proceeding with Dribbble and competitive research only"

### Step 5: Competitive & Reference Analysis

1. **Search** for 3-5 existing applications similar to the one being built:
   - Use WebSearch to find real applications in the same domain
   - Focus on applications praised for good UI/UX

2. **For each reference application, document**:
   - What their UI does well (specific, actionable observations)
   - What their UI does poorly (patterns to avoid)
   - Navigation structure (sidebar, top-nav, tabs, how deep is the hierarchy?)
   - Information architecture (how is content organized?)
   - Component patterns (cards, tables, forms — what approach do they use?)

3. **Synthesize** patterns observed across all references:
   - Common navigation approaches in this domain
   - Expected page types and layouts
   - Standard interactive patterns users expect

### Step 6: Generate Design Research Document

Create `.ultimate-sdlc/council-state/development/ui-design-research.md`:

```markdown
# UI Design Research — [Project Name]

## Application Profile
- **Type**: [from product concept]
- **Target users**: [from feature specs]
- **Design personality**: [from planning handoff Design Direction]
- **Unforgettable element**: [from planning handoff anti-convergence answer]
- **Pages identified**: [count]

## Visual Direction Summary
[2-3 paragraphs synthesizing ALL research findings into a clear, specific design direction.
Not generic principles — specific choices informed by what was researched.]

## Page-by-Page Design References

### [Page Name] — [Route]
- **Layout approach**: [specific layout informed by Dribbble/competitive research]
- **Key components**: [list with design approach for each]
- **Design references**: [describe 1-2 specific references found]
- **Responsive approach**: [how this page adapts, based on reference patterns]

[Repeat for EVERY page in the Page Inventory]

## Component Style References

### Navigation
[Design approach informed by research — specific, not generic]

### Cards / Content Containers
[Design approach]

### Forms / Input Elements
[Design approach]

### Tables / Data Display
[Design approach — if applicable]

### Modals / Overlays
[Design approach]

### Buttons / CTAs
[Design approach]

## Color & Typography Refinement
[Confirm or refine the planning handoff's selections based on research.
If research suggests different fonts or colors than planning proposed, state the revision with rationale.]

## Research Sources
[List all Dribbble searches performed, reference applications analyzed, Spline resources found, Stitch explorations done]
```

### Step 7: Update Run Tracker

Update `.ultimate-sdlc/council-state/development/run-tracker.md`:
- Set `UI Design Phases > UI Research` status to ✅ COMPLETE

### Step 8: Announce Completion

```
## UI Design Research Complete

**Pages researched**: [N]
**Design references collected**: [N]
**Competitive applications analyzed**: [N]

Research document saved to: .ultimate-sdlc/council-state/development/ui-design-research.md

Next step: Run /dev-ui-design-plan to create the UI design plan.
```

---

## Completion Condition

The phase is complete when ALL of the following are true:
- `.ultimate-sdlc/council-state/development/ui-design-research.md` exists
- Every page from the Page Inventory has a section in the research document
- Each page section contains at least 2 specific design references (not generic principles)
- At least 3 competitive/reference applications were analyzed
- The Visual Direction Summary is specific to this application (not generic design advice)

**Verification test**: Count pages in research document sections. Compare to Page Inventory count. If they match: PASS. If not: identify missing pages and research them.

---

## Error Handling

**If Dribbble search returns no useful results for a page type:**
- Broaden the search (try synonyms, related page types)
- Search for the general application type instead of specific page
- Document that limited references were found and note the searches attempted

**If no competitive applications found:**
- Broaden the domain search
- Search for applications with similar features even if different domain
- Minimum: 2 reference applications (relax from 3-5 if truly nothing exists)

**If web search tools are unavailable:**
- Use the `ui-ux-pro-max` skill's search tool for internal design database results
- Use the `frontend-design` skill's decision trees for design direction
- Document that web research was not possible; research was internal only
- The phase still completes — the design plan will rely more heavily on the skill's built-in knowledge

---

## Agent Invocations

### Agent: ux
Invoke via Agent tool with `subagent_type: "sdlc-ux"`:
- **Provide**: Design direction from planning handoff, feature specs, page inventory, competitive analysis results
- **Request**: Conduct design research — analyze Dribbble references, competitive applications, and design patterns; synthesize findings into a specific visual direction with per-page design references and component style guidance
- **Apply**: Integrate research findings into the ui-design-research artifact to inform the design plan

---
