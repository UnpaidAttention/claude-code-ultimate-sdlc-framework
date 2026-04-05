---
name: planning-verify
description: |
  Validate planning deliverables with evidence
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/evidence-capture/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/traceability/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/systematic-evaluation/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# Planning Verify Workflow

---

## Lens / Skills / Model
**Lens**: `[Quality]` + `[Security]` | **Model**: Claude Opus 4.5
> Apply RARV cycle, session protocol per council-planning.md

## Description

Validates planning deliverables against external criteria using artifacts as proof. Uses browser subagent when applicable to verify diagrams and visual outputs. **This workflow provides external validation that the AI cannot fake.**

## Why This Workflow Exists

AI agents have a tendency to claim completion without proper verification. This workflow enforces external validation by:
1. Requiring artifacts as proof of completion
2. Using checklists that must be explicitly verified
3. Capturing evidence that can be reviewed by humans
4. Blocking progression when criteria are not met

## Pre-Conditions

- At least one deliverable should be complete
- `.ultimate-sdlc/project-context.md` must exist with current phase
- Deliverable files must be accessible

## Steps

### Step 1: Identify What to Verify

Read `.ultimate-sdlc/project-context.md` and `.ultimate-sdlc/progress.md` to determine:
- Current phase
- Deliverables claimed as complete
- Files that should exist

Use **Display Template** from `council-planning.md` to show: Verification Target

### Step 2: Gather Evidence

For EACH deliverable being verified:

1. **Check File Exists**
   - Read the deliverable file
   - If file doesn't exist: FAIL immediately

2. **Check Completeness**
   - Verify all required sections are present
   - Verify sections have actual content (not placeholders)
   - Check for TODO/FIXME markers that indicate incomplete work

3. **Check Quality**
   - Feature matrices have all 8 sections filled
   - ADRs have decision rationale documented
   - AIOUs have acceptance criteria
   - Dependencies are explicit, not "TBD"

### Step 3: Generate Evidence Artifacts

For each verified deliverable, generate:

**Documentation Artifact** (for text deliverables):
Use **Display Template** from `council-planning.md` to show: Verification Evidence: [Deliverable Name]

**Diagram Artifact** (for architecture/data model diagrams):
- Generate or capture the diagram
- Verify it matches the specification
- Check all components are labeled

### Step 4: Cross-Reference Validation

Verify consistency across deliverables:

1. **Feature → AIOU Traceability**
   - Every feature in Phase 3 output maps to AIOUs
   - No orphan AIOUs without parent feature

2. **ADR → Implementation Alignment**
   - Tech stack decisions in ADRs match specifications
   - No contradictions between documents

3. **Requirement → Feature Coverage**
   - All requirements from Phase 1 have features
   - No missing coverage

Generate **Traceability Artifact**:
Use **Display Template** from `council-planning.md` to show: Traceability Verification

### Step 5: Generate Verification Report

Create **Checklist Artifact** with overall results:

Use **Display Template** from `council-planning.md` to show: Planning Verification Report

### Step 6: Update State

**If VERIFIED:**
- Update `.ultimate-sdlc/progress.md` with verification timestamp
- Save to Knowledge Base: `{PROJECT}-PLANNING-VERIFY-{PHASE}-{DATE}`
- Announce: "Phase [X] deliverables VERIFIED ✅"

**If FAILED:**
- List specific failures
- Do NOT update phase status
- Announce: "Verification FAILED ❌ - [X] issues found"
- Provide remediation steps

## Artifacts Generated

- **Verification Evidence Artifact** - Per-deliverable proof
- **Traceability Artifact** - Cross-reference validation
- **Checklist Artifact** - Overall verification report

## Important

**This workflow exists because AI tends to claim completion without verification.**

- Do NOT skip checks
- Do NOT assume files exist without reading them
- Do NOT mark placeholders as complete
- Evidence artifacts are MANDATORY
- If you cannot generate evidence, verification FAILS

## Usage Examples

```
/planning-verify              # Verify current phase deliverables
/planning-verify phase=3      # Verify specific phase
/planning-verify all          # Verify all phases completed so far
```
