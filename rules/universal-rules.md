---
trigger: always_on
---

# UNIVERSAL-RULES.md - Unified Framework

## TIER 0: UNIVERSAL RULES

Always active regardless of council or context.

**P0 Rule Files (Always Loaded)**: `UNIVERSAL-RULES.md`, `INTEGRITY-RULES.md`

### 0.1 Clean Code Mandate
- Concise, direct, solution-focused code
- Self-documenting over commented
- No over-engineering; every agent documents own changes

### 0.2 Security-First Principle
- Security verification is cumulative per gate — see § Security Tracking for per-gate criteria
- Input validation on every implementation
- No hardcoded secrets; OWASP Top 10 mandatory
- Parameterized queries only

### 0.3 Evidence-Based Completion
- NEVER claim completion without artifact proof
- "I believe", "should be", "probably" = NOT verified
- Evidence must be EXTERNAL and REVIEWABLE
- Runtime verification over code review

### 0.4 Artifact-as-Proof Protocol

| Claim | Required Proof |
|-------|----------------|
| Feature complete | Passing tests + runtime verification |
| Bug fixed | Before/after screenshots + test |
| Gate passed | Completed checklist + sign-offs |
| Secure | Security checklist + scan results |

### 0.5 Zero-Compromise Principle

| Prohibited | Example | Required Alternative |
|-----------|---------|---------------------|
| Vague deferral | "We'll figure this out during development" | `DEFERRED:[reason]:[owner]:[target-phase]` |
| Placeholder scope | "TBD", "Approximately X features" | Exact count, reference scope-lock.md |
| Approximate counts | "~15 features", "about 100 AIOUs" | Exact integer from scope-lock.md |
| Symptom-fixing | Fix without root cause analysis | Root cause documented, symptom fix rejected |

**DEFERRED format**: `DEFERRED:[reason]:[owner]:[target-phase]`. All three fields required. Track in `.ultimate-sdlc/specs/deferred-decisions.md`. Gate fails if DEFERRED items targeting current phase remain OPEN.

### 0.6 Request Classification

| Type | Keywords | Action |
|------|----------|--------|
| QUESTION | "what is", "explain" | Text response |
| SIMPLE CODE | Single file fix | Inline edit |
| COMPLEX | Multi-file, design | Plan required |
| COUNCIL CMD | /planning-*, etc. | Workflow dispatch |

### 0.7 Socratic Gate

For COMPLEX requests, verify before implementing: (1) Expected behavior? (2) Edge cases? (3) Constraints?

**Rule**: If 1% is unclear → ASK. Never assume.

### 0.8 Skill Loading Protocol

**Maximum 7 skills per workflow.** Knowledge skills are loaded via the Read tool from `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/`. If absent, use defaults:

| Prefix | Default Skills |
|--------|----------------|
| planning- | rarv-cycle, requirements-engineering, brainstorming, documentation-standards |
| dev- | rarv-cycle, clean-code, typescript-expert, test-patterns |
| audit- | rarv-cycle, functional-testing, systematic-evaluation, gap-analysis |
| validate- | rarv-cycle, intent-extraction, verification-testing, targeted-correction |
| (other) | rarv-cycle, clean-code, documentation-standards, +1 reserved |

**Rules**: Workflow skill references = LOAD; Agent skill references = IGNORE; If 8+ listed, load first 7.

### 0.9 State Persistence

**Persistent (all cycles)**: `.ultimate-sdlc/project-manifest.md` — Project identity, cycle history, feature inventory
**Authoritative (per-cycle)**: `.ultimate-sdlc/project-context.md`, `.ultimate-sdlc/council-state/*/current-state.md`, `.ultimate-sdlc/specs/scope-lock.md`
**Planning Batch State**: `.ultimate-sdlc/council-state/planning/planning-tracker.md`
**Session**: `.ultimate-sdlc/council-state/*/WORKING-MEMORY.md`
**Historical**: `.ultimate-sdlc/progress.md` (append-only, per-cycle)

**Cycle State Resolution**: If `.ultimate-sdlc/project-context.md` exists → active cycle. If only `.ultimate-sdlc/project-manifest.md` → between cycles, run `/new-cycle`. If neither → run `/init` or `/adopt`.

