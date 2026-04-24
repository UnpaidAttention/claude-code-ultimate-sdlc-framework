---
description:  Verify Correction Gate C4 criteria. All corrections must be validated before production track.
---

**Step 0 — Load enforcement protocols**: Read `rules/integrity-enforcement.md` before verifying gate criteria.

# /sdlc-validate-gate-c4

This command invokes the `sdlc-validate-gate-c4` workflow skill. Use the Skill tool to load the full workflow:

```
Skill: sdlc-validate-gate-c4
```

---

### Final Step: Log evaluation

Invoke `/sdlc-gate-log` with:
- `gate_id`: `C4`
- `council`: `validation`
- `result`: [PASS|FAIL from gate decision above]
- `failed_criteria`: [array of criterion IDs that failed, empty if PASS]

This appends a row to `.ultimate-sdlc/gate-hit-rate.md` for retro-time analysis. Logging failure does NOT reverse the gate decision.
