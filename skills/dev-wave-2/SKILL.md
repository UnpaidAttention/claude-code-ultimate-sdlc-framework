---
name: sdlc-dev-wave-2
description: |
  Execute Development Wave 2 - Data Layer. Implement database models, repositories, and migrations.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/database-design/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/clean-code/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/test-patterns/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/data-access/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /dev-wave-2 - Data Layer

## Lens / Skills / Model
**Lens**: `[Architecture]` + `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol, code review protocol per `council-development.md`

---

## Prerequisites

- Wave 1 (Utilities & Helpers) must be complete

If prerequisites not met:
```
Wave 1 not complete. Run /dev-wave-1 first.
```

---

## Workflow

### Step 1: Update Project State

Update `.ultimate-sdlc/project-context.md`:
- Set `Active Council`: development
- Set `Current Wave`: 2 - Data Layer
- Set `Status`: in_progress

### Step 2: Review Wave 2 AIOUs

**SCOPE**: In multi-run mode, process only current run's AIOUs.

Read from `specs/wave-summary.md` and `specs/aious/`:
- List all Wave 2 AIOUs (filtered by run if multi-run)
- Review data architecture from ADRs
- Understand data relationships

**Feature Context Loading** (per council-development.md § Feature Context Loading Protocol):
For each AIOU in this wave, read the parent FEAT spec and deep-dive.
Record feature context in WORKING-MEMORY.md before beginning implementation.

### Step 3a: Design and Create Schema

**Lens**: `[Architecture]` (primary focus on data modeling)

### Agent: sdlc-database-specialist
Invoke via Agent tool with `subagent_type: "sdlc-database-specialist"`:
- **Provide**: Wave 2 AIOU specs, data architecture ADRs, entity relationships from feature specs
- **Request**: Design database schema including entities, relationships, indexes, constraints, and migration strategy
- **Apply**: Use the specialist's schema design as the blueprint for implementation below

**Task**:
Define the database schema, models, and migrations.

1.  **Define database schema/models** for the Wave 2 AIOUs, including entities, relationships, indexes, and constraints.
2.  **Create the necessary migration files** to apply the schema.
3.  **Generate seed data scripts** if required for development.
4.  **Document the data models** and their relationships.

### Step 3b: Implement Repository Layer

**Lens**: `[Architecture]` + `[Quality]` (data access patterns + test coverage)

**Task**:
Implement the repository layer that interacts with the database.

1.  **Implement the repository/data access layer** for the models defined in Step 3a.
2.  **Implement CRUD (Create, Read, Update, Delete) operations.**
3.  **Add any custom queries** required by the AIOUs.
4.  **Implement data validation** and transaction handling where necessary.
5.  **Write unit tests** for the repository layer.

   ### Agent: sdlc-tdd-guide
   Invoke via Agent tool with `subagent_type: "sdlc-tdd-guide"`:
   - **Provide**: Repository interfaces, AIOU acceptance criteria, data model schema
   - **Request**: Generate test cases for all CRUD operations, custom queries, validation rules, and transaction handling
   - **Apply**: Write tests first (RED), implement repository to pass (GREEN), then refactor

   ### Agent: sdlc-code-reviewer
   Invoke via Agent tool with `subagent_type: "sdlc-code-reviewer"`:
   - **Provide**: Implemented repository code, schema, migration files, and test results
   - **Request**: Review for N+1 query issues, missing indexes, validation gaps, and transaction safety
   - **Apply**: Fix all CRITICAL and HIGH issues before marking AIOU complete

### Step 4: Quality Standards

Each data component must:
- [ ] Follow naming conventions
- [ ] Have proper indexes for queries
- [ ] Include validation rules
- [ ] Have repository tests
- [ ] Handle errors gracefully
- [ ] Support transactions where needed

### Step 5: Wave Completion Criteria

**SCOPE**: In multi-run mode, verify only current run's AIOUs.

Before completing this wave, verify:
- [ ] All Wave 2 AIOUs **in current run** implemented.
- [ ] Database migrations work (up and down).
- [ ] All repository tests passing.
- [ ] No N+1 query issues.
- [ ] Code reviewed (parallel-code-review).
- [ ] Committed with proper messages.
- [ ] **If multi-run**: Run tracker Wave 2 column updated for all AIOUs

### Step 6: Complete Wave

When all criteria met:

1. Update `.ultimate-sdlc/project-context.md`:
   - Set Wave 2 status: Complete

2. Update `.ultimate-sdlc/council-state/development/WORKING-MEMORY.md`:
   - Mark completed AIOUs
   - Record session learnings

3. Record metrics in `.metrics/tasks/development/`

4. Create git checkpoint:
   ```bash
   git tag wave-2-complete
   ```

5. Display completion message:

```
## Wave 2: Data Layer - Complete

**AIOUs Completed**: [X]
**Models Created**: [Y]
**Migrations**: [Z]
**Tests**: [N] passing

**Wave completion security check**: Run `npm audit --audit-level=high` (or stack equivalent). If high/critical findings: fix before proceeding. Run `gitleaks detect --no-git` on files modified in this wave.

**Next Step**: Run `/dev-wave-3` to continue to Services
```

---

## Code Review Integration

After completing each AIOU, apply parallel 3-reviewer code review:
- Dispatch 3 reviewers (Security, Quality, Logic focus)
- If unanimous approval, run Devil's Advocate review
- Fix all Critical and High issues before marking complete

---
