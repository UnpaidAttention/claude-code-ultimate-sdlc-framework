---
name: planning-orchestration
description: Orchestrates multi-phase planning sessions with specialist agent coordination and quality gates. Use when running Planning Council sessions, transitioning between planning phases, coordinating multiple agents, preparing Development Council handoffs, or recovering from interrupted planning sessions.
---

# Planning Orchestration

> Coordinate complex multi-phase planning sessions with multiple specialist agents, ensuring smooth transitions, proper handoffs, and quality gates.


## Core Principles

| Principle | Rule |
|-----------|------|
| **Phase Integrity** | Complete each phase before advancing; no skipping |
| **State Persistence** | Always update progress.md after phase completion |
| **Gate Enforcement** | Gates require explicit approval before proceeding |
| **Agent Specialization** | Route work to agents with appropriate expertise |
| **Checkpoint Recovery** | Sessions can resume from last saved checkpoint |
| **Documentation First** | All decisions must be documented before implementation |


## When to Use

- Running Planning Council sessions
- Transitioning between planning phases
- Coordinating multiple specialist agents
- Preparing handoff documents for Development Council
- Recovering from interrupted planning sessions
- Managing complex multi-stakeholder planning


## Phase Overview

| Phase | Name | Key Output | Primary Agents |
|-------|------|------------|----------------|
| 1 | Discovery | Requirements document | analyst, strategist |
| 1.5 | Deliberation | MVP scope decision | strategist, analyst |
| 2 | Architecture | System design | architect |
| 3 | Features | Feature specifications | analyst, architect |
| 3.5 | AIOU Decomposition | Work breakdown (GATE) | scribe, architect |
| 4 | Security | Security requirements | security-analyst |
| 5 | Testing Strategy | Test plan | test-strategist |
| 6 | Infrastructure | Deployment plan | infrastructure-planner |
| 7 | Sprint Planning | Development sequence | scribe |
| 8 | Launch Ready | Handoff document (GATE) | strategist, scribe |


## Phase Orchestration Patterns

### Sequential Flow Pattern

```
Phase N Complete
    |
    v
[Verify Outputs] --> Missing? --> [Return to Phase N]
    |
    v (Complete)
[Update progress.md]
    |
    v
[Gate Check Required?] --> Yes --> [Request Approval]
    |                                    |
    v (No)                               v (Approved)
[Prepare Phase N+1 Context]
    |
    v
[Invoke Phase N+1 Agents]
```

### Parallel Execution Pattern

Some phases can run in parallel when outputs are independent:

| Parallel Group | Phases | Prerequisite |
|----------------|--------|--------------|
| Security + Testing | 4 + 5 | Phase 3.5 complete |
| Infrastructure | 6 | Phase 2 complete |

```
Phase 3.5 (AIOU) Complete
    |
    +---> Phase 4 (Security)     --|
    |                              |--> Phase 7 (Sprint Planning)
    +---> Phase 5 (Testing)      --|
    |
    +---> Phase 6 (Infrastructure) --+
```

### Iterative Refinement Pattern

```
[Initial Output]
    |
    v
[Review Against Criteria]
    |
    v
[Gaps Found?] --> Yes --> [Targeted Refinement]
    |                           |
    v (No)                      v
[Accept Output] <---------------+
```


## State Management

### Progress File Structure

```markdown
# Planning Progress

## Current State
- **Active Phase**: 3
- **Status**: in_progress
- **Last Updated**: 2024-01-15T14:30:00Z
- **Session ID**: planning-session-abc123

## Phase Completion
| Phase | Status | Completed At | Approver |
|-------|--------|--------------|----------|
| 1 | complete | 2024-01-14T10:00:00Z | - |
| 1.5 | complete | 2024-01-14T14:00:00Z | user |
| 2 | complete | 2024-01-15T11:00:00Z | - |
| 3 | in_progress | - | - |

## Blocking Issues
- None

## Next Actions
1. Complete feature specifications for auth module
2. Review with stakeholder
```

### State Transitions

| From State | To State | Trigger | Required |
|------------|----------|---------|----------|
| `not_started` | `in_progress` | Phase initiated | Agent assignment |
| `in_progress` | `review` | Outputs complete | Output validation |
| `review` | `complete` | Review passed | None or approval |
| `review` | `in_progress` | Review failed | Gap identification |
| `complete` | `locked` | Gate approved | Explicit approval |
| Any | `blocked` | Blocking issue | Issue documentation |

