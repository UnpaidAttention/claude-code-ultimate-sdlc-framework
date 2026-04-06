---
name: eight-layer-verification
description: 8-layer runtime verification protocol for validating corrections across UI, Event, Frontend, API, Backend, Service, Persistence, and Restart layers. Use after any code fix, during Validation Council correction verification, or when proving corrections work end-to-end.
---

# 8-Layer Runtime Verification Procedure

## Purpose

Every correction in Validation Council must be verified through all 8 layers. This document specifies exactly how to verify each layer.


## Layer Overview

```
┌─────────────────────────────────────────────────────────────┐
│ Layer 8: RESTART       - Data survives application restart  │
├─────────────────────────────────────────────────────────────┤
│ Layer 7: PERSISTENCE   - Data correctly saved to storage    │
├─────────────────────────────────────────────────────────────┤
│ Layer 6: SERVICE       - Business logic executes correctly  │
├─────────────────────────────────────────────────────────────┤
│ Layer 5: BACKEND       - Backend handler processes request  │
├─────────────────────────────────────────────────────────────┤
│ Layer 4: API/IPC       - Request crosses client/server      │
├─────────────────────────────────────────────────────────────┤
│ Layer 3: FRONTEND      - Frontend logic processes correctly │
├─────────────────────────────────────────────────────────────┤
│ Layer 2: EVENT         - Event handler fires correctly      │
├─────────────────────────────────────────────────────────────┤
│ Layer 1: UI            - Visual element renders correctly   │
└─────────────────────────────────────────────────────────────┘
```


## Layer-by-Layer Verification

### Layer 1: UI Interaction

**What to verify**: Visual element renders correctly, is interactive

**Verification method**:
1. Navigate to the affected UI element
2. Capture screenshot showing element in expected state
3. Verify element is visible and properly styled
4. If interactive: verify hover/focus states work

**Evidence required**:
- Screenshot: `screenshots/CORRECTION-XXX-L1-ui.png`
- Description: What the UI should show

**Pass criteria**:
- [ ] Element is visible
- [ ] Element has correct styling
- [ ] Element is in correct position
- [ ] Screenshot captured and saved

**Test command** (if automated):
```bash
# Playwright/Puppeteer example
await expect(page.locator('[data-testid="element"]')).toBeVisible()
await page.screenshot({ path: 'screenshots/CORRECTION-XXX-L1-ui.png' })
```


### Layer 2: Event Handler

**What to verify**: Event triggers and handler executes

**Pass criteria**:
- [ ] Event listener is attached
- [ ] Handler function is called on trigger
- [ ] Correct event data passed to handler
- [ ] No errors thrown in handler


### Layer 3: Frontend Logic

**What to verify**: Frontend state/logic updates correctly

**Pass criteria**:
- [ ] State updates to expected value
- [ ] Derived/computed values correct
- [ ] No stale state issues
- [ ] Re-renders happen as expected


### Layer 4: API/IPC Bridge

**What to verify**: Request sent correctly, response handled

**Pass criteria**:
- [ ] Correct HTTP method used
- [ ] Correct endpoint called
- [ ] Request body/params correct
- [ ] Response status as expected
- [ ] Response body parsed correctly


### Layer 5: Backend Handler

**What to verify**: Backend receives and processes request

**Pass criteria**:
- [ ] Request received by server
- [ ] Request validation passes
- [ ] Correct handler invoked
- [ ] Handler calls correct service methods


### Layer 6: Service Logic

**What to verify**: Business logic executes correctly

**Pass criteria**:
- [ ] Service function called with correct args
- [ ] Business rules applied correctly
- [ ] Edge cases handled
- [ ] Correct result returned


### Layer 7: Persistence

**What to verify**: Data correctly saved to storage

**Pass criteria**:
- [ ] Data written to correct table/collection
- [ ] All fields have correct values
- [ ] Relationships/foreign keys correct
- [ ] No orphaned records


### Layer 8: Restart Survival

**What to verify**: Data persists across application restart

**Pass criteria**:
- [ ] Application stops cleanly
- [ ] Application restarts successfully
- [ ] Data visible after restart
- [ ] Data values match pre-restart state


## Verification Checklist Template

Copy this for each correction:

```markdown
## 8-Layer Verification: CORRECTION-XXX

**Defect**: [Brief description]
**Fix Applied**: [What was changed]

| Layer | Description | Status | Evidence |
|-------|-------------|--------|----------|
| L1: UI | Element renders correctly | [ ] PASS | [screenshot link] |
| L2: Event | Handler fires on trigger | [ ] PASS | [test/log link] |
| L3: Frontend | State updates correctly | [ ] PASS | [test/screenshot link] |
| L4: API/IPC | Request/response correct | [ ] PASS | [network/test link] |
| L5: Backend | Handler processes request | [ ] PASS | [log/test link] |
| L6: Service | Business logic correct | [ ] PASS | [test link] |
| L7: Persist | Data saved correctly | [ ] PASS | [query/test link] |
| L8: Restart | Data survives restart | [ ] PASS | [screenshot/test link] |
```

## Layer Applicability

| Correction Type | Required Layers |
|-----------------|-----------------|
| UI-only (styling, layout) | L1 only |
| Frontend logic | L1, L2, L3 |
| API integration | L1-L5 |
| Data persistence | L1-L7 |
| Full stack with persistence | ALL 8 layers |

**Rule**: When in doubt, verify more layers, not fewer.
