# Framework Improvements Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Apply eleven targeted improvements to the Claude Code Ultimate SDLC Framework addressing context overhead, surface area, feedback subsystem rigor, and quality-depth gaps identified in the 2026-04-23 framework review.

**Architecture:** Changes fall into three groups executed in order: (1) **Context-overhead refactors** — split, compress, and table-ize always-on rules to reclaim ~800-1000 lines of P0 context; (2) **Measurement infrastructure** — gate hit-rate tracking and workflow invocability flags to make the system self-auditing; (3) **Feedback & quality features** — mid-cycle promotion, single-entry exceptions, rule-deletion budgets, and structured manual QA fallbacks. Every change is additive or minimally destructive; extracted content moves to reference files loaded on demand.

**Tech Stack:** Markdown (YAML frontmatter + body), bash/grep/awk for scripted edits across ~171 workflow files, git for atomic commits per task.

**Repository Root:** `/home/jons/AntigravityFrameworks/claude-code-framework/`

---

## File Structure

### New files (created)

| Path | Responsibility |
|------|---------------|
| `rules/integrity-enforcement.md` | Detailed PRH enforcement protocol, self-check protocol, integrity verification protocol, run recovery protocol. Loaded on-demand at gate verification and on violation detection. |
| `rules/anti-slop-code-reference.md` | Extended rationale for every banned pattern in anti-slop-code.md. Loaded on-demand when writing code likely to violate a pattern. |
| `contexts/gate-hit-rate-schema.md` | Schema for per-gate evaluation counters: `times_evaluated`, `times_failed`, `last_failure_cycle`, failure reason tally. |
| `templates/gate-hit-rate-tracker.md` | Initial template for `.ultimate-sdlc/gate-hit-rate.md` in project installs. |
| `commands/sdlc-gate-log.md` | Thin wrapper skill invoked by every gate workflow to append one row to the hit-rate tracker. |
| `skills/gate-log/SKILL.md` | Skill body for gate-log — reads gate ID + result from caller, appends row, returns. |

### Modified files

| Path | Change |
|------|--------|
| `rules/universal-rules.md` | Table-ize Tiers 0.5–0.11 narrative sections; update P0 list (remove feedback-rules from always-on, add pointer); prune duplication with INTEGRITY-RULES. |
| `rules/integrity-rules.md` | Slim to awareness-only (PRH IDs + one-line descriptions + triggers); move enforcement/self-check/recovery protocols to integrity-enforcement.md. |
| `rules/anti-slop-code.md` | Slim to 30-second slop test + banned-pattern name table + required-alternative column only; move "Why Banned" rationale + expanded examples to anti-slop-code-reference.md. |
| `rules/feedback-rules.md` | Update P0 declaration to "conditional-P0: loaded when feedback skills invoked or at Session Protocol feedback step"; remove duplicated content now canonical in universal-rules.md. |
| `rules/council-audit.md` | Add gate-log invocation to Pre-Gate Feedback Check section. |
| `rules/council-planning.md` | Same. |
| `rules/council-development.md` | Same; restructure Visual QA Protocol manual-QA fallback into required 3-item checklist. |
| `rules/council-validation.md` | Same; add mid-cycle promotion trigger to S1 Feedback Promotion section. |
| `commands/sdlc-feedback-promote.md` | Add mid-cycle trigger logic (≥3 entries in single council); add single-entry exception for `gate-learning` + framework-inconsistency. |
| `skills/feedback-promote/SKILL.md` | Sync with command changes. |
| `commands/sdlc-framework-retro.md` | Add mandatory "rule-deletion proposal" section: every retro proposes ≥1 rule to retire or explicit justification. |
| `skills/framework-retro/SKILL.md` | Sync with command changes. |
| `commands/sdlc-ag-help.md` | Filter workflow listing by `user_invocable: true` frontmatter; add `--all` flag to show internal workflows. |
| All 13 gate workflows (`commands/sdlc-*gate*.md`) | Add single-line step invoking `/sdlc-gate-log` after decision recorded. |
| All 171 workflow files (`commands/sdlc-*.md`) | Add `user_invocable: true\|false` frontmatter field. |

---

## Task Ordering Rationale

Tasks 1-5 (**context-overhead refactors**) land first so subsequent feature work operates on the cleaner rule files. Tasks 6-8 (**measurement**) add data-collection infrastructure used by later retros. Tasks 9-12 (**feedback + quality features**) build on the measurement infrastructure. Task 13 is final cross-reference validation.

---

## Task 1: Table-ize UNIVERSAL-RULES narrative sections

**Files:**
- Modify: `rules/universal-rules.md` (Tiers 0.5, 0.6, 0.7, 0.10, 0.11, 0.20)

**Target reduction:** 100-150 lines from universal-rules.md without information loss.

- [ ] **Step 1: Baseline line count**

Run: `wc -l rules/universal-rules.md`
Expected output: `289 rules/universal-rules.md`
Record baseline: `BASELINE=289`

- [ ] **Step 2: Convert Tier 0.5 (Zero-Compromise Principle) prose to table**

Open `rules/universal-rules.md`. Locate the `### 0.5 Zero-Compromise Principle` section. Replace the prose block with:

```markdown
### 0.5 Zero-Compromise Principle

| Prohibited | Example | Required Alternative |
|-----------|---------|---------------------|
| Vague deferral | "We'll figure this out during development" | `DEFERRED:[reason]:[owner]:[target-phase]` |
| Placeholder scope | "TBD", "Approximately X features" | Exact count, reference scope-lock.md |
| Approximate counts | "~15 features", "about 100 AIOUs" | Exact integer from scope-lock.md |
| Symptom-fixing | Fix without root cause analysis | Root cause documented, symptom fix rejected |

**DEFERRED format**: `DEFERRED:[reason]:[owner]:[target-phase]`. All three fields required. Track in `.ultimate-sdlc/specs/deferred-decisions.md`. Gate fails if DEFERRED items targeting current phase remain OPEN.
```

- [ ] **Step 3: Convert Tier 0.6 Request Classification narrative to table-only**

The existing table is fine; remove the paragraph immediately preceding it that repeats its content. Keep only the table + the 2-line intro.

- [ ] **Step 4: Convert Tier 0.7 Socratic Gate to checklist**

Replace prose with:

```markdown
### 0.7 Socratic Gate

For COMPLEX requests, ask 2-3 questions BEFORE implementing:

- [ ] Expected behavior documented?
- [ ] Edge cases enumerated?
- [ ] Constraints identified (time, dependency, compatibility)?

**Rule**: If 1% is unclear → ASK. Never assume.
```

- [ ] **Step 5: Convert Tier 0.10 Focus Lens Protocol to table-only**

The table already exists; remove the three paragraphs before it that describe "awareness, not hard blocking" and merge that single sentence into the table header row.

- [ ] **Step 6: Convert Tier 0.11 Conflict Resolution to table**

Replace the bulleted list + prose under `**Resolution rules**:` with:

```markdown
### 0.11 Conflict Resolution

**Priority**: P0 > P1 > P2 > P3. P0 = UNIVERSAL/INTEGRITY; P1 = council; P2 = agent; P3 = skill.

| Conflict Type | Winner | Rule |
|--------------|--------|------|
| P0 vs P1 | P0 | P1 may NARROW, not contradict |
| P0 vs P2/P3 | P0 | Unless agent has explicit `## Override` with rationale (P2 only) |
| P1 vs P2 | P2 | Agent-specific behavior wins |
| Ambiguous | Safer | Priority: data safety > security > conservative scope > more verification |

