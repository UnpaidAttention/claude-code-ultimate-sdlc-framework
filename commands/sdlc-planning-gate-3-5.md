---
description:  Verify Planning Gate 3.5 criteria. All features must be decomposed into AIOUs with wave assignments before proceeding.
user_invocable: false
---

**Step 0 — Load enforcement protocols**: Read `rules/integrity-enforcement.md` before verifying gate criteria.

# /sdlc-planning-gate-3-5

This command invokes the `sdlc-planning-gate-3-5` workflow skill. Use the Skill tool to load the full workflow:

```
Skill: sdlc-planning-gate-3-5
```

---

### Final Step: Log evaluation

Invoke `/sdlc-gate-log` with:
- `gate_id`: `3.5`
- `council`: `planning`
- `result`: [PASS|FAIL from gate decision above]
- `failed_criteria`: [array of criterion IDs that failed, empty if PASS]

This appends a row to `.ultimate-sdlc/gate-hit-rate.md` for retro-time analysis. Logging failure does NOT reverse the gate decision.
