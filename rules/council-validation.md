# Validation Council Rules

Load when: `/council validation` or `/validate-*` commands

## Multi-Session Design

The Validation Council has 22 phases across 5 tracks. It is designed for **mandatory multi-session execution**. Each track produces a self-contained checkpoint artifact that enables a fresh session to resume without accumulated context:

| After Track | Checkpoint Artifact | Contents |
|-------------|--------------------|-----------|
| V5 complete | `validation-checkpoint-v5.md` | Intent map, gap analysis, completeness matrix, correction plan |
| C4 complete | `validation-checkpoint-c4.md` | All corrections applied, before/after evidence, regression results |
| P4 complete | `validation-checkpoint-p4.md` | Ops checklist, failure modes, performance benchmarks, security hardening |
| E4 complete | `validation-checkpoint-e4.md` | Enhancement list, UX polish results, accessibility verification |

**Session boundaries**: Plan to end sessions at track boundaries. Each checkpoint contains everything needed to start the next track in a fresh context. Do NOT attempt to run all 5 tracks in a single session.

## Track Structure (Sequential - Must Complete In Order)

### Validation Track (V1-V5)
| Phase | Name | Output |
|-------|------|--------|
| V1 | Intent Extraction | intent-map.md |
| V2 | Gap Analysis | Gap report |
| V3 | Completeness Assessment | completeness-matrix.md |
| V4 | Prerequisite Verification | Prereq check |
| V5 | Correction Planning | Correction plan |

### Correction Track (C1-C4)
| Phase | Name | Output |
|-------|------|--------|
| C1 | Targeted Corrections | Fixes applied |
| C2 | Edge Case Implementation | Edge cases handled |
| C3 | Verification Testing | Verification tests |
| C4 | Regression Validation | Regression passed |

### Production Track (P1-P4)
| Phase | Name | Output |
|-------|------|--------|
| P1 | Operational Assessment | Ops checklist |
| P2 | Failure Mode Analysis | Failure modes |
| P3 | Performance Optimization | Perf benchmarks |
| P4 | Security Hardening | Security hardened |

### Enhancement Track (E1-E4)
| Phase | Name | Output |
|-------|------|--------|
| E1 | Feature Richness | Richness analysis |
| E2 | Innovation Opportunities | Ideas |
| E3 | Enhancement Implementation | Implemented |
| E4 | UX Polish | UX refined |

### Synthesis Track (S1-S2)
| Phase | Name | Output |
|-------|------|--------|
| S1 | Documentation Update | Docs updated |
| S2 | Release Readiness | validation-handoff.md |

## Quality Gates

Gate criteria are defined in `~/.claude/skills/ultimate-sdlc/context/gate-criteria.md` (single source of truth).
Mode-specific activation: see `~/.claude/skills/ultimate-sdlc/context/governance-modes.md § Per-Council Phase Activation`.

- **Gate V5**: Correction Plan → see `gate-criteria.md § Gate V5`
- **Gate C4**: Regression Validation → see `gate-criteria.md § Gate C4`
- **Gate P4**: Security Hardened → see `gate-criteria.md § Gate P4`
- **Gate E4**: UX Polish → see `gate-criteria.md § Gate E4`
- **Gate S2**: Release Ready → see `gate-criteria.md § Gate S2`

**After Gate S2 passes:** Run `/deploy` to execute production deployment.

## Session Protocol

Standard session start/resume sequence for all Validation Council workflows:

1. Read `.ultimate-sdlc/config.yaml` → extract `governance_mode`, `project_type`
2. Read `.ultimate-sdlc/project-context.md` → confirm Active Council = Validation, get current track/phase
3. Read `.ultimate-sdlc/handoffs/audit-handoff.md` → load quality assessment results
4. Read `.ultimate-sdlc/council-state/validation/WORKING-MEMORY.md` → check for incomplete tasks
5. Check for checkpoint artifacts (`validation-checkpoint-*.md`) → resume from last checkpoint
6. **If resuming**: Display resume summary from checkpoint, continue from next track
7. **If new session**: Display welcome with track overview
8. Check governance_mode → skip non-applicable tracks per `~/.claude/skills/ultimate-sdlc/context/governance-modes.md`
9. **Lazy initialization**: Only create supporting documents (correction-log.md, enhancement-ideas.md) when their track starts, not at V1 setup

## Evidence Protocol

MANDATORY for every correction. Evidence format varies by `project_type`:

| project_type | Before Evidence | After Evidence |
|-------------|----------------|---------------|
| `web-app` | Screenshot (issue visible) | Screenshot (issue resolved) |
| `mobile-app` | Screenshot (issue visible) | Screenshot (issue resolved) |
| `cli-tool` | Terminal output (error state) | Terminal output (correct state) |
| `library` | Test output (failing) | Test output (passing) |
| `api-service` | Request/response diff (error) | Request/response diff (correct) |
| `ml-pipeline` | Metric output (before) | Metric output (after) |

Steps:
1. Reproduce the issue
2. Capture BEFORE evidence (format per table above)
3. Apply fix
4. Capture AFTER evidence
5. If fix involves interaction/animation (web-app/mobile-app): record browser session video
6. Write verification test
7. Run regression suite
8. Document in correction-log.md

**NO CORRECTION COMPLETE WITHOUT BOTH EVIDENCE ARTIFACTS + TEST**

## Verification Layers

Verification layers are determined by `project_type` — see `~/.claude/skills/ultimate-sdlc/context/project-presets.md` for type-specific layers.

Default (web-app): 1. UI Interaction → 2. Event Handler → 3. Frontend Logic → 4. API/IPC Bridge → 5. Backend Handler → 6. Service Logic → 7. Persistence → 8. Load on Restart

> For non-web project types, the layer count and structure differ. Always consult project-presets.md.

## Display Template

```markdown
## Validation Council - [Track]: [Phase Name]

**Mode**: [governance_mode] | **Type**: [project_type]
**Track**: [N] of [active_track_count] | **Phase**: [X N]
**Checkpoint**: [last checkpoint or "None"]

[Phase-specific content follows]
```

## Focus Lenses

| Lens | Applied During |
|------|---------------|
| `[Quality]` | V1-V5, C1-C4, S1-S2 |
| `[Security]` | P3-P4, all gates |
| `[Performance]` | P1-P3 |
| `[Operations]` | P1-P2 |
| `[UX]` | E1-E4 (if frontend) |
| `[Documentation]` | S1 |

## Model Selection

- Validation Track (V1-V5): claude-opus-4-6
- Correction Track (C1-C4): claude-sonnet-4-6
- Production Track (P1-P4): claude-opus-4-6
- Enhancement Track (E1-E4): claude-opus-4-6
- Synthesis Track (S1-S2): claude-opus-4-6

## Enhancement Track Note

> **E-track creates backlog, not implementations.** Enhancement phases (E1-E4) discover opportunities, evaluate feasibility, and produce a prioritized enhancement backlog for the next development cycle. Actual implementation of new features happens via `/new-cycle`, not during validation.

## Handoff Output

validation-handoff.md containing: Validation summary, Corrections applied, Production hardening status, Enhancement backlog, Release checklist, RELEASE READY status

Validate against `~/.claude/skills/ultimate-sdlc/context/handoff-schemas/validation-handoff.schema.md`.

## Recovery

If recovering mid-track, check for the most recent checkpoint artifact (`validation-checkpoint-*.md`). Resume from the track after the last checkpoint. Track boundaries are natural recovery and session-end points. See `/recover` for full protocol.