[Specific Cases table unchanged below]
```

- [ ] **Step 7: Convert Tier 0.20 Autonomous Decision Protocol to numbered table**

Replace prose with:

```markdown
### 0.20 Autonomous Decision Protocol

| Step | Action |
|------|--------|
| 1 | Search codebase for existing patterns; if found, follow |
| 2 | Evaluate options: security (safest) > simplicity (simpler) > consistency (matches existing) > reversibility (more reversible) |
| 3 | Record decision + rationale in WORKING-MEMORY.md |
| 4 | If decision affects >3 files OR >1 feature: create ADR |
| 5 | When equally valid: choose most common industry convention for stack |
```

- [ ] **Step 8: Verify no broken cross-references**

Run: `grep -rn "0\.5\|0\.6\|0\.7\|0\.10\|0\.11\|0\.20" rules/ commands/ agents/ skills/ | grep -v universal-rules.md`

Expected: any match found should still resolve — the section headers above retain their numbering.

- [ ] **Step 9: Verify line reduction**

Run: `wc -l rules/universal-rules.md`
Expected: ≤ `BASELINE - 80` (at least 80 lines removed; stretch target 150).

- [ ] **Step 10: Commit**

```bash
git add rules/universal-rules.md
git commit -m "refactor(rules): table-ize UNIVERSAL-RULES narrative sections

Converts Tiers 0.5, 0.6, 0.7, 0.10, 0.11, 0.20 from prose to tables
without information loss. Reduces always-on P0 context."
```

---

## Task 2: Prune rule duplication across P0 files

**Files:**
- Modify: `rules/universal-rules.md` (Tier 0.21 Feedback-Driven Learning — slim to pointer)
- Modify: `rules/feedback-rules.md` (FR-1, FR-2 — remove content duplicated in integrity-rules)
- Modify: `rules/integrity-rules.md` (PRH-007 — canonical scope-integrity definition; universal-rules becomes pointer)

- [ ] **Step 1: Identify duplicates**

Run:
```bash
grep -n "scope integrity\|Scope Integrity\|scope-lock" rules/universal-rules.md rules/integrity-rules.md rules/feedback-rules.md rules/council-planning.md
```

Record lines where the same concept is defined multiply.

- [ ] **Step 2: Make INTEGRITY-RULES § PRH-007 the canonical scope-integrity source**

Leave PRH-007 in `rules/integrity-rules.md` as the single authoritative definition.

- [ ] **Step 3: Reduce universal-rules § 0.5 scope reference to a pointer**

In `rules/universal-rules.md` Tier 0.5, replace any paragraph re-explaining scope integrity with:

```markdown
**Scope integrity**: See INTEGRITY-RULES.md § PRH-007. All features from product concept in scope by default; no unilateral MoSCoW/MVP/priority categorization.
```

- [ ] **Step 4: Reduce feedback-rules § FR-2 to a pointer**

In `rules/feedback-rules.md` § FR-2, replace the PRH enumeration (PRH-002, PRH-003, PRH-006/007/008) with:

```markdown
### FR-2: Feedback Never Bypasses Integrity Rules

Feedback cannot justify any PRH-001..PRH-009 violation. See INTEGRITY-RULES.md for the full enumeration. Write-time rejection applies per FBP-004; rejections logged to `REJECTED.md`.
```

- [ ] **Step 5: Verify still-complete coverage**

Run:
```bash
grep -c "PRH-00" rules/integrity-rules.md
```

Expected: all 9 PRHs (PRH-001 through PRH-009) defined exactly once. Verify count: `grep -E "### PRH-00[1-9]" rules/integrity-rules.md | wc -l` should equal `9`.

- [ ] **Step 6: Verify no dangling pointers**

Run:
```bash
grep -rn "PRH-007\|PRH-008\|PRH-009" rules/ commands/ agents/ skills/
```

Every match should either (a) be in integrity-rules.md itself, or (b) reference INTEGRITY-RULES as the source. No standalone re-definitions.

- [ ] **Step 7: Commit**

```bash
git add rules/universal-rules.md rules/integrity-rules.md rules/feedback-rules.md
git commit -m "refactor(rules): deduplicate PRH references across P0 files

PRH-007 (scope integrity) defined once in INTEGRITY-RULES.md.
UNIVERSAL-RULES and feedback-rules become pointers."
```

---

## Task 3: Split INTEGRITY-RULES into awareness + enforcement

**Files:**
- Create: `rules/integrity-enforcement.md`
- Modify: `rules/integrity-rules.md`

**Target reduction:** 120-150 lines off always-on INTEGRITY-RULES.

- [ ] **Step 1: Create integrity-enforcement.md with extracted content**

Write `rules/integrity-enforcement.md`:

```markdown
# INTEGRITY-ENFORCEMENT.md — Detailed Protocols

**Load when**: Any gate verification workflow runs | Any PRH violation is suspected | Run recovery is triggered.
**Load mechanism**: Gate workflows Read this file explicitly as Step 1. PRH violation detection triggers Read. Not loaded at session start.

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

### Pre-Completion Checkpoint (MANDATORY at gates)

Before claiming ANY phase/wave/run/gate complete, paste this into WORKING-MEMORY.md:

[PASTE VERBATIM from old integrity-rules.md § INTEGRITY VERIFICATION PROTOCOL]

**Gate Integration**: Gates verify checkpoint exists, counts match, all PRH = NO, all commands exit 0. Missing/incomplete checkpoint = automatic gate FAIL.

---

## AUTONOMOUS OPERATION PROTOCOL

[PASTE VERBATIM from old integrity-rules.md § AUTONOMOUS OPERATION PROTOCOL]

---

## RUN RECOVERY PROTOCOL

[PASTE VERBATIM from old integrity-rules.md § RUN RECOVERY PROTOCOL]
```

- [ ] **Step 2: Copy the actual verbatim content**

From `rules/integrity-rules.md` (original), extract the following three sections to the placeholders above in `integrity-enforcement.md`:
- Everything under `## INTEGRITY VERIFICATION PROTOCOL` through the next `---`
- Everything under `## AUTONOMOUS OPERATION PROTOCOL` through the next `---`
- Everything under `## RUN RECOVERY PROTOCOL` through end of file

Verify: `rules/integrity-enforcement.md` now contains each of these sections exactly once, in full.

- [ ] **Step 3: Slim integrity-rules.md**

In `rules/integrity-rules.md`, delete the three sections just copied (INTEGRITY VERIFICATION PROTOCOL, AUTONOMOUS OPERATION PROTOCOL, RUN RECOVERY PROTOCOL). Replace with a single pointer section at end of file:

```markdown
---

## Detailed Protocols

Enforcement Protocol, Self-Check Protocol, Integrity Verification Protocol (Pre-Completion Checkpoint template), Autonomous Operation Protocol, and Run Recovery Protocol are defined in **integrity-enforcement.md** — loaded on demand at gate verification and on violation detection.
```

Keep: Prohibited Behaviors section (PRH-001 through PRH-009) — this is awareness, stays in always-on.
Keep: Enforcement Protocol as a 5-line summary (move detailed version to integrity-enforcement.md).

- [ ] **Step 4: Update gate workflow Step 1 to load enforcement file**

For each file in `commands/sdlc-*gate*.md`, verify or add at the top of the workflow body (after frontmatter):

```markdown
**Step 0 — Load enforcement protocols**: Read `rules/integrity-enforcement.md`. This provides the Pre-Completion Checkpoint template and verification protocol required for gate evaluation.
```

Use a scripted edit:

```bash
for f in commands/sdlc-*gate*.md; do
  if ! grep -q "integrity-enforcement.md" "$f"; then
    # Insert after first --- (end of frontmatter)
    awk '/^---$/{count++; print; if(count==2) print "\n**Step 0 — Load enforcement protocols**: Read `rules/integrity-enforcement.md` before verifying gate criteria.\n"; next} {print}' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
  fi
done
```

- [ ] **Step 5: Verify line reduction**

Run: `wc -l rules/integrity-rules.md rules/integrity-enforcement.md`
Expected:
- `rules/integrity-rules.md` ≤ 100 (was 216)
- `rules/integrity-enforcement.md` ≥ 100 (contains extracted content)
- Sum ≥ 200 (no content lost)

- [ ] **Step 6: Verify all PRHs still reachable**

Run: `grep -E "PRH-00[1-9]" rules/integrity-rules.md | wc -l`
Expected: ≥ 18 (each PRH referenced in header + required-behavior line at minimum)

- [ ] **Step 7: Commit**

```bash
git add rules/integrity-rules.md rules/integrity-enforcement.md commands/sdlc-*gate*.md
git commit -m "refactor(rules): split INTEGRITY-RULES into awareness + enforcement

integrity-rules.md keeps PRH awareness (always-on P0).
integrity-enforcement.md holds detailed protocols (loaded on-demand at gates).
All 13 gate workflows now explicitly Read integrity-enforcement.md as Step 0."
```

---

## Task 4: Compress anti-slop-code.md + create reference

**Files:**
- Create: `rules/anti-slop-code-reference.md`
- Modify: `rules/anti-slop-code.md`

- [ ] **Step 1: Create anti-slop-code-reference.md**

Write `rules/anti-slop-code-reference.md` with the following structure:

```markdown
# Anti-Slop Code — Extended Reference

**Load when**: Writing code in an AIOU that touches a banned pattern's domain (security code, component decomposition, state management, error handling).
**Load mechanism**: Explicit Read at AIOU start when the AIOU spec mentions a domain covered below.

This is the extended rationale + examples for anti-slop-code.md. The core rules file stays minimal for always-on loading; this file provides the "why" and concrete examples when an agent is about to write code that might violate.

---

## Why Each Pattern Is Banned

[For each section 1-7 from anti-slop-code.md, expand with: rationale, concrete violation examples, recommended alternative with code sample]
```

- [ ] **Step 2: Move "Why Banned" content from anti-slop-code.md to reference**

For each of the seven tables in `rules/anti-slop-code.md` (sections 1-7), copy the "Why Banned" column content and expand each cell into a subsection in the reference file. Leave the table intact in the original file but the reference now has deeper explanation.

- [ ] **Step 3: Slim anti-slop-code.md**

Rewrite `rules/anti-slop-code.md` to retain:
- Core Mandate (1 paragraph)
- 7 tables: Pattern | Required Alternative (two columns only — drop Why Banned column)
- Slop Detection Checklist
- 30-Second Slop Test
- Enforcement section (slim to 3 lines)
- Pointer to reference file

Drop from always-on:
- Expanded prose under each section
- Example code blocks (move to reference)
- Section headers 5, 6, 7 detailed breakdowns

Target final length: ≤ 80 lines (from 140).

- [ ] **Step 4: Add load-point to Wave 3/4/5 workflows**

For Wave 3 (services), Wave 4 (API), and Wave 5 (UI) workflows, add at the top:

```markdown
**Reference load**: If this AIOU touches security, error handling, or component decomposition, Read `rules/anti-slop-code-reference.md` before implementing.
```

Apply to: `commands/sdlc-dev-wave-3.md`, `commands/sdlc-dev-wave-4.md`, `commands/sdlc-dev-wave5-start.md`, `commands/sdlc-dev-wave5-next.md`.

- [ ] **Step 5: Verify line reduction**

Run: `wc -l rules/anti-slop-code.md rules/anti-slop-code-reference.md`
Expected:
- `rules/anti-slop-code.md` ≤ 80 (was 140)
- Sum ≥ 180 (content preserved)

- [ ] **Step 6: Commit**

```bash
git add rules/anti-slop-code.md rules/anti-slop-code-reference.md commands/sdlc-dev-wave-3.md commands/sdlc-dev-wave-4.md commands/sdlc-dev-wave5-start.md commands/sdlc-dev-wave5-next.md
git commit -m "refactor(rules): split anti-slop-code into summary + reference

anti-slop-code.md kept minimal for always-on P0 (ban table + checklist).
anti-slop-code-reference.md holds rationale + examples (on-demand).
Wave 3/4/5 workflows explicitly load reference when AIOU touches relevant domain."
```

---

## Task 5: Promote feedback-rules.md from P0 to conditional-P0

**Files:**
- Modify: `rules/feedback-rules.md`
- Modify: `rules/universal-rules.md` (Tier 0.21)
- Modify: All four council rule files (add explicit Read step in Session Protocol)

- [ ] **Step 1: Update feedback-rules.md header**

Replace the first paragraph of `rules/feedback-rules.md` with:

```markdown
# FEEDBACK-RULES.md — Feedback-Driven Learning

**Load status**: Conditional-P0. Loaded at (a) every council's Session Protocol feedback step, (b) invocation of any `/sdlc-feedback-*` or `/sdlc-framework-retro` command. Not loaded at agent spin-up.

This file governs the feedback subsystem: how the framework captures user corrections with reasoning, applies them to future work, and proposes framework-level improvements.

**Core Principle** (always-on, mirrored in UNIVERSAL-RULES § 0.21): Feedback captures **how** the team wants work done. Requirements capture **what** the system does. The two are orthogonal.

[Rest of file unchanged]
```

- [ ] **Step 2: Update universal-rules.md § 0.21**

Slim `rules/universal-rules.md` Tier 0.21 Feedback-Driven Learning to just the core principle + trigger list. Remove detailed protocol references; they live in feedback-rules.md now loaded conditionally.

New § 0.21 (target ≤ 20 lines):

```markdown
### 0.21 Feedback-Driven Learning

Feedback captures HOW the team wants work done; specs capture WHAT the system does. Orthogonal.

**Storage**: `.ultimate-sdlc/feedback/` (per-project, `pattern` entries carry forward across cycles).

**Protocol file**: `rules/feedback-rules.md` — loaded at every council's Session Protocol feedback step and on invocation of any feedback command. Not loaded at agent spin-up.

**Triggers**:
| Event | Action |
|-------|--------|
| User corrects + explains | `/sdlc-feedback-log` |
| User states preference | `/sdlc-feedback-log --type user-preference` |
| Gate fails on rule gap | `/sdlc-feedback-log --type gate-learning` |
| Cycle end (S1) | `/sdlc-feedback-promote` |
| Cycle close | `/sdlc-framework-retro` (propose-only) |

**Hard constraint** (from feedback-rules.md FR-2): Feedback NEVER justifies a PRH violation. Enforced at write time.
```

- [ ] **Step 3: Update every council rule file Session Protocol**

In each of `rules/council-planning.md`, `rules/council-development.md`, `rules/council-audit.md`, `rules/council-validation.md`, locate the Session Protocol section. Change the "Feedback load" step to:

```markdown
6. **Feedback load** (per `rules/feedback-rules.md § Trigger R1` — Read feedback-rules.md first, then): Invoke `/sdlc-feedback-review` → load active feedback entries for `council: <current>` or `council: any`. Apply their "How to apply" during this session. Record loaded IDs in WORKING-MEMORY.md under "Feedback loaded this session".
```

