---
name: sdlc-dev-config
description: |
  Read and validate framework configuration
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/configuration-management/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/validation-patterns/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/systematic-evaluation/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# Configuration Management

// turbo-all

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocols per `~/.claude/skills/ultimate-sdlc/rules/council-development.md`

## Trigger
- `/dev-config` - Display current configuration
- `/dev-config validate` - Validate configuration file
- `/dev-config set [key] [value]` - Update a configuration value

## Purpose

The `.ultimate-sdlc/config.yaml` file allows customization of framework behavior:
- Project profile (micro/standard/enterprise)
- Parallel execution settings
- Standards enforcement
- Testing limits
- Evidence requirements

## Configuration Loading

### At Session Start

1. Check if `.ultimate-sdlc/config.yaml` exists in project root
2. If exists: Load and validate
3. If not exists: Use defaults from framework `.ultimate-sdlc/config.yaml`
4. Report active configuration

### Load Sequence

```
1. Read framework default .ultimate-sdlc/config.yaml
2. Read project .ultimate-sdlc/config.yaml (if exists)
3. Merge (project overrides framework defaults)
4. Validate merged configuration
5. Apply to session
```

## Configuration Sections

### Profile

```yaml
profile: standard  # micro | standard | enterprise
```

### Parallel Execution

```yaml
parallel:
  enabled: true
  max_agents: 3
  require_ownership_map: true
```

- `enabled`: Allow parallel AIOU execution within waves
- `max_agents`: Maximum concurrent agents
- `require_ownership_map`: Must generate file ownership before parallel

### Standards

```yaml
standards:
  enforce_before_implementation: true
  categories:
    - global
    - backend
    - frontend
    - testing
```

- `enforce_before_implementation`: Require reading standards before coding
- `categories`: Which standard categories to load

### Reuse Protocol

```yaml
reuse:
  require_pattern_search: true
  warn_on_potential_duplicates: true
```

- `require_pattern_search`: Must run `/dev-search-patterns` before implementation
- `warn_on_potential_duplicates`: Alert when creating potentially duplicate utilities

### Testing

```yaml
testing:
  min_tests_per_aiou: 3
  max_tests_per_aiou: 8
  coverage:
    unit: 80
    integration: 70
    e2e: "critical_paths"
```

- `min_tests_per_aiou`: Minimum tests required
- `max_tests_per_aiou`: Maximum tests to prevent bloat
- `coverage`: Coverage targets per test type

### Visual Assets

```yaml
visual_assets:
  mandatory_check: true
  require_screenshots: true
  breakpoints:
    - desktop: 1920
    - tablet: 768
    - mobile: 375
```

- `mandatory_check`: Always search for mockups at Wave 5 start
- `require_screenshots`: Must capture screenshots for UI AIOUs
- `breakpoints`: Responsive breakpoints to capture

### Gates

```yaml
gates:
  i4:
    require_type_check: true
    min_coverage: 80
    require_security_scan: true
  i8:
    require_all_tests_pass: true
    min_coverage: 80
    require_e2e: true
    require_security_review: true
```

Gate requirements can be adjusted per project needs.

### Models

```yaml
models:
  wave_0_4: "claude-sonnet-4"
  wave_5: "claude-opus-4-6"
  wave_6: "claude-sonnet-4"
  complex_issues: "claude-opus-4"
```

Recommended models for each wave. Ultimate SDLC can use these for model selection.

## Validation Rules

When validating config:

1. **Required fields**: `version`, `profile`
2. **Valid values**:
   - `profile`: must be `micro`, `standard`, or `enterprise`
   - `coverage` values: must be 0-100 or "critical_paths"
   - `max_agents`: must be 1-10
3. **Type checking**:
   - Booleans for enabled/require flags
   - Integers for numeric values
   - Lists for arrays

## Output Format

### Display Configuration
Use **Display Template** from `council-development.md` to show: Active Configuration

### Validation Output
Use **Display Template** from `council-development.md` to show: Configuration Validation

## Usage in Workflows

Other workflows reference config values:

Use **Display Template** from `council-development.md` to show: In /dev-parallel

## Project Setup

To customize configuration for a project:

1. Copy `.ultimate-sdlc/config.yaml` from framework to project root
2. Edit values as needed
3. Run `/dev-config validate` to verify
4. Configuration applies to all subsequent operations

## Notes

- Config changes take effect immediately
- Invalid config prevents session start
- Missing config uses framework defaults
- Project config always overrides framework defaults
