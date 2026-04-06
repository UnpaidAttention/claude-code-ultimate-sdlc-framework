---
name: sdlc-audit-feature
description: |
  Test and audit a specific feature
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/functional-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/accessibility-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/usability-audit/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# Audit Feature Workflow

> Trigger: `/audit-feature`

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4.5
> Apply RARV cycle, session protocol per `council-audit.md`

## Description

Systematically tests a specific feature from the inventory. Ensures comprehensive coverage with consistent methodology across all features.

## Why This Workflow Exists

Random or ad-hoc testing leads to gaps. This workflow ensures every feature receives consistent, thorough testing covering functional, GUI, and integration aspects.

## Pre-Conditions

- T1 (Inventory) should be complete
- Feature should be identified in the feature inventory
- Application should be accessible

## Steps

### Step 1: Select Feature

Ask user which feature to test, or show inventory:

Use **Display Template** from `council-audit.md` to show: Feature Inventory

### Step 2: Load Feature Context

Read about the selected feature:
- From `planning-handoff.md` (if available): Feature specification
- From feature inventory: Known screens, flows, dependencies
- From `defect-log.md`: Any existing defects for this feature

### Step 3: Enter Plan Mode

Switch to **Plan Mode** for systematic testing. Create a test plan:

Use **Display Template** from `council-audit.md` to show: Feature Test Plan: [Feature Name]

### Step 4: Execute Functional Tests (T2)

For each functional test case:

1. **Navigate** to feature
2. **Execute** test steps
3. **Observe** behavior
4. **Compare** to expected result
5. **Document** outcome

If defect found: Run `/audit-defect` immediately

Generate **Test Execution Artifact**:

Use **Display Template** from `council-audit.md` to show: Functional Test Results: [Feature Name]

### Step 5: Execute GUI Tests (T3)

Use browser integration:
- **Screenshot** each screen state
- **Record** complex interactions
- **Check** console for errors

Test checklist:
- [ ] Visual consistency with design
- [ ] All interactive elements respond
- [ ] Loading states display properly
- [ ] Error messages are clear
- [ ] Works at different viewport sizes
- [ ] Keyboard navigation works
- [ ] Focus indicators visible
- [ ] Color contrast adequate

Generate **Screenshot Artifacts** for evidence.

### Step 6: Execute Integration Tests (T4)

Test interactions with other features:
- Data passed correctly?
- State maintained across navigation?
- Side effects as expected?
- Rollback/undo works?

### Step 7: Generate Feature Test Report

Create a **Report Artifact**:

Use **Display Template** from `council-audit.md` to show: Feature Test Report: [Feature Name]

### Step 8: Update Tracking

Update `audit-context.md`:
- Mark feature tests as complete for each type (T2/T3/T4)
- Update defect counts if new defects found

Update `.ultimate-sdlc/progress.md`:
- Log feature test completion
- Note key findings

### Step 9: Announce Results

> "Feature '[Name]' testing complete. Results: [X] tests passed, [Y] defects found, [Z] enhancements identified. See Feature Test Report artifact."

## Artifacts Generated

- **Test Execution Artifact**: Detailed test results
- **Screenshot Artifacts**: Visual evidence
- **Browser Recording Artifact**: (if complex flows)
- **Report Artifact**: Feature test summary

## Testing Best Practices

1. **Test happy path first** - Verify basic functionality works
2. **Then test edges** - Boundaries, limits, invalid inputs
3. **Then test errors** - What happens when things go wrong
4. **Capture evidence** - Screenshots prove findings
5. **Log defects immediately** - Don't wait until end
6. **Note enhancements** - Capture ideas as you go
7. **Be systematic** - Follow the checklist, don't skip

## Agent Invocations

### Agent: sdlc-tdd-guide
Invoke via Agent tool with `subagent_type: "sdlc-tdd-guide"`:
- **Provide**: Feature name, test plan from Step 3, acceptance criteria from planning handoff
- **Request**: Design comprehensive test cases covering functional, edge, and error scenarios for this feature
- **Apply**: Integrate test designs into the Feature Test Plan before executing Steps 4-6

### Agent: sdlc-code-reviewer
Invoke via Agent tool with `subagent_type: "sdlc-code-reviewer"`:
- **Provide**: Feature test results from Steps 4-6, defect findings, code locations under test
- **Request**: Quality check the feature implementation for code smells, missed error handling, and untested paths
- **Apply**: Incorporate quality findings into the Feature Test Report in Step 7
