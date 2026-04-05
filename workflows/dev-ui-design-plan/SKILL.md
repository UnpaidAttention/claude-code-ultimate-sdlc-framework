---
name: dev-ui-design-plan
description: |
  Create comprehensive UI design plan with page layouts, navigation architecture, and interactive element inventory before frontend implementation.
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


# /dev-ui-design-plan - UI Design Planning Phase

## Purpose

Translate design research into a concrete, actionable design plan that the agent implements against during Wave 5. This plan defines every page layout, the complete navigation architecture, and every interactive element — BEFORE any frontend code is written.

**Core Principle**: "Plan the UI as rigorously as the database schema." — Every page, route, button, and form is specified before implementation.

---

## Lens / Skills / Model
**Lens**: `[UX]` + `[Quality]` | **Model**: claude-opus-4-6
> Apply RARV cycle, session protocol per `council-development.md`

## Prerequisites

- `.antigravity/council-state/development/ui-design-research.md` exists (UI-R phase complete)
- `handoffs/planning-handoff.md` with Design Direction
- All `specs/features/FEAT-XXX.md` and `specs/deep-dives/DIVE-XXX.md` available
- At least one run has passed Gate I4

If prerequisites not met:
```
UI Design Plan requires UI Research to be complete.
Run /dev-ui-research first.
```

---

## Workflow

### Step 1: Load Inputs

1. Read `.antigravity/council-state/development/ui-design-research.md` (research findings)
2. Read `handoffs/planning-handoff.md` Section 4 (Design Direction)
3. Read ALL `specs/features/FEAT-XXX.md` — extract user-facing pages/views
4. Read ALL `specs/deep-dives/DIVE-XXX.md` — extract component inventories, user journeys
5. If `design-system.md` exists: read it. Otherwise: create it in Step 2.

### Step 2: Design System Definition

**If `design-system.md` already exists** (from prior UI-P execution, a previous cycle, or preserved by `--keep-design-system` redesign), refine it based on research findings from UI-R phase. Ensure it contains all sections below.

**If no `design-system.md` exists**, create it now.

**Required sections** (all values must be specific — no TBD, no placeholders):

**Color Palette:**
- Primary color with hover, active, light, and dark variants
- Secondary color with variants
- Accent color
- Semantic colors: success, warning, error, info (each with background and text variants)
- Neutral scale: background, surface, elevated surface, border, divider, text-primary, text-secondary, text-muted, text-disabled

**Typography:**
- Display font: name, weights, usage contexts
- Body font: name, weights, usage contexts
- Mono font: name, usage contexts
- Size scale: minimum 8 steps (xs through 4xl) with pixel values, line heights, and usage notes
- MUST NOT use banned fonts: Inter, Arial, Roboto, system-ui, sans-serif as primary

**Spacing:**
- Base unit and scale (minimum 6 steps: xs through 2xl) with pixel values
- Component padding standards (buttons, inputs, cards, sections)
- Section spacing standards (between page sections, between components)

**Borders & Shadows:**
- Border radius scale (minimum 4 values)
- Shadow scale (minimum 3 levels)
- Border color and width standards

**Component Standards:**
- Buttons: styles per variant (primary, secondary, ghost, destructive), sizes (sm, md, lg), states (default, hover, active, disabled, loading)
- Inputs: default, focus, error, disabled states
- Cards: padding, border treatment, hover behavior
- Navigation elements: active, hover, mobile behavior

**Verification**: Every color is a specific value (hex, HSL, or OKLCH). Every font is a specific named font. Every spacing value is a specific pixel value. No "TBD" or "to be determined."

### Step 3: Page-by-Page Layout Plan

For **EVERY** page/view in the application, create a layout specification:

**CRITICAL: Recursive Decomposition Required.** Do NOT plan only top-level pages. Every page that contains sub-pages, tabs, wizard steps, or nested routes must have ALL of its children planned as separate entries. Plan to LEAF level — the level where there are no further sub-pages.

