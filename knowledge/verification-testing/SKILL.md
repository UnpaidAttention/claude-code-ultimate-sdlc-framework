name: verification-testing
description: Systematic verification testing protocol for confirming fixes and validating code changes. Use when running gate verifications, testing corrections, confirming regression fixes, or proving that corrections work across unit, integration, E2E, and visual verification layers.

# Verification Testing

Write and execute tests that prove corrections work.

## Purpose

Every correction needs proof. Verification tests provide that proof.

## Verification Test Types

### 1. Unit Verification
Tests a specific function/method in isolation.

```typescript
describe('Fix: [Issue description]', () => {
  it('should [expected behavior]', () => {
    const result = functionUnderTest(input);
    expect(result).toBe(expectedOutput);
  });
});
```

### 2. Integration Verification
Tests interaction between components.

```typescript
describe('Fix: [Issue description]', () => {
  it('should [expected behavior] when components interact', async () => {
    const service = new Service();
    const result = await service.performOperation();
    expect(result.status).toBe('success');
  });
});
```

### 3. E2E Verification
Tests complete user flow.

```typescript
describe('Fix: [Issue description]', () => {
  it('should [expected behavior] for user', async () => {
    await page.goto('/feature');
    await page.click('[data-testid="button"]');
    await expect(page.locator('.result')).toBeVisible();
  });
});
```

### 4. Regression Prevention
Tests that issue doesn't recur.

```typescript
describe('Regression: [Issue description]', () => {
  it('should NOT [previous broken behavior]', () => {
    // Arrange - set up condition that previously caused bug
    // Act - trigger the scenario
    // Assert - verify bug doesn't occur
  });
});
```

## Test Design Process

### Step 1: Understand the Fix
```markdown
**Correction**: COR-XXX
**Gap**: GAP-XXX
**What was fixed**: [Description]
**Expected behavior now**: [What should happen]
**Previously broken behavior**: [What was wrong]
```

### Step 2: Identify Test Scenarios
```markdown
## Test Scenarios

### Happy Path
- Input: [valid input]
- Expected: [correct output]

### Edge Cases
- Empty input: [expected handling]
- Boundary value: [expected handling]
- Invalid input: [expected handling]

### Error Cases
- [Error condition]: [expected handling]

### Regression Case
- Condition that caused original bug: [verify it's fixed]
```

### Step 3: Write Test Code
```typescript
// File: tests/corrections/COR-XXX.test.ts

import { describe, it, expect, beforeEach } from 'vitest';
import { componentUnderTest } from '../src/component';

describe('COR-XXX: [Brief description]', () => {
  beforeEach(() => {
    // Setup
  });

  describe('Happy path', () => {
    it('should [expected behavior] when [condition]', () => {
      // Arrange
      const input = validInput;

      // Act
      const result = componentUnderTest(input);

      // Assert
      expect(result).toEqual(expectedOutput);
    });
  });

  describe('Edge cases', () => {
    it('should handle empty input', () => {
      const result = componentUnderTest('');
      expect(result).toEqual(emptyHandling);
    });

    it('should handle boundary values', () => {
      const result = componentUnderTest(maxValue);
      expect(result).toEqual(boundaryHandling);
    });
  });

  describe('Error handling', () => {
    it('should throw on invalid input', () => {
      expect(() => componentUnderTest(invalid))
        .toThrow('Expected error message');
    });
  });

  describe('Regression prevention', () => {
    it('should NOT [previous broken behavior]', () => {
      // This test specifically verifies the bug is fixed
      const bugTriggerInput = conditionThatCausedBug;
      const result = componentUnderTest(bugTriggerInput);
      expect(result).not.toEqual(previouslyBrokenOutput);
      expect(result).toEqual(correctOutput);
    });
  });
});
```

