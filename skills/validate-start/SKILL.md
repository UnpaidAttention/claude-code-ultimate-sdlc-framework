---
name: sdlc-validate-start
description: |
  Initialize or resume Validation Council session. Guides through 5 tracks with gates at V5, C4, P4, E4, S2.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/intent-extraction/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/multi-lens-analysis/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/memory-system/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /validate-start - Begin Validation Council

## Arguments
| Argument | Required | Description |
|----------|----------|-------------|
| (none) | — | Session auto-detects state |

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Opus 4.5
> Apply RARV cycle, session protocol per council-validation.md


**Additional Lens**: `[Requirements]` — for intent analysis

---

## Purpose

Start or resume the Validation Council. This council validates software against intent and ensures release readiness through 5 tracks.

---

## Pre-Conditions

- `.ultimate-sdlc/project-context.md` must exist (run `/init` first if not)
- **Full / Feature / Improvement cycles**: Audit Council must be complete (Gates A2 and A3 passed), `handoffs/audit-handoff.md` must exist
- **Patch / Maintenance cycles**: Development Council must be complete (Gate I8 passed), `handoffs/development-handoff.md` must exist (Audit is skipped for these cycle types)

---

## Workflow

### Step 1: Load Framework Context

Read these files:
- `~/.claude/skills/ultimate-sdlc/context/framework-overview.md` - Understand the overall process
- `.reference/phase-guide.md` - Detailed track and phase information
- `.reference/skills-index.md` - Skills to load for each phase

### Step 2: Check Project State

Read `.ultimate-sdlc/project-context.md`:
- If `Active Council` is not "validation", check if transition is valid
- Identify current track and phase
- Read `Cycle Information` section → extract **Cycle Type** and **Cycle Intent**

**Pre-condition check by cycle type:**
- **Full / Feature / Improvement**: Verify Audit Council (Gates A2 and A3) is marked complete
- **Patch / Maintenance**: Verify Development Council (Gate I8) is marked complete (Audit was skipped)

### Step 2a: Cycle-Scoped Validation

**Read the Cycle Type from `.ultimate-sdlc/project-context.md`.**

| Cycle Type | Validation Scope | Handoff Source |
|------------|-----------------|----------------|
| **Full** | Full validation of entire application | `audit-handoff.md` |
| **Feature** | **Primary**: Validate new features against intent. **Secondary**: Regression validation on features that interact with new ones. | `audit-handoff.md` |
| **Patch** | **Primary**: Verify fixes resolve reported defects. **Secondary**: Regression validation — ensure fixes don't break existing functionality. | `development-handoff.md` (no audit handoff) |
| **Maintenance** | **Primary**: Verify all existing tests pass after updates. **Secondary**: Verify no behavioral changes. | `development-handoff.md` (no audit handoff) |
| **Improvement** | **Primary**: Verify behavioral contracts from planning are maintained. **Secondary**: Verify refactored code passes all existing tests. | `audit-handoff.md` |

**Add to `.ultimate-sdlc/council-state/validation/WORKING-MEMORY.md`**:
```
### Cycle Context
- Cycle Type: [type]
- Validation Scope: [FULL / NEW+REGRESSION / REGRESSION-ONLY / CONTRACT-VERIFY per table above]
- Cycle Intent: [from .ultimate-sdlc/project-context.md]
- Handoff Source: [audit-handoff.md / development-handoff.md]
```

**For Patch/Maintenance cycles**: The Validation Council may be abbreviated:
- V-track: Focus on verifying fixes/updates work correctly
- C-track: Fix any issues found during verification
- P-track: Verify no security or performance regressions
- E-track: May be skipped (no new features to enhance)
- S-track: Standard release readiness

### Step 3: Verify Handoff

**For Full / Feature / Improvement cycles:**
Check if `handoffs/audit-handoff.md` exists:
- **If exists**: Parse it for audit findings
- **If not exists**: Stop with error: "Audit handoff not found. Complete Audit Council first with `/audit-start`."

