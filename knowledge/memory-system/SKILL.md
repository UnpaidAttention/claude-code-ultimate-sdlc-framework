---
name: memory-system
description: Use when learning from past work, recording decisions, or retrieving patterns for current tasks
---

# Three-Tier Memory System

## Purpose

Capture learnings from every session so future work benefits from past experience. Prevents repeating mistakes and accelerates pattern recognition.

## Memory Architecture

```
.memory/
├── episodic/           # Specific interaction traces
│   ├── planning/       # Planning council episodes
│   ├── development/    # Development council episodes
│   ├── audit/          # Audit council episodes
│   └── validation/     # Validation council episodes
├── semantic/           # Generalized patterns
│   ├── patterns.md     # Successful patterns
│   └── anti-patterns.md # What NOT to do
└── procedural/         # Learned workflows
    └── workflows.md    # Optimized procedures
```

## Tier 1: Episodic Memory

**What**: Specific interaction traces - what happened in a particular session.

**When to write**: End of every significant session or task completion.

**Format**: `.memory/episodic/[council]/YYYY-MM-DD-[description].md`

```markdown
# Episode: [Brief description]

**Date**: YYYY-MM-DD
**Council**: [Council name]
**Phase**: [Phase number and name]
**Task**: [What was being accomplished]

## Context

[2-3 sentences about the situation]

## Actions Taken

1. [Action 1 with outcome]
2. [Action 2 with outcome]
3. [Action 3 with outcome]

## Outcome

**Result**: [Success/Partial/Failed]
**Artifacts**: [List of files created/modified]

## Learnings

- [Learning 1]
- [Learning 2]

## Tags

#[tag1] #[tag2] #[tag3]
```

### Episode Example

```markdown
# Episode: JWT Authentication Implementation

**Date**: 2025-01-15
**Council**: Development
**Phase**: Phase 2 - Wave 1
**Task**: Implement AIOU-023 (User Authentication)

## Context

First feature in Wave 1. Needed JWT-based auth following ADR-005 decision.
Existing codebase had partial passport.js setup from previous attempt.

## Actions Taken

1. Reviewed existing passport.js code - found incomplete middleware
2. Decided to complete passport.js rather than replace (less risk)
3. Implemented JWT strategy with refresh token rotation
4. Added comprehensive tests (24 test cases)

## Outcome

**Result**: Success
**Artifacts**:
- src/auth/jwt.strategy.ts
- src/auth/auth.middleware.ts
- tests/auth/*.test.ts

## Learnings

- Check for existing partial implementations before starting fresh
- Refresh token rotation added complexity but required for security
- passport.js docs outdated, used source code as reference

## Tags

#authentication #jwt #passport #security #wave1
```

## Tier 2: Semantic Memory

**What**: Generalized patterns extracted from multiple episodes.

**When to write**: When same learning appears 2+ times in episodic memory.

**Files**:
- `.memory/semantic/patterns.md` - Successful patterns
- `.memory/semantic/anti-patterns.md` - What NOT to do

### patterns.md Format

```markdown
# Successful Patterns

## Pattern: [Name]

**Description**: [What this pattern is]
**When to use**: [Triggering conditions]
**How to apply**: [Steps to follow]

**Source episodes**:
- [Episode 1 reference]
- [Episode 2 reference]

**Confidence**: [High/Medium/Low based on episode count]

---
```

### anti-patterns.md Format

```markdown
# Anti-Patterns - What NOT To Do

## Anti-Pattern: [Name]

**Description**: [What NOT to do]
**Why it fails**: [Root cause of failure]
**What to do instead**: [Correct approach]

**Source episodes**:
- [Episode where this failed]

**Severity**: [Critical/High/Medium]

---
```

### Semantic Memory Example

```markdown
# Successful Patterns

## Pattern: Check Before Create

**Description**: Before implementing a new feature, check if partial
implementation already exists in codebase.

**When to use**: Starting any new feature implementation

**How to apply**:
1. Search codebase for related keywords
2. Check git history for abandoned attempts
3. Review related config files
4. Decide: complete existing or start fresh

**Source episodes**:
- 2025-01-15-jwt-authentication (found partial passport.js)
- 2025-01-18-email-service (found partial nodemailer setup)
- 2025-01-20-caching (found Redis client already configured)

**Confidence**: High (3 confirming episodes)

---
```

## Tier 3: Procedural Memory

**What**: Optimized workflows learned from experience.

**When to write**: When a workflow is refined through multiple iterations.

**File**: `.memory/procedural/workflows.md`

### Format

```markdown
# Learned Workflows

## Workflow: [Name]

**Purpose**: [What this workflow accomplishes]
**Trigger**: [When to use this workflow]

### Steps

1. [Step 1]
2. [Step 2]
3. [Step 3]

### Optimizations

- [Optimization learned from experience]

**Source episodes**:
- [Episodes that informed this workflow]

---
```

## Memory Lifecycle

### Writing Memory

1. **During session**: Note learnings in WORKING-MEMORY.md
2. **Session end**: Transfer significant learnings to episodic memory
3. **Pattern recognition**: When 2+ episodes share learning, create semantic entry
4. **Workflow refinement**: When procedures improve, update procedural memory

### Reading Memory

Before starting significant work:

1. Check semantic memory for relevant patterns
2. Search episodic memory for similar past tasks
3. Review procedural memory for applicable workflows
4. Load relevant items into WORKING-MEMORY.md context section

## Integration with RARV

**REASON phase**: Query memory for relevant patterns
```markdown
**Context Retrieved:**
- Relevant patterns: Check Before Create, Test First
- Anti-patterns to avoid: Guessing Dependencies
- Similar past tasks: 2025-01-15-jwt-authentication
```

**REFLECT phase**: Identify new learnings
```markdown
**Learning**: [What was learned]
**Memory action**: [Episodic entry / Update semantic / None]
```

## Tagging Conventions

Use consistent tags for searchability:

| Category | Tags |
|----------|------|
| Council | #planning #development #audit #validation |
| Phase | #phase1 #phase2 #phase3 etc. |
| Outcome | #success #partial #failed |
| Type | #bugfix #feature #refactor #security |
| Tech | #auth #api #database #frontend etc. |

## Common Mistakes

| Mistake | Impact | Prevention |
|---------|--------|------------|
| Not writing episodes | Lost learnings | Make it end-of-session habit |
| Too vague episodes | Can't extract patterns | Include specific details |
| Never reading memory | Repeating mistakes | Add to REASON phase |
| Premature patterns | Wrong generalizations | Wait for 2+ episodes |

## Quick Reference

```
WRITE:
- Episodic: Every significant session → .memory/episodic/[council]/
- Semantic: When pattern appears 2+ times → .memory/semantic/
- Procedural: When workflow is refined → .memory/procedural/

READ (Before work):
1. grep .memory/semantic/ for relevant patterns
2. Search .memory/episodic/ for similar tasks
3. Load findings into WORKING-MEMORY.md
```
