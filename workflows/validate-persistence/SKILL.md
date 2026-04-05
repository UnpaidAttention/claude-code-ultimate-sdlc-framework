---
name: validate-persistence
description: |
  Verify configuration and state changes persist across app restart
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/persistence-verification/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/data-flow-analysis/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/storage-validation/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/evidence-capture/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# Workflow: validate-persistence

> **Tech-Specific**: This workflow uses Electron/desktop app patterns (IPC, preload, main process, config files). Adapt layer names and storage types for your stack.

---

## Lens / Skills / Model
**Lens**: `[Architecture]` | **Model**: Claude Sonnet 4
> Apply session protocol per `council-validation.md`
---

> Trigger: `/validate-persistence [setting-or-state]` or "Verify persistence of [item]"

## Description

Verifies that configuration changes, user preferences, and application state actually persist across application restarts. Many features "work" in the GUI but don't survive a restart because persistence is missing or broken.

## Why This Workflow Exists

A devastating failure pattern:
1. User changes a setting
2. UI updates immediately (React state)
3. User thinks setting is saved
4. App restarts
5. Setting is gone - was never persisted

This happens because:
- Frontend state management (Redux/Context) is confused with persistence
- Write operations are missing or fail silently
- Read operations don't load persisted values
- Config file path is wrong or file doesn't exist
- Database connection isn't established

## Persistence Types

| Type | Storage | Typical Use | Verification Method |
|------|---------|-------------|---------------------|
| Config File | JSON/YAML/TOML | User settings, preferences | Read file contents |
| electron-store | Encrypted JSON | Secure settings, API keys | electron-store API |
| SQLite | Database file | Structured data, history | SQL query |
| localStorage | Browser storage | Web app state | DevTools Application tab |
| Keychain/Credential | OS secure storage | Passwords, tokens | OS credential manager |
| External API | Remote server | Cloud-synced settings | API request |

## Pre-Conditions

- [ ] Application is running
- [ ] Setting/state is modifiable via GUI
- [ ] Persistence location is identified
- [ ] Application can be restarted

## Steps

### Step 1: Identify Persistence Requirements

Use **Display Template** from `council-validation.md` to show: Persistence Analysis: [Setting/State Name]

### Step 2: Capture Initial State

Use **Display Template** from `council-validation.md` to show: Initial State: [Setting Name]
[Current contents of config file / database record]
Use **Display Template** from `council-validation.md` to show: UI State BEFORE Change

### Step 3: Make Change via GUI

Use **Display Template** from `council-validation.md` to show: Change Execution

### Step 4: Verify Immediate Persistence

**Before restarting**, check if the change was written:

Use **Display Template** from `council-validation.md` to show: Immediate Persistence Check
[Contents of config file / database record AFTER change]
Use **Display Template** from `council-validation.md` to show: Comparison

### Step 5: Restart Application

Use **Display Template** from `council-validation.md` to show: Application Restart

### Step 6: Verify Persistence After Restart

Use **Display Template** from `council-validation.md` to show: Post-Restart Verification
[Contents of storage after restart]
Use **Display Template** from `council-validation.md` to show: UI State After Restart

### Step 7: Deep Analysis (If Failed)

If persistence failed, trace the issue:

Use **Display Template** from `council-validation.md` to show: Persistence Failure Analysistypescript
[Write code with issue highlighted]
```

#### Read Analysis
**Read Method**: [method name]
**Read Location**: [file:line]
**Read Called on Startup**: Yes / No
**Value Returned**: [value or error]

```typescript
[Read code with issue highlighted]
Use **Display Template** from `council-validation.md` to show: Path/Location Analysis

### Step 8: Generate Persistence Report

Use **Display Template** from `council-validation.md` to show: Persistence Verification Report: [Setting/State]

## Artifacts Generated

- **Before State Screenshots**: UI and storage state before change
- **After State Screenshots**: UI and storage state after change
- **Post-Restart Screenshots**: UI state after restart
- **Storage Content Artifacts**: Config file / database contents
- **Persistence Report Artifact**: Complete verification documentation

## Required Evidence Checklist

For persistence to be verified:

- [ ] Storage state captured BEFORE change
- [ ] Change made via GUI (not code)
- [ ] Storage state captured AFTER change
- [ ] Application fully restarted
- [ ] Storage state verified AFTER restart
- [ ] UI state verified AFTER restart
- [ ] Values match across all states

## Usage

```
/validate-persistence "theme setting"
/validate-persistence "api key"
/validate-persistence "window position"
/validate-persistence "recent files list"
/validate-persistence all-settings    # Test all settings
```

## Common Persistence Issues

| Issue | Symptom | Fix |
|-------|---------|-----|
| No write call | UI updates, storage empty | Add save method call |
| Wrong path | File exists elsewhere | Fix path configuration |
| No read on start | Storage has data, UI default | Add load on app start |
| Async not awaited | Sometimes persists | await the save operation |
| Default overwrites | Saved value replaced | Load before setting defaults |
| Encode/Decode error | Data corrupted | Fix serialization |

## Integration with E2E Testing

```
/validate-e2e-test [feature]
    │
    │ For settings/config features:
    ↓
/validate-persistence [setting]  ← Automatic sub-check
    │
    │ If persistence fails:
    ↓
/validate-data-flow [setting-write]  ← Trace the failure
```

## Persistence Verification Matrix

Use this matrix to track all persistent items:

| Item | Storage | Write Verified | Read Verified | Restart Verified |
|------|---------|----------------|---------------|------------------|
| [setting-1] | [type] | ✅ / ❌ | ✅ / ❌ | ✅ / ❌ |
