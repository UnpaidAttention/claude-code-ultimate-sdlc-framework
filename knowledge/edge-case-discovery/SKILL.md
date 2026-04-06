---
name: edge-case-discovery
description: |
  Systematically discover edge cases, boundary conditions, and unusual scenarios.
---

  Use when: (1) Testing requires boundary value analysis, (2) identifying input
  boundaries (empty, max length, special characters), (3) exploring state boundaries
  (first-time, empty, corrupted), (4) testing time boundaries (timezone, DST, leap year),
  (5) user action edge cases (double-click, rapid repeat, back button during process).

# Edge Case Discovery

Systematic approach to discovering edge cases, boundary conditions, and unusual scenarios that may not have been considered during development.

## Edge Case Categories

### Input Boundaries
- Empty inputs
- Single character/item
- Maximum length/size
- Just over maximum
- Negative values
- Zero values
- Special characters
- Unicode/emoji
- Whitespace only

### State Boundaries
- First-time use
- Empty state
- Single item state
- Full/maximum state
- Corrupted state
- Expired state
- Concurrent modification

### Time Boundaries
- Midnight crossing
- Timezone changes
- Daylight saving transitions
- Leap year/leap second
- Very old dates
- Far future dates
- Expired sessions

### User Boundaries
- New user
- Guest user
- Admin user
- Suspended user
- Deleted user
- Multi-role user
- Concurrent sessions

## Discovery Techniques

### 1. Boundary Value Analysis
For each input, test:
```
[min-1] [min] [min+1] ... [max-1] [max] [max+1]
```

### 2. Equivalence Partitioning
Divide inputs into classes:
- Valid normal values
- Valid boundary values
- Invalid values
- Special values (null, empty)

### 3. State Transition Testing
For each state:
- What triggers entry?
- What triggers exit?
- What happens at boundaries?

### 4. Error Guessing
Based on experience:
- What usually goes wrong?
- What have I seen fail before?
- What would a confused user do?

### 5. Combinatorial Testing
Test combinations of:
- Multiple inputs
- Multiple states
- Multiple user types
- Multiple environments

## Edge Case Checklist

### Data Input
- [ ] Empty string
- [ ] Very long string
- [ ] Special characters (<, >, ", ', &)
- [ ] Unicode characters
- [ ] Emoji
- [ ] SQL injection attempts
- [ ] Script injection attempts
- [ ] Leading/trailing whitespace
- [ ] Only whitespace
- [ ] Negative numbers
- [ ] Zero
- [ ] Decimal with many places
- [ ] Scientific notation
- [ ] Very large numbers

### Files
- [ ] Empty file
- [ ] Very large file
- [ ] Wrong file type
- [ ] Corrupted file
- [ ] File with no extension
- [ ] File with spaces in name
- [ ] File with special characters in name
- [ ] Duplicate file upload
- [ ] Simultaneous uploads

### User Actions
- [ ] Double-click submit
- [ ] Rapid repeated actions
- [ ] Back button during process
- [ ] Refresh during process
- [ ] Close browser during process
- [ ] Multiple browser tabs
- [ ] Session timeout during action
- [ ] Network disconnect/reconnect

### System States
- [ ] Empty database
- [ ] Database at capacity
- [ ] Cache empty
- [ ] Cache full
- [ ] External service unavailable
- [ ] External service slow
- [ ] Low disk space
- [ ] High CPU load

## Discovery Process

### Step 1: Map Feature Boundaries
For each feature, identify:
- All inputs
- All outputs
- All states
- All dependencies

### Step 2: Generate Edge Cases
Apply techniques to each boundary:
```markdown
| Boundary | Edge Case | Expected Behavior |
|----------|-----------|-------------------|
| [Input] | [Case] | [What should happen] |
```

### Step 3: Test Edge Cases
For each edge case:
- Execute the scenario
- Document actual behavior
- Compare to expected
- Note any issues

### Step 4: Document Findings
```markdown
## Edge Case Finding: [Title]

### Scenario
[Describe the edge case]

### Steps to Reproduce
1. [Step 1]
2. [Step 2]

### Expected Behavior
[What should happen]

### Actual Behavior
[What actually happened]

### Severity
[Critical/High/Medium/Low]

### Recommendation
[How to handle this case]
```

## Edge Case Matrix

| Feature | Category | Edge Case | Tested | Result |
|---------|----------|-----------|--------|--------|
| Login | Input | Empty password | ✓ | Pass |
| Login | Input | 1000 char password | ✓ | Fail |
| Search | State | Empty results | ✓ | Pass |

## Common Overlooked Edge Cases

### Authentication
- Password with only spaces
- Email with plus addressing
- Case sensitivity in username
- Account locked during login attempt

### Forms
- Paste from clipboard with formatting
- Auto-fill interactions
- Required field with only whitespace
- Validation timing

### Lists/Tables
- Empty list display
- Single item behavior
- Pagination boundary
- Sorting empty values
- Filtering to zero results

### File Handling
- Zero-byte file
- Binary file with text extension
- File path too long
- Special characters in filename

## References

- See `references/edge-case-examples.md`
- See `references/boundary-value-tables.md`
