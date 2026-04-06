---
name: sdlc-dev-ui-verify
description: |
  Verify UI wiring completeness — navigation, interactive elements, states, visual consistency, responsive design. Runs after Wave 5, before Wave 6.
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
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/frontend-design/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


# /dev-ui-verify - UI Wiring & Completeness Verification

## Purpose

Systematically verify that the implemented frontend is complete, fully wired, and functional — not just rendering without errors. This phase catches broken navigation, unwired buttons, missing forms, incomplete states, and visual inconsistencies BEFORE integration testing.

**Core Principle**: "Rendering is not functioning." — A button that appears on screen but does nothing is a defect. This verification catches what visual screenshots cannot.

---

## Lens / Skills / Model
**Lens**: `[UX]` + `[Quality]` | **Model**: Claude Opus 4
> Apply RARV cycle, session protocol per `council-development.md`

## Prerequisites

- Wave 5 complete for current run (all Wave 5 AIOUs implemented)
- `.ultimate-sdlc/council-state/development/ui-design-plan.md` exists
- `design-system.md` exists

If prerequisites not met:
```
UI Verification requires Wave 5 to be complete for the current run.
Complete all Wave 5 AIOUs first, then run /dev-ui-verify.
```

---

## Workflow

### Step 1: Load Verification Inputs

1. Read `.ultimate-sdlc/council-state/development/ui-design-plan.md` — the source of truth for:
   - Page inventory (what pages should exist)
   - Navigation architecture (what routes and links should work)
   - Interactive element inventory (what buttons, forms, modals should function)
   - Data-loading components (what states should exist)

2. Read `design-system.md` — the source of truth for:
   - Color values (to check for hardcoded colors)
   - Font families (to check for banned fonts)
   - Spacing values (to check for ad-hoc spacing)

3. Read `.ultimate-sdlc/council-state/development/run-tracker.md` — identify which features/AIOUs are in the current run's scope.

4. **Scope determination**: If this is a per-run verification, verify ONLY the pages and elements from the current run's features. If this is a global verification (after all runs), verify EVERYTHING.

### Step 2: Navigation Verification

For each route in the design plan's navigation architecture that is in scope:

**2a. Route Existence (ALL routes, including sub-pages)**
```
For EVERY route in the Route Tree (not just top-level — every sub-page, tab, wizard step):
- [ ] Route is declared in the router configuration (search for route path in code)
- [ ] Route's page component exists (the file imported by the route)
- [ ] Page component renders its OWN content (not an empty return, not a placeholder, not just the parent's shell)
- [ ] If container page: sub-navigation exists and renders child routes
- [ ] If wizard step: step content exists with its documented fields and validation
```

**Method**: Search the router/routes file for EVERY route path from the Route Tree. Follow the import to the page component file. Verify the component has MEANINGFUL, UNIQUE render content — not just `<div/>`, `return null`, `<Outlet/>` with no content, "Coming soon", or a redirect to the parent.

**Depth-specific checks**:
- For tab-based pages: verify each tab renders a different component with real content
- For wizard steps: verify each step has its own form fields, not just a step number
- For detail pages (/items/:id): verify the component fetches and displays item-specific data
- For edit pages (/items/:id/edit): verify the form is pre-populated and submits updates

**2b. Navigation Element Wiring**
```
For each entry in the Navigation Map:
- [ ] Source page contains the described element (search for link/button text or route reference)
- [ ] Element navigates to the correct destination (verify the href/to prop or onClick handler)
- [ ] Destination page renders correctly (verified in 2a above)
```

**Method**: On each source page, search for the navigation element. Verify its link target or navigation handler points to the documented destination route.

**2c. Dead Link Detection**
```
- [ ] Search ALL components for <Link>, <a>, router.push, navigate() calls
- [ ] For each: verify the target route exists in the router configuration
- [ ] Flag any route references that don't match a declared route
```

**Method**: Grep for navigation patterns across all frontend files. Cross-reference each target route against the router config.

