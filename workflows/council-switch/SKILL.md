---
name: council-switch
description: |
  Switch between councils (Planning, Development, Audit, Validation) with state preservation.
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
- Read `~/.claude/skills/antigravity/knowledge/memory-system/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/orchestration-patterns/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/handoff-protocols/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# /council-switch - Change Active Council

---

## Lens / Skills / Model
**Lens**: `[Architecture]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per the active council rules file

## Arguments
| Argument | Required | Description |
|----------|----------|-------------|
| (none) | — | Session auto-detects state |

---

## CRITICAL RULES

1. **Verify gate completion** before switching
2. **Save current state** before transition
3. **Load new council state** after switch
4. **Update .antigravity/config.yaml** with new active council

---

## Task

Switch to a different council:

### 1. Pre-Switch Verification

```
IF switching FROM Planning:
  - Verify Gate 8 (Launch Ready) complete
  - Ensure planning-handoff.md exists

IF switching FROM Development:
  - Verify Gate I8 (Integration) complete
  - Ensure all AIOs marked complete

IF switching FROM Audit:
  - Ensure audit-handoff.md complete
  - Ensure defect-log.md complete

IF switching FROM Validation:
  - Only if returning to earlier council for fixes
```

### 2. State Preservation

- Save current progress to `.antigravity/council-state/{current}/current-state.md`
- Update `.antigravity/progress.md` with session summary

### 3. Council Activation

- Update `.antigravity/config.yaml` active_council field
- Load `.antigravity/council-state/{new}/current-state.md`
- Display new council status

---

## Arguments

| Argument | Description |
|----------|-------------|
| planning | Switch to Planning Council |
| development | Switch to Development Council |
| audit | Switch to Audit Council |
| validation | Switch to Validation Council |

---

## Usage

```
/council-switch development
/council-switch audit
/council-switch validation
```
