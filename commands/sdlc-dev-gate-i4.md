---
description:  Verify Development Gate I4 criteria. Backend must be complete before proceeding to UI development.
user_invocable: false
---

**Step 0 — Load enforcement protocols**: Read `rules/integrity-enforcement.md` before verifying gate criteria.

# /sdlc-dev-gate-i4

This command invokes the `sdlc-dev-gate-i4` workflow skill. Use the Skill tool to load the full workflow:

```
Skill: sdlc-dev-gate-i4
```

---

### Final Step: Log evaluation

Invoke `/sdlc-gate-log` with:
- `gate_id`: `I4`
- `council`: `development`
- `result`: [PASS|FAIL from gate decision above]
- `failed_criteria`: [array of criterion IDs that failed, empty if PASS]

This appends a row to `.ultimate-sdlc/gate-hit-rate.md` for retro-time analysis. Logging failure does NOT reverse the gate decision.
