name: documentation-standards
description: Establishes standards for technical documentation including READMEs, API docs, ADRs, and user guides. Use when writing project specifications, creating API documentation, documenting architecture decisions, preparing handoff documents, or establishing documentation conventions.

# Documentation Standards

> Consistent, high-quality documentation practices that serve both humans and machines.
> Good documentation is an investment that pays dividends in team productivity.


## Core Principles

| Principle | Rule |
|-----------|------|
| **Audience First** | Write for your reader, not yourself |
| **Keep Current** | Outdated docs are worse than no docs |
| **Single Source of Truth** | One authoritative location per topic |
| **Minimal but Complete** | Include what's needed, nothing more |
| **Actionable** | Readers should know what to do next |


## When to Use

- Writing project specifications
- Creating API documentation
- Documenting architecture decisions (ADRs)
- Writing README files
- Creating user guides or tutorials
- Preparing handoff documents


## Documentation Types

### Type Selection Matrix

| Type | Audience | Purpose | Update Frequency |
|------|----------|---------|------------------|
| **README** | New developers | Project overview, getting started | Per release |
| **API Docs** | API consumers | Endpoint reference | Per API change |
| **ADRs** | Team, future devs | Decision rationale | When decisions made |
| **User Guides** | End users | How to use features | Per feature change |
| **Runbooks** | Ops team | Operational procedures | Per infrastructure change |
| **Tutorials** | Learners | Step-by-step learning | Periodic review |


## README Template

```markdown
# Project Name

Brief description (1-2 sentences).

## Features

- Feature 1: What it does
- Feature 2: What it does

## Quick Start

\`\`\`bash
# Installation
npm install project-name

# Run
npm start
\`\`\`

## Requirements

- Node.js >= 18
- PostgreSQL >= 14

## Configuration

| Variable | Description | Default |
|----------|-------------|---------|
| `DATABASE_URL` | PostgreSQL connection string | Required |
| `PORT` | Server port | 3000 |

## Development

\`\`\`bash
npm run dev     # Start development server
npm test        # Run tests
npm run lint    # Check code style
\`\`\`

## Architecture

Brief overview with link to detailed docs.

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md).

## License

MIT
```


## API Documentation Template

### Endpoint Documentation

```markdown
## Create User

Creates a new user account.

### Request

\`\`\`http
POST /api/v1/users
Content-Type: application/json
Authorization: Bearer {token}
\`\`\`

#### Body Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `email` | string | Yes | Valid email address |
| `name` | string | Yes | Full name (2-100 chars) |
| `role` | string | No | User role (default: "user") |

#### Example

\`\`\`json
{
  "email": "user@example.com",
  "name": "Jane Smith",
  "role": "admin"
}
\`\`\`

### Response

#### Success (201 Created)

\`\`\`json
{
  "data": {
    "id": "usr_abc123",
    "email": "user@example.com",
    "name": "Jane Smith",
    "role": "admin",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
\`\`\`

#### Errors

| Status | Code | Description |
|--------|------|-------------|
| 400 | `VALIDATION_ERROR` | Invalid input data |
| 409 | `EMAIL_EXISTS` | Email already registered |
| 401 | `UNAUTHORIZED` | Missing or invalid token |
```


## Architecture Decision Record (ADR) Template

```markdown
# ADR-XXX: [Short Title]

## Status

Proposed | Accepted | Deprecated | Superseded by ADR-YYY

## Date

YYYY-MM-DD

## Context

What is the issue that we're seeing that motivates this decision?
What are the forces at play (technical, business, team)?

## Decision

What is the change that we're proposing and/or doing?

## Consequences

### Positive

- Benefit 1
- Benefit 2

### Negative

- Trade-off 1
- Trade-off 2

### Neutral

- Side effect that's neither good nor bad

## Alternatives Considered

### Option A: [Name]

Description of alternative.

**Pros:**
- Pro 1

**Cons:**
- Con 1

**Why rejected:** Explanation

## References

- Link to relevant documentation
- Link to related ADRs
```

### When to Write an ADR

| Scenario | ADR Needed? |
|----------|-------------|
| Choosing a framework | Yes |
| Selecting a database | Yes |
| Defining coding standards | Yes |
| Bug fix implementation | No |
| Routine feature work | No |
| Significant refactoring | Yes |


## User Guide Template

```markdown
# [Feature Name] Guide

## Overview

What this feature does and why it's useful.

## Prerequisites

- What the user needs before starting
- Required permissions or access

## Step-by-Step Instructions

### Step 1: [Action]

1. Navigate to [location]
2. Click [button/link]
3. Enter [information]

> **Note:** Important information the user should know.

### Step 2: [Action]

[Screenshot or diagram if helpful]

## Common Use Cases

### Use Case 1: [Scenario]

When you want to [goal], do [steps].

### Use Case 2: [Scenario]

When you need to [goal], follow [steps].

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Error message X | Try solution Y |
| Feature not working | Check Z |

## FAQ

**Q: Question?**
A: Answer.

## Related Features

- [Link to related feature guide]
```