### Checkpoint Format

```json
{
  "session_id": "planning-session-abc123",
  "phase": 3,
  "state": "in_progress",
  "timestamp": "2024-01-15T14:30:00Z",
  "context": {
    "current_feature": "F-003",
    "completed_features": ["F-001", "F-002"],
    "pending_decisions": []
  },
  "agent_states": {
    "analyst": "active",
    "architect": "waiting"
  }
}
```


## Handoff Protocols

### Phase-to-Phase Handoff

```markdown
## Handoff: Phase {N} -> Phase {N+1}

### Completed Deliverables
- [ ] Output 1: [link/location]
- [ ] Output 2: [link/location]

### Key Decisions Made
1. Decision 1: Rationale
2. Decision 2: Rationale

### Open Items for Next Phase
- Item 1: Context needed
- Item 2: Dependency on external input

### Assumptions Carried Forward
- Assumption 1
- Assumption 2

### Agent Notes
- Note from analyst: ...
- Note from architect: ...
```

### Council-to-Council Handoff (Planning -> Development)

```markdown
## Development Handoff Package

### Project Summary
- Name: [Project Name]
- MVP Scope: [Brief description]
- Timeline: [Expected duration]

### Documentation Index
| Document | Location | Status |
|----------|----------|--------|
| Requirements | /planning/requirements.md | Final |
| Architecture | /planning/architecture.md | Final |
| Feature Specs | /planning/features/ | Final |
| Security Requirements | /planning/security.md | Final |
| Test Strategy | /planning/testing.md | Final |
| Infrastructure Plan | /planning/infrastructure.md | Final |

### Wave Structure
| Wave | Features | Dependencies |
|------|----------|--------------|
| 1 | F-001, F-002 | None |
| 2 | F-003, F-004 | Wave 1 |
| 3 | F-005 | Wave 2 |

### Critical Path Items
1. Item 1 - blocks everything
2. Item 2 - blocks Wave 2

### Known Risks
| Risk | Mitigation | Owner |
|------|------------|-------|
| Risk 1 | Mitigation approach | Role |

### Success Criteria
- [ ] Criterion 1
- [ ] Criterion 2
```


## Progress Tracking Mechanisms

### Phase Progress Dashboard

```markdown
## Planning Dashboard

### Overall Progress
[=========>          ] 45% Complete

### Phase Status
| Phase | Progress | Blockers | ETA |
|-------|----------|----------|-----|
| 1 Discovery | 100% | - | Done |
| 1.5 Deliberation | 100% | - | Done |
| 2 Architecture | 100% | - | Done |
| 3 Features | 60% | 1 | 2h |
| 3.5 AIOU | 0% | - | - |
| 4 Security | 0% | - | - |

### Active Blockers
1. [BLOCKER-001] Awaiting stakeholder decision on auth provider

### Recent Activity
- 14:30 - Completed F-002 specification
- 14:00 - Started F-003 specification
- 13:00 - Resolved BLOCKER-000
```

### Deliverable Tracking

| Deliverable | Phase | Status | Location | Reviewer |
|-------------|-------|--------|----------|----------|
| Requirements Doc | 1 | Complete | /reqs.md | strategist |
| MVP Decision | 1.5 | Complete | /mvp.md | user |
| System Diagram | 2 | Complete | /arch.md | architect |
| Feature F-001 | 3 | Complete | /features/F-001.md | analyst |
| Feature F-002 | 3 | In Review | /features/F-002.md | architect |
| Feature F-003 | 3 | In Progress | /features/F-003.md | - |


## Rollback and Recovery Patterns

### Rollback Scenarios

| Scenario | Action | State After |
|----------|--------|-------------|
| Phase output rejected | Revert to phase start | `in_progress` |
| Gate approval denied | Revert to pre-gate phase | `review` |
| New requirements discovered | Assess impact, may revert | Varies |
| Stakeholder change request | Document, assess scope | May restart phase |

### Recovery Procedure

```markdown
## Recovery Checklist

### 1. Assess Current State
- [ ] Read progress.md for last known state
- [ ] Check for incomplete outputs
- [ ] Identify any blocking issues

### 2. Validate Completed Work
- [ ] Verify completed phase outputs exist
- [ ] Confirm outputs meet acceptance criteria
- [ ] Check for any invalidated assumptions

### 3. Resume Execution
- [ ] Update progress.md with recovery timestamp
- [ ] Re-invoke appropriate agents
- [ ] Continue from last valid checkpoint

### 4. Document Recovery
- [ ] Note reason for interruption
- [ ] Record any state changes during recovery
- [ ] Update timeline estimates if needed
```

