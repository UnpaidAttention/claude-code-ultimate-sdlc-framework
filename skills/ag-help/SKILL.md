---
name: sdlc-help
description: |
  Show all available Ultimate SDLC Framework commands organized by council and purpose.
  Use when asked for help, command list, or framework overview.
allowed-tools:
  - Bash
  - Read
---

# Ultimate SDLC Framework — Command Reference

## Quick Start

| Command | Purpose |
|---------|---------|
| `/init` | Initialize a new project |
| `/adopt` | Onboard an existing codebase |
| `/status` | Show current project state |
| `/continue` | Auto-advance to next step |
| `/new-cycle` | Start a new development cycle |
| `/close-cycle` | Archive current cycle |

## Planning Council (Requirements → Specifications)

| Command | Purpose |
|---------|---------|
| `/planning-start` | Begin/resume Planning Council |
| `/planning-phase-2` | Architecture & system design |
| `/planning-phase-3` | Feature specifications (FEAT-XXX) |
| `/planning-phase-3-5` | AIOU decomposition |
| `/planning-phase-8` | Launch readiness |
| `/planning-gate-1-5` | Gate: Feature completeness |
| `/planning-gate-3-5` | Gate: AIOU decomposition complete |
| `/planning-gate-8` | Gate: Launch ready |
| `/planning-feature` | Create a single feature spec |
| `/planning-feature-discovery` | Discover features from requirements |
| `/planning-discover` | Discovery session |
| `/planning-supporting-specs` | Supporting specifications (merged phases 4-7) |
| `/planning-config` | Configure planning settings |
| `/planning-adr` | Create Architecture Decision Record |
| `/planning-handoff` | Generate planning handoff document |
| `/planning-status` | Planning-specific status |
| `/planning-verify` | Verify planning completeness |
| `/planning-parallel` | Parallel planning execution |
| `/planning-complete` | Mark planning complete |

## Development Council (Specifications → Implementation)

| Command | Purpose |
|---------|---------|
| `/dev-start` | Begin/resume Development Council |
| `/dev-wave-1` | Types, Interfaces & Utilities |
| `/dev-wave-2` | Data Layer |
| `/dev-wave-3` | Services & Business Logic |
| `/dev-wave-4` | API Layer |
| `/dev-wave5-start` | UI Components (start) |
| `/dev-wave5-classify` | Classify UI components |
| `/dev-wave5-next` | Next UI component |
| `/dev-wave-6` | Integration |
| `/dev-gate-i4` | Gate: Services complete |
| `/dev-gate-i8` | Gate: Pre-deployment ready |
| `/dev-aiou` | Execute a single AIOU |
| `/dev-verify-aiou` | Verify AIOU completion |
| `/dev-verify-feature` | Verify feature completion |
| `/dev-verify-handoff` | Verify development handoff |
| `/dev-test` | Run project tests |
| `/dev-build` | Build project |
| `/dev-checkpoint` | Save development checkpoint |
| `/dev-status` | Development-specific status |
| `/dev-complete` | Mark development complete |
| `/dev-config` | Configure development settings |
| `/dev-scope-analysis` | Analyze implementation scope |
| `/dev-search-patterns` | Search for reusable patterns |
| `/dev-parallel` | Parallel development execution |

### UI Workflows

| Command | Purpose |
|---------|---------|
| `/dev-ui-research` | UI design research |
| `/dev-ui-design-plan` | UI design planning |
| `/dev-ui-verify` | Verify UI implementation |
| `/dev-ui-audit` | Audit UI for gaps |
| `/dev-ui-polish` | Polish UI (remove AI slop) |
| `/dev-ui-retheme` | Visual makeover |
| `/dev-ui-redesign` | Full UI restart |

## Audit Council (Implementation → Quality Assessment)

| Command | Purpose |
|---------|---------|
| `/audit-start` | Begin/resume Audit Council |
| `/audit-t2` | Functional testing |
| `/audit-t3` | GUI analysis |
| `/audit-t4` | Integration testing |
| `/audit-t5` | Security & performance testing |
| `/audit-a1` | Purpose alignment |
| `/audit-a2` | Completeness assessment |
| `/audit-a3` | Quality scorecard |
| `/audit-gate-t3` | Gate: GUI analysis |
| `/audit-gate-a2` | Gate: Completeness |
| `/audit-gate-a3` | Gate: Quality assessment |
| `/audit-defect` | Log a defect |
| `/audit-feature` | Audit a single feature |
| `/audit-report` | Generate audit report |
| `/audit-status` | Audit-specific status |
| `/audit-complete` | Mark audit complete |

## Validation Council (Assessment → Release Readiness)

| Command | Purpose |
|---------|---------|
| `/validate-start` | Begin/resume Validation Council |
| `/validate-v2` through `/validate-v5` | Validation tracks |
| `/validate-c1` through `/validate-c4` | Correction tracks |
| `/validate-p1` through `/validate-p4` | Production hardening |
| `/validate-e1` through `/validate-e4` | UX enhancement |
| `/validate-s1`, `/validate-s2` | Synthesis & release |
| `/validate-gate-v5` | Gate: Correction plan |
| `/validate-gate-c4` | Gate: Regression validated |
| `/validate-gate-p4` | Gate: Security hardened |
| `/validate-gate-e4` | Gate: UX polished |
| `/validate-gate-s2` | Gate: Release ready |
| `/validate-correct` | Apply corrections |
| `/validate-feature` | Validate a single feature |
| `/validate-report` | Generate validation report |
| `/validate-status` | Validation-specific status |
| `/validate-complete` | Mark validation complete |

## Cycle Management

| Command | Purpose |
|---------|---------|
| `/patch-planning` | Abbreviated planning for bugfixes |
| `/maintenance-planning` | Planning for dependency/infra updates |
| `/improvement-planning` | Planning for refactoring/tech debt |
| `/council-switch` | Switch active council |
| `/recover` | Recover from errors |
| `/rollback` | Rollback changes |

## Utility Commands

| Command | Purpose |
|---------|---------|
| `/brainstorm` | Brainstorming session |
| `/debug` | Debugging workflow |
| `/test` | Run tests |
| `/deploy` | Deploy to production |
| `/release` | Create a release |
| `/preview` | Preview changes |
| `/enhance` | Enhancement workflow |
| `/thoroughness-audit` | Audit quality depth |
| `/thoroughness-remediate` | Fix quality gaps |

## Governance Modes

| Mode | Features | Gates |
|------|----------|-------|
| **Lightweight** | <8 | 7 active (skips 1.5, 3.5, I4, T3, V5, P4, E4) |
| **Standard** | 8-25 | All 13 active |
| **Enterprise** | 25+ | All 13 + external security scans |

## Focus Lens Agents

Available as subagents via the Agent tool:
- `sdlc-architecture` — System structure, API design, scalability
- `sdlc-security` — Threat modeling, OWASP, secrets
- `sdlc-quality` — Test coverage, code review, defects
- `sdlc-performance` — Profiling, optimization, benchmarks
- `sdlc-ux` — Usability, accessibility, design
- `sdlc-operations` — Deployment, monitoring, failure modes
- `sdlc-requirements` — Feature completeness, scope
- `sdlc-documentation` — Technical docs, guides

## File Locations

| Component | Location |
|-----------|----------|
| Plugin source | `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/` |
| Global config | `~/.ultimate-sdlc/config.yaml` |
| Project state | `.ultimate-sdlc/` (in project root) |
| Knowledge skills | `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/` |
| Rules | `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/rules/` |
| Context | `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/` |
| Agents | `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/agents/` |
