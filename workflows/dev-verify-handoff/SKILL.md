---
name: dev-verify-handoff
description: |
  Validate planning handoff document before development
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/handoff-protocols/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/completeness-matrix/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/traceability-analysis/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# Verify Planning Handoff

// turbo-all

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocols per `~/.claude/skills/ultimate-sdlc/rules/council-development.md`

## Trigger
Run this workflow BEFORE starting any development work to ensure handoff quality.

## Steps

1. **Locate Handoff**
   - Find `planning-handoff.md` in project root
   - If missing: STOP and inform user Planning Council must complete first

2. **Validate Structure**
   Check for required sections:
   - [ ] Project Overview (name, description, stakeholders)
   - [ ] Architecture Summary (tech stack, key decisions)
   - [ ] Comprehensive Feature Specification (Phase 2.5 output)
   - [ ] AIOU Wave Summary (wave assignments)
   - [ ] AIOU Specifications (individual AIOU details)
   - [ ] Security Requirements
   - [ ] Infrastructure Requirements

3. **Validate Feature Specification**
   Check Comprehensive Feature Specification section:
   - [ ] Discovery Summary present (agent perspectives documented)
   - [ ] Feature Inventory by Category present
   - [ ] Feature Summary (all features in scope-lock.md represented)
   - [ ] Feature-to-AIOU Traceability table present
   - [ ] All features in scope-lock.md have detailed specifications
   - [ ] Feature dependencies mapped

4. **Validate AIOUs**
   For each AIOU in the handoff:
   - [ ] Has unique ID (AIOU-XXX format)
   - [ ] Has description
   - [ ] Has wave assignment (0-6)
   - [ ] Has size estimate (XS/S/M/L)
   - [ ] Has acceptance criteria (at least one)
   - [ ] Has dependencies listed (or "None")
   - [ ] Has parent feature reference (F-XXX)

5. **Validate Wave Integrity**
   - [ ] Wave 0 AIOUs have no dependencies on other AIOUs
   - [ ] Each wave's dependencies only reference earlier waves
   - [ ] No circular dependencies detected

6. **Validate Traceability**
   - [ ] Every AIOU maps to a feature in the Feature Specification
   - [ ] Every feature in scope-lock.md has at least one AIOU
   - [ ] Feature-to-AIOU coverage is complete

7. **Generate Verification Report**
   Create artifact with:
   - Total AIOU count
   - AIOUs per wave breakdown
   - Missing fields (if any)
   - Dependency validation results
   - PASS/FAIL verdict

## Outcomes

**PASS**: All validations successful
- Update `.ultimate-sdlc/project-context.md` with handoff verification timestamp
- Proceed to `/dev-start`

**FAIL**: Validation errors found
- List all issues in verification report
- DO NOT proceed with development
- Inform user: "Planning handoff incomplete. Issues must be resolved before development."

## Output Format

Use **Display Template** from `council-development.md` to show: Handoff Verification Report
