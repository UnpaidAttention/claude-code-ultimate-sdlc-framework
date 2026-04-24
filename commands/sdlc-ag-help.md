---
description: Show available SDLC Framework commands organized by council. Default shows user-facing entry points only (~68). Flags: --all (all 172), --council <name> (one council).
user_invocable: true
---

# /sdlc-ag-help

This command invokes the `sdlc-ag-help` workflow skill. Use the Skill tool to load the full workflow:

```
Skill: sdlc-ag-help
```

## Flags

- `/sdlc-ag-help` — user-facing entry points only (~68 commands, `user_invocable: true`)
- `/sdlc-ag-help --all` — all workflows including internal orchestration (~172 commands)
- `/sdlc-ag-help --council <name>` — one council's user-invocable commands (e.g. `--council dev`)
