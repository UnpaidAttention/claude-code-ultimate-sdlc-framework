# Quality Gate Criteria - Binary Checklist

All gate criteria are binary (PASS/FAIL) and testable.

---

## Standard Terms

| Term | PASS if |
|------|---------|
| **Verified** | Artifact exists AND reviewed AND matches expected outcome |
| **Documented** | File exists AND has required sections AND non-empty |
| **Complete** | 100% items checked AND no TBD/placeholder content |
| **Tested** | Tests executed AND results recorded AND pass rate meets threshold |

When in doubt, apply the most stringent interpretation.

---

## Governance Mode Activation

Not all gates are active in every mode. Read `.ultimate-sdlc/config.yaml → governance_mode` to determine which gates apply:

| Gate | Lightweight | Standard | Enterprise |
|------|------------|----------|------------|
| 1.5 | ❌ Skip | ✅ | ✅ |
| 3.5 | ❌ Skip | ✅ | ✅ |
| 8 | ✅ Simplified | ✅ | ✅ |
| I4 | ❌ Skip | ✅ | ✅ |
| I8 | ✅ | ✅ | ✅ |
| T3 | ❌ Skip | ✅ if frontend | ✅ |
| A2 | ✅ | ✅ | ✅ |
| A3 | ✅ Simplified | ✅ | ✅ |
| V5 | ❌ Skip | ✅ | ✅ |
| C4 | ✅ | ✅ | ✅ |
| P4 | ❌ Skip | ✅ | ✅ |
| E4 | ❌ Skip | ❌ | ✅ |
| S2 | ✅ | ✅ | ✅ |

**Simplified** gates use the same criteria but fewer items (skip informational criteria, keep quality-floor criteria).

> **Playbook document gate criteria**: Criteria checking for BRD, PRD cross-cutting, API spec, Database Design, Runbook, Tech Docs, and Consistency Audits are automatically N/A in Lightweight mode. See `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/governance-modes.md § Playbook Document Requirements` for the full matrix.

See `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/governance-modes.md` for full mode definitions.

---

## Technology Adaptation

Commands below use `npm` as default. Adapt to your stack:

| Action | npm | Python | Rust | Go |
|--------|-----|--------|------|----|
| Build | `npm run build` | `python -m build` | `cargo build` | `go build ./...` |
| Test | `npm test` | `pytest` | `cargo test` | `go test ./...` |
| Lint | `npm run lint` | `ruff check .` | `cargo clippy` | `golangci-lint run` |
| Coverage | `npm test -- --coverage` | `pytest --cov` | `cargo tarpaulin` | `go test -cover` |
| Security | `npm audit` | `pip-audit` | `cargo audit` | `govulncheck ./...` |

CRITERIA are universal. COMMANDS are stack-specific.

## Security Scan Commands

Adapt to your stack. At minimum, run at the indicated gates:

| Gate | Scan | npm | Python | Rust | Go |
|------|------|-----|--------|------|----|
| I4, I8 | Dependency audit | `npm audit --audit-level=high` | `pip-audit` | `cargo audit` | `govulncheck ./...` |
| I4, I8, P4 | Secrets scan | `gitleaks detect --no-git` | `gitleaks detect --no-git` | `gitleaks detect --no-git` | `gitleaks detect --no-git` |
| I8, T5 | SAST | `semgrep --config=auto . --error` | `semgrep --config=auto . --error` | `semgrep --config=auto . --error` | `semgrep --config=auto . --error` |
| P4 | OWASP (web) | `zap-cli quick-scan [url]` | `zap-cli quick-scan [url]` | N/A | N/A |

**PASS criteria**: All scans exit 0 with 0 high/critical findings. MCP servers (Semgrep MCP, ZAP MCP) enhance this if available; fall back to CLI tools.

---

## Planning Council Gates

### Gate 1.5: Feature Completeness

