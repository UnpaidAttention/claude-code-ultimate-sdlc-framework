---
name: audit-defect
description: |
  Log a defect with proper documentation and evidence
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
AG_HOME="${HOME}/.antigravity"
AG_PROJECT=".antigravity"
AG_SKILLS="${HOME}/.claude/skills/antigravity"

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
- Read `~/.claude/skills/antigravity/knowledge/systematic-debugging/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/error-handling/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# Audit Defect Logging Workflow

> Trigger: `/audit-defect`

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per `council-audit.md`

## Description
Logs a new defect with proper documentation and evidence capture.

## Steps

1. **Capture Evidence**
   - Take Screenshot Artifact of the defect
   - If behavioral: Create Browser Recording Artifact
   - Note exact URL and application state

2. **Gather Defect Details**
   - Ask for defect title (brief description)
   - Ask for severity: Critical / High / Medium / Low
   - Identify affected feature from inventory
   - Document current phase

3. **Generate Defect ID**
   - Read current defect count from `audit-context.md`
   - Assign next ID: DEF-XXX
   - Increment counter

4. **Document Steps to Reproduce**
   - Record exact steps taken
   - Note any preconditions
   - Document expected vs actual behavior

5. **Log to Defect Log**
   - Append to `defect-log.md` using template:
   Use **Display Template** from `council-audit.md` to show: DEF-XXX: [Title]

6. **Update Context**
   - Increment defect count in `audit-context.md`
   - Update severity breakdown
   - Note in `.antigravity/progress.md`

## Artifacts Generated
- Screenshot Artifact: Visual evidence
- Browser Recording Artifact: (if behavioral issue)
- Defect Artifact: Formatted defect entry

## Severity Guidelines

| Severity | Criteria |
|----------|----------|
| Critical | Application crash, data loss, security vulnerability |
| High | Feature broken, major functionality impaired |
| Medium | Feature works but with issues, workaround exists |
| Low | Cosmetic, minor inconvenience, edge case |
