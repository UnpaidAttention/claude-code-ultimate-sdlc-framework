---
name: sdlc-dev-upgrade
description: |
  Upgrade framework to a new version
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
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/git-operations/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/configuration-management/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


# Framework Upgrade

// turbo-all

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocols per `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/rules/council-development.md`

## Trigger
- `/dev-upgrade` - Start upgrade process
- `/dev-upgrade --dry-run` - Preview upgrade without changes
- `/dev-upgrade --check` - Check for available updates

## Purpose

Safely upgrade the framework while:
- Preserving project-specific configuration
- Backing up customizations
- Migrating settings to new version
- Regenerating Ultimate SDLC skills

## Upgrade Process

### Step 1: Pre-Upgrade Check

Run upgrade script in dry-run mode:

```bash
./upgrade.sh --dry-run
```

### Step 2: Review Changes

```bash
./upgrade.sh --source /path/to/new/version
```

Or with custom backup location:

```bash
./upgrade.sh --source /path/to/new/version --backup-dir /custom/backup/path
```

### Step 5: Post-Upgrade Tasks

After upgrade completes:

1. **Regenerate Ultimate SDLC skills**:
   ```
   /dev-export-skills
   ```

2. **Validate configuration**:
   ```
   /dev-config validate
   ```

3. **Merge project customizations**:
   - Compare backup config with new config
   - Apply project-specific settings

4. **Verify workflows work**:
   ```
   /dev-status
   ```

## Upgrade Script Options

```
./upgrade.sh [OPTIONS]

Options:
  --dry-run         Preview changes without applying
  --backup-dir      Directory for backups (default: ./backups)
  --source          Source directory for new framework version
  --help            Show help message
```

### Version Compatibility

```bash
   # Find your backup
   ls ./backups/

   # Restore (replace timestamp)
   cp -r ./backups/dev-council-TIMESTAMP/.agent .
   cp -r ./backups/dev-council-TIMESTAMP/.standards .
   cp ./backups/dev-council-TIMESTAMP/CLAUDE.md .
   cp ./backups/dev-council-TIMESTAMP/.ultimate-sdlc/config.yaml .
   ```

2. **Regenerate skills**:
   ```
   /dev-export-skills
   ```

## Customization Preservation

### Preserved Automatically
- Project `.ultimate-sdlc/config.yaml` (if in project root, not framework)
- Project state files (`.ultimate-sdlc/project-context.md`, `.ultimate-sdlc/progress.md`)

### Manual Preservation Needed
- Custom standards added to `.standards/`
- Custom workflows added to `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/skills/`
- Custom directives added to `directives/`

**Recommendation**: Keep customizations in project-specific files, not framework files.

## Output

### Dry Run Output
Use **Display Template** from `council-development.md` to show: Upgrade Preview

### Actual Upgrade Output
Use **Display Template** from `council-development.md` to show: Upgrade Complete