**2d. Authentication Flow**
```
- [ ] Protected routes redirect unauthenticated users (verify auth guard/middleware)
- [ ] Login success redirects to the documented destination
- [ ] Logout redirects to the documented destination
```

**Record findings** in the verification report (Step 7).

### Step 2.5: Page Depth Verification

**This step catches the most common agent failure: implementing top-level pages but skipping sub-pages.**

Using the Route Tree from `ui-design-plan.md`, identify all container pages (pages with children):

```
For each container page in the Route Tree:
- [ ] Container page has sub-navigation rendered (tabs, sidebar, wizard stepper)
- [ ] Sub-navigation contains ALL child routes listed in the Route Tree
- [ ] EACH child route renders its own unique content (not the parent's shell, not blank, not placeholder)
- [ ] Default child loads when visiting the container route (e.g., /settings loads /settings/account)
```

**For wizard/multi-step flows:**
```
For each wizard flow in the design plan:
- [ ] ALL steps exist as routes and render content
- [ ] Each step has its documented form fields (not empty forms)
- [ ] Next/Back navigation between steps works
- [ ] Progress indicator shows correct step
- [ ] Final step performs the documented completion action
- [ ] Cancel/abandon behavior works as documented
```

**For list/detail patterns:**
```
For each list page that links to detail pages:
- [ ] List page renders with data
- [ ] Clicking a list item navigates to the detail page
- [ ] Detail page renders item-specific content (not a blank template)
- [ ] Edit page (if exists) has pre-populated form
- [ ] Create page (if exists) has empty form that submits
- [ ] Back navigation from detail returns to list
```

**Depth verification summary:**
```
Container pages in Route Tree: [X]
Container pages with all children implemented: [X]
Wizard flows in design plan: [X]
Wizard flows with all steps implemented: [X]
List/Detail patterns: [X]
List/Detail patterns fully connected: [X]
```

**Any container page with missing children = CRITICAL issue.** Fix before proceeding.

### Step 2.7: Feature Interaction Flow Verification

**This step catches the second most common agent failure: rendering interactive elements that do nothing when clicked.**

Using the Feature Interaction Maps from `ui-design-plan.md`, verify that EVERY mapped interaction is fully implemented through all 4 layers (Render → Trigger → Response → Completion):

```
For each feature's Interaction Map:
  For each interaction in the map:
    - [ ] RENDER: The trigger element exists on the correct page (button, menu, link, icon)
    - [ ] TRIGGER: The element has a handler attached (onClick, onSubmit, onChange)
    - [ ] RESPONSE: The handler produces the documented effect:
          - If "Opens modal": modal component exists and renders with documented content
          - If "Opens dropdown menu": menu component exists with ALL documented menu items
          - If "Navigates to page": navigation target exists and renders
          - If "Submits form": API call is made with correct endpoint and payload
          - If "Opens confirmation dialog": dialog component exists with confirm/cancel actions
    - [ ] COMPLETION: The flow resolves end-to-end:
          - Success: documented success behavior occurs (toast, redirect, list refresh, modal close)
          - Error: documented error behavior occurs (error message, field highlighting, retry option)
          - Cancel: documented cancel behavior occurs (close without changes, return to previous state)
```

**CRUD Completeness Verification:**
```
For each entity in the CRUD Completeness Matrix:
- [ ] CREATE: Trigger works → form/modal opens → all fields present → validation works → submit calls API → success shows → entity appears in list
- [ ] READ LIST: Page loads → data fetches → table/list populated → loading state during fetch → empty state when no data
- [ ] READ DETAIL: Row/card click → navigates to detail → all entity info displayed → actions available
- [ ] UPDATE: Edit trigger works → form opens pre-populated → changes save → success shown → data refreshes
- [ ] DELETE: Delete trigger works → confirmation shows → confirm deletes → entity removed → success shown
- [ ] SEARCH: Type → results filter → no-results shown when empty → clear restores list
- [ ] FILTER: Open → options present → apply updates list → clear restores list → active indicator shows
- [ ] SORT: Column click → sorts → indicator shows direction → toggle reverses
```

