name: documentation-update
description: Keep all documentation synchronized with code changes across README, API docs, changelogs, and inline comments. Use after implementing corrections or enhancements, during release preparation, or when auditing documentation freshness and accuracy.

# Documentation Update

Keep all documentation current with changes made.

## Purpose

Documentation that doesn't match code is worse than no documentation. Keep everything in sync.

## Documentation Types

### 1. README
Main entry point for the project.

| Section | Check | Status |
|---------|-------|--------|
| Project description | Current | [Yes/No] |
| Installation steps | Current | [Yes/No] |
| Quick start | Current | [Yes/No] |
| Configuration | Current | [Yes/No] |
| Examples | Current | [Yes/No] |

### 2. API Documentation
Technical reference for developers.

| Aspect | Check | Status |
|--------|-------|--------|
| Endpoints documented | Complete | [Yes/No] |
| Request formats | Accurate | [Yes/No] |
| Response formats | Accurate | [Yes/No] |
| Error codes | Complete | [Yes/No] |
| Examples | Working | [Yes/No] |

### 3. User Guides
How-to documentation for end users.

| Aspect | Check | Status |
|--------|-------|--------|
| Features covered | Complete | [Yes/No] |
| Steps accurate | Verified | [Yes/No] |
| Screenshots current | Updated | [Yes/No] |
| Use cases covered | Complete | [Yes/No] |

### 4. Architecture Documentation
System design and decisions.

| Aspect | Check | Status |
|--------|-------|--------|
| Diagrams current | Updated | [Yes/No] |
| Components documented | Complete | [Yes/No] |
| Decisions recorded | Current | [Yes/No] |
| Dependencies listed | Accurate | [Yes/No] |

### 5. Changelog/Release Notes
History of changes.

| Aspect | Check | Status |
|--------|-------|--------|
| All changes listed | Complete | [Yes/No] |
| Breaking changes noted | Highlighted | [Yes/No] |
| Migration steps | Provided | [Yes/No] |

## Update Process

### Step 1: Identify Changes
```markdown
## Changes Made This Session

### New Features
| Feature | Files | Documentation Needed |
|---------|-------|---------------------|
| [Feature] | [Files] | [What to document] |

### Modifications
| Change | Files | Documentation Update |
|--------|-------|---------------------|
| [Change] | [Files] | [What to update] |

### Fixes
| Fix | Files | Documentation Impact |
|-----|-------|---------------------|
| [Fix] | [Files] | [Any doc changes] |
```

### Step 2: Map Changes to Docs
```markdown
## Documentation Impact

| Change | README | API Docs | User Guide | Architecture |
|--------|--------|----------|------------|--------------|
| [Change 1] | [X] | [ ] | [X] | [ ] |
| [Change 2] | [ ] | [X] | [ ] | [ ] |
```

### Step 3: Update Each Document
```markdown
## Documentation Updates

### README.md
**Section**: [Section name]
**Change**: [What to add/modify]

**Before**:
```markdown
[Old content]
```

**After**:
```markdown
[New content]
```

### API Documentation
**Endpoint**: [Endpoint affected]
**Change**: [What to update]

[Updated documentation]
```

### Step 4: Write Release Notes
```markdown
## Release Notes: v[X.Y.Z]

### New Features
- **[Feature Name]**: [Brief description]

### Improvements
- **[Improvement]**: [Brief description]

### Bug Fixes
- **[Fix]**: [What was fixed]

### Breaking Changes
- **[Change]**: [What changed, how to migrate]

### Migration Guide
[If breaking changes exist]
1. [Step 1]
2. [Step 2]
```

### Step 5: Verify Documentation
```markdown
## Documentation Verification

### Accuracy Check
| Document | Reviewed | Accurate | Issues |
|----------|----------|----------|--------|
| README | [Yes/No] | [Yes/No] | [List] |
| API Docs | [Yes/No] | [Yes/No] | [List] |
| User Guide | [Yes/No] | [Yes/No] | [List] |

### Example Verification
| Example | Location | Works | Issues |
|---------|----------|-------|--------|
| [Example 1] | [Doc] | [Yes/No] | [Issue] |

### Link Check
| Link | Status |
|------|--------|
| [URL] | [Working/Broken] |
```

## Documentation Standards

### Writing Style
- Clear, concise language
- Active voice
- Present tense for current behavior
- Consistent terminology

### Structure
- Logical organization
- Progressive disclosure
- Cross-references where helpful
- Table of contents for long docs

### Examples
- Realistic, working examples
- Cover common use cases
- Include expected output
- Note prerequisites

### Maintenance
- Date stamps on time-sensitive info
- Version numbers where relevant
- Clear ownership
- Review schedule

## Output Format

```markdown
# Documentation Update Report

## Summary
- **Documents Updated**: [X]
- **New Sections**: [X]
- **Examples Verified**: [X]
- **Status**: [Complete/In Progress]

## Changes Made

### README.md
- [x] Updated [section] with [change]
- [x] Added [new section]

### API Documentation
- [x] Added endpoint [X]
- [x] Updated request format for [Y]

### User Guide
- [x] Added guide for [feature]
- [x] Updated screenshots

### Release Notes
- [x] Created for v[X.Y.Z]

## Verification
- All examples working: [Yes/No]
- All links valid: [Yes/No]
- Reviewed by: [Who/When]

## Remaining Work
| Document | Task | Priority |
|----------|------|----------|
| [Doc] | [Task] | [H/M/L] |
```

## Quality Checklist

- [ ] All changes identified
- [ ] Affected documents mapped
- [ ] Updates made
- [ ] Examples verified
- [ ] Links checked
- [ ] Release notes written
- [ ] Reviewed for accuracy
- [ ] Consistent style maintained
