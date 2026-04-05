name: validation-orchestration
description: Orchestrates Validation Council tracks from intent to release readiness. Use when running Validation Council.

# Validation Orchestration

Coordinating the Validation Council's correction and hardening tracks.

## When to use this skill

- Running Validation Council sessions
- Managing defect corrections
- Preparing for release

## Track Overview

### Validation Track (V1-V5)

| Phase | Name | Output |
|-------|------|--------|
| V1 | Intent Extraction | Intent analysis |
| V2 | Gap Analysis | Gap report |
| V3 | Completeness Assessment | Coverage report |
| V4 | Prerequisite Verification | Dependency check |
| V5 | Correction Planning | Correction plan (GATE) |

### Correction Track (C1-C4)

| Phase | Name | Output |
|-------|------|--------|
| C1 | Targeted Corrections | Fixed defects |
| C2 | Edge Cases | Edge case fixes |
| C3 | Verification Testing | Test results |
| C4 | Regression Validation | Regression report (GATE) |

### Production Track (P1-P4)

| Phase | Name | Output |
|-------|------|--------|
| P1 | Operational Assessment | Ops readiness |
| P2 | Failure Mode Analysis | FMEA report |
| P3 | Performance Optimization | Performance report |
| P4 | Security Hardening | Security report (GATE) |

### Enhancement Track (E1-E4)

| Phase | Name | Output |
|-------|------|--------|
| E1 | Feature Richness | Feature gaps |
| E2 | Innovation Opportunities | Ideas list |
| E3 | Enhancement Implementation | Enhancements |
| E4 | UX Polish | UX improvements (GATE) |

### Synthesis Track (S1-S2)

| Phase | Name | Output |
|-------|------|--------|
| S1 | Documentation Update | Updated docs |
| S2 | Release Readiness | Release cert (GATE) |

## Gate Requirements

**Gate V5**: All defects analyzed, corrections planned
**Gate C4**: All corrections verified, no regressions
**Gate P4**: Production-ready, security hardened
**Gate E4**: Enhancements complete, UX polished
**Gate S2**: Documentation complete, release certified

## Agent Coordination

| Track | Primary Agents |
|-------|---------------|
| V1-V5 | intent-analyst, gap-analyst |
| C1-C4 | correction-engineer, edge-case-specialist |
| P1-P4 | production-engineer, security-hardener |
| E1-E4 | enhancement-engineer, ux-specialist |
| S1-S2 | synthesis-lead, documentation-specialist |