| # | Criterion | PASS if |
|---|-----------|---------|
| 1 | Product concept analyzed | Every sentence reviewed for features |
| 2 | Feature candidates list | `.ultimate-sdlc/specs/features/feature-candidates.md` exists |
| 3 | Cross-reference verified | features_found >= features_in_concept |
| 4 | Anti-truncation signed | Signature in feature-candidates.md |
| 5 | No silent omissions | 100% concept coverage |
| 6 | User scope confirmation | User explicitly confirmed all features in scope (or excluded specific features with documented reasons) |
| 7 | User journeys mapped | All touchpoints → features |
| 8 | Feature categories | Category checklist completed (per `project_type` — see `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/project-presets.md`) |
| 9 | Scope lock ready | All data needed to generate `.ultimate-sdlc/specs/scope-lock.md` is present |
| 10 | Complexity classified | Every feature has Simple/Moderate/Complex classification |
| 11 | BRD exists (Standard/Enterprise) | `.ultimate-sdlc/specs/business/brd.md` exists with all 10 sections (or N/A if Lightweight) |
| 12 | Cross-document consistency (Standard/Enterprise) | Consistency audit run (per `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/consistency-audit-template.md § Gate 1.5`): 0 BLOCKING issues (or N/A if Lightweight) |

**On PASS**: Generate `.ultimate-sdlc/specs/scope-lock.md` — the canonical list of all in-scope features. This file is referenced by all downstream phases and gates.

```markdown
## Gate 1.5 Verification
- [ ] Total feature candidates: ___
- [ ] User-confirmed in scope: ___ | User-excluded: ___ (sum must = total)
- [ ] feature-candidates.md exists: YES/NO
- [ ] Anti-truncation declaration signed: YES/NO
- [ ] User exclusion reasons documented: YES/NO (or N/A if none excluded)
- [ ] Cross-reference ratio (candidates/concept): ___ (≥ 1.0)
- [ ] Feature category checklist completed: YES/NO
- [ ] User journeys mapped: ___/___ personas
- [ ] scope-lock.md generated: YES/NO
- [ ] BRD exists: YES/NO/N/A (Lightweight)
- [ ] Consistency audit: CLEAN / ___ BLOCKING issues (or N/A)
**GATE STATUS**: PASS / FAIL
```

---

### Gate 3.5: AIOU Decomposition

| # | Criterion | PASS if |
|---|-----------|---------|
| 1 | Full scope coverage | Every feature in `.ultimate-sdlc/specs/scope-lock.md` has ≥1 AIOU |
| 2 | Features decomposed | AIOU-*.md count ≥ 1 |
| 3 | Acceptance criteria | 100% of AIOUs have criteria |
| 4 | ≥3 criteria each | All AIOUs have ≥3 `- [ ]` items |
| 4a | Criteria are testable | Every criterion specifies a concrete input/action AND expected outcome. Criteria containing only "properly", "correctly", "as expected", "thoroughly" without specifying what that means = FAIL |
| 5 | Sized | All have Size: XS/S/M/L/XL |
| 6 | Waves assigned | All have Wave: 0-6 |
| 7 | Dependencies documented | All have Dependencies field |
| 8 | No circular deps | Manual review — no cycles |
| 9 | No blocking TBD/DEFERRED | 0 matches for current phase |
| 10 | Connectivity matrix | `.ultimate-sdlc/specs/connectivity-matrix.md` exists with all features represented |
| 11 | FEAT spec completeness | Every FEAT spec has all required sections per Feature Specification Matrix in `council-planning.md` — with substantive content (not 1-line placeholders). Sections: Purpose, User Stories, Acceptance Criteria, Data Requirements, API Contracts, UI Requirements, Edge Cases, Dependencies, Component Inventory, Navigation & Placement, Security Test Scenarios (as applicable per `project_type`) |
| 12 | PRD cross-cutting exists (Standard/Enterprise) | `.ultimate-sdlc/specs/prd-crosscutting.md` exists with NFR targets defined (or N/A if Lightweight) |
| 13 | API specification exists (Standard/Enterprise) | `.ultimate-sdlc/specs/architecture/api-specification.md` exists with all endpoints from FEAT specs (or N/A if Lightweight) |
| 14 | Database design exists (Standard/Enterprise) | `.ultimate-sdlc/specs/architecture/database-design.md` exists (or N/A if Lightweight) |
| 15 | Cross-document consistency | Consistency audit run (per `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/consistency-audit-template.md`): 0 BLOCKING issues |