Verify step is in all four files: `grep -l "Feedback load" rules/council-*.md | wc -l` should equal `4`.

- [ ] **Step 4: Verify P0 set**

Run: `grep "Always Loaded\|P0 Rule" rules/universal-rules.md`
Expected: the P0 list names only `UNIVERSAL-RULES.md`, `INTEGRITY-RULES.md` (anti-slop stays mentioned but anti-slop-visual stays conditional, anti-slop-code stays P0 summary-only). feedback-rules.md must NOT appear in the always-on P0 list.

Update the `**P0 Rule Files (Always Loaded)**:` line to:

```markdown
**P0 Rule Files (Always Loaded)**: `UNIVERSAL-RULES.md`, `INTEGRITY-RULES.md`, `anti-slop-code.md` (summary form).
**Conditional-P0 Files**: `feedback-rules.md` (loaded at feedback triggers), `integrity-enforcement.md` (loaded at gates), `anti-slop-code-reference.md` (loaded at relevant AIOUs), `anti-slop-visual.md` (loaded at UI work).
```

- [ ] **Step 5: Commit**

```bash
git add rules/feedback-rules.md rules/universal-rules.md rules/council-*.md
git commit -m "refactor(rules): move feedback-rules to conditional-P0

feedback-rules.md no longer loaded at agent spin-up. Loaded on demand
at Session Protocol feedback step and on any /sdlc-feedback-* invocation.
Core principle mirrored in UNIVERSAL-RULES 0.21 (20 lines) for always-on awareness."
```

---

## Task 6: Gate hit-rate tracking — schema + skill + template

**Files:**
- Create: `contexts/gate-hit-rate-schema.md`
- Create: `templates/gate-hit-rate-tracker.md`
- Create: `commands/sdlc-gate-log.md`
- Create: `skills/gate-log/SKILL.md`

- [ ] **Step 1: Write the schema**

Create `contexts/gate-hit-rate-schema.md`:

```markdown
# Gate Hit-Rate Schema

**Purpose**: Track which gate criteria actually catch defects over time. Data feeds `/sdlc-framework-retro` to propose retiring criteria that never fail.

**Storage**: `.ultimate-sdlc/gate-hit-rate.md` (per-project, appended per gate evaluation).

## Entry Format

Each gate evaluation appends one row to the tracker:

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| gate_id | string | yes | e.g. `1.5`, `I4`, `A3`, `V5`, `S2` |
| council | enum | yes | planning \| development \| audit \| validation |
| cycle_id | string | yes | From project-manifest.md, e.g. `cycle-001` |
| timestamp | ISO-8601 | yes | When verification completed |
| result | enum | yes | PASS \| FAIL |
| failed_criteria | array | if FAIL | List of criterion IDs that failed |
| iteration | integer | yes | Which attempt at this gate in this cycle (1 for first try, 2 for retry after fix) |

## Aggregate Metrics

Derived at retro time:

- `times_evaluated[gate_id][criterion_id]` — total evaluations across all cycles
- `times_failed[gate_id][criterion_id]` — total failures
- `hit_rate[gate_id][criterion_id]` = failures / evaluations
- `last_failure_cycle[gate_id][criterion_id]` — most recent cycle where criterion failed
- `never_failed[gate_id][criterion_id]` — boolean, true if times_failed == 0

## Retirement Candidate Criteria

A criterion is a retirement candidate when:
- `times_evaluated >= 5` (enough data) AND
- `hit_rate == 0` (never caught anything) AND
- `last_failure_cycle == null`

Retirement is proposed, not automatic. `/sdlc-framework-retro` surfaces candidates for user review.
```

- [ ] **Step 2: Write the template**

Create `templates/gate-hit-rate-tracker.md`:

```markdown
# Gate Hit-Rate Tracker

**Format**: Per-gate-evaluation append-only log. See `contexts/gate-hit-rate-schema.md`.

## Evaluations

| gate_id | council | cycle_id | timestamp | result | failed_criteria | iteration |
|---------|---------|----------|-----------|--------|----------------|-----------|
| <!-- First evaluation appends here --> |

## Aggregate (regenerated on demand)

| gate_id | criterion_id | times_evaluated | times_failed | hit_rate | last_failure_cycle |
|---------|--------------|-----------------|--------------|----------|-------------------|
```

- [ ] **Step 3: Write the command wrapper**

Create `commands/sdlc-gate-log.md`:

```markdown
---
description: Append a gate evaluation row to .ultimate-sdlc/gate-hit-rate.md. Invoked by every gate workflow after decision recorded.
user_invocable: false
---

# /sdlc-gate-log

Internal skill invoked by gate verification workflows. Appends one row to the hit-rate tracker.

**Usage**: Invoked automatically by `/sdlc-*-gate-*` workflows. Not intended for direct user invocation.

```
Skill: gate-log
```
```

- [ ] **Step 4: Write the skill body**

Create `skills/gate-log/SKILL.md`:

```markdown
---
name: gate-log
description: Append a single evaluation row to .ultimate-sdlc/gate-hit-rate.md. Called internally by every gate verification workflow.
---

# Gate Log Skill

## Invocation Context

Called as the final step of every `/sdlc-*-gate-*` workflow, AFTER the gate decision (PASS/FAIL) has been written to the gate report.

## Inputs (from calling workflow context)

- `gate_id`: e.g. `1.5`, `I4`, `A3`, `V5`, `S2`
- `council`: planning | development | audit | validation
- `result`: PASS | FAIL
- `failed_criteria`: array of criterion IDs (empty if PASS)

## Steps

1. Read `.ultimate-sdlc/project-manifest.md` → extract current `cycle_id`.
2. Read `.ultimate-sdlc/council-state/<council>/current-state.md` → extract iteration count for this gate.
3. Generate ISO-8601 timestamp.
4. Append one row to `.ultimate-sdlc/gate-hit-rate.md` under `## Evaluations`. If file does not exist, initialize from `templates/gate-hit-rate-tracker.md` first.
5. Return silently — no user-facing output unless write failed.

## Error Handling

If `.ultimate-sdlc/gate-hit-rate.md` write fails, log to WORKING-MEMORY.md and continue. Hit-rate logging is best-effort; it MUST NOT block gate completion.

## No Side Effects on Gate Decision

This skill NEVER changes the gate result. It only records it.
```

- [ ] **Step 5: Verify files exist and lint**

Run:
```bash
ls -la contexts/gate-hit-rate-schema.md templates/gate-hit-rate-tracker.md commands/sdlc-gate-log.md skills/gate-log/SKILL.md
```
Expected: all four files present and non-empty.

- [ ] **Step 6: Commit**

```bash
git add contexts/gate-hit-rate-schema.md templates/gate-hit-rate-tracker.md commands/sdlc-gate-log.md skills/gate-log/SKILL.md
git commit -m "feat(gates): add gate hit-rate tracking infrastructure

Adds schema, template, wrapper command, and skill for logging every
gate evaluation to .ultimate-sdlc/gate-hit-rate.md. Enables retros
to identify criteria that never catch defects and propose retirement.
Wiring to individual gate workflows in next commit."
```

---

## Task 7: Wire gate-log into all 13 gate workflows

**Files:**
- Modify: all `commands/sdlc-*gate*.md` (13 files)

- [ ] **Step 1: Add gate-log invocation to one gate as template**

Open `commands/sdlc-planning-gate-8.md`. After the final step that records the gate decision in `.ultimate-sdlc/council-state/planning/gate-reports/`, add:

```markdown
### Final Step: Log evaluation

