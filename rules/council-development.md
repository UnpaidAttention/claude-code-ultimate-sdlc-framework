# Development Council Rules

Load when: `/council development` or `/dev-*` commands

## State File Access Restrictions

> The Development Council reads state files from `.ultimate-sdlc/council-state/development/` and the planning handoff from `.ultimate-sdlc/handoffs/planning-handoff.md`. Do NOT read other council's state directories.

## Workflow Sequence

| Step | Workflow | Key Deliverable |
|------|----------|-----------------|
| **Scope** | `/dev-scope-analysis` | run-tracker.md (if multi-run) |
| **Start** | `/dev-start` | Development begins |
| Wave 0-1 | `/dev-wave-1` | Types, Interfaces & Utilities (combined) |
| Wave 2 | `/dev-wave-2` | Data Layer |
| Wave 3 | `/dev-wave-3` | Services |
| Wave 4 | `/dev-wave-4` | API Layer |
| **Gate I4** | `/dev-gate-i4` | **GATE** - Services verified |
| **UI-R** | `/dev-ui-research` | ui-design-research.md (once, after first Gate I4) |
| **UI-P** | `/dev-ui-design-plan` | ui-design-plan.md + design-system.md (once, after UI-R) |
| Wave 5 | `/dev-wave5-start` | UI Components (guided by design plan) |
| **UI-V** | `/dev-ui-verify` | UI wiring verification report (per run, after Wave 5) |
| Wave 6 | `/dev-wave-6` | Integration |
| **Gate I8** | `/dev-gate-i8` | **GATE** - Pre-deployment |

> **Note**: Waves 0 and 1 are combined into `/dev-wave-1` because Types and Utilities are tightly coupled and typically implemented together.

**Note**: Waves 0-6 may execute in multiple runs. Check `.ultimate-sdlc/council-state/development/run-tracker.md` for run assignments.

**Note**: UI-R and UI-P execute ONCE globally (after the first run passes Gate I4). UI-V executes per run after Wave 5. See UI Design Phases below.

## Quality Gates

Gate criteria are defined in `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/gate-criteria.md` (single source of truth).
Mode-specific activation: see `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/governance-modes.md § Per-Council Phase Activation`.

- **Gate I4**: Services Complete → see `gate-criteria.md § Gate I4`
- **UI Design Review Gate**: Design plan complete → see `/dev-ui-design-plan` Step 7
- **UI-V**: UI Wiring Verification → see `/dev-ui-verify`
- **Gate I8**: Pre-Deployment → see `gate-criteria.md § Gate I8`

## Session Protocol

Standard session start/resume sequence for all Development Council workflows:

1. Read `.ultimate-sdlc/config.yaml` → extract `governance_mode`, `project_type`
2. Read `.ultimate-sdlc/project-context.md` → confirm Active Council = Development, get current wave
3. Read `.ultimate-sdlc/handoffs/planning-handoff.md` → load AIOU specs for current wave
4. Read `.ultimate-sdlc/council-state/development/WORKING-MEMORY.md` → check for incomplete AIOUs
5. Check for `.ultimate-sdlc/council-state/development/run-tracker.md` → if exists, load current run assignment
6. **If resuming**: Display resume summary, identify next incomplete AIOU
7. **If new session**: Display welcome with wave overview, proceed to first AIOU
8. Check governance_mode → apply mode-specific behavior per `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/governance-modes.md`

## Context Health Protocol

Context degradation causes silent quality loss. Apply these checkpoints:

**Every 3 AIOUs within a run:**
- Assess context utilization (are you losing track of earlier decisions? repeating analysis?)
- If degraded: summarize all completed work to WORKING-MEMORY.md, compact/clear conversation, reload from state files
- Record context status in WORKING-MEMORY.md: `Context: GREEN/YELLOW/RED | AIOUs since last checkpoint: [N]`

**At wave boundaries (between waves):**
- Write wave completion summary to WORKING-MEMORY.md (what was built, key decisions, patterns established)
- Clear conversation context and start fresh
- Reload from: WORKING-MEMORY.md, run-tracker.md, current wave's AIOU specs
- This is mandatory, not optional — wave transitions are natural checkpoint boundaries

