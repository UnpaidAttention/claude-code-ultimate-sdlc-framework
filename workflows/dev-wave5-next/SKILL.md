---
name: dev-wave5-next
description: |
  Move to the next Wave 5 AIOU with model switch suggestion
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/component-patterns/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/model-routing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/progress-tracking/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# Workflow: dev-wave5-next

---

## Lens / Skills / Model
**Lens**: `[UX]` + `[Quality]` | **Model**: claude-opus-4-6
> Apply RARV cycle, session protocol, code review protocol per `council-development.md`

## Trigger

`/dev-wave5-next` or after completing current AIOU

## Prerequisites

- Wave 5 initialized via `/dev-wave5-start`
- `wave5-context.md` exists with execution queue
- If not first AIOU: current AIOU must be verified complete

## Instructions

### Step 1: Read Wave 5 Context

Read `wave5-context.md` to get:
- Current AIOU (if any)
- Execution queue (next AIOUs)
- Completed AIOUs
- Layer progress

**Feature Context Loading** (per council-development.md § Feature Context Loading Protocol):
For each AIOU in this wave, read the parent FEAT spec and deep-dive.
Record feature context in WORKING-MEMORY.md before beginning implementation.

### Step 2: Verify Current AIOU Complete (if applicable)

If there's a current AIOU in progress:

1. Check if AIOU is verified complete:
   - `/dev-verify-aiou AIOU-XXX` was run
   - AIOU Completion Artifact exists
   - Tests pass

2. If NOT complete:
   - Output: "Current AIOU-XXX is not yet complete. Run `/dev-verify-aiou AIOU-XXX` first."
   - STOP

3. If complete:
   - Update `wave5-context.md`: move to Completed list
   - Commit: `Complete AIOU-XXX: [description]`

### Step 3: Get Next AIOU from Queue

1. Read execution queue from `wave5-context.md`
2. Get the next AIOU that:
   - Is not completed
   - Has all UI Dependencies satisfied (completed)

If no AIOU available due to unmet dependencies:
- Output: "Next AIOUs have unsatisfied dependencies. Complete these first: [list]"
- STOP

If queue is empty (all complete):
- Output: "All Wave 5 AIOUs complete! Run `/dev-wave-6` to proceed to Integration."
- STOP

### Step 4: Load AIOU Details

From `planning-handoff.md`, extract:
- AIOU ID and Name
- UI Model classification
- UI Layer
- UI Dependencies
- Scope
- Acceptance Criteria
- Visual Requirements
- Technical Notes

### Step 5: Determine Model Requirement

Based on UI Model:

**VISUAL**:
```
Recommended Model: claude-opus-4-6
Reason: This AIOU is visual-first (animations, mockup-driven, creative layout)
```

**LOGIC**:
```
Recommended Model: Claude Opus 4.5
Reason: This AIOU requires complex state, validation, or error handling
```

**HYBRID**:
```
Recommended Model: claude-opus-4-6 (Phase 1)
Reason: Start with visual prototype, then switch to Claude Opus 4.5 for logic refinement
Note: This AIOU requires TWO implementation passes
```

### Step 6: Check for Model Switch

Compare recommended model to current model:
- If SAME model: "Continue with current model"
- If DIFFERENT model: "MODEL SWITCH REQUIRED"

### Step 7: Update Wave 5 Context

Update `wave5-context.md`:
Use **Display Template** from `council-development.md` to show: Status

### Step 8: Announce Next AIOU

Output:

Use **Display Template** from `council-development.md` to show: Next AIOU: [AIOU-XXX]

### Step 9: For HYBRID AIOUs

If this is a HYBRID AIOU:

**Phase 1 (claude-opus-4-6)**:
- Focus on visual implementation
- Create component structure
- Implement animations and styling
- Placeholder logic is OK

**Phase 2 (Claude Opus 4.5)**:
- Refine state management
- Implement validation logic
- Handle error cases
- Polish edge cases

After Phase 1, output:
Use **Display Template** from `council-development.md` to show: HYBRID AIOU Phase 1 Complete

## Arguments

| Argument | Description |
|----------|-------------|
| `--skip` | Skip current AIOU (mark as blocked) |
| `--hybrid-phase2 AIOU-XXX` | Continue HYBRID AIOU Phase 2 |
| `--force` | Force move to next even if current incomplete |

## Progress Display

