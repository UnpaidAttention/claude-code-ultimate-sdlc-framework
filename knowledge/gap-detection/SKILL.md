description: Systematically compare intended functionality to actual implementation and identify all gaps. Covers gap detection methodology, completeness assessment, and gap classification for correction planning.

# Gap Detection

Systematically compare intent to implementation and identify all gaps.

## Purpose

Find every place where implementation diverges from intent. Gaps are correction targets.

## Gap Categories

### Functional Gaps
- Missing functionality
- Partial implementation
- Wrong behavior
- Incomplete flows

### Error Handling Gaps
- Missing error handlers
- Silent failures
- Unhelpful error messages
- Missing recovery

### Edge Case Gaps
- Unhandled boundaries
- Missing null checks
- Race condition exposure
- Timeout gaps

### Validation Gaps
- Missing input validation
- Incomplete sanitization
- Type coercion issues
- Range violations

### Security Gaps
- Missing authentication
- Insufficient authorization
- Injection vulnerabilities
- Exposure risks

### Performance Gaps
- Missing optimization
- N+1 queries
- Missing caching
- Blocking operations

## Detection Process

### Step 1: Load Intent
```markdown
Feature: [Name]
Intent Source: [reference to intent-map.md entry]

Key acceptance criteria:
1. [AC-001]
2. [AC-002]
...
```

### Step 2: Trace Implementation
```markdown
## Implementation Trace

**Entry Point**: [file:line]
**Code Path**: [description of flow]

### Function/Method Analysis
| Function | Purpose | Location |
|----------|---------|----------|
| [name] | [what it does] | file:line |

### Data Flow
Input → [transformation 1] → [transformation 2] → Output

### Error Paths
[Where errors are caught and handled]
```

### Step 3: Compare Point by Point
```markdown
## Point-by-Point Comparison

| AC ID | Intent | Implementation | Match |
|-------|--------|----------------|-------|
| AC-001 | [expected] | [actual] | Yes/No/Partial |
| AC-002 | [expected] | [actual] | Yes/No/Partial |
```

### Step 4: Document Each Gap
```markdown
## Gap: [GAP-XXX]

**Category**: [Functional/Error/Edge/Validation/Security/Performance]
**Severity**: [Critical/High/Medium/Low]

**Intent**: [What should happen]
**Actual**: [What actually happens]
**Impact**: [User/system impact]

**Location**: `file:line`

**Evidence**:
```[language]
// Code showing the gap
```

**Related Acceptance Criteria**: [AC-XXX]
```

### Step 5: Calculate Alignment Score
```markdown
## Alignment Score

| Category | Criteria Count | Met | Partial | Unmet | Score |
|----------|----------------|-----|---------|-------|-------|
| Functional | [X] | [X] | [X] | [X] | [X]% |
| Error Handling | [X] | [X] | [X] | [X] | [X]% |
| Edge Cases | [X] | [X] | [X] | [X] | [X]% |
| Validation | [X] | [X] | [X] | [X] | [X]% |
| Security | [X] | [X] | [X] | [X] | [X]% |
| Performance | [X] | [X] | [X] | [X] | [X]% |

**Overall Alignment**: [X]%

Scoring:
- Met = 100%
- Partial = 50%
- Unmet = 0%
```

### Step 6: Prioritize Gaps
```markdown
## Gap Priority

| Priority | Gap ID | Category | Severity | Impact |
|----------|--------|----------|----------|--------|
| 1 | GAP-001 | [cat] | Critical | [impact] |
| 2 | GAP-002 | [cat] | High | [impact] |
...
```

## Detection Techniques

### Static Analysis
- Read code paths
- Check for missing branches
- Verify error handlers exist
- Look for TODO/FIXME comments

### Dynamic Analysis
- Run the code
- Test boundary conditions
- Trigger error conditions
- Observe actual behavior

### Differential Analysis
- Compare to similar features
- Check against patterns
- Review against standards

### Review Analysis
- Check code comments vs code
- Review test coverage
- Examine documentation accuracy

## Gap Severity Matrix

| Severity | Criteria |
|----------|----------|
| **Critical** | Data loss, security breach, system crash, complete feature failure |
| **High** | Major functionality missing, significant UX impact, error exposure |
| **Medium** | Partial functionality, edge cases fail, degraded experience |
| **Low** | Minor issues, cosmetic, rare edge cases |

## Output Format

```markdown
# Gap Analysis: [Feature Name]

## Summary
- **Total Gaps Found**: [X]
- **Critical**: [X]
- **High**: [X]
- **Medium**: [X]
- **Low**: [X]
- **Overall Alignment**: [X]%

## Alignment Breakdown
| Category | Score |
|----------|-------|
| Functional | [X]% |
| Error Handling | [X]% |
| Edge Cases | [X]% |
| Validation | [X]% |
| Security | [X]% |
| Performance | [X]% |

## Gap Details

### GAP-001: [Title]
- **Category**: [category]
- **Severity**: [severity]
- **Intent**: [expected]
- **Actual**: [observed]
- **Location**: `file:line`
- **Impact**: [user impact]
- **Evidence**: [code/test showing gap]

[Repeat for each gap]

## Recommendations
| Priority | Gap | Recommended Correction |
|----------|-----|----------------------|
| 1 | GAP-001 | [brief correction approach] |
```

## Quality Checklist

- [ ] All acceptance criteria traced
- [ ] Implementation fully analyzed
- [ ] Point-by-point comparison done
- [ ] All gaps documented with evidence
- [ ] Severity accurately assessed
- [ ] Alignment score calculated
- [ ] Gaps prioritized
- [ ] Corrections recommended
