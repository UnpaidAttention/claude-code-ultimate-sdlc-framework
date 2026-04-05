---
name: sdlc-validate-production
description: |
  Production readiness assessment for component or system
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/production-readiness/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/operational-assessment/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/resilience-engineering/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/security-analysis/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# Workflow: validate-production

Production readiness assessment for specific component or entire system.

---

## Lens / Skills / Model
**Lens**: `[Operations]` | **Model**: Claude Sonnet 4
> Apply session protocol per `council-validation.md`
---

## Trigger
`/validate-production [component]` or "Check production readiness"

## Behavior

1. Assess operational concerns (logging, monitoring, alerting)
2. Analyze failure modes
3. Evaluate performance under load
4. Check security hardening
5. Generate production readiness report

## Output

Use **Display Template** from `council-validation.md` to show: Production Readiness Assessment: [Component/System]

## Notes
- Be thorough and honest
- Consider real-world scenarios
- Identify ALL gaps before production
- Clear go/no-go recommendation
