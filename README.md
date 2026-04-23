# Ultimate SDLC Framework for Claude Code

A structured, gate-driven, multi-council orchestration system for AI-assisted software development. Manages the full lifecycle from requirements through deployment: **Planning → Development → Audit → Validation**.

167 workflow commands, 245 knowledge skills, 19 specialist agents, 13 quality gates, 5 cycle types.

## Install

```bash
git clone https://github.com/UnpaidAttention/claude-code-ultimate-sdlc-framework.git ~/ultimate-sdlc && cd ~/ultimate-sdlc && ./setup
```

The setup script copies the framework into the Claude Code plugin cache (`~/.claude/plugins/cache/`), registers it as a plugin, and installs agents and rules. The source repo at `~/ultimate-sdlc` stays separate — safe to modify, update, and push without affecting the installed copy.

Restart Claude Code after setup. All `/sdlc-*` commands will be available.

## Quick Start

In any Claude Code session:

```
/sdlc-init              # Initialize a new project
/sdlc-planning-start    # Begin the Planning Council
/sdlc-status            # Check current progress
/sdlc-continue          # Auto-advance to next step
/sdlc-help              # Full command reference
```

> If you chose **short** naming mode during setup, drop the `sdlc-` prefix: `/init`, `/planning-start`, etc.

---

## How It Works

The framework guides AI-assisted development through **four sequential councils**. Each council has phases or tracks, quality gates that block progression, and specialized workflow commands. You advance through each council in order — Planning produces specifications, Development implements them, Audit verifies quality, and Validation certifies release readiness.

### The Four Councils

#### 1. Planning Council — Requirements → Specifications

Transforms a product concept into implementation-ready specifications. Walks through discovery, architecture, feature specification, and AIOU (Atomic Implementation Output Unit) decomposition.

| Phase | Purpose | Command |
|-------|---------|---------|
| Phase 1 | Discovery — understand the problem, users, constraints | `/sdlc-planning-start` |
| Phase 1.5 | Deliberation — multi-perspective analysis | `/sdlc-planning-phase-1-5` |
| Phase 2 | Architecture — system design, tech stack, data models | `/sdlc-planning-phase-2` |
| Phase 2.5 | Feature deep-dive — detailed analysis per feature | `/sdlc-planning-feature-deep-dive` |
| Phase 3 | Features — create FEAT-XXX specifications with acceptance criteria | `/sdlc-planning-phase-3` |
| Phase 3.5 | AIOU decomposition — break features into atomic implementation units | `/sdlc-planning-phase-3-5` |
| Phases 4-7 | Supporting specs — security, testing strategy, infrastructure, sprint planning | `/sdlc-planning-supporting-specs` |
| Phase 8 | Launch ready — final review and handoff preparation | `/sdlc-planning-phase-8` |

**Gates**: 1.5 (feature completeness), 3.5 (AIOU decomposition), 8 (launch ready)

#### 2. Development Council — Specifications → Implementation

Implements the planned specifications wave by wave, from foundational types through UI to full integration.

| Wave | Purpose | Command |
|------|---------|---------|
| Wave 1 | Types, interfaces, utilities | `/sdlc-dev-wave-1` |
| Wave 2 | Data layer — models, schemas, migrations | `/sdlc-dev-wave-2` |
| Wave 3 | Services — business logic, domain operations | `/sdlc-dev-wave-3` |
| Wave 4 | API layer — endpoints, controllers, middleware | `/sdlc-dev-wave-4` |
| Wave 5 | UI components — pages, forms, interactions | `/sdlc-dev-wave5-start` |
| Wave 6 | Integration — end-to-end wiring, system tests | `/sdlc-dev-wave-6` |

**Gates**: I4 (services complete), I8 (pre-deployment ready)

**Additional dev commands**: `/sdlc-dev-aiou` (execute a single AIOU), `/sdlc-dev-test` (run tests), `/sdlc-dev-checkpoint` (save progress), `/sdlc-dev-verify-feature` (verify a feature)

#### 3. Audit Council — Implementation → Quality Assessment

Independently tests and assesses the implementation for correctness, completeness, and quality.

