# Antigravity SDLC Framework Overview

## Purpose

Structured, iterative SDLC through four sequential councils with specialized phases, agents, and quality gates. Supports ongoing use across multiple development cycles.

## Cycle System

The framework operates through **cycles** — discrete passes through the pipeline. Completed cycles are archived to `.cycles/`.

| Type | Use Case | Active Councils | Planning |
|------|----------|----------------|----------|
| **Full** | Initial build, major versions | All 4 | Full 8 phases |
| **Feature** | Adding 1-5 features | All 4 | Full 8 phases |
| **Patch** | Bug fixes | Planning, Dev, Validation | Abbreviated (`/patch-planning`) |
| **Maintenance** | Dependencies, security, infra | Planning, Dev, Validation | Abbreviated (`/maintenance-planning`) |
| **Improvement** | Refactoring, performance, tech debt | All 4 | Abbreviated (`/improvement-planning`) |

**Lifecycle**: `/init` (once) → `/planning-start` → ... → `/close-cycle` → `/new-cycle` → ... (repeat)
For existing codebases: use `/adopt` instead of `/init`.

### Key Files

| File | Scope | Purpose |
|------|-------|---------|
| `.antigravity/project-manifest.md` | **Persistent** (all cycles) | Project identity, cycle history, feature inventory |
| `.antigravity/project-context.md` | **Per-cycle** (archived by `/close-cycle`) | Active council, phase, cycle info |
| `.antigravity/progress.md` | **Per-cycle** | Session history |
| `.antigravity/council-state/` | **Per-cycle** | Council progress, working memory |
| `.cycles/` | **Archive** | Completed cycle state |

## Council Flow

```
/init OR /adopt (one-time) → /new-cycle (each cycle)
  → PLANNING (8 or abbrev) → DEVELOPMENT (7 waves) → AUDIT (3 tracks) → VALIDATION (5 tracks)
  → /close-cycle (archive + learn) → /new-cycle → ...
```

Patch and Maintenance cycles skip Audit Council.

## How It Works

### 1. Initialize (Once Per Project)
- **New project**: `/init` — creates project structure, manifest, first cycle. Supports guided creation or reads existing `product-concept.md`.
- **Existing codebase**: `/adopt` — scans code, creates feature inventory, generates manifest.

### 2. Start Cycles
1. **First cycle**: Created by `/init` (Full type)
2. **Subsequent**: `/new-cycle` → choose type → archives previous state, creates fresh files
3. **Between**: `/close-cycle` → archives work, extracts learnings, updates manifest

### 3. Progress Through Councils
Each council has phases/waves/tracks (sequential steps), gates (blocking checkpoints), and handoffs (documents for next council, validated against `~/.claude/skills/antigravity/context/handoff-schemas/`).

MCP tools for testing, security, performance: see `~/.claude/skills/antigravity/reference/mcp-tool-guide.md`.

### 4. State Management
- `.antigravity/project-manifest.md`: Persistent project identity (survives all cycles)
- `.antigravity/project-context.md`: Current cycle state
- `.antigravity/progress.md`: Session history (per cycle)
- `.antigravity/council-state/{council}/`: Council-specific state

**Cycle state resolution**: `.antigravity/project-context.md` exists → active cycle. Only `.antigravity/project-manifest.md` → between cycles. Neither → not initialized.

### 5. Skill Loading
**Maximum 7 skills per workflow. Always include `rarv-cycle`.** See `~/.claude/skills/antigravity/reference/skill-loading-guide.md` and `~/.claude/skills/antigravity/reference/skills-index.md`.

### 6. Governance Modes
The framework scales governance to project size (Lightweight/Standard/Enterprise). See `~/.claude/skills/antigravity/context/governance-modes.md`.

### 7. On-Demand File Loading
Files load when first referenced, not preemptively. Governance files (P0 rules) are internalized once per session. See UNIVERSAL-RULES §0.9.

## Key Commands

| Command | Purpose |
|---------|---------|
| `/init` | Start new project (creates state files + first cycle) |
| `/adopt` | Onboard existing codebase |
| `/new-cycle` | Start new cycle (archives previous state) |
| `/close-cycle` | Archive completed cycle, extract learnings |
| `/status` | Show current state + next workflow |
| `/continue` | Auto-advance through phases (pauses at gates/council transitions) |
| `/recover` | Recover from interrupted session |
| `/planning-start` | Begin/resume Planning Council |
| `/patch-planning` | Abbreviated planning for bug fixes |
| `/maintenance-planning` | Abbreviated planning for dependency/infra |
| `/improvement-planning` | Abbreviated planning for refactoring/performance |
| `/dev-start` | Begin/resume Development Council |
| `/audit-start` | Begin/resume Audit Council |
| `/validate-start` | Begin/resume Validation Council |

## Workflow Navigation

Each workflow tells you the next workflow to run. Use `/continue` to auto-advance, `/status` to see current position.

### Architecture

```
WORKFLOW (specifies agent + skills_required) → AGENT (domain expertise) → SKILLS (from workflow frontmatter)
```

### Workflow Naming

| Council | Pattern | Example |
|---------|---------|---------|
| Planning | `/planning-phase-X`, `/planning-gate-X` | `/planning-phase-2`, `/planning-gate-3-5` |
| Development | `/dev-wave-X`, `/dev-gate-IX` | `/dev-wave-3`, `/dev-gate-i4` |
| Audit | `/audit-TX`, `/audit-AX`, `/audit-EX` | `/audit-t2`, `/audit-gate-t3` |
| Validation | `/validate-VX`, `/validate-CX`, etc. | `/validate-c1`, `/validate-gate-v5` |