**Step 3a: Build the Hierarchical Route Tree**

Before writing page layouts, build the complete route tree showing parent/child relationships:

```markdown
# Route Tree

/                           ← Landing/Home
├── /login                  ← Login page
├── /register               ← Registration (or wizard: /register/step-1, /step-2, /step-3)
│   ├── /register/step-1    ← Account info
│   ├── /register/step-2    ← Profile setup
│   └── /register/step-3    ← Confirmation
├── /dashboard              ← Main dashboard
├── /settings               ← Settings shell (contains tabs/sub-routes)
│   ├── /settings/account   ← Account settings
│   ├── /settings/notifications ← Notification preferences
│   ├── /settings/billing   ← Billing & payments
│   └── /settings/security  ← Security settings
├── /projects               ← Project list
│   ├── /projects/:id       ← Project detail
│   ├── /projects/:id/edit  ← Project edit
│   └── /projects/new       ← Create project (or wizard)
└── /404                    ← Not found
```

**How to build this tree:**
1. Start with feature specs — each feature implies pages
2. For each page: does it have tabs, sub-sections, or nested content? → those are child routes
3. For each form: is it multi-step? → each step is a child route (wizard)
4. For each list/detail pattern: the list page AND the detail page AND any edit/create pages are ALL separate routes
5. Continue recursively until every route is a leaf (no further children)

**Leaf test**: A route is a leaf if it has NO tabs, NO sub-navigation, NO wizard steps, and NO nested routes. If it has any of these, decompose further.

**Step 3b: Page Layout Specifications (for EVERY leaf and container page)**

For **EVERY** route in the tree — both container pages (that hold sub-routes) AND leaf pages — create a layout specification:

```markdown
## [Page Name]
**Route**: /path/to/page
**Depth**: [top-level / sub-page / wizard-step / tab-content]
**Parent page**: [parent route, or "none" if top-level]
**Children**: [list child routes, or "leaf" if none]
**Purpose**: [one sentence]
**Auth required**: yes/no
**Parent feature**: FEAT-XXX

### Layout Structure
[Describe the layout: which content zones exist, how they're arranged, column structure.
Reference the design research findings that informed this layout choice.]

### Content Zones
1. **[Zone name]** — [position in layout]
   - Content: [what goes here]
   - Visual weight: [primary/secondary/tertiary]
   - Components: [list specific components]

2. **[Zone name]** — [position]
   - Content: [what goes here]
   - Components: [list]

### Sub-Navigation (if this page has children)
- **Type**: [tabs / sidebar-sub-nav / wizard-steps / accordion / none]
- **Items**: [ordered list of child routes with labels]
- **Default**: [which child loads by default when parent route is visited]
- **Active indicator**: [how user knows which sub-page they're on]

### Visual Hierarchy
[What is the most important element on this page? Second? How is the user's eye guided?]

### Responsive Behavior
- **Desktop (≥1024px)**: [layout]
- **Tablet (768-1023px)**: [changes]
- **Mobile (<768px)**: [changes]
```

**Completion check**: Count page specifications. Must equal TOTAL route count from the Route Tree (both container and leaf pages). NOT just top-level pages — every route in the tree must have a layout spec.

**Step 3c: Wizard and Multi-Step Flow Inventory**

For every multi-step flow in the application (registration wizards, onboarding flows, creation wizards, checkout processes, setup flows):

```markdown
# Wizard / Multi-Step Flows

## [Flow Name] — [Parent Feature]
**Entry point**: [route or trigger that starts this flow]
**Total steps**: [N]
**Can user skip steps?**: yes/no
**Can user go back?**: yes/no
**Progress indicator**: [stepper / progress bar / step count / none]
**Abandon behavior**: [what happens if user leaves mid-flow — data saved? lost? prompt?]

### Steps
| # | Step Name | Route | Content | Required Fields | Validation | Next Condition |
|---|-----------|-------|---------|----------------|------------|---------------|
| 1 | [name] | [route] | [what user sees/does] | [fields] | [rules] | [what must be valid to proceed] |
| 2 | [name] | [route] | [content] | [fields] | [rules] | [condition] |
| ... | | | | | | |
| N | [name] | [route] | [confirmation/summary] | — | — | [submit/complete action] |

### Flow Completion
- **Success action**: [what happens — redirect, toast, email, etc.]
- **Error handling**: [what if submission fails at the final step]
- **Data persistence**: [is data saved per-step or only on final submit?]
```

