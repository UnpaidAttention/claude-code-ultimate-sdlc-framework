---
name: sdlc-planning-phase-8
description: |
  Execute Planning Phase 8 - Launch Ready. Final planning review and handoff preparation for Development Council.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/handoff-protocols/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/completeness-matrix/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /planning-phase-8 - Launch Ready

## Lens / Skills / Model
**Lens**: `[Architecture]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per council-planning.md

## Prerequisites

- Phases 4-7 (Supporting Specs) must be complete

If prerequisites not met:
```
Phases 4-7 not complete. Run /planning-supporting-specs first.
```

---

## Workflow

### Step 1: Update Project State

Update `.ultimate-sdlc/project-context.md`:
- Set `Active Council`: planning
- Set `Current Phase`: 8 - Launch Ready
- Set `Status`: in_progress

### Agent: sdlc-gate-keeper
Invoke via Agent tool with `subagent_type: "sdlc-gate-keeper"`:
- **Provide**: All planning artifacts (scope-lock.md, FEAT specs, AIOU specs, ADRs, wave-summary, security specs, testing strategy, infrastructure plan, sprint plan, planning-handoff.md draft)
- **Request**: Perform pre-gate review of all Gate 8 criteria — verify all phases complete, all artifacts exist and are internally consistent, no critical open questions, full traceability from requirements through AIOUs. Identify any gaps before formal gate evaluation.
- **Apply**: Address any gaps identified before proceeding to formal Gate 8 verification

### Step 2: Final Review Checklist

Review all planning artifacts:

#### Requirements
- [ ] All requirements documented
- [ ] All requirements have acceptance criteria
- [ ] No orphan requirements

#### Architecture
- [ ] Architecture documented
- [ ] ADRs complete
- [ ] Technology decisions justified

#### Features & AIOUs
- [ ] All features have specs
- [ ] All AIOUs defined
- [ ] Wave assignments complete
- [ ] Dependencies mapped

#### Security
- [ ] Threat model complete
- [ ] Security requirements documented
- [ ] Compliance addressed

#### Testing
- [ ] Test strategy defined
- [ ] Coverage targets set
- [ ] Test frameworks selected

#### Infrastructure
- [ ] Deployment architecture defined
- [ ] CI/CD pipeline designed
- [ ] Monitoring planned

#### Sprint Planning
- [ ] Sprints organized
- [ ] Timeline created
- [ ] Estimates complete

### Step 3: Generate Planning Handoff

Create `handoffs/planning-handoff.md`:

Use **Display Template** from `council-planning.md` to show: Planning Handoff

### Step 4: Validate Handoff Completeness

Ensure all referenced files exist:
- specs/features/*.md
- specs/aious/*.md
- specs/adrs/*.md
- specs/wave-summary.md

### Step 5: Phase Completion Criteria

Before completing this phase, verify:
- [ ] Final review checklist complete
- [ ] planning-handoff.md generated
- [ ] All referenced artifacts exist
- [ ] No critical open questions

### Step 6: Complete Phase

When all criteria met:

1. Update `.ultimate-sdlc/project-context.md`:
   - Set Phase 8 status: Complete

2. Update `.ultimate-sdlc/council-state/planning/WORKING-MEMORY.md`:
   - Mark completed tasks
   - Record session learnings

3. Record metrics in `.metrics/tasks/planning/`

4. Display completion message:

```
## Phase 8: Launch Ready - Complete

**Artifacts Created**:
- handoffs/planning-handoff.md

**Next Step**: Run `/planning-gate-8` to verify gate criteria and transition to Development Council
```

---
