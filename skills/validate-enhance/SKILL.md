---
name: sdlc-validate-enhance
description: |
  Propose and implement a feature enhancement
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
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/enhancement-planning/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/competitive-analysis/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/implementation-patterns/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


# Workflow: validate-enhance

---

## Lens / Skills / Model
**Lens**: `[UX]` | **Model**: Claude Sonnet 4
> Apply session protocol per `council-validation.md`
---

Propose and implement a feature enhancement.

## Trigger
`/validate-enhance [feature-name]` or "Enhance [feature]"

## Behavior

1. Analyze current feature implementation
2. Compare to best-in-class implementations
3. Identify enhancement opportunities
4. Evaluate ROI and alignment with software goals
5. Propose prioritized enhancements
6. Implement approved enhancement
7. Verify enhancement works
8. Update enhancement-proposals.md

## Output

Use **Display Template** from `council-validation.md` to show: Enhancement Analysis: [Feature Name]

Include the new/modified code in a fenced code block with the appropriate language tag.

Use **Display Template** from `council-validation.md` to show: Verification Results

## Notes
- Focus on goal alignment
- Consider ROI
- Enhance deliberately, not randomly
- Verify enhancement before logging

## Agent Invocations

### Agent: sdlc-code-reviewer
Invoke via Agent tool with `subagent_type: "sdlc-code-reviewer"`:
- **Provide**: Enhancement proposal, implementation code, verification results, affected files
- **Request**: Review the enhancement for code quality, alignment with existing patterns, and potential regressions
- **Apply**: Address review findings before updating enhancement-proposals.md in Step 8
