---
name: dev-search-patterns
description: |
  Search codebase for reusable patterns before implementing AIOU
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
- Read `~/.claude/skills/antigravity/knowledge/pattern-recognition/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/code-reuse/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/architecture-principles/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/clean-code/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# Search Existing Patterns

// turbo-all

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocols per `~/.claude/skills/antigravity/rules/council-development.md`

## Trigger
Run this workflow BEFORE starting any AIOU implementation.
- `/dev-search-patterns AIOU-XXX` - Search for patterns relevant to specific AIOU
- `/dev-search-patterns` - General pattern search

## Purpose

Prevent reinventing the wheel by finding:
- Similar existing features to reference
- Reusable utilities and helpers
- Established patterns to follow
- Naming conventions in use

## Steps

### Step 1: Read AIOU Specification

1. Find AIOU spec in `planning-handoff.md`
2. Note:
   - What functionality is needed
   - What types/interfaces are involved
   - What services/utilities might be needed
   - What patterns might apply

### Step 2: Search for Similar Features

Search for existing implementations of similar functionality:

```bash
# Search for similar service patterns
grep -r "class.*Service" src/ --include="*.ts" --include="*.py"

# Search for similar utilities
grep -r "export function" src/utils/ --include="*.ts" --include="*.py"

# Search for similar components (frontend)
grep -r "export.*Component" src/components/ --include="*.tsx" --include="*.vue"

# Search for similar API endpoints
grep -r "router\." src/routes/ --include="*.ts"
```

### Step 3: Search for Reusable Utilities

Based on AIOU needs, search for existing utilities:

```bash
# Validation utilities
grep -r "validate" src/utils/ --include="*.ts"

# Error handling
grep -r "class.*Error" src/ --include="*.ts"

# Data transformation
grep -r "transform\|convert\|format" src/utils/ --include="*.ts"

# API helpers
grep -r "fetch\|request\|api" src/utils/ --include="*.ts"
```

### Step 4: Identify Naming Conventions

Examine existing code for patterns:

```bash
# How are services named?
ls src/services/

# How are components named?
ls src/components/

# How are utilities organized?
ls src/utils/

# How are types named?
grep -r "interface\|type" src/types/ --include="*.ts" | head -20
```

### Step 5: Document Findings

Create reuse documentation:

Use **Display Template** from `council-development.md` to show: Reuse Analysis: AIOU-XXX

### Step 6: Load Relevant Standards

Based on AIOU wave, load applicable standards:

| Wave | Standards to Load |
|------|-------------------|
| 0-1 | `global/*` |
| 2 | `global/*`, `backend/data-access.md` |
| 3 | `global/*`, `backend/*` |
| 4 | `global/*`, `backend/api-design.md` |
| 5 | `global/*`, `frontend/*` |
| 6 | All standards |

Read the relevant standards files from `.standards/`.

## Output Format

Use **Display Template** from `council-development.md` to show: Pattern Search Results: AIOU-XXX

## Integration

This workflow integrates with:
- `/dev-verify-aiou` - Verification will check that reuse analysis was performed
- `.standards/` - Standards loaded based on wave
- `planning-handoff.md` - Source of AIOU specifications

## Notes

- This workflow should take 5-10 minutes
- Better to spend time searching than duplicating code
- If you find patterns that should be standardized, propose adding to `.standards/`
- Document even negative findings ("no similar features found")
