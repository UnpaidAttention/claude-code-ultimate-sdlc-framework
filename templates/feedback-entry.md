---
id: FB-NNN
name: <short-slug>
description: <one-line summary used by INDEX.md>
type: user-correction
# one of: user-correction | user-preference | gate-learning | pattern
council: development
# one of: planning | development | audit | validation | any
phase: <phase-or-wave-or-track-id>
# examples: 1.5 | 2.5 | wave-3 | T2 | V5 | any
cycle: <cycle-id>
# e.g. cycle-001-flagship
created: <ISO 8601 timestamp>
updated: <ISO 8601 timestamp>
status: active
# one of: active | resolved | superseded | promoted
tags: []
# e.g. [validation, email, wave-3]
supersedes: []
# [FB-NNN, ...] if this entry consolidates or replaces prior entries
promoted_to: null
# FB-NNN of the pattern entry this was rolled into, if status=promoted
references: []
# spec or artifact IDs this feedback relates to, e.g. [FEAT-004, AIOU-017, gate-I4]
user_reasoning_source: verbatim
# one of: verbatim (quoted from user) | paraphrase (user confirmed) | inferred (flag for review)
---

# [FB-NNN] <Short Title>

## What was wrong

<!-- Describe the agent's action or draft output that was incorrect or suboptimal.
Be specific: file path, line range, AIOU ID, decision made. No blame, just facts. -->

## Fix applied

<!-- What the corrected version is. Code diff, spec edit, or behavioral change. -->

## Why (user's reasoning)

<!-- The user's explanation of WHY this change matters. This is the most important
section — without it, the entry is invalid (FBP-001). Quote verbatim where possible.
If paraphrased, mark user_reasoning_source: paraphrase in frontmatter. -->

> "<user's words>"

## How to apply (generalized guidance)

<!-- Actionable guidance for the agent to detect similar situations and prevent them
in future sessions. Write as: "When X, do Y because Z." -->

1.
2.

## Scope of applicability

- **Councils:** <which councils should load this>
- **Phases:** <which phases/waves>
- **Trigger conditions:** <when this is relevant — file patterns, AIOU tags, gate IDs>

## Anti-weaponization check

This entry is **invalid** if applying it would cause any of the following (FBP-004, FR-2):

- [ ] PRH-001: Would skipping features be justified by this feedback? (If yes: INVALID)
- [ ] PRH-002: Would tests be loosened or disabled? (If yes: INVALID)
- [ ] PRH-003: Would code or services be disabled? (If yes: INVALID)
- [ ] PRH-006/007/008: Would scope be silently reduced or features simplified? (If yes: INVALID)
- [ ] PRH-009: Would cross-feature integration be skipped? (If yes: INVALID)

If ALL boxes are unchecked (safe), this entry is valid. If any box is checked, the entry must be rejected at write time — the correction belongs in a spec change, not feedback.