Show progress bar:
```
Wave 5 Progress: [=========>          ] 45% (9/20 AIOUs)

Layer Progress:
  L1-2: ████████████ 100% (4/4)
  L3:   ████████░░░░  67% (2/3)
  L4:   ████░░░░░░░░  33% (1/3)
  L5:   ░░░░░░░░░░░░   0% (0/5)
  L6:   ░░░░░░░░░░░░   0% (0/4)
  L7:   ░░░░░░░░░░░░   0% (0/1)
```

## Design Plan & System Compliance

Before implementing each AIOU:
1. Read `design-system.md` — apply established typography, colors, and spacing tokens
2. Read `.ultimate-sdlc/council-state/development/ui-design-plan.md` — find the page layout, navigation entries, and interactive element inventory entries relevant to this AIOU
3. **Check the Route Tree**: Identify ALL routes this AIOU covers — both the parent page AND every sub-page, tab, and wizard step beneath it. The AIOU is not complete until ALL routes it owns are implemented.
4. **Implement against the design plan**: Use the planned layout, wire interactive elements per the inventory, follow the navigation architecture for all links
5. Reference `frontend-design` skill's Anti-Convergence Rule: every component must be distinctive
6. After implementation, verify against ANTI-SLOP-RULES (P0): no banned fonts, no purple gradients, no generic layouts
7. Ensure all colors use semantic design tokens, not ad-hoc hex values
8. **Verify interactive element wiring**: For each button, form, or modal in this AIOU's scope (per the inventory), confirm the handler is connected and performs the documented action

### Page Depth Completion Rule (MANDATORY)

**An AIOU that covers a container page (a page with sub-pages/tabs/wizard steps) is NOT complete until ALL of its children are implemented.**

When implementing a page that has children in the Route Tree:
1. Implement the container/shell (layout, sub-navigation tabs/sidebar)
2. Implement EVERY child page listed in the Route Tree for this container
3. Wire the sub-navigation so every tab/link leads to its child page with real content
4. For wizard flows: implement every step with its fields, validation, navigation (next/back/cancel)
5. Verify: navigate to the container page → click/tap every sub-nav item → each renders its own content (not blank, not placeholder, not "coming soon")

**Do NOT:**
- Implement the shell and leave tabs empty or with placeholder content
- Implement the first sub-page and skip the rest
- Create routes that render blank components or redirect to the parent
- Defer sub-page content to "a later AIOU" unless the sub-page has its own explicit AIOU assignment

**If an AIOU covers too many sub-pages to implement in one pass**: the scope analysis should have decomposed this into multiple AIOUs. If it didn't, implement all sub-pages anyway — completeness is mandatory. Document in WORKING-MEMORY.md that the AIOU was larger than expected.

### Component Interaction Depth Rule (MANDATORY — This Prevents "Three Dots That Do Nothing")

**Every interactive element rendered on screen MUST be implemented through all 4 layers. A button that appears but does nothing when clicked is a defect, not a partial implementation.**

The 4 layers of a complete interactive element:

| Layer | What It Means | Example (Actions Menu) | Common Failure |
|-------|--------------|----------------------|----------------|
| **1. Render** | Element appears on screen | Three-dots icon shows in each row | Agent stops here |
| **2. Trigger** | Click/hover handler attached and fires | onClick opens a dropdown menu | Agent adds onClick but it's empty |
| **3. Response** | Handler produces the correct UI effect | Menu shows items: View, Edit, Delete | Agent shows menu but items do nothing |
| **4. Completion** | Each action resolves end-to-end | "Delete" opens confirm dialog → confirms → API call → row removed → toast shown | Almost never implemented |

**ALL 4 LAYERS ARE REQUIRED for every interactive element.** Use the Feature Interaction Map from `ui-design-plan.md` as the specification for each element's complete flow.

**Per-page implementation checklist** (complete before moving to next page):

After implementing all elements on a page, walk through EVERY interaction mapped for this page's feature:

```
For each interaction in the Feature Interaction Map for this page:
1. □ Trigger the interaction (click the button, submit the form, open the menu)
2. □ Verify the response appears (modal opens, menu shows, page navigates)
3. □ Complete the flow (fill form + submit, select menu item, confirm dialog)
4. □ Verify the success state (toast appears, list refreshes, modal closes, data persists)
5. □ Verify the error state (submit with invalid data → error messages appear)
6. □ Verify cancel/close (dismiss without completing → state unchanged)
```

