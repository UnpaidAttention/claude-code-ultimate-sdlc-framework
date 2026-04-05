---
name: dev-build
description: |
  Verify build succeeds with evidence artifact
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
- Read `~/.claude/skills/antigravity/knowledge/build-verification/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/test-patterns/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/evidence-capture/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/clean-code/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# Development Build Verification Workflow

> Trigger: `/dev-build`

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4.5
> Apply RARV cycle, session protocols per `~/.claude/skills/antigravity/rules/council-development.md`

## Description

Runs build and captures evidence before any AIOU can be marked complete. **This workflow provides external proof that the code compiles and works.**

## Why This Workflow Exists

AI agents often claim code is "complete" without actually verifying it builds or runs. This workflow enforces:
1. Actual build execution (not just "I think it works")
2. Evidence capture via artifacts
3. Blocking incomplete work from progressing

## Pre-Conditions

- Project must have a build system configured
- Working directory should be the project root
- Code changes should be saved to files

## Steps

### Step 1: Identify Build System

Detect the project's build system:

```bash
# Check for common build systems
ls package.json 2>/dev/null && echo "Node.js project"
ls Cargo.toml 2>/dev/null && echo "Rust project"
ls go.mod 2>/dev/null && echo "Go project"
ls pom.xml 2>/dev/null && echo "Maven project"
ls build.gradle* 2>/dev/null && echo "Gradle project"
ls Makefile 2>/dev/null && echo "Make project"
ls pyproject.toml setup.py 2>/dev/null && echo "Python project"
```

### Step 2: Run Build

```bash
npm run build 2>&1 || yarn build 2>&1 || pnpm build 2>&1
```

**TypeScript (type check only):**
```bash
npx tsc --noEmit 2>&1
```

**Rust:**
```bash
cargo build 2>&1
```

**Go:**
```bash
go build ./... 2>&1
```

**Python:**
```bash
python -m py_compile *.py 2>&1 || python -m compileall . 2>&1
```

### Step 3: Capture Build Output

### Verification
- Build completed without errors
- Output artifacts generated (if applicable)

### Evidence
[Screenshot of terminal if available]
```

**If build FAILS:**

Generate **Build Failure Artifact**:
Use **Display Template** from `council-development.md` to show: Build Verification: FAILED
[Full error output]
```

### Error Analysis
- **Error Type**: [Syntax/Type/Dependency/Configuration]
- **Location**: [file:line if identifiable]
- **Root Cause**: [analysis]

### Recommended Fix
[Specific steps to fix the error]

### AIOU Status
**AIOU CANNOT be marked complete until build passes.**
```

### Step 4: Run Type Check (if applicable)

For TypeScript/typed languages:

```bash
# TypeScript
npx tsc --noEmit 2>&1

# Python with mypy
mypy . 2>&1 || echo "mypy not installed"

# Go (built into build)
go vet ./... 2>&1
```

Generate **Type Check Artifact** if errors found.

### Step 5: Run Quick Tests

Execute fast tests to verify basic functionality:

```bash
# Node.js
npm test -- --bail --findRelatedTests [changed files] 2>&1

# Or run all tests with timeout
timeout 120 npm test 2>&1
```

### Step 6: Update State

/dev-build                    # Run build verification
/dev-build aiou=AIOU-042      # Verify specific AIOU's changes
/dev-build full               # Full build + all tests
```

## Integration with AIOU Completion

Before marking ANY AIOU complete:
1. Run `/dev-build`
2. Verify Build Artifact shows SUCCESS
3. Only then update .antigravity/project-context.md

**AIOU without successful Build Artifact = NOT COMPLETE**
