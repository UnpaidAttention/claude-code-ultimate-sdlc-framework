---
description: Master orchestration skill for the validation and perfection workflow. Coordinates intent extraction, gap analysis, correction planning, production hardening, and release readiness across all validation tracks.
---

# Validation & Perfection Orchestration

Master process skill for orchestrating the full validation and perfection workflow.

## Skill Purpose

Coordinate the complete journey from AI-generated code to production-perfect software through systematic validation, verified corrections, production hardening, and feature enhancement.

## Process Overview

```
┌──────────────────────────────────────────────────────────────────┐
│                    VALIDATION TRACK (V1-V5)                      │
│  Intent → Gaps → Completeness → Prerequisites → Correction Plan  │
└──────────────────────────────────────────────────────────────────┘
                              ↓ Gate V5
┌──────────────────────────────────────────────────────────────────┐
│                    CORRECTION TRACK (C1-C4)                      │
│  Targeted Fixes → Edge Cases → Verification → Regression Check   │
└──────────────────────────────────────────────────────────────────┘
                              ↓ Gate C4
┌──────────────────────────────────────────────────────────────────┐
│                    PRODUCTION TRACK (P1-P4)                      │
│  Operations → Failure Modes → Performance → Security Hardening   │
└──────────────────────────────────────────────────────────────────┘
                              ↓ Gate P4
┌──────────────────────────────────────────────────────────────────┐
│                    ENHANCEMENT TRACK (E1-E4)                     │
│  Feature Richness → Innovation → Implementation → UX Polish      │
└──────────────────────────────────────────────────────────────────┘
                              ↓ Gate E4
┌──────────────────────────────────────────────────────────────────┐
│                    SYNTHESIS TRACK (S1-S2)                       │
│  Documentation Update → Release Readiness                        │
└──────────────────────────────────────────────────────────────────┘
                              ↓ Gate S2
                        [RELEASE READY]
```

## Orchestration Rules

### Rule 1: Sequential Tracks
Tracks must be completed in order. Cannot skip to Production without completing Validation and Correction.

### Rule 2: Parallel Phases Within Tracks
Phases within a track can be parallelized where dependencies allow.

### Rule 3: Gate Enforcement
Cannot proceed to next track without passing gate.

### Rule 4: Feature Focus
Work on ONE feature at a time through phases. Complete fully before moving to next feature.

### Rule 5: Progress Persistence
Update state files before any context switch or major transition.

## Session Management

### Session Start
```markdown
1. Read validation-context.md
2. Determine current track and phase
3. Load phase-specific skills
4. Resume from last checkpoint
5. Display status to user
```

### Session Progress
```markdown
1. Work on current feature/phase
2. Document findings immediately
3. Log corrections instantly
4. Update progress.md regularly
5. Checkpoint before transitions
```

### Session End
```markdown
1. Update progress.md with session summary
2. Update validation-context.md with current state
3. List next steps for resumption
4. Save all state files
```

## State Files

### validation-context.md
```markdown
# Validation Context

## Current State
- Track: [Validation/Correction/Production/Enhancement/Synthesis]
- Phase: [V1-V5/C1-C4/P1-P4/E1-E4/S1-S2]
- Feature: [Current feature being validated]

## Progress
- Features Validated: [X] / [Total]
- Corrections Made: [X]
- Gates Passed: [List]

## Session History
- [Date]: [Phase] - [Summary]
```

### progress.md
```markdown
# Session Progress

## Current Session
- Date: [Date]
- Phase: [Phase]
- Focus: [What we're working on]

## Findings
- [Finding 1]
- [Finding 2]

## Actions Taken
- [Action 1]
- [Action 2]

## Next Steps
1. [Next step 1]
2. [Next step 2]
```

## Agent Coordination

### Phase-to-Agent Mapping
| Phase | Primary Agent | Support Agents |
|-------|---------------|----------------|
| V1 | intent-analyst | - |
| V2 | gap-detective | intent-analyst |
| V3 | completeness-auditor | gap-detective |
| V4 | completeness-auditor | - |
| V5 | completeness-auditor | - |
| C1-C4 | correction-engineer | - |
| P1 | operations-analyst | - |
| P2 | resilience-engineer | - |
| P3 | performance-architect | - |
| P4 | security-hardener | - |
| E1-E2 | innovation-catalyst | - |
| E3-E4 | experience-designer | - |
| S1-S2 | - (hub handles) | - |

### Delegation Protocol
```markdown
Delegate to [agent]:
- Context: Phase [X], Feature [Y]
- Task: [Specific task]
- Input: [What they need to know]
- Output: [Expected format]
```

## Quality Gate Procedures

### Gate Check Process
1. Load gate checklist
2. Verify each item
3. Document evidence for each
4. If all pass → Proceed to next track
5. If any fail → Remediate and recheck

### Gate Checklists

**Gate V5**: Validation Complete
- [ ] All features have documented intent
- [ ] All implementation gaps identified
- [ ] Completeness matrices filled
- [ ] Prerequisites verified
- [ ] Correction plan created

**Gate C4**: Correction Complete
- [ ] All corrections implemented
- [ ] All corrections verified
- [ ] No regressions introduced
- [ ] Edge cases handled

**Gate P4**: Production Complete
- [ ] Operational requirements met
- [ ] Failure modes mitigated
- [ ] Performance acceptable
- [ ] Security hardened

**Gate E4**: Enhancement Complete
- [ ] Feature richness evaluated
- [ ] Enhancements implemented
- [ ] UX polished
- [ ] All verified

**Gate S2**: Release Ready
- [ ] Documentation complete
- [ ] All tests passing
- [ ] Production checklist verified
- [ ] Release notes prepared

## Troubleshooting

### Stuck at Gate
1. Review failing checklist items
2. Create targeted tasks to address
3. Re-run gate check after fixes

### Context Lost
1. Read validation-context.md
2. Read progress.md
3. Review correction-log.md
4. Resume from documented state

### Conflicting Findings
1. Document both perspectives
2. Trace to source of truth
3. Verify with tests
4. Update documentation

## Success Metrics

Track completion:
- Validation Track: All features have intent, gaps, completeness scores
- Correction Track: All corrections verified, no regressions
- Production Track: Production readiness checklist passed
- Enhancement Track: Feature richness improved, UX polished
- Synthesis Track: Documentation complete, release ready
