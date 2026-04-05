---
name: planning-upgrade
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
- Read `~/.claude/skills/antigravity/knowledge/upgrade-procedures/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/backup-management/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/configuration-management/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/migration-strategies/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# Framework Upgrade

// turbo-all

---

## Lens / Skills / Model
**Lens**: `[Architecture]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per council-planning.md

## Trigger
- `/planning-upgrade` - Start upgrade process
- `/planning-upgrade --dry-run` - Preview upgrade without changes

## Purpose

Safely upgrade the framework while:
- Preserving project-specific configuration
- Backing up customizations
- Migrating settings to new version

## Upgrade Process

### Step 1: Pre-Upgrade Check

Run upgrade script in dry-run mode:

```bash
./upgrade.sh --dry-run
```

### Step 2: Backup Current State

```bash
./upgrade.sh --source /path/to/new/version
```

### Step 4: Post-Upgrade Tasks

1. **Validate configuration**:
   ```
   /planning-config validate
   ```

2. **Merge project customizations** from backup

3. **Verify workflows work**:
   ```
   /planning-status
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

## Rollback

If upgrade causes issues, restore from backup:

```bash
ls ./backups/
cp -r ./backups/planning-council-TIMESTAMP/.agent .
cp -r ./backups/planning-council-TIMESTAMP/.context .
cp ./backups/planning-council-TIMESTAMP/CLAUDE.md .
cp ./backups/planning-council-TIMESTAMP/.antigravity/config.yaml .
```
