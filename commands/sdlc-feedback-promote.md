---
description: Synthesize recurring feedback entries into pattern entries at cycle end. Invoked during Validation Council S1 phase. Requires at least 2 corroborating entries per pattern.
user_invocable: true
---

# /sdlc-feedback-promote

This command invokes the `sdlc-feedback-promote` workflow skill. Use the Skill tool to load the full workflow:

```
Skill: sdlc-feedback-promote
```

## When to Invoke

**Cycle-end (original)**: During Validation S1 (Documentation Update) phase.

**Mid-cycle (new)**: When ≥3 active `user-correction` or `user-preference` entries cluster to the same concept within a single council's current session. The agent detects this during Session Protocol feedback load:
1. Load active entries per Trigger R1
2. Group by `tags` intersection (≥50% tag overlap)
3. If any cluster has ≥3 entries → invoke `/sdlc-feedback-promote --mid-cycle` before proceeding with work

**Framework-bug singleton (new)**: A single `gate-learning` entry whose reasoning identifies a framework-level inconsistency (per FBP-005 exception) — invoke `/sdlc-feedback-promote --singleton-exception FB-NNN`.

## Flags

- `--mid-cycle` — promote now even though cycle is still in progress
- `--singleton-exception FB-NNN` — promote a single gate-learning entry that qualifies for FBP-005 exception
- (no flag) — standard cycle-end promotion per S1
