name: correction-planning
description: Create prioritized correction plans for identified defects and gaps. Use during Validation Council C1-C2 phases, when triaging audit defects, planning fix implementation order, estimating correction effort, and establishing verification criteria for each fix.

# Correction Planning

Create prioritized, verified correction plans for identified gaps.

## Purpose

Transform gap analysis into actionable correction plan with verification criteria.

## Planning Process

### Step 1: Consolidate Gaps
```markdown
## Gap Consolidation

| Gap ID | Category | Severity | Feature | Description |
|--------|----------|----------|---------|-------------|
| GAP-001 | Functional | Critical | [Feature] | [Description] |
| GAP-002 | Security | High | [Feature] | [Description] |
```

### Step 2: Analyze Dependencies
```markdown
## Dependency Analysis

### Gap Dependencies
| Gap | Depends On | Blocking |
|-----|-----------|----------|
| GAP-001 | None | GAP-003, GAP-004 |
| GAP-002 | GAP-001 | None |

### Correction Sequence
1. GAP-001 (no dependencies, blocks others)
2. GAP-003 (depends on GAP-001)
3. GAP-004 (depends on GAP-001)
4. GAP-002 (depends on GAP-001)
```

### Step 3: Verify Prerequisites
```markdown
## Prerequisite Verification

### GAP-001: [Title]
| Prerequisite | Required | Available | Action if Missing |
|--------------|----------|-----------|-------------------|
| API endpoint X | Yes | Yes | - |
| Database column Y | Yes | No | Create migration |
| Service Z | Yes | Yes | - |

**Status**: [Ready / Blocked]
**Blockers**: [List if any]
```

### Step 4: Design Corrections
```markdown
## Correction Design

### COR-001: Fix for GAP-001
**Gap**: [Gap description]
**Root Cause**: [Actual cause]

**Correction Approach**:
[Describe the minimal change to fix the root cause]

**Files to Change**:
| File | Change Type | Description |
|------|-------------|-------------|
| `path/to/file.ts` | Modify | [What to change] |

**NOT Doing**:
- [What we're explicitly not changing]
- [Scope limits]

**Risk Assessment**:
- Regression risk: [Low/Medium/High]
- Affected components: [List]
- Rollback possible: [Yes/No]
```

### Step 5: Define Verification
```markdown
## Verification Criteria

### COR-001 Verification
**Verification Type**: [Unit Test / Integration Test / Manual / E2E]

**Test Specification**:
```[language]
describe('GAP-001 fix', () => {
  it('should [expected behavior]', () => {
    // Arrange
    // Act
    // Assert
  });
});
```

**Success Criteria**:
- [ ] Original symptom no longer occurs
- [ ] New test passes
- [ ] Existing tests still pass
- [ ] No console errors
- [ ] [Feature-specific criteria]

**Regression Scope**:
| Component | Risk | Test |
|-----------|------|------|
| [Component] | [Level] | [Test to run] |
```

### Step 6: Prioritize Corrections
```markdown
## Priority Matrix

| Priority | Correction | Gap | Severity | Effort | Dependencies |
|----------|------------|-----|----------|--------|--------------|
| 1 | COR-001 | GAP-001 | Critical | Low | None |
| 2 | COR-002 | GAP-002 | High | Medium | COR-001 |
| 3 | COR-003 | GAP-003 | High | High | None |

### Priority Criteria
- Critical severity → Priority 1
- High severity + Low effort → Priority 2
- High severity + Dependencies resolved → Priority 3
- Medium severity → Priority 4+

### Grouping for Efficiency
**Batch 1** (No dependencies):
- COR-001, COR-003

**Batch 2** (After Batch 1):
- COR-002

**Batch 3** (After Batch 2):
- COR-004, COR-005
```

### Step 7: Estimate Effort
```markdown
## Effort Estimation

| Correction | Complexity | Files | Tests | Effort |
|------------|------------|-------|-------|--------|
| COR-001 | Low | 1 | 1 | Small |
| COR-002 | Medium | 3 | 2 | Medium |
| COR-003 | High | 5+ | 3+ | Large |

### Effort Definitions
- **Small**: < 30 minutes, 1-2 files, straightforward
- **Medium**: 30-120 minutes, 2-4 files, some complexity
- **Large**: 2+ hours, 5+ files, significant complexity
```

## Output Format

```markdown
# Correction Plan: [Feature/Component]

## Summary
- **Total Gaps**: [X]
- **Critical**: [X]
- **High**: [X]
- **Medium**: [X]
- **Total Corrections**: [X]
- **Blocked**: [X]

## Correction Schedule

### Batch 1 - Immediate (No Dependencies)
| ID | Gap | Description | Effort | Prerequisites |
|----|-----|-------------|--------|---------------|
| COR-001 | GAP-001 | [desc] | Small | Ready |

### Batch 2 - After Batch 1
| ID | Gap | Description | Effort | Prerequisites |
|----|-----|-------------|--------|---------------|
| COR-002 | GAP-002 | [desc] | Medium | COR-001 |

## Detailed Correction Plans

### COR-001: [Title]
**Gap**: GAP-001 - [Brief description]
**Severity**: Critical
**Root Cause**: [Cause]

**Approach**:
[Minimal change description]

**Changes**:
| File | Change |
|------|--------|
| `file.ts:line` | [Change] |

**Verification**:
- Test: [Test name/type]
- Success: [Criteria]

**Regression Check**:
- Run: [Tests to run]
- Components: [Affected components]

---

[Repeat for each correction]

## Prerequisites Status
| Prerequisite | Required For | Status | Action |
|--------------|--------------|--------|--------|
| [Prereq] | COR-001 | Ready | - |
| [Prereq] | COR-002 | Missing | [Action] |

## Risks
| Risk | Impact | Mitigation |
|------|--------|------------|
| [Risk] | [Impact] | [Mitigation] |

## Next Steps
1. [First correction to implement]
2. [Second correction to implement]
```

## Quality Checklist

- [ ] All gaps have corresponding corrections
- [ ] Dependencies mapped
- [ ] Prerequisites verified
- [ ] Each correction has verification criteria
- [ ] Priority based on severity and dependencies
- [ ] Effort estimated
- [ ] Risks identified
- [ ] Batches organized efficiently