**Completion check**: Every multi-step form identified in the interactive element inventory must have a corresponding wizard flow entry. Every wizard step must appear as a route in the Route Tree.

### Step 4: Navigation Architecture

Create the complete navigation map using the Route Tree from Step 3a as the source of truth:

```markdown
# Navigation Architecture

## Route Tree Reference
[Copy the complete Route Tree from Step 3a here — this is the canonical list of ALL routes]

## Total Route Count: [N] (must match page layout spec count from Step 3b)

## Primary Navigation Structure
- **Type**: [sidebar / top-nav / tabs / bottom-tabs / other]
- **Position**: [left sidebar / top / bottom]
- **Behavior**: [fixed / sticky / scrolls away]
- **Mobile transform**: [hamburger menu / drawer / bottom tabs]

### Primary Nav Items (in order)
| # | Label | Icon | Route | Badge/Count |
|---|-------|------|-------|-------------|
[List every primary nav item — these are top-level routes only]

## Sub-Navigation Map

For every page that has children (container pages from Route Tree):

| Container Page | Sub-Nav Type | Items | Default Child | Active Indicator |
|---------------|-------------|-------|--------------|-----------------|
| /settings | tabs | Account, Notifications, Billing, Security | /settings/account | active tab highlight |
| /projects/:id | sidebar | Overview, Tasks, Files, Settings | /projects/:id (overview) | bold + indicator |
[List EVERY container page with its sub-navigation]

## Wizard Flow Navigation

For every wizard/multi-step flow:

| Flow | Step Navigation | Back Allowed | Progress Indicator | Cancel Destination |
|------|----------------|-------------|-------------------|-------------------|
| Registration | stepper: Step 1 → 2 → 3 | yes (to previous step) | 3-step stepper | /login |
[List EVERY wizard flow]

## Complete Navigation Map

Every clickable element that navigates, across ALL pages (including sub-pages):

| Source Page | Element | Element Type | Destination | Condition |
|------------|---------|-------------|-------------|-----------|
[List EVERY navigation action in the entire application — including sub-page-to-sub-page navigation]

Element types: nav-item, link, button, card-click, breadcrumb, tab, wizard-next, wizard-back, logo, back-button

## Authentication Flow
- Unauthenticated → protected route: redirect to [route]
- After login: redirect to [route or original destination]
- After logout: redirect to [route]
- Session expiry: [behavior]

## 404 / Not Found
- Route: [/404 or catch-all]
- Content: [what the 404 page shows]
- Navigation: [how users get back to valid pages]
```

**Completion check**:
- Route count in navigation architecture = route count in Route Tree = page layout spec count from Step 3b
- Every container page has a Sub-Navigation Map entry
- Every wizard flow has navigation details
- Every sub-page is reachable (appears as a destination in the Complete Navigation Map)

### Step 5: Feature Interaction Maps (CRITICAL — This Is What Prevents Incomplete UIs)

**Why this step exists**: The most common UI failure is building the visual surface of a page (table, buttons, icons) without building what happens when the user interacts with each element. An "Add Tenant" button that renders on screen but does nothing when clicked, or a three-dots actions menu that appears but has no dropdown — these are the result of planning elements without planning their complete interaction flows.

For **EVERY feature** in the application, create a complete interaction map that traces EVERY user action the feature supports, from trigger through to completion:

