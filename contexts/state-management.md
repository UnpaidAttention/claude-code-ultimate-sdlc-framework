# State Management Protocol

## Purpose

Authoritative state sources, update timing, and sync rules to prevent state conflicts.

---

## Cycle System Overview

The framework supports **iterative development** through cycles. Each cycle has its own state files.

- **`.ultimate-sdlc/project-manifest.md`** — Persistent project identity (survives all cycles)
- **`.ultimate-sdlc/project-context.md`** — Active cycle state (archived between cycles)
- **Cycle types**: Full, Feature, Patch, Maintenance, Improvement
- **`/new-cycle`** archives previous state, creates fresh files
- **`/close-cycle`** archives completed cycle into `.cycles/`

**Lifecycle**: `/init` (once) → `/planning-start` → ... → `/close-cycle` → `/new-cycle` → ... (repeat)

**Between cycles** (after `/close-cycle`, before `/new-cycle`):
- `.ultimate-sdlc/project-manifest.md` exists (persistent)
- `.ultimate-sdlc/project-context.md` does NOT exist (archived)
- `.ultimate-sdlc/specs/` contains accumulated specifications
- `.cycles/` contains archived state

---

## Quick Reference

| Question | File to Read/Update |
|----------|---------------------|
| Where am I? (council, phase) | `.ultimate-sdlc/project-context.md` |
| What project is this? | `.ultimate-sdlc/project-manifest.md` |
| What cycle am I in? | `.ultimate-sdlc/project-context.md` → Cycle Information |
| What's done in this council? | `.ultimate-sdlc/council-state/{council}/current-state.md` |
| What am I doing right now? | `.ultimate-sdlc/council-state/{council}/WORKING-MEMORY.md` |
| Key decisions & patterns? | `project-intelligence.md` |
| What runs exist? | `.ultimate-sdlc/council-state/{council}/run-tracker.md` |
| What happened historically? | `.ultimate-sdlc/progress.md` (current cycle) |
| Previous cycles? | `.cycles/cycle-NNN/.ultimate-sdlc/progress.md` |
| Active cycle? | `.ultimate-sdlc/project-context.md` exists = yes |

## State Update Cheat Sheet

| Event | Update This File | Content |
|-------|------------------|---------|
| Significant action completed | WORKING-MEMORY.md | Add to "Completed This Session" |
| Phase/wave completed | current-state.md AND .ultimate-sdlc/project-context.md | Mark phase complete, update position |
| Run item completed | run-tracker.md | Check off item |
| Session ending | WORKING-MEMORY.md AND .ultimate-sdlc/progress.md | Final state + session summary |
| Key decision made | project-intelligence.md | One-line summary of decision |
| Council transition | .ultimate-sdlc/project-context.md | Change Active Council |
| Cycle complete | Run `/close-cycle` | Archives all state |
| Starting new cycle | Run `/new-cycle` | Creates fresh state files |

---

## State File Hierarchy

```
AUTHORITATIVE (Source of Truth)
├── .ultimate-sdlc/project-context.md              ← Position, metadata (update after phase complete)
├── project-intelligence.md         ← Key decisions & patterns (update at phase boundaries)
├── .ultimate-sdlc/council-state/{council}/
│   ├── current-state.md            ← Council progress (update after phase in council)
│   └── run-tracker.md              ← Run progress, multi-run only (update after each item)
│                                      CREATED BY: /dev-scope-analysis
SESSION STATE
├── .ultimate-sdlc/council-state/{council}/
│   └── WORKING-MEMORY.md           ← In-progress tasks (update after each action)
HISTORICAL (Append-Only)
└── .ultimate-sdlc/progress.md                     ← Session summaries (update at session end only)
```

---

## Update Timing Rules

### .ultimate-sdlc/project-context.md (Authoritative)
**Update AFTER**: Completing phase/wave/track, passing gate, council transition, session end (if phase changed).
**Content**: Active Council, Current Phase/Wave/Track, Last Updated, Status (in_progress/complete).

### .ultimate-sdlc/council-state/{council}/current-state.md
**Update AFTER**: Completing any phase, passing a gate, significant milestone within phase.
**Content**: Phase checklist status, key decisions, artifacts produced.

### run-tracker.md (Development Multi-Run)
**Created BY**: `/dev-scope-analysis`
**Update AFTER**: Completing each AIOU, completing each wave, passing gate, marking run COMPLETED.
**Content**: Checklist status (⏳ → ✅), phase/wave progress, gate evidence.
**Run Completion**: All items ✅ → all columns Complete → gate passed → verification checked → status COMPLETED.

### WORKING-MEMORY.md
**Update AFTER**: Each significant action, starting/completing tasks, encountering blockers.
**Content**: In Progress, Completed This Session, Blockers, Session Learnings.
**RESET**: At session start (clear Completed This Session), at phase transition (archive to .ultimate-sdlc/progress.md).

### .ultimate-sdlc/progress.md (Historical Log)
**Update AFTER**: Phase/wave/track marked Complete, gate passed, council transition.
**Content**: Summary of completed work from WORKING-MEMORY.md.

---

## State Sync Protocol

