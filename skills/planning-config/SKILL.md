---
name: sdlc-planning-config
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
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/configuration-management/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/validation-patterns/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/systematic-evaluation/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


# Configuration Management

// turbo-all

---

## Lens / Skills / Model
**Lens**: `[Requirements]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per council-planning.md

## Trigger
- `/planning-config` - Display current configuration
- `/planning-config validate` - Validate configuration file

## Purpose

The `.ultimate-sdlc/config.yaml` file allows customization of framework behavior:
- Project profile (micro/standard/enterprise)
- Discovery settings
- Feature discovery agents
- AIOU size limits
- Gate requirements

## Configuration Loading

### At Session Start

1. Check if `.ultimate-sdlc/config.yaml` exists in project root
2. If exists: Load and validate
3. If not exists: Use defaults from framework `.ultimate-sdlc/config.yaml`
4. Report active configuration

## Configuration Sections

### Profile

```yaml
profile: standard  # micro | standard | enterprise
```

### Discovery Configuration

```yaml
discovery:
  questions_with_defaults: true
  required_dimensions:
    - problem_purpose
    - target_users
    - core_value
    - key_capabilities
    - constraints
    - success_criteria
```

- `questions_with_defaults`: Use assumption-based questions for faster confirmation
- `required_dimensions`: Dimensions to cover in `/planning-discover`

### Feature Discovery

```yaml
feature_discovery:
  agents:
    - product_visionary
    - ux_strategist
    - domain_expert
    - technical_validator
    - business_analyst
  require_consensus: true
  min_features: 3
```

- `agents`: Agents to include in Phase 2.5 deliberation
- `require_consensus`: All agents must align before proceeding
- `min_features`: Minimum features required for project viability

### AIOU Configuration

```yaml
aiou:
  max_size: "L"
  size_limits:
    xs: {max_hours: 1, max_files: 2}
    s: {max_hours: 2, max_files: 3}
    m: {max_hours: 4, max_files: 5}
    l: {max_hours: 8, max_files: 7}
  require_size_review: true
```

- `max_size`: Maximum allowed AIOU size before mandatory split
- `size_limits`: Definition of each size category
- `require_size_review`: Review M+ AIOUs for potential splitting

### Gates

```yaml
gates:
  gate_3_5:
    require_all_features_decomposed: true
    require_dependency_mapping: true
    require_wave_assignments: true
  gate_8:
    require_all_phases_complete: true
    require_traceability: true
    require_security_checklist: true
```

Gate requirements can be adjusted per project needs.

### Models

```yaml
models:
  phases_1_to_3_5: "claude-opus-4"
  phases_4_to_8: "claude-sonnet-4"
```

Recommended models for each phase range. Ultimate SDLC can use these for model selection.

## Output Format

### Display Configuration
Use **Display Template** from `council-planning.md` to show: Active Configuration

## Usage in Workflows

Other workflows reference config values:

Use **Display Template** from `council-planning.md` to show: In /planning-discover

## Project Setup

To customize configuration for a project:

1. Copy `.ultimate-sdlc/config.yaml` from framework to project root
2. Edit values as needed
3. Run `/planning-config validate` to verify
4. Configuration applies to all subsequent operations