### Partial Rollback

```
Current: Phase 4 (Security) in_progress
Issue: Architecture decision in Phase 2 needs revision

Rollback Scope:
- Phase 2: Revise specific decision
- Phase 3: Review affected features only
- Phase 3.5: Re-decompose affected features
- Phase 4: Continue after updates propagate
```


## Multi-Agent Coordination

### Agent Assignment Matrix

| Phase | Lead Agent | Support Agents | Handoff To |
|-------|------------|----------------|------------|
| 1 | analyst | strategist | strategist |
| 1.5 | strategist | analyst | architect |
| 2 | architect | - | analyst |
| 3 | analyst | architect | scribe |
| 3.5 | scribe | architect | security-analyst |
| 4 | security-analyst | - | test-strategist |
| 5 | test-strategist | - | infrastructure-planner |
| 6 | infrastructure-planner | - | scribe |
| 7 | scribe | - | strategist |
| 8 | strategist | scribe | Development Council |

### Agent Communication Protocol

```markdown
## Agent Message Format

### Request
FROM: [sending-agent]
TO: [receiving-agent]
PHASE: [current-phase]
TYPE: [handoff | query | review-request | escalation]
PRIORITY: [normal | urgent | blocking]

CONTEXT:
[Relevant context for the receiving agent]

REQUEST:
[Specific ask or deliverable expected]

DEADLINE: [if applicable]
```

### Conflict Resolution

| Conflict Type | Resolution Process |
|---------------|-------------------|
| Technical disagreement | Architect makes final call |
| Scope disagreement | Strategist escalates to user |
| Priority conflict | Scribe documents, strategist decides |
| Resource conflict | Infrastructure-planner mediates |


## Gate Requirements

### Gate 3.5 (AIOU Decomposition)

| Criterion | Validation |
|-----------|------------|
| All features decomposed | Every F-XXX has AIOU breakdown |
| Dependencies mapped | Dependency graph complete |
| Waves assigned | Each feature in a wave |
| Sizes estimated | T-shirt sizes for all items |
| No circular dependencies | Graph validation passes |

### Gate 8 (Launch Ready)

| Criterion | Validation |
|-----------|------------|
| All specs complete | No placeholder content |
| No TBD items | Search for "TBD" returns empty |
| Security reviewed | Security-analyst sign-off |
| Test plan complete | Coverage for all features |
| Infrastructure defined | Deployment runbook ready |
| Handoff document prepared | All sections complete |


## Session Management Checklist

### Starting a Session

- [ ] Read project-context.md for project overview
- [ ] Check progress.md for current state
- [ ] Identify active phase and status
- [ ] Review any blocking issues
- [ ] Prepare context for active agents

### During a Session

- [ ] Update progress.md after each phase completion
- [ ] Document all decisions with rationale
- [ ] Track blocking issues immediately
- [ ] Maintain handoff notes between agents

### Ending a Session

- [ ] Save checkpoint state
- [ ] Update progress.md with session summary
- [ ] Document next actions
- [ ] Prepare resumption context


## Quality Checks

| Check | Question |
|-------|----------|
| **Completeness** | Are all phase outputs present? |
| **Consistency** | Do outputs align across phases? |
| **Traceability** | Can we trace requirements to features? |
| **Approval** | Are gates properly approved? |
| **Documentation** | Is state recoverable from docs? |


## Anti-Patterns

| Pattern | Problem | Fix |
|---------|---------|-----|
| Skipping phases | Missing critical analysis | Enforce phase sequence |
| Undocumented decisions | Can't recover or explain | Document all decisions |
| Gate bypassing | Quality issues downstream | Strict gate enforcement |
| State in memory only | Session loss = progress loss | Persist to progress.md |
| Monolithic phases | Too long, hard to checkpoint | Break into sub-phases |
| Agent overload | One agent doing everything | Respect specialization |


## Related Skills

- feature-deliberation - Phase 1.5 detailed process
- aiou-decomposition - Phase 3.5 detailed process
- project-coordination - Overall project management
- handoff-protocols - Detailed handoff procedures
