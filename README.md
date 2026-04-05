# Antigravity SDLC Framework for Claude Code

A structured, gate-driven, multi-council orchestration system for AI-assisted software development. Manages the full lifecycle from requirements through deployment: **Planning → Development → Audit → Validation**.

167 workflow commands, 240 knowledge skills, 8 focus lens agents, 13 quality gates.

## Install

```bash
git clone https://github.com/UnpaidAttention/antigravity-claude-code.git ~/.claude/skills/antigravity && cd ~/.claude/skills/antigravity && ./setup
```

That's it. All `/commands` are now available in Claude Code.

## Quick Start

In any Claude Code session:

```
/init              # Initialize a new project
/planning-start    # Begin the Planning Council
/status            # Check current progress
/continue          # Auto-advance to next step
/ag-help           # Full command reference
```

## What It Does

The framework orchestrates AI-assisted development through four sequential councils, each with phases, gates, and specialized workflows:

| Council | Purpose | Key Commands |
|---------|---------|--------------|
| **Planning** | Requirements → specifications | `/planning-start`, `/planning-phase-3`, `/planning-gate-8` |
| **Development** | Specifications → implementation | `/dev-start`, `/dev-wave-3`, `/dev-gate-i8` |
| **Audit** | Implementation → quality assessment | `/audit-start`, `/audit-t2`, `/audit-gate-a3` |
| **Validation** | Assessment → release readiness | `/validate-start`, `/validate-c1`, `/validate-gate-s2` |

### Quality Gates (13 total)

Binary pass/fail checkpoints that block progression:

- **Planning**: Gate 1.5 (feature completeness), Gate 3.5 (AIOU decomposition), Gate 8 (launch ready)
- **Development**: Gate I4 (services complete), Gate I8 (pre-deployment)
- **Audit**: Gate T3 (GUI analysis), Gate A2 (completeness), Gate A3 (quality assessment)
- **Validation**: Gate V5, C4, P4, E4, S2 (release ready)

### Governance Modes

Automatically selected based on feature count:

| Mode | Features | Pipeline |
|------|----------|----------|
| **Lightweight** | <8 | Abbreviated (7 gates) |
| **Standard** | 8-25 | Full pipeline (13 gates) |
| **Enterprise** | 25+ | Full + ADRs + external scans |

### Focus Lens Agents

8 analytical perspectives available as subagents:

- `ag-architecture` — System structure, API design, scalability
- `ag-security` — Threat modeling, OWASP, secrets
- `ag-quality` — Test coverage, code review, defects
- `ag-performance` — Profiling, optimization, benchmarks
- `ag-ux` — Usability, accessibility, design
- `ag-operations` — Deployment, monitoring, failure modes
- `ag-requirements` — Feature completeness, scope
- `ag-documentation` — Technical docs, guides

## Cycle Types

| Type | Use Case | Command |
|------|----------|---------|
| **Full** | Initial build, major versions | `/init` |
| **Feature** | Adding 1-5 features | `/new-cycle` |
| **Patch** | Bug fixes | `/patch-planning` |
| **Maintenance** | Dependencies, security, infra | `/maintenance-planning` |
| **Improvement** | Refactoring, performance, tech debt | `/improvement-planning` |

## Project Structure

Per-project state lives in `.antigravity/` within your project directory:

```
.antigravity/
├── project-manifest.md          # Persistent identity
├── project-context.md           # Current council/phase/status
├── progress.md                  # Session history
├── config.yaml                  # Project-specific config
├── council-state/               # Per-council state
├── specs/                       # Feature specs, AIOUs, ADRs
├── handoffs/                    # Council transition documents
└── .cycles/                     # Archived cycle state
```

## Plugin Structure

```
~/.claude/skills/antigravity/
├── setup                        # One-time installation script
├── SKILL.md                     # Root skill (framework overview)
├── bin/                         # CLI utilities
│   ├── ag-config                # Config reader/writer
│   ├── ag-state                 # State management
│   ├── ag-uninstall             # Clean removal
│   └── ag-patch-names           # Prefix patching
├── workflows/                   # 167 invokable workflow skills
├── knowledge/                   # 240 reference knowledge skills
├── agents/                      # 8 focus lens agents
├── context/                     # Framework context files
├── rules/                       # Governance rules
├── templates/                   # Project initialization templates
├── scripts/                     # Generator scripts
└── references/                  # On-demand reference docs
```

## Configuration

Global config: `~/.antigravity/config.yaml`

```bash
# View config
~/.claude/skills/antigravity/bin/ag-config list

# Change settings
~/.claude/skills/antigravity/bin/ag-config set governance_mode enterprise
```

## Naming Modes

During setup you can choose:

- **Short** (default): `/init`, `/planning-start`, `/dev-wave-1`
- **Namespaced**: `/ag-init`, `/ag-planning-start`, `/ag-dev-wave-1`

Namespaced mode avoids conflicts if you have other skills with similar names.

## Update

```bash
cd ~/.claude/skills/antigravity && git pull && ./setup
```

## Uninstall

```bash
~/.claude/skills/antigravity/bin/ag-uninstall
```

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI installed
- Git

## License

MIT
