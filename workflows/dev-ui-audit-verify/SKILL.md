---
name: dev-ui-audit-verify
description: |
  "Phase 6 of UI Audit: Verify completeness — run full UI-V verification to confirm all gaps are closed. PASS requires 0 CRITICAL, 0 HIGH issues."
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/frontend-design/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/ui-ux-pro-max/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/component-patterns/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /dev-ui-audit-verify - Phase 6: Verify Completeness

## Lens / Skills / Model
**Lens**: `[UX]` + `[Quality]` | **Model**: Claude Opus 4
> Apply RARV cycle, session protocol per `council-development.md`

## Prerequisites

- Phase 5 complete: All items in `.ultimate-sdlc/council-state/development/ui-audit-plan.md` are `DONE` or `BLOCKED`
- `.ultimate-sdlc/council-state/development/ui-audit-report.md` exists (the gap analysis to verify against)
- `.ultimate-sdlc/council-state/development/ui-audit-target-state.md` exists (the target state to verify against)

If prerequisites not met:
```
Phase 6 requires gap implementation to be complete.
Run /dev-ui-audit-fix first to implement all gaps.
```

---

## Workflow

### Step 6.1: Route Existence Verification

For every route in the target route tree:
1. Confirm the route is registered in the router
2. Confirm the component exists and renders content
3. Mark: PASS or FAIL with details

### Step 6.2: Feature Interaction Flow Verification

For every interaction in the target feature interaction maps:
1. Trace the full flow: trigger element → handler → API call → response → UI update
2. Verify all 4 layers of Component Interaction Depth are implemented
3. Mark: PASS or FAIL with details

### Step 6.3: CRUD Completeness Verification

For every cell in the target CRUD matrix:
1. Verify the operation exists end-to-end (UI → API → data → UI update)
2. Mark: PASS or FAIL with details

### Step 6.4: State Completeness Verification

For every data-displaying component:
1. Verify loading state exists
2. Verify error state exists
3. Verify empty state exists
4. Mark: PASS or FAIL with details

### Step 6.5: Issue Classification

Classify any failures:
- **CRITICAL**: Route missing entirely, core CRUD operation missing
- **HIGH**: Interaction unwired, missing error/loading state on primary flow
- **MEDIUM**: Missing empty state, non-primary interaction incomplete
- **LOW**: Minor polish items, edge case states

### Step 6.6: Remediation (if needed)

If CRITICAL or HIGH issues found:
1. Fix each issue immediately
2. Re-verify the specific item
3. Repeat until 0 CRITICAL, 0 HIGH remain

---

## Output Artifact

Save to `.ultimate-sdlc/council-state/development/ui-audit-verification.md`:

```markdown
# UI Audit Verification Report

## Route Verification
| Route | Status | Notes |
|-------|--------|-------|
| /path | PASS/FAIL | [details if FAIL] |

## Interaction Verification
| Feature | Interaction | Layer 1 | Layer 2 | Layer 3 | Layer 4 | Status |
|---------|------------|---------|---------|---------|---------|--------|
| [Feature] | [Action] | PASS/FAIL | PASS/FAIL | PASS/FAIL | PASS/FAIL | PASS/FAIL |

## CRUD Verification
| Entity | Create | Read List | Read Detail | Update | Delete | Search | Filter | Sort |
|--------|--------|-----------|-------------|--------|--------|--------|--------|------|
| [Entity] | PASS/FAIL | PASS/FAIL | ... | ... | ... | ... | ... | ... |

## State Completeness
| Component | Loading | Error | Empty | Status |
|-----------|---------|-------|-------|--------|
| [Component] | PASS/FAIL | PASS/FAIL | PASS/FAIL | PASS/FAIL |

## Issue Summary
| Severity | Count | Details |
|----------|-------|---------|
| CRITICAL | [N] | [list] |
| HIGH | [N] | [list] |
| MEDIUM | [N] | [list] |
| LOW | [N] | [list] |

## Verdict
**PASS** / **FAIL** — [0 CRITICAL, 0 HIGH required for PASS]
```

---

## PASS Criteria

- **0 CRITICAL issues**
- **0 HIGH issues**
- All target routes exist and render content
- All target interactions are fully wired through 4 layers
- All CRUD operations complete for all entities

---

## Completion Condition

- Full verification has been run against all target state items
- All CRITICAL and HIGH issues have been remediated
- Verification report is saved
- `.ultimate-sdlc/council-state/development/ui-audit-verification.md` exists with PASS verdict

---

## Next Step

```
## UI Audit Complete

**Gaps Found**: [N] routes, [N] unwired components, [N] incomplete pages
**Gaps Fixed**: [N]/[N]
**Existing Code Preserved**: All original components untouched
**New Code Added**: [N] files created, [N] files modified
**Verification**: PASS — 0 CRITICAL, 0 HIGH

Next step: Run /dev-ui-polish to audit design quality and remove AI slop.
```

---
