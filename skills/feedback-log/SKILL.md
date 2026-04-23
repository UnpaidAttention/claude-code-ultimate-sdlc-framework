---
name: sdlc-feedback-log
description: |
  Capture a user correction, preference, or gate-learning as a feedback entry with required
  "why" reasoning. Validates against anti-weaponization rules (PRH-001..PRH-009) before
  writing. Bootstraps INDEX.md on first use. Rejected entries are logged to REJECTED.md.
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - AskUserQuestion
---

## Preamble (run first)

```bash
# Detect project state
AG_PROJECT=".ultimate-sdlc"
FEEDBACK_DIR="$AG_PROJECT/feedback"

if [ ! -d "$AG_PROJECT" ]; then
  echo "ERROR: Project not initialized. Run /sdlc-init or /sdlc-adopt first."
  exit 1
fi

# Detect active council/phase
if [ -f "$AG_PROJECT/project-context.md" ]; then
  COUNCIL=$(grep -A1 "## Active Council" "$AG_PROJECT/project-context.md" | tail -1 | tr -d ' ')
  PHASE=$(grep -A1 "## Current Phase" "$AG_PROJECT/project-context.md" | tail -1 | tr -d ' ')
  CYCLE=$(grep -A1 "## Cycle" "$AG_PROJECT/project-context.md" | tail -1 | tr -d ' ')
  echo "COUNCIL: $COUNCIL"
  echo "PHASE: $PHASE"
  echo "CYCLE: $CYCLE"
else
  echo "WARNING: No active cycle. Feedback will be logged with council=any, phase=any."
fi

# Bootstrap feedback dir + INDEX.md if needed
if [ ! -d "$FEEDBACK_DIR" ]; then
  mkdir -p "$FEEDBACK_DIR"
  echo "BOOTSTRAP: created $FEEDBACK_DIR"
fi

if [ ! -f "$FEEDBACK_DIR/INDEX.md" ]; then
  # Copy from installed plugin cache first (preferred), fall back to repo dir if running unpackaged
  PLUGIN_TEMPLATE="$HOME/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/templates/feedback-index.md"
  REPO_TEMPLATE="${CCUSF_DIR:-$HOME/AntigravityFrameworks/claude-code-framework}/templates/feedback-index.md"
  if [ -f "$PLUGIN_TEMPLATE" ]; then
    cp "$PLUGIN_TEMPLATE" "$FEEDBACK_DIR/INDEX.md"
    echo "BOOTSTRAP: copied feedback-index from plugin cache → $FEEDBACK_DIR/INDEX.md"
  elif [ -f "$REPO_TEMPLATE" ]; then
    cp "$REPO_TEMPLATE" "$FEEDBACK_DIR/INDEX.md"
    echo "BOOTSTRAP: copied feedback-index from repo → $FEEDBACK_DIR/INDEX.md"
  else
    echo "WARNING: templates/feedback-index.md not found in plugin cache or repo."
    echo "Create $FEEDBACK_DIR/INDEX.md manually from templates/feedback-index.md in the framework repo."
  fi
fi

# Extract next FB ID
NEXT_ID=$(grep -oE "FB-[0-9]{3}" "$FEEDBACK_DIR/INDEX.md" | tail -1 || echo "FB-001")
echo "NEXT_ID: $NEXT_ID"
```

## Knowledge Skills

Load these knowledge skills for reference during this workflow:
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/documentation-standards/SKILL.md`

Also read (always for this skill):
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/rules/feedback-rules.md` (P0 rule — governs this workflow)
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/feedback-schema.md` (authoritative schema)
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/rules/integrity-rules.md` (for anti-weaponization check)

---

# /sdlc-feedback-log — Capture User Correction as Feedback

---

## Lens / Model
**Lens**: `[Documentation]` + `[Quality]` | **Model**: Claude Sonnet 4
> Feedback is a governance artifact — accuracy matters more than speed.

## Arguments

| Argument | Required | Description |
|----------|----------|-------------|
| `--type <type>` | no | `user-correction` (default), `user-preference`, `gate-learning` |
| `--tags "<tag1,tag2>"` | no | Comma-separated domain tags |
| `--references "<ID1,ID2>"` | no | Related FEAT/AIOU/gate IDs |
| (none) | — | Interactive mode — asks for each field |

---

## Purpose

Write a structured feedback entry to `.ultimate-sdlc/feedback/FB-NNN-<slug>.md` with required "why" reasoning. Validates that applying the entry would not bypass any PRH-001..PRH-009 rule.

---

## Workflow

### Step 1: Validate Prerequisites

- `.ultimate-sdlc/` exists
- `.ultimate-sdlc/feedback/` exists (or bootstrap per preamble)
- `.ultimate-sdlc/feedback/INDEX.md` exists (or bootstrap per preamble)

If prerequisites fail: display actionable error and STOP.

### Step 2: Collect Feedback Fields

Use AskUserQuestion for interactive collection, or parse from arguments if provided:

1. **Type** — one of `user-correction`, `user-preference`, `gate-learning`. Default: `user-correction`.
2. **What was wrong** — the agent action or draft that was incorrect. Required.
3. **Fix applied** — what the corrected version is. Required.
4. **Why (user's reasoning)** — the user's explanation. **Required, non-empty, ≥15 chars non-whitespace.** If empty or missing, ASK the user; if they decline to give a reason, REJECT the entry per FBP-001.
5. **How to apply** — "When X, do Y because Z" generalization. Required. If the user doesn't provide one, ask them or propose a draft and get user confirmation.
6. **Tags** — domain tags for future matching (e.g., `validation`, `auth`, `wave-3`).
7. **References** — related FEAT/AIOU/gate IDs, if any.
8. **User reasoning source** — one of `verbatim` (quoted), `paraphrase` (user confirmed), `inferred` (agent's guess, flag for user review).

### Step 3: Anti-Weaponization Check (MANDATORY)

Before writing, analyze the proposed "How to apply" content:

| Check | Trigger | Action |
|-------|---------|--------|
| PRH-001 | Would applying this allow feature skipping? | REJECT — scope belongs in spec |
| PRH-002 | Would applying this loosen tests or assertions? | REJECT — tests fixed by correctness, not by feedback |
| PRH-003 | Would applying this disable code, services, or middleware? | REJECT — use DEFERRED pattern or spec change |
| PRH-006/007/008 | Would applying this silently reduce scope or simplify a feature? | REJECT — scope change requires explicit spec update |
| PRH-009 | Would applying this skip cross-feature integration? | REJECT — integration goes in connectivity matrix, not feedback |

If ANY check fires:
1. Do NOT write the entry.
2. Append rejection to `.ultimate-sdlc/feedback/REJECTED.md` with timestamp, PRH ID, and suggested alternative channel.
3. Display to user: which PRH was triggered + suggested alternative (spec update, DEFERRED item, etc.).
4. STOP.

If all checks pass: proceed.

### Step 4: Allocate ID

1. Read `.ultimate-sdlc/feedback/INDEX.md § ID allocation`.
2. Extract the `Next ID:` value (e.g. `FB-007`).
3. Compute slug from the `description` field: lowercase, kebab-case, ≤6 words, strip stopwords.
4. Target filename: `FB-007-<slug>.md`.

### Step 5: Write Entry File

Use the template at `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/templates/feedback-entry.md`. Fill in:

- Frontmatter: `id`, `name` (slug), `description`, `type`, `council`, `phase`, `cycle`, `created`, `updated` (both = now), `status: active`, `tags`, `supersedes: []`, `promoted_to: null`, `references`, `user_reasoning_source`.
- Body: fill each required section with collected content. Mark the Anti-Weaponization section as `[x]` on all boxes only if Step 3 passed for each.

Write to `.ultimate-sdlc/feedback/FB-NNN-<slug>.md`.

### Step 6: Update INDEX.md

Edit `.ultimate-sdlc/feedback/INDEX.md`:

1. Prepend a new bullet to the `## Active` section:
   ```
   - [FB-NNN](FB-NNN-slug.md) `type` `council/phase` — <description>
   ```
   Replace the placeholder `_No active entries yet._` if present.
2. Bump the stats table: increment `Total entries` and `Active`.
3. Bump `Next ID:` to `FB-<NNN+1>`.
4. Update `Last updated:` timestamp.

### Step 7: Update WORKING-MEMORY

Append to `.ultimate-sdlc/council-state/{council}/WORKING-MEMORY.md` under a "Feedback captured this session" heading:

```
- FB-NNN `type` — <description> — see feedback/FB-NNN-slug.md
```

If the heading doesn't exist yet in WORKING-MEMORY, create it.

### Step 8: Confirm

Display:

```
✅ Feedback entry written.

  ID: FB-NNN
  File: .ultimate-sdlc/feedback/FB-NNN-<slug>.md
  Type: <type>
  Council/Phase: <council>/<phase>

The entry's "How to apply" will be loaded at the start of every future session
that matches this council/phase and during pre-AIOU checks for matching tags.
```

---

## Error Handling

### If "Why (user's reasoning)" is empty

- Ask the user once.
- If still empty or user declines: REJECT per FBP-001. Append to REJECTED.md. Display: "Feedback requires reasoning. A correction without 'why' doesn't become a reusable lesson — it's just a one-off patch."

### If INDEX.md is corrupted or missing the `Next ID:` field

- Scan all `FB-NNN-*.md` files in `.ultimate-sdlc/feedback/`, find the highest N, use N+1.
- Fix INDEX.md to include the `Next ID:` line.

### If the anti-weaponization check is ambiguous (borderline cases)

- Display the proposed entry content to the user.
- Display all matching PRH concerns.
- Ask: "This feedback looks like it might bypass [PRH-X]. Should I (a) reject, (b) rewrite the 'How to apply' to stay within PRH bounds, or (c) log it as a spec-change request instead?"

### If the entry duplicates an existing active entry

- Detect via description similarity and tag overlap.
- Ask the user: "This looks similar to FB-NNN. Should I (a) supersede FB-NNN with this new entry, or (b) create a distinct entry?"
- If superseding: new entry's `supersedes: [FB-NNN]`; update FB-NNN's status to `superseded`.

---

## Post-Conditions

- `.ultimate-sdlc/feedback/FB-NNN-<slug>.md` exists with valid frontmatter and all required body sections.
- `.ultimate-sdlc/feedback/INDEX.md` updated.
- `.ultimate-sdlc/council-state/{council}/WORKING-MEMORY.md` updated.
- No writes to the framework repo directory (FR-3, FBP-003).