**At Gate I4 (mandatory context reset):**
- Gate I4 marks the transition from backend to UI. Full context reset.
- Write comprehensive backend summary to WORKING-MEMORY.md (API endpoints, data models, service interfaces, auth patterns)
- Clear and reload for UI phases with backend context from WORKING-MEMORY.md, not from conversation history

**Session-ending triggers** (per `universal-rules.md § 0.15`):
- Content file count exceeds session type limit
- Conversation exceeds ~30 substantive turns
- Noticing repetition or lost track of earlier decisions
- Gate verification fails 3+ times on same criterion

## Code Review Protocol

Applied after every AIOU implementation. Defined once here — all wave workflows reference this:

1. Review implemented code against AIOU spec
2. Verify test coverage meets requirements (>=3 tests per AIOU)
3. **Test assertion quality**: Every test must assert a specific business behavior — not just that the function returns something or doesn't throw. Prohibited weak assertions: `toBeDefined()`, `toBeTruthy()`, `not.toThrow()` as the ONLY assertion in a test. Each test must verify a concrete expected value, state change, or behavior.
4. Check security requirements (parameterized queries, input validation, output encoding, no secrets)
5. **Secrets scan**: Search all modified/created files for hardcoded secrets — API keys, passwords, tokens, private keys, connection strings. Any match → remove and replace with environment variable reference. Do NOT commit secrets.
6. Verify file modifications match AIOU scope (no unrelated changes)
7. Run build + test suite
8. **[Enterprise]** Capture evidence of review in wave completion report

## Display Template

Use this single template for all Development Council displays (new session or resume, single-run or multi-run):

```markdown
## Development Council - Wave [N]: [Wave Name]

**Mode**: [governance_mode] | **Type**: [project_type]
**Wave**: [N] of [total] | **Run**: [current_run/total_runs or "Single Pass"]
**AIOUs in scope**: [count] | **Completed**: [done_count]

[Wave-specific content follows]
```

## Gate Report Template

Use this template for all Development Council gate artifacts:

```markdown
## Gate [ID] Verification Report

**Date**: [Date] | **Mode**: [governance_mode]
**Verified By**: orchestrator | **Scope**: [run X of Y or "Single Pass"]

### Criteria Results
| Criterion | Status | Evidence |
|-----------|--------|----------|
| [from gate-criteria.md] | PASS/FAIL | [link or summary] |

### Gate Decision: [PASS/FAIL]
[If FAIL: list blocking issues with remediation steps]
```

## Focus Lenses

| Lens | Applied During |
|------|---------------|
| `[Architecture]` | Wave setup, scope analysis |
| `[Quality]` | All waves (code review) |
| `[Security]` | All waves (AIOU security checklist), gates |
| `[Performance]` | Wave 6 integration |
| `[UX]` | Wave 5 UI (if applicable to project_type) |

## Run Tracker Awareness

When `.ultimate-sdlc/council-state/development/run-tracker.md` exists (multi-run mode):
1. Read run tracker at workflow start to identify current run
2. Load ONLY the AIOUs assigned to the current run
3. Process only those AIOUs (not all project AIOUs)
4. Update tracker's progress table after completing each wave
5. Check off AIOUs as completed
6. Block run completion if any AIOU in run is incomplete

## Feature Context Loading Protocol

Before starting ANY AIOU, the agent MUST load the parent feature's context:

1. **Read** the parent FEAT-XXX spec from `.ultimate-sdlc/specs/features/FEAT-XXX.md`
2. **Read** the deep-dive analysis from `.ultimate-sdlc/specs/deep-dives/DIVE-XXX.md`
3. **Identify** the AIOU's role: other feature AIOUs, which are complete, how this AIOU connects to the component inventory
4. **After completing each AIOU**, verify against feature context: Does implementation align with user journey? Does it implement all components for this AIOU's scope? Does it handle documented integration points?

Record in WORKING-MEMORY.md:
- Parent Feature, Deep-dive reference, Feature AIOU count/progress, Components covered by this AIOU

