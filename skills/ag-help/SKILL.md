---
name: sdlc-help
description: |
  Show all available Ultimate SDLC Framework commands organized by council and purpose.
  Use when asked for help, command list, or framework overview.
  Supports --all (include internal workflows) and --council <name> flags.
allowed-tools:
  - Bash
  - Read
---

# Ultimate SDLC Framework — Command Reference

## Filtering Behavior

By default, `/sdlc-ag-help` lists only workflows with `user_invocable: true` in frontmatter. Internal orchestration workflows (called only by other workflows or the `/sdlc-continue` conductor) are hidden.

### Flags

- `/sdlc-ag-help` — user-facing entry points only (~68 commands)
- `/sdlc-ag-help --all` — include internal workflows (all ~172 commands)
- `/sdlc-ag-help --council <name>` — filter to one council's user-invocable commands (e.g. `--council planning`)

### Implementation

When this skill is invoked, apply the following filter logic to determine which commands to display:

1. Parse frontmatter for each file in `commands/sdlc-*.md`: extract `description:` and `user_invocable:` fields.
2. Apply filters based on flags passed:
   - **Default mode** (no flags): skip files with `user_invocable: false` or missing `user_invocable`
   - **`--all`**: include every file regardless of `user_invocable` value
   - **`--council <name>`**: include only files whose name matches the council prefix (`planning-*`, `dev-*`, `audit-*`, `validate-*`, `feedback-*`) AND have `user_invocable: true` (unless `--all` is also passed, in which case include all files for that council)
3. Group output by prefix: planning-*, dev-*, audit-*, validate-*, feedback-*, then remaining (lifecycle/utility).
4. Emit a markdown table with columns: **Command** | **Purpose** for each group.
5. Print a summary footer: `Showing N of 172 commands. Use --all to see internal workflows.` (omit footer when `--all` is active; replace with `Showing all 172 commands.`).

### Rationale for the Hidden Set

Roughly 104 internal workflows are hidden by default. These are phase sub-steps (`planning-phase-3`, `dev-aiou`, `audit-a1`, `validate-c1`, etc.) that are called by orchestrators or the `/continue` conductor rather than typed by users directly. Exposing them in help clutters the experience and misleads users toward the wrong entry points.

---

## Quick Start

| Command | Purpose |
|---------|---------|
| `/init` | Initialize a new project |
| `/adopt` | Onboard an existing codebase to the framework |
| `/status` | Display current project and council status |
| `/continue` | Auto-advance to next step |
| `/new-cycle` | Start a new development cycle |
| `/close-cycle` | Close and archive the current development cycle |
| `/plan` | Create project plan using Planning Council |
| `/create` | Create new application |
| `/enhance` | Add or update features in existing application |
| `/recover` | Recover from interrupted session |
| `/rollback` | Roll back development to a prior wave |

## Planning Council (Requirements → Specifications)

> Use `/sdlc-ag-help --all --council planning` to see all 20 planning sub-workflows including internal phase steps.

| Command | Purpose |
|---------|---------|
| `/planning-start` | Initialize or resume Planning Council session |
| `/planning-handoff` | Generate final planning-handoff.md for Development Council |
| `/planning-upgrade` | Upgrade framework to a new version |

## Development Council (Specifications → Implementation)

> Use `/sdlc-ag-help --all --council dev` to see all 51 dev sub-workflows including internal phases, AIOU execution, wave5 sub-steps, and UI sub-phases.

