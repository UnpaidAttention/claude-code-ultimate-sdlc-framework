---
description:  Verify Audit Gate T3 criteria. GUI analysis must be complete before proceeding.
user_invocable: false
---

**Step 0 — Load enforcement protocols**: Read `rules/integrity-enforcement.md` before verifying gate criteria.

# /sdlc-audit-gate-t3

This command invokes the `sdlc-audit-gate-t3` workflow skill. Use the Skill tool to load the full workflow:

```
Skill: sdlc-audit-gate-t3
```

---

### Final Step: Log evaluation

Invoke `/sdlc-gate-log` with:
- `gate_id`: `T3`
- `council`: `audit`
- `result`: [PASS|FAIL from gate decision above]
- `failed_criteria`: [array of criterion IDs that failed, empty if PASS]

This appends a row to `.ultimate-sdlc/gate-hit-rate.md` for retro-time analysis. Logging failure does NOT reverse the gate decision.
