name: integration-testing
description: |
  Test interactions between system components including API contracts and data flow.

  Use when: (1) Phase T4 requires cross-component testing, (2) API contract verification
  between frontend and backend, (3) Database integration testing for data persistence,
  (4) Service-to-service communication validation, (5) Third-party/external service
  integration testing (payment gateways, auth providers).

# Integration Testing

Testing how components work together.

## Integration Points

### Common Integration Types

| Type | Tests | Example |
|------|-------|---------|
| **API Integration** | Client-server communication | Frontend calls backend API |
| **Database Integration** | Data persistence | Service writes to database |
| **Service Integration** | Service-to-service calls | Auth service validates tokens |
| **External Integration** | Third-party services | Payment gateway calls |

## Test Strategy

### API Contract Testing

```markdown
## Endpoint: POST /api/users

### Request
```json
{
  "email": "test@example.com",
  "name": "Test User"
}
```

### Expected Response (201)
```json
{
  "id": "uuid",
  "email": "test@example.com",
  "name": "Test User",
  "createdAt": "ISO-8601"
}
```

### Error Responses
- 400: Invalid email format
- 409: Email already exists
- 500: Server error
```

### Data Flow Testing

```
┌─────────┐     ┌─────────┐     ┌─────────┐
│ Frontend│ ──▶ │ Backend │ ──▶ │Database │
└─────────┘     └─────────┘     └─────────┘
     │               │               │
     ▼               ▼               ▼
  Verify:        Verify:         Verify:
  - Request      - Processing    - Persistence
    format       - Validation    - Data integrity
  - Response     - Error         - Relationships
    handling       handling
```

## Test Execution

### Pre-Integration Checklist
- [ ] All components deployed
- [ ] Network connectivity verified
- [ ] Authentication configured
- [ ] Test data seeded

### Integration Test Template

```markdown
## INT-XXX: [Integration Name]

**Components**: [Component A] ↔ [Component B]
**Type**: API | Database | Service | External

### Setup
- [Required configuration]
- [Test data needed]

### Test Steps
1. [Action triggering integration]
2. [Verification of data flow]

### Verification Points
- [ ] Request sent correctly
- [ ] Response received
- [ ] Data persisted/transformed correctly
- [ ] Error handling works

### Result
- [ ] Pass
- [ ] Fail: [Details]
```

## Common Integration Issues

| Issue | Symptom | Investigation |
|-------|---------|---------------|
| **Contract Mismatch** | 400/422 errors | Compare request to spec |
| **Timeout** | Connection hangs | Check network, service health |
| **Auth Failure** | 401/403 errors | Verify tokens, permissions |
| **Data Loss** | Missing data | Trace full data flow |

## Defect Documentation

For integration defects, always capture:
- Full request/response payloads
- Network traces if available
- Timestamps of requests
- Environment details
- Steps to reproduce

```markdown
## DEF-XXX: [Title]

**Integration**: [Component A] → [Component B]
**Severity**: Critical | High | Medium | Low

### Request Sent
```json
[Actual request payload]
```

### Expected Response
[What should have happened]

### Actual Response
```json
[What actually happened]
```

### Environment
- [Service versions, config details]
```