## AIOU Execution Protocol (TDD)

For EVERY AIOU that produces testable code, follow the Red-Green-Refactor cycle:

### 0. Context Load
- Read parent FEAT-XXX spec + AIOU-XXX spec + deep-dive DIVE-XXX (if exists)
- Search codebase for existing patterns matching this AIOU's requirements
- If existing pattern found: follow it. Do NOT create an alternative pattern.
- **Wave 2 additional context**: Read `.ultimate-sdlc/specs/architecture/database-design.md` (if exists) — use as implementation blueprint for data layer AIOUs. Schema design, indexes, migration strategy are authoritative.
- **Wave 4 additional context**: Read `.ultimate-sdlc/specs/architecture/api-specification.md` (if exists) — use as implementation blueprint for API layer AIOUs. Endpoint paths, request/response schemas, error codes, and auth requirements are authoritative.
- **All waves**: Read `.ultimate-sdlc/specs/prd-crosscutting.md` §1 NFRs (if exists) — performance budgets, security requirements, and accessibility standards apply to all implementation work.

### 1. Red Phase — Write Failing Tests
- Each acceptance criterion → at least one test case
- Include edge cases from spec
- Run tests → confirm they FAIL (evidence: test output showing failures)
- If tests already pass without new code → tests are wrong or AIOU is already implemented. Investigate.

**Security tests (if AIOU handles user input, auth, or data)**:
- At least 1 injection attempt test per input entry point
- At least 1 auth test (valid, invalid, missing credentials)
- At least 1 negative authorization test (wrong role/user)
Include these in the Red phase alongside acceptance criteria tests.

### 2. Green Phase — Implement Minimum Code
- Write the minimum code to make tests pass
- Run tests after each significant change
- Do NOT add functionality beyond what tests require
- **Test files from Red phase are READ-ONLY during Green phase.** To modify tests, return to Red phase explicitly and document why.

### 3. Refactor Phase
- Refactor for readability and consistency (maintain passing tests)
- **Pattern verification**: Does this code follow existing codebase patterns? (naming, error handling, data access)
- **Reuse check**: Could any code reuse existing utilities/helpers?
- **Duplication check**: Any duplication >10 lines? → Extract to shared utility
- **New pattern?** → Document rationale in project-intelligence.md

### 4. Observe — Run Your Own Code
Before declaring tests pass, observe the implementation through its natural feedback channel:
- **Wave 2 (Data)**: Execute a query against the new schema/model — verify it works
- **Wave 3 (Services)**: Call the new service function with realistic input — verify output
- **Wave 4 (API)**: Hit the new endpoint — verify response shape and status code
- **Wave 5 (UI)**: Render the component — verify it appears (Visual QA handles deeper checks)
- **Wave 6 (Integration)**: Run the E2E path — verify end-to-end flow

If observation reveals a problem that tests missed: add a test that catches it (return to Red Phase), then fix.

### 5. Verify & Commit
- Run full test suite (not just new tests)
- Run build + lint
- Run dependency verification (`npm ls` / `pip check` / equivalent)
- **Secrets check**: Search modified files for patterns: API keys (`[A-Za-z0-9_]{20,}`), passwords (`password\s*=\s*["'][^"']+`), tokens (`token\s*=\s*["'][^"']+`), private keys (`-----BEGIN.*PRIVATE KEY`). If found: remove and use environment variables.
- Commit with descriptive message referencing AIOU-XXX
- Update run-tracker.md (mark AIOU complete)

**Exception**: If AIOU is pure configuration, documentation, or asset creation (no testable code), skip Red/Green and use direct implementation with verification.

## When Tests Fail

1. **READ** the full error message and stack trace
2. **LOCATE** the failing assertion — what was expected vs. actual?
3. **TRACE** backwards from the failure point to find the root cause
4. **FIX** the root cause (not the symptom)
5. **RE-RUN** the specific failing test to confirm fix
6. **RE-RUN** full test suite to check for regressions
7. If fix fails 3 times on the same issue: document in WORKING-MEMORY.md, flag for gate review

