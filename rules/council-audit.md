# Audit Council Rules

Load when: `/council audit` or `/audit-*` commands

## Track Structure

**IMPORTANT:** Tracks execute **sequentially**, not in parallel:
1. **Testing Track (T1→T2→T3→T4→T5)** - Must complete first
2. **Audit Track (A1→A2→A3)** - Starts after T5 complete

> **Enhancement Track was removed from Audit Council.** Enhancement activities (E1-E4) now reside exclusively in the Validation Council. This avoids overlap and ensures enhancements happen after full audit is complete.

Within each track, phases are sequential with mandatory prerequisites.

### Testing Track (T1-T5)
| Phase | Name | Output | Notes |
|-------|------|--------|-------|
| T1 | Inventory | Feature inventory, screen map | Embedded in `/audit-start` |
| T2 | Functional | Test results per feature | |
| T3 | GUI Analysis | Navigation map, UX audit | **Skip if `project_type` has no frontend** |
| T4 | Integration | Cross-feature tests | |
| T5 | Performance & Security | Metrics, scan results | |

### Audit Track (A1-A3)
| Phase | Name | Output |
|-------|------|--------|
| A1 | Purpose Alignment | Alignment matrix |
| A2 | Completeness | Gap analysis |
| A3 | Quality Assessment | Quality scorecard |

## Quality Gates

Gate criteria are defined in `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/gate-criteria.md` (single source of truth).
Mode-specific activation: see `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/governance-modes.md § Per-Council Phase Activation`.

- **Gate T3**: GUI Analysis → see `gate-criteria.md § Gate T3` — **skip if `project_type` has no frontend**
- **Gate A2**: Completeness → see `gate-criteria.md § Gate A2`
- **Gate A3**: Quality Assessment → see `gate-criteria.md § Gate A3`

## Session Protocol

Standard session start/resume sequence for all Audit Council workflows:

1. Read `.ultimate-sdlc/config.yaml` → extract `governance_mode`, `project_type`
2. Read `.ultimate-sdlc/project-context.md` → confirm Active Council = Audit, get current track/phase
3. Read `.ultimate-sdlc/handoffs/development-handoff.md` → load implementation summary
4. Read `.ultimate-sdlc/council-state/audit/WORKING-MEMORY.md` → check for incomplete tasks
5. **Feedback load** (per `rules/feedback-rules.md § Trigger R1` — Read feedback-rules.md first, then): Invoke `/sdlc-feedback-review` → load active feedback entries for `council: audit` or `council: any`. Apply their "How to apply" during this session. Record loaded IDs in WORKING-MEMORY.md under "Feedback loaded this session".
   **Cluster check**: After loading active entries, group by tag overlap. If any cluster has ≥3 entries, invoke `/sdlc-feedback-promote --mid-cycle` before proceeding with phase work. Record promotions triggered this way in WORKING-MEMORY.md under "Mid-cycle promotions".
6. **If resuming**: Display resume summary, continue from last position
7. **If new session**: Display welcome with track overview
8. Check governance_mode → apply mode-specific behavior (combine phases in Lightweight, skip T3 if no frontend)
9. Check `project_type` → skip T3 for non-frontend types (cli-tool, library, api-service, ml-pipeline)

## Pre-Gate Feedback Check

Before verifying ANY gate (T3, A2, A3), the agent MUST:

1. Invoke `/sdlc-feedback-review --gate <gate-id>` → loads active `gate-learning` entries for this specific gate.
2. For each loaded entry, verify the preventive rule named in "How to apply" has been applied during the work leading up to this gate.
3. Record each check in the gate report under a new section `### Feedback-derived checks`:
   - FB-NNN → preventive rule → verified / not verified / N/A
4. If any preventive rule was NOT applied: gate FAILS until the agent addresses it. This is an automatic fail criterion added by each gate-learning entry.

This ensures past gate failures (captured as `gate-learning` feedback) actively prevent the same failure recurring.

## Display Template

```markdown
## Audit Council - [Track]: [Phase Name]

**Mode**: [governance_mode] | **Type**: [project_type]
**Track**: [Testing|Audit] | **Phase**: [T/A N]
**Defects Found**: [count] (P0: [n], P1: [n], P2: [n], P3: [n])

[Phase-specific content follows]
```

## Focus Lenses

| Lens | Applied During |
|------|---------------|
| `[Quality]` | T1-T2, T4, A1-A3 |
| `[UX]` | T3 (if frontend) |
| `[Security]` | T5, A3 |
| `[Performance]` | T5 |

## Defect Logging Protocol

1. Observe potential issue → 2. REPRODUCE (MANDATORY) → 3. Capture evidence (screenshot for UI, output diff for CLI/API) → 4. Log with /audit-defect → 5. Verify logged