**Actions Menu / Context Menu Verification:**
```
For each actions menu or context menu in the application:
- [ ] Trigger (three dots, right-click, etc.) opens the menu
- [ ] ALL documented menu items are present with correct labels
- [ ] Each menu item has a click handler
- [ ] Clicking each menu item performs its documented action (not just closes the menu)
- [ ] Menu closes after item selection
- [ ] Menu closes on click outside / ESC key
```

**Interaction flow summary:**
```
Features verified: [X]
Total interactions in maps: [X]
Interactions fully implemented (all 4 layers): [X]
Interactions partially implemented (render only): [X] ← these are CRITICAL defects
Interactions missing entirely: [X] ← these are CRITICAL defects
CRUD entities: [X] | Fully complete: [X] | Missing operations: [X]
Actions menus: [X] | All items functional: [X] | Non-functional items: [X]
```

**Any interaction that has Render (layer 1) but not Trigger+Response+Completion (layers 2-4) = CRITICAL issue.** This is the "button that does nothing" defect. Fix before proceeding.

### Step 3: Interactive Element Verification

For each interactive element in the design plan's inventory that is in scope:

**3a. Button Wiring**
```
For each button in the inventory:
- [ ] Button element exists in the documented page's component
- [ ] Button has an onClick/onPress handler attached
- [ ] Handler function is defined (not just declared — it contains logic)
- [ ] Handler performs the documented action:
      - If action is "opens modal": verify modal component exists and handler sets its open state
      - If action is "submits form": verify form submission logic
      - If action is "calls API": verify API call is made
      - If action is "navigates": verify navigation target (covered in Step 2)
      - If action is "deletes/modifies data": verify API call + state update
```

**Method**: For each button, search the page component for the button element. Check its handler prop. Find the handler function definition. Read the function body to verify it performs the documented action.

**3b. Form Verification**
```
For each form in the inventory:
- [ ] Form element exists on the documented page
- [ ] All documented fields are present with correct input types
- [ ] Required fields have required attribute or validation rule
- [ ] Validation rules from inventory are implemented:
      - Email format validation (if documented)
      - Min/max length (if documented)
      - Pattern matching (if documented)
      - Custom validation (if documented)
- [ ] Form has an onSubmit handler
- [ ] Submit handler calls the documented API endpoint
- [ ] Success state is implemented (redirect, toast, confirmation message)
- [ ] Error state is implemented (error message display, field-level errors)
- [ ] Submit button shows loading state during submission
- [ ] Double-submit is prevented (button disabled during submission)
```

**Method**: Read each form component. Verify field presence, validation schema, submit handler, success/error handling.

**3c. Modal Verification**
```
For each modal in the inventory:
- [ ] Modal component exists
- [ ] Trigger element opens the modal (verify state toggle)
- [ ] Modal renders its documented content
- [ ] Primary action button is wired (if documented)
- [ ] Close methods work:
      - X button closes modal (if documented)
      - ESC key closes modal (if documented)
      - Backdrop click closes modal (if documented)
      - Cancel button closes modal (if documented)
```

**Method**: Find modal component. Trace trigger element to modal open state. Verify close handlers exist for each documented method.

**3d. Dropdown/Select/Filter Verification**
```
For each dropdown, select, or filter control:
- [ ] Element exists on the documented page
- [ ] Options are populated (static or from data source)
- [ ] On-change handler exists and performs the documented effect
- [ ] Default value matches documentation
```

### Step 4: State Completeness Verification

For each data-loading component in the inventory that is in scope:

```
- [ ] Loading state: Component shows a loading indicator (spinner, skeleton, progress bar)
      when data is being fetched. Search for conditional rendering based on loading state.

- [ ] Empty state: Component shows an empty state message (and optional CTA) when the
      data source returns empty/no results. Search for conditional rendering when data
      array is empty or null.

- [ ] Error state: Component shows an error message (and optional retry button) when the
      data fetch fails. Search for error handling in the data fetch (try/catch, .catch(),
      onError callback).
```