### Step 4: Execute Tests
```markdown
## Test Execution

**Command**: `npm test -- --grep "COR-XXX"`

**Output**:
```
 ✓ COR-XXX: [Brief description]
   ✓ Happy path
     ✓ should [expected behavior] when [condition] (3ms)
   ✓ Edge cases
     ✓ should handle empty input (1ms)
     ✓ should handle boundary values (1ms)
   ✓ Error handling
     ✓ should throw on invalid input (2ms)
   ✓ Regression prevention
     ✓ should NOT [previous broken behavior] (1ms)

Test Suites: 1 passed, 1 total
Tests:       5 passed, 5 total
```

**Result**: [Pass/Fail]
```

### Step 5: Document Verification
```markdown
## Verification Documentation

**Correction**: COR-XXX
**Test File**: `tests/corrections/COR-XXX.test.ts`
**Test Count**: 5

| Test | Type | Status |
|------|------|--------|
| Happy path | Unit | Pass |
| Empty input | Edge | Pass |
| Boundary values | Edge | Pass |
| Invalid input | Error | Pass |
| Regression | Regression | Pass |

**Verification Status**: Complete
**Evidence**: [Screenshot/log output]
```

## Test Quality Standards

### Good Verification Test
```typescript
// Clear, specific, proves the fix
it('should return user data when valid ID provided', () => {
  const user = getUserById('123');
  expect(user).toEqual({ id: '123', name: 'Test' });
});
```

### Bad Verification Test
```typescript
// Vague, doesn't prove anything
it('should work', () => {
  const result = doThing();
  expect(result).toBeTruthy();
});
```

### Required Test Qualities
- **Specific**: Tests exact scenario, not general behavior
- **Isolated**: Doesn't depend on external state
- **Deterministic**: Same result every time
- **Fast**: Runs quickly
- **Clear**: Failure message explains what's wrong

## Test Patterns

### Pattern: Before/After Comparison
```typescript
it('should fix [issue]', () => {
  // BEFORE: This would have failed/returned wrong result
  // const oldResult = oldImplementation(input);
  // expect(oldResult).toBe(wrongValue); // Would have been true

  // AFTER: Now returns correct result
  const result = newImplementation(input);
  expect(result).toBe(correctValue);
});
```

### Pattern: Error Recovery
```typescript
it('should recover from [error condition]', async () => {
  // Trigger error condition
  mockService.failOnce();

  // Should handle gracefully
  const result = await serviceUnderTest.perform();

  expect(result.status).toBe('recovered');
  expect(result.error).toBeUndefined();
});
```

### Pattern: Boundary Testing
```typescript
describe('Boundary conditions', () => {
  it('should handle minimum value', () => {
    expect(process(0)).toBe(minResult);
  });

  it('should handle maximum value', () => {
    expect(process(Number.MAX_SAFE_INTEGER)).toBe(maxResult);
  });

  it('should handle just below boundary', () => {
    expect(process(threshold - 1)).toBe(belowResult);
  });

  it('should handle just above boundary', () => {
    expect(process(threshold + 1)).toBe(aboveResult);
  });
});
```

## Output Format

```markdown
# Verification Test Report: COR-XXX

## Summary
- **Correction**: COR-XXX - [Description]
- **Test File**: `tests/corrections/COR-XXX.test.ts`
- **Tests Written**: [X]
- **Tests Passing**: [X]
- **Verification Status**: [Complete/Incomplete]

## Test Details

| # | Test Name | Type | Status | Time |
|---|-----------|------|--------|------|
| 1 | [Name] | [Type] | Pass | 3ms |
| 2 | [Name] | [Type] | Pass | 1ms |

## Coverage

- Happy path: Covered
- Edge cases: [X] of [Y] covered
- Error handling: Covered
- Regression: Covered

## Evidence

```
[Test output pasted here]
```

## Conclusion

[Statement that correction is verified working]
```

## Quality Checklist

- [ ] Test file created for correction
- [ ] Happy path tested
- [ ] Edge cases tested
- [ ] Error handling tested
- [ ] Regression case included
- [ ] All tests pass
- [ ] Tests are specific and clear
- [ ] Documentation complete