| Track | Purpose | Commands |
|-------|---------|----------|
| Testing (T1-T5) | Functional, GUI, integration, security, performance testing | `/sdlc-audit-t2` through `/sdlc-audit-t5` |
| Audit (A1-A3) | Purpose alignment, completeness assessment, quality scorecard | `/sdlc-audit-a1` through `/sdlc-audit-a3` |

**Gates**: T3 (GUI analysis), A2 (completeness), A3 (quality assessment)

**Additional audit commands**: `/sdlc-audit-defect` (log a defect), `/sdlc-audit-report` (generate report), `/sdlc-audit-trace` (verify spec-to-implementation traceability)

#### 4. Validation Council — Assessment → Release Readiness

Validates corrections, hardens for production, polishes UX, and certifies release readiness.

| Track | Purpose | Commands |
|-------|---------|----------|
| Validation (V1-V5) | Gap analysis, completeness, correction planning | `/sdlc-validate-v2` through `/sdlc-validate-v5` |
| Correction (C1-C4) | Targeted fixes, edge cases, verification, regression | `/sdlc-validate-c1` through `/sdlc-validate-c4` |
| Production (P1-P4) | Operational assessment, failure modes, performance, security hardening | `/sdlc-validate-p1` through `/sdlc-validate-p4` |
| Enhancement (E1-E4) | Feature richness, innovation, UX polish | `/sdlc-validate-e1` through `/sdlc-validate-e4` |
| Synthesis (S1-S2) | Documentation updates, final release certification | `/sdlc-validate-s1`, `/sdlc-validate-s2` |

**Gates**: V5, C4, P4, E4, S2 (release ready)

---

## Quality Gates

13 binary pass/fail checkpoints that **block progression** until criteria are met. Each gate has a specific checklist — you can't skip or hand-wave past them.

| Gate | Council | What It Checks |
|------|---------|----------------|
| **1.5** | Planning | Every requirement captured, no truncation, user confirmed scope |
| **3.5** | Planning | All features decomposed into AIOUs with acceptance criteria |
| **8** | Planning | Specs complete, handoff document ready for Development |
| **I4** | Development | Backend services implemented, tests passing, security verified |
| **I8** | Development | Full integration complete, no vulnerabilities, ready to hand off |
| **T3** | Audit | GUI/UX analysis complete (skipped if no frontend) |
| **A2** | Audit | All features tested, no untested code paths |
| **A3** | Audit | Quality scorecard across 6 dimensions meets thresholds |
| **V5** | Validation | All issues mapped, correction plan approved |
| **C4** | Validation | All corrections applied and regression-tested |
| **P4** | Validation | Production hardened — monitoring, rollback, security scans pass |
| **E4** | Validation | UX polished — accessibility, visual consistency, flow verified |
| **S2** | Validation | Final release gate — everything passes, documentation complete |

Run any gate check with: `/sdlc-planning-gate-1-5`, `/sdlc-dev-gate-i4`, `/sdlc-validate-gate-s2`, etc.

---

## Specialist Agents (19)

19 specialist agents are invoked automatically during workflow execution. Each carries deep domain expertise, embedded rules (anti-slop, integrity, security), and actionable patterns — not just evaluation questions. They are installed to `~/.claude/agents/` and wired into 138 of 167 workflow skills.

### Analytical Lenses (8)

Applied during evaluation, review, and gate verification phases.

| Agent | Expertise | When Invoked |
|-------|-----------|-------------|
| **Architecture** | System design patterns, ADRs, tech stack evaluation, scalability | Planning phases 2-3, dev wave setup, Audit A3 |
| **Security** | OWASP Top 10, STRIDE/DREAD, secrets scanning, hardening | All gates, every AIOU, Audit T5, Validation P4 |
| **Quality** | Code review checklists, quality scoring (6 dimensions), anti-patterns | Dev code review, Audit A3, Validation C1-C4 |
| **Performance** | Web Vitals targets, load testing, profiling, query optimization | Audit T5, Validation P1-P3 |
| **UX** | WCAG 2.2 AA, Nielsen's heuristics, anti-slop visual rules | Audit T3, Validation E4, Wave 5 (frontend only) |
| **Operations** | Deployment checklists, FMEA, monitoring, runbooks, SLOs | Validation P1-P2, deployment workflows |
| **Requirements** | Elicitation, INVEST criteria, scope-lock enforcement, traceability | Planning phases 1-1.5, gate reviews, Audit A1-A2 |
| **Documentation** | API docs (OpenAPI), changelogs, handoff templates, ADRs | Validation S1, all handoff generation |