Invoke `/sdlc-gate-log` with:
- `gate_id`: `8`
- `council`: `planning`
- `result`: [PASS|FAIL from gate decision above]
- `failed_criteria`: [array of criterion IDs that failed, empty if PASS]

This appends a row to `.ultimate-sdlc/gate-hit-rate.md` for retro-time analysis. Logging failure does NOT reverse the gate decision.
```

- [ ] **Step 2: Verify the template works in one gate**

Manually inspect `commands/sdlc-planning-gate-8.md`:
- Final Step appears after gate decision
- gate_id matches filename
- council correct

- [ ] **Step 3: Apply to remaining 12 gates via script**

```bash
declare -A GATE_MAP=(
  ["planning-gate-1-5"]="1.5:planning"
  ["planning-gate-3-5"]="3.5:planning"
  ["dev-gate-i4"]="I4:development"
  ["dev-gate-i8"]="I8:development"
  ["audit-gate-t3"]="T3:audit"
  ["audit-gate-a2"]="A2:audit"
  ["audit-gate-a3"]="A3:audit"
  ["validate-gate-v5"]="V5:validation"
  ["validate-gate-c4"]="C4:validation"
  ["validate-gate-p4"]="P4:validation"
  ["validate-gate-e4"]="E4:validation"
  ["validate-gate-s2"]="S2:validation"
)

for key in "${!GATE_MAP[@]}"; do
  IFS=':' read -r gate_id council <<< "${GATE_MAP[$key]}"
  file="commands/sdlc-${key}.md"
  if ! grep -q "sdlc-gate-log" "$file"; then
    cat >> "$file" << EOF

---

### Final Step: Log evaluation

Invoke \`/sdlc-gate-log\` with:
- \`gate_id\`: \`$gate_id\`
- \`council\`: \`$council\`
- \`result\`: [PASS|FAIL from gate decision above]
- \`failed_criteria\`: [array of criterion IDs that failed, empty if PASS]

This appends a row to \`.ultimate-sdlc/gate-hit-rate.md\` for retro-time analysis. Logging failure does NOT reverse the gate decision.
EOF
  fi
done
```

- [ ] **Step 4: Verify all 13 gates wired**

Run: `grep -l "sdlc-gate-log" commands/sdlc-*gate*.md | wc -l`
Expected: `13`

- [ ] **Step 5: Commit**

```bash
git add commands/sdlc-*gate*.md
git commit -m "feat(gates): wire gate-log invocation into all 13 gate workflows

Every gate verification now appends an evaluation row to the hit-rate
tracker after recording its decision. Logging is best-effort and
never affects the gate result."
```

---

## Task 8: Add `user_invocable` frontmatter to all workflows

**Files:**
- Modify: all 171 workflow files (`commands/sdlc-*.md`)

**Classification rule:** User-invocable workflows are entry points a user types directly. Internal workflows are called only by orchestrators (e.g. `/sdlc-continue`) or other workflows. Default to `user_invocable: true` for public-facing workflows; explicitly mark internal-only workflows `false`.

- [ ] **Step 1: Define the user-invocable allowlist**

Create `scripts/classify-workflows.sh` with the canonical list. User-invocable entry points (the ones users type):

```bash
USER_INVOCABLE=(
  # Lifecycle
  "init" "adopt" "new-cycle" "close-cycle" "plan" "create" "enhance" "status" "continue" "recover" "amend" "rollback"
  # Planning entry points
  "planning-start" "planning-handoff" "planning-upgrade"
  "patch-planning" "maintenance-planning" "improvement-planning"
  "brainstorm" "plan"
  # Dev entry points
  "dev-start" "dev-status" "dev-complete" "dev-upgrade"
  "dev-wave-1" "dev-wave-2" "dev-wave-3" "dev-wave-4" "dev-wave-6"
  "dev-wave5-start" "dev-wave5-status"
  "dev-ui-research" "dev-ui-design-plan" "dev-ui-verify"
  "dev-ui-audit" "dev-ui-polish" "dev-ui-retheme" "dev-ui-redesign"
  # Audit entry points
  "audit-start" "audit-status" "audit-report" "audit-complete"
  "audit-defect" "audit-enhancement" "audit-feature" "audit-think"
  # Validate entry points
  "validate-start" "validate-status" "validate-complete" "validate-report"
  "validate-feature" "validate-production" "validate-framework"
  # Feedback
  "feedback-log" "feedback-review" "feedback-promote" "framework-retro"
  # Other
  "ag-help" "deploy" "preview" "release" "debug" "test" "orchestrate"
  "ui-ux-pro-max" "council-switch" "ralph-wave" "ralph-corrections" "ralph-defects"
  "gate-log" # entry exists but marked false below — it's internal
)
```

All other workflows (phase-internal, wave-internal, sub-step workflows like `planning-phase-3`, `dev-aiou`, `audit-a1`, `validate-c1`, etc.) become `user_invocable: false`.

- [ ] **Step 2: Write the classification script**

```bash
cat > scripts/add-user-invocable-flag.sh << 'EOF'
#!/usr/bin/env bash
set -euo pipefail

USER_INVOCABLE_LIST="init adopt new-cycle close-cycle plan create enhance status continue recover amend rollback
planning-start planning-handoff planning-upgrade patch-planning maintenance-planning improvement-planning brainstorm
dev-start dev-status dev-complete dev-upgrade dev-wave-1 dev-wave-2 dev-wave-3 dev-wave-4 dev-wave-6 dev-wave5-start dev-wave5-status
dev-ui-research dev-ui-design-plan dev-ui-verify dev-ui-audit dev-ui-polish dev-ui-retheme dev-ui-redesign
audit-start audit-status audit-report audit-complete audit-defect audit-enhancement audit-feature audit-think
validate-start validate-status validate-complete validate-report validate-feature validate-production validate-framework
feedback-log feedback-review feedback-promote framework-retro
ag-help deploy preview release debug test orchestrate ui-ux-pro-max council-switch ralph-wave ralph-corrections ralph-defects"

for f in commands/sdlc-*.md; do
  name=$(basename "$f" .md | sed 's/^sdlc-//')
  if echo "$USER_INVOCABLE_LIST" | tr ' ' '\n' | grep -qx "$name"; then
    flag="true"
  else
    flag="false"
  fi

  # Skip if already has user_invocable
  if grep -q "^user_invocable:" "$f"; then
    continue
  fi

  # Insert user_invocable line after description: in frontmatter
  awk -v flag="$flag" '
    BEGIN { in_fm=0; fm_count=0; inserted=0 }
    /^---$/ { fm_count++; print; if (fm_count==1) in_fm=1; else in_fm=0; next }
    in_fm && /^description:/ && !inserted { print; print "user_invocable: " flag; inserted=1; next }
    { print }
  ' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
done
EOF
chmod +x scripts/add-user-invocable-flag.sh
./scripts/add-user-invocable-flag.sh
```

- [ ] **Step 3: Verify every workflow has the flag**

Run:
```bash
grep -L "^user_invocable:" commands/sdlc-*.md
```
Expected: empty output (every file has the field).

- [ ] **Step 4: Verify counts**

Run:
```bash
echo "user_invocable: true -> $(grep -l '^user_invocable: true' commands/sdlc-*.md | wc -l)"
echo "user_invocable: false -> $(grep -l '^user_invocable: false' commands/sdlc-*.md | wc -l)"
```
Expected: roughly `~70 true / ~100 false` (ratio may vary — confirm false ≥ true since most workflows are internal phase/wave sub-steps).

- [ ] **Step 5: Spot-check classification**

