---
name: validate-data-flow
description: |
  Trace data flow from GUI action through all layers to final effect
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
- Read `~/.claude/skills/antigravity/knowledge/data-flow-analysis/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/10-layer-tracing/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/ipc-debugging/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/systematic-debugging/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# Workflow: validate-data-flow

> **Tech-Specific**: This workflow uses Electron/desktop app patterns (IPC, preload, main process, config files). Adapt layer names and storage types for your stack.

---

## Lens / Skills / Model
**Lens**: `[Architecture]` | **Model**: Claude Sonnet 4
> Apply session protocol per `council-validation.md`
---

> Trigger: `/validate-data-flow [ui-element]` or "Trace data flow for [element]"

## Description

Traces the complete data flow from a GUI action through all application layers to its final effect. This workflow identifies EXACTLY where data gets lost, transformed incorrectly, or fails to reach its destination.

## Why This Workflow Exists

A common failure pattern: "The button exists, the handler exists, the backend exists... but they don't connect."

This happens because:
- IPC channel names don't match between frontend and backend
- Event handlers are defined but not wired up
- Backend handlers exist but aren't registered
- Data transforms incorrectly between layers
- Async operations fail silently

**This workflow traces the actual path data takes**, identifying breaks in the chain.

## Data Flow Architecture (Electron Apps)

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          DATA FLOW LAYERS                                │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  [1] UI EVENT          User clicks button, toggles switch, submits form │
│         ↓                                                                │
│  [2] EVENT HANDLER     React/Vue/etc component handler function         │
│         ↓                                                                │
│  [3] API CALL          window.electronAPI.xxx() or fetch()              │
│         ↓                                                                │
│  [4] PRELOAD BRIDGE    ipcRenderer.invoke() / ipcRenderer.send()        │
│         ↓                                                                │
│  [5] IPC CHANNEL       Named channel between renderer and main          │
│         ↓                                                                │
│  [6] MAIN HANDLER      ipcMain.handle() / ipcMain.on()                  │
│         ↓                                                                │
│  [7] SERVICE LAYER     Business logic, validation, processing           │
│         ↓                                                                │
│  [8] PERSISTENCE       Database, config file, external API              │
│         ↓                                                                │
│  [9] RESPONSE          Data returned back through the chain             │
│         ↓                                                                │
│  [10] UI UPDATE        Component state update, re-render                │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

## Pre-Conditions

- [ ] Application is running
- [ ] UI element is accessible
- [ ] Developer tools/console accessible
- [ ] Source code available for inspection

## Steps

### Step 1: Identify the UI Element

Use **Display Template** from `council-validation.md` to show: Data Flow Trace: [UI Element Name]
```jsx
[The actual element code]
```

### User Action
**Action Type**: [click / change / submit / focus / etc.]
**Expected Effect**: [What should happen]

### Step 2: Trace Layer 1-2 (UI Event → Handler)

Use **Display Template** from `council-validation.md` to show: Layer 1-2: UI Event to Handler

```typescript
[The actual handler code]
```

Use **Display Template** from `council-validation.md` to show: Verification

### Step 3: Trace Layer 3-4 (Handler → API → Preload)

Use **Display Template** from `council-validation.md` to show: Layer 3-4: Handler to IPC Bridge

```typescript
[The API call code]
```

### Preload Bridge
**Preload File**: [preload.ts location]
**Bridge Method**: [The method exposed via contextBridge]

### Preload Code
```typescript
[The preload bridge code]
```

Use **Display Template** from `council-validation.md` to show: IPC Call Trace

### Step 4: Trace Layer 5-6 (IPC Channel → Main Handler)

Use **Display Template** from `council-validation.md` to show: Layer 5-6: IPC to Main Process

```typescript
[The main process handler code]
```

### Channel Registration
```typescript
[Where the handler is registered]
```

Use **Display Template** from `council-validation.md` to show: Verification

### Step 5: Trace Layer 7-8 (Service → Persistence)

Use **Display Template** from `council-validation.md` to show: Layer 7-8: Service to Persistence

```typescript
[The service method code]
```

### Persistence Operation
**Type**: [Database / Config File / External API / etc.]
**Operation**: [Read / Write / Update / Delete]
**Target**: [table/file/endpoint]

### Persistence Code
```typescript
[The persistence code]
```

Use **Display Template** from `council-validation.md` to show: Verification

### Step 6: Trace Layer 9-10 (Response → UI Update)

Use **Display Template** from `council-validation.md` to show: Layer 9-10: Response to UI

```typescript
[The state update code]
```

Use **Display Template** from `council-validation.md` to show: Verification

### Step 7: Generate Data Flow Map

```markdown
## Complete Data Flow Map

### Visual Flow
```
[UI Element]
    │ [event type]
    ↓
[Handler Function] @ [file:line]
    │ calls
    ↓
[window.electronAPI.xxx.yyy()] @ [file:line]
    │ via
    ↓
[ipcRenderer.invoke('channel-name')] @ [preload:line]
    │ IPC
    ↓
[ipcMain.handle('channel-name')] @ [main:line]   ← CHANNEL MATCH: Yes/No
    │ calls
    ↓
[ServiceClass.method()] @ [service:line]
    │ persists to
    ↓
[Database/Config/API] @ [persistence:line]
    │ returns
    ↓
[Response flows back through chain]
    │ updates
    ↓
[UI State] → [Component Re-render]
```

### Layer Status Summary

| Layer | Status | Issue (if any) |
|-------|--------|----------------|
| 1. UI Event | ✅/❌ | [Issue] |
| 2. Handler | ✅/❌ | [Issue] |
| 3. API Call | ✅/❌ | [Issue] |
| 4. Preload Bridge | ✅/❌ | [Issue] |
| 5. IPC Channel | ✅/❌ | [Issue] |
| 6. Main Handler | ✅/❌ | [Issue] |
| 7. Service Layer | ✅/❌ | [Issue] |
| 8. Persistence | ✅/❌ | [Issue] |
| 9. Response | ✅/❌ | [Issue] |
| 10. UI Update | ✅/❌ | [Issue] |

### Break Points Identified

| Layer | Issue | Root Cause | Fix Required |
|-------|-------|------------|--------------|
| [Layer #] | [What's broken] | [Why] | [How to fix] |
```

### Step 8: Create Gap/Correction Entries

```
/validate-data-flow "save settings button"
/validate-data-flow "theme toggle"
/validate-data-flow "login form submit"
/validate-data-flow "file open action"
```

## Integration Points

This workflow is called by:
- `/validate-e2e-test` when a test fails
- `/validate-ui-action` for deep analysis
- `/validate-persistence` for persistence issues

## Common Break Points

| Rank | Layer | Frequency | Typical Fix |
|------|-------|-----------|-------------|
| 1 | IPC Channel (5-6) | Very High | Match channel names |
| 2 | Handler Registration | High | Register before app ready |
| 3 | Persistence Write | High | Add missing write call |
| 4 | API Not Exposed | Medium | Add to preload contextBridge |
| 5 | Event Not Bound | Medium | Wire up event handler |
