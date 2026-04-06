---
name: targeted-correction
description: Systematic defect correction with before/after evidence. Use during Validation C1 phase.
---

# Targeted Correction

Methodical approach to fixing defects with verification.

## When to use this skill

- Validation Track C1 (Targeted Corrections)
- Fixing audit defects
- Implementing corrections

## Correction Protocol

### Before Starting Any Fix:

1. **Understand the defect**
   - Read defect description
   - Reproduce the issue
   - Identify root cause

2. **Capture "before" state**
   - Screenshot the current behavior
   - Save to `council-state/validation/screenshots/DEF-XXX-before.png`

3. **Plan the fix**
   - Identify files to change
   - Consider side effects
   - Check for related code

### Implementing the Fix:

1. **Make minimal changes**
   - Fix only what's broken
   - Don't refactor unrelated code
   - Keep changes focused

2. **Follow existing patterns**
   - Match code style
   - Use existing utilities
   - Maintain consistency

3. **Add guards if needed**
   - Input validation
   - Null checks
   - Error handling

### After the Fix:

1. **Capture "after" state**
   - Screenshot the fixed behavior
   - Save to `council-state/validation/screenshots/DEF-XXX-after.png`

2. **Run 8-layer verification**
   - UI renders correctly
   - Events bind properly
   - Frontend validation works
   - API request/response correct
   - Backend processes correctly
   - Service integration works
   - Data persists correctly
   - Survives page restart

3. **Update defect log**
   - Mark as Fixed
   - Document the fix applied
   - Link before/after screenshots

## Evidence Template

```markdown
### DEF-XXX: [Title]

**Status**: Fixed

**Before**: ![Before](screenshots/DEF-XXX-before.png)

**Fix Applied**:
[Description of what was changed]

**Files Modified**:
- `path/to/file.ts`: [what changed]

**After**: ![After](screenshots/DEF-XXX-after.png)

**Verification**:
- [x] UI renders correctly
- [x] Events bind properly
- [x] Frontend validation works
- [x] API request/response correct
- [x] Backend processes correctly
- [x] Service integration works
- [x] Data persists correctly
- [x] Survives page restart
```