```markdown
## Gate 3.5 Verification
- [ ] Features in scope-lock.md: ___ | Features with ≥1 AIOU: ___/___ (must be 100%)
- [ ] Total AIOUs: ___ | With criteria: ___/___ | ≥3 each: ___/___
- [ ] Criteria testability: ___/___ AIOUs have all criteria specifying concrete input/action + expected outcome
- [ ] FEAT spec completeness: ___/___ features have all required sections per specification matrix
- [ ] Sized: ___/___ | Waves assigned: ___/___ | Dependencies: ___/___
- [ ] Circular dependency check: PASS/FAIL
- [ ] TBD/DEFERRED blocking current phase: 0
- [ ] PRD cross-cutting: YES/NO/N/A | API spec: YES/NO/N/A | DB design: YES/NO/N/A
- [ ] Consistency audit: CLEAN / ___ BLOCKING issues
**GATE STATUS**: PASS / FAIL
```

---

### Gate 8: Launch Ready

| # | Criterion | PASS if |
|---|-----------|---------|
| 1 | All phases complete | current-state.md shows all complete |
| 2 | Full scope coverage | Every feature in `.ultimate-sdlc/specs/scope-lock.md` has a FEAT spec AND ≥1 AIOU AND is represented in handoff |
| 3 | No TBD items | grep TBD in .ultimate-sdlc/specs/ = 0 |
| 4 | No blocking DEFERRED | grep DEFERRED Phase-[1-8] = 0 |
| 5 | Security reviewed | `.ultimate-sdlc/specs/security/threat-model.md` exists |
| 6 | ADRs complete | All Status: Accepted |
| 7 | Handoff generated | `.ultimate-sdlc/handoffs/planning-handoff.md` exists |
| 8 | Handoff validates against schema | All 8 sections per `planning-handoff.schema.md` have content |
| 9 | Cross-document consistency | Consistency audit run: 0 BLOCKING issues across all specs |
| 10 | BRD traceability (Standard/Enterprise) | Every BR-XXX in BRD has ≥1 FEAT spec covering it (or N/A if Lightweight) |

**Handoff validation**: Use `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/handoff-schemas/planning-handoff.schema.md` as the single source of truth for required sections (8 sections including Design Direction).

**Scope coverage validation**: Cross-reference `.ultimate-sdlc/specs/scope-lock.md` against FEAT specs, AIOUs, and handoff content. Every feature must be traceable end-to-end. Missing features = automatic FAIL.

**Adversarial review** (after all criteria pass, before declaring PASS):
Challenge the plan with these questions:
1. **What's missing?** — Are there user journeys that aren't covered by any feature? Edge cases with no AIOU? Integration points between features that aren't documented?
2. **What could go wrong?** — Which architectural decisions have the highest risk? What happens if a core dependency fails? Are there single points of failure?
3. **What's underspecified?** — Are any AIOUs vague enough that an agent could interpret them in multiple incompatible ways? Are acceptance criteria specific enough to test?

If the adversarial review identifies genuine gaps: add them as findings, fix before declaring PASS. If it identifies risks but not gaps: document them in the handoff's "Known Risks" section and PASS.

```markdown
## Gate 8 Verification
- [ ] Phases 1-7 complete: YES/NO
- [ ] Scope-lock features: ___ | FEAT specs: ___/___ | AIOUs: ___/___ | In handoff: ___/___ (all must be 100%)
- [ ] TBD count: 0 | Blocking DEFERRED: 0
- [ ] Security threat model exists: YES/NO
- [ ] ADRs accepted: ___/___ | planning-handoff.md exists: YES/NO
- [ ] Handoff validates against schema: ___/8 sections
- [ ] Consistency audit: CLEAN / ___ BLOCKING issues
- [ ] BRD traceability: ___/___ BR-XXX covered by FEAT specs (or N/A)
**GATE STATUS**: PASS / FAIL
```

---

## Development Council Gates

### Gate I4: Services Complete

