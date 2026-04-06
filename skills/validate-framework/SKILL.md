---
name: sdlc-validate-framework
description: |
  Validate framework integrity by checking file existence, reference consistency, and structural validity.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/systematic-evaluation/SKILL.md`


# /validate-framework - Framework Self-Validation

## Arguments
| Argument | Required | Description |
|----------|----------|-------------|
| (none) | — | Session auto-detects state |

---

## Purpose

Check the integrity of the Ultimate SDLC Framework to catch structural problems, missing files, broken references, and configuration errors.

**Run this workflow when:**
- After making changes to framework files
- When experiencing unexpected errors
- Before starting a new project
- Periodically as a health check

---

## Workflow

### Step 1: Validate Directory Structure

Check that all required directories exist:

```
□ ~/.claude/skills/ultimate-sdlc/rules/
□ ~/.claude/skills/ultimate-sdlc/agents/
□ ~/.claude/skills/ultimate-sdlc/knowledge/
□ ~/.claude/skills/ultimate-sdlc/workflows/
□ ~/.claude/skills/ultimate-sdlc/context/
□ handoffs/
```

**If any missing**: Log error `ERR-INIT-002` and STOP.

---

### Step 2: Validate Core Rule Files

Check these files exist and are non-empty:

| File | Required |
|------|----------|
| `~/.claude/skills/ultimate-sdlc/rules/UNIVERSAL-RULES.md` | ✓ |
| `~/.claude/skills/ultimate-sdlc/rules/CONSTITUTION.md` | ✓ |
| `~/.claude/skills/ultimate-sdlc/rules/conflict-resolution.md` | ✓ |
| `~/.claude/skills/ultimate-sdlc/rules/council-planning.md` | ✓ |
| `~/.claude/skills/ultimate-sdlc/rules/council-development.md` | ✓ |
| `~/.claude/skills/ultimate-sdlc/rules/council-audit.md` | ✓ |
| `~/.claude/skills/ultimate-sdlc/rules/council-validation.md` | ✓ |

**If any missing**: Report which files are missing.

---

### Step 3: Validate Context Files

Check these files exist:

| File | Required |
|------|----------|
| `~/.claude/skills/ultimate-sdlc/context/framework-overview.md` | ✓ |
| `.reference/phase-guide.md` | ✓ |
| `.reference/skills-index.md` | ✓ |
| `~/.claude/skills/ultimate-sdlc/context/state-management.md` | ✓ |
| `.reference/model-selection-guide.md` | ✓ |
| `.reference/skill-loading-guide.md` | ✓ |
| `~/.claude/skills/ultimate-sdlc/context/error-catalog.md` | ✓ |
| `.reference/skill-dependencies.md` | ✓ |

---

### Step 4: Validate Handoff Templates

Check these templates exist:

| File | Required |
|------|----------|
| `handoffs/planning-handoff-template.md` | ✓ |
| `handoffs/development-handoff-template.md` | ✓ |
| `handoffs/audit-handoff-template.md` | ✓ |
| `handoffs/validation-handoff-template.md` | ✓ |

---

### Step 5: Validate Core Workflows

Check these critical workflows exist:

| Workflow | Purpose |
|----------|---------|
| `init.md` | Project initialization |
| `status.md` | Status display |
| `recover.md` | State recovery |
| `planning-start.md` | Planning council entry |
| `dev-start.md` | Development council entry |
| `audit-start.md` | Audit council entry |
| `validate-start.md` | Validation council entry |

---

### Step 6: Validate Reference Consistency

Check for broken references:

1. **Agent references in workflows**: For each workflow with `agents:` section, verify the agent file exists in `~/.claude/skills/ultimate-sdlc/agents/`

2. **Skill references**: For common skills referenced, verify they exist in `~/.claude/skills/ultimate-sdlc/knowledge/`

3. **File path references**: Scan for `.md` file references and verify they resolve

---

### Step 7: Validate Skill Loading Limits

Check that no workflow specifies more than 7 skills in `skills_required`.

---

### Step 8: Generate Report

Create validation report:

Use **Display Template** from `council-validation.md` to show: Framework Validation Report

---

## Error Handling

If validation fails critically:
1. Display the report
2. Recommend running `/recover` or manual fixes
3. Do NOT proceed with normal framework operations until fixed

---

## Usage

```
/validate-framework
```

No arguments required. Run anytime to verify framework health.

## Agent Invocations

### Agent: sdlc-gate-keeper
Invoke via Agent tool with `subagent_type: "sdlc-gate-keeper"`:
- **Provide**: Validation report from Step 8, directory structure results, reference consistency findings
- **Request**: Verify framework structural integrity against all framework gate criteria and flag blocking issues
- **Apply**: Use gate verification to determine whether framework is operational or requires /recover