Full map: `~/.claude/skills/antigravity/reference/workflow-reference.md`

## Multi-Run System (Development Only)

For large projects, development is divided into manageable runs. Planning always single-pass.

AI models lose context with many items. Multi-run:
- Divides work into focused chunks via `run-tracker.md`
- Tracks AIOU completion explicitly
- Prevents truncation during implementation

**Flow**: After Gate 8 → `/dev-scope-analysis` → creates `.antigravity/council-state/development/run-tracker.md`. Each run processes only its assigned AIOUs through Waves 0-6.

### Integrity Rules

P0 prohibitions in `INTEGRITY-RULES.md`: PRH-001 (feature truncation), PRH-002 (test manipulation), PRH-003 (service disabling), PRH-004 (false attribution), PRH-005 (premature completion), PRH-006 (scope reduction).

---

## Design Quality Standards

Every UI project MUST complete dedicated UI design phases BEFORE Wave 5 implementation.

- **UI Design Phases** (execute once, after first Gate I4 pass):
  - **UI-R** (`/dev-ui-research`): Design inspiration research from Dribbble, Spline, Stitch, competitive analysis
  - **UI-P** (`/dev-ui-design-plan`): Design system definition, page layouts, navigation architecture, interactive element inventory
  - **UI-V** (`/dev-ui-verify`): Post-Wave-5 verification of navigation wiring, button handlers, form submission, state completeness
- **Banned**: Inter, Arial, Roboto, system-ui; purple gradients; centered-everything; generic hero sections; evenly-spaced card grids
- **Required**: Distinctive typography pairing, context-derived color palette (OKLCH, HSL fallback), purposeful motion design
- **Artifacts**: `design-system.md`, `ui-design-research.md`, `ui-design-plan.md` before any UI components
- **Gates**: I4 verifies design direction; UI-V verifies functional wiring; I8 verifies anti-slop compliance + WCAG 2.2 AA + UI completeness
- **Redesign**: `/dev-ui-redesign` archives existing UI and restarts the full UI pipeline. Preserves backend. Options: `--keep-design-system`, `--keep-research`, `--scope feature FEAT-XXX`
- **Reference**: `~/.claude/skills/antigravity/knowledge/frontend-design/SKILL.md`, `~/.claude/skills/antigravity/reference/wave5-special-handling.md`

---

## Quality Gates

Gates BLOCK progression until ALL criteria pass. Binary PASS/FAIL with specific tests.
**Reference**: `~/.claude/skills/antigravity/context/gate-criteria.md` for criteria and checklist templates.

| Gate | Council | Criteria |
|------|---------|----------|
| **1.5** | Planning | All features identified, anti-truncation verified |
| 3.5 | Planning | All features decomposed into AIOUs |
| 8 | Planning | All specs complete, ready for development |
| I4 | Development | Services complete, tests passing |
| I8 | Development | Full integration, ready for audit |
| T3 | Audit | GUI analysis complete |
| A2 | Audit | Completeness verified |
| A3 | Audit | Quality assessment complete |
| V5 | Validation | Correction plan complete |
| C4 | Validation | All corrections verified |
| P4 | Validation | Production hardened |
| E4 | Validation | UX polished |
| S2 | Validation | Release ready |

### Post-Launch Operations

After Gate S2 + `/deploy`: Monitor (health checks, error rates), follow incident runbook, execute rollback if needed, collect feedback, `/close-cycle` → `/new-cycle`.

## State Files

**Protocol**: `~/.claude/skills/antigravity/context/state-management.md`

| File | Scope | Purpose | Update Timing |
|------|-------|---------|---------------|
| `.antigravity/project-manifest.md` | Persistent | Project identity, cycle history | After cycle close/start |
| `.antigravity/project-context.md` | Per-cycle | Authoritative position | After phase complete |
| `.antigravity/council-state/*/current-state.md` | Per-cycle | Council progress | After phase in council |
| `.antigravity/council-state/*/WORKING-MEMORY.md` | Per-cycle | Session state | After each action |
| `.antigravity/council-state/*/run-tracker.md` | Per-cycle | Run progress (if multi-run) | After each item complete |
| `.antigravity/progress.md` | Per-cycle | Historical log | Session end only |

```
project-root/
├── .antigravity/project-manifest.md          # Persistent (survives all cycles)
├── .antigravity/project-context.md           # Current cycle state
├── .antigravity/progress.md                  # Current cycle history
├── .antigravity/council-state/{council}/     # current-state.md, WORKING-MEMORY.md, run-tracker.md
├── .antigravity/handoffs/                    # planning-, development-, audit-, validation-handoff.md
├── .antigravity/specs/features/, aious/, adrs/
└── .cycles/cycle-NNN-slug/      # Archived cycle state
```

## Agents

41 specialist agents organized by council. See `~/.claude/skills/antigravity/agents/` for full list.
- **Agent Selection Guide**: `~/.claude/skills/antigravity/reference/agent-selection-guide.md`
- **Model Selection Guide**: `~/.claude/skills/antigravity/reference/model-selection-guide.md`

### Constitutional Principles

All agents self-critique against `~/.claude/skills/antigravity/rules/CONSTITUTION.md`: Safety (no destructive ops without backup), Quality (verify before claiming), Process (read before modify), Communication (state what was done).

## Rules Priority

```
P0: UNIVERSAL-RULES.md, INTEGRITY-RULES.md    (Always active)
P1: council-{name}.md                         (When council active)
P2: Agent-specific rules                      (When agent invoked)
P3: Skill-specific rules                      (When skill loaded)
```

**Conflict Resolution**: `~/.claude/skills/antigravity/rules/conflict-resolution.md`