**Method**: For each component, search for the data-fetching logic. Verify three conditional branches exist: loading (data is being fetched), empty (data returned but empty), error (fetch failed).

**Quick check**: Search for patterns like:
- `isLoading`, `loading`, `isPending` → loading state exists
- `data?.length === 0`, `!data`, `isEmpty` → empty state exists
- `isError`, `error`, `catch` → error state exists

### Step 5: Visual Consistency Verification

**5a. Hardcoded Color Detection**
```
Search all frontend component files for hardcoded color values:
- Hex colors (#XXX, #XXXXXX) that are NOT in the design system
- RGB/RGBA values not from the design system
- HSL/HSLA values not from the design system

Exclude: design-system.md itself, tailwind.config, CSS variable definitions, third-party libraries
```

**Method**: Grep for hex color patterns in component files. Cross-reference against design-system.md values. Flag any that don't match.

**5b. Banned Font Detection**
```
Search all frontend files for banned fonts:
- "Inter" (as font-family, not as variable name)
- "Arial"
- "Roboto"
- "system-ui"
- "sans-serif" as the ONLY fallback (generic sans-serif at end of stack is OK)
```

**Method**: Grep for font-family declarations and className patterns containing banned font names.

**5c. Design Token Usage**
```
- [ ] Colors in components reference design tokens/CSS variables (not raw values)
- [ ] Font sizes reference the typography scale (not arbitrary pixel values)
- [ ] Spacing references the spacing system (not arbitrary margins/paddings)
```

**Method**: Sample 5-10 components across different pages. Check that style values reference tokens rather than literals.

### Step 6: Responsive Verification

**6a. Breakpoint Coverage**
```
For each page in scope:
- [ ] Page has responsive styles for mobile (<768px)
- [ ] Page has responsive styles for tablet (768-1023px)
- [ ] Page has responsive styles for desktop (≥1024px)
```

**Method**: If Playwright MCP is available: navigate to each page and screenshot at 375px, 768px, and 1920px width. Review screenshots for layout issues.

If no screenshot tool: search each page component for responsive classes (sm:, md:, lg: in Tailwind) or media queries.

**6b. Navigation Mobile Transform**
```
- [ ] Primary navigation has a mobile version (hamburger, drawer, or bottom tabs)
- [ ] Mobile navigation opens and closes correctly
- [ ] Mobile navigation contains all primary nav items
```

**6c. Content Overflow**
```
- [ ] No horizontal scrollbar at any viewport width (check for overflow-x issues)
- [ ] All text is readable at mobile sizes (no text smaller than 14px on mobile)
- [ ] Touch targets are adequate (minimum 44x44px for interactive elements on mobile)
```

### Step 7: Generate Verification Report

Save to `.ultimate-sdlc/council-state/development/ui-verify-run-[N].md` (or `ui-verify-global.md` for global verification):

