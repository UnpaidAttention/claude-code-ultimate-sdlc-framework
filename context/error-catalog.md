# Error Catalog

Centralized error codes and recovery procedures.

---

## Error Code Format

`ERR-{CATEGORY}-{NUMBER}` — Categories: INIT, STATE, GATE, SKILL, HANDOFF, WORKFLOW, CYCLE

---

## Initialization Errors (ERR-INIT-*)

### ERR-INIT-001: Missing product-concept.md
**Recovery**: Run `/init` (supports guided creation) or create `product-concept.md` manually, then re-run `/init`.

### ERR-INIT-002: Missing Required Template
**Recovery**: STOP. Restore template from framework source, re-run `/init`.

### ERR-INIT-003: Malformed Product Concept
**Recovery**: Verify `product-concept.md` has name, description, profile. Fix and re-run `/init`.

---

## State Errors (ERR-STATE-*)

### ERR-STATE-001: Missing .antigravity/project-context.md
**Recovery**: Run `/init` to create project context.

### ERR-STATE-002: Corrupted .antigravity/project-context.md
**Recovery**: Run `/recover`. If fails, recreate from .antigravity/progress.md history.

### ERR-STATE-003: State Inconsistency
**Recovery**: Run `/recover`. .antigravity/project-context.md is authoritative; council state derived from it.

### ERR-STATE-004: Session Interrupted
**Recovery**: Read WORKING-MEMORY.md → verify in-progress work → complete or rollback → continue.

---

## Gate Errors (ERR-GATE-*)

### ERR-GATE-001: Security Checklist Failed
**Recovery**: Log in WORKING-MEMORY.md → fix security issue → re-run entire checklist.

### ERR-GATE-002: Prerequisite Not Met
**Recovery**: Complete prerequisite phase/task, then re-attempt gate.

### ERR-GATE-003: TBD Items Found
**Recovery**: Search for "TBD" in specs → replace with values or DEFERRED pattern → re-attempt.

---

## Skill Errors (ERR-SKILL-*)

### ERR-SKILL-001: Skill Not Found
**Recovery**: Log in WORKING-MEMORY.md, continue with remaining skills. Notify user if critical.

### ERR-SKILL-002: Skill Limit Exceeded
**Recovery**: Review loaded skills, unload non-essential, load critical skill.

### ERR-SKILL-003: Circular Skill Dependency
**Recovery**: Check skill-dependencies.md for order, load in dependency order, skip already-loaded.

---

## Handoff Errors (ERR-HANDOFF-*)

### ERR-HANDOFF-001: Handoff Not Found
**Recovery**: Complete prerequisite council. If lost, regenerate from council state files.

### ERR-HANDOFF-002: Handoff Validation Failed
**Recovery**: Complete missing section, re-validate before proceeding.

---

## Workflow Errors (ERR-WORKFLOW-*)

### ERR-WORKFLOW-001: Agent Not Found
**Recovery**: Check filename, use fallback agent, notify user if no fallback.

### ERR-WORKFLOW-002: Context Budget Exceeded
**Recovery**: Summarize state to WORKING-MEMORY.md → end session → start new session.

---

## Cycle Errors (ERR-CYCLE-*)

### ERR-CYCLE-001: No Active Cycle
**Recovery**: Run `/new-cycle` (or `/init` for first cycle).

### ERR-CYCLE-002: Cycle Already Active
**Recovery**: Run `/close-cycle` first, then `/new-cycle`. Use `--force` if stuck.

### ERR-CYCLE-003: Cycle Archive Failed
**Recovery**: Verify `.cycles/` exists and is writable, check for conflicts, retry `/close-cycle`.

---

## Usage

On error: Match code → display message → follow recovery → log in WORKING-MEMORY.md.
