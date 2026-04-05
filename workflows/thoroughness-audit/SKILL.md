---
name: thoroughness-audit
description: |
  Audit features against 8 thoroughness criteria (deep-dive, connectivity, component inventory, run sizing, PRH compliance). Non-destructive — reads and reports only. Generates gap report with TG-XXX IDs.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/thoroughness-audit/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/gap-analysis/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/feature-deep-dive/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/completeness-matrix/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/systematic-evaluation/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /thoroughness-audit - Thoroughness Audit

## Arguments

| Argument | Format | Default | Description |
|----------|--------|---------|-------------|
| `--features` | FEAT-001,FEAT-002 | all | Audit a subset of features |
| `--severity-threshold` | Critical / Major / Minor | Minor | Only report gaps at or above this severity |
| `--dry-run` | flag | off | Show what would be audited without generating a report |

## Lens / Skills / Model
**Lens**: `[Quality]` + `[Architecture]` | **Model**: Claude Opus 4
> Apply RARV cycle per workflow-conventions.md

## What This Workflow Does NOT Do

- Modify any spec files
- Create DIVE files
- Modify any code
- Change Active Council
- Create or modify AIOUs

This is a **read-only audit**. All artifact creation is deferred to `/thoroughness-remediate`.

## Prerequisites

- Project must have `specs/scope-lock.md` (feature list)
- At least one FEAT spec must exist in `specs/features/`
- `.ultimate-sdlc/project-context.md` must exist

If prerequisites not met:
```
Missing required files. Ensure scope-lock.md and at least one FEAT spec exist.
Run /planning-start if this is a new project.
```

---

## Workflow

### Step 1: Load Project Context

Read and internalize:
- `.ultimate-sdlc/project-context.md` — project type, active council, current phase
- `specs/scope-lock.md` — canonical feature list with IDs
- `.ultimate-sdlc/council-state/development/run-tracker.md` — run divisions and AIOU assignments (if exists)
- `.ultimate-sdlc/council-state/planning/planning-handoff.md` — planning→development handoff (if exists)
- `.ultimate-sdlc/config.yaml` — thoroughness settings (`thoroughness.audit_batch_size`)

**Extract from scope-lock.md:**
- Total feature count
- Feature IDs and names
- Complexity column (if present)

**Apply `--features` filter**: If provided, reduce the audit set to only the specified features. Verify each specified feature exists in scope-lock.md.

### Step 2: Determine Batch Plan

Read `.ultimate-sdlc/config.yaml` → `thoroughness.audit_batch_size` (default: 5).

- If audit set ≤ batch size: **single pass** — audit all features without stopping
- If audit set > batch size: **batched** — divide into batches of 3-5 features, grouped by related functionality where possible

Display:
```
Thoroughness Audit — [PROJECT_NAME]
Features to audit: [N]
Mode: [Single pass / Batched — N batches of ~M features]
Severity threshold: [threshold]
```

If `--dry-run`: display the batch plan and feature list, then STOP.

### Step 3: Classify Feature Implementation Status

For each feature in the audit set:

1. **Find AIOUs** — scan `specs/aious/` for AIOU specs referencing this feature
2. **Check completion** — if `run-tracker.md` exists, check AIOU completion status. Otherwise, check for feature verification files.
3. **Assign tier**:
   - **Tier A (Fully Implemented)**: All AIOUs complete, or feature verification file exists
   - **Tier B (Partially Implemented)**: Some AIOUs started/complete, but not all
   - **Tier C (Not Yet Started)**: No AIOUs begun, no implementation evidence

Display the implementation status table:
```
Feature Implementation Status:
| Feature | AIOUs | Complete | Tier |
|---------|-------|----------|------|
| FEAT-001 — ... | 5 | 5 | A — Fully Implemented |
| FEAT-002 — ... | 3 | 1 | B — Partially Implemented |
| FEAT-003 — ... | 4 | 0 | C — Not Yet Started |
```

### Step 4: Per-Feature Thoroughness Audit (Batched)

Process each feature in the current batch. For each feature, evaluate all applicable criteria based on its tier.

#### 4a: Criterion 1 — Complexity Classification

Check `specs/scope-lock.md` for a Complexity column. If missing or feature has no value: record gap.

#### 4b: Criterion 2 — Deep-Dive Analysis

Check `specs/deep-dives/DIVE-{Feature-ID}.md`:
- File exists? If not → Critical gap
- If exists: verify all 7 sections present. Check component counts are exact numbers.
- **If file missing**: perform **retroactive deep-dive analysis** inline:
  - Read the FEAT spec for this feature
  - Read any AIOU specs referencing this feature
  - If code exists, scan the relevant source directories
  - Synthesize the 7-section analysis following the Retroactive Deep-Dive Protocol from the thoroughness-audit skill
  - Embed the retroactive analysis in the report (do NOT create a DIVE file)
  - Flag uncertain items with `[UNCERTAIN]`

