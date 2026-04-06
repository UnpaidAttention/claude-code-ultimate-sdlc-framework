---
name: prerequisite-analysis
description: Verify all dependencies and prerequisites exist before making code changes. Use when starting a new development task, before implementing corrections, or when checking that APIs, databases, libraries, and configurations are in place before writing code.
---

# Prerequisite Analysis

Verify all dependencies exist before making changes.

## Purpose

Never attempt a fix without ensuring prerequisites exist. This prevents partial implementations and cascading failures.

## Prerequisite Categories

### Code Prerequisites
- Required functions/methods exist
- Required APIs available
- Required libraries installed
- Required types/interfaces defined

### Data Prerequisites
- Required database tables exist
- Required columns present
- Required data available
- Required migrations applied

### Infrastructure Prerequisites
- Required services running
- Required endpoints accessible
- Required permissions granted
- Required resources available

### Process Prerequisites
- Required approvals obtained
- Required documentation complete
- Required tests written
- Required environments ready

## Analysis Process

### Step 1: Identify Required Changes
```markdown
## Planned Correction/Enhancement

**ID**: [COR-XXX / ENH-XXX]
**Description**: [What we're trying to do]
**Files Affected**: [List of files]
```

### Step 2: Map Prerequisites
```markdown
## Prerequisite Map

### Code Dependencies
| Dependency | Type | Required By | Status |
|------------|------|-------------|--------|
| [Function X] | Function | COR-XXX | [Exists/Missing] |
| [API Y] | Endpoint | COR-XXX | [Exists/Missing] |

### Data Dependencies
| Dependency | Type | Required By | Status |
|------------|------|-------------|--------|
| [Table X] | Database | COR-XXX | [Exists/Missing] |
| [Column Y] | Column | COR-XXX | [Exists/Missing] |

### Infrastructure Dependencies
| Dependency | Type | Required By | Status |
|------------|------|-------------|--------|
| [Service X] | Service | COR-XXX | [Available/Unavailable] |

### External Dependencies
| Dependency | Type | Required By | Status |
|------------|------|-------------|--------|
| [Library X] | Package | COR-XXX | [Installed/Missing] |
```

### Step 3: Verify Each Prerequisite
```markdown
## Prerequisite Verification

### [Prerequisite Name]
**Type**: [Code/Data/Infrastructure/External]
**Required For**: [What needs this]

**Verification Method**:
[How to check if it exists]

**Result**: [Exists/Missing]

**If Missing**:
- Action needed: [What to create/install/configure]
- Effort: [H/M/L]
- Blocks: [What's blocked until resolved]
```

### Step 4: Create Resolution Plan
```markdown
## Resolution Plan

### Missing Prerequisites
| Prerequisite | Priority | Resolution | Effort |
|--------------|----------|------------|--------|
| [Name] | [H/M/L] | [How to resolve] | [Effort] |

### Resolution Sequence
1. [First prerequisite to resolve]
2. [Second prerequisite to resolve]

### Blockers
| Blocker | Impact | Escalation |
|---------|--------|------------|
| [Blocker] | [What's blocked] | [Who to escalate to] |
```

## Common Prerequisites

### For UI Changes
- [ ] Component library available
- [ ] Design tokens defined
- [ ] Styles/CSS available
- [ ] Assets exist

### For API Changes
- [ ] Database schema supports change
- [ ] Authentication configured
- [ ] Rate limiting in place
- [ ] Error handling exists

### For Database Changes
- [ ] Migration mechanism exists
- [ ] Rollback procedure defined
- [ ] Backup available
- [ ] Downtime window (if needed)

### For Integration Changes
- [ ] External service accessible
- [ ] Credentials configured
- [ ] Fallback defined
- [ ] Timeout handling exists

## Output Format

```markdown
# Prerequisite Analysis: [COR/ENH-XXX]

## Summary
- **Total Prerequisites**: [X]
- **Verified**: [X]
- **Missing**: [X]
- **Status**: [Ready/Blocked]

## Prerequisite Status

### Ready (Prerequisites Met)
| Prerequisite | Type | Verification |
|--------------|------|--------------|
| [Name] | [Type] | [How verified] |

### Missing (Need Resolution)
| Prerequisite | Type | Resolution | Priority |
|--------------|------|------------|----------|
| [Name] | [Type] | [Action] | [H/M/L] |

## Resolution Plan
[If missing prerequisites exist]

1. [Step 1]
2. [Step 2]

## Blockers
[List any external blockers]

## Conclusion
[Ready to proceed / Need resolution first]
```

## Quality Checklist

- [ ] All changes identified
- [ ] All prerequisites mapped
- [ ] Each prerequisite verified
- [ ] Missing prerequisites documented
- [ ] Resolution plan created
- [ ] Blockers escalated
