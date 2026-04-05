---
name: sdlc-audit-trace
description: |
  Verify implementation matches planning specifications
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/traceability-analysis/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/gap-analysis/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/completeness-matrix/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# Traceability Audit

Verify Development Council output matches Planning Council specifications.

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per `council-audit.md`

## Purpose
Cross-reference implemented code against `planning-handoff.md` to detect drift, missing features, and undocumented additions.

## Prerequisites
- `planning-handoff.md` must exist (from Planning Council)
- Implemented codebase must be available
- Audit Council must have completed T1 (Inventory)

## Steps

1. **Load Planning Specifications**
   - Read `planning-handoff.md`
   - Extract all AIOUs with their acceptance criteria
   - Extract all feature specifications
   - Note expected file/component locations

2. **Load Implementation Inventory**
   - Read T1 feature inventory from `audit-context.md` or `.ultimate-sdlc/progress.md`
   - List all implemented features discovered
   - Note actual file/component locations

3. **Generate Traceability Matrix**

   For each planned AIOU:
   - [ ] AIOU-XXX: [description]
     - Planned: [acceptance criteria]
     - Implemented: [YES/NO/PARTIAL]
     - Location: [file path or "NOT FOUND"]
     - Notes: [any deviations]

4. **Identify Gaps**

   **Missing Implementations** (planned but not found):
   - List AIOUs with no corresponding implementation
   - Severity: HIGH if core feature, MEDIUM if enhancement

   **Undocumented Additions** (implemented but not planned):
   - List features found in code but not in planning-handoff.md
   - Flag for review: intentional improvement or scope creep?

   **Partial Implementations**:
   - List AIOUs where some but not all acceptance criteria are met
   - Detail which criteria are missing

5. **Calculate Coverage**
   ```
   Traceability Score = (Fully Implemented AIOUs / Total Planned AIOUs) × 100
   ```

6. **Generate Report Artifact**

## Output Format

Use **Display Template** from `council-audit.md` to show: Traceability Audit Report

## Severity Guidelines

| Gap Type | Severity | Action |
|----------|----------|--------|
| Core AIOU missing | Critical | Must implement before release |
| Enhancement AIOU missing | Medium | Prioritize for next iteration |
| Acceptance criteria gap | High | Complete implementation |
| Undocumented addition | Low | Document or remove |

## Integration

- Run this workflow after T2 (Functional Testing) for best results
- Results feed into A2 (Completeness) phase
- Update `audit-context.md` with traceability score
