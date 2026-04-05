name: api-patterns
description: Guides API development decisions including REST vs GraphQL selection, versioning strategies, authentication patterns, and error handling. Use when designing new APIs, choosing API styles, planning versioning, implementing auth, or troubleshooting API integration issues.

# API Patterns

> Comprehensive guide to API design principles and decision-making for modern applications.
> **Learn to THINK about context, not copy fixed patterns.**


## Core Principles

| Principle | Rule |
|-----------|------|
| **Consistency** | Use uniform patterns across all endpoints |
| **Simplicity** | Design for the common case, support the complex |
| **Discoverability** | APIs should be self-documenting and intuitive |
| **Backward Compatibility** | Changes should not break existing clients |
| **Security First** | Authentication and authorization on every endpoint |


## When to Use

- Designing new API endpoints or services
- Choosing between REST, GraphQL, or tRPC
- Planning API versioning strategy
- Implementing authentication/authorization
- Defining error response formats
- Setting up rate limiting


## API Style Selection

### Decision Matrix

| Factor | REST | GraphQL | tRPC |
|--------|------|---------|------|
| **Best for** | Public APIs, microservices | Complex queries, mobile | TypeScript monorepos |
| **Learning curve** | Low | Medium | Low (TS devs) |
| **Caching** | Easy (HTTP) | Complex | Manual |
| **Type safety** | Manual (OpenAPI) | Built-in schema | Full end-to-end |
| **Overfetching** | Common issue | Solved | Solved |
| **File uploads** | Native | Complex | Supported |

### When to Choose REST

- Public-facing APIs with diverse clients
- Simple CRUD operations
- Need HTTP caching
- Team familiar with REST conventions

### When to Choose GraphQL

- Mobile apps needing bandwidth optimization
- Complex, nested data requirements
- Multiple client types with different data needs
- Rapid frontend iteration

### When to Choose tRPC

- TypeScript full-stack monorepo
- Need end-to-end type safety
- Internal APIs only
- Small to medium team


## REST Best Practices

### Resource Naming

| Pattern | Example | Notes |
|---------|---------|-------|
| **Plural nouns** | `/users`, `/orders` | Collections are plural |
| **Nested resources** | `/users/{id}/orders` | Max 2 levels deep |
| **Specific actions** | `/orders/{id}/cancel` | POST for actions |
| **Filtering** | `/users?status=active` | Query params for filters |

### HTTP Methods

| Method | Purpose | Idempotent | Safe |
|--------|---------|------------|------|
| `GET` | Retrieve resource | Yes | Yes |
| `POST` | Create resource | No | No |
| `PUT` | Replace resource | Yes | No |
| `PATCH` | Partial update | No | No |
| `DELETE` | Remove resource | Yes | No |

### Status Codes

| Code | Meaning | When to Use |
|------|---------|-------------|
| `200` | OK | Successful GET, PUT, PATCH |
| `201` | Created | Successful POST creating resource |
| `204` | No Content | Successful DELETE |
| `400` | Bad Request | Invalid input, validation errors |
| `401` | Unauthorized | Missing or invalid authentication |
| `403` | Forbidden | Authenticated but not authorized |
| `404` | Not Found | Resource doesn't exist |
| `409` | Conflict | Resource state conflict |
| `422` | Unprocessable Entity | Semantic validation errors |
| `429` | Too Many Requests | Rate limit exceeded |
| `500` | Internal Server Error | Unexpected server error |


## Error Response Standards

### Standard Error Format

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "The request contains invalid data",
    "details": [
      {
        "field": "email",
        "code": "INVALID_FORMAT",
        "message": "Email must be a valid email address"
      }
    ],
    "request_id": "req_abc123",
    "documentation_url": "https://api.example.com/docs/errors#VALIDATION_ERROR"
  }
}
```

### Error Code Categories

| Category | Prefix | Example |
|----------|--------|---------|
| Validation | `VALIDATION_` | `VALIDATION_REQUIRED_FIELD` |
| Authentication | `AUTH_` | `AUTH_TOKEN_EXPIRED` |
| Authorization | `AUTHZ_` | `AUTHZ_INSUFFICIENT_PERMISSIONS` |
| Resource | `RESOURCE_` | `RESOURCE_NOT_FOUND` |
| Rate Limit | `RATE_` | `RATE_LIMIT_EXCEEDED` |
| Server | `SERVER_` | `SERVER_INTERNAL_ERROR` |


## Versioning Strategies

| Strategy | Example | Pros | Cons |
|----------|---------|------|------|
| **URI Path** | `/v1/users` | Clear, easy routing | URL pollution |
| **Header** | `Accept: application/vnd.api.v1+json` | Clean URLs | Hidden version |
| **Query Param** | `/users?version=1` | Flexible | Easy to forget |

### Recommended: URI Path Versioning

- Most discoverable and debuggable
- Works with all HTTP clients
- Clear in logs and documentation

### Version Lifecycle

```
v1 (stable) -> v2 (current) -> v3 (beta)
     |              |
     v              v
  deprecated    supported
  (sunset in    (active
   6 months)    development)
