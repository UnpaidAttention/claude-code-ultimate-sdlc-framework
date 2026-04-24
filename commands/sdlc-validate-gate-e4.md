---
description:  Verify Enhancement Gate E4 criteria. All enhancements must be polished before synthesis track.
---

**Step 0 — Load enforcement protocols**: Read `rules/integrity-enforcement.md` before verifying gate criteria.

# /sdlc-validate-gate-e4

This command invokes the `sdlc-validate-gate-e4` workflow skill. Use the Skill tool to load the full workflow:

```
Skill: sdlc-validate-gate-e4
```

---

### Final Step: Log evaluation

Invoke `/sdlc-gate-log` with:
- `gate_id`: `E4`
- `council`: `validation`
- `result`: [PASS|FAIL from gate decision above]
- `failed_criteria`: [array of criterion IDs that failed, empty if PASS]

This appends a row to `.ultimate-sdlc/gate-hit-rate.md` for retro-time analysis. Logging failure does NOT reverse the gate decision.
