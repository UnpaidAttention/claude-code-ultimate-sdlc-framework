---
name: sdlc-validate-lens
description: |
  Apply multi-lens analysis to a feature or system
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
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/multi-lens-analysis/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/user-analysis/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/security-analysis/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/performance-analysis/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


# Workflow: validate-lens

---

## Lens / Skills / Model
**Lens**: `[Requirements]` | **Model**: Claude Sonnet 4
> Apply session protocol per `council-validation.md`
---

Apply multi-lens analysis to a feature or system.

## Trigger
`/validate-lens [feature] [lens]` or "Analyze [feature] from [lens] perspective"

Available lenses: user, operations, security, performance, business, all

## Behavior

1. Identify target feature/component
2. Apply specified lens (or all lenses)
3. Evaluate from that perspective
4. Identify gaps and opportunities
5. Provide recommendations

## The Five Lenses

| Lens | Emoji | Focus | Key Questions |
|------|-------|-------|---------------|
| User | 👤 | End-user experience | Intuitive? Accessible? Delightful? |
| Operations | ⚙️ | Production concerns | Monitorable? Recoverable? Maintainable? |
| Security | 🔒 | Attack surface | Authenticated? Validated? Protected? |
| Performance | ⚡ | Speed & scale | Fast? Scalable? Efficient? |
| Business | 💼 | Value delivery | Goal-aligned? Valuable? ROI-positive? |

## Output

Use **Display Template** from `council-validation.md` to show: Multi-Lens Analysis: [Feature Name]

## Notes
- Each lens reveals different issues
- Don't skip any lens for "all"
- Be specific about gaps
- Actionable recommendations

## Agent Invocations

### Agent: sdlc-architecture
Invoke via Agent tool with `subagent_type: "sdlc-architecture"`:
- **Provide**: Feature/component under analysis, codebase structure, deployment architecture
- **Request**: Evaluate from Operations and Performance lens perspectives — monitorability, scalability, failure modes, and architectural fitness
- **Apply**: Integrate architecture findings into the Operations and Performance lens sections

### Agent: sdlc-security
Invoke via Agent tool with `subagent_type: "sdlc-security"`:
- **Provide**: Feature/component under analysis, authentication flows, data handling paths, API surface
- **Request**: Evaluate from Security lens — attack surface, authentication gaps, input validation, data protection
- **Apply**: Integrate security findings into the Security lens section

### Agent: sdlc-quality
Invoke via Agent tool with `subagent_type: "sdlc-quality"`:
- **Provide**: Feature/component under analysis, test coverage data, code quality metrics
- **Request**: Evaluate from User and Business lens — usability gaps, accessibility issues, business value alignment
- **Apply**: Integrate quality findings into the User and Business lens sections
