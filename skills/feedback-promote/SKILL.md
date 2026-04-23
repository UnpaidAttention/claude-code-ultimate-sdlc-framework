---
name: sdlc-feedback-promote
description: |
  Synthesize recurring feedback entries into pattern entries at cycle end. Invoked
  during Validation Council S1 phase. Patterns require at least 2 corroborating
  entries (FBP-005). Constituents are marked promoted, not deleted.
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
AG_PROJECT=".ultimate-sdlc"
FEEDBACK_DIR="$AG_PROJECT/feedback"

if [ ! -d "$FEEDBACK_DIR" ] || [ ! -f "$FEEDBACK_DIR/INDEX.md" ]; then
  echo "NO_FEEDBACK: $FEEDBACK_DIR/INDEX.md does not exist — nothing to promote."
  exit 0
fi

# Expect to be invoked during Validation S1
if [ -f "$AG_PROJECT/project-context.md" ]; then
  COUNCIL=$(grep -A1 "## Active Council" "$AG_PROJECT/project-context.md" | tail -1 | tr -d ' ')
  PHASE=$(grep -A1 "## Current Phase" "$AG_PROJECT/project-context.md" | tail -1 | tr -d ' ')
  CYCLE=$(grep -A1 "## Cycle" "$AG_PROJECT/project-context.md" | tail -1 | tr -d ' ')
  echo "COUNCIL: $COUNCIL | PHASE: $PHASE | CYCLE: $CYCLE"

  if [ "$COUNCIL" != "validation" ] || [[ "$PHASE" != S1* ]]; then
    echo "WARNING: This skill is designed for Validation S1. Current: $COUNCIL/$PHASE."
    echo "Promotion may still proceed but is out of standard cadence."
  fi
fi

# Count active entries
ACTIVE_COUNT=$(grep -cE "^- \[FB-[0-9]+\]" "$FEEDBACK_DIR/INDEX.md" || echo "0")
echo "ACTIVE_ENTRIES: $ACTIVE_COUNT"

if [ "$ACTIVE_COUNT" -lt 2 ]; then
  echo "INSUFFICIENT_ENTRIES: Need >=2 active entries to form any pattern."
fi
```

## Knowledge Skills

- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/rules/feedback-rules.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/feedback-schema.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/documentation-standards/SKILL.md`

---

# /sdlc-feedback-promote — Cycle-End Pattern Synthesis

---

## Lens / Model
**Lens**: `[Quality]` + `[Documentation]` | **Model**: Claude Opus 4 (synthesis benefits from stronger reasoning)

## Arguments

| Argument | Required | Description |
|----------|----------|-------------|
| `--dry-run` | no | Show clusters and proposed patterns without writing |
| `--min-cluster-size <N>` | no | Override minimum cluster size (default 2, per FBP-005) |
| (none) | — | Standard interactive promotion |

---

## Purpose

At cycle end, cluster active feedback entries that share domain / pattern / recurring root cause, and synthesize each cluster into a single `pattern` entry that will carry forward to the next cycle. Constituents are marked `status: promoted` so they remain as history.

---

## Workflow

### Step 1: Prerequisites Check

- `.ultimate-sdlc/feedback/INDEX.md` exists
- At least 2 active entries exist (else STOP with "No patterns to synthesize — fewer than 2 active entries")
- Preferably invoked during Validation S1 (warn if elsewhere)

### Step 2: Load All Active Entries

- Parse INDEX.md `## Active` section → list of FB-NNN IDs.
- Read each FB-NNN file.
- Build an in-memory table: ID, type, tags, description, how-to-apply, references.

### Step 3: Cluster

Group entries by shared concerns. Use these signals:

1. **Tag overlap** — entries sharing ≥1 tag are candidate clusters.
2. **Council + phase** — entries for the same council + phase cluster naturally.
3. **Reference overlap** — entries referencing the same FEAT/AIOU cluster.
4. **Semantic similarity in "How to apply"** — entries with similar generalization language cluster.

A cluster is valid for promotion if it has **≥ 2 members** (FBP-005 minimum). Singletons do not promote; they remain active.

### Step 4: Present Clusters to User

Display each candidate cluster:

```
Cluster 1: "Email validation rigor"
  - FB-003 (user-correction, development/wave-3) — validate emails with RFC regex, not truthiness
  - FB-007 (user-correction, development/wave-4) — API email validation must match service-layer

Proposed pattern: "Email validation must use the RFC regex in all layers (service + API + UI)."
Rationale: both entries corrected the same root cause at different layers.
```

For each cluster, ask the user:
- (a) Promote this cluster to a pattern
- (b) Keep as individual active entries
- (c) Edit the proposed synthesis before promoting

### Step 5: Allocate Pattern IDs & Write

For each cluster the user approves:

1. Allocate next FB-NNN from INDEX.md.
2. Write new entry using `templates/feedback-entry.md` with:
   - `type: pattern`
   - `council: any` (patterns are generally cross-cutting; narrow if the cluster is council-specific)
   - `phase: any`
   - `status: active`
   - `supersedes: [FB-A, FB-B, ...]` (the cluster members)
   - `tags`: union of cluster member tags
   - `references`: union of cluster member references
   - Body: synthesized "What was wrong" (aggregated), "Fix applied" (common approach), "Why" (the shared reasoning, cite user quotes from constituents), "How to apply" (generalized rule), "Scope of applicability" (broader than constituents).
3. For each constituent FB-A:
   - Edit its frontmatter: `status: promoted`, `promoted_to: FB-NNN` (the new pattern ID).
   - Update `updated` timestamp.

### Step 6: Update INDEX.md

- Move promoted constituents from `## Active` to `## Promoted (→ Patterns)` with pointer to new pattern ID.
- Add new pattern entries to `## Active`.
- Bump stats: `Promoted` count += constituents, `Active` count adjusted (−constituents +new_patterns), `Total entries` += new_patterns.
- Bump `Next ID:`.

### Step 7: Anti-Weaponization Re-Check

For each new pattern entry: run the PRH checks from `sdlc-feedback-log § Step 3` on the synthesized "How to apply". If any check fires:
- Do NOT write the pattern.
- Revert the cluster promotion for that pattern.
- Log to REJECTED.md.
- Report to user: "Cluster X failed anti-weaponization in synthesis; constituents remain active."

### Step 8: Report

Display summary:

```
Promoted N clusters to patterns.
New pattern entries: FB-NNN, FB-MMM, ...
Constituents marked promoted: FB-A, FB-B, FB-C, ...
Active count: X → Y
```

---

## Error Handling

### If no clusters have ≥2 members

- Display: "No clusters meet the minimum size of 2. All active entries remain individual."
- STOP without writing.

### If a cluster spans contradictory reasoning

- Do NOT promote. Display to user: "Cluster X contains entries with contradictory 'How to apply' guidance (FB-A says do X, FB-B says do Y). Not promotable as a single pattern. Keep as individual entries or create separate patterns."
- Move to next cluster.

### If INDEX.md is out of sync with files

- Scan `.ultimate-sdlc/feedback/FB-*.md` directly to identify active entries by frontmatter `status: active`.
- Rebuild the `## Active` section of INDEX.md from file scan before promoting.

---

## Post-Conditions

- New pattern entries written for each approved cluster.
- Constituents' frontmatter updated: `status: promoted`, `promoted_to: FB-NNN`.
- INDEX.md reflects new state.
- No constituents deleted — history is preserved.
- No writes to the framework repo.
