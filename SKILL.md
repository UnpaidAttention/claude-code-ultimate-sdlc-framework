---
name: antigravity
description: |
  Antigravity Ultimate SDLC Framework for Claude Code. A structured, gate-driven,
  multi-council orchestration system for AI-assisted software development.
  Manages the full lifecycle: Planning → Development → Audit → Validation.
  Use /ag-help for available commands, /init to start a new project,
  /status to check progress, /continue to auto-advance.
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

# Antigravity Ultimate SDLC Framework

## Overview

A structured, gate-driven, multi-council orchestration system for AI-assisted software development.

### Four Councils
1. **Planning** — Requirements to specifications (Phases 1-8, Gates 1.5/3.5/8)
2. **Development** — Specifications to implementation (Waves 0-6, Gates I4/I8)
3. **Audit** — Implementation to quality assessment (Tracks T/A/E, Gates T3/A2/A3)
4. **Validation** — Assessment to release readiness (Tracks V/C/P/E/S, Gates V5/C4/P4/E4/S2)

### Quick Start
- `/init` — Initialize a new project
- `/adopt` — Onboard an existing codebase
- `/status` — Check current progress
- `/continue` — Auto-advance to next step
- `/ag-help` — Full command reference

### Lifecycle Commands
- `/new-cycle` — Start a new development cycle
- `/close-cycle` — Archive current cycle
- `/planning-start` — Begin Planning Council
- `/dev-start` — Begin Development Council
- `/audit-start` — Begin Audit Council
- `/validate-start` — Begin Validation Council

### Governance Modes
- **Lightweight** (<8 features) — Abbreviated pipeline
- **Standard** (8-25 features) — Full pipeline
- **Enterprise** (25+ features) — Full pipeline + formal ADRs + external scans

## Routing

When the user's request matches one of these patterns, invoke the corresponding skill:

| User Intent | Invoke |
|---|---|
| Start new project | `/init` |
| Adopt existing code | `/adopt` |
| Check status/progress | `/status` |
| Continue working | `/continue` |
| Start planning | `/planning-start` |
| Start development | `/dev-start` |
| Start audit | `/audit-start` |
| Start validation | `/validate-start` |
| New cycle | `/new-cycle` |
| Ship/release | `/release` |

## Utility Scripts

The following CLI utilities are available at `~/.claude/skills/antigravity/bin/`:

| Script | Purpose |
|---|---|
| `ag-config` | Read/write global config (`~/.antigravity/config.yaml`) |
| `ag-state` | Per-project state management (`.antigravity/`) |
| `ag-uninstall` | Clean removal of all installed components |
| `ag-patch-names` | Toggle between short and namespaced skill names |

## State Management

### Global State (`~/.antigravity/`)
- `config.yaml` — Global settings (naming mode, governance, telemetry)
- `analytics/` — Usage analytics
- `sessions/` — Session history

### Project State (`.antigravity/`)
- `project-manifest.md` — Persistent project identity and cycle history
- `project-context.md` — Current council, phase, and status
- `progress.md` — Checkbox tracker for all phases and gates
- `council-state/` — Per-council state files
- `specs/` — Feature specs, AIOUs, and ADRs
- `handoffs/` — Inter-council handoff documents
- `.cycles/` — Archived cycle state
