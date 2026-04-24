---
description: Append a gate evaluation row to .ultimate-sdlc/gate-hit-rate.md. Invoked by every gate workflow after decision recorded.
user_invocable: false
---

# /sdlc-gate-log

Internal skill invoked by gate verification workflows. Appends one row to the hit-rate tracker.

**Usage**: Invoked automatically by `/sdlc-*-gate-*` workflows. Not intended for direct user invocation.

Use the Skill tool to load the full workflow:

```
Skill: gate-log
```