## Handoff Document Template

```markdown
# [Project/Feature] Handoff

## Executive Summary

2-3 sentences: what was built, why, current status.

## What Was Built

### Features Implemented

- [ ] Feature 1 - Status (complete/partial)
- [ ] Feature 2 - Status

### Technical Decisions

Key architectural choices made (link to ADRs).

## Current State

### Working

- List of functional features

### Known Issues

| Issue | Severity | Notes |
|-------|----------|-------|
| Issue 1 | High/Med/Low | Workaround or plan |

### Technical Debt

- Items intentionally deferred

## How to Continue

### Immediate Next Steps

1. Priority task 1
2. Priority task 2

### Future Enhancements

- Enhancement idea 1
- Enhancement idea 2

## Key Files and Locations

| Purpose | Location |
|---------|----------|
| Main entry | `src/index.ts` |
| Config | `config/` |
| Tests | `tests/` |

## Contacts

| Role | Name | For |
|------|------|-----|
| Tech Lead | [Name] | Architecture questions |
| PM | [Name] | Requirements |
```


## Writing Guidelines

### Be Specific

| Bad | Good |
|-----|------|
| "The system should be fast" | "API responses under 200ms at p95" |
| "Handle errors appropriately" | "Return 400 for validation, 500 for server errors" |
| "Supports many users" | "Tested with 10,000 concurrent users" |

### Use Active Voice

| Passive | Active |
|---------|--------|
| "The file is read by the parser" | "The parser reads the file" |
| "Errors are returned when..." | "The function returns an error when..." |

### Include Examples

Every concept should have:
- Code example (when applicable)
- Input/output example
- Real-world use case

### Structure for Scanning

- Use headings liberally
- Keep paragraphs short (3-4 sentences max)
- Use bullet points for lists
- Use tables for comparisons
- Highlight key terms in **bold**


## When to Document vs When NOT to

### Document

| Scenario | Why |
|----------|-----|
| Public APIs | External consumers need reference |
| Architecture decisions | Future maintainers need context |
| Complex business logic | Non-obvious behavior needs explanation |
| Setup/deployment | Onboarding depends on this |
| Workarounds/gotchas | Prevent others from hitting same issues |

### Skip Documentation

| Scenario | Alternative |
|----------|-------------|
| Self-explanatory code | Write clearer code |
| Implementation details that change | Let code be the documentation |
| Obvious getter/setter methods | Use clear naming |
| Temporary solutions | Add TODO comment instead |


## Quality Criteria

### Documentation Review Checklist

| Criterion | Question |
|-----------|----------|
| **Accuracy** | Is the information correct and current? |
| **Completeness** | Are all necessary topics covered? |
| **Clarity** | Can the target audience understand this? |
| **Conciseness** | Is there unnecessary content to remove? |
| **Consistency** | Does formatting match other docs? |
| **Actionable** | Does the reader know what to do next? |

### Maintenance Schedule

| Doc Type | Review Frequency |
|----------|------------------|
| README | Every release |
| API Docs | With each API change |
| ADRs | When superseded |
| Tutorials | Quarterly |
| User Guides | With feature changes |


## Formatting Standards

### Markdown Conventions

| Element | Convention |
|---------|------------|
| Headings | Use ## for main sections, ### for subsections |
| Code | Use fenced code blocks with language |
| Lists | Use `-` for unordered, `1.` for ordered |
| Links | Use descriptive text, not "click here" |
| Images | Include alt text, keep under 100KB |

### File Organization

```
docs/
├── README.md           # Project overview
├── CONTRIBUTING.md     # How to contribute
├── api/               # API documentation
│   ├── README.md
│   └── endpoints/
├── guides/            # User guides
├── architecture/      # ADRs and diagrams
│   └── decisions/
└── runbooks/          # Operational docs
```


## Anti-Patterns

| Pattern | Problem | Fix |
|---------|---------|-----|
| **Write Once, Forget** | Docs become stale | Schedule reviews |
| **Documentation Dump** | Too much, no structure | Organize by audience |
| **Copy-Paste Docs** | Duplicated, inconsistent | Single source of truth |
| **No Examples** | Abstract, hard to apply | Add concrete examples |
| **Jargon Heavy** | Excludes newcomers | Define terms, use glossary |
| **Screenshots Only** | Break with UI changes | Prefer text instructions |


## Related Skills

| Need | Skill |
|------|-------|
| API design | `@[skills/api-patterns]` |
| Architecture decisions | `@[skills/architecture-principles]` |
| Requirements | `@[skills/requirements-engineering]` |