**NO DEFECT WITHOUT REPRODUCTION + EVIDENCE**

> Evidence format is determined by `project_type`: screenshots for web-app/mobile-app, terminal output for cli-tool, request/response diffs for api-service. See `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/project-presets.md`.

## Defect Severity

| Severity | Definition | Action |
|----------|-----------|--------|
| P0 - Critical | System unusable | Block release |
| P1 - High | Major feature broken | Fix before release |
| P2 - Medium | Degraded, workaround | Next sprint |
| P3 - Low | Minor, cosmetic | Backlog |

## Security Finding Severity

| Severity | Definition | Examples | Action |
|----------|-----------|---------|--------|
| SEC-CRITICAL | Exploitable vulnerability allowing unauthorized access, data breach, or RCE | SQL injection with no parameterization, hardcoded admin credentials, RCE via command injection | **BLOCK** — must fix before A1. Log as P0 defect. |
| SEC-HIGH | Exploitable vulnerability with significant impact but requiring specific conditions | XSS in user-facing pages, IDOR on sensitive resources, missing auth on admin endpoints, weak crypto (MD5 passwords) | **BLOCK** — must fix before Gate A3. Log as P1 defect. |
| SEC-MEDIUM | Security weakness that increases attack surface but is not directly exploitable | Missing rate limiting, verbose error messages, missing security headers, session timeout too long | **LOG** — document in defect-log.md. Fix in Validation P4 or next cycle. |
| SEC-LOW | Security best practice not followed, minimal risk | Missing HSTS header on internal-only app, informational findings from scanners | **LOG** — document as P3. Address if time permits. |

**Enforcement**: SEC-CRITICAL findings immediately trigger remediation before the audit continues. SEC-HIGH findings must be resolved before Gate A3. SEC-MEDIUM and SEC-LOW are carried forward to Validation.

## Test Depth Protocol (Testing Track T2 — Functional Testing)

Functional testing MUST go beyond happy-path verification. For EVERY feature tested:

### Three-Level Test Depth (MANDATORY)

| Level | What to Test | Minimum Tests | Example |
|-------|-------------|---------------|---------|
| **Happy Path** | Primary success scenario with valid input | >=1 per feature | User creates project → project appears in list |
| **Error/Validation** | Invalid input, missing required fields, unauthorized access, conflict states | >=1 per feature | User submits empty form → field-level errors displayed. User accesses other user's project → 403. |
| **Edge Case** | Boundary values, empty data sets, maximum limits, concurrent operations, special characters | >=1 per feature | User creates project with 255-char name → succeeds. User creates project #101 when limit is 100 → appropriate error. |

**A feature tested only at the happy-path level is NOT "100% covered" for Gate A2.** All three levels must be exercised.

### What to Verify at Each Level

**Happy Path**: Does the feature produce the correct result with normal input? Does the UI show the expected state? Does the data persist correctly?

**Error/Validation Path**: Does invalid input produce a clear error message (not a crash or blank screen)? Does the error message tell the user what to fix? Does the system remain in a valid state after the error? Can the user recover and retry?

**Edge Case**: What happens with empty lists, zero quantities, very long strings, special characters (unicode, emoji, HTML tags), dates at boundaries (midnight, DST transitions, year-end), concurrent edits by multiple users, rapid repeated actions (double-click, rapid submit)?

### Security-Specific Test Requirements

For every threat in `.ultimate-sdlc/specs/security/threat-model.md`:
- Identify the specific attack vector (SQL injection, XSS, IDOR, etc.)
- Attempt the attack against the implemented mitigation
- Verify the attack is blocked (request rejected, input sanitized, access denied)
- Record evidence: the attack input used, the response received, PASS/FAIL

**Mitigations without attack tests are unverified.** Gate A2 criterion 7 requires every threat to have a negative test case.

## Multi-Thinking Modes

Switch with `/audit-think [mode]`:

| Mode | Lens | Best For |
|------|------|----------|
| intuitive | `[UX]` | UX evaluation |
| critical | `[Quality]` | Defect analysis |
| creative | `[Quality]` | Edge cases |
| systematic | `[Quality]` | Coverage scoring |

## Model Selection

- Testing (T1-T5): claude-sonnet-4-6
- Assessment (A1-A3): claude-opus-4-6

## Quality Scorecard Format

| Dimension | Score (1-5) |
|-----------|-------------|
| Functionality | |
| Reliability | |
| Usability | |
| Performance | |
| Security | |
| Maintainability | |

## Handoff Outputs

- audit-handoff.md - Quality assessment
- defect-log.md - All defects with evidence

Validate against `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/handoff-schemas/audit-handoff.schema.md`.

## Recovery

If recovering mid-track, verify last completed phase via WORKING-MEMORY.md and resume from that point. Track boundaries are natural recovery points. See `/recover` for full protocol.