| # | Criterion | PASS if |
|---|-----------|---------|
| 1 | Types compile | Build exit code 0 |
| 2 | Lint passes | Lint exit code 0 |
| 3 | Unit tests pass | Test exit code 0 |
| 4 | Coverage ≥80% | Lines ≥ 80% |
| 5 | No high/critical vulns | Security audit exit code 0 |
| 6 | API contracts match | All endpoints implemented |
| 6a | API error responses complete | Every endpoint handles: 400 (input validation), 401/403 (if auth), 404 (if resource), 500 (generic). Each response code has ≥1 integration test. Endpoints returning ONLY 200+500 = FAIL |
| 7 | Waves 0-4 AIOUs complete | All marked complete |
| 8 | Dependencies verified | Package manager verify exits clean (`npm ls` / `pip check` / `cargo verify-project` / `go mod verify` exit 0); no packages in source that aren't in lockfile |
| 9 | Architectural consistency | No new patterns introduced without ADR; code follows existing codebase conventions; no code duplication >20 lines |
| 10 | **If frontend**: Design direction implemented | CSS custom properties match design doc values |
| 11 | **If frontend**: No banned fonts | No Inter, Arial, Roboto, system-ui |
| 12 | **If frontend**: Color palette defined | CSS custom properties or OKLCH/HSL values |
| 13 | API spec coverage (Standard/Enterprise) | All implemented endpoints exist in `.ultimate-sdlc/specs/architecture/api-specification.md` (or N/A if Lightweight) |
| 14 | Cross-document consistency (Standard/Enterprise) | Consistency audit run (per `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/consistency-audit-template.md § Gate I4`): 0 BLOCKING issues between planned specs and implemented code (or N/A if Lightweight) |

> Criteria 10-12 apply only if the project includes Wave 5 AIOUs (frontend work). For backend-only or non-web projects, mark as N/A.

```markdown
## Gate I4 Verification
- [ ] Build: ___ | Lint: ___ | Tests: ___ (all exit 0)
- [ ] Coverage: ___% (≥80%) | Security audit: exit ___
- [ ] API endpoints: ___/___ | Waves 0-4 AIOUs: all complete
- [ ] API error responses: ___/___ endpoints handle 400+401/403+404+500 (as applicable) | Error response tests: ___
- [ ] **If frontend**: Design implemented: YES/NO/N/A | Banned fonts: 0/N/A | Colors defined: YES/NO/N/A
- [ ] Consistency audit: CLEAN / ___ BLOCKING issues (or N/A)
**GATE STATUS**: PASS / FAIL
```

---

### Gate I8: Pre-Deployment

| # | Criterion | PASS if |
|---|-----------|---------|
| 1 | All tests pass | Exit 0 |
| 2 | Coverage ≥80% | Lines ≥ 80% |
| 3 | E2E tests pass | Exit 0 |
| 4 | Build succeeds | Exit 0 |
| 5 | No vulnerabilities | 0 high/critical |
| 6 | All AIOUs complete | 100% |
| 7 | Performance acceptable | p99 < `.ultimate-sdlc/config.yaml → quality.performance.p99_threshold_ms` (default 500ms) measured at `.ultimate-sdlc/config.yaml → quality.performance.concurrent_load` concurrent requests (default 10). Single-user p99 is NOT sufficient — test must simulate concurrent load. If no load test tool available, document baseline with concurrency count and method used |
| 7a | Feature verification | All features passed `/dev-verify-feature` (reports in `feature-verifications/`) |
| 7c | Dependencies verified | Package manager verify exits clean; no unresolved or extraneous packages |
| 7d | Test integrity preserved | No test assertions weakened, no `.skip` added, no coverage thresholds reduced vs. original test specs |
| 7b | Connectivity verified | All interactions in `.ultimate-sdlc/specs/connectivity-matrix.md` verified PASS. "Verified PASS" means: (1) the happy-path interaction works (Feature A calls Feature B → correct result), AND (2) ≥1 error path tested per interaction (Feature B returns error → Feature A handles gracefully, no crash, user sees appropriate feedback). Interactions verified only at happy-path level = FAIL |
| 8 | Handoff generated | development-handoff.md exists |
| 9 | **If frontend**: Anti-slop compliance | No banned fonts/patterns (load `ANTI-SLOP-VISUAL.md`) |
| 10 | **If frontend**: Design consistency | All components match design tokens |
| 11 | **If frontend**: Accessibility | WCAG 2.2 AA verified |
| 12 | **If frontend**: Visual QA evidence | Every Wave 5 AIOU has visual QA screenshots in `visual-qa/` OR documented manual QA |
| 13 | **If frontend**: UI design phases complete | `ui-design-research.md` and `ui-design-plan.md` exist |
| 14 | **If frontend**: UI wiring verification passed | All runs have `ui-verify-run-[N].md` with PASS verdict (0 CRITICAL, 0 HIGH) |
| 15 | **If frontend**: Navigation architecture complete | All routes from `ui-design-plan.md` navigation map exist and render |
| 16 | **If frontend**: Interactive elements wired | All buttons, forms, modals from `ui-design-plan.md` inventory are functional |
| 17 | Runbook exists (Enterprise) | `.ultimate-sdlc/specs/operations/runbook.md` exists with all applicable scenarios from checklist (or N/A if Lightweight/Standard) |
| 18 | Tech docs generated (Standard/Enterprise) | `docs/` contains README.md and ARCHITECTURE.md at minimum (or N/A if Lightweight) |
| 19 | Cross-document consistency | Consistency audit run: 0 BLOCKING issues |

