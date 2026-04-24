---
description: Draft proposed edits to the framework itself based on cycle-level pattern entries. Produces FR-NNN proposals for user review. Never auto-applies to the framework repo.
user_invocable: true
---

# /sdlc-framework-retro

This command invokes the `sdlc-framework-retro` workflow skill. Use the Skill tool to load the full workflow:

```
Skill: sdlc-framework-retro
```

## Outputs

Each retro produces one or more FR-NNN proposals in `.ultimate-sdlc/framework-revisions-proposed/`. Every proposal set includes:

- **Addition proposals**: new rules, workflows, or criteria drawn from recurring patterns
- **Modification proposals**: existing rules that should be strengthened or clarified
- **Deletion proposals (MANDATORY)**: ≥1 rule/criterion to retire OR explicit retention justification for the 3 least-used rules

Framework retros without deletion analysis are incomplete. The skill will refuse to finalize an FR set that lacks the deletion section.
