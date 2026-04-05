---
name: dev-ui-polish-report
description: |
  Phase 2 of UI Polish — transform raw anti-slop scan results into a structured report with severity ratings and summary counts per category.
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
- Read `~/.claude/skills/antigravity/knowledge/frontend-design/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/ui-ux-pro-max/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/systematic-evaluation/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# /dev-ui-polish-report - Phase 2: Generate Slop Report

---

## Lens / Skills / Model
**Lens**: `[UX]` + `[Quality]` | **Model**: claude-opus-4-6
> Apply RARV cycle, session protocol per `council-development.md`

## Prerequisites

- `.antigravity/council-state/development/ui-slop-scan.md` must exist (Phase 1 complete)

If prerequisite not met:
```
Raw scan results not found. Run /dev-ui-polish-scan first.
Phase 2 requires the raw scan output from Phase 1.
```

---

## Instructions

### Step 1: Load Raw Scan Results

Read `.antigravity/council-state/development/ui-slop-scan.md` from Phase 1. Extract all findings across the 5 categories.

### Step 2: Deduplicate and Consolidate

- Merge findings that refer to the same root cause (e.g., Inter font referenced in 12 files is ONE finding, not 12)
- Group related findings (e.g., all purple color uses are one finding with multiple affected files)
- Preserve individual file references within consolidated findings

### Step 3: Assign Severity

For each consolidated finding, assign severity:

| Severity | Criteria |
|----------|----------|
| **HIGH** | Immediately recognizable as AI-generated; affects first impression; appears on primary pages (landing, dashboard) |
| **MEDIUM** | Contributes to generic appearance; affects secondary pages or repeated components |
| **LOW** | Minor pattern; only noticeable in aggregate; limited to edge-case pages |

### Step 4: Write Structured Report

For each finding, document:

```markdown
### Finding [N]: [Category] — [Short Description]
- **File(s)**: [list of affected file paths]
- **Current**: [what exists — exact code, class, or value]
- **Why it's slop**: [specific explanation — what makes this generic AI output]
- **Severity**: HIGH / MEDIUM / LOW
```

### Step 5: Generate Summary Counts

Summarize at the top of the report:

```markdown
## Findings Summary
- Typography issues: [N] (HIGH: [n], MEDIUM: [n], LOW: [n])
- Color issues: [N] (HIGH: [n], MEDIUM: [n], LOW: [n])
- Layout issues: [N] (HIGH: [n], MEDIUM: [n], LOW: [n])
- Component style issues: [N] (HIGH: [n], MEDIUM: [n], LOW: [n])
- Copy issues: [N] (HIGH: [n], MEDIUM: [n], LOW: [n])
- **Total slop findings**: [N]
- **HIGH severity**: [N]
- **MEDIUM severity**: [N]
- **LOW severity**: [N]
```

---

## Output

Save structured report to `.antigravity/council-state/development/ui-slop-report.md`:

```markdown
# Anti-Slop Audit Report

## Report Date: [date]
## Source: .antigravity/council-state/development/ui-slop-scan.md

## Findings Summary
[Summary counts per Step 5]

## Detailed Findings

### Finding 1: [Category] — [Description]
[Per Step 4 template]

### Finding 2: ...
[Repeat for every consolidated finding]
```

---

## Completion Condition

- All raw findings consolidated and deduplicated
- Every finding has severity assigned with justification
- Summary counts match detailed findings
- Report saved to `.antigravity/council-state/development/ui-slop-report.md`

---

## Next Step

```
## Phase 2 Complete: Slop Report Generated

**Total slop findings**: [N] (HIGH: [n], MEDIUM: [n], LOW: [n])
**Report saved to**: .antigravity/council-state/development/ui-slop-report.md

**Next step**: Run `/dev-ui-polish-research` to research design alternatives for each finding category.
```

---
