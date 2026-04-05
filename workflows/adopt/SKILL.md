---
name: sdlc-adopt
description: |
  Onboard an existing codebase to the Ultimate SDLC Framework. Scans code, generates feature inventory, extracts architecture, creates project manifest.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/requirements-engineering/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/architecture-principles/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/clean-code/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /adopt - Onboard Existing Codebase

---

## Lens / Skills / Model
**Lens**: `[Architecture]` | **Model**: Claude Opus 4
> Apply RARV cycle, session protocol per the active council rules file

## Arguments
| Argument | Required | Description |
|----------|----------|-------------|
| (none) | — | Session auto-detects state |

---

## Purpose

Onboard an existing, already-developed codebase to the Ultimate SDLC Framework so that subsequent development cycles can be managed through the framework. This is for projects that were NOT built using the framework originally.

**What this does**:
1. Analyzes the existing codebase to understand tech stack, architecture, and features
2. Generates a feature inventory from discovered code
3. Extracts architecture decisions into ADR format
4. Creates the project manifest
5. Creates a historical "cycle-001-pre-existing" representing all work done before adoption
6. Prepares the project for `/new-cycle`

**What this does NOT do**:
- Modify any existing code
- Change project structure
- Add or remove dependencies
- Run any destructive operations

---

## Pre-Flight Check

1. **Verify codebase exists**: Check for source code directories (`src/`, `app/`, `lib/`, `pages/`, `server/`, etc.) or language-specific indicators (`package.json`, `requirements.txt`, `go.mod`, `Cargo.toml`, `pom.xml`, etc.)
   - If no codebase found: "No codebase detected. Run `/init` to start a new project."

2. **Check if already adopted**: Check for `.ultimate-sdlc/project-manifest.md`
   - If exists: "Project already onboarded. Run `/new-cycle` to start a new cycle."

3. **Check for existing framework state**: Check for `.ultimate-sdlc/project-context.md`
   - If exists with Active Council: "Framework state detected. This project may already be using the framework. Run `/status` to check, or delete `.ultimate-sdlc/project-context.md` to proceed with adoption."

---

## Workflow

### Step 1: Codebase Analysis

Scan the project directory to identify:

#### 1a: Tech Stack Identification

- **Languages**: Check file extensions (.ts, .tsx, .js, .py, .go, .rs, .java, etc.)
- **Package managers**: package.json (npm/yarn/pnpm/bun), requirements.txt/pyproject.toml (pip/poetry), go.mod, Cargo.toml, etc.
- **Frameworks**: Check dependencies for React, Next.js, Vue, Angular, Express, FastAPI, Django, Flask, Gin, Actix, Spring, etc.
- **Databases**: Check for Prisma schema, SQLAlchemy models, TypeORM entities, migration files, docker-compose services
- **Testing**: Check for test directories, jest.config, pytest.ini, vitest.config, etc.
- **CI/CD**: Check for .github/workflows/, .gitlab-ci.yml, Dockerfile, docker-compose.yml
- **Infrastructure**: Check for terraform/, k8s/, helm/, serverless.yml, etc.

#### 1b: Architecture Pattern Identification

- **Monolith vs Microservices**: Check for multiple service directories, docker-compose with multiple services
- **API style**: REST (routes/controllers), GraphQL (schema/resolvers), gRPC (proto files)
- **Frontend pattern**: SPA, SSR, SSG, hybrid
- **State management**: Redux, Zustand, Context, Vuex, Pinia, etc.
- **Data access pattern**: ORM, raw SQL, repository pattern

#### 1c: Complexity Assessment

- Count total files (exclude node_modules, .git, dist, build, __pycache__, etc.)
- Count lines of code (approximate)
- Count distinct modules/features
- Estimate project profile: Micro (<5 features) / Standard (5-20) / Enterprise (20+)

Display findings:

Use **Display Template** from `the active council rules file` to show: Codebase Analysis

### Step 2: Feature Discovery

Analyze the codebase to identify existing features:

#### 2a: Route/Endpoint Analysis
- Scan route files, controllers, API handlers
- Map each route group to a feature

#### 2b: Component/Module Analysis
- Scan UI components (if frontend exists)
- Identify feature-level modules
- Map components to features

#### 2c: Data Model Analysis
- Read database schema/models
- Identify entity relationships
- Map data models to features

#### 2d: Generate Feature Inventory

Create `specs/feature-inventory.md`:

Use **Display Template** from `the active council rules file` to show: Feature Inventory

Present to user for verification:

Use **Display Template** from `the active council rules file` to show: Discovered Features

Wait for user corrections.

### Step 3: Architecture Extraction

Generate initial ADRs reflecting existing decisions:

Create files in `specs/adrs/`:

Use **Display Template** from `the active council rules file` to show: ADR-001: [Technology/Pattern Choice]

Generate ADRs for key decisions:
- Primary language/framework
- Database choice
- API architecture
- Frontend architecture (if applicable)
- Authentication approach (if applicable)
- Deployment approach (if CI/CD exists)

### Step 4: Quality Baseline

Run available quality checks (non-destructive only):

#### 4a: Test Status
```
If test runner configured → Run tests → Capture pass/fail/coverage
If no tests → Note "No automated tests found"
```

#### 4b: Lint Status
```
If linter configured → Run linter → Capture issue count
If no linter → Note "No linter configured"
```

#### 4c: Security Status
```
If npm → Run `npm audit` (or equivalent)
If pip → Check for known vulnerabilities
Note any findings
```

#### 4d: Generate Baseline Report

Use **Display Template** from `the active council rules file` to show: Quality Baseline

### Step 5: Create Project Manifest

Create `.ultimate-sdlc/project-manifest.md`:

Use **Display Template** from `the active council rules file` to show: Project Manifest

### Step 6: Create Historical Cycle Archive

Create `.cycles/cycle-001-pre-existing/`:

```bash
mkdir -p .cycles/cycle-001-pre-existing
```

Create `.cycles/cycle-001-pre-existing/CYCLE-SUMMARY.md`:

Use **Display Template** from `the active council rules file` to show: Cycle Summary — cycle-001-pre-existing

### Step 7: Create Spec Directories

```bash
mkdir -p specs/features
mkdir -p specs/aious
mkdir -p specs/adrs
```

(Feature inventory and ADRs were already created in earlier steps)

### Step 8: Display Completion

Use **Display Template** from `the active council rules file` to show: Project Adopted to Framework

---

## Error Handling

### If codebase is too large to analyze
- Focus on entry points (main files, route files, component directories)
- Use file counts and directory structure as proxies
- Ask user to clarify features rather than deep-scanning every file

### If no clear feature boundaries exist
- Use route groupings, directory structure, or data models as feature proxies
- Ask user to define features manually
- Note "Feature boundaries unclear" in manifest

### If package manager / build system not recognized
- Ask user for tech stack details
- Skip automated quality checks
- Note limitations in baseline report

---