### Session Start
1. Read `.ultimate-sdlc/project-context.md` → current position
2. Read `project-intelligence.md` → key decisions & patterns (**fast context rebuild** — 80% of context at 10% cost)
3. Read `current-state.md` → council progress
4. Read `WORKING-MEMORY.md` → last session state
5. Read `run-tracker.md` → multi-run mode? Current run, items (if Development Council)
6. If incomplete tasks → resume or verify
7. Clear "Completed This Session"
8. Begin work

### Session End

**Triggers** (execute Session End Protocol when ANY is true):

| Trigger | Action |
|---------|--------|
| Explicit end (user says: goodbye, done, stopping, checkpoint) | END SESSION |
| Council/run complete (all phases/waves done) | END SESSION before announcing |
| Terminal gate passed (Gate 8, I8, or council-final) | END SESSION after documenting |
| Context warning (>10 substantial files loaded) | END SESSION after current action |
| Different PROJECT (not just different feature) | END SESSION, then start new |

**Continue working** (NOT end triggers): Different feature same project, clarifying questions, additional requirements, recoverable errors.

**Session Overflow**: If context degrading → 1. Write WORKING-MEMORY.md (highest priority), 2. Update current-state.md + .ultimate-sdlc/project-context.md, 3. Append to .ultimate-sdlc/progress.md, 4. End session.

**Session End Protocol**:
1. Update WORKING-MEMORY.md with final state
2. If phase completed → update current-state.md + .ultimate-sdlc/project-context.md
3. Append session summary to .ultimate-sdlc/progress.md
4. Commit state files

### Phase Transition
1. Verify current phase complete (check gate if applicable)
2. Update current-state.md
3. Update .ultimate-sdlc/project-context.md with new phase
4. Reset WORKING-MEMORY.md sections
5. Announce next phase

### Council Transition
1. Verify current council complete (final gate passed)
2. Generate handoff document
3. Update .ultimate-sdlc/project-context.md (new council, starting position)
4. Create new council's current-state.md
5. Announce transition

---

## Conflict Resolution

### State file conflicts
**Priority**: .ultimate-sdlc/project-context.md > current-state.md > WORKING-MEMORY.md > .ultimate-sdlc/progress.md

1. Trust .ultimate-sdlc/project-context.md for position
2. Verify against current-state.md
3. If mismatch → use more conservative position (earlier phase)
4. Document conflict in .ultimate-sdlc/progress.md

### Session interrupted mid-update
1. Read last completed task from WORKING-MEMORY.md
2. Verify work was actually done
3. Mark complete if done, resume if not
4. Document recovery in .ultimate-sdlc/progress.md

---

## State File Templates

### .ultimate-sdlc/project-context.md
```markdown
## Current Position
**Active Council**: [Planning | Development | Audit | Validation]
**Current Phase/Wave/Track**: [position]
**Status**: [in_progress | complete]
**Last Updated**: [YYYY-MM-DD HH:MM]
```

### WORKING-MEMORY.md
```markdown
## Session: [YYYY-MM-DD]

### In Progress
- [ ] [Current task]

### Completed This Session
- [x] [Task 1]

### Blockers
- [Blocker description if any]

### Session Learnings
- [Insight gained]

### Files Loaded
- [ ] ~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/rules/UNIVERSAL-RULES.md
- [ ] (workflow file)
- [ ] (skill files as loaded)
(N substantial files — Status: GREEN/YELLOW/RED)

> `.memory/` and `.metrics/` populate over time. If missing, skip memory steps. Do NOT create placeholders.
```

### .ultimate-sdlc/progress.md
```markdown
---
## Session: [YYYY-MM-DD HH:MM]
**Phase**: [Phase/Wave/Track]

### Accomplished
- [Item 1]

### Decisions Made
- [Decision and rationale]

### Next Steps
- [What to do next]
```

---

## Cycle State Management

### .ultimate-sdlc/project-context.md — Cycle Information
```markdown
## Cycle Information
- **Cycle**: cycle-NNN-slug
- **Cycle Type**: Full / Feature / Patch / Maintenance / Improvement
- **Cycle Intent**: [description]
- **Cycle Started**: [date]
- **Active Councils**: [list]
```

Created by `/init` (cycle-001) or `/new-cycle` (subsequent).

### Cycle Archival (by /close-cycle)

**MOVED to `.cycles/cycle-NNN-slug/`**: .ultimate-sdlc/project-context.md, .ultimate-sdlc/progress.md, cycle-baseline.md, .ultimate-sdlc/council-state/, .ultimate-sdlc/handoffs/, .memory/, .metrics/

**PERSIST across cycles** (never moved): .ultimate-sdlc/project-manifest.md, product-concept.md, .ultimate-sdlc/specs/, source code, framework files (~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/)

### Cycle State Resolution
1. `.ultimate-sdlc/project-context.md` exists → active cycle
2. Only `.ultimate-sdlc/project-manifest.md` → between cycles
3. Neither → not initialized

### .ultimate-sdlc/project-manifest.md (Persistent)
Created by `/init` or `/adopt`. Updated by `/close-cycle` (adds cycle history) and `/new-cycle` (sets active cycle). Contains: project identity, cycle history, feature inventory reference, technical debt, learnings reference.

### Cycle Baseline (by /new-cycle, non-initial cycles)
`cycle-baseline.md` — Summarizes existing architecture, features, tech debt, learnings from previous cycles. Replaces `product-concept.md` as starting context (both may be referenced).
