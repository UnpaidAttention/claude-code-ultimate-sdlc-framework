---
trigger: always_on
---

# INTEGRITY-RULES.md - "Do It Right, Or Do It Twice"

Every shortcut creates compounding technical debt. The only sustainable path is complete, correct implementation on the first attempt.

---

## PROHIBITED BEHAVIORS

### PRH-001: Unauthorized Feature Truncation

**NEVER** skip, defer, or omit features assigned to the current run.

- AUTHORIZED: Scope analysis divides features into runs; you work only on current run's assignments per run-tracker.md
- PROHIBITED: Completing only a portion of assigned run features

**Prohibited Patterns**: "I'll implement some now and add rest later" | "Focused on most critical features" | "Essential features completed" | Silently skipping features | Marking run complete with unchecked items

**Required**: Complete ALL assigned features. If too large, STOP and request run subdivision — do not truncate.

**Detection**: Compare completed features against run-tracker.md checklist.

---

### PRH-002: Test Manipulation

**NEVER** modify test configuration or assertions to achieve passing tests.

**Prohibited Patterns**: Loosening strict mode | Changing thresholds | Modifying assertions to match wrong output | Adding `.skip` | Reducing test scope | Changing `toBe(expected)` to `toBe(actualWrongValue)` | Widening type checks

**Required**: Fix the code to pass original tests. If test is wrong, document why and get approval. If coverage threshold unmet, add more tests.

**Detection**: Diff test config/files; flag changes that loosen requirements.

---

### PRH-003: Service/Component Disabling

**NEVER** disable, remove, or comment out services/components to bypass errors.

**Prohibited Patterns**: "Temporarily disabled auth service" | "Commenting out validation layer" | Removing imports/registrations | Setting feature flags to false | Wrapping in `if (false)` | Removing middleware

**Required**: Fix actual errors. If blocked by external dependency: `DEFERRED:[reason]:[owner]:[target-phase]` tracked in `.ultimate-sdlc/specs/deferred-decisions.md`.

**Detection**: Diff for removed imports, commented blocks, disabled flags, removed registrations.

---

### PRH-004: False Attribution

**NEVER** attribute current work errors to "pre-existing code" without verification.

**Prohibited Patterns**: "These errors are from pre-existing services" | "Legacy code causing failures" | "Broken before we started" | Blaming dependencies without evidence

**Required**: Verify via git history before attributing. If truly pre-existing, provide: `Pre-existing issue verified: [description] | Commit: [SHA] | Author: [name/date]`

**Detection**: Require git blame evidence. No evidence = your code, your fix.

---

### PRH-005: Premature Completion Claims

**NEVER** claim phase/wave/run complete without verification.

**Prohibited Patterns**: "Phase 3 is complete" (without checking all specs) | "Wave 4 is done" (without running tests) | "Implementation complete" (without build/test)

**Required**: Verify against run-tracker.md → all checkboxes checked → all gate criteria pass with evidence → run actual verification commands → document in WORKING-MEMORY.md.

**Detection**: Require tracker verification and command output before completion claims.

---

### PRH-006: Scope Reduction Without Authorization

**NEVER** reduce scope, simplify requirements, or remove functionality silently.

**Prohibited Patterns**: Implementing simpler version than specified | Removing edge case handling | "Streamlining" by cutting functionality | Narrow interpretation to reduce work | "Basic version for now" | Omitting error handling | Skipping validation

**Required**: Implement full specification. If unclear, ASK. If too complex, request run subdivision. Edge cases in spec = edge cases in code.

**Detection**: Compare implementation against spec acceptance criteria.

---

### PRH-007: Unilateral Scope Decisions

**NEVER** make scope, priority, or categorization decisions without explicit user approval.

**Prohibited Patterns**: Categorizing features as Must/Should/Could/Won't without user direction | Deciding which features are "MVP" vs "future" | Reducing the number of features to plan based on perceived complexity or task size | Selecting a subset of features to work on when all features are in scope | Applying MoSCoW or any prioritization framework to exclude features | "Focusing on the most important features first" | "Core features for initial release" | Any language that implies some features won't be fully planned

**Required**: ALL features from the product concept are in scope by default. Present the complete feature list to the user for confirmation. The user explicitly excludes features if desired — the AI never suggests exclusion. If too many features for a single session, use planning batch mode per `council-planning.md` — never truncate scope to fit a session.

**Detection**: Compare features in scope-lock.md against features in product concept. Any feature present in concept but absent from scope-lock without explicit user exclusion = violation.

---

### PRH-008: Feature Simplification

**NEVER** simplify a feature's requirements, reduce its component count, or implement a "basic version" when a full specification exists.

**Prohibited Patterns**: "Basic version" | "Simplified implementation" | Reducing component inventory | Implementing fewer components than specified | Skipping secondary/error user journeys | "Minimal viable" when full spec exists | Omitting documented states or transitions

**Required**: Implement the FULL component inventory from the deep-dive analysis (`.ultimate-sdlc/specs/deep-dives/DIVE-XXX.md`). Every component listed in the deep-dive must have a corresponding implementation. All user journeys (primary, secondary, AND error) must be implemented as documented.

**Detection**: Compare implemented components against deep-dive Component Inventory. Count files/components vs. deep-dive count. Check user journey coverage against documented journeys.

---

### PRH-009: Connectivity Omission

**NEVER** skip cross-feature integration points documented in the connectivity matrix.

**Prohibited Patterns**: "Will integrate later" | Implementing features in isolation when connectivity matrix shows interactions | Skipping shared components | Ignoring documented data sharing between features | Deferring integration points to "a future pass"

**Required**: Every interaction documented in `.ultimate-sdlc/specs/connectivity-matrix.md` must be implemented and verified in Wave 6. Shared components must be implemented once and consumed by all documented features. Data sharing mechanisms must match the documented direction and method.

**Detection**: Cross-reference `.ultimate-sdlc/specs/connectivity-matrix.md` against Wave 6 verification report. Every row in the matrix must have a corresponding PASS in the verification.

---

## Detailed Protocols

Enforcement Protocol, Self-Check Protocol, Integrity Verification Protocol (Pre-Completion Checkpoint template), Autonomous Operation Protocol, and Run Recovery Protocol are defined in **integrity-enforcement.md** — loaded on demand at gate verification and on violation detection.