**For actions menus / context menus / dropdown menus specifically:**
- The menu trigger (three dots, right-click, dropdown arrow) opens the menu ← Layer 2
- EVERY menu item is present with correct label and icon ← Layer 3
- Clicking EACH menu item performs its documented action ← Layer 4
- The menu closes after selection ← Layer 4

**For CRUD features specifically:**
Use the CRUD Completeness Matrix from `ui-design-plan.md`. Before marking a feature's AIOU complete:
- [ ] **Create**: Form/modal opens, all fields present, validation works, submit creates entity, success feedback shown
- [ ] **Read List**: Data loads, table/list populated, loading state shows during fetch, empty state shows when no data
- [ ] **Read Detail**: Clicking entity navigates to detail, all entity info displayed, back navigation works
- [ ] **Update**: Edit form opens pre-populated, changes submit, success feedback shown, data refreshes
- [ ] **Delete**: Confirmation dialog appears, confirm deletes, entity removed from list, success feedback shown
- [ ] **Search**: Input filters list, no-results state shown, clearing search restores full list
- [ ] **Filter**: Filter controls open, options populated, applying filters updates list, clearing filters restores list
- [ ] **Sort**: Column header click sorts, visual indicator shows direction, toggling reverses

### MCP-Assisted Implementation

Read `wave5-context.md § MCP Configuration` to determine which MCP tools are available and user-approved.

**Stitch MCP (for VISUAL model AIOUs):**
If Stitch MCP is available and the current AIOU is classified as VISUAL:
1. Use `enhance-prompt` skill to create an optimized Stitch prompt incorporating `DESIGN.md`
2. Generate the component screen in Stitch
3. Use `react-components` skill to transform Stitch output into production React code
4. Verify against `design-system.md` and ANTI-SLOP-RULES

**shadcn/ui MCP (for component-based AIOUs):**
If shadcn/ui MCP is available:
1. Search available components that match the AIOU requirements
2. Install needed components via MCP tools
3. Customize installed components to match `design-system.md` tokens
4. Verify no default styles leak through (check against ANTI-SLOP-RULES)

**Spline MCP (for AIOUs with 3D elements):**
If Spline MCP is available and the AIOU includes 3D elements:
1. Create/modify 3D scenes matching the component requirements
2. Configure materials using design system colors
3. Add animations matching the design system's motion language
4. Generate runtime code and integrate into the React component

### Visual QA Feedback Loop (MANDATORY)

**Every Wave 5 AIOU MUST complete a visual QA cycle before being marked done.** This is defined in `council-development.md § Visual QA Protocol`.

After implementation and tests pass:

1. **Render**: Start dev server or isolated preview. Navigate to the implemented component/page.
2. **Screenshot**: Capture at 3 breakpoints (375×812, 768×1024, 1920×1080) using:
   - Playwright MCP: `browser_navigate` → `browser_take_screenshot`
   - OR Browser Extension: `browser_navigate` → `browser.capture_screenshot_and_save`
   - OR if neither available: document manual visual inspection
3. **Compare**: Review against design system and AIOU visual requirements:
   - [ ] Typography matches design tokens
   - [ ] Colors use semantic tokens (no ad-hoc hex values)
   - [ ] Spacing and layout match spec
   - [ ] No ANTI-SLOP violations (banned fonts, purple gradients, generic layouts)
   - [ ] Component is visually distinctive (anti-convergence check)
   - [ ] Responsive behavior correct at all breakpoints
4. **Fix**: If issues found → fix → re-render → re-screenshot. Max 3 iterations.
5. **Document**: Save final screenshots to `visual-qa/AIOU-XXX/` directory.

**AIOU is NOT complete until Visual QA passes.** The AIOU completion artifact must include:
```markdown
### Visual QA
- Screenshots: visual-qa/AIOU-XXX/ ([count] files)
- Breakpoints verified: Mobile ✅ | Tablet ✅ | Desktop ✅
- Anti-slop check: PASS
- Design token compliance: PASS
- Iterations required: [1-3]
```

---

## Notes

- Wave 5 processes ONE AIOU at a time for proper model switching
- Model switches happen BETWEEN AIOUs, not during
- HYBRID AIOUs require two passes (two model switches)
- Always verify current AIOU complete before moving to next
- Dependencies must be satisfied before AIOU can start
- Use `--skip` if AIOU is blocked and needs manual resolution