### Action Specialists (11)

Invoked during implementation, testing, debugging, and correction phases.

| Agent | Expertise | When Invoked |
|-------|-----------|-------------|
| **Planner** | Feature decomposition, AIOU creation, batch planning, sprint orchestration | Planning phases 1-8, correction planning |
| **Code Reviewer** | AIOU-aware review against acceptance criteria, anti-slop code rules | Every AIOU completion, post-correction review |
| **TDD Guide** | Test-first enforcement, Red-Green-Refactor, coverage analysis, test quality | Every AIOU in waves 1-6, test failures, corrections |
| **Database Specialist** | Schema design, migrations, indexing, N+1 prevention, query optimization | Wave 2, Audit T4, Validation P3 |
| **API Designer** | REST conventions, all HTTP status codes, OpenAPI, middleware, rate limiting | Wave 4, planning phase 3.5 API spec |
| **Frontend Specialist** | Component architecture, state management, anti-slop visual rules, a11y | Wave 5, UI audit/polish/retheme, Validation E4 |
| **Backend Specialist** | Service patterns, DI, clean architecture, error handling, domain logic | Wave 3, Audit A3 |
| **Build Resolver** | Minimal-diff build fixes, no architectural drift, PRH-002/003 compliance | Any build failure across all waves |
| **Gate Keeper** | All 13 gate criteria, evidence-based verification, binary PASS/FAIL | All gate verification skills |
| **Debugger** | 4-phase root cause analysis, hypothesis testing, "3+ fixes" escalation | `/debug`, Validation C1 corrections |
| **Integration Tester** | E2E test design, 8-layer verification, API contracts, regression strategy | Wave 6, Audit T4, Validation C3-C4 |

### Agent Pipeline Per Wave

During development, each AIOU follows a specialist pipeline:

| Wave | Pipeline |
|------|----------|
| Wave 1 (Types/Utils) | TDD Guide → Code Reviewer |
| Wave 2 (Data Layer) | Database Specialist → TDD Guide → Code Reviewer |
| Wave 3 (Services) | Backend Specialist → TDD Guide → Code Reviewer |
| Wave 4 (API Layer) | API Designer → TDD Guide → Code Reviewer + Security |
| Wave 5 (UI) | Frontend Specialist → UX → Code Reviewer |
| Wave 6 (Integration) | Integration Tester → Code Reviewer |

> **Technical detail**: Agent definitions live at `~/.claude/agents/sdlc-*.md` and in the plugin's `agents/` directory. Each agent carries 200-500 lines of domain expertise with embedded framework rules.

---

## Governance Modes

Automatically selected based on feature count (or manually overridden):

| Mode | Feature Count | What Changes |
|------|--------------|--------------|
| **Lightweight** | <8 features | Abbreviated pipeline — 7 gates active, combined planning phases, simplified audit |
| **Standard** | 8-25 features | Full pipeline — all 13 gates, multi-run support, full handoff documents |
| **Enterprise** | 25+ features | Full pipeline + formal ADRs, mandatory multi-run, external security/penetration testing required |

Override during init: `/sdlc-init --mode enterprise`

---

## Cycle Types

Not every change needs the full pipeline. Choose the right cycle type for your work:

| Type | Use Case | What It Runs | Command |
|------|----------|-------------|---------|
| **Full** | Initial build, major versions | All 4 councils, full planning | `/sdlc-init` |
| **Feature** | Adding 1-5 features | All 4 councils, full planning | `/sdlc-new-cycle` |
| **Patch** | Bug fixes | Planning (abbreviated) → Dev → Validation | `/sdlc-patch-planning` |
| **Maintenance** | Dependency updates, security patches, infra | Planning (abbreviated) → Dev → Validation | `/sdlc-maintenance-planning` |
| **Improvement** | Refactoring, performance, tech debt | All 4 councils, abbreviated planning | `/sdlc-improvement-planning` |

Cycle management: `/sdlc-close-cycle` archives the current cycle, `/sdlc-new-cycle` starts fresh.

---

## Knowledge Skills (245)

