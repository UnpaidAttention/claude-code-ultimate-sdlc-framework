# Ultimate SDLC Framework for Claude Code

A structured, gate-driven, multi-council orchestration system for AI-assisted software development. Manages the full lifecycle from requirements through deployment: **Planning → Development → Audit → Validation**.

167 workflow commands, 240 knowledge skills, 8 focus lens agents, 13 quality gates, 5 cycle types.

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

## Focus Lens Agents

8 analytical perspectives that can be applied individually or in combination during any workflow. These are **not** slash commands — they are subagent definitions installed to `~/.claude/agents/` that Claude invokes automatically during relevant workflow phases, or on demand when you ask for a specific analysis.

**How to use them**: Ask Claude to apply a lens directly:
- "Apply the security lens to this code"
- "Run the architecture agent on this design"
- "Analyze this feature with the quality lens"
- "What does the operations lens say about this deployment plan?"

Claude will invoke the appropriate agent as a subagent via the Agent tool.

| Lens | What It Analyzes | Key Questions | When Used |
|------|-----------------|---------------|-----------|
| **Architecture** | System structure, API design, data models, dependencies, scalability | "Is this the right structure? Does it scale? Are dependencies managed?" | Planning phases 2-3, dev wave setup |
| **Security** | Threat modeling, input validation, auth, secrets, OWASP Top 10 | "What could be exploited? Are inputs validated? Are secrets exposed?" | All gates, every AIOU, Audit T5, Validation P3-P4 |
| **Quality** | Test coverage, code review, defect analysis, completeness, regression | "Is this tested? What edge cases exist? Does this match the spec?" | Dev code review, Audit T1-T4/A1-A3, Validation C1-C4 |
| **Performance** | Profiling, optimization, benchmarks, resource usage, throughput | "Is this fast enough? Where are the bottlenecks? What's the memory footprint?" | Audit T5, Validation P1-P3 |
| **UX** | Usability, accessibility, navigation, visual design, user journeys | "Can users accomplish their goals? Is this accessible? Is the flow intuitive?" | Audit T3, Validation E1-E4 (frontend projects only) |
| **Operations** | Deployment, monitoring, failure modes, runbooks, rollback | "What happens when this fails? Is it observable? Can we roll back?" | Validation P1-P2, deployment workflows |
| **Requirements** | Feature completeness, user stories, acceptance criteria, scope | "Is every requirement captured? What's missing? Does this solve the user's problem?" | Planning phases 1-1.5, gate reviews |
| **Documentation** | Technical docs, user guides, API references, handoff completeness | "Would someone new understand this? Is the handoff complete? Are docs current?" | Validation S1, all handoff generation |

**Lenses combine**: During development, `[Security] + [Quality]` is automatically applied to every AIOU. For Wave 5 UI work, `[UX] + [Quality] + [Security]` all apply simultaneously.

> **Technical detail**: Agent definitions live at `~/.claude/agents/sdlc-*.md`. They are installed by the `./setup` script and persist across all sessions.

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

## Knowledge Skills (240)

The framework includes 240 reference knowledge skills covering patterns, best practices, and domain expertise. These aren't invoked as slash commands — they're automatically loaded by workflow skills when relevant context is needed.

Categories include: clean code, TDD, architecture patterns, security, accessibility, API design, database patterns, performance optimization, and many more.

Browse the full index: `~/.claude/skills/ultimate-sdlc/knowledge/INDEX.md`

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

CLI utilities: `sdlc-state current` (show position), `sdlc-state advance` (move forward), `sdlc-state gate-check` (verify gate)

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
├── handoffs/                    # Council transition documents
└── .cycles/                     # Archived cycle state
```

## Plugin Structure

```
~/.claude/skills/ultimate-sdlc/
├── setup                        # One-time installation script
├── SKILL.md                     # Root skill (framework overview + routing)
├── bin/
│   ├── sdlc-config              # Read/write global config
│   ├── sdlc-state               # Project state management
│   ├── sdlc-uninstall           # Clean removal
│   └── sdlc-patch-names         # Toggle short/namespaced naming
├── skills/                      # 167 invokable workflow skills
├── knowledge/                   # 240 reference knowledge skills
├── agents/                      # 8 focus lens agent definitions
├── context/                     # Gate criteria, governance modes, state management
├── rules/                       # Universal rules, integrity rules, council rules
├── templates/                   # Project initialization templates
├── scripts/                     # Generator scripts (gen-skill-docs.sh)
└── references/                  # On-demand reference documentation
```

## Configuration

Global config: `~/.ultimate-sdlc/config.yaml`

```bash
# View all settings
~/.claude/skills/ultimate-sdlc/bin/sdlc-config list

# Change settings
~/.claude/skills/ultimate-sdlc/bin/sdlc-config set governance_mode enterprise
~/.claude/skills/ultimate-sdlc/bin/sdlc-config set project_type api-service
```

Supported project types: `web-app`, `cli-tool`, `library`, `api-service`, `ml-pipeline`, `mobile-app`

## Naming Modes

During setup you choose how commands appear:

- **Short** (default): `/init`, `/planning-start`, `/dev-wave-1`
- **Namespaced**: `/sdlc-init`, `/sdlc-planning-start`, `/sdlc-dev-wave-1`

Namespaced mode is recommended if you have other plugins that might conflict (e.g., a `/init` from another tool).

## Update

```bash
cd ~/ultimate-sdlc && git pull && ./setup
```

## Uninstall

```bash
~/.claude/skills/ultimate-sdlc/bin/sdlc-uninstall
```

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI installed
- Git

## License

MIT
