---
name: runtime-verification
description: 8-layer runtime verification protocol for validating corrections. Use after any code fix.
---

# Runtime Verification

Comprehensive 8-layer verification for all corrections.

## When to use this skill

- After implementing any fix (C1-C4)
- Verifying corrections work end-to-end
- Preventing surface-level fixes

## The 8 Layers

### Layer 1: UI Render
- Does the component display correctly?
- Are all elements visible?
- Is styling correct?

### Layer 2: Event Binding
- Do buttons respond to clicks?
- Do forms capture input?
- Do keyboard shortcuts work?

### Layer 3: Frontend Validation
- Are required fields enforced?
- Do format validations work?
- Are error messages shown?

### Layer 4: API Request/Response
- Is the request sent correctly?
- Are parameters correct?
- Does response parse correctly?

### Layer 5: Backend Processing
- Does business logic execute?
- Are transformations correct?
- Are calculations accurate?

### Layer 6: Service Integration
- Do services communicate?
- Are external calls made?
- Do callbacks fire?

### Layer 7: Data Persistence
- Is data saved to database?
- Can data be retrieved?
- Are relationships correct?

### Layer 8: Full Page Restart
- Does the fix survive page refresh?
- Is state restored correctly?
- No runtime errors on reload?

## Verification Checklist

```markdown
## Verification: DEF-XXX

- [ ] Layer 1: UI renders correctly
- [ ] Layer 2: Events bind and fire
- [ ] Layer 3: Frontend validation works
- [ ] Layer 4: API request/response correct
- [ ] Layer 5: Backend processes correctly
- [ ] Layer 6: Services integrate properly
- [ ] Layer 7: Data persists correctly
- [ ] Layer 8: Survives page restart
```

## Why All 8 Layers?

Surface-level fixes often:
- Look correct in UI but don't persist
- Work until page refresh
- Pass frontend but fail backend
- Save data but break retrieval

All 8 layers ensure the fix is complete.

## When a Layer Fails

1. Stop verification
2. Investigate the failing layer
3. Fix the root cause
4. Restart verification from Layer 1
5. All layers must pass
