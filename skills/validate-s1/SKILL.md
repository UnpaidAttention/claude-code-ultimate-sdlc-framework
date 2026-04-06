---
name: sdlc-validate-s1
description: |
  Execute Synthesis Track S1 - Documentation Update. Update all documentation for release.
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
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/changelog-management/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/documentation-review/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


# /validate-s1 - Documentation Update

## Lens / Skills / Model
**Lens**: `[Documentation]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per council-validation.md

## Prerequisites

- Gate E4 must be passed

If prerequisites not met:
```
Gate E4 not passed. Run /validate-gate-e4 first.
```

---

## Workflow

### Step 1: Update Project State

Update `.ultimate-sdlc/project-context.md`:
- Set `Current Track`: Synthesis
- Set `Current Phase`: S1 - Documentation Update
- Set `Status`: in_progress

### Agent: documentation
Invoke via Agent tool with `subagent_type: "sdlc-documentation"`:
- **Provide**: All project documentation (README, API docs, code comments, setup guides, changelog), current codebase state, corrections and enhancements from C-track and E-track
- **Request**: Review all documentation for accuracy and completeness — identify outdated content, missing sections, broken links, stale screenshots, and code examples that no longer match implementation
- **Apply**: Use documentation review findings to guide documentation updates in Steps 3 and 4

### Step 2: Documentation Inventory

Review and update all documentation:

Use **Display Template** from `council-validation.md` to show: Documentation Inventory

### Step 3: Documentation Updates

For each document needing update:

1. **Review current content**
   - Is information accurate?
   - Are examples current?
   - Are screenshots current?

2. **Update content**
   - Update text for changes
   - Update code examples
   - Update screenshots
   - Update version references

3. **Verify links**
   - Internal links work
   - External links work
   - Code references valid

### Step 4: Changelog Update

Update CHANGELOG.md:

Use **Display Template** from `council-validation.md` to show: [Version] - [Date]

### Step 5: Phase Completion Criteria

- [ ] All user documentation updated
- [ ] All technical documentation updated
- [ ] Changelog updated
- [ ] All links verified

### Step 6: Complete Phase

```
## S1: Documentation Update - Complete

**Documents Updated**: [X]
**Changelog Entries**: [Y]
**Screenshots Updated**: [Z]

**Next Step**: Run `/validate-s2` to continue to Release Readiness
```

---