**For Patch / Maintenance cycles (Audit skipped):**
Check if `handoffs/development-handoff.md` exists:
- **If exists**: Parse it for implementation details (this replaces audit handoff since Audit was skipped)
- **If not exists**: Stop with error: "Development handoff not found. Complete Development Council first with `/dev-start`."

### Step 4: Determine Mode

**If Track is Validation/V1 and status is "not started":**
→ NEW SESSION - Go to Step 5

**If any track is in progress:**
→ RESUME SESSION - Go to Step 6

### Agent: requirements
Invoke via Agent tool with `subagent_type: "sdlc-requirements"`:
- **Provide**: `product-concept.md`, `specs/scope-lock.md`, `handoffs/audit-handoff.md` (or `development-handoff.md` for Patch/Maintenance cycles)
- **Request**: Extract documented intents — for each feature, identify the stated purpose, target users, success criteria, and expected behaviors
- **Apply**: Use extracted intents to populate `intent-map.md` during session setup

### Step 5: New Session Setup

1. Update `.ultimate-sdlc/project-context.md`:
   - Set `Active Council`: validation
   - Set `Current Track`: Validation
   - Set `Current Phase`: V1
   - Set `Status`: in_progress

2. Parse `handoffs/audit-handoff.md`:
   - Extract defect list
   - Extract quality scorecard
   - Extract enhancement proposals

3. Create `.ultimate-sdlc/council-state/validation/current-state.md`:
   - Initialize track statuses
   - Copy defects to correction queue
   - Initialize verification checklists

4. Create supporting documents:
   - `.ultimate-sdlc/council-state/validation/intent-map.md`
   - `.ultimate-sdlc/council-state/validation/completeness-matrix.md`
   - `.ultimate-sdlc/council-state/validation/correction-log.md`
   - `.ultimate-sdlc/council-state/validation/enhancement-proposals.md`

5. Load V1 Skills (from `.reference/skills-index.md`):
   - Read `~/.claude/skills/ultimate-sdlc/knowledge/intent-extraction/SKILL.md`
   - Read `~/.claude/skills/ultimate-sdlc/knowledge/multi-lens-analysis/SKILL.md`

6. Update `.ultimate-sdlc/progress.md` with new session entry

7. Display welcome:
Use **Display Template** from `council-validation.md` to show: Validation Council - V1: Intent Extraction

### Step 6: Resume Session

1. Read `.ultimate-sdlc/project-context.md` for current track and phase
2. Read `.ultimate-sdlc/progress.md` for last session notes
3. Read `.ultimate-sdlc/council-state/validation/current-state.md` for detailed state
4. Read track-specific documents based on current phase:
   - V-phases: `intent-map.md`
   - C-phases: `correction-log.md`
   - P-phases: `current-state.md`
   - E-phases: `enhancement-proposals.md`
   - S-phases: All documents
5. Load skills for current phase:
   - Look up phase in `.reference/skills-index.md`
   - Read each skill from `~/.claude/skills/ultimate-sdlc/knowledge/<skill-name>/SKILL.md`

6. Display status:
Use **Display Template** from `council-validation.md` to show: Validation Council - Resumed

---

## Track Navigation

### When V1 complete:
Run `/validate-v2` to continue to Gap Analysis

### Direct Phase Entry
**Validation Track:**
- V2: `/validate-v2` (Gap Analysis)
- V3: `/validate-v3` (Completeness Assessment)
- V4: `/validate-v4` (Prerequisite Verification)
- V5: `/validate-v5` (Correction Planning)
- Gate V5: `/validate-gate-v5` (Gate Verification)

**Correction Track:**
- C1: `/validate-c1` (Targeted Corrections)
- C2: `/validate-c2` (Edge Cases)
- C3: `/validate-c3` (Verification Testing)
- C4: `/validate-c4` (Regression Validation)
- Gate C4: `/validate-gate-c4` (Gate Verification)

**Production Track:**
- P1: `/validate-p1` (Operational Assessment)
- P2: `/validate-p2` (Failure Mode Analysis)
- P3: `/validate-p3` (Performance Optimization)
- P4: `/validate-p4` (Security Hardening)
- Gate P4: `/validate-gate-p4` (Gate Verification)

