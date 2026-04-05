---
name: feature-deep-dive
description: Guides structured deep-dive analysis of software features. Produces 7-section analysis covering functional behavior, complete component inventories, UI placement and navigation, user journey maps, cross-feature integration points, state and data flows, and prerequisite components. Ensures no feature is shallowly specified by requiring exact component counts, concrete navigation paths, and documented error journeys.
version: 1.0.0
---

# Feature Deep-Dive Analysis Skill

## Purpose

Ensure every feature receives thorough, structured analysis before specification writing begins. This skill prevents the common AI failure mode of producing shallow, high-level feature descriptions that miss components, omit error paths, and ignore cross-feature connectivity.

## 7-Section Analysis Methodology

### 1. Feature Functional Analysis
- Map the complete functional flow from trigger to completion
- Document ALL states the feature can be in (idle, loading, active, error, disabled, etc.)
- Map state transitions with their triggers
- List every business rule with exceptions and edge cases

### 2. Complete Component Inventory
- Enumerate EVERY component: UI components, services, API endpoints, data entities, hooks, validators, utilities
- Use exact counts — never "several" or "various"
- Assign each component to a development wave (0-6)
- The total count becomes the implementation verification target

### 3. UI Placement & Navigation
- Document exact route/URL path
- Specify the complete navigation path from app entry to feature
- List ALL entry points (menu, URL, link, notification, etc.)
- Describe screen layout structure

### 4. User Journey Map
- **Primary journey**: Step-by-step (User Action → System Response → UI Change)
- **Secondary journeys**: Alternate paths with triggers
- **Error journeys**: What user sees when things fail, how they recover
- ALL three journey types are mandatory — no exceptions

### 5. Cross-Feature Integration Points
- Document every data-sharing interaction with other features
- Specify direction (A→B, B→A, bidirectional)
- Identify shared components consumed by multiple features
- If truly isolated, document that explicitly

### 6. State & Data Flow
- Text-based data flow diagrams
- State management table: item, source, consumers, update trigger, persistence
- Data transformations and derivations

### 7. Prerequisite Components
- What must exist before implementation
- What must be built alongside (tightly coupled)
- External dependencies with version requirements

## Quality Checks

After completing each feature's deep-dive, verify:

| Check | Requirement |
|-------|-------------|
| Component counts | Exact numbers, never estimates |
| User journeys | Primary + secondary + error documented |
| Integration points | Documented even if "none identified" |
| Wave assignments | Every component assigned to wave 0-6 |
| State management | Specific stores/sources, not generic references |
| Navigation paths | Concrete routes and paths, not "accessible from dashboard" |
| Business rules | Listed with exceptions, not just happy path |

## Anti-Patterns to Avoid

| Anti-Pattern | Correct Approach |
|-------------|-----------------|
| "The feature includes several components" | List every component with exact count |
| "Users can access this from the dashboard" | Specify: Sidebar → Settings → Notifications tab, route: /settings/notifications |
| "Standard error handling" | Document each error scenario with user-facing message and recovery path |
| "Integrates with authentication" | Specify: Reads auth token from AuthContext, calls /api/auth/verify on mount, redirects to /login on 401 |
| "Data is stored in the database" | Specify entities, fields, relationships, indexes, and which service reads/writes |
| Omitting error journeys | ALWAYS document what happens when API fails, validation fails, permission denied |
| "Similar to Feature X" | Fully document — cross-reference is fine but each feature stands alone |

## Complexity Classification Reference

Used in Phase 1.5 to classify features before deep-dive:

| Factor | Simple (1pt) | Moderate (2pt) | Complex (3pt) |
|--------|-------------|----------------|---------------|
| UI Surfaces | 1 screen/component | 2-3 screens | 4+ screens or multi-step wizard |
| Data Entities | 0-1 entities | 2-3 entities | 4+ entities or complex relationships |
| Integration Points | None | 1-2 internal | External APIs or 3+ internal |
| Business Logic | Basic CRUD | Conditional logic | State machines, workflows, calculations |
| User Interactions | View/click | Forms, filters | Real-time, drag-drop, multi-step flows |

Scoring: 5-7 = Simple, 8-11 = Moderate, 12-15 = Complex

**All features receive the full 7-section analysis regardless of complexity.** Classification informs batch grouping and development prioritization only.