Manually verify 5 workflows:
- `commands/sdlc-init.md` → true
- `commands/sdlc-planning-phase-3.md` → false (internal)
- `commands/sdlc-dev-aiou.md` → false (internal)
- `commands/sdlc-feedback-log.md` → true
- `commands/sdlc-gate-log.md` → false (internal, set in Task 6)

- [ ] **Step 6: Commit**

```bash
git add scripts/add-user-invocable-flag.sh commands/sdlc-*.md
git commit -m "feat(workflows): classify workflows as user-invocable or internal

Adds user_invocable: true|false to all 171 workflow frontmatters.
Enables /sdlc-ag-help to show only user-facing entry points by default.
Internal phase/wave sub-workflows marked false."
```

---

## Task 9: Update /sdlc-ag-help to filter by user_invocable

**Files:**
- Modify: `commands/sdlc-ag-help.md`
- Modify: `skills/ag-help/SKILL.md` (if exists; otherwise inline in command)

- [ ] **Step 1: Locate ag-help implementation**

Run:
```bash
ls skills/ag-help/ 2>/dev/null || echo "no skill dir"
cat commands/sdlc-ag-help.md
```

- [ ] **Step 2: Update ag-help logic**

Modify the workflow to (a) parse each workflow file's frontmatter, (b) filter by `user_invocable: true` by default, (c) accept `--all` flag to show everything including internals.

Add to the workflow body:

```markdown
## Filtering Behavior

By default, `/sdlc-ag-help` lists only workflows with `user_invocable: true` in frontmatter. Internal orchestration workflows are hidden.

**Flags**:
- `/sdlc-ag-help` — user-facing only (~70 commands)
- `/sdlc-ag-help --all` — include internal workflows (~171 commands)
- `/sdlc-ag-help --council <name>` — filter to one council's user-invocable commands

## Implementation

For each file in `commands/sdlc-*.md`:
1. Parse frontmatter `description:` and `user_invocable:` fields
2. Skip if `user_invocable: false` unless `--all` passed
3. Group by prefix (planning-*, dev-*, audit-*, validate-*, feedback-*, other)
4. Emit markdown list with one-line description per command
```

- [ ] **Step 3: Manually test the filter (dry-run via shell)**

```bash
echo "=== user-facing (default view) ==="
for f in commands/sdlc-*.md; do
  if grep -q "^user_invocable: true" "$f"; then
    desc=$(grep "^description:" "$f" | head -1 | sed 's/^description:\s*//')
    name=$(basename "$f" .md)
    echo "/$name — $desc"
  fi
done | head -10

echo ""
echo "=== count comparison ==="
echo "default view: $(grep -l '^user_invocable: true' commands/sdlc-*.md | wc -l)"
echo "--all view:   $(ls commands/sdlc-*.md | wc -l)"
```
Expected: default view significantly smaller than --all view (ratio ~1:2.4).

- [ ] **Step 4: Commit**

```bash
git add commands/sdlc-ag-help.md skills/ag-help/SKILL.md 2>/dev/null || git add commands/sdlc-ag-help.md
git commit -m "feat(help): filter /sdlc-ag-help by user_invocable flag

Default view shows only user-facing entry points.
Adds --all flag to include internal orchestration workflows.
Adds --council <name> for per-council filtering."
```

---

## Task 10: Mid-cycle pattern promotion trigger + single-entry exception

**Files:**
- Modify: `commands/sdlc-feedback-promote.md`
- Modify: `skills/feedback-promote/SKILL.md`
- Modify: `rules/feedback-rules.md` (FBP-005 exception)

- [ ] **Step 1: Update FBP-005 in feedback-rules.md**

In `rules/feedback-rules.md`, locate `### FBP-005: Single-Entry Pattern Promotion`. Replace the "Required" paragraph with:

```markdown
**Required**: A pattern requires ≥2 corroborating entries.

**Exception**: A singleton MAY promote directly if ALL of:
1. `feedback_type: gate-learning` (it arose from a gate failure, not preference)
2. The entry's reasoning identifies a **framework-level inconsistency** (rule contradicts another rule; workflow references a missing skill; schema conflicts with itself) — not a project-specific preference
3. The singleton path creates an FR proposal directly (skipping the pattern stage) — set `promoted_to: FR-<new-id>` instead of `FB-<new-id>`

This prevents the two-entry threshold from blocking framework bugs that only one cycle has uncovered.
```

- [ ] **Step 2: Update feedback-promote command doc**

In `commands/sdlc-feedback-promote.md`, add the new trigger section:

```markdown
## When to Invoke

**Cycle-end (original)**: During Validation S1 (Documentation Update) phase.

**Mid-cycle (new)**: When ≥3 active `user-correction` or `user-preference` entries cluster to the same concept within a single council's current session. The agent detects this during Session Protocol feedback load:
1. Load active entries per Trigger R1
2. Group by `tags` intersection (≥50% tag overlap)
3. If any cluster has ≥3 entries → invoke `/sdlc-feedback-promote --mid-cycle` before proceeding with work

**Framework-bug singleton (new)**: A single `gate-learning` entry whose reasoning identifies a framework-level inconsistency (per FBP-005 exception) — invoke `/sdlc-feedback-promote --singleton-exception FB-NNN`.

## Flags

- `--mid-cycle` — promote now even though cycle is still in progress
- `--singleton-exception FB-NNN` — promote a single gate-learning entry that qualifies for FBP-005 exception
- (no flag) — standard cycle-end promotion per S1
```

- [ ] **Step 3: Update feedback-promote skill logic**

In `skills/feedback-promote/SKILL.md`, add the detection step at the start:

```markdown
## Step 0: Determine promotion mode

Read invocation flags:
- If `--singleton-exception FB-NNN` → go to Step 6 (singleton framework-bug path)
- If `--mid-cycle` → go to Step 1, skip cycle-end gates, promote eligible clusters, do not mark cycle complete
- If no flag → standard cycle-end promotion; proceed to Step 1

## Step 6: Singleton framework-bug promotion

1. Read `.ultimate-sdlc/feedback/FB-NNN-*.md`
2. Verify eligibility:
   - `feedback_type: gate-learning` → required
   - Reasoning mentions "contradiction", "inconsistency", "missing skill", "broken reference", or equivalent → required
   - If either check fails: ABORT, tell user "This singleton does not qualify for FBP-005 exception. Need ≥1 corroborating entry."
3. If eligible: generate FR proposal directly in `.ultimate-sdlc/framework-revisions-proposed/FR-<next-id>-<slug>.md` citing the single FB entry
4. Mark `FB-NNN` as `status: promoted`, `promoted_to: FR-<new-id>`
5. Log to INDEX.md

## Step 1 (existing logic): Cluster active entries

[unchanged]
```

- [ ] **Step 4: Add cluster-detection logic to Session Protocol**

This touches all four council rule files. For each of `rules/council-planning.md`, `rules/council-development.md`, `rules/council-audit.md`, `rules/council-validation.md`, find the "Feedback load" step (step 6 in Session Protocol) and append:

```markdown
**Cluster check**: After loading active entries, group by tag overlap. If any cluster has ≥3 entries, invoke `/sdlc-feedback-promote --mid-cycle` before proceeding with phase work. Record promotions triggered this way in WORKING-MEMORY.md under "Mid-cycle promotions".
```

- [ ] **Step 5: Verify all four council files updated**

Run: `grep -l "Mid-cycle promotions" rules/council-*.md | wc -l`
Expected: `4`

- [ ] **Step 6: Commit**

