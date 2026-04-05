---
name: planning-supporting-specs
description: |
  Execute Planning Phases 4-7 combined. Security, testing, infrastructure, and sprint planning in one session.
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Agent
  - AskUserQuestion
---

## Preamble (run first)

```bash
# Detect project state
AG_HOME="${HOME}/.antigravity"
AG_PROJECT=".antigravity"
AG_SKILLS="${HOME}/.claude/skills/antigravity"

# Check if project is initialized
if [ -d "$AG_PROJECT" ]; then
  echo "PROJECT: initialized"
  # Read current state
  if [ -f "$AG_PROJECT/project-context.md" ]; then
    COUNCIL=$(grep -A1 "## Active Council" "$AG_PROJECT/project-context.md" | tail -1 | tr -d ' ')
    PHASE=$(grep -A1 "## Current Phase" "$AG_PROJECT/project-context.md" | tail -1 | tr -d ' ')
    STATUS=$(grep -A1 "## Status" "$AG_PROJECT/project-context.md" | tail -1 | tr -d ' ')
    echo "COUNCIL: $COUNCIL"
    echo "PHASE: $PHASE"  
    echo "STATUS: $STATUS"
  fi
else
  echo "PROJECT: not initialized (run /init first)"
fi

# Read global config
if [ -f "$AG_HOME/config.yaml" ]; then
  GOV_MODE=$(grep "governance_mode:" "$AG_HOME/config.yaml" | awk '{print $2}')
  PROJ_TYPE=$(grep "project_type:" "$AG_HOME/config.yaml" | awk '{print $2}')
  echo "GOVERNANCE: ${GOV_MODE:-standard}"
  echo "PROJECT_TYPE: ${PROJ_TYPE:-web-app}"
fi
```

After the preamble runs, use the detected state to verify prerequisites for this workflow.

## Knowledge Skills

