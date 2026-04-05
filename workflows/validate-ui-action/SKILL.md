---
name: validate-ui-action
description: |
  Verify individual UI elements actually perform their intended actions
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/ui-action-verification/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/evidence-capture/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/runtime-verification/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/edge-case-handling/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# Workflow: validate-ui-action

---

## Lens / Skills / Model
**Lens**: `[UX]` | **Model**: Claude Sonnet 4
> Apply session protocol per `council-validation.md`
---

> Trigger: `/validate-ui-action [element-type] [element-name]` or "Verify [button/toggle/etc] works"

## Description

Verifies that individual UI elements (buttons, toggles, checkboxes, inputs, selects) actually perform their intended backend actions. This is a focused workflow for testing specific interactive elements.

## Why This Workflow Exists

The most common false-positive in AI validation:
- "The button exists" ✓
- "The button has an onClick handler" ✓
- "The handler calls a function" ✓
- **"But clicking it does nothing"** ✗

This workflow requires PHYSICAL INTERACTION with the UI element and VERIFICATION of the actual effect.

## UI Element Categories

| Category | Elements | Expected Behavior |
|----------|----------|-------------------|
| **Action** | Buttons, Links | Trigger operation, navigate |
| **Toggle** | Switches, Checkboxes | Change boolean state |
| **Input** | Text fields, Numbers | Accept and validate input |
| **Select** | Dropdowns, Radio | Choose from options |
| **Form** | Forms | Collect and submit data |
| **File** | File pickers | Select files/folders |

## Pre-Conditions

- [ ] Application is running
- [ ] UI element is visible and accessible
- [ ] Console/DevTools available for inspection
- [ ] Expected behavior is documented

## Steps

### Step 1: Identify and Document Element

Use **Display Template** from `council-validation.md` to show: UI Element Analysis: [Element Name]tsx
[The element JSX/HTML code]
```

### Event Binding
**Event Type**: [onClick / onChange / onSubmit / etc.]
**Handler**: [Handler function name]
**Handler Location**: [file:line]
```

### Step 2: Document Expected Behavior

Use **Display Template** from `council-validation.md` to show: Expected Behavior: [Element Name]

### Step 3: Perform Action and Capture Evidence

Use **Display Template** from `council-validation.md` to show: Action Execution: [Element Name]
[Any console logs during action]
```

#### Network Activity (if applicable)
**Request Made**: Yes / No
**Endpoint**: [URL if request made]
**Payload**: [Request body]
**Response**: [Response received]
```

### Step 4: Verify Backend Effect

Use **Display Template** from `council-validation.md` to show: Backend Verification: [Element Name]
[Relevant console output]
```

#### Storage/Database State
**Location**: [Where to check]
**State BEFORE Action**:
```
[State before]
```

**State AFTER Action**:
```
[State after]
```

#### API Evidence (if applicable)
**Request**:
```json
[Request details]
```

**Response**:
```json
[Response details]
```

### Backend Effect Result
**Effect Occurred**: Yes / No / Partial
**Data Correct**: Yes / No
**Evidence**: [What proves it]
```

### Step 5: Test Error Handling

Use **Display Template** from `council-validation.md` to show: Error Handling Verification: [Element Name]

### Step 6: Test Edge Cases

Use **Display Template** from `council-validation.md` to show: Edge Case Testing: [Element Name]

### Step 7: Generate Element Verification Report

Use **Display Template** from `council-validation.md` to show: UI Element Verification Report: [Element Name]

## Element-Specific Checklists

### Button Verification
- [ ] Button visible and enabled
- [ ] Click produces visual feedback
- [ ] Handler function is called
- [ ] Intended action occurs
- [ ] Loading state shown (if async)
- [ ] Success/error feedback shown
- [ ] Disabled during operation (if needed)
- [ ] Re-enabled after completion

### Toggle/Checkbox Verification
- [ ] Initial state correct
- [ ] State changes on click/toggle
- [ ] Visual change matches state
- [ ] State persisted to backend
- [ ] State survives refresh
- [ ] State survives restart
- [ ] Cannot be toggled when disabled

### Input Field Verification
- [ ] Accepts valid input
- [ ] Validates invalid input
- [ ] Shows validation errors
- [ ] Value accessible programmatically
- [ ] Value submitted correctly
- [ ] Handles paste correctly
- [ ] Respects max length

### Select/Dropdown Verification
- [ ] Options load correctly
- [ ] Selection changes value
- [ ] Selected option shown
- [ ] Value submitted correctly
- [ ] Default value correct
- [ ] Handles no options gracefully

### Form Verification
- [ ] All fields accessible
- [ ] Validation runs on submit
- [ ] Invalid fields highlighted
- [ ] Submit disabled during submission
- [ ] Success feedback shown
- [ ] Error feedback shown
- [ ] Form data reaches backend
- [ ] Data persisted correctly

## Artifacts Generated

- **Element Screenshot**: Highlighted element
- **Before/After Screenshots**: State change evidence
- **Console Log Artifact**: Execution evidence
- **Network Artifact**: API call evidence
- **Element Report Artifact**: Complete verification

## Usage

```
/validate-ui-action button "Save Settings"
/validate-ui-action toggle "Dark Mode"
/validate-ui-action checkbox "Remember Me"
/validate-ui-action input "API Key Field"
/validate-ui-action select "Theme Selector"
/validate-ui-action form "Login Form"
/validate-ui-action all                    # Verify all interactive elements
```

## Common Failure Patterns

| Element | Failure | Typical Cause |
|---------|---------|---------------|
| Button | No effect | Handler not bound |
| Button | Works once, then stops | State not reset |
| Toggle | UI changes, backend doesn't | Missing API call |
| Toggle | Reverts on refresh | Not persisted |
| Input | Value not submitted | Wrong form binding |
| Select | Options empty | Data not loaded |
| Form | Submit does nothing | Event not prevented, no handler |

## Integration with Other Workflows

```
/validate-ui-action [element]
    │
    │ If backend not called:
    ↓
/validate-data-flow [element]  ← Trace the break
    │
    │ If state not persisted:
    ↓
/validate-persistence [related-setting]  ← Check storage
```
