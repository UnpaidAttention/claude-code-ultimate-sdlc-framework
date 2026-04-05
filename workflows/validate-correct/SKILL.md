---
name: validate-correct
description: |
  Apply verified correction following verification-first protocol
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/correction-management/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/root-cause-analysis/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/tdd-methodology/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# Workflow: validate-correct

Apply a verified correction following the verification-first protocol.

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply session protocol per `council-validation.md`
---

## Trigger
`/validate-correct [issue-id]` or "Correct [issue]"

## Behavior

1. Identify the issue to correct
2. Analyze root cause (not symptoms)
3. Verify prerequisites exist
4. Plan minimal correction
5. Implement correction
6. Write verification test
7. Run verification test
8. Confirm fix works
9. Check for regressions
10. Update correction-log.md

## Verification-First Protocol

```
1. Document → 2. Root Cause → 3. Prerequisites → 4. Plan
                                                    ↓
8. Regression ← 7. Confirm ← 6. Test ← 5. Implement
       ↓
9. Log Result
```

## Output

Use **Display Template** from `council-validation.md` to show: Correction: [Issue ID][language]
[Original code]
```

**After**:
```[language]
[Fixed code]
```

**Change Summary**: [What changed and why]

---

### Verification Test

```[language]
[Test code that verifies the fix]
Use **Display Template** from `council-validation.md` to show: Verification Results

## Notes
- NEVER skip root cause analysis
- ALWAYS verify prerequisites first
- ALWAYS write and run verification test
- ALWAYS check for regressions
- Document everything in correction-log.md