> Criteria 9-16 apply only if the project includes frontend work. For backend-only or non-web projects, mark as N/A.

```markdown
## Gate I8 Verification
- [ ] Tests: ___ | Coverage: ___% | E2E: ___ | Build: ___ (all exit 0)
- [ ] Vulnerabilities: 0 | AIOUs: ___/___ | Performance p99: ___ms
- [ ] Feature verification: ___/___ features passed /dev-verify-feature
- [ ] Connectivity verified: ___/___ matrix interactions PASS
- [ ] development-handoff.md: YES/NO
- [ ] **If frontend**: Anti-slop: YES/NO/N/A | Design tokens: YES/NO/N/A | WCAG AA: YES/NO/N/A
- [ ] **If frontend**: Visual QA evidence: ___/___ Wave 5 AIOUs have screenshots (or documented manual QA)
- [ ] **If frontend**: UI design phases: research YES/NO/N/A | plan YES/NO/N/A
- [ ] **If frontend**: UI wiring verification: ___/___ runs PASS | 0 CRITICAL | 0 HIGH
- [ ] **If frontend**: Navigation complete: ___/___ routes exist and render
- [ ] **If frontend**: Interactive elements: ___/___ wired and functional
- [ ] Runbook: YES/NO/N/A | Tech docs: YES/NO/N/A
- [ ] Consistency audit: CLEAN / ___ BLOCKING issues
**GATE STATUS**: PASS / FAIL
```

---

## Audit Council Gates

### Gate T3: GUI Analysis

| # | Criterion | PASS if |
|---|-----------|---------|
| 1 | Navigation map exists | File exists |
| 2 | All screens documented | Count matches inventory |
| 3 | Usability audit complete | File exists with findings |
| 4 | WCAG AA tested | Report exists |
| 5 | Critical a11y: 0 | 0 critical issues |
| 6 | Screenshots captured | ≥1 per screen |
| 7 | **If frontend**: Design quality assessed | Report with anti-slop findings (load `ANTI-SLOP-VISUAL.md`) |
| 8 | **If frontend**: No banned fonts in production | 0 matches in CSS |
| 9 | **If frontend**: Design tokens consistent | All sampled components match |

> Criteria 7-9 apply only if the project includes frontend. For backend-only or non-web projects, mark as N/A.

```markdown
## Gate T3 Verification
- [ ] Nav map: YES/NO | Screens: ___/___ | Usability audit: YES/NO
- [ ] A11y report: YES/NO | Critical a11y: 0 | Screenshots: ___
- [ ] **If frontend**: Design quality: YES/NO/N/A | Banned fonts: 0/N/A | Token consistency: YES/NO/N/A
**GATE STATUS**: PASS / FAIL
```

---

### Gate A2: Completeness

| # | Criterion | PASS if |
|---|-----------|---------|
| 1 | All features tested | 100% covered |
| 2 | Test results documented | File exists |
| 3 | P0 defects logged | All have ID, description, screenshot |
| 4 | P1 defects logged | All have ID, description, screenshot |
| 5 | Screenshots exist | All references valid |
| 6 | Security requirements verified | All threats from threat-model.md have mitigations; all AIOU security reqs implemented |
| 7 | Security mitigations test-verified | Every threat in threat-model.md with a code-level mitigation has ≥1 NEGATIVE test case that attempts the attack and verifies it's blocked (e.g., SQL injection attempt → rejected, unauthorized access attempt → 403 returned, XSS payload → sanitized). Mitigation code without a test proving it works = FAIL |
| 8 | Test path depth per feature | Every feature tested at 3 levels: ≥1 happy path test, ≥1 error/validation path test, ≥1 edge case test. Features with only happy-path tests = FAIL |