```


## Authentication Patterns

### Pattern Selection

| Pattern | Best For | Security Level |
|---------|----------|----------------|
| **API Keys** | Server-to-server, simple integrations | Medium |
| **JWT** | Stateless auth, microservices | High |
| **OAuth 2.0** | Third-party access, user delegation | High |
| **Session Cookies** | Browser-based apps | High |
| **Passkeys/WebAuthn** | Passwordless user auth | Very High |

### JWT Best Practices

```json
{
  "header": {
    "alg": "RS256",
    "typ": "JWT"
  },
  "payload": {
    "sub": "user_123",
    "iss": "https://api.example.com",
    "aud": "https://app.example.com",
    "exp": 1699999999,
    "iat": 1699996399,
    "scope": "read:users write:users"
  }
}
```

| Practice | Recommendation |
|----------|----------------|
| Algorithm | RS256 (asymmetric) for public APIs |
| Expiration | Short-lived (15 min) with refresh tokens |
| Payload | Minimal claims, no sensitive data |
| Storage | HttpOnly cookies or secure storage |


## Rate Limiting Patterns

### Algorithms

| Algorithm | Description | Use Case |
|-----------|-------------|----------|
| **Token Bucket** | Tokens refill at fixed rate | Bursty traffic allowed |
| **Sliding Window** | Count requests in moving window | Smooth rate enforcement |
| **Fixed Window** | Count resets at intervals | Simple implementation |
| **Leaky Bucket** | Process at constant rate | Queue-based systems |

### Response Headers

```http
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1699999999
Retry-After: 60
```

### Rate Limit Tiers

| Tier | Limit | Use Case |
|------|-------|----------|
| Anonymous | 60/hour | Unauthenticated requests |
| Free | 1000/hour | Basic authenticated users |
| Pro | 10000/hour | Paid users |
| Enterprise | Custom | High-volume partners |


## Pagination Patterns

### Offset Pagination

```
GET /users?offset=20&limit=10
```
- Simple but inefficient for large offsets
- Results can shift with inserts/deletes

### Cursor Pagination (Recommended)

```
GET /users?cursor=eyJpZCI6MTAwfQ&limit=10

Response:
{
  "data": [...],
  "pagination": {
    "next_cursor": "eyJpZCI6MTEwfQ",
    "has_more": true
  }
}
```
- Consistent results
- Efficient for large datasets


## Quality Checks

| Check | Question |
|-------|----------|
| **Consistency** | Do all endpoints follow the same patterns? |
| **Security** | Is every endpoint authenticated and authorized? |
| **Documentation** | Is OpenAPI spec complete and accurate? |
| **Versioning** | Is there a clear deprecation policy? |
| **Error Handling** | Are errors consistent and informative? |
| **Rate Limiting** | Are all endpoints protected? |


## Anti-Patterns

| Pattern | Problem | Fix |
|---------|---------|-----|
| Verbs in URLs | `/getUsers`, `/createOrder` | Use nouns: `/users`, `/orders` |
| Inconsistent responses | Different formats per endpoint | Standardize envelope format |
| Exposing internals | Stack traces in errors | Generic error messages |
| No versioning | Breaking changes break clients | Version from day one |
| Ignoring HTTP semantics | POST for everything | Use appropriate methods |
| Deep nesting | `/a/{id}/b/{id}/c/{id}/d` | Max 2 levels deep |


## Content Map

| File | Description | When to Read |
|------|-------------|--------------|
| `api-style.md` | REST vs GraphQL vs tRPC decision tree | Choosing API type |
| `rest.md` | Resource naming, HTTP methods, status codes | Designing REST API |
| `response.md` | Envelope pattern, error format, pagination | Response structure |
| `graphql.md` | Schema design, when to use, security | Considering GraphQL |
| `trpc.md` | TypeScript monorepo, type safety | TS fullstack projects |
| `versioning.md` | URI/Header/Query versioning | API evolution planning |
| `auth.md` | JWT, OAuth, Passkey, API Keys | Auth pattern selection |
| `rate-limiting.md` | Token bucket, sliding window | API protection |
| `documentation.md` | OpenAPI/Swagger best practices | Documentation |
| `security-testing.md` | OWASP API Top 10, auth/authz testing | Security audits |


## Related Skills

| Need | Skill |
|------|-------|
| API implementation | `@[skills/backend-development]` |
| Data structure | `@[skills/database-design]` |
| Security details | `@[skills/security-hardening]` |


## Script

| Script | Purpose | Command |
|--------|---------|---------|
| `scripts/api_validator.py` | API endpoint validation | `python scripts/api_validator.py <project_path>` |
