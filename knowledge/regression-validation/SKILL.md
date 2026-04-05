name: regression-validation
description: Ensure corrections and code changes don't break existing functionality. Use during Validation Council Gate C4, after applying corrections, when running regression test suites, or when verifying that fixes in one area haven't introduced defects elsewhere.

# Regression Validation

Ensure corrections don't break existing functionality.

## Purpose

Every fix has regression potential. Systematic regression testing catches breakage before it reaches users.

## Regression Risk Assessment

### Risk Levels
| Level | Criteria | Testing Required |
|-------|----------|------------------|
| **Low** | Isolated change, no shared dependencies | Targeted tests |
| **Medium** | Touches shared code, has dependencies | Related module tests |
| **High** | Core functionality, many dependents | Full test suite |
| **Critical** | Authentication, data, payments | Full suite + manual |

### Risk Indicators
```markdown
Low Risk:
- Change is in leaf function
- No other code depends on it
- Change is additive, not modification

Medium Risk:
- Change is in shared utility
- 2-5 components depend on it
- Interface unchanged, implementation modified

High Risk:
- Change is in core business logic
- Many components depend on it
- Interface or behavior modified

Critical Risk:
- Change affects authentication
- Change affects data persistence
- Change affects financial transactions
```

## Regression Testing Process

### Step 1: Assess Regression Risk
```markdown
## Regression Risk Assessment: COR-XXX

**Change Description**: [What was changed]

**Files Modified**:
| File | Risk Level | Dependents |
|------|------------|------------|
| `file.ts` | [Level] | [List] |

**Overall Risk**: [Low/Medium/High/Critical]

**Testing Strategy**: [Targeted/Related/Full/Full+Manual]
```

### Step 2: Identify Affected Areas
```markdown
## Affected Areas

### Direct Dependencies
Components that directly use changed code:
- [Component 1]: `path/to/component1.ts`
- [Component 2]: `path/to/component2.ts`

### Indirect Dependencies
Components that use the direct dependencies:
- [Component 3] via [Component 1]

### Shared Resources
- Database tables: [List]
- API endpoints: [List]
- Configuration: [List]

### User Flows
| Flow | Uses Changed Code | Test |
|------|------------------|------|
| [User flow 1] | Yes | E2E Test X |
| [User flow 2] | Indirect | E2E Test Y |
```

### Step 3: Run Regression Suite
```markdown
## Regression Test Execution

### Test Suite Selection
- [x] Unit tests for modified files
- [x] Unit tests for direct dependents
- [x] Integration tests for affected modules
- [ ] Full test suite (if high risk)
- [ ] E2E tests for affected flows

### Execution

**Command**: `npm test`

**Output**:
```
Test Suites: 24 passed, 24 total
Tests:       156 passed, 156 total
Snapshots:   12 passed, 12 total
Time:        4.532s
```

**Result**: [All Pass / Failures Found]
```

### Step 4: Verify Related Features
```markdown
## Related Feature Verification

| Feature | Relation | Test Type | Result |
|---------|----------|-----------|--------|
| [Feature 1] | Direct dependency | Automated | Pass |
| [Feature 2] | Shared data | Manual | Pass |
| [Feature 3] | Same module | Automated | Pass |

### Manual Verification Steps
1. [Step 1]: [Expected result] - [Actual result] - [Pass/Fail]
2. [Step 2]: [Expected result] - [Actual result] - [Pass/Fail]
```

### Step 5: Document Results
```markdown
## Regression Validation Results

**Correction**: COR-XXX
**Risk Level**: [Level]
**Testing Strategy**: [Strategy used]

### Test Results
| Suite | Tests | Passed | Failed |
|-------|-------|--------|--------|
| Unit | 120 | 120 | 0 |
| Integration | 30 | 30 | 0 |
| E2E | 6 | 6 | 0 |

### Related Features
| Feature | Result |
|---------|--------|
| [Feature 1] | Verified |
| [Feature 2] | Verified |

### Regressions Found
[None / List with details]

### Conclusion
[Statement on regression status]
```

## Handling Found Regressions

### Step 1: Document Regression
```markdown
## Regression Found

**Discovered**: During COR-XXX regression testing
**Test**: [Test name that failed]

**Symptom**: [What's broken]
**Expected**: [What should happen]
**Actual**: [What happens now]

**Location**: `path/file.ts:line`
```

### Step 2: Analyze Cause
```markdown
## Regression Analysis

**Caused By**: COR-XXX change to [specific thing]

**Chain of Effect**:
1. Changed [X] in `file.ts`
2. This affected [Y] in `other.ts`
3. Which broke [Z] in `affected.ts`

**Fix Options**:
1. Revert COR-XXX and find alternative approach
2. Extend COR-XXX to handle this case
3. Fix the regression separately
```

### Step 3: Resolve
```markdown
## Regression Resolution

**Approach**: [Option chosen]

**Additional Changes**:
| File | Change |
|------|--------|
| `file.ts` | [Change] |

**Verification**:
- Original fix still works: [Yes/No]
- Regression fixed: [Yes/No]
- New tests added: [Yes/No]
```

## Regression Test Patterns

### Pattern: Snapshot Testing
```typescript
it('should maintain expected output format', () => {
  const result = component.render();
  expect(result).toMatchSnapshot();
});
```

### Pattern: Contract Testing
```typescript
it('should maintain API contract', () => {
  const response = api.getUser(123);
  expect(response).toMatchObject({
    id: expect.any(Number),
    name: expect.any(String),
    email: expect.stringMatching(/@/),
  });
});
```

### Pattern: Behavioral Testing
```typescript
describe('Regression: User creation', () => {
  it('should still create users with all fields', async () => {
    const user = await createUser(validData);
    expect(user.id).toBeDefined();
    expect(user.createdAt).toBeDefined();
    expect(user.status).toBe('active');
  });
});
```

## Output Format

```markdown
# Regression Validation Report: COR-XXX

## Summary
- **Correction**: COR-XXX - [Description]
- **Risk Level**: [Level]
- **Test Strategy**: [Strategy]
- **Overall Result**: [Pass/Fail]

## Test Execution
| Suite | Run | Passed | Failed |
|-------|-----|--------|--------|
| Unit | 120 | 120 | 0 |
| Integration | 30 | 30 | 0 |
| E2E | 6 | 6 | 0 |

## Related Features
| Feature | Method | Result |
|---------|--------|--------|
| [Feature] | [Auto/Manual] | [Pass/Fail] |

## Regressions
[None found / List with resolution]

## Conclusion
[Final statement on regression status]
```

## Quality Checklist

- [ ] Risk level assessed
- [ ] Affected areas identified
- [ ] Appropriate test suite selected
- [ ] All tests executed
- [ ] Related features verified
- [ ] Regressions documented (if any)
- [ ] Regressions resolved (if any)
- [ ] Final status confirmed