```markdown
## Gate A2 Verification
- [ ] Features tested: ___/___ | Test results doc: YES/NO
- [ ] Test depth: ___/___ features have happy + error + edge case tests
- [ ] P0 defects: ___ (all complete) | P1 defects: ___ (all complete) | Screenshots valid: YES/NO
- [ ] Security requirements verified: ___% threats mitigated | ___% AIOU security reqs implemented
- [ ] Security mitigations test-verified: ___/___ threats have negative test cases | All pass: YES/NO
**GATE STATUS**: PASS / FAIL
```

---

### Gate A3: Quality Assessment

| # | Criterion | PASS if |
|---|-----------|---------|
| 1 | Quality scorecard complete | File exists |
| 2 | All 6 dimensions scored | Functionality, Reliability, Usability, Performance, Security, Maintainability |
| 3 | audit-handoff.md generated | File exists |
| 4 | defect-log.md generated | File exists |
| 5 | Overall score calculated | 1.0-5.0 |
| 6 | Security score >= 7 | Security dimension on rubric >= 7/10 |
| 7 | SEC-CRITICAL resolved | 0 SEC-CRITICAL findings open |
| 8 | SEC-HIGH resolved | 0 SEC-HIGH findings open |

```markdown
## Gate A3 Verification
- [ ] Scorecard: YES/NO | Dimensions: ___/6 | Score: ___
- [ ] audit-handoff.md: YES/NO | defect-log.md: YES/NO
- [ ] Security score: ___/10 (>= 7) | SEC-CRITICAL: 0 | SEC-HIGH: 0
**GATE STATUS**: PASS / FAIL
```

---

## Validation Council Gates

### Gate V5: Correction Planning

| # | Criterion | PASS if |
|---|-----------|---------|
| 1 | All defects analyzed | 100% have root cause |
| 2 | Correction plan exists | File exists |
| 3 | Each defect has fix plan | 100% planned |
| 4 | Priority order defined | Order present |

```markdown
## Gate V5 Verification
- [ ] Defects with root cause: ___/___ | Plan exists: YES/NO | Priority order: YES/NO
**GATE STATUS**: PASS / FAIL
```

---

### Gate C4: Regression Validation

| # | Criterion | PASS if |
|---|-----------|---------|
| 1 | All corrections applied | 100% fixed |
| 2 | Each fix verified | Before/after screenshots |
| 3 | 8-layer verification | 100% complete |
| 4 | No regressions | Tests pass post-fix |
| 5 | Correction log complete | 100% documented |

```markdown
## Gate C4 Verification
- [ ] Fixed: ___/___ | Before/after: ___/___ | 8-layer: ___/___
- [ ] Tests post-fix: exit ___ | Documentation: ___/___
**GATE STATUS**: PASS / FAIL
```

---

### Gate P4: Security Hardening

| # | Criterion | PASS if |
|---|-----------|---------|
| 1 | OWASP checklist | All 10 categories reviewed |
| 2 | Security headers | All required present |
| 3 | No high/critical vulns | Audit exit 0 |
| 4 | Secrets scan clean | No secrets found |
| 5 | Authentication verified | All flows pass |
| 6 | Authorization verified | All roles pass |

```markdown
## Gate P4 Verification
- [ ] OWASP: ___/10 | Headers: YES/NO | Vulns: 0
- [ ] Secrets scan: CLEAN | Auth tests: PASS | Authz tests: PASS
**GATE STATUS**: PASS / FAIL
```

---

### Gate E4: UX Polish

| # | Criterion | PASS if |
|---|-----------|---------|
| 1 | Enhancements implemented | 100% of approved |
| 2 | UX review complete | Report exists |
| 3 | No P0/P1 UX issues | 0 |
| 4 | Accessibility maintained | WCAG AA compliant |

```markdown
## Gate E4 Verification
- [ ] Enhancements: ___/___ | UX report: YES/NO | P0/P1 UX: 0 | WCAG AA: YES/NO
**GATE STATUS**: PASS / FAIL
```

---

### Gate S2: Release Readiness (FINAL)

