---
name: sdlc-validate-s2
description: |
  Execute Synthesis Track S2 - Release Readiness. Final release checklist and preparation.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/release-readiness/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/gate-verification/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/handoff-protocols/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/systematic-evaluation/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /validate-s2 - Release Readiness

## Lens / Skills / Model
**Lens**: `[Architecture]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per council-validation.md

## Prerequisites

- S1 (Documentation Update) must be complete

If prerequisites not met:
```
S1 not complete. Run /validate-s1 first.
```

---

## Workflow

### Step 1: Update Project State

Update `.ultimate-sdlc/project-context.md`:
- Set `Current Phase`: S2 - Release Readiness
- Set `Status`: in_progress

### Agent: gate-keeper
Invoke via Agent tool with `subagent_type: "sdlc-gate-keeper"`:
- **Provide**: All previous gate results (V5, C4, P4, E4), validation handoff draft, release checklist, full test suite results, documentation status
- **Request**: Conduct final S2 certification pre-check — verify all previous gates remain valid, confirm no regressions since last gate, and validate release readiness across all dimensions
- **Apply**: Use gate-keeper's pre-check to confirm release readiness before generating the final handoff

### Step 2: Release Checklist

Complete final release checklist:

Use **Display Template** from `council-validation.md` to show: Release Readiness Checklist

### Step 3: Generate Validation Handoff

Create `handoffs/validation-handoff.md`:

Use **Display Template** from `council-validation.md` to show: Validation Handoff

### Step 4: Final Review

Conduct final review:

1. **Regression Check**
   - Run full test suite
   - Verify no new issues

2. **Smoke Test**
   - Critical paths work
   - No obvious issues

3. **Sign-off Collection**
   - Technical lead approval
   - Product owner approval

### Step 5: Phase Completion Criteria

- [ ] Release checklist complete
- [ ] Validation handoff generated
- [ ] Final regression check passed
- [ ] All sign-offs obtained

### Step 6: Complete Phase

```
## S2: Release Readiness - Complete

**Release Status**: READY
**All Gates Passed**: ✅
**Handoff Generated**: validation-handoff.md

**Next Step**: Run `/validate-gate-s2` for FINAL certification
```

---
