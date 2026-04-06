---
name: sdlc-validate-feature
description: |
  Deep validation of feature through intent alignment and completeness
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
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/completeness-matrix/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/gap-analysis/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/purpose-alignment/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


# Workflow: validate-feature

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply session protocol per `council-validation.md`
---

Deep validation of a specific feature through intent alignment and completeness.

## Trigger
`/validate-feature [feature-name]` or "Validate [feature] feature"

## Behavior

1. Identify the feature to validate
2. Extract/review feature intent
3. Compare against implementation
4. Apply completeness matrix
5. Apply multi-lens analysis
6. Identify gaps and issues
7. Update intent-map.md and completeness-matrix.md

## Output

Use **Display Template** from `council-validation.md` to show: Feature Validation: [Feature Name]

## Notes
- Be thorough in intent extraction
- Score honestly against completeness dimensions
- Specific gap identification with file:line references
- Clear correction recommendations

## Agent Invocations

### Agent: sdlc-requirements
Invoke via Agent tool with `subagent_type: "sdlc-requirements"`:
- **Provide**: Feature name, planning handoff specification, product concept, acceptance criteria
- **Request**: Verify intent alignment between the original feature requirements and the current implementation
- **Apply**: Use intent alignment results in Steps 2-3 to identify drift and missing requirements

### Agent: sdlc-integration-tester
Invoke via Agent tool with `subagent_type: "sdlc-integration-tester"`:
- **Provide**: Feature name, completeness matrix dimensions, implementation file paths, test coverage data
- **Request**: Validate feature completeness across all dimensions including functional, integration, and edge case coverage
- **Apply**: Integrate validation results into the completeness scoring in Steps 4-6