```markdown
# UI Wiring Verification Report — [Run N / Global]

**Date**: [ISO 8601]
**Scope**: [Run N features / All features]
**Verified by**: [model]

## Navigation Verification
- Total routes in Route Tree: [X] | Exist & render: [X] | Missing/broken: [X]
- Top-level routes: [X]/[X] | Sub-page routes: [X]/[X] | Wizard step routes: [X]/[X]
- Nav elements checked: [X] | Correctly wired: [X] | Broken: [X]
- Dead links found: [X]
- Auth flow verified: YES/NO

## Page Depth Verification
- Container pages: [X] | All children implemented: [X] | Missing children: [X]
- Wizard flows: [X] | All steps implemented: [X] | Incomplete: [X]
- List/Detail patterns: [X] | Fully connected: [X] | Missing: [X]
- Sub-pages with real content (not placeholder): [X]/[X]

## Feature Interaction Flow Verification
- Features verified: [X] | Total interactions mapped: [X]
- Interactions fully implemented (all 4 layers): [X]
- Interactions render-only (visible but non-functional): [X] ← CRITICAL if >0
- Interactions missing entirely: [X] ← CRITICAL if >0
- CRUD entities: [X] | All operations complete: [X] | Missing operations: [X]
- Actions/Context menus: [X] | All items functional: [X] | Non-functional items: [X]

## Interactive Element Verification
- Buttons checked: [X] | Fully wired: [X] | Unwired/broken: [X]
- Forms checked: [X] | Fully functional: [X] | Issues: [X]
- Modals checked: [X] | Working: [X] | Issues: [X]
- Dropdowns/Filters checked: [X] | Working: [X] | Issues: [X]

## State Completeness
- Data components checked: [X]
- With loading state: [X] | Missing: [X]
- With empty state: [X] | Missing: [X]
- With error state: [X] | Missing: [X]

## Visual Consistency
- Hardcoded colors found: [X]
- Banned fonts found: [X]
- Token compliance (sampled): [X]/[X] components compliant

## Responsive
- Pages verified: [X]
- All breakpoints pass: [X] | Issues: [X]
- Mobile nav works: YES/NO

## Issues Found

| # | Category | Page | Element | Issue | Severity |
|---|----------|------|---------|-------|----------|
[List every issue found — severity: CRITICAL (blocks), HIGH (fix before Wave 6), MEDIUM (fix before I8)]

## Issue Summary
- CRITICAL: [X] (must fix before proceeding)
- HIGH: [X] (must fix before Wave 6)
- MEDIUM: [X] (must fix before Gate I8)

## Verdict: PASS / FAIL
[PASS only if 0 CRITICAL and 0 HIGH issues remain]
```

### Step 8: Fix Issues (if FAIL)

If verification fails:

1. Fix all CRITICAL issues first (routes that don't exist, pages that don't render)
2. Fix all HIGH issues (unwired buttons, broken forms, missing states)
3. Re-run the relevant verification steps (not the full verification — just the categories that had issues)
4. Update the verification report with fix evidence
5. Re-assess verdict

**Maximum iterations**: 3. If issues persist after 3 fix attempts, document in WORKING-MEMORY.md and flag for user attention.

### Step 9: Update State

**If PASS:**
1. Update `.ultimate-sdlc/council-state/development/run-tracker.md`:
   - Set UI-V status to ✅ for current run
2. Announce:
   ```
   ## UI Verification PASSED — Run [N]
   All navigation, interactive elements, states, and visual consistency verified.
   Proceed to /dev-wave-6 for integration.
   ```

**If FAIL after max iterations:**
1. Document unresolved issues in WORKING-MEMORY.md
2. Announce:
   ```
   ## UI Verification FAILED — Run [N]
   [X] issues remain unresolved after 3 fix attempts.
   Review .ultimate-sdlc/council-state/development/ui-verify-run-[N].md for details.
   User intervention needed before proceeding to Wave 6.
   ```

---

## Completion Condition

PASS when ALL of the following are true:
- 0 CRITICAL issues (missing routes, non-rendering pages)
- 0 HIGH issues (unwired buttons, broken forms, missing loading/empty/error states)
- Verification report exists with PASS verdict
- Run tracker updated with UI-V status

**Efficiency note**: This verification is rigorous but scoped. It checks the DESIGN PLAN against the CODE. If the design plan says a button does X, verify the button does X. Don't invent new requirements — verify what was planned.

---

## Agent Invocations

### Agent: integration-tester
Invoke via Agent tool with `subagent_type: "sdlc-integration-tester"`:
- **Provide**: UI design plan (routes, navigation map, interactive elements, feature interaction maps), implemented frontend code
- **Request**: Verify UI wiring completeness — check every route exists and renders, every navigation element links correctly, every interactive element has a functional handler, every CRUD operation works end-to-end
- **Apply**: Integrate wiring verification results into the verification report

### Agent: ux
Invoke via Agent tool with `subagent_type: "sdlc-ux"`:
- **Provide**: Verification report, design system, responsive behavior specs
- **Request**: Perform final UX check — verify visual consistency (no hardcoded colors, no banned fonts, design tokens used), responsive behavior at all breakpoints, and state completeness (loading, empty, error states)
- **Apply**: Incorporate UX findings into the verification report; flag remaining issues by severity

---
