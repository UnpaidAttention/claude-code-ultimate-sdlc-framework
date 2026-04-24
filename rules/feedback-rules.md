---
trigger: conditional
---

# FEEDBACK-RULES.md — Feedback-Driven Learning

**Load status**: Conditional-P0. Loaded at (a) every council's Session Protocol feedback step, (b) invocation of any `/sdlc-feedback-*` or `/sdlc-framework-retro` command. Not loaded at agent spin-up.

This file governs the feedback subsystem: how the framework captures user corrections with reasoning, applies them to future work, and proposes framework-level improvements.

**Core Principle** (always-on, mirrored in UNIVERSAL-RULES § 0.21): Feedback captures **how** the team wants work done. Requirements capture **what** the system does. The two are orthogonal. Gates catch what we know can break; feedback catches what the project teaches us over time.

For schema and file layout, see `contexts/feedback-schema.md`.

---

## TIER 0: FIRST PRINCIPLES

### FR-1: Feedback Is Orthogonal to Specs

- Requirements/specs (FEAT, AIOU, ADR) describe WHAT the system does — discoverable by reading the code.
- Feedback describes HOW the team wants the work done — style, emphasis, avoidance. Not discoverable from code.
- **Never conflate.** A missing validation that's in the spec is a bug → fix per the spec. A user saying "we always validate emails this specific way because of incident X" is feedback.

### FR-2: Feedback Never Bypasses Integrity Rules

Feedback cannot justify any PRH-001..PRH-009 violation. See `INTEGRITY-RULES.md` for the full PRH enumeration. Write-time rejection applies per FBP-004 below; rejections logged to `REJECTED.md`.

### FR-3: Framework Self-Modification Is Proposal-Only

- The framework MAY **propose** edits to its own files (rules, skills, commands, templates, contexts) under `.ultimate-sdlc/framework-revisions-proposed/`.
- The framework **NEVER auto-applies** edits to the framework repo at `/home/jons/AntigravityFrameworks/claude-code-framework/` (or wherever the framework lives).
- User review is mandatory before any revision is merged. No exceptions.
- Agents do not have write access to the framework repo during SDLC execution — only to the project's `.ultimate-sdlc/` tree.

### FR-4: Feedback Is Per-Project

- Feedback lives in `.ultimate-sdlc/feedback/` — scoped to one project, one codebase.
- Feedback does NOT propagate across projects automatically.
- Cross-project learning is out of scope for this subsystem.

---

## TIER 1: FEEDBACK STORAGE

### Storage Location

```
.ultimate-sdlc/feedback/
├── INDEX.md                          # Authoritative index; entries grouped by status
├── FB-001-<slug>.md                  # Individual feedback entries
├── FB-002-<slug>.md
├── ...
└── REJECTED.md                       # Append-only log of entries rejected at write time

.ultimate-sdlc/framework-revisions-proposed/
├── INDEX.md                          # Proposal index (created on first use)
├── FR-001-<slug>.md                  # Framework revision proposals
└── ...
```

Entries are per-file (not rows in a shared table). IDs are zero-padded and monotonically increasing per namespace (FB-xxx, FR-xxx).

### Four Feedback Types

| Type | Trigger | Scope | Lifetime |
|------|---------|-------|----------|
| `user-correction` | User corrects agent + explains why | Specific council/phase | Active until superseded or promoted |
| `user-preference` | User states how they want work done, unprompted | Broad or narrow | Active until superseded |
| `gate-learning` | Gate failure reveals rule/process gap | Specific gate | Active until gate criterion updated |
| `pattern` | Cycle-end synthesis of ≥2 recurring entries | Cross-cutting | Carried forward to next cycle |

---

## TIER 2: WRITE TRIGGERS

### Trigger W1: User Correction (highest priority)