```bash
git add rules/feedback-rules.md rules/council-*.md commands/sdlc-feedback-promote.md skills/feedback-promote/SKILL.md
git commit -m "feat(feedback): mid-cycle pattern promotion + singleton exception

Adds --mid-cycle flag: promote patterns when cluster reaches >=3 entries
within a single council, rather than waiting for Validation S1.

Adds --singleton-exception flag: promote single gate-learning entry
directly to FR proposal when it identifies framework-level inconsistency.
Codified as FBP-005 exception."
```

---

## Task 11: Rule-deletion budget in framework-retro

**Files:**
- Modify: `commands/sdlc-framework-retro.md`
- Modify: `skills/framework-retro/SKILL.md`
- Modify: `templates/framework-revision.md` (add deletion section)

- [ ] **Step 1: Update framework-revision.md template**

Open `templates/framework-revision.md`. After the existing proposal sections, add:

```markdown
## Deletion Proposals (MANDATORY — ≥1 required)

Every retro MUST propose at least one of:

### Option A: Retire a rule/criterion

- **Target**: [file path + section/rule ID]
- **Rationale**: [why this rule can be removed without harm]
- **Hit-rate evidence**: [if a gate criterion — cite times_evaluated and times_failed from gate-hit-rate.md]
- **Risk**: [what could go wrong if deleted]
- **Mitigation**: [how other rules cover the gap]

### Option B: Explicit retention justification

If no rule can be deleted, list the 3 least-used rules from the current cycle and justify why each MUST remain:

1. **Rule**: [path + ID] | **Justification**: [why still needed]
2. **Rule**: [path + ID] | **Justification**: [why still needed]
3. **Rule**: [path + ID] | **Justification**: [why still needed]

Option B is acceptable for the first 3 cycles; after that, Option A is required. Framework accretion without retirement is a red flag.
```

- [ ] **Step 2: Update framework-retro skill**

In `skills/framework-retro/SKILL.md`, add a new section after pattern-analysis step:

```markdown
## Step N: Generate Deletion Proposals

Every FR proposal set MUST include a deletion section:

1. Read `.ultimate-sdlc/gate-hit-rate.md` (if exists)
2. Identify candidate criteria:
   - `times_evaluated >= 5` AND `times_failed == 0` (per contexts/gate-hit-rate-schema.md § Retirement Candidate Criteria)
3. For each candidate, draft an Option A deletion proposal in the FR doc
4. If no candidates exist (project is too early — <5 cycles of gate history), generate Option B: the 3 rules with lowest "uses loaded" count from feedback entries this cycle, with retention justifications
5. **Hard rule**: An FR proposal set with zero deletion proposals AND zero retention justifications is INVALID — the skill refuses to complete. User must either accept a deletion candidate or write retention justifications.
```

- [ ] **Step 3: Update framework-retro command doc**

In `commands/sdlc-framework-retro.md`, add to the output description:

```markdown
## Outputs

Each retro produces one or more FR-NNN proposals in `.ultimate-sdlc/framework-revisions-proposed/`. Every proposal set includes:

- **Addition proposals**: new rules, workflows, or criteria drawn from recurring patterns
- **Modification proposals**: existing rules that should be strengthened or clarified
- **Deletion proposals (MANDATORY)**: ≥1 rule/criterion to retire OR explicit retention justification for the 3 least-used rules

Framework retros without deletion analysis are incomplete. The skill will refuse to finalize an FR set that lacks the deletion section.
```

- [ ] **Step 4: Verify templates + skill consistent**

Run:
```bash
grep -c "Deletion Proposal" templates/framework-revision.md skills/framework-retro/SKILL.md commands/sdlc-framework-retro.md
```
Expected: all three files contain the phrase at least once.

- [ ] **Step 5: Commit**

```bash
git add templates/framework-revision.md skills/framework-retro/SKILL.md commands/sdlc-framework-retro.md
git commit -m "feat(retro): require deletion proposals or retention justification

Every framework retro now must propose >=1 rule/criterion to retire,
OR justify retention of the 3 least-used rules. Counters framework
accretion over time. Hit-rate data from gate-log feeds the candidate list."
```

---

## Task 12: Structured manual QA fallback for Visual QA Protocol

**Files:**
- Modify: `rules/council-development.md` (Visual QA Protocol section)
- Modify: `commands/sdlc-dev-wave5-next.md`

- [ ] **Step 1: Update the Visual QA Protocol in council-development.md**

Locate the `## Visual QA Protocol (Wave 5 — MANDATORY)` section. Replace the existing "If no screenshot tool is available" paragraph with:

```markdown
**If no screenshot tool is available (headless dev, CI, or WSL without X server):**

The manual-QA fallback is NOT a narrative paragraph. It MUST produce structured evidence:

Write `visual-qa/AIOU-XXX/manual-qa.md` containing all three sections:

### 1. Rendered State Description

Describe the output component-by-component. For each component:
- Component name (matches design-system.md)
- Position in layout (top bar / sidebar / main / modal / etc.)
- Content rendered (text, image alt-text, data displayed)
- Visual state (default / hover / focus / error / loading / empty / disabled — whichever is applicable)

### 2. Design Token Citation

For every visible element, cite the design-system.md token used:
- Color: `--color-primary` → renders as #X
- Font: `--font-heading` → renders as [family]
- Spacing: `--spacing-md` → renders as [px]

Any ad-hoc color/font/spacing without a token reference is a Visual QA defect.

### 3. 30-Second Slop Test

Check against the 5 ANTI-SLOP patterns:
- [ ] No generic font (Inter/Roboto/Open Sans/system-ui without override)
- [ ] No purple/indigo accent as primary
- [ ] No three-box trinity (3 equal icon cards in symmetrical grid)
- [ ] No uniform radius+shadow on everything
- [ ] No flat white/gray background with no atmosphere

Three or more unchecked = Visual QA FAIL. Return to implementation.

---

**Evidence Required at Gate I8 (unchanged policy, tightened acceptance criteria)**: `visual-qa/` directory must contain at least one screenshot OR a complete 3-section `manual-qa.md` per Wave 5 AIOU. Prose-only QA notes do NOT satisfy the criterion.
```

- [ ] **Step 2: Update dev-wave5-next workflow**

In `commands/sdlc-dev-wave5-next.md`, locate the Visual QA step and add:

```markdown
**If manual QA path (no screenshot tool)**: Write `visual-qa/<AIOU-ID>/manual-qa.md` using the three-section structure from council-development.md § Visual QA Protocol. Do NOT substitute prose — the structured format is mandatory.
```

- [ ] **Step 3: Verify update**

Run: `grep -c "3-section\|three-section\|Rendered State Description" rules/council-development.md commands/sdlc-dev-wave5-next.md`
Expected: both files reference the structured format.

- [ ] **Step 4: Commit**

```bash
git add rules/council-development.md commands/sdlc-dev-wave5-next.md
git commit -m "feat(visual-qa): require structured manual-QA fallback

When no screenshot tool is available, manual QA must produce a
three-section manual-qa.md (rendered state / token citation / slop test).
Prose-only QA notes no longer satisfy Gate I8 visual evidence criterion."
```

---

## Task 13: Cross-reference validation + final consistency check

**Files:**
- Validation-only (no writes): grep/lint across entire framework repo
- Modify: `README.md` if any user-facing command names changed

- [ ] **Step 1: Verify no broken file references**

