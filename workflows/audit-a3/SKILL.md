---
name: sdlc-audit-a3
description: |
  Execute Audit Track A3 - Quality Assessment. Code quality, maintainability, and best practices evaluation.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/systematic-evaluation/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/code-review-checklist/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/clean-code/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /audit-a3 - Quality Assessment

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Opus 4
> Apply RARV cycle, session protocol per `council-audit.md`

## Prerequisites

- Gate A2 must be passed

If prerequisites not met:
```
Gate A2 not passed. Run /audit-gate-a2 first.
```

---

## Workflow

### Step 1: Update Project State

Update `.ultimate-sdlc/project-context.md`:
- Set `Current Phase`: A3 - Quality Assessment
- Set `Status`: in_progress

### Step 2: Quality Dimensions

#### Code Quality
- [ ] Consistent coding style
- [ ] Meaningful naming
- [ ] Appropriate comments
- [ ] No dead code
- [ ] DRY principles followed

#### Architecture Quality
- [ ] Separation of concerns
- [ ] Proper layering
- [ ] Dependency management
- [ ] Scalability considerations

#### Test Quality
- [ ] Adequate coverage
- [ ] Meaningful test cases
- [ ] No flaky tests
- [ ] Test maintainability

#### Documentation Quality
- [ ] API documentation
- [ ] Code comments
- [ ] README complete
- [ ] Setup instructions

### Step 3: Quality Scorecard

| Dimension | Score (1-10) | Notes |
|-----------|--------------|-------|
| Code Quality | [X] | [Notes] |
| Architecture | [X] | [Notes] |
| Testing | [X] | [Notes] |
| Documentation | [X] | [Notes] |
| Security | [X] | [Notes] |
| Performance | [X] | [Notes] |
| **Overall** | **[Avg]** | |

#### Security Scoring Rubric

| Score | Criteria |
|-------|---------|
| 9-10 | All OWASP Top 10 categories reviewed and mitigated. 0 high/critical findings. Security tests exist for all input points. |
| 7-8 | OWASP Top 10 reviewed. 0 critical, <=2 high findings with documented mitigations. Security tests exist for critical paths. |
| 5-6 | Automated scans clean but manual review incomplete. Some security tests missing. |
| 3-4 | Known high-severity findings unresolved. Missing security tests. |
| 1-2 | Critical vulnerabilities present. No security testing. |

**BLOCKING**: Security score < 7 -> Gate A3 FAIL. Resolve findings before proceeding.

### Step 4: Recommendations

Document improvement recommendations:
- Priority 1 (Must fix before release)
- Priority 2 (Should fix soon)
- Priority 3 (Nice to have)

### Step 5: Phase Completion Criteria

- [ ] Quality scorecard complete
- [ ] All critical defects logged
- [ ] Recommendations documented

### Step 6: Complete Phase

```
## A3: Quality Assessment - Complete

**Quality Score**: [X]/10
**Critical Issues**: [Y]
**Recommendations**: [Z]

**Next Step**: Run `/audit-gate-a3` to verify Gate A3 criteria
```

---