**File Loading — On-Demand Model**:

| Priority | Files | Load When |
|----------|-------|-----------|
| P0 | UNIVERSAL-RULES.md, INTEGRITY-RULES.md, council-{current}.md, workflow | Session start (once) |
| P1 | project-context.md, project-manifest.md, WORKING-MEMORY.md, run-tracker.md, required skills | On first reference |
| P2 | progress.md, additional skills, .memory/* | If needed |

**On-demand principle**: P0 governance files are internalized once per session — do not re-read them if already loaded. P1/P2 files load when first referenced, not preemptively. This maximizes context available for project content.

**Budget >80%**: P0 only. **>95%**: End session after current task.

**Security floor**: Even at >80% budget, the AIOU security checklist (10 items from council-development.md § Security Requirements) remains active. Security is never dropped.

### 0.10 Focus Lens Protocol

Apply analytical lenses for the current task (awareness, not hard blocking):

| Lens | Always Active | Context-Specific |
|------|--------------|-----------------|
| `[Security]` | Every AIOU, every gate | — |
| `[Quality]` | Every AIOU (code review) | Audit, Validation |
| `[Architecture]` | — | Planning, wave setup |
| `[UX]` | — | When `project_type` has frontend |
| `[Performance]` | — | Audit T5, Validation P-track |
| `[Operations]` | — | Validation P-track, deploy |
| `[Requirements]` | — | Planning Phases 1-1.5 |
| `[Documentation]` | — | Handoffs, releases |

**Multiple lenses can be active simultaneously.** When writing code, `[Security]` + `[Quality]` are always active.

### 0.11 Conflict Resolution

**Priority**: P0 > P1 > P2 > P3. P0 = UNIVERSAL/INTEGRITY; P1 = council; P2 = agent; P3 = skill.

| Conflict Type | Winner | Rule |
|--------------|--------|------|
| P0 vs P1 | P0 | P1 may NARROW, not contradict |
| P0 vs P2/P3 | P0 | Unless agent has explicit `## Override` with rationale (P2 only) |
| P1 vs P2 | P2 | Agent-specific behavior wins |
| Ambiguous | Safer | Priority: data safety > security > conservative scope > more verification |

**Specific Cases**:
- **Socratic Gate override**: Workflow frontmatter `socratic_gate: skip` → skip. Explicit "Prerequisites" section → questions already answered. Otherwise → apply gate.
- **Sequential vs Parallel**: One feature at a time within a single session. Parallel subagents (Task tool) can work on different features simultaneously.
- **Evidence Fallback Chain**: Playwright MCP → Request user → After 2 unanswered prompts, proceed without. NEVER mark as "verified" without actual evidence.
- **Zero-Compromise vs Deferral**: "TBD" prohibited → use `DEFERRED:[reason]:[owner]:[target-phase]` tracked in `.ultimate-sdlc/specs/deferred-decisions.md`.
- **Workflow overrides**: Frontmatter `overrides:` section can set `socratic_gate: skip`, `evidence_required: user-provided`, `parallel_allowed: true` for that workflow only.

Document conflicts in `.memory/semantic/conflict-resolutions.md`. Never proceed with unresolved conflict.

### 0.12 RARV Cycle Modes

**Full RARV**: Multi-step, multiple files, complex changes
**RARV Lite**: Single-file, ≤20 lines, no logic changes, isolated, verifiable by diff alone

**Default**: Full RARV. Use Lite only when ALL of: 1 file, ≤20 lines, no logic changes, isolated, diff-verifiable.

### 0.13 Run Tracker Awareness

**Reference**: `INTEGRITY-RULES.md` for prohibitions (PRH-001 to PRH-009).

**Locations**: `.ultimate-sdlc/council-state/{planning,development}/run-tracker.md`

**Session Start**: project-context.md → run-tracker.md → WORKING-MEMORY.md → work ONLY on assigned items.

**Completion Claims**: Verify against run-tracker.md; all items checked; no items skipped without DEFERRED.

### 0.14 Batch & Multi-Run Mode Triggers

| Council | Threshold | Mode | Tracking Artifact |
|---------|-----------|------|-------------------|
| Planning | ≥8 features in scope-lock.md | Batch mode (Phases 2.5 + 3 + 3.5) | planning-tracker.md |
| Development | ≥15 AIOUs OR ≥25 estimated hours | Multi-run mode | run-tracker.md |

**Planning Batch Mode**: When feature count ≥8, Phases 2.5, 3, and 3.5 execute in batches of 3-5 features grouped by module/domain. Complete a batch → STOP → notify user → user runs `/continue` (or the next applicable workflow) → next batch. See `council-planning.md § Planning Batch Mode` for full protocol.

**Development Multi-Run Mode**: Size estimates: XS=1h, S=2h, M=4h, L=8h, XL=16h. If threshold exceeded, scope analysis is MANDATORY → creates run-tracker.md. Maximum 15 AIOUs per run, maximum 45 effort units per run.

### 0.15 Context Budget Management

**You cannot precisely count your own tokens.** Use hard limits by session type:

| Session Type | Max Content Files | Action at Limit |
|-------------|------------------|-----------------|
| Planning phase | 12 | Complete current item, END SESSION |
| Development wave | 10 | Complete current AIOU, END SESSION |
| Audit track | 8 | Complete current analysis, END SESSION |
| Gate verification | 6 | Complete gate, END SESSION |

**"Content file"** = source code, spec, skill, or project documentation >50 lines. **Governance files** (UNIVERSAL-RULES.md, INTEGRITY-RULES.md, council rules, workflow) count as **1 unit collectively** — fixed overhead, not variable load.

**Estimation**: ~500 tokens per 100 lines of markdown, ~400 tokens per 100 lines of code. Framework overhead ≈ 4,000 tokens fixed.

**Session-end triggers** (ANY ONE triggers end):
1. Content file count exceeds session type limit
2. Conversation exceeds ~30 substantive turns
3. You notice repeating yourself or losing track of earlier decisions
4. Gate verification fails 3+ times on same criterion (see Gate Failure Protocol in `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/gate-criteria.md`)

**Fast context rebuild**: Read `project-intelligence.md` first when resuming — key decisions in ~20 lines, 80% of context at 10% the cost.

Track in WORKING-MEMORY.md as a simple list of content files loaded + status (GREEN/YELLOW/RED).

### 0.16 Evidence Integrity

When claiming test/security/performance results, include actual command output as evidence. AI-generated assertions ("all tests pass") are NOT valid without command output. Reference: PRH-005.

| Claim Type | Required Evidence |
|-----------|-------------------|
| Tests pass | Terminal output showing test results |
| Security scan clean | Scan tool output (Semgrep, ZAP, npm audit, etc.) |
| Performance meets target | Lighthouse/k6/profiler output with actual metrics |
| Screenshot captured | File path to saved screenshot or artifact ID |

### 0.17 Browser Interaction Guard

When using Playwright MCP for screenshot capture:
1. **Screenshot loop prevention**: Max 3 attempts per static page. If unchanged between attempts, stop.
2. **Visual comparison limitations**: AI vision is judgment-based, not pixel-exact. For pixel precision, recommend dedicated visual regression tools (Percy, Applitools, pixelmatch).
3. **Session recording scope**: For long sessions, capture targeted recordings per feature, not one continuous session.

## TIER 1: COUNCIL ACTIVATION

Load council rules at workflow start based on prefix: `planning-*`, `dev-*`, `audit-*`, `validate-*`

**Loading Order**: UNIVERSAL-RULES.md → INTEGRITY-RULES.md → council-{current}.md → workflow → skills

## TIER 2: QUALITY GATES

Gates BLOCK progression. Failed gate = STOP.

### Security Tracking (Cumulative)

Security verification is **cumulative**, not repeated. Each gate checks only the criteria **new to that phase**:

| Gate Phase | Security Criteria |
|------------|-------------------|
| Planning gates (1.5, 3.5, 8) | Security requirements documented, threat model referenced |
| Development gates (I4, I8) | No hardcoded secrets, input validation implemented, parameterized queries, auth implemented |
| Audit gates (T3, A2, A3) | Security scan clean, vulnerability count = 0, no information leakage |
| Validation gates (V5, C4, P4, E4, S2) | OWASP Top 10 verified, penetration test (Enterprise mode), security hardening complete |

Track cumulative status in `security-status.md`. Each gate verifies its criteria and marks them in the tracking file. Previous criteria are inherited — no re-verification.

**Evidence Required**:

| Check | Evidence |
|-------|----------|
| No secrets | Grep source for: password, api_key, secret, token, credential (0 matches excluding tests/.env.example) |
| Auth | Auth flow in specs/ OR login test passes |
| Authz | Role matrix OR RBAC tests pass |
| Input validation | Schemas present OR tests pass |
| Output encoding | XSS tests pass OR library documented |
| OWASP | Security review covers all 10 categories |

### 0.18 Model Selection Guidance

Model selection directives in workflows and council rules are **informational**. The executing model follows all workflow instructions regardless of which model is specified. If the specified model differs from the executing model, note this in WORKING-MEMORY.md but proceed normally. Model assignments are advisory metadata for orchestration layers — they do not affect workflow execution logic.

### 0.19 Platform-Specific Guardrails

#### Claude Code

Standard framework rules apply without modification. Claude's instruction adherence is reliable; no additional pinning needed. Plan session ends at ~120K tokens for claude-sonnet-4-6, ~600K for claude-opus-4-6.

### 0.20 Autonomous Decision Protocol

When facing a choice not covered by specs, ADRs, or existing patterns:

| Step | Action |
|------|--------|
| 1 | Search codebase for existing patterns; if found, follow |
| 2 | Evaluate options: security (safest) > simplicity (simpler) > consistency (matches existing) > reversibility (more reversible) |
| 3 | Record decision + rationale in WORKING-MEMORY.md |
| 4 | If decision affects >3 files OR >1 feature: create ADR |
| 5 | When equally valid: choose most common industry convention for stack |

### 0.21 Feedback-Driven Learning

The framework captures **user corrections with reasoning** as feedback entries that persist across sessions and cycles. Feedback describes HOW the team wants work done; specs describe WHAT the system does — they are orthogonal (FR-1).

**P0 Rule File (Always Loaded, added in this version)**: `feedback-rules.md` — alongside UNIVERSAL-RULES and INTEGRITY-RULES.

**Storage**: `.ultimate-sdlc/feedback/` (per-project, carried forward across cycles via `pattern` entries).

**Four feedback types**: `user-correction` | `user-preference` | `gate-learning` | `pattern`.

**Write triggers** — agent creates a feedback entry when:
1. User corrects the agent AND explains why → `/sdlc-feedback-log`.
2. User states a preference unprompted → `/sdlc-feedback-log --type user-preference`.
3. A gate fails because of a rule/process gap → `/sdlc-feedback-log --type gate-learning`.
4. Validation S1 synthesizes recurring entries → `/sdlc-feedback-promote`.

**Read triggers** — agent loads feedback at:
1. Every council's Session Protocol → `/sdlc-feedback-review`.
2. Before any AIOU implementation (Planning 2.5/3/3.5, all Development waves) → `/sdlc-feedback-review --aiou <AIOU-ID>`.
3. Before every gate verification → `/sdlc-feedback-review --gate <gate-id>`.
4. On `/sdlc-new-cycle` bootstrap → load carried-forward `pattern` entries.

**Anti-weaponization** (FR-2): Feedback NEVER justifies a PRH-001..PRH-009 violation. Rejections logged to `.ultimate-sdlc/feedback/REJECTED.md`.

**Framework meta-improvement** (FR-3): `/sdlc-framework-retro` at cycle close drafts proposed edits to framework files as `FR-NNN` in `.ultimate-sdlc/framework-revisions-proposed/`. **Propose-only** — agents never write to the framework repo directory. User reviews and applies manually.

**Cross-project learning** (FR-4): NOT automatic. Feedback stays per-project.

Full protocol: see `feedback-rules.md`. Schema: see `contexts/feedback-schema.md`. Templates: `feedback-entry.md`, `feedback-index.md`, `framework-revision.md`.
