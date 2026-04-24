# Gate Hit-Rate Schema

**Purpose**: Track which gate criteria actually catch defects over time. Data feeds `/sdlc-framework-retro` to propose retiring criteria that never fail.

**Storage**: `.ultimate-sdlc/gate-hit-rate.md` (per-project, appended per gate evaluation).

## Entry Format

Each gate evaluation appends one row to the tracker:

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| gate_id | string | yes | e.g. `1.5`, `I4`, `A3`, `V5`, `S2` |
| council | enum | yes | planning \| development \| audit \| validation |
| cycle_id | string | yes | From project-manifest.md, e.g. `cycle-001` |
| timestamp | ISO-8601 | yes | When verification completed |
| result | enum | yes | PASS \| FAIL |
| failed_criteria | array | if FAIL | List of criterion IDs that failed |
| iteration | integer | yes | Which attempt at this gate in this cycle (1 for first try, 2 for retry after fix) |

## Aggregate Metrics

Derived at retro time:

- `times_evaluated[gate_id][criterion_id]` — total evaluations across all cycles
- `times_failed[gate_id][criterion_id]` — total failures
- `hit_rate[gate_id][criterion_id]` = failures / evaluations
- `last_failure_cycle[gate_id][criterion_id]` — most recent cycle where criterion failed
- `never_failed[gate_id][criterion_id]` — boolean, true if times_failed == 0

## Retirement Candidate Criteria

A criterion is a retirement candidate when:
- `times_evaluated >= 5` (enough data) AND
- `hit_rate == 0` (never caught anything) AND
- `last_failure_cycle == null`

Retirement is proposed, not automatic. `/sdlc-framework-retro` surfaces candidates for user review.