```markdown
# Feature Interaction Maps

## Feature: [FEAT-XXX — Feature Name]

### Interaction 1: [Action Name] (e.g., "Create Tenant")
- **Trigger**: [What the user clicks/taps — be specific: "Add Tenant button, top-right of /tenants page"]
- **Opens**: [What appears — modal, new page, drawer, inline form, dropdown]
- **Contains**: [Every element in what opens — form fields, buttons, dropdowns, text]
- **Fields** (if form):
  | Field | Type | Required | Validation | Placeholder |
  |-------|------|----------|------------|-------------|
  | [name] | [text/email/select/etc.] | [yes/no] | [rules] | [hint text] |
- **Submit action**: [API endpoint, method, payload shape]
- **Success flow**: [What the user sees — toast, redirect, list refreshes, modal closes — in order]
- **Error flow**: [What the user sees — inline errors, toast, field highlighting — in order]
- **Cancel/Close flow**: [What happens — discard changes, confirm abandon, return to previous state]

### Interaction 2: [Action Name] (e.g., "View Tenant Details")
- **Trigger**: [Click on tenant row in table]
- **Opens**: [/tenants/:id detail page]
- **Shows**: [List every piece of information displayed — name, domain, status, plan, created date, admin email, usage stats]
- **Actions available from here**: [Edit button, Delete button, Deactivate toggle, Back to list]
- **Each action leads to**: [Reference other interaction numbers — "Edit → Interaction 3", "Delete → Interaction 5"]

### Interaction 3: [Action Name] (e.g., "Edit Tenant")
- **Trigger**: ["Edit" button on detail page OR "Edit" from actions menu on list]
- **Opens**: [Edit form — pre-populated with current values]
- **Fields**: [Same as create, but pre-filled — note any fields that are read-only during edit]
- **Submit action**: [PUT /api/tenants/:id]
- **Success flow**: [Show updated data, toast "Tenant updated"]
- **Error flow**: [Validation errors, API errors]

### Interaction 4: [Action Name] (e.g., "Actions Menu")
- **Trigger**: [Click three-dots icon on tenant row]
- **Opens**: [Dropdown menu]
- **Menu Items**:
  | Item | Icon | Action | Leads To |
  |------|------|--------|----------|
  | View Details | eye | Navigate to /tenants/:id | Interaction 2 |
  | Edit | pencil | Open edit form | Interaction 3 |
  | Deactivate | pause | Open confirmation dialog | Interaction 6 |
  | Delete | trash | Open delete confirmation | Interaction 5 |
- **Close behavior**: [Click outside closes menu, ESC closes menu]

### Interaction 5: [Action Name] (e.g., "Delete Tenant")
- **Trigger**: ["Delete" from actions menu or detail page]
- **Opens**: [Confirmation dialog]
- **Dialog content**: ["Are you sure you want to delete [tenant name]? This action cannot be undone."]
- **Confirm action**: [DELETE /api/tenants/:id]
- **Success flow**: [Close dialog, remove from list, toast "Tenant deleted"]
- **Error flow**: [Show error in dialog, keep dialog open]
- **Cancel**: [Close dialog, no change]

### Interaction 6: [Action Name] (e.g., "Filter Tenants")
- **Trigger**: [Click "Filter" button on list page]
- **Opens**: [Filter panel/popover]
- **Filter Options**:
  | Filter | Type | Options | Default |
  |--------|------|---------|---------|
  | Status | select | All, Active, Inactive | All |
  | Plan | select | All, Free, Pro, Enterprise | All |
  | Date Range | date-range | From/To date pickers | None |
- **Apply behavior**: [Table updates immediately on filter change / "Apply" button required]
- **Clear behavior**: ["Clear All" resets all filters, table shows all items]
- **Active filter indicator**: [Badge on Filter button showing count of active filters]

### Interaction 7: [Action Name] (e.g., "Search Tenants")
- **Trigger**: [Type in search input]
- **Behavior**: [Debounced (300ms), searches name and domain columns]
- **Results**: [Table updates to show matching rows]
- **No results**: ["No tenants match your search" message in table body]
- **Clear**: [X button in search field, clears search and shows all items]

### Interaction 8: [Action Name] (e.g., "Sort Tenants")
- **Trigger**: [Click column header in table]
- **Behavior**: [Toggle ascending → descending → none]
- **Sortable columns**: [Name, Status, Created Date, Plan]
- **Visual indicator**: [Arrow icon in column header showing sort direction]
```

