---
name: sdlc-dev-wave-4
description: |
  Execute Development Wave 4 - API Layer. Implement controllers, routes, and API endpoints.
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Agent
  - AskUserQuestion
---

## Preamble (run first)

```bash
# Detect project state
AG_HOME="${HOME}/.Ultimate SDLC"
AG_PROJECT=".ultimate-sdlc"
AG_SKILLS="${HOME}/.claude/skills/ultimate-sdlc"

# Check if project is initialized
if [ -d "$AG_PROJECT" ]; then
  echo "PROJECT: initialized"
  # Read current state
  if [ -f "$AG_PROJECT/project-context.md" ]; then
    COUNCIL=$(grep -A1 "## Active Council" "$AG_PROJECT/project-context.md" | tail -1 | tr -d ' ')
    PHASE=$(grep -A1 "## Current Phase" "$AG_PROJECT/project-context.md" | tail -1 | tr -d ' ')
    STATUS=$(grep -A1 "## Status" "$AG_PROJECT/project-context.md" | tail -1 | tr -d ' ')
    echo "COUNCIL: $COUNCIL"
    echo "PHASE: $PHASE"  
    echo "STATUS: $STATUS"
  fi
else
  echo "PROJECT: not initialized (run /init first)"
fi

# Read global config
if [ -f "$AG_HOME/config.yaml" ]; then
  GOV_MODE=$(grep "governance_mode:" "$AG_HOME/config.yaml" | awk '{print $2}')
  PROJ_TYPE=$(grep "project_type:" "$AG_HOME/config.yaml" | awk '{print $2}')
  echo "GOVERNANCE: ${GOV_MODE:-standard}"
  echo "PROJECT_TYPE: ${PROJ_TYPE:-web-app}"
fi
```

After the preamble runs, use the detected state to verify prerequisites for this workflow.

## Knowledge Skills

Load these knowledge skills for reference during this workflow:
- Read `~/.claude/skills/ultimate-sdlc/knowledge/api-design/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/security-patterns/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/test-patterns/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/clean-code/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /dev-wave-4 - API Layer

## Lens / Skills / Model
**Lens**: `[Architecture]` + `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol, code review protocol per `council-development.md`

## Prerequisites

- Wave 3 (Services) must be complete

If prerequisites not met:
```
Wave 3 not complete. Run /dev-wave-3 first.
```

---

## Workflow

### Step 1: Update Project State

Update `.ultimate-sdlc/project-context.md`:
- Set `Active Council`: development
- Set `Current Wave`: 4 - API Layer
- Set `Status`: in_progress

### Step 2: Review Wave 4 AIOUs

**SCOPE**: In multi-run mode, process only current run's AIOUs.

Read from `specs/wave-summary.md` and `specs/aious/`:
- List all Wave 4 AIOUs (filtered by run if multi-run)
- Review API requirements from feature specs
- Understand authentication/authorization needs

**Feature Context Loading** (per council-development.md § Feature Context Loading Protocol):
For each AIOU in this wave, read the parent FEAT spec and deep-dive.
Record feature context in WORKING-MEMORY.md before beginning implementation.

### Step 3: API Architecture

Implement clean API layer:

```
Request → Router → Middleware → Controller → Service → Response
                      │
                      ├── Authentication
                      ├── Authorization
                      ├── Validation
                      ├── Rate Limiting
                      └── Error Handling
```

### Step 4: Implementation Pattern

For each API endpoint:

1. **Define route**

   ### Agent: sdlc-api-designer
   Invoke via Agent tool with `subagent_type: "sdlc-api-designer"`:
   - **Provide**: AIOU spec, feature API requirements, service interfaces from Wave 3, authentication needs
   - **Request**: Design endpoint routes, request/response schemas, validation rules, middleware chain, and response matrix (all applicable status codes)
   - **Apply**: Use the designer's API specification as the blueprint for implementation

2. **Create request validation schema**
3. **Write integration tests** (TDD)

   ### Agent: sdlc-tdd-guide
   Invoke via Agent tool with `subagent_type: "sdlc-tdd-guide"`:
   - **Provide**: API endpoint design, response matrix, validation schemas, auth requirements
   - **Request**: Generate integration tests for all response codes (200, 400, 401, 403, 404, 409, 422, 429, 500 as applicable)
   - **Apply**: Write tests first (RED), implement controller to pass (GREEN)

4. **Implement controller**
   - Validate input
   - Call service
   - Format response