#### 4c: Criterion 3 — FEAT Sections 9-10

Read `specs/features/FEAT-{ID}.md`:
- Check for Section 9 (Component Inventory) with component table and total count
- Check for Section 10 (Navigation & Access) with route and navigation path
- Missing either section → Major gap

#### 4d: Criterion 4 — Connectivity Matrix

Check `specs/connectivity-matrix.md`:
- File exists? If not → Critical gap (one gap for the whole project, not per-feature)
- If exists: verify this feature appears in the matrix
- If feature missing from matrix → Critical gap for this feature
- **If matrix missing entirely**: perform inline connectivity analysis:
  - For each feature pair, check DIVE Section 5 / FEAT integration notes / code imports
  - Document discovered interactions in the report
  - This analysis feeds into remediation

#### 4e: Criterion 5 — Feature Verification (Tier A only)

Check `.ultimate-sdlc/council-state/development/feature-verifications/FEAT-{ID}-verified.md`:
- File exists? If not → Critical gap
- If exists: verify it references the component inventory and confirms implementation

#### 4f: Criterion 6 — Run Sizing (Tier A and B only)

Check `.ultimate-sdlc/council-state/development/run-tracker.md`:
- If exists: find the run(s) containing this feature's AIOUs. Check limits (≤15 AIOUs, ≤45 effort).
- If no run-tracker but total AIOUs > 15: → Major gap (run-tracker should exist)

#### 4g: Criterion 7 — PRH-008 Compliance (Tier A only)

Cross-reference DIVE Section 2 / FEAT Section 9 component inventory against implemented code:
- Count specified components vs. implemented components
- Any shortfall → Critical gap with details on missing components

#### 4h: Criterion 8 — PRH-009 Compliance (Tier A only)

Cross-reference connectivity matrix against integration code:
- For each non-"none" interaction involving this feature
- Verify integration exists in code
- Any unimplemented connection → Critical gap

### Step 5: Aggregate and Classify Gaps

After evaluating all features in the batch:

1. **Per-feature summary** — for each feature, list criteria results (Pass/Fail/N/A)
2. **Assign TG-XXX IDs** — sequential across the entire audit (TG-001, TG-002, ...)
3. **Classify each gap**:
   - Severity: Critical / Major / Minor
   - Remediation Type: Spec (missing/incomplete artifact) or Code (unimplemented component/integration)
   - Estimated Effort: S (< 30 min) / M (30-120 min) / L (> 2 hours)

### Step 6: Batch Completion

**If batched mode**: After completing a batch, **STOP** and display:

```
Batch [N] of [total] complete.
Features audited this batch: [count]
Gaps found this batch: [critical] Critical, [major] Major, [minor] Minor
Cumulative gaps: [total]

Say "proceed" to audit the next batch.
```

Wait for user to say "proceed" before starting the next batch.

**If single pass**: Continue directly to Step 7.

### Step 7: Generate Report

After all features audited (all batches complete or single pass done):

1. Create directory: `.ultimate-sdlc/council-state/audit/thoroughness/`
2. Write report to `.ultimate-sdlc/council-state/audit/thoroughness/thoroughness-audit-report.md` using the template from `templates/thoroughness-audit-report.md`
3. Fill all template sections:
   - Executive Summary with gap counts and pass rate
   - Feature Implementation Status table
   - Per-Feature Audit Results with criterion tables and retroactive analyses
   - Connectivity Matrix Analysis
   - Run Sizing Analysis
   - Consolidated Gap Inventory (Critical → Major → Minor)
   - Remediation Summary
   - Audit Metadata

### Step 8: Update State

1. Append to `.ultimate-sdlc/progress.md`:
```
### [DATE] - Thoroughness Audit

**Workflow**: /thoroughness-audit
**Features Audited**: [N]
**Gaps Found**: [critical] Critical, [major] Major, [minor] Minor
**Pass Rate**: [N]%
**Report**: .ultimate-sdlc/council-state/audit/thoroughness/thoroughness-audit-report.md
```

2. Do NOT change Active Council or modify existing specs.

### Step 9: Display Completion

```
Thoroughness Audit Complete
━━━━━━━━━━━━━━━━━━━━━━━━━━

Features Audited:  [N]
Pass Rate:         [N]% (zero Critical/Major gaps)

Gaps Found:
  Critical:  [N]
  Major:     [N]
  Minor:     [N]

Breakdown:
  Spec gaps:   [N] (artifact creation/update needed)
  Code gaps:   [N] (implementation work needed)

Report: .ultimate-sdlc/council-state/audit/thoroughness/thoroughness-audit-report.md

Next Step: Run /thoroughness-remediate to address gaps.
  --severity Critical    → Fix only critical gaps
  --spec-only            → Fix spec artifacts only (no code AIOUs)
```