**PROHIBITED**: Modify test to match wrong output (PRH-002). Disable the failing test (PRH-003). Claim "it works" without test output evidence (PRH-005).

## Feature Integration Checkpoint Protocol

After the LAST AIOU for any feature completes, run `/dev-verify-feature FEAT-XXX` before proceeding to the next feature's AIOUs or to Wave 6.

**Trigger**: When all AIOUs for a feature (as listed in the FEAT spec and wave summary) have passed `/dev-verify-aiou`.

**Verification scope**: Component inventory completeness, user journey coverage, navigation placement, cross-feature connections, feature-level tests.

**Blocking**: Feature verification failures block Wave 6 integration AIOUs. All features must pass `/dev-verify-feature` before Wave 6 can begin.

## Model Selection

- Waves 0-4, 6: claude-sonnet-4-6 (fast execution)
- Wave 5 VISUAL: claude-opus-4-6 (creative layouts)
- Wave 5 LOGIC: claude-opus-4-6 (complex state)
- Wave 5 HYBRID: Both models (2 passes)

## Wave 5 Classification

> **Note**: Wave 5 (UI Components) only applies when `project_type` has a frontend (web-app, mobile-app). For CLI-tool, library, api-service, ml-pipeline: Wave 5 content is determined by `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/project-presets.md`.

| Type | Examples | Model |
|------|----------|-------|
| VISUAL | Animations, layouts, mockups | claude-opus-4-6 |
| LOGIC | State, forms, validation | claude-opus-4-6 |
| HYBRID | Both significant | Both (2 passes) |

## Security Requirements (Every AIOU)

- [ ] Parameterized queries only (no string concatenation in SQL/NoSQL)
- [ ] Validate all inputs server-side (type, length, range, format)
- [ ] Encode all outputs context-appropriately (HTML, URL, JS, SQL)
- [ ] Use established auth patterns (no custom auth)
- [ ] No hardcoded secrets, credentials, or API keys (use env vars)
- [ ] Use crypto-secure randomness (NOT Math.random/random.random)
- [ ] Error responses reveal no internals (no stack traces, paths, schema)
- [ ] Log no sensitive data (no PII, tokens, passwords in logs)
- [ ] Rate limit auth endpoints and expensive operations
- [ ] CSRF protection on state-changing endpoints (if web)

## Testing Requirements

- Unit tests: >80% coverage per AIOU
- Integration tests: >70% coverage per wave
- E2E tests: Critical user journeys
- Tests per AIOU: 3-8 (optimal range)

### Test Depth Requirements (Coverage != Quality)

80% coverage means 80% of lines were EXECUTED, not that behaviors were VERIFIED. Tests must go beyond coverage:

**Per-AIOU test depth**: Each AIOU must have tests covering:
1. **Happy path** — Primary success scenario with valid input → expected output
2. **Validation/Error path** — Invalid input → appropriate error (>=1 per input field/parameter)
3. **Edge case** — Boundary condition, empty input, maximum values, concurrent access (>=1 per AIOU)

**Assertion quality rules**:
- Every test MUST assert a specific expected value, state, or behavior
- Prohibited as sole assertion: `toBeDefined()`, `toBeTruthy()`, `not.toThrow()`, `toBeInstanceOf()`, `expect(result)` with no matcher
- Minimum 1 assertion per test that verifies a CONCRETE business outcome (e.g., `expect(user.name).toBe('Alice')` not just `expect(user).toBeDefined()`)

**Wave-specific test depth**:
- **Wave 2 (Data)**: Test schema constraints (unique, required, foreign key), migration up AND down, seed data validity
- **Wave 3 (Services)**: Test business rules, not just CRUD. What happens when: input is invalid? Dependency returns error? Concurrent modification occurs?
- **Wave 4 (API)**: Test every documented response code per the API Response Matrix. Not just 200 — test 400, 401, 403, 404, 500.
- **Wave 5 (UI)**: Test component rendering, user interactions (click, type, submit), state changes, error displays
- **Wave 6 (Integration)**: E2E tests must cover happy path + >=1 error path + >=1 edge case per critical user journey

## UI MCP Discovery Protocol (Wave 5)

