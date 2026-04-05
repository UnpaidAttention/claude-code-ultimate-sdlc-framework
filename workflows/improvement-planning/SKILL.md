---
name: improvement-planning
description: |
  Abbreviated planning for improvement cycles. Analyzes code quality, identifies refactoring targets, creates improvement AIOUs for tech debt, performance, and architecture.
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

## Preamble (run first)

```bash
# Detect project state
AG_HOME="${HOME}/.antigravity"
AG_PROJECT=".antigravity"
AG_SKILLS="${HOME}/.claude/skills/antigravity"

# Check if project is initialized
if [ -d "$AG_PROJECT" ]; then
  echo "PROJECT: initialized"
  # Read current state
  if [ -f "$AG_PROJECT/project-context.md" ]; then
    COUNCIL=$(grep -A1 "## Active Council" "$AG_PROJECT/project-context.md" | tail -1 | tr -d ' ')
    PHASE=$(grep -A1 "## Current Phase" "$AG_PROJECT/project-context.md" | tail -1 | tr -d ' ')
    STATUS=$(grep -A1 "## Status" "$AG_PROJECT/project-context.md" | tail -1 | tr -d ' ')
    echo "COUNCIL: $COUNCIL"
    echo "PHASE: $PHASE"  
    echo "STATUS: $STATUS"
  fi
else
  echo "PROJECT: not initialized (run /init first)"
fi

# Read global config
if [ -f "$AG_HOME/config.yaml" ]; then
  GOV_MODE=$(grep "governance_mode:" "$AG_HOME/config.yaml" | awk '{print $2}')
  PROJ_TYPE=$(grep "project_type:" "$AG_HOME/config.yaml" | awk '{print $2}')
  echo "GOVERNANCE: ${GOV_MODE:-standard}"
  echo "PROJECT_TYPE: ${PROJ_TYPE:-web-app}"
fi
```

After the preamble runs, use the detected state to verify prerequisites for this workflow.

## Knowledge Skills

Load these knowledge skills for reference during this workflow:
- Read `~/.claude/skills/antigravity/knowledge/architecture-principles/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/clean-code/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/performance-optimization/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/requirements-engineering/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# /improvement-planning - Improvement Cycle Planning

---

## Lens / Skills / Model
**Lens**: `[Architecture]` | **Model**: Claude Opus 4
> Apply RARV cycle, session protocol per council-development.md

## Arguments
| Argument | Required | Description |
|----------|----------|-------------|
| (none) | — | Session auto-detects state |

---

## Purpose

Abbreviated planning workflow for **Improvement cycles** — focused on code quality improvements, refactoring, performance optimization, and technical debt reduction without the full 8-phase planning process.

**This replaces the full Planning Council for Improvement cycle types.** It produces a `planning-handoff.md` compatible with existing development workflows.

**Pipeline**: `/improvement-planning` → `/dev-scope-analysis` → `/dev-start` → ... → `/audit-start` → ... → `/validate-start` → ...

**All Councils Active**: Improvements go through Audit to verify no behavioral regressions.

---

## Pre-Conditions

- `.antigravity/project-context.md` must exist with `Cycle Type: Improvement`
- `cycle-baseline.md` must exist (created by `/new-cycle`)
- `.antigravity/project-manifest.md` must exist

---

## Workflow

### Step 1: Identify Improvement Scope

Ask user what improvements are needed:

Use **Display Template** from `council-development.md` to show: Improvement Planning

### Step 2: Current State Analysis

Based on the improvement type:

#### For Refactoring:
1. Identify target code areas
2. Map current structure and dependencies
3. Identify code smells (duplication, god classes, long methods, etc.)
4. Define target structure
5. Assess refactoring risk (what could break?)

#### For Performance:
1. Identify performance bottlenecks (if user reports them) or run profiling
2. Measure current baselines (load time, response time, memory, bundle size)
3. Identify optimization opportunities
4. Estimate improvement potential

#### For Tech Debt:
1. Review previous audit quality scorecard (if available in `.cycles/`)
2. Identify highest-impact debt items
3. Map dependencies between debt items
4. Prioritize by impact-to-effort ratio

#### For Architecture Evolution:
1. Document current architecture (from ADRs and code)
2. Define target architecture
3. Identify migration steps
4. Assess backwards compatibility requirements

Document findings:

Use **Display Template** from `council-development.md` to show: Current State Analysis

### Step 3: Create Improvement AIOUs

For each improvement item, create an AIOU:

Use **Display Template** from `council-development.md` to show: AIOU-IMP-001: [Improvement Title]

### Step 4: Architecture Review (Light)

If any improvement requires architectural changes:

1. Create or update ADR:
   Use **Display Template** from `council-development.md` to show: ADR-XXX: [Architecture Evolution]

2. Verify consistency with existing ADRs

### Step 5: Generate Planning Handoff

Create `handoffs/planning-handoff.md`:

Use **Display Template** from `council-development.md` to show: Planning Handoff — Improvement Cycle

### Step 6: Update State

1. Update `.antigravity/project-context.md`: Mark Planning complete (abbreviated)
2. Update `.antigravity/council-state/planning/current-state.md`: All phases complete
3. Update `.antigravity/progress.md` with planning session summary

### Step 7: Route to Development

Use **Display Template** from `council-development.md` to show: Improvement Planning Complete
Improvement Planning [DONE] → Development [ ] → Audit [ ] → Validation [ ] → Close Cycle

---