**Repeat for EVERY feature.** Every feature should have 5-15 interactions mapped. If a feature has fewer than 3 interactions, it's likely incomplete — review the feature spec for missing capabilities.

### CRUD Completeness Matrix

For every data entity in the application (every "thing" the user manages — tenants, users, projects, tasks, invoices, etc.), verify the full lifecycle is planned:

```markdown
# CRUD Completeness Matrix

| Entity | Create | Read (List) | Read (Detail) | Update | Delete | Search | Filter | Sort | Bulk Actions |
|--------|--------|-------------|---------------|--------|--------|--------|--------|------|-------------|
| Tenant | Modal form (Int. 1) | /tenants table (Int. 7,8) | /tenants/:id (Int. 2) | Edit form (Int. 3) | Confirm dialog (Int. 5) | Search bar (Int. 7) | Filter panel (Int. 6) | Column headers (Int. 8) | N/A |
| User | ... | ... | ... | ... | ... | ... | ... | ... | ... |
```

**Every cell must reference a specific interaction number from the Feature Interaction Maps.** Empty cells = missing functionality. Every entity MUST have at minimum: Create + Read List + Read Detail + Update + Delete.

**If a cell is intentionally empty** (e.g., entity cannot be deleted by design), mark it as "N/A — [reason]" (not just blank).

### Step 5b: Interactive Element Inventory

Catalog EVERY interactive element in the application. **Every element MUST reference a Feature Interaction Map interaction that fully specifies what happens when the user interacts with it.**

```markdown
# Interactive Element Inventory

## Buttons (non-navigation)
| # | Page | Label | Variant | Interaction Ref | Handler Name | Success Behavior | Error Behavior |
|---|------|-------|---------|----------------|-------------|-----------------|----------------|
[List every button — each MUST have an Interaction Ref pointing to the Feature Interaction Map]

## Forms
| # | Page | Form Name | Interaction Ref | Fields | Validation Rules | Submit Endpoint | Success State | Error State |
|---|------|-----------|----------------|--------|-----------------|----------------|---------------|-------------|
[For each form, the Interaction Ref points to the interaction that fully specifies fields, validation, submit, and states]

### Form Field Details
For each form above, expand field details:

#### [Form Name] — [Page]
| Field | Type | Required | Validation | Error Message |
|-------|------|----------|------------|---------------|

## Modals / Dialogs
| # | Trigger Element | Modal Name | Interaction Ref | Content | Primary Action | Secondary Action | Close Methods |
|---|----------------|------------|----------------|---------|----------------|-----------------|---------------|
Close methods: X button, ESC key, backdrop click, cancel button

## Dropdowns / Select Controls
| # | Page | Element | Options Source | Default | On Change Effect |
|---|------|---------|---------------|---------|-----------------|

## Filters / Sort Controls
| # | Page | Element | Filter/Sort Options | Affects Component | Reset Behavior |
|---|------|---------|--------------------|--------------------|----------------|

## Data-Loading Components
| # | Page | Component | Data Source | Loading State | Empty State | Error State | Refresh Trigger |
|---|------|-----------|-------------|---------------|-------------|-------------|-----------------|

## Toggles / Switches
| # | Page | Element | Default | On Change Effect | Persists To |
|---|------|---------|---------|-----------------|-------------|
```

**Completion check**: Review each page's layout plan. Every component listed in the layout that is interactive must appear in this inventory. Cross-reference against deep-dive component inventories — every interactive component from deep-dives must be accounted for.

### Step 6: Compile Design Plan Document