5. **Add middleware** (auth, validation)
6. **Run tests**
7. **Document API**

   ### Agent: sdlc-code-reviewer
   Invoke via Agent tool with `subagent_type: "sdlc-code-reviewer"`:
   - **Provide**: Controller code, middleware, test results, API documentation, AIOU acceptance criteria
   - **Request**: Review for input validation gaps, response format consistency, error handling completeness, and API documentation accuracy
   - **Apply**: Fix all CRITICAL and HIGH issues before marking AIOU complete

   ### Agent: sdlc-security
   Invoke via Agent tool with `subagent_type: "sdlc-security"`:
   - **Provide**: API endpoint code, authentication/authorization middleware, validation schemas, rate limiting config
   - **Request**: Review for auth bypass vulnerabilities, injection risks, missing rate limits, and sensitive data exposure in error responses
   - **Apply**: Fix all security findings before marking AIOU complete

8. **Commit**

### Step 5: Common Wave 4 Components

Typical API components:
- Route definitions
- Controllers
- Request validators
- Response formatters
- Authentication middleware
- Authorization middleware
- Error handling middleware
- API documentation

### Step 6: Quality Standards

Each API endpoint must:
- [ ] Validate all inputs
- [ ] Require authentication (where needed)
- [ ] Check authorization
- [ ] Return consistent response format
- [ ] Have integration tests
- [ ] Be documented (OpenAPI/Swagger)
- [ ] **Implement ALL applicable response codes** (not just 200 success):

### API Response Completeness (MANDATORY)

Every endpoint must handle and return proper responses for ALL applicable scenarios — not just the happy path. Before implementing an endpoint, document its response matrix:

| Response Code | When | Response Body | Test Required |
|--------------|------|---------------|--------------|
| 200 OK | Success (GET, PUT, PATCH) | Resource or result | ✅ |
| 201 Created | Success (POST creating resource) | Created resource | ✅ |
| 204 No Content | Success (DELETE) | Empty | ✅ |
| 400 Bad Request | Invalid input (malformed JSON, wrong types) | `{ error, details: [{field, message}] }` | ✅ |
| 401 Unauthorized | Missing or invalid auth token | `{ error: "Unauthorized" }` | ✅ (if auth required) |
| 403 Forbidden | Valid auth but insufficient permissions | `{ error: "Forbidden" }` | ✅ (if roles exist) |
| 404 Not Found | Resource doesn't exist | `{ error: "Not found" }` | ✅ (for resource endpoints) |
| 409 Conflict | Duplicate or state conflict | `{ error, details }` | ✅ (if uniqueness constraints) |
| 422 Unprocessable | Valid syntax but failed business rules | `{ error, details }` | ✅ (if business validation) |
| 429 Too Many Requests | Rate limit exceeded | `{ error, retryAfter }` | ✅ (if rate limited) |
| 500 Internal Server Error | Unexpected failure | `{ error: "Internal error" }` (no internals) | ✅ |

**Implementation rule**: An endpoint that only returns 200 and 500 is INCOMPLETE. Every endpoint must implement at minimum: success response + 400 (input validation) + 401/403 (if authenticated) + 404 (if resource-based) + 500 (generic error handler).

**Test rule**: Each implemented response code must have at least one integration test that triggers it and verifies the response shape and status code.

### Step 7: Wave Completion Criteria

**SCOPE**: In multi-run mode, verify only current run's AIOUs.

Before completing this wave, verify:
- [ ] All Wave 4 AIOUs **in current run** implemented
- [ ] All integration tests passing
- [ ] API documentation complete
- [ ] Security controls in place
- [ ] Code reviewed (parallel-code-review)
- [ ] Committed with proper messages
- [ ] **If multi-run**: Run tracker Wave 4 column updated for all AIOUs

### Step 8: Complete Wave

When all criteria met:

1. Update `.ultimate-sdlc/project-context.md`:
   - Set Wave 4 status: Complete

2. Update `.ultimate-sdlc/council-state/development/WORKING-MEMORY.md`:
   - Mark completed AIOUs
   - Record session learnings

3. Record metrics in `.metrics/tasks/development/`

4. Create git checkpoint:
   ```bash
   git tag wave-4-complete
   ```

5. Display completion message:

```
## Wave 4: API Layer - Complete

**AIOUs Completed**: [X]
**Endpoints Created**: [Y]
**Tests**: [N] passing

**Wave completion security check**: Run `npm audit --audit-level=high` (or stack equivalent). If high/critical findings: fix before proceeding. Run `gitleaks detect --no-git` on files modified in this wave.

**Next Step**: Run `/dev-gate-i4` to verify Gate I4 criteria before UI development
```

---

## Code Review Integration

After completing each AIOU, apply parallel 3-reviewer code review:
- Dispatch 3 reviewers (Security, Quality, Logic focus)
- If unanimous approval, run Devil's Advocate review
- Fix all Critical and High issues before marking complete

---