> Only applies when `project_type` has a frontend component. Executed once at `/dev-wave5-start`.

At Wave 5 initialization, the agent MUST discover available MCP servers and consult the user before proceeding:

**Step 1: Detect Available MCP Servers**

Scan the environment for connected MCP servers relevant to UI development. Check for the presence of tools with these prefixes/names:

| MCP Server | Detection Method | Purpose |
|------------|-----------------|---------|
| **shadcn/ui MCP** | Look for `shadcn` prefixed tools or registry-related tools | Component discovery + installation from registries |
| **Spline MCP** | Look for `spline` prefixed tools or 3D scene management tools | 3D elements, animations, interactive scenes |
| **Figma MCP** | Look for `get_design_context`, `get_variable_defs`, `figma` prefixed tools | Design-to-code from Figma files (detect and offer if found) |
| **Playwright MCP** | Look for `browser_take_screenshot`, `browser_navigate` tools | Visual QA render-screenshot-compare loop |

**Step 2: Present Discovery Results to User**

Present findings and ask the user:

```
UI Design MCP Servers Detected:
- [List detected servers with their purpose]

Not detected:
- [List undetected servers with their purpose]

Options:
1. Use detected MCP servers for UI development
2. Add an MCP server before proceeding (I can help with setup)
3. Proceed without MCP design tools (manual coding only)

Which would you prefer?
```

**Step 3: Record MCP Configuration**

Save the user's MCP choices in `wave5-context.md` under an `## MCP Configuration` section. All subsequent Wave 5 workflows reference this configuration.

**Key Principle**: MCP servers are ALWAYS optional. The agent adapts to whatever is available. No MCP = manual coding with the same quality standards. MCP tools enhance speed and fidelity but are never hard requirements.

## Visual QA Protocol (Wave 5 — MANDATORY)

> Only applies when `project_type` has a frontend component. Executed per AIOU in Wave 5.

Every Wave 5 AIOU MUST include a visual QA feedback loop before being marked complete. This ensures UI output matches design intent and catches visual defects early.

**Visual QA Cycle (per AIOU):**

1. **Render**: Start the dev server (or use Storybook/isolated preview). Navigate to the component/page.
2. **Screenshot**: Capture screenshots at key breakpoints using Playwright MCP:
   - Mobile: 375x812
   - Tablet: 768x1024
   - Desktop: 1920x1080
3. **Compare**: Review screenshots against `design-system.md` and AIOU visual requirements:
   - Typography matches design tokens?
   - Colors use semantic tokens (not ad-hoc hex)?
   - Spacing/layout matches spec?
   - No ANTI-SLOP violations?
   - Component is visually distinctive (anti-convergence)?
4. **Fix**: If discrepancies found, fix them and return to step 1. Max 3 iterations per AIOU.
5. **Document**: Save final screenshots as visual QA evidence in `visual-qa/AIOU-XXX/` directory.

**If no screenshot tool is available**: Document the manual QA check in the AIOU completion artifact. Note: "Visual QA performed via manual inspection — no screenshot tool available."

**Evidence Required at Gate I8**: `visual-qa/` directory must contain at least one screenshot per Wave 5 AIOU (or documented manual QA for environments without screenshot tools).

## UI Design Phases (Frontend Projects)

> Only applies when `project_type` has a frontend component (web-app, mobile-app).

Frontend UI development requires dedicated design phases that execute BETWEEN Gate I4 and Wave 5. These phases ensure the agent researches, plans, and designs the UI before writing any frontend code.

### Phase Sequence

```
Gate I4 PASS (first run) → UI-R (research) → UI-P (design plan) → Wave 5 (implementation) → UI-V (verification) → Wave 6
```

### UI-R: Design Research (`/dev-ui-research`)
- **When**: Once, after the FIRST run passes Gate I4
- **Purpose**: Research design inspiration from Dribbble, Spline, and competitive applications
- **Output**: `.ultimate-sdlc/council-state/development/ui-design-research.md`
- **Completion**: Every page has design references; research document covers all identified pages