Save as `.antigravity/council-state/development/ui-design-plan.md`:

```markdown
# UI Design Plan — [Project Name]

## Design System Reference
See: design-system.md

## Pages
[All page layout specifications from Step 3]

## Navigation Architecture
[Complete navigation map from Step 4]

## Interactive Element Inventory
[Complete inventory from Step 5]

## Verification Counts
- Total routes in Route Tree: [N]
- Page layout specs written: [N] (must equal route count)
- Top-level pages: [N] | Sub-pages: [N] | Wizard steps: [N]
- Container pages with sub-nav defined: [N]
- Wizard/multi-step flows documented: [N]
- Navigation elements mapped: [N]
- Buttons inventoried: [N]
- Forms inventoried: [N]
- Modals inventoried: [N]
- Data-loading components inventoried: [N]

## Depth Completeness Verification
- [ ] Every container page (has children in Route Tree) has sub-navigation defined
- [ ] Every wizard flow has all steps documented with routes
- [ ] Every sub-page has its own layout specification (not just the parent)
- [ ] No "TBD" or "see parent page" placeholders in sub-page specs
- [ ] Every leaf route renders its OWN content (not just the parent's shell)

## Feature Interaction Completeness
- [ ] Every feature has a Feature Interaction Map with ALL user actions traced trigger→completion
- [ ] Every data entity has a complete row in the CRUD Completeness Matrix (Create+Read List+Read Detail+Update+Delete minimum)
- [ ] Every interactive element in the inventory has an Interaction Ref pointing to a Feature Interaction Map entry
- [ ] Every actions menu / context menu has its menu items listed with what each item does
- [ ] Every button has a specified success flow AND error flow (not just "handles errors")
- [ ] Total feature interactions mapped: [N]
- [ ] Total CRUD entities verified complete: [N]
```

### Step 7: Design Plan Review Gate (HARD STOP)

**The agent MUST NOT proceed to Wave 5 implementation until this gate passes.**

Verification checklist:
- [ ] `design-system.md` exists with ALL required sections, no TBD values
- [ ] `.antigravity/council-state/development/ui-design-plan.md` exists
- [ ] `.antigravity/council-state/development/ui-design-research.md` exists
- [ ] Route Tree is built to leaf level (no container page without its children listed)
- [ ] Every route in the Route Tree has a page layout specification
- [ ] Every container page has sub-navigation defined (type, items, default child, active indicator)
- [ ] Every wizard/multi-step flow has all steps documented with routes and field details
- [ ] Every interactive component from deep-dives appears in the interactive element inventory
- [ ] Navigation map covers ALL navigation including sub-page-to-sub-page and wizard step transitions
- [ ] Every form lists its fields, validation rules, and submit behavior
- [ ] Every data-loading component specifies loading, empty, and error states
- [ ] **Depth check**: No sub-page spec says "see parent" or "TBD" — every page has its own complete layout
- [ ] **Feature Interaction Maps**: Every feature has a complete interaction map tracing every user action trigger→completion
- [ ] **CRUD Completeness**: Every data entity has Create + Read List + Read Detail + Update + Delete (or documented N/A)
- [ ] **Interaction References**: Every element in the inventory has an Interaction Ref to a fully specified flow
- [ ] **No orphan elements**: No button, menu item, or interactive component exists without a fully specified interaction flow
- [ ] **Every actions/context menu**: Has its menu items listed with specific actions and destinations for each item

**Count verification**:
```
Routes in Route Tree: [X]
Page layout specs:    [X] — must equal Route Tree count

Top-level pages:     [X]
Sub-pages/tabs:      [X]
Wizard steps:        [X]
Total:               [X] — must equal Route Tree count

Container pages in Route Tree: [X]
Container pages with sub-nav defined: [X] — must equal

Wizard flows identified: [X]
Wizard flows fully documented: [X] — must equal

Interactive components in deep-dives: [X]
Interactive elements in inventory:    [X] — must match or exceed

Features with interaction maps: [X]
Total interactions mapped:      [X] — expect 5-15 per feature
Data entities in CRUD matrix:   [X]
CRUD cells filled (not blank):  [X]/[total cells] — every cell must be filled or N/A
Inventory elements with Interaction Ref: [X]/[X] — must be 100%
```