When the user corrects the agent mid-session AND provides a reason:
1. Invoke `/sdlc-feedback-log`.
2. Required fields: *what was wrong*, *fix applied*, **why** (user's reasoning, quoted verbatim where possible).
3. If no reason is given: **ask for one**. No reason ⇒ no entry (FBP-001).

### Trigger W2: User Preference (proactive)

When the user states a preference about HOW work is done, even without an active error:
1. Invoke `/sdlc-feedback-log --type user-preference`.
2. Capture the preference in the user's own words.

### Trigger W3: Gate Failure

When any quality gate FAILS and the root cause is a rule/process gap (not a code defect):
1. First log the defect per the council's defect/correction protocol.
2. Then invoke `/sdlc-feedback-log --type gate-learning` with: which gate, which criterion, what was missed, what preventive rule would have caught it.

### Trigger W4: Pattern Synthesis (cycle end)

During Validation Council S1, invoke `/sdlc-feedback-promote`:
- Cluster ≥2 recurring active entries into a `pattern` entry.
- Mark constituents `status: promoted` + set `promoted_to: FB-<new-id>`.
- Single-entry promotions are prohibited (FBP-005) — a pattern requires corroboration.

### Anti-Weaponization Check at Write Time

Before creating any feedback entry, the Feedback-Log skill MUST:
1. Parse the proposed entry's "How to apply" section.
2. Check whether applying it would enable any PRH-001..PRH-009 violation.
3. If yes: REJECT. Append to `REJECTED.md` with the PRH ID, reason, and a pointer to the correct channel (e.g., "this is a scope change — update the FEAT spec").
4. If no: proceed to write.

---

## TIER 3: READ TRIGGERS

### Trigger R1: Session Start (all councils)

Every council's Session Protocol MUST include this step:
- Read `.ultimate-sdlc/feedback/INDEX.md`.
- Load entries where `status: active` AND (`council == current_council` OR `council == any`).
- Apply their "How to apply" guidance for the duration of the session.
- Record in WORKING-MEMORY.md under a "Feedback loaded this session" heading: list of FB-NNN IDs + one-line summaries.

### Trigger R2: Pre-AIOU Implementation

Applies to Planning Phases 2.5 / 3 / 3.5 (AIOU generation) AND all Development Waves.

Before starting any AIOU:
- Filter active feedback by (a) `references` containing this AIOU or its parent FEAT, and (b) `tags` intersecting the AIOU's domain tags.
- Apply matched entries' "How to apply" sections to the implementation plan.
- **Conflict rule**: If a feedback entry contradicts the AIOU spec, **the spec wins** — flag the conflict to the user for reconciliation.

### Trigger R3: Pre-Gate Verification

Before verifying any quality gate:
- Load active `gate-learning` entries where `references` contains this gate ID.
- For each, verify the preventive rule has been applied.
- Record verification in the gate report under "Feedback-derived checks".

### Trigger R4: New-Cycle Bootstrap

At `/sdlc-new-cycle`:
- Copy carried-forward `pattern` entries from the prior cycle's archive into the new cycle's `.ultimate-sdlc/feedback/`.
- Set `cycle` frontmatter field to the new cycle ID.
- Entries retain their FB IDs.

---

## TIER 4: FRAMEWORK META-IMPROVEMENT

At `/sdlc-close-cycle` Step 6, the framework-retro workflow runs:

1. Review all `pattern` entries from this cycle plus any carried-forward patterns.
2. Identify patterns that reflect framework-level gaps (not just project-specific preferences).
3. Draft proposed edits to target framework files as `FR-NNN-<slug>.md` under `.ultimate-sdlc/framework-revisions-proposed/`.
4. Each proposal cites the FB entries that motivated it (≥2 unless framework-level bug).
5. Surface the proposals to the user with a summary.
6. **User applies manually** to the framework repo. Agents never write to the framework repo directory.

---

## TIER 5: INTEGRATION POINTS (WHERE FEEDBACK PLUGS IN)

| Integration Point | Action |
|-------------------|--------|
| All council `Session Protocol` sections | Read feedback INDEX.md, load active entries for current council |
| Planning 2.5 / 3 / 3.5 (AIOU generation) | Filter feedback by AIOU tags; apply to specs |
| Development § AIOU Execution Protocol § 0 (Context Load) | Filter feedback by AIOU tags; apply to implementation plan |
| Development § Code Review Protocol | Verify no loaded feedback was violated during the AIOU |
| Every gate verification workflow | Load gate-learning entries for this gate; verify prevention applied |
| Validation S1 (Documentation Update) | Invoke `/sdlc-feedback-promote` for pattern synthesis |
| `/sdlc-close-cycle` Step 6 | Invoke `/sdlc-framework-retro` to draft revision proposals |
| `/sdlc-new-cycle` bootstrap | Load carried-forward pattern entries |

---

## TIER 6: PROHIBITED PATTERNS (FEEDBACK-SPECIFIC)

Violations are logged and, where applicable, blocked at skill boundaries.

### FBP-001: Missing Reasoning

**Prohibited**: Writing a feedback entry with empty or placeholder "Why (user's reasoning)".

**Detection**: `/sdlc-feedback-log` validates the section is non-empty and longer than a threshold (≥15 chars, non-whitespace).

**Required**: If the user corrects without explaining, ASK for the reason. If they decline: do not write the entry.

### FBP-002: Ignoring Loaded Feedback

**Prohibited**: Reading feedback at session start but not applying its "How to apply" during work.

**Detection**: Code Review Protocol step: verify the AIOU implementation does not contradict any loaded entry without a documented reconciliation.

### FBP-003: Auto-Applying Framework Revisions

**Prohibited**: Writing to any file under the framework repo directory as part of `/sdlc-framework-retro` or any other workflow.

**Detection**: Skills must never target the framework repo path. Any such write attempt is a hard failure.

### FBP-004: Using Feedback to Bypass PRH

**Prohibited**: Citing a feedback entry to justify a PRH-001..PRH-009 violation.

**Required**: If feedback appears to authorize a PRH violation, the entry is invalid — the user must restate the change as a spec update.

**Rejection message**: When a feedback entry is rejected for this reason, the rejection message MUST point the user to the correct channel for their request — typically a spec update (FEAT-XXX edit), a gate criteria change, or an ADR — rather than silently refusing. This preserves the user's intent while blocking the PRH violation.

### FBP-005: Single-Entry Pattern Promotion

**Prohibited**: Creating a `pattern` entry from only 1 constituent feedback entry.

**Required**: A pattern requires ≥2 corroborating entries. Exception: if a single entry identifies a framework-level bug (e.g. rule contradicts INTEGRITY-RULES), it may escalate directly to an FR proposal without pattern promotion.

### FBP-006: Speculative Feedback

**Prohibited**: Writing feedback about hypothetical future problems ("we might want to").

**Required**: Feedback captures observed corrections or stated preferences — not speculation.

---

## TIER 7: CONFLICT RESOLUTION WITHIN FEEDBACK

- **Feedback vs spec**: spec wins. Flag conflict to user. Feedback that consistently contradicts specs is a signal the spec needs updating (create FR proposal).
- **Feedback vs INTEGRITY-RULES**: INTEGRITY-RULES win (FR-2). Always.
- **Feedback vs UNIVERSAL-RULES**: UNIVERSAL-RULES win. Feedback can NARROW (add stricter interpretation), not contradict.
- **Feedback vs newer feedback**: newer wins; older entry marked `superseded`.
- **Two active entries contradict**: Most recent `updated` timestamp wins; older entry flagged for review.

---

## TIER 8: QUICK REFERENCE

- **Write feedback**: `/sdlc-feedback-log` (interactive or piped correction)
- **Review active feedback**: `/sdlc-feedback-review`
- **Promote patterns at cycle end**: `/sdlc-feedback-promote` (Validation S1)
- **Draft framework revisions at cycle close**: `/sdlc-framework-retro` (close-cycle Step 6)

Schema reference: `contexts/feedback-schema.md`
Templates: `templates/feedback-entry.md`, `templates/feedback-index.md`, `templates/framework-revision.md`