| # | Criterion | PASS if |
|---|-----------|---------|
| 1 | All previous gates passed | All PASS |
| 2 | Documentation updated | Reflects final state |
| 3 | Release notes complete | File exists |
| 4 | Final tests pass | Exit 0 |
| 5 | validation-handoff.md | File exists |
| 6 | Sign-off complete | All signed |

**Previous gates by cycle type:**
- Full/Feature: 1.5, 3.5, 8, I4, I8, T3, A2, A3, V5, C4, P4, E4
- Patch/Maintenance: I4, I8, V5, C4, P4
- Improvement: I4, I8, T3, A2, A3, V5, C4, P4, E4

```markdown
## Gate S2 Verification - FINAL
### Previous Gates: [list per cycle type — all PASS]
- [ ] Docs current: YES/NO | Release notes: YES/NO | Tests: exit ___
- [ ] validation-handoff.md: YES/NO | Sign-offs: YES/NO
### Operational Readiness
- [ ] Monitoring configured | Runbook exists | Rollback tested | Feedback mechanism
**GATE STATUS**: PASS / FAIL | **RELEASE READY**: YES / NO
After PASS: Run `/deploy`
```

---

## 8-Layer Verification Protocol

Used at Gate C4 and for correction verification.

| Layer | Verify | PASS if |
|-------|--------|---------|
| 1. UI | Visual change correct | Screenshot match |
| 2. Event | Interactions trigger | Events fire as expected |
| 3. State | App state updates | State matches expected |
| 4. API | Calls send/receive | Request/response match spec |
| 5. Backend | Server processes | Logic executes without error |
| 6. Service | Business logic | Rules enforced |
| 7. Persist | Data saved/retrieved | Integrity maintained |
| 8. Restart | Survives restart | Fix present after restart |

Mark N/A for non-applicable layers per fix.

> **Project-type adaptation**: The 8-layer model is for web-apps. For other project types, use the verification layers defined in `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/project-presets.md`. CLI tools use 5 layers (Input→Logic→Output→Error→Edge Cases), libraries use 5 layers (API→Logic→Types→Error→Docs), etc.

---

## Cycle-Type Gate Adaptation

| Cycle Type | Planning Gates | Dev Gates | Audit Gates | Validation Gates |
|------------|---------------|-----------|-------------|-----------------|
| **Full** | Standard | Standard | Standard | Standard |
| **Feature** | Scoped to new features | Scoped to new/modified AIOUs | Standard | Standard |
| **Patch** | Abbreviated | Fix verification + regression | Skipped | Regression-focused |
| **Maintenance** | Abbreviated | Existing tests pass | Skipped | Regression-focused |
| **Improvement** | Abbreviated | No behavioral changes, coverage maintained | Verify no regressions | Standard |

**Feature**: Gate criteria apply only to new/modified items; existing coverage must not decrease.
**Patch/Maintenance**: Planning gates replaced by abbreviated workflow completion check.
**Improvement**: Behavioral contracts must be verified throughout.

---

## Gate Failure Protocol

### Escalation Ladder

| Attempt | Action |
|---------|--------|
| 1st failure | Identify specific failed criteria. Apply targeted fix. Re-run gate. |
| 2nd failure (same criterion) | Root-cause analysis: WHY did the fix not work? Document in WORKING-MEMORY.md. Try fundamentally different approach. Re-run. |
| 3rd failure (same criterion) | **STOP.** Document: (1) which criterion, (2) all approaches tried, (3) suspected root cause. Request user guidance. |
| 3rd failure (different criteria each time) | Implementation has systemic issues. Document all failures. Consider rolling back to last known-good state and re-implementing the current wave/phase. |

### Maximum Attempts

- **Per gate**: 5 total attempts maximum
- **After 5th failure**: Mandatory session end. Write comprehensive failure report to WORKING-MEMORY.md and .ultimate-sdlc/progress.md. User must intervene before proceeding.

### Remediation Decision Tree

```
Gate criterion failed
  ├── Build/Lint/Test failure → Fix code, not config (PRH-002/003)
  ├── Coverage below threshold → Add tests for uncovered paths (do NOT lower threshold)
  ├── Security scan failure → Fix vulnerability, do NOT suppress finding
  ├── Missing artifact → Generate the required artifact
  ├── Handoff schema invalid → Fill missing sections
  ├── Performance below threshold → Profile, identify bottleneck, optimize hot path
  └── Dependency verification failure → Fix or remove unresolved packages
```
