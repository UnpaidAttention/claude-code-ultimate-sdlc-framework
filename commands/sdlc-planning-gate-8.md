---
description:  Verify Planning Gate 8 criteria. Final gate before transitioning to Development Council.
---

**Step 0 — Load enforcement protocols**: Read `rules/integrity-enforcement.md` before verifying gate criteria.

# /sdlc-planning-gate-8

This command invokes the `sdlc-planning-gate-8` workflow skill. Use the Skill tool to load the full workflow:

```
Skill: sdlc-planning-gate-8
```

---

### Final Step: Log evaluation

Invoke `/sdlc-gate-log` with:
- `gate_id`: `8`
- `council`: `planning`
- `result`: [PASS|FAIL from gate decision above]
- `failed_criteria`: [array of criterion IDs that failed, empty if PASS]

This appends a row to `.ultimate-sdlc/gate-hit-rate.md` for retro-time analysis. Logging failure does NOT reverse the gate decision.