### UI-P: Design Planning (`/dev-ui-design-plan`)
- **When**: Once, after UI-R completes
- **Purpose**: Define design system, page layouts, navigation architecture, interactive element inventory
- **Output**: `design-system.md` + `.ultimate-sdlc/council-state/development/ui-design-plan.md`
- **Review Gate**: Agent verifies all pages, routes, and interactive elements are accounted for before proceeding
- **HARD STOP**: Wave 5 CANNOT begin until UI-P is complete and passes its review gate

### UI-V: Wiring Verification (`/dev-ui-verify`)
- **When**: Per run, after Wave 5 completes (before Wave 6)
- **Purpose**: Verify navigation works, buttons are wired, forms submit, states are complete
- **Output**: `.ultimate-sdlc/council-state/development/ui-verify-run-[N].md`
- **Blocking**: Wave 6 CANNOT begin until UI-V passes (0 CRITICAL, 0 HIGH issues)

### UI Audit (`/dev-ui-audit`) — Non-Destructive Completeness Fix
- **When**: Project has existing UI that's partially built. Pages exist but sub-pages, interactions, or CRUD operations are missing.
- **Purpose**: Scan existing UI, compare against feature specs, identify gaps (missing routes, unwired buttons, incomplete interactions), plan and build only what's missing
- **Preserves**: ALL existing code. Only ADDS new code and CONNECTS existing elements.
- **Output**: `.ultimate-sdlc/council-state/development/ui-audit-report.md`

### UI Polish (`/dev-ui-polish`) — Anti-Slop Remediation
- **When**: AFTER UI is functionally complete. The UI works but looks like generic AI output.
- **Purpose**: Scan for AI slop patterns (default fonts, purple gradients, bento grids, generic copy), research distinctive alternatives, replace slop with project-appropriate design
- **Prerequisite**: `/dev-ui-audit` or `/dev-ui-verify` passed — functionality must be complete before polishing
- **Output**: `.ultimate-sdlc/council-state/development/ui-slop-report.md`, `.ultimate-sdlc/council-state/development/ui-polish-report.md`

### UI Retheme (`/dev-ui-retheme`) — Visual Theme Makeover
- **When**: UI is complete and works but you want a completely different visual identity (new colors, fonts, spacing, aesthetic)
- **Purpose**: Apply a new visual theme while preserving all functionality. Changes look-and-feel without changing behavior.
- **Process**: Document current → research new direction (with user input) → propose new design system → implement after approval → verify consistency
- **Safety**: Creates git tag `pre-retheme-baseline` before any changes

### UI Redesign (`/dev-ui-redesign`) — Full UI Restart
- **When**: Any time after Gate I4, when existing UI needs a complete restart (not just fixes or restyling)
- **Purpose**: Archives existing UI artifacts and code, resets run tracker for Wave 5+, routes through fresh UI pipeline
- **Preserves**: All backend code (Waves 0-4), Gate I4 status, test infrastructure
- **Options**: `--keep-design-system` (skip research+planning), `--keep-research` (skip research only), `--scope feature FEAT-XXX` (single feature)
- **Safety**: Creates git branch `pre-ui-redesign-backup` before any changes

### Design Plan as Implementation Guide

During Wave 5, the agent MUST implement against the design plan — not improvise:
- Read the **Feature Interaction Map** from `ui-design-plan.md` before implementing each feature's AIOUs — this is the primary implementation guide. It specifies every user action, what opens, what fields appear, what happens on submit, success, error, and cancel.
- Read the page layout from `ui-design-plan.md` before implementing each page's AIOUs
- **Check the Route Tree for depth**: identify ALL sub-pages, tabs, and wizard steps under each page being implemented. Implement ALL of them — not just the top-level shell.
- **Check the CRUD Completeness Matrix**: for every data entity on this page, verify Create + Read List + Read Detail + Update + Delete are all being implemented. Missing CRUD operations = incomplete feature.
- Wire interactive elements per the interactive element inventory — every element must reference its Interaction Map entry
- Follow the navigation architecture for all links and routing
- Apply `design-system.md` tokens consistently (no ad-hoc colors, fonts, or spacing)
- **Depth rule**: A page with sub-navigation is NOT complete until every sub-page renders its own content. Empty tabs, placeholder sub-pages, and "coming soon" content are defects.
- **Interaction depth rule**: Every interactive element must be implemented through all 4 layers (Render → Trigger → Response → Completion). A button that appears but does nothing when clicked is a defect. An actions menu that opens but whose items do nothing is a defect. Every element must work end-to-end per its Feature Interaction Map specification.

