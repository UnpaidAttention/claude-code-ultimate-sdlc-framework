---
name: sdlc-framework-retro
description: |
  At cycle close, draft proposed edits to the framework repo based on pattern feedback
  entries. Produces FR-NNN proposals in .ultimate-sdlc/framework-revisions-proposed/
  for user review. NEVER writes to the framework repo directory. User applies manually.
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - Agent
  - AskUserQuestion
---

## Preamble (run first)

```bash
AG_PROJECT=".ultimate-sdlc"
FEEDBACK_DIR="$AG_PROJECT/feedback"
REVISIONS_DIR="$AG_PROJECT/framework-revisions-proposed"

# Safety: confirm we are NOT inside the framework repo itself
CURRENT_PWD=$(pwd)
FRAMEWORK_ROOT="${CCUSF_DIR:-$HOME/AntigravityFrameworks/claude-code-framework}"
if [ "$CURRENT_PWD" = "$FRAMEWORK_ROOT" ] || [[ "$CURRENT_PWD" == "$FRAMEWORK_ROOT"/* ]]; then
  echo "ERROR: Refusing to run /sdlc-framework-retro from inside the framework repo ($FRAMEWORK_ROOT)."
  echo "This skill writes proposals to the PROJECT under .ultimate-sdlc/framework-revisions-proposed/."
  echo "It must be run from a project directory, not the framework source."
  exit 1
fi

# Check feedback exists
if [ ! -d "$FEEDBACK_DIR" ]; then
  echo "NO_FEEDBACK: no $FEEDBACK_DIR — nothing to retro."
  exit 0
fi

# Bootstrap revisions dir if needed
if [ ! -d "$REVISIONS_DIR" ]; then
  mkdir -p "$REVISIONS_DIR"
  echo "BOOTSTRAP: created $REVISIONS_DIR"
fi

# Detect cycle
if [ -f "$AG_PROJECT/project-context.md" ]; then
  CYCLE=$(grep -A1 "## Cycle" "$AG_PROJECT/project-context.md" | tail -1 | tr -d ' ')
  echo "CYCLE: $CYCLE"
fi

# Count pattern entries to consider
PATTERN_COUNT=$(grep -lE "^type: pattern" "$FEEDBACK_DIR"/FB-*.md 2>/dev/null | wc -l)
echo "PATTERN_ENTRIES: $PATTERN_COUNT"
```

## Knowledge Skills

- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/rules/feedback-rules.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/feedback-schema.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/rules/integrity-rules.md` (to ensure proposals respect PRH)
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`

---

# /sdlc-framework-retro — Draft Framework Revision Proposals

---

## Lens / Model
**Lens**: `[Architecture]` + `[Documentation]` | **Model**: Claude Opus 4 (meta-analysis benefits from stronger reasoning)

## Arguments

| Argument | Required | Description |
|----------|----------|-------------|
| `--dry-run` | no | Analyze and report without writing proposals |
| `--scope rules\|skills\|commands\|all` | no | Restrict target files (default: all) |
| (none) | — | Standard: full scan of pattern entries, propose for all targets |

---

## Purpose

After `/sdlc-feedback-promote` has synthesized cycle-level patterns, this skill evaluates each pattern against the framework's own rules, skills, commands, and templates to identify **framework-level gaps** — places where the framework should be updated to prevent the pattern from recurring in future cycles or future projects.

Each identified gap becomes a proposed revision (`FR-NNN`) in `.ultimate-sdlc/framework-revisions-proposed/`. The user reviews and manually applies.

**Hard constraint**: This skill NEVER writes to the framework repo directory.

---

## Workflow

### Step 1: Safety Check

Confirm `pwd` is not inside the framework repo (per preamble). If it is: STOP with error.

### Step 2: Load Inputs