The framework includes 245 reference knowledge skills covering patterns, best practices, and domain expertise. These aren't invoked as slash commands — they're automatically loaded by workflow skills when relevant context is needed.

Categories include: clean code, TDD, architecture patterns, security, accessibility, API design, database patterns, performance optimization, and many more.

Browse the full index in the `knowledge/` directory.

---

## Key Concepts

### AIOUs (Atomic Implementation Output Units)

The smallest unit of work in the framework. Each feature is decomposed into AIOUs during Planning Phase 3.5. Each AIOU has:
- A specific wave assignment (1-6)
- Clear acceptance criteria
- Estimated effort
- Dependencies on other AIOUs

### Handoffs

Formal documents that transfer work between councils. Each handoff is validated against a schema to ensure nothing is lost:
- **Planning → Development**: Feature specs, AIOUs, architecture decisions
- **Development → Audit**: Implementation summary, test results, known issues
- **Audit → Validation**: Quality assessment, defect log, recommendations
- **Validation → Release**: Final certification, deployment checklist

### State Management

Per-project state persists in `.ultimate-sdlc/` across sessions:
- `project-context.md` — Current council, phase, and status (the "cursor")
- `project-manifest.md` — Persistent identity that survives cycle archives
- `council-state/` — Per-council working memory and progress
- `specs/` — Feature specs (FEAT-XXX), AIOUs (AIOU-XXX), ADRs
- `progress.md` — Append-only session history
- `feedback/` — User corrections with reasoning (see next section)
- `framework-revisions-proposed/` — Framework edit proposals awaiting user review

CLI utilities: `sdlc-state current` (show position), `sdlc-state advance` (move forward), `sdlc-state gate-check` (verify gate)

---

## Feedback-Driven Learning

The framework captures **user corrections with reasoning** as persistent feedback entries, separate from specs. Requirements describe **what** the system does; feedback describes **how** the team wants work done. They are orthogonal — gates catch what you know can break, feedback catches what the project teaches you over time.

### Storage

```
.ultimate-sdlc/feedback/
├── INDEX.md                          # Authoritative index grouped by status
├── FB-001-<slug>.md                  # Individual entries (frontmatter + body)
├── ...
└── REJECTED.md                       # Log of entries rejected at write time

.ultimate-sdlc/framework-revisions-proposed/
├── INDEX.md
├── FR-001-<slug>.md                  # Proposed edits to framework files
└── ...
```

### Four Feedback Types

| Type | When to capture |
|------|-----------------|
| `user-correction` | User corrects agent output AND provides reasoning |
| `user-preference` | User states a preference unprompted by an error |
| `gate-learning` | A quality gate fails because of a rule/process gap |
| `pattern` | Cycle-end synthesis of ≥2 recurring entries |

### Workflow Commands

| Command | Purpose | When |
|---------|---------|------|
| `/sdlc-feedback-log` | Capture a new feedback entry with required "why" reasoning | Anytime the user corrects or states a preference |
| `/sdlc-feedback-review` | Surface active entries matching current context | Session start, pre-AIOU, pre-gate (often auto-invoked) |
| `/sdlc-feedback-promote` | Cluster recurring entries into `pattern` entries | Validation Council S1 (end of cycle) |
| `/sdlc-framework-retro` | Draft proposed framework edits from patterns | `/sdlc-close-cycle` Step 6b |

### Guardrails

- **Every entry requires the user's reasoning.** No "why" → no entry. A correction without reasoning is patching, not learning (FBP-001).
- **Feedback cannot bypass INTEGRITY-RULES.** Entries that would enable PRH-001..PRH-009 violations are rejected at write time and logged to `REJECTED.md` (FR-2, FBP-004).
- **Patterns require ≥2 corroborating entries** — no single-entry promotions (FBP-005).
- **Framework self-modification is proposal-only.** `/sdlc-framework-retro` writes proposals to the project under `framework-revisions-proposed/`. Agents never write to the framework repo directory. The user reviews and applies manually (FR-3).
- **Feedback is per-project.** It does not propagate across projects (FR-4).

### Integration Points

Feedback is read at:
- Every council's Session Protocol (`/sdlc-feedback-review` auto-invoked)
- Before any AIOU in Planning phases 2.5 / 3 / 3.5 and all Development waves
- Before every gate verification
- At `/sdlc-new-cycle` bootstrap (carries forward `pattern` entries)