Load these knowledge skills for reference during this workflow:
- Read `~/.claude/skills/antigravity/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# /planning-supporting-specs - Supporting Specifications (Phases 4-7)

## Purpose

Execute security analysis, testing strategy, infrastructure planning, and sprint planning as four sub-phases in a single workflow. Each sub-phase loads its own agent and domain skills.

---

## Prerequisites

- Gate 3.5 must be passed
- All AIOUs defined and wave-assigned

If prerequisites not met:
```
Gate 3.5 not passed. Run /planning-gate-3-5 first.
```

---

## Workflow

## Sub-Phase A: Security Analysis (Phase 4)

**Lens**: `[Security]` — Apply security analysis perspective.
**Load skills**: threat-modeling, security-patterns, risk-assessment

### A1: Asset Inventory

Identify and document:
- Data assets (user data, business data, credentials)
- System assets (servers, databases, APIs)
- Intellectual property

### A1b: Trust Zone Mapping

Define trust boundaries and zones for the system:

1. Read architecture diagrams from Phase 2
2. Identify trust zones:
   - **External** (untrusted): Public internet, third-party APIs, user browsers/devices
   - **DMZ** (semi-trusted): Load balancers, API gateways, CDN edge nodes
   - **Application** (trusted): Application servers, internal services, message queues
   - **Data** (highly trusted): Databases, secret stores, encryption key management
3. Map every component from architecture to its trust zone
4. Document data flows that cross trust boundaries — these are primary attack vectors
5. For each boundary crossing, note: protocol, authentication method, encryption, and data sensitivity level
6. Save trust zone diagram description in security specs section of WORKING-MEMORY.md

### A2: Threat Modeling (STRIDE)

| Threat | Description | Mitigation |
|--------|-------------|------------|
| **S**poofing | Identity impersonation | Authentication |
| **T**ampering | Data modification | Integrity checks |
| **R**epudiation | Denying actions | Audit logging |
| **I**nformation Disclosure | Data leaks | Encryption, access control |
| **D**enial of Service | System unavailability | Rate limiting, redundancy |
| **E**levation of Privilege | Unauthorized access | Authorization, least privilege |

For each component in architecture:
1. Identify applicable threats
2. Assess risk (likelihood x impact)
3. Define mitigations

For each high-risk threat, apply DREAD scoring (1-10 each):

| Factor | Score |
|--------|-------|
| **D**amage potential | ___ |
| **R**eproducibility | ___ |
| **E**xploitability | ___ |
| **A**ffected users | ___ |
| **D**iscoverability | ___ |
| **Risk Score** (sum/5) | ___ |

Priority: >=7 = Critical, 5-6 = High, 3-4 = Medium, 1-2 = Low

### A2b: Security Controls Matrix

Create a controls matrix mapping threats to concrete countermeasures:

| Threat ID | Threat | DREAD Score | Control | Control Type | Implementation Layer | AIOU Reference | Verification Method |
|-----------|--------|-------------|---------|-------------|---------------------|----------------|---------------------|
| T-XXX | [from STRIDE] | [score] | [specific control] | Preventive/Detective/Corrective | [trust zone] | AIOU-XXX | [how to test] |

For each control:
1. Specify whether it is preventive (blocks attack), detective (identifies attack), or corrective (recovers from attack)
2. Map to the trust zone boundary it protects
3. Reference the AIOU that will implement it
4. Define a concrete verification method (unit test, penetration test, audit log review, etc.)

### A3: Security Requirements

Document:
- Authentication mechanism (JWT, OAuth, etc.)
- Authorization model (RBAC, ABAC, etc.)
- Data protection (at rest, in transit, encryption standards)
- Input validation requirements
- Logging & monitoring requirements
- Compliance requirements (GDPR, HIPAA, etc.)

### A4: Security Architecture

Define:
- Authentication mechanism
- Authorization model
- Encryption approach
- Secret management
- Security boundaries

### A4b: Attack Surface Analysis

Document the system's attack surface by enumerating all entry points:

1. **Network entry points**: Every exposed port, endpoint, and protocol
2. **Authentication surfaces**: Login forms, API key endpoints, OAuth callbacks, token refresh
3. **File upload/download**: Any endpoint accepting or serving files
4. **Admin interfaces**: Management consoles, debug endpoints, health checks with sensitive data
5. **Third-party integrations**: Webhook receivers, callback URLs, SSO endpoints
6. **Client-side surfaces**: Local storage, cookies, postMessage handlers, deep links

For each entry point, document:
- URL/path pattern
- Authentication requirement (none, API key, session, OAuth)
- Input validation applied
- Rate limiting applied
- Logging/monitoring coverage
- Risk rating (Critical/High/Medium/Low)

Flag any entry point missing authentication or rate limiting as `[SECURITY GAP: ...]`.

### A5: Update AIOUs

Add security requirements to relevant AIOUs:
- Authentication AIOUs
- Authorization checks
- Input validation
- Encryption requirements

### Checkpoint A

Before proceeding to Sub-Phase B:
- [ ] Threat model complete
- [ ] Trust zones mapped with all boundary crossings documented
- [ ] Security controls matrix complete with verification methods
- [ ] Security requirements documented
- [ ] Security architecture defined
- [ ] Attack surface documented with all entry points enumerated
- [ ] Relevant AIOUs updated with security requirements
- [ ] Compliance requirements identified

**Save artifacts** and summarize key security decisions in WORKING-MEMORY.md.

---

## Sub-Phase B: Testing Strategy (Phase 5)

**Lens**: `[Quality]` — Apply testing and validation perspective.
**Swap skills**: test-strategy, test-patterns, coverage-planning

### B1: Define Test Levels

#### Unit Testing
- Coverage target: [e.g., 80%]
- Framework: [e.g., Jest, pytest]
- Mocking strategy

#### Integration Testing
- Scope: [API integration, service integration]
- Framework: [e.g., Supertest]
- Test database strategy

#### End-to-End Testing
- Scope: [Critical user journeys]
- Framework: [e.g., Playwright, Cypress]
- Test environment

#### Performance Testing
- Tools: [e.g., k6, Artillery]
- Benchmarks and load scenarios

#### Security Testing
- SAST tools, DAST approach, penetration testing scope

### B1b: Integration Test Specifications

For each service-to-service and service-to-database interaction:

1. Define mock/stub strategy:
   - Which dependencies are mocked vs. real (test containers, in-memory DBs)
   - Mock fidelity level (shallow stubs vs. contract-verified mocks)
2. Define contract tests for each API boundary (consumer-driven or provider-driven)
3. Specify test database strategy:
   - Schema migration before test suite
   - Data seeding approach (fixtures, factories)
   - Isolation method (transactions, truncation, separate DB per suite)
4. Map integration test scenarios to FEAT specs

### B1c: Performance Test Plan

Define performance testing approach:

1. **Load profiles**:
   - Normal load: [expected concurrent users, requests/sec]
   - Peak load: [2-3x normal, event-driven spikes]
   - Stress test: [find breaking point]
   - Soak test: [sustained load over hours to find memory leaks]
2. **Key transactions to benchmark**: Map to FEAT specs and API endpoints
3. **Performance budgets**:
   - API response time: p50, p95, p99 targets per endpoint category
   - Page load time: LCP, FID, CLS targets
   - Database query time: p95 target per query type
4. **Test data volume**: Define realistic data volumes for each entity (match database-design.md estimates)
5. **Environment requirements**: Specify infrastructure parity needed for meaningful results

### B1d: AI Output Quality Testing

> Skip if no FEAT specs include AI/ML features.

For each AI-powered feature:

1. Define quality metrics:
   - Accuracy/relevance threshold (e.g., >85% user satisfaction)
   - Hallucination detection method
   - Response latency budget
   - Cost per invocation budget
2. Define test datasets:
   - Golden set: curated input→expected output pairs
   - Edge cases: adversarial inputs, empty inputs, multilingual inputs
   - Regression set: previously-failed cases
3. Define fallback testing:
   - Behavior when AI service is unavailable
   - Behavior when response quality is below threshold
   - Graceful degradation to non-AI path
4. Define evaluation method: automated scoring, human review, or hybrid

### B2: Test Coverage Matrix

Map tests to requirements:

| Requirement | Unit | Integration | E2E | Security |
|-------------|------|-------------|-----|----------|
| FEAT-001 | X | X | X | |
| FEAT-002 | X | X | | X |

### B3: Test Data Strategy

Define:
- Test data sources
- Data generation approach
- Data cleanup procedures
- Sensitive data handling

### B4: CI/CD Test Integration

Plan:
- Which tests run on commit
- Which tests run on PR
- Which tests run on deploy
- Test parallelization

### Checkpoint B

Before proceeding to Sub-Phase C:
- [ ] Test levels defined
- [ ] Integration test mock strategies documented per service boundary
- [ ] Performance test profiles defined (normal, peak, stress, soak)
- [ ] AI output quality testing planned (or N/A if no AI features)
- [ ] Coverage targets set
- [ ] Test frameworks selected
- [ ] Test coverage matrix created
- [ ] Test data strategy defined
- [ ] CI/CD integration planned

**Save artifacts** and summarize key testing decisions in WORKING-MEMORY.md.

---

## Sub-Phase C: Infrastructure (Phase 6)

**Lens**: `[Operations]` — Apply infrastructure and deployment perspective.
**Swap skills**: infrastructure-design, cicd-patterns, monitoring-observability

### C1: Deployment Architecture

#### Environments
- Development, Staging, Production
- Environment parity strategy

#### Infrastructure Components
- Compute (servers, containers, serverless)
- Database (managed, self-hosted)
- Cache, Storage, CDN, Load balancing

#### Cloud/Hosting
- Provider and region selection
- Cost estimation

### C2: CI/CD Pipeline Specification

Design and document a comprehensive CI/CD pipeline. Save to `specs/infrastructure/ci-cd-spec.md`:

1. **Repository structure**: Monorepo vs. polyrepo, branch naming conventions
2. **Branch strategy**: Trunk-based, GitFlow, or GitHub Flow — with merge/rebase policy
3. **Pipeline stages** (define per-stage: trigger, tools, timeout, failure action):
   ```
   Lint → Build → Unit Test → Integration Test → Security Scan → Build Image → Deploy Staging → Smoke Test → Deploy Prod → Post-Deploy Verify
   ```
4. **Environment promotion**: Dev → Staging → Production gates and approval requirements
5. **Secret injection**: How secrets are provided to each pipeline stage (vault, CI secrets, OIDC)
6. **Container strategy**: Base image selection, multi-stage builds, image scanning, registry
7. **Database migration integration**: When migrations run in the pipeline, rollback on failure
8. **Rollback automation**: Automatic rollback triggers (health check failure, error rate spike), manual rollback procedure
9. **Pipeline monitoring**: Build time tracking, flaky test detection, deployment frequency metrics
10. **Artifact management**: Build artifact storage, retention policy, deployment manifests

### C3: Monitoring & Observability

Save to `specs/infrastructure/monitoring-plan.md`.

Plan:
- Logging (centralized), Metrics (application, infrastructure)
- Tracing (distributed), Alerting (thresholds, escalation)
- Dashboards

**SLI/SLO Definitions Table** (MANDATORY):

| Service/Endpoint | SLI (what to measure) | SLO Target | Measurement Window | Error Budget | Alert Threshold |
|-----------------|----------------------|------------|-------------------|-------------|----------------|
| [API overall] | Availability (successful requests / total) | 99.9% | 30-day rolling | 0.1% (~43 min) | <99.5% over 1hr |
| [API latency] | Request latency p99 | <500ms | 30-day rolling | — | p99 >1s for 5min |
| [Key transaction] | Success rate | 99.95% | 30-day rolling | 0.05% | <99.8% over 30min |

Define for each critical service and user-facing endpoint.

**Alerting Rules**:
- Define severity levels: P1 (page immediately), P2 (page during business hours), P3 (ticket), P4 (dashboard only)
- Map each SLO breach to a severity level
- Define escalation paths per severity

**On-Call Procedures**:
- Rotation schedule and tooling
- Runbook location and format
- Incident response process (detect → triage → mitigate → resolve → postmortem)

### C4: Disaster Recovery

Define:
- Backup strategy
- Recovery time objective (RTO) and recovery point objective (RPO)
- Failover procedures

### C5: Infrastructure as Code

Plan:
- IaC tool (Terraform, Pulumi, etc.)
- Repository structure
- Environment configuration
- Secret management

### Checkpoint C

Before proceeding to Sub-Phase D:
- [ ] Deployment architecture documented
- [ ] CI/CD pipeline specification saved to `specs/infrastructure/ci-cd-spec.md`
- [ ] Monitoring plan saved to `specs/infrastructure/monitoring-plan.md`
- [ ] SLI/SLO definitions complete for all critical services
- [ ] Alerting rules defined with severity levels and escalation paths
- [ ] Disaster recovery plan created
- [ ] Infrastructure as Code approach selected
- [ ] Cost estimation completed

**Save artifacts** and summarize key infrastructure decisions in WORKING-MEMORY.md.

---

## Sub-Phase D: Sprint Planning (Phase 7)

**Lens**: `[Requirements]` — Apply planning and prioritization perspective.
**Swap skills**: sprint-planning, estimation, risk-assessment

### D1: Estimate AIOUs

For each AIOU, estimate:
- Complexity: Simple / Medium / Complex
- Effort: Story points or hours
- Risk: Low / Medium / High

### D2: Sprint Organization

Organize AIOUs by wave into sprints:

Use **Display Template** from `council-planning.md` to show: Sprint 1: Foundation

### D2b: Critical Path Analysis

Identify the critical path through the development plan:

1. Map AIOU dependencies as a directed acyclic graph (DAG)
2. Calculate earliest start, earliest finish, latest start, latest finish for each AIOU
3. Identify the critical path — the longest chain of dependent AIOUs
4. Calculate total float for non-critical AIOUs
5. Document:
   - Critical path AIOUs (these cannot slip without delaying the project)
   - Near-critical paths (float < 1 sprint)
   - Parallelization opportunities (independent AIOUs that can be worked simultaneously)

### D2c: Risk Register

Create a project risk register with minimum 5 risks:

| Risk ID | Risk Description | Probability (1-5) | Impact (1-5) | Risk Score | Mitigation Strategy | Contingency Plan | Owner | Status |
|---------|-----------------|-------------------|-------------|------------|--------------------|--------------------|-------|--------|
| R-001 | [description] | [1-5] | [1-5] | [P×I] | [how to reduce probability/impact] | [what to do if it happens] | [role] | Open |

Categories to consider:
- Technical risks (new technology, complex integrations, performance unknowns)
- Resource risks (skill gaps, availability, onboarding time)
- External risks (third-party API changes, regulatory changes, vendor reliability)
- Schedule risks (underestimation, scope creep, dependency delays)
- Security risks (new attack vectors, compliance gaps)

### D2d: Global Definition of Done

Define the project-wide Definition of Done that applies to ALL AIOUs:

1. **Code quality**: Passes linting, follows coding standards, no TODO/FIXME without ticket
2. **Testing**: Unit tests pass, integration tests pass, coverage meets target
3. **Security**: No critical/high vulnerabilities, input validation, auth checks
4. **Documentation**: API docs updated, inline comments for complex logic, AIOU acceptance criteria met
5. **Review**: Code review approved by at least one reviewer
6. **Performance**: Meets performance budget defined in B1c
7. **Accessibility**: Meets WCAG level defined in prd-crosscutting.md (if applicable)
8. **Deployment**: Deployable to staging without manual intervention

This DoD supplements (does not replace) individual AIOU acceptance criteria.

### D3: Timeline

Create development timeline:
```
Week 1-2:  Sprint 1 (Foundation)
Week 3-4:  Sprint 2 (Data Layer)
Week 5-6:  Sprint 3 (Services)
Week 7-8:  Sprint 4 (API) + Gate I4
Week 9-10: Sprint 5 (UI)
Week 11:   Sprint 6 (Integration) + Gate I8
Week 12:   Buffer / Bug fixes
```

### D4: Risk Mitigation

For high-risk AIOUs:
- Identify mitigation strategies
- Plan spike/POC work
- Allocate buffer time

### D5: Dependencies Check

Verify:
- Sprint dependencies are respected
- No sprint depends on future sprint work
- Parallel work is identified

### Checkpoint D

Before completing:
- [ ] All AIOUs estimated
- [ ] Sprints defined
- [ ] Critical path identified with float analysis
- [ ] Risk register created with minimum 5 risks
- [ ] Global Definition of Done documented
- [ ] Timeline created
- [ ] Risks identified with mitigations
- [ ] Dependencies validated

**Save artifacts** and summarize key sprint decisions in WORKING-MEMORY.md.

---

## Completion

When all four sub-phases are complete:

1. Update `.antigravity/project-context.md`:
   - Set Phase 4-7 status: Complete

2. Update `.antigravity/council-state/planning/WORKING-MEMORY.md`:
   - Mark all sub-phases completed
   - Record session learnings

3. Record metrics in `.metrics/tasks/planning/`

4. Display completion message:

Use **Display Template** from `council-planning.md` to show: Phases 4-7: Supporting Specs - Complete

---