- Read all entries in `.ultimate-sdlc/feedback/FB-*.md` where `type: pattern` AND `status: active`.
- Also include carried-forward patterns from prior cycles (they're already in the same location).
- For each pattern, read: description, "How to apply", tags, references.

### Step 3: For Each Pattern — Locate Target Framework Areas

For each pattern, analyze whether the recurrence reflects:

- **A rule gap** — missing check or ambiguous rule in `rules/*`
- **A workflow gap** — missing step or missing context load in `skills/*`
- **A command gap** — missing command or command with insufficient guardrails in `commands/*`
- **A template gap** — template missing a required section
- **A gate criterion gap** — criterion in `contexts/gate-criteria.md` needs to be added/tightened

Dispatch parallel Explore agents (via the Agent tool) to search the framework repo at `$FRAMEWORK_ROOT` for:
- The most relevant rule/skill/command file for each pattern
- The section within that file where the revision should land

Read-only access to the framework repo is acceptable — this is inspection, not modification.

### Step 4: Draft Proposals

For each identified gap (NOT each pattern — one pattern may produce 0 or multiple proposals):

1. Allocate next FR-NNN from `.ultimate-sdlc/framework-revisions-proposed/INDEX.md` (bootstrap if missing).
2. Use `templates/framework-revision.md` as the template.
3. Fill in:
   - `target_file`: relative path (e.g. `rules/council-development.md`)
   - `target_section`: section header
   - `evidence`: list of FB-NNN pattern IDs that motivated this
   - `impact`: low | medium | high (judgment — changing Session Protocol = medium; adding one check = low; changing control flow = high)
   - `reversibility`: easy | moderate | hard
   - Body:
     - **Current state**: exact excerpt from target file
     - **Proposed change**: diff block
     - **Rationale**: short paragraph
     - **Evidence trail**: table of FB entries + observations + connection
     - **Risk assessment**: blast radius, reversibility, PRH conflicts
4. Verify the proposal RESPECTS PRH rules — a proposal must never suggest loosening integrity rules.
5. Write to `.ultimate-sdlc/framework-revisions-proposed/FR-NNN-<slug>.md`.

### Step 5: Update Revisions INDEX.md

Bootstrap `.ultimate-sdlc/framework-revisions-proposed/INDEX.md` if missing. Structure:

```markdown
# Framework Revision Proposals

**Last updated:** <timestamp>

## Proposed (awaiting user review)
- [FR-NNN](FR-NNN-slug.md) → `<target_file>` — <description>

## Applied
<!-- User moves entries here after applying -->

## Rejected
<!-- User moves entries here after declining -->

## ID allocation
Next ID: FR-NNN
```

Add each new proposal to `## Proposed`.

### Step 6: Hard Safety Audit (MANDATORY BEFORE REPORTING)

Before presenting proposals to the user, run a final audit:

1. For each generated proposal, confirm the `target_file` path is RELATIVE (no absolute paths to framework repo).
2. Grep all proposal files for any write commands or edit instructions that target absolute paths matching the framework repo.
3. Confirm no Write/Edit tool calls were made to paths under `$FRAMEWORK_ROOT` during this workflow.
4. If any violation: mark all generated proposals as `status: invalid`, do NOT surface them, and display a hard failure to the user.

### Step 7: Report to User

Display:

```
Framework retrospective complete for cycle <CYCLE>.

Proposals drafted: N
Location: .ultimate-sdlc/framework-revisions-proposed/

Summary:
  - FR-001 → rules/council-development.md — <description>
  - FR-002 → skills/dev-wave-3/SKILL.md — <description>
  ...

Next steps:
  1. Review each FR-NNN file.
  2. If accepted: apply the diff manually to the framework repo at <FRAMEWORK_ROOT>.
  3. Commit with: "framework-revision: FR-NNN <title>"
  4. Mark FR-NNN status: applied with applied_at and applied_commit.
  5. If rejected: mark FR-NNN status: rejected — file is retained as history.

The framework repo was NOT modified by this workflow.
```

---

## Error Handling

### If the framework repo is not accessible

- If `$FRAMEWORK_ROOT` does not exist or is not readable, skip Step 3 for location details.
- Generate proposals with `target_file: UNKNOWN` and a note: "Target file location could not be auto-identified; user must specify when applying."

### If all patterns are covered by existing framework rules

- Do NOT generate proposals.
- Display: "All pattern feedback is already addressed by existing framework rules. No revisions proposed this cycle."

### If a proposal would conflict with INTEGRITY-RULES

- Discard the proposal.
- Log: "Proposal for pattern FB-NNN discarded — would conflict with PRH-X. Pattern indicates a legitimate recurring issue but the fix does not belong in the framework."

---

## Post-Conditions

- N proposals written to `.ultimate-sdlc/framework-revisions-proposed/FR-NNN-<slug>.md`.
- `.ultimate-sdlc/framework-revisions-proposed/INDEX.md` updated.
- **Zero writes to `$FRAMEWORK_ROOT` or any path under it.** (Enforced at preamble, verified at Step 6.)
- User receives a clear summary of proposals with next-steps guidance.
