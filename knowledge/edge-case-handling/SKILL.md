name: edge-case-handling
description: Systematically identify and handle unusual inputs, boundary conditions, and unexpected scenarios. Use during Audit Council quality assessment, when cataloguing edge cases, designing defensive error handling, or validating robustness beyond happy-path testing.

# Edge Case Handling

Systematically identify and handle unusual inputs and scenarios.

## Purpose

Edge cases are where software breaks. Systematically find and handle them before users do.

## Edge Case Categories

### Input Edge Cases
- Empty/null/undefined
- Maximum/minimum values
- Boundary values (just above/below limits)
- Special characters
- Unicode/emoji
- Very long strings
- Negative numbers
- Zero values

### State Edge Cases
- Not authenticated
- Expired session
- Concurrent modifications
- Stale data
- Partial state

### Timing Edge Cases
- Race conditions
- Timeouts
- Slow responses
- Rapid repeated actions
- Interrupted operations

### Resource Edge Cases
- Network failure
- Disk full
- Memory exhaustion
- Service unavailable
- Rate limited

### Data Edge Cases
- Missing data
- Duplicate data
- Corrupted data
- Invalid references
- Circular references

## Identification Process

### Step 1: Map Feature Inputs
```markdown
## Feature: [Name]

### Inputs
| Input | Type | Valid Range | Notes |
|-------|------|-------------|-------|
| [Input 1] | [Type] | [Range] | |
| [Input 2] | [Type] | [Range] | |
```

### Step 2: Generate Edge Cases
```markdown
## Edge Case Matrix

### Input: [Input Name]
| Edge Case | Value | Expected Handling |
|-----------|-------|-------------------|
| Empty | "" | [How to handle] |
| Null | null | [How to handle] |
| Max value | [Max] | [How to handle] |
| Min value | [Min] | [How to handle] |
| Just above max | [Max+1] | [How to handle] |
| Just below min | [Min-1] | [How to handle] |
| Special chars | [Examples] | [How to handle] |
```

### Step 3: Check Current Handling
```markdown
## Current Edge Case Handling

| Edge Case | Currently Handled | How | Status |
|-----------|------------------|-----|--------|
| [Case 1] | [Yes/No] | [Implementation] | [OK/Needs Work] |
| [Case 2] | [Yes/No] | [Implementation] | [OK/Needs Work] |
```

### Step 4: Implement Handlers
```markdown
## Edge Case Implementation

### Edge Case: [Description]
**Input**: [What triggers this]
**Current Behavior**: [What happens now]
**Expected Behavior**: [What should happen]

**Implementation**:
```typescript
// Before
function processInput(value) {
  return value.toUpperCase(); // Crashes on null
}

// After
function processInput(value) {
  if (value == null || value === '') {
    return ''; // Handle empty/null gracefully
  }
  return value.toUpperCase();
}
```

**Test**:
```typescript
it('should handle null input', () => {
  expect(processInput(null)).toBe('');
});
```
```

### Step 5: Test Edge Cases
```markdown
## Edge Case Tests

| Edge Case | Test | Result |
|-----------|------|--------|
| Empty input | `test('empty input')` | [Pass/Fail] |
| Null input | `test('null input')` | [Pass/Fail] |
| Max value | `test('max value')` | [Pass/Fail] |
```

## Common Edge Case Patterns

### Pattern: Null/Undefined Check
```typescript
// Handle null/undefined at entry point
function process(input: string | null | undefined): Result {
  if (input == null) {
    return defaultResult;
  }
  // Safe to use input
}
```

### Pattern: Boundary Validation
```typescript
// Validate boundaries explicitly
function setAge(age: number): void {
  if (age < 0 || age > 150) {
    throw new ValidationError('Age must be between 0 and 150');
  }
  this.age = age;
}
```

### Pattern: Empty Collection Handling
```typescript
// Handle empty arrays/objects
function getFirst(items: Item[]): Item | undefined {
  if (!items || items.length === 0) {
    return undefined;
  }
  return items[0];
}
```

### Pattern: Timeout Handling
```typescript
// Add timeout to async operations
async function fetchWithTimeout(url: string, timeout = 5000) {
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), timeout);

  try {
    return await fetch(url, { signal: controller.signal });
  } finally {
    clearTimeout(timeoutId);
  }
}
```

### Pattern: Concurrent Modification Check
```typescript
// Use version/timestamp for optimistic locking
async function update(id: string, data: Data, version: number) {
  const current = await getById(id);
  if (current.version !== version) {
    throw new ConcurrencyError('Data was modified');
  }
  await save({ ...data, version: version + 1 });
}
```

## Output Format

```markdown
# Edge Case Analysis: [Feature]

## Summary
- **Total Edge Cases**: [X]
- **Currently Handled**: [X]
- **Needs Implementation**: [X]

## Edge Cases by Category

### Input Edge Cases
| Edge Case | Status | Implementation |
|-----------|--------|----------------|
| [Case] | [Handled/Needs Work] | [Details] |

### State Edge Cases
| Edge Case | Status | Implementation |
|-----------|--------|----------------|
| [Case] | [Handled/Needs Work] | [Details] |

### Timing Edge Cases
| Edge Case | Status | Implementation |
|-----------|--------|----------------|
| [Case] | [Handled/Needs Work] | [Details] |

## Implementation Details

### [Edge Case Name]
**Before**: [Current behavior]
**After**: [Implemented handling]
**Test**: [Test that verifies]

## Test Coverage
| Edge Case | Test | Status |
|-----------|------|--------|
| [Case] | [Test name] | [Pass/Fail] |

## Conclusion
[Summary of edge case coverage]
```

## Quality Checklist

- [ ] All inputs identified
- [ ] Edge cases enumerated
- [ ] Current handling assessed
- [ ] Missing handlers implemented
- [ ] Tests written for each edge case
- [ ] All edge case tests pass
