# INTEGRITY-ENFORCEMENT.md — Detailed Protocols

**Load when**: Any gate verification workflow runs | Any PRH violation is suspected | Run recovery is triggered.
**Load mechanism**: Gate workflows Read this file explicitly as Step 0. PRH violation detection triggers Read. Not loaded at session start.

This file contains the detailed enforcement, self-check, verification, and recovery protocols extracted from INTEGRITY-RULES.md. The main INTEGRITY-RULES.md contains only awareness-level content (PRH IDs, one-line descriptions, triggers).

---

## ENFORCEMENT PROTOCOL

When any prohibited behavior is detected:

1. **STOP** — Halt current work immediately
2. **REVERT** — Undo corner-cutting changes, restore configs, re-enable services
3. **DOCUMENT** — Log in WORKING-MEMORY.md: which PRH violated, why it was tempting
4. **FIX** — Address root cause properly per Required Behavior (see INTEGRITY-RULES.md § PRH-NNN)
5. **VERIFY** — Confirm fix addresses root cause, run verification commands

---

## SELF-CHECK PROTOCOL

Before marking ANY task complete:

| Question | If "No" → Action |
|----------|------------------|
| Did I complete ALL assigned items? | Check run-tracker.md, complete missing items |
| Did I run the actual tests? | Run tests, fix failures |
| Did I disable anything to make it work? | Re-enable and fix properly |
| Did I blame pre-existing code without proof? | Get git evidence or fix it |
| Did I implement the full spec? | Review spec, implement missing parts |
| Did I exclude features without user approval? | Check scope-lock.md against product concept |
| Did I simplify any feature below its spec? | Compare implementation against deep-dive Component Inventory |
| Did I skip cross-feature integration points? | Check connectivity-matrix.md against implementation |
| Can I prove completion with artifacts? | Generate proof before claiming done |

---

## INTEGRITY VERIFICATION PROTOCOL

### Pre-Completion Checkpoint (MANDATORY)

Before claiming ANY phase/wave/run/gate complete, paste this into WORKING-MEMORY.md:

```markdown
## Integrity Checkpoint - [Phase/Wave/Run]

### Artifact Verification
- [ ] Run tracker count matches feature/AIOU count: ___ = ___
- [ ] All checklist items checked: ___/___
- [ ] Gate criteria evidence exists: [file paths]

### Prohibition Check
| Rule | Did I violate? | Answer |
|------|---------------|--------|
| PRH-001 | Skip assigned items? | YES/NO |
| PRH-002 | Modify tests to pass? | YES/NO |
| PRH-003 | Disable code to avoid errors? | YES/NO |
| PRH-004 | Blame pre-existing without proof? | YES/NO |
| PRH-005 | Claim complete without verification? | YES/NO |
| PRH-006 | Implement less than spec? | YES/NO |
| PRH-007 | Exclude features without user approval? | YES/NO |
| PRH-008 | Simplify feature below deep-dive spec? | YES/NO |
| PRH-009 | Skip connectivity matrix integration points? | YES/NO |

**If ANY YES**: STOP. Fix the violation first.

### Verification Commands (N/A if no build system)
- [ ] Build: `[command]` → Exit code: ___
- [ ] Tests: `[command]` → Exit code: ___
- [ ] Lint: `[command]` → Exit code: ___

Signature: [AI model] | Timestamp: [ISO 8601]
```

**Gate Integration**: Gates verify checkpoint exists, counts match, all PRH = NO, all commands exit 0. Missing/incomplete checkpoint = automatic gate FAIL.

---

## AUTONOMOUS OPERATION PROTOCOL

When operating without human oversight:

1. **When unsure about a decision**: (a) Check codebase for existing patterns — if found, follow them. (b) Check if a loaded skill provides guidance. (c) If still unsure, choose the safer/more conservative option. (d) Document the uncertainty and chosen approach in WORKING-MEMORY.md. (e) Flag for user review at the next gate checkpoint.

2. **Before destructive operations** (file deletion, config changes, dependency removal): Verify rollback is possible. Document what will change in WORKING-MEMORY.md before executing.

3. **When blocked by external dependency**: Use `DEFERRED:[reason]:[owner]:[target-phase]` pattern. Do NOT invent workarounds that bypass the blocked functionality.

---

## RUN RECOVERY PROTOCOL

When run scope is too large mid-run:

1. **STOP** — Document progress in WORKING-MEMORY.md, count completed vs remaining
2. **Request Subdivision** — Notify user: "Run [X] too large. Requesting subdivision." Propose split.
3. **If Approved** — Mark completed items DONE, update run-tracker.md (rename to "Run X (Partial)", create new runs), continue
4. **Preserve Work** — Completed runs stay COMPLETED. Partial runs marked "PARTIAL - subdivided". No work lost.

**Key Principle**: Better to subdivide late than to truncate features.
