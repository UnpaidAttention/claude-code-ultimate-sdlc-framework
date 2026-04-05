---
name: audit-reset-feature
description: |
  Reset and re-test a specific feature from scratch
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/defect-logging/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/test-case-design/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# Reset Feature Test

Reset and re-test a specific feature from scratch.

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per `council-audit.md`

## When to Use
- Feature was tested but results are questionable
- Software was updated and feature needs re-verification
- Previous test was interrupted or incomplete
- Defects were fixed and feature needs re-test

## Trigger
```
/audit-reset-feature [feature-name]
```

## Steps

1. **Identify Feature**
   - If feature name provided: locate in inventory
   - If not provided: list features and ask user to select
   - Verify feature exists in T1 inventory

2. **Review Previous Test State**
   - Check `.ultimate-sdlc/progress.md` for previous test results
   - Check `defect-log.md` for related defects
   - Note: DEF-XXX IDs associated with this feature

3. **Archive Previous Results**
   Use **Display Template** from `council-audit.md` to show: Previous Test Results (Archived)
   - Append to `.ultimate-sdlc/progress.md` under "Archived Tests" section

4. **Update Defect Status**
   For each related defect in `defect-log.md`:
   - If defect was fixed: Mark as "RETEST PENDING"
   - If defect still open: Keep status, note re-test scheduled
   - Add note: "Feature reset for re-test on [date]"

5. **Reset Feature in Tracking**
   Update `audit-context.md`:
   - Move feature from "tested" to "pending" list
   - Update coverage percentage
   - Note reset timestamp

6. **Prepare for Re-Test**
   - Load appropriate skills for feature type:
     - UI feature → gui-analysis skills
     - API feature → integration-testing skills
     - Core logic → functional-testing skills
   - Navigate to feature in application
   - Take fresh screenshot of initial state

7. **Execute Fresh Test**
   - Follow standard T2 functional testing protocol
   - Test all acceptance criteria from planning-handoff.md (if available)
   - Document results in `.ultimate-sdlc/progress.md`
   - Log any new defects with fresh DEF-XXX IDs

8. **Compare Results**
   After re-test complete:
   Use **Display Template** from `council-audit.md` to show: Re-Test Comparison

9. **Update Tracking**
   - Update `audit-context.md` with new test results
   - Update `defect-log.md` with any new defects
   - Close resolved defects if re-test passes
   - Update `.ultimate-sdlc/progress.md` with completion

## Output Format

Use **Display Template** from `council-audit.md` to show: Feature Re-Test Complete

## Notes

- Re-testing does NOT delete previous defects - they remain in log with status updates
- New defects get new IDs, even if similar to previous defects
- Always archive previous results before resetting
- Use this workflow when in doubt about test validity