### State Artifacts

| Artifact | Created By | Used By |
|----------|-----------|---------|
| `ui-design-research.md` | `/dev-ui-research` | `/dev-ui-design-plan` |
| `ui-design-plan.md` | `/dev-ui-design-plan` | `/dev-wave5-start`, `/dev-wave5-next`, `/dev-ui-verify` |
| `design-system.md` | `/dev-ui-design-plan` | All Wave 5 workflows, `/dev-ui-verify` |
| `ui-verify-run-[N].md` | `/dev-ui-verify` | `/dev-gate-i8` |

## Forbidden Patterns (Wave 5 UI)

> Only applies when `project_type` has a frontend component.

Standard Hero Split (Left Text / Right Image) | Bento Grids as default | Purple as primary color | Generic copy ("Orchestrate", "Empower") | Default UI libraries without approval

## Handoff Output

development-handoff.md containing: Implementation summary, Test results, Coverage metrics, Known issues, Git commit history

Validate against `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/handoff-schemas/development-handoff.schema.md`.

## Session Summary Protocol

At the end of every development session (whether natural completion, context limit, or user-initiated stop), append a structured summary to `.ultimate-sdlc/progress.md`:

```markdown
### Session: [ISO 8601 timestamp]
**Wave**: [current wave] | **Run**: [current run / single pass]
**AIOUs completed this session**: [list with IDs]
**AIOUs in progress**: [list — incomplete, to resume next session]
**Files modified**: [count] ([list key files])
**Tests added**: [count] | **Tests passing**: [count]/[total]
**Errors encountered**: [count] ([brief descriptions])
**Context checkpoints**: [count] (compactions/clears performed)
**Key decisions made**: [1-2 sentence summary of non-obvious choices]
**Next action**: [exact next step for the resuming session]
```

Also update `.ultimate-sdlc/council-state/development/WORKING-MEMORY.md` with:
- Last completed AIOU ID
- Current wave and position within wave
- Any blocked items or unresolved issues
- Context status (GREEN/YELLOW/RED)

This enables clean session resumption and provides audit trail of development activity.

## Recovery

If recovering mid-wave, verify last completed AIOU via WORKING-MEMORY.md and resume from that point. See `/recover` for full protocol.

### Post-Gate I8: Operational Readiness Documents

> **Governance check**: Read `.ultimate-sdlc/config.yaml → governance_mode`.

**Step 1: Generate Operational Runbook** (Enterprise: REQUIRED | Standard: RECOMMENDED | Lightweight: SKIP)
1. Read `templates/runbook-template.md`
2. Read `.ultimate-sdlc/specs/security/threat-model.md` — failure modes inform scenarios
3. Read `.ultimate-sdlc/specs/architecture/api-specification.md` — integration endpoints inform failure scenarios
4. Read `.ultimate-sdlc/specs/infrastructure/monitoring-plan.md` — alerting rules inform symptoms
5. Generate `.ultimate-sdlc/specs/operations/runbook.md` covering all 12 mandatory scenarios from the checklist
6. Each scenario documents actual system behavior (not theoretical — this is post-implementation)

**Step 2: Generate Technical Documentation Suite** (Standard/Enterprise: REQUIRED | Lightweight: RECOMMENDED)
1. Read `templates/tech-docs-checklist.md`
2. Generate docs from actual implemented codebase:
   - `README.md` — setup, env vars, commands from actual package.json/Makefile
   - `ARCHITECTURE.md` — component map from actual directory structure, links to ADRs
   - `API_GUIDE.md` — from `.ultimate-sdlc/specs/architecture/api-specification.md` + actual routes
   - `TROUBLESHOOTING.md` — common issues discovered during development
3. Verify all checklist items checked
