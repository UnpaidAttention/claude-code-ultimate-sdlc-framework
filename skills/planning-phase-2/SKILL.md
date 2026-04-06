---
name: sdlc-planning-phase-2
description: |
  Execute Planning Phase 2 - Architecture. Define system architecture, create ADRs, and establish technical foundation.
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
AG_HOME="${HOME}/.Ultimate SDLC"
AG_PROJECT=".ultimate-sdlc"
AG_SKILLS="${HOME}/.claude/skills/ultimate-sdlc"

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
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/architecture-principles/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/decision-making/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/system-design/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


# /planning-phase-2 - Architecture

## Lens / Skills / Model
**Lens**: `[Architecture]` | **Model**: Claude Opus 4
> Apply RARV cycle, session protocol per council-planning.md

## Prerequisites

- Phase 1.5 (Deliberation) must be complete
- Feature scope confirmed (scope-lock.md generated at Gate 1.5)

If prerequisites not met:
```
Phase 1.5 not complete. Run /planning-phase-1-5 first.
```

---

## Workflow

### Step 1: Update Project State

Update `.ultimate-sdlc/project-context.md`:
- Set `Active Council`: planning
- Set `Current Phase`: 2 - Architecture
- Set `Status`: in_progress

### Step 2: Review Inputs

Read and understand:
- `specs/scope-lock.md` — complete feature list from Phase 1.5
- Technical constraints
- Non-functional requirements
- Existing system context (if any)

### Agent: sdlc-architecture
Invoke via Agent tool with `subagent_type: "sdlc-architecture"`:
- **Provide**: scope-lock.md (full feature list), technical constraints, non-functional requirements, project type
- **Request**: Design high-level system architecture — component decomposition, service boundaries, integration patterns, technology stack recommendations with trade-off analysis
- **Apply**: Use architecture agent's design as the foundation for Step 3 outputs and ADR creation

### Agent: sdlc-database-specialist
Invoke via Agent tool with `subagent_type: "sdlc-database-specialist"`:
- **Provide**: scope-lock.md features, architecture agent's component design, data-related constraints
- **Request**: Design conceptual data model — entities, relationships, storage approach, data flow patterns, database technology recommendation with rationale
- **Apply**: Integrate into Data Architecture section and database design document (Step 4B)

### Agent: sdlc-api-designer
Invoke via Agent tool with `subagent_type: "sdlc-api-designer"`:
- **Provide**: scope-lock.md features, architecture agent's service boundaries, integration points
- **Request**: Define API strategy — internal vs external API boundaries, API style (REST/GraphQL/gRPC), versioning approach, authentication pattern
- **Apply**: Integrate into Integration Points section and inform ADR creation for API decisions

### Step 3: High-Level Architecture

Define:

1. **System Components**
   - Major modules/services
   - Their responsibilities
   - Boundaries and interfaces

2. **Data Architecture**
   - Data models (conceptual)
   - Storage approach
   - Data flow

3. **Integration Points**
   - External systems
   - APIs (internal and external)
   - Third-party services

4. **Technology Stack**
   - Languages and frameworks
   - Databases
   - Infrastructure

### Step 4: Create Architecture Decision Records (ADRs)

For each significant decision, create ADR in `specs/adrs/`:

Use **Display Template** from `council-planning.md` to show: ADR-XXX: [Decision Title]

### Step 4B: Generate Database Design Document

> **Governance check**: Read `.ultimate-sdlc/config.yaml → governance_mode`. If `lightweight`, SKIP this step. If `standard` or `enterprise`, this step is MANDATORY.

1. Read `templates/database-design-template.md` for required structure
2. Read the database technology ADR (created in Step 4) for technology selection
3. Read `specs/scope-lock.md` for feature inventory driving data requirements
4. Generate `specs/architecture/database-design.md`:
   - **Section 1 (Overview)**: Derive entity groups from feature scope
   - **Section 2 (Schema Design)**: Define tables for each data entity implied by features in scope-lock.md. For each table: columns, types, constraints, indexes, estimated row count, lifecycle.
   - **Section 3 (Relationships)**: Define all FK relationships with cardinality and cascade behavior
   - **Section 4 (Enums)**: Define all enumeration types
   - **Section 5 (Time-Series)**: If monitoring/metrics features exist, define partitioning and retention
   - **Section 6 (Caching)**: Define cache keys, TTLs, invalidation triggers based on access patterns
   - **Section 7 (Migration)**: Specify tooling per ADR, naming convention, rollback approach
   - **Section 8 (Security)**: RLS policies, roles, connection security, PII handling
   - Flag areas needing more feature detail with `[REQUIRES FEAT SPEC: ...]`
5. Cross-reference: Verify every feature in scope-lock.md has at least one table supporting its data needs
6. Update WORKING-MEMORY.md with Database Design status

### Step 5: Architecture Diagrams

Create diagrams for:
- System context (C4 Level 1)
- Container diagram (C4 Level 2)
- Data flow diagram
- Deployment architecture

### Step 6: Technical Risks

Document:
- Architecture risks
- Mitigation strategies
- Spike/POC needs

### Step 7: Phase Completion Criteria

Before completing this phase, verify:
- [ ] High-level architecture defined
- [ ] Technology stack selected with rationale
- [ ] ADRs created for major decisions
- [ ] Architecture diagrams created
- [ ] Technical risks documented
- [ ] Database Design Document created (or N/A if Lightweight mode)
- [ ] Every feature in scope-lock.md has supporting data model

### Step 8: Complete Phase

When all criteria met:

1. Update `.ultimate-sdlc/project-context.md`:
   - Set Phase 2 status: Complete

2. Update `.ultimate-sdlc/council-state/planning/WORKING-MEMORY.md`:
   - Mark completed tasks
   - Record session learnings

3. Record metrics in `.metrics/tasks/planning/`

4. Display completion message:

Use **Display Template** from `council-planning.md` to show: Phase 2: Architecture - Complete

---