Feedback is written at:
- User correction or stated preference (any time)
- Gate failure caused by rule/process gap
- Validation S1 (pattern synthesis)

See `rules/feedback-rules.md` for full governance and `contexts/feedback-schema.md` for schema.

---

## UI Development Workflows

Special workflows for frontend projects with comprehensive UI lifecycle support:

| Workflow | Purpose | Command |
|----------|---------|---------|
| **UI Research** | Study design patterns, competitor analysis | `/sdlc-dev-ui-research` |
| **UI Design Plan** | Page layouts, component hierarchy, interaction maps | `/sdlc-dev-ui-design-plan` |
| **UI Audit** | Find gaps in existing UI (6 phases) | `/sdlc-dev-ui-audit` |
| **UI Polish** | Remove AI slop, improve visual quality (6 phases) | `/sdlc-dev-ui-polish` |
| **UI Retheme** | Complete visual makeover (5 phases) | `/sdlc-dev-ui-retheme` |
| **UI Redesign** | Full restart of UI development | `/sdlc-dev-ui-redesign` |

Each maintenance workflow has individually invocable phases (e.g., `/sdlc-dev-ui-audit-scan`, `/sdlc-dev-ui-audit-gaps`, `/sdlc-dev-ui-audit-fix`).

---

## Project Structure

Per-project state lives in `.ultimate-sdlc/` within your project directory:

```
.ultimate-sdlc/
├── project-manifest.md          # Persistent identity (survives cycles)
├── project-context.md           # Current council/phase/status
├── progress.md                  # Append-only session history
├── config.yaml                  # Project-specific config overrides
├── council-state/
│   ├── planning/current-state.md
│   ├── development/current-state.md
│   ├── audit/current-state.md
│   └── validation/current-state.md
├── specs/
│   ├── features/FEAT-001.md     # Feature specifications
│   ├── aious/AIOU-001.md        # Atomic implementation units
│   ├── adrs/ADR-001.md          # Architecture decision records
│   └── scope-lock.md            # Canonical in-scope feature list
├── feedback/                    # User corrections with reasoning (per-cycle)
│   ├── INDEX.md
│   ├── FB-001-<slug>.md
│   └── REJECTED.md
├── framework-revisions-proposed/ # Framework edit proposals (cross-cycle, user-reviewed)
│   ├── INDEX.md
│   └── FR-001-<slug>.md
├── handoffs/                    # Council transition documents
└── .cycles/                     # Archived cycle state
```

## Plugin Structure

```
~/ultimate-sdlc/                   # Source repo (your working copy)
├── .claude-plugin/                # Plugin manifest (plugin.json, marketplace.json)
├── setup                          # Installation script
├── SKILL.md                       # Root skill (framework overview + routing)
├── commands/                      # 167 slash command stubs (/sdlc-init, etc.)
├── skills/                        # 167 workflow skills (full instructions)
├── knowledge/                     # 245 reference knowledge skills
├── agents/                        # 19 specialist agent definitions
├── contexts/                      # Gate criteria, governance modes, state management
├── rules/                         # Anti-slop, integrity, council rules (9 files)
├── bin/                           # CLI utilities (sdlc-config, sdlc-state, etc.)
├── templates/                     # Project initialization templates
└── scripts/                       # Generator scripts
```

Installed to: `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/`

## Configuration

Global config: `~/.ultimate-sdlc/config.yaml`

```bash
# View all settings
sdlc-config list

# Change settings
sdlc-config set governance_mode enterprise
sdlc-config set project_type api-service
```

Supported project types: `web-app`, `cli-tool`, `library`, `api-service`, `ml-pipeline`, `mobile-app`

## Naming Modes

During setup you choose how commands appear:

- **Namespaced** (default, recommended): `/sdlc-init`, `/sdlc-planning-start`, `/sdlc-dev-wave-1`
- **Short**: `/init`, `/planning-start`, `/dev-wave-1`

Namespaced mode is recommended to avoid conflicts with other plugins.

## Update

```bash
cd ~/ultimate-sdlc && git pull && ./setup
```

## Uninstall

```bash
~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/bin/sdlc-uninstall
```

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI installed
- Git

## License

MIT
