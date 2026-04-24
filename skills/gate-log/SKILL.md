---
name: gate-log
description: Append a single evaluation row to .ultimate-sdlc/gate-hit-rate.md. Called internally by every gate verification workflow.
---

# Gate Log Skill

## Invocation Context

Called as the final step of every `/sdlc-*-gate-*` workflow, AFTER the gate decision (PASS/FAIL) has been written to the gate report.

## Inputs (from calling workflow context)

- `gate_id`: e.g. `1.5`, `I4`, `A3`, `V5`, `S2`
- `council`: planning | development | audit | validation
- `result`: PASS | FAIL
- `failed_criteria`: array of criterion IDs (empty if PASS)

## Steps

1. Read `.ultimate-sdlc/project-manifest.md` → extract current `cycle_id`.
2. Read `.ultimate-sdlc/council-state/<council>/current-state.md` → extract iteration count for this gate (default to 1 if not found).
3. Generate ISO-8601 timestamp.
4. Append one row to `.ultimate-sdlc/gate-hit-rate.md` under `## Evaluations`. If file does not exist, initialize from `templates/gate-hit-rate-tracker.md` first.
5. Return silently — no user-facing output unless write failed.

## Error Handling

If `.ultimate-sdlc/gate-hit-rate.md` write fails, log to WORKING-MEMORY.md and continue. Hit-rate logging is best-effort; it MUST NOT block gate completion.

## No Side Effects on Gate Decision

This skill NEVER changes the gate result. It only records it.