Run:
```bash
# Find all references to rule files that should now exist
grep -rn "integrity-enforcement\.md\|anti-slop-code-reference\.md\|gate-hit-rate-schema\.md\|gate-hit-rate-tracker\.md" rules/ commands/ skills/ agents/ contexts/ templates/ | grep -v ".git"

# Verify each referenced file actually exists
for f in rules/integrity-enforcement.md rules/anti-slop-code-reference.md contexts/gate-hit-rate-schema.md templates/gate-hit-rate-tracker.md commands/sdlc-gate-log.md skills/gate-log/SKILL.md; do
  [[ -f "$f" ]] && echo "EXISTS: $f" || echo "MISSING: $f"
done
```
Expected: every created file reported as EXISTS.

- [ ] **Step 2: Verify context reduction targets met**

Run:
```bash
echo "=== Always-on P0 line counts ==="
wc -l rules/universal-rules.md rules/integrity-rules.md rules/anti-slop-code.md
echo ""
echo "=== Conditional-P0 line counts ==="
wc -l rules/feedback-rules.md rules/integrity-enforcement.md rules/anti-slop-code-reference.md rules/anti-slop-visual.md
echo ""
echo "=== Baseline was 1040 across original 5 files ==="
echo "Target: always-on P0 <= 700"
```

Expected: `rules/universal-rules.md + rules/integrity-rules.md + rules/anti-slop-code.md ≤ 700` combined.

- [ ] **Step 3: Verify no dangling references**

```bash
grep -rn "UNIVERSAL-RULES\|INTEGRITY-RULES\|feedback-rules\|anti-slop" rules/ commands/ agents/ skills/ | grep -v "\.md:" | head -20
# Check for references like "UNIVERSAL-RULES.md § 0.21" that might now point to moved content
grep -rn "§ 0\." rules/ commands/ | grep -v "universal-rules.md"
```
Expected: any section pointer resolves to a section that still exists.

- [ ] **Step 4: Verify gate workflows all wired**

```bash
echo "Gates with gate-log wiring: $(grep -l 'sdlc-gate-log' commands/sdlc-*gate*.md | wc -l) / 13"
echo "Gates with integrity-enforcement load: $(grep -l 'integrity-enforcement' commands/sdlc-*gate*.md | wc -l) / 13"
```
Expected: both report `13 / 13`.

- [ ] **Step 5: Verify workflow classification complete**

```bash
echo "Workflows with user_invocable: $(grep -l '^user_invocable:' commands/sdlc-*.md | wc -l) / $(ls commands/sdlc-*.md | wc -l)"
```
Expected: `171 / 171`.

- [ ] **Step 6: Verify feedback system additions**

```bash
grep -q "mid-cycle" commands/sdlc-feedback-promote.md && echo "mid-cycle trigger: PRESENT" || echo "mid-cycle trigger: MISSING"
grep -q "singleton-exception" commands/sdlc-feedback-promote.md && echo "singleton exception: PRESENT" || echo "singleton exception: MISSING"
grep -q "Deletion Proposal" templates/framework-revision.md && echo "deletion budget: PRESENT" || echo "deletion budget: MISSING"
grep -q "three-section\|Rendered State Description" rules/council-development.md && echo "structured manual QA: PRESENT" || echo "structured manual QA: MISSING"
```
Expected: all four report `PRESENT`.

- [ ] **Step 7: Update README.md if needed**

If the README's command list references any workflow classified as `user_invocable: false`, update the README to either remove that reference or mark it as internal. Run:

```bash
grep -oP '`/sdlc-[a-z0-9-]+`' README.md | sort -u > /tmp/readme-commands.txt
while read -r cmd; do
  clean=$(echo "$cmd" | tr -d '`')
  file="commands${clean}.md"
  if [[ -f "$file" ]]; then
    flag=$(grep "^user_invocable:" "$file" | awk '{print $2}')
    echo "$clean → $flag"
  fi
done < /tmp/readme-commands.txt
```

Any command showing `false` should be reviewed in README — either remove or annotate as "internal, called by orchestrator."

- [ ] **Step 8: Final commit**

```bash
git add README.md 2>/dev/null
git diff --cached --quiet || git commit -m "docs(readme): align command examples with user_invocable classification"

# If no README changes needed, skip the commit
echo "Plan implementation complete."
```

---

## Self-Review

**Spec coverage:**

| Recommendation | Task | Coverage |
|---------------|------|----------|
| 1. Rule-deletion budget | Task 11 | ✓ Covered |
| 2. Gate hit-rate tracking | Tasks 6, 7 | ✓ Covered |
| 3. User-facing vs internal workflow split | Tasks 8, 9 | ✓ Covered |
| 4. Mid-cycle pattern promotion | Task 10 | ✓ Covered |
| 5. Single-entry promotion exception | Task 10 | ✓ Covered |
| 6. Structured manual QA fallback | Task 12 | ✓ Covered |
| A. feedback-rules → conditional-P0 | Task 5 | ✓ Covered |
| B. Split INTEGRITY awareness/enforcement | Task 3 | ✓ Covered |
| C. Compress anti-slop-code + reference | Task 4 | ✓ Covered |
| D. Table-ize UNIVERSAL-RULES sections | Task 1 | ✓ Covered |
| E. Prune rule duplication | Task 2 | ✓ Covered |

All 11 recommendations have implementing tasks.

**Placeholder scan:** No TBDs, no "similar to Task N" without repeating code, no "implement later" markers. Every script block is executable as written; every grep has expected output.

**Type consistency:**
- `user_invocable` field name used consistently across Tasks 8, 9, 13
- `gate_id` / `council` / `result` / `failed_criteria` field names consistent across Tasks 6, 7
- `/sdlc-gate-log` command name consistent across Tasks 6, 7
- `/sdlc-feedback-promote --mid-cycle` and `--singleton-exception` flag names consistent across Task 10
- File paths consistent with `ls` inventory confirmed at plan start

**Ordering check:**
- Tasks 1-5 (context reduction) land before Tasks 6-7 (measurement) so measurement is added to cleaner files.
- Tasks 6-7 (gate-log infrastructure) land before Task 11 (rule-deletion budget) because retros need hit-rate data.
- Tasks 8-9 (user_invocable flag + ag-help filter) are independent; grouped together for cohesion.
- Tasks 10-12 (feature additions) land last because they build on measurement + classification from earlier tasks.
- Task 13 (cross-ref validation) is final gate.

**Risks acknowledged:**
- Task 3 (INTEGRITY split) relies on gate workflows Reading `integrity-enforcement.md` at Step 0. If a gate workflow is added later that forgets this, enforcement degrades silently. Mitigation: Task 13 Step 4 verifies all 13 gates wired; future gate additions should follow the established pattern.
- Task 8 (classification script) relies on the USER_INVOCABLE list being correct. Misclassification produces the wrong filter in `/sdlc-ag-help`. Mitigation: Task 8 Step 5 spot-checks 5 known cases; user reviews full list before committing.
- Task 4 (anti-slop compression) relies on Wave 3/4/5 workflows loading the reference file. If an AIOU touches a banned pattern domain outside those waves, slop can leak. Mitigation: this is acceptable — anti-slop-code.md (summary form) stays always-on, catching the common cases.

---

## Execution Handoff

Plan complete and saved to `docs/plans/2026-04-23-framework-improvements.md`. Two execution options:

**1. Subagent-Driven (recommended)** — I dispatch a fresh subagent per task, review between tasks, fast iteration. Best for this plan because tasks are independent and each produces a clean commit.

**2. Inline Execution** — Execute tasks in this session using executing-plans, batch execution with checkpoints. Best if you want to shape each commit's message or adjust rules as you go.

Which approach?
