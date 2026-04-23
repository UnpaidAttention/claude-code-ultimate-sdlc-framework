---
name: sdlc-feedback-review
description: |
  Surface active feedback entries relevant to the current council, phase, or explicit
  filter. Displays "How to apply" guidance for each matching entry. Use at session start
  or before starting a new AIOU to apply learned preferences.
allowed-tools:
  - Bash
  - Read
  - Grep
  - Glob
---

## Preamble (run first)

```bash
AG_PROJECT=".ultimate-sdlc"
FEEDBACK_DIR="$AG_PROJECT/feedback"

if [ ! -d "$FEEDBACK_DIR" ] || [ ! -f "$FEEDBACK_DIR/INDEX.md" ]; then
  echo "NO_FEEDBACK: $FEEDBACK_DIR/INDEX.md does not exist — no feedback captured yet."
  exit 0
fi

# Detect current context
if [ -f "$AG_PROJECT/project-context.md" ]; then
  COUNCIL=$(grep -A1 "## Active Council" "$AG_PROJECT/project-context.md" | tail -1 | tr -d ' ')
  PHASE=$(grep -A1 "## Current Phase" "$AG_PROJECT/project-context.md" | tail -1 | tr -d ' ')
  echo "COUNCIL: $COUNCIL"
  echo "PHASE: $PHASE"
fi

# Count active entries
ACTIVE_COUNT=$(grep -cE "^- \[FB-[0-9]+\]" "$FEEDBACK_DIR/INDEX.md" || echo "0")
echo "ACTIVE_ENTRIES: $ACTIVE_COUNT"
```

## Knowledge Skills

- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/rules/feedback-rules.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/feedback-schema.md`

---

# /sdlc-feedback-review — Surface Active Feedback

---

## Lens / Model
**Lens**: `[Documentation]` | **Model**: Claude Sonnet 4

## Arguments

| Argument | Required | Description |
|----------|----------|-------------|
| `--council <name>` | no | Override auto-detected council |
| `--phase <name>` | no | Override auto-detected phase |
| `--tag <tag>` | no | Filter by single tag |
| `--aiou <AIOU-NNN>` | no | Filter by AIOU reference |
| `--gate <gate-id>` | no | Show only gate-learning entries for this gate |
| `--full` | no | Print full entry bodies (default: summary only) |
| (none) | — | Auto-detects current council/phase |

---

## Purpose

Read `.ultimate-sdlc/feedback/INDEX.md`, filter entries matching current context (or explicit arguments), load matched entry files, and display their "How to apply" guidance.

Used at:
- Every council's Session Protocol (Trigger R1)
- Pre-AIOU in Planning 2.5/3/3.5 + Development waves (Trigger R2)
- Pre-gate verification (Trigger R3)

---

## Workflow

### Step 1: Load Index

Read `.ultimate-sdlc/feedback/INDEX.md`. If no `## Active` entries: display `No active feedback entries for this project. (Tip: capture corrections with /sdlc-feedback-log)` and STOP.

### Step 2: Apply Filters

Filter the `## Active` list using:

- `status: active` (always — never surface non-active for application)
- `council == current_council OR council == any` (from preamble or `--council` arg)
- `phase == current_phase OR phase == any` (from preamble or `--phase` arg)
- If `--tag <tag>`: entry `tags` includes `<tag>`
- If `--aiou <id>`: entry `references` includes `<id>` OR tags intersect AIOU domain
- If `--gate <id>`: entry `type == gate-learning` AND `references` includes `<id>`

Extract the matching FB-NNN IDs from the INDEX and read each corresponding file.

### Step 3: Display Summary

For each matching entry, display:

```markdown
## FB-NNN — <description>
- **Type:** <type> | **Council/Phase:** <council>/<phase> | **Tags:** <tags>
- **How to apply:**
  1. <first line of How to apply>
  2. <second line>
  ...

  _(See `.ultimate-sdlc/feedback/FB-NNN-<slug>.md` for full entry.)_
```

If `--full` was specified: print the full `How to apply` and `Scope of applicability` sections instead of truncating.

### Step 4: Summary Footer

```
Loaded N feedback entries for <council>/<phase>.
Apply the "How to apply" guidance during this session.
Conflicts with specs: specs win — flag to user for reconciliation.
```

### Step 5: Log to Working Memory

Append to `.ultimate-sdlc/council-state/{council}/WORKING-MEMORY.md` under "Feedback loaded this session":

```
## Feedback loaded this session (<ISO timestamp>)

- FB-NNN — <description> — [applied]
- FB-MMM — <description> — [applied]
```

This creates an auditable record of which entries were active during the session, for later verification during Code Review Protocol (per FBP-002).

---

## Error Handling

### If a referenced FB-NNN file is missing

- Note in the display output: `⚠ FB-NNN referenced in INDEX.md but file missing — index out of sync`.
- Continue with remaining entries.
- Suggest: `Run /sdlc-feedback-review --repair to reconcile index against files.` (Future enhancement — not implemented in v1.)

### If INDEX.md has no `## Active` section

- Bootstrap section if missing.
- Display: `Feedback index is empty. Capture corrections with /sdlc-feedback-log.`

---

## Post-Conditions

- No files modified in `.ultimate-sdlc/feedback/`.
- `WORKING-MEMORY.md` updated with loaded-feedback audit trail.
- No writes to the framework repo.