| Command | Purpose |
|---------|---------|
| `/dev-start` | Initialize or resume Development Council session |
| `/dev-wave-1` | Execute Wave 1 — Types, Interfaces & Utilities |
| `/dev-wave-2` | Execute Wave 2 — Data Layer |
| `/dev-wave-3` | Execute Wave 3 — Services & Business Logic |
| `/dev-wave-4` | Execute Wave 4 — API Layer |
| `/dev-wave5-start` | Begin Wave 5 — UI Components |
| `/dev-wave5-status` | Show Wave 5 UI development status |
| `/dev-wave-6` | Execute Wave 6 — Integration |
| `/dev-ui-research` | Conduct UI design research before frontend implementation |
| `/dev-ui-design-plan` | Create comprehensive UI design plan |
| `/dev-ui-verify` | Verify UI wiring completeness |
| `/dev-ui-audit` | Non-destructive audit of existing UI for gaps |
| `/dev-ui-polish` | Orchestrate anti-slop audit and design remediation |
| `/dev-ui-retheme` | Orchestrate a complete UI visual retheme |
| `/dev-ui-redesign` | Reset and restart UI development |
| `/dev-status` | Quick status overview of development progress |
| `/dev-complete` | Complete Development Council and generate handoff |
| `/dev-upgrade` | Upgrade framework to a new version |

## Audit Council (Implementation → Quality Assessment)

> Use `/sdlc-ag-help --all --council audit` to see all 18 audit sub-workflows including individual testing phases (t2-t5), assessment phases (a1-a3), and gate sub-steps.

| Command | Purpose |
|---------|---------|
| `/audit-start` | Initialize or resume Audit Council session |
| `/audit-defect` | Log a defect with documentation and evidence |
| `/audit-enhancement` | Log enhancement idea discovered during audit |
| `/audit-feature` | Test and audit a specific feature |
| `/audit-report` | Generate comprehensive final audit report |
| `/audit-think` | Switch cognitive thinking modes for audit tasks |
| `/audit-status` | Quick status overview of audit progress |
| `/audit-complete` | Complete Audit Council and generate handoff |

## Validation Council (Assessment → Release Readiness)

> Use `/sdlc-ag-help --all --council validate` to see all 35 validation sub-workflows including individual V/C/P/E/S phase steps and gate sub-steps.

| Command | Purpose |
|---------|---------|
| `/validate-start` | Initialize or resume Validation Council session |
| `/validate-feature` | Deep validation of a specific feature |
| `/validate-framework` | Validate framework integrity and reference consistency |
| `/validate-production` | Production readiness assessment |
| `/validate-report` | Generate comprehensive validation report |
| `/validate-status` | Quick status overview of validation progress |
| `/validate-complete` | Complete Validation Council and mark project release-ready |

## Feedback & Learning

| Command | Purpose |
|---------|---------|
| `/feedback-log` | Log a user correction or preference with reasoning |
| `/feedback-review` | Review active feedback entries for current council/phase |
| `/feedback-promote` | Synthesize recurring entries into pattern entries at cycle end |

## Cycle Management

| Command | Purpose |
|---------|---------|
| `/patch-planning` | Abbreviated planning for bugfix cycles |
| `/maintenance-planning` | Planning for dependency/infra update cycles |
| `/improvement-planning` | Planning for refactoring/tech debt cycles |
| `/council-switch` | Switch active council with state preservation |
| `/amend` | Backtrack to amend a previous council's artifacts |
| `/framework-retro` | Draft proposed framework improvements from cycle patterns |

## Additional Utilities

| Command | Purpose |
|---------|---------|
| `/brainstorm` | Structured brainstorming with Socratic questioning |
| `/debug` | Systematic 4-phase debugging with root cause analysis |
| `/test` | Test-Driven Development — RED-GREEN-REFACTOR cycle |
| `/deploy` | Pre-flight checks and production deployment |
| `/release` | Final release certification and documentation |
| `/preview` | Local development server start/stop/status |
| `/orchestrate` | Coordinate multiple agents for complex tasks |
| `/ralph-wave` | Execute an entire wave autonomously (Ralph loop) |
| `/ralph-defects` | Fix all open defects autonomously (Ralph loop) |
| `/ralph-corrections` | Process all pending corrections autonomously (Ralph loop) |
| `/ui-ux-pro-max` | Full UI/UX planning and implementation |

> **Showing 68 of 172 commands.** Internal orchestration workflows (phase sub-steps, gate sub-steps, AIOU execution, wave5 sub-steps) are hidden by default. Use `/sdlc-ag-help --all` to see all 172 commands, or `/sdlc-ag-help --council <name>` to scope to one council.

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