**Enhancement Track:**
- E1: `/validate-e1` (Feature Richness)
- E2: `/validate-e2` (Innovation Opportunities)
- E3: `/validate-e3` (Enhancement Implementation)
- E4: `/validate-e4` (UX Polish)
- Gate E4: `/validate-gate-e4` (Gate Verification)

**Synthesis Track:**
- S1: `/validate-s1` (Documentation Update)
- S2: `/validate-s2` (Release Readiness)
- Gate S2: `/validate-gate-s2` (FINAL Gate)

### To log correction:
Use `/validate-correction`

### To view status:
Use `/status`

---

## Track Quick Reference

### Validation Track (V1-V5)
| Phase | Name | Key Output | Gate |
|-------|------|------------|------|
| V1 | Intent Extraction | Intent map | - |
| V2 | Gap Analysis | Gap report | - |
| V3 | Completeness Assessment | Matrix | - |
| V4 | Prerequisite Verification | Verification log | - |
| V5 | Correction Planning | Correction plan | GATE |

### Correction Track (C1-C4)
| Phase | Name | Key Output | Gate |
|-------|------|------------|------|
| C1 | Targeted Corrections | Fixed issues | - |
| C2 | Edge Cases | Edge case fixes | - |
| C3 | Verification Testing | Test results | - |
| C4 | Regression Validation | Regression report | GATE |

### Production Track (P1-P4)
| Phase | Name | Key Output | Gate |
|-------|------|------------|------|
| P1 | Operational Assessment | Ops report | - |
| P2 | Failure Mode Analysis | FMEA document | - |
| P3 | Performance Optimization | Performance report | - |
| P4 | Security Hardening | Security report | GATE |

### Enhancement Track (E1-E4)
| Phase | Name | Key Output | Gate |
|-------|------|------------|------|
| E1 | Feature Richness | Feature proposals | - |
| E2 | Innovation Opportunities | Innovation list | - |
| E3 | Enhancement Implementation | Implementations | - |
| E4 | UX Polish | UX improvements | GATE |

### Synthesis Track (S1-S2)
| Phase | Name | Key Output | Gate |
|-------|------|------------|------|
| S1 | Documentation Update | Updated docs | - |
| S2 | Release Readiness | Release checklist | GATE |

---

## Gate Criteria

### Gate V5 (Correction Planning)
- [ ] All features have documented intents
- [ ] All gaps identified
- [ ] Completeness matrix filled
- [ ] Correction plan created

### Gate C4 (Regression Validation)
- [ ] All corrections implemented
- [ ] Edge cases handled
- [ ] Verification tests pass
- [ ] No regressions introduced

### Gate P4 (Security Hardening)
- [ ] Operations assessment complete
- [ ] Failure modes documented
- [ ] Performance optimized
- [ ] Security hardened

### Gate E4 (UX Polish)
- [ ] Feature richness evaluated
- [ ] Innovations considered
- [ ] Enhancements implemented
- [ ] UX polished

### Gate S2 (Release Readiness) - FINAL GATE
- [ ] All documentation updated
- [ ] Release checklist complete
- [ ] All previous gates passed
- [ ] Ready for release

---

## Verification Layer Runtime Verification

For each correction, verify through all 8 layers:

1. **UI Layer**: Visual rendering correct
2. **Event Layer**: User interactions work
3. **Frontend State**: State updates properly
4. **API Layer**: API calls succeed
5. **Backend Layer**: Business logic correct
6. **Service Layer**: External services work
7. **Persistence Layer**: Data saved correctly
8. **Restart Layer**: Survives application restart

---

## Before/After Protocol

For EVERY correction:
1. Take BEFORE screenshot
2. Implement fix
3. Take AFTER screenshot
4. Document in `correction-log.md`

---

## Handoff

When Gate S2 passes:
- Generate `handoffs/validation-handoff.md`
- Update `.ultimate-sdlc/project-context.md` to mark Validation complete
- Generate final release checklist
- **CYCLE COMPLETE** — Instruct user to run `/close-cycle` to archive this cycle, then `/new-cycle` for the next

---