If counts don't match: identify and add missing items before proceeding.

**Depth verification test**: Pick any container page from the Route Tree. Verify that:
1. Its layout spec lists its children
2. Each child has its own layout spec
3. Each child is reachable in the navigation map
4. Each child's interactive elements are in the inventory
If any fail: the plan is incomplete. Fix before proceeding.

**Adversarial review** (after checklist and counts pass):
Challenge the design plan before approving it:
1. **Navigation dead ends**: Is there any page a user can reach but not leave? Any page with no back-navigation path?
2. **Missing states**: For each form — what happens on network failure mid-submit? For each data component — what if the API returns unexpected data?
3. **Orphan elements**: Are there buttons in the inventory whose handlers depend on backend endpoints that don't exist in the API specs? Forms that submit to undefined endpoints?
4. **Responsive gaps**: Does every page's responsive plan actually work? Can a mobile user complete every task a desktop user can?
5. **Navigation consistency**: Can users always tell where they are? Is the active state behavior consistent across all pages?

If genuine gaps found: fix them in the design plan before proceeding. If concerns are speculative: note them in WORKING-MEMORY.md and proceed.

### Step 8: Update State

1. Update `.antigravity/council-state/development/run-tracker.md`:
   - Set `UI Design Phases > UI Design Plan` status to ✅ COMPLETE

2. Display:
```
## UI Design Plan Complete

**Design system**: Defined ([N] tokens)
**Pages planned**: [N]
**Routes mapped**: [N]
**Interactive elements inventoried**: [N] buttons, [N] forms, [N] modals, [N] data components

Design plan saved to: .antigravity/council-state/development/ui-design-plan.md

Next step: Continue to Wave 5 with /dev-wave5-start
The design plan will guide all frontend implementation.
```

---

## Completion Condition

ALL of the following must be true:
1. `design-system.md` has no placeholder values
2. `ui-design-plan.md` covers every page from feature specs
3. Navigation map covers every route
4. Interactive element inventory covers every interactive component from deep-dives
5. Count verification passes (design plan pages ≥ feature spec pages)

**Verification test**: The agent checks counts. If all counts match: PASS. If any count is short: identify and fix the gap.

---

## Feature-Scoped Re-Planning (After `/dev-ui-redesign --scope feature`)

If `ui-design-plan.md` already exists and contains `<!-- REDESIGN -->` markers:

1. **Detect**: Search `ui-design-plan.md` for `<!-- REDESIGN` markers
2. **Scope**: Only regenerate sections containing `<!-- REDESIGN -->` markers — leave all other sections intact
3. **Process**: For each marked section:
   - Read the corresponding FEAT spec and deep-dive
   - Regenerate the page layout, navigation entries, and interactive element inventory for that feature
   - Remove the `<!-- REDESIGN -->` marker
4. **Verify**: After regeneration, run Step 7 (Design Plan Review Gate) on the FULL plan to ensure consistency
5. **Update navigation map**: Ensure any new routes for the redesigned feature are added and any removed pages' routes are cleaned up

This allows targeted design plan updates without regenerating the entire plan.

---

## Error Handling

**If a feature spec doesn't specify any pages/views:**
- Check if the feature is backend-only (no UI). If so: mark as N/A in the plan.
- If the feature should have UI but pages aren't specified: infer pages from user journeys in the deep-dive and document the inference.

**If the interactive element count in deep-dives doesn't match the inventory:**
- Deep-dives may group components differently than the inventory. Verify that the FUNCTIONALITY is covered even if the granularity differs.
- When in doubt, add the element to the inventory. Over-specifying is better than under-specifying.

---
