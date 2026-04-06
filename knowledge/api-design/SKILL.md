---
name: api-design
description: Covers RESTful API design including resource modeling, endpoint conventions, and OpenAPI specifications. Use when designing new API endpoints, reviewing API contracts, creating OpenAPI specs, establishing API standards, or implementing contract-first development during Wave 4.
---

# API Design

> Design clean, consistent, and developer-friendly APIs. Build contracts first, then implement.


## Core Principles

| Principle | Rule |
|-----------|------|
| **Resources Over Actions** | Model nouns, not verbs; let HTTP methods express actions |
| **Consistency Is Key** | Same patterns everywhere; predictability aids adoption |
| **Contract First** | Define the API spec before writing code |
| **Consumer Perspective** | Design for the API consumer, not the database |
| **Explicit Errors** | Clear, actionable error messages |
| **Versioning From Day One** | Plan for evolution; breaking changes are expensive |


## When to Use

- Designing new API endpoints
- Reviewing API contracts
- Implementing API layer (Wave 4)
- Creating OpenAPI/Swagger specifications
- Establishing API standards for a project
- API versioning decisions


## RESTful Resource Modeling

### Resource Identification

| Concept | Good Example | Bad Example | Why |
|---------|--------------|-------------|-----|
| Collections | `/users` | `/getUsers` | Nouns, not verbs |
| Singleton | `/users/{id}` | `/user?id=123` | Path params for identity |
| Sub-resources | `/users/{id}/orders` | `/orders?userId=123` | Shows ownership |
| Actions (rare) | `/orders/{id}/cancel` | `/cancelOrder/{id}` | Verb as last resort |

### Resource Hierarchy

```
/users
/users/{userId}
/users/{userId}/profile
/users/{userId}/orders
/users/{userId}/orders/{orderId}
/users/{userId}/orders/{orderId}/items
/users/{userId}/orders/{orderId}/items/{itemId}
```

### Modeling Relationships

| Relationship | Pattern | Example |
|--------------|---------|---------|
| One-to-One | Nested resource | `/users/{id}/profile` |
| One-to-Many (owned) | Sub-collection | `/users/{id}/orders` |
| One-to-Many (reference) | Query param | `/orders?userId=123` |
| Many-to-Many | Either direction | `/users/{id}/roles` or `/roles/{id}/users` |

### Resource State Diagram

```
[Draft] --publish--> [Published] --archive--> [Archived]
   ^                      |                        |
   |                      v                        |
   +------unpublish------+                        |
   |                                              |
   +------------------restore---------------------+
```


## Endpoint Naming Conventions

### URL Structure

```
https://api.example.com/v1/users/{userId}/orders?status=pending&limit=20
|_____________________| |_| |____| |_____| |____| |___________________|
        Base URL       Ver Resource  ID    Sub-    Query Parameters
                                          resource
```

### Naming Rules

| Rule | Good | Bad |
|------|------|-----|
| Lowercase | `/users` | `/Users` |
| Hyphens for multi-word | `/user-profiles` | `/userProfiles`, `/user_profiles` |
| Plural for collections | `/orders` | `/order` |
| No trailing slash | `/users` | `/users/` |
| No file extensions | `/users` | `/users.json` |
| No CRUD in URL | `POST /users` | `POST /createUser` |

### Query Parameters

| Purpose | Parameter | Example |
|---------|-----------|---------|
| Filtering | Field name | `?status=active&role=admin` |
| Sorting | `sort` / `order` | `?sort=created_at&order=desc` |
| Pagination | `page`, `limit` | `?page=2&limit=20` |
| Field selection | `fields` | `?fields=id,name,email` |
| Search | `q` or `search` | `?q=john` |
| Expansion | `expand` / `include` | `?expand=orders,profile` |


## HTTP Methods

| Method | Purpose | Idempotent | Safe | Request Body |
|--------|---------|------------|------|--------------|
| GET | Read resource(s) | Yes | Yes | No |
| POST | Create resource | No | No | Yes |
| PUT | Replace resource | Yes | No | Yes |
| PATCH | Partial update | Yes | No | Yes |
| DELETE | Remove resource | Yes | No | Optional |
| OPTIONS | Get allowed methods | Yes | Yes | No |
| HEAD | Get headers only | Yes | Yes | No |

### Method Selection Guide

```
Need to read data?
  └─> GET

Need to create new resource?
  ├─> With client ID → PUT /resource/{id}
  └─> Server generates ID → POST /resource

Need to update resource?
  ├─> Replace entirely → PUT /resource/{id}
  └─> Partial update → PATCH /resource/{id}

Need to delete resource?
  └─> DELETE /resource/{id}

Need to trigger action (no resource)?
  └─> POST /resource/{id}/action
```


## Status Codes

### Success Codes

| Code | Meaning | Use Case |
|------|---------|----------|
| 200 | OK | Successful GET, PUT, PATCH |
| 201 | Created | Successful POST (include Location header) |
| 202 | Accepted | Async operation started |
| 204 | No Content | Successful DELETE or PUT with no response body |

### Client Error Codes

| Code | Meaning | Use Case |
|------|---------|----------|
| 400 | Bad Request | Malformed request syntax |
| 401 | Unauthorized | Missing or invalid authentication |
| 403 | Forbidden | Authenticated but not authorized |
| 404 | Not Found | Resource doesn't exist |
| 405 | Method Not Allowed | HTTP method not supported |
| 409 | Conflict | State conflict (duplicate, version mismatch) |
| 422 | Unprocessable Entity | Validation failed |
| 429 | Too Many Requests | Rate limit exceeded |

### Server Error Codes

| Code | Meaning | Use Case |
|------|---------|----------|
| 500 | Internal Server Error | Unexpected server failure |
| 502 | Bad Gateway | Upstream service error |
| 503 | Service Unavailable | Maintenance or overload |
| 504 | Gateway Timeout | Upstream service timeout |


## Request/Response Design Patterns

### Collection Response

```json
{
  "data": [
    { "id": "1", "type": "users", "attributes": { "name": "Alice" } },
    { "id": "2", "type": "users", "attributes": { "name": "Bob" } }
  ],
  "meta": {
    "total": 150,
    "page": 1,
    "limit": 20,
    "totalPages": 8
  },
  "links": {
    "self": "/api/v1/users?page=1&limit=20",
    "first": "/api/v1/users?page=1&limit=20",
    "prev": null,
    "next": "/api/v1/users?page=2&limit=20",
    "last": "/api/v1/users?page=8&limit=20"
  }
}
```

### Single Resource Response

```json
{
  "data": {
    "id": "123",
    "type": "users",
    "attributes": {
      "name": "Alice Smith",
      "email": "alice@example.com",
      "createdAt": "2024-01-15T10:30:00Z"
    },
    "relationships": {
      "orders": {
        "links": { "related": "/api/v1/users/123/orders" }
      }
    }
  },
  "links": {
    "self": "/api/v1/users/123"
  }
}
```

### Error Response

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Request validation failed",
    "details": [
      {
        "field": "email",
        "code": "INVALID_FORMAT",
        "message": "Email must be a valid email address"
      },
      {
        "field": "age",
        "code": "OUT_OF_RANGE",
        "message": "Age must be between 18 and 120"
      }
    ],
    "requestId": "req_abc123",
    "documentation": "https://api.example.com/docs/errors#VALIDATION_ERROR"
  }
}
```

### Request Body (Create)

```json
{
  "name": "Alice Smith",
  "email": "alice@example.com",
  "role": "user",
  "preferences": {
    "notifications": true,
    "theme": "dark"
  }
}
```

### Request Body (Partial Update - PATCH)

```json
{
  "name": "Alice Johnson",
  "preferences": {
    "theme": "light"
  }
}
```


## API Contract-First Development

### Workflow

```
1. Define Requirements
       ↓
2. Design API Contract (OpenAPI)
       ↓
3. Review with Stakeholders
       ↓
4. Generate Server Stubs
       ↓
5. Generate Client SDKs
       ↓
6. Implement Business Logic
       ↓
7. Validate Against Contract
       ↓
8. Deploy and Document
```

### Contract Review Checklist

| Category | Check |
|----------|-------|
| **Naming** | Consistent, clear resource names? |
| **Methods** | Correct HTTP methods for operations? |
| **Status Codes** | Appropriate codes for all responses? |
| **Errors** | All error cases documented? |
| **Validation** | Input constraints specified? |
| **Security** | Auth requirements defined? |
| **Versioning** | Version strategy clear? |
| **Pagination** | Collection endpoints paginated? |

### Benefits of Contract-First

| Benefit | Description |
|---------|-------------|
| Parallel Development | Frontend and backend work simultaneously |
| Early Validation | Catch design issues before coding |
| Documentation | Spec IS the documentation |
| Mock Servers | Test integrations before implementation |
| SDK Generation | Auto-generate client libraries |
| Contract Testing | Validate implementation matches spec |


## OpenAPI/Swagger Integration

### Basic OpenAPI Structure

```yaml
openapi: 3.0.3
info:
  title: User Management API
  version: 1.0.0
  description: API for managing users and their resources
  contact:
    name: API Support
    email: api@example.com

servers:
  - url: https://api.example.com/v1
    description: Production
  - url: https://staging-api.example.com/v1
    description: Staging

paths:
  /users:
    get:
      summary: List all users
      operationId: listUsers
      tags:
        - Users
      parameters:
        - $ref: '#/components/parameters/PageParam'
        - $ref: '#/components/parameters/LimitParam'
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UserList'
        '401':
          $ref: '#/components/responses/Unauthorized'

    post:
      summary: Create a user
      operationId: createUser
      tags:
        - Users
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateUserRequest'
      responses:
        '201':
          description: User created
          headers:
            Location:
              schema:
                type: string
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
        '422':
          $ref: '#/components/responses/ValidationError'

components:
  schemas:
    User:
      type: object
      required:
        - id
        - email
        - name
      properties:
        id:
          type: string
          format: uuid
        email:
          type: string
          format: email
        name:
          type: string
          minLength: 1
          maxLength: 100
        createdAt:
          type: string
          format: date-time

    CreateUserRequest:
      type: object
      required:
        - email
        - name
      properties:
        email:
          type: string
          format: email
        name:
          type: string
          minLength: 1
          maxLength: 100

  parameters:
    PageParam:
      name: page
      in: query
      schema:
        type: integer
        minimum: 1
        default: 1

    LimitParam:
      name: limit
      in: query
      schema:
        type: integer
        minimum: 1
        maximum: 100
        default: 20

  responses:
    Unauthorized:
      description: Authentication required
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'

    ValidationError:
      description: Validation failed
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'

  securitySchemes:
    BearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT

security:
  - BearerAuth: []
```

### OpenAPI Best Practices

| Practice | Description |
|----------|-------------|
| Use `$ref` | Reuse schemas, parameters, responses |
| operationId | Unique, descriptive IDs for code gen |
| Tags | Group related endpoints |
| Examples | Include request/response examples |
| Descriptions | Document all fields |
| Validation | Use format, pattern, min/max |


## API Versioning

### Versioning Strategies

| Strategy | Example | Pros | Cons |
|----------|---------|------|------|
| URL Path | `/v1/users` | Clear, cacheable | Clutters URL |
| Query Param | `/users?version=1` | Optional | Easy to forget |
| Header | `Accept: application/vnd.api.v1+json` | Clean URLs | Hidden |
| Content Negotiation | `Accept: application/vnd.api+json; version=1` | RESTful | Complex |

### Version Lifecycle

```
v1 (current) ─────────────────────────────────────> v1 (deprecated)
                                                          |
v2 (beta) ──> v2 (current) ──────────────────────> v2 (deprecated)
                                                          |
              v3 (beta) ──> v3 (current) ─────────────────>
```

### Breaking vs Non-Breaking Changes

| Non-Breaking (Safe) | Breaking (Requires New Version) |
|---------------------|--------------------------------|
| Add optional field | Remove field |
| Add new endpoint | Change field type |
| Add optional parameter | Rename field |
| Deprecate (with notice) | Change URL structure |
| Add enum value | Remove enum value |
| Relax validation | Tighten validation |


## API Design Review Checklist

### Naming & Structure
- [ ] Resource names are nouns, not verbs
- [ ] URLs use lowercase and hyphens
- [ ] Collection names are plural
- [ ] Relationships modeled appropriately

### HTTP Semantics
- [ ] Correct HTTP methods used
- [ ] Appropriate status codes returned
- [ ] Idempotency guarantees documented
- [ ] Safe methods don't modify state

### Request/Response
- [ ] Request bodies are minimal and clear
- [ ] Response envelopes are consistent
- [ ] Pagination for all collections
- [ ] Timestamps in ISO 8601 format

### Error Handling
- [ ] Error response format is consistent
- [ ] Error codes are documented
- [ ] Error messages are actionable
- [ ] Validation errors include field details

### Security
- [ ] Authentication method documented
- [ ] Authorization rules specified
- [ ] Sensitive data not in URLs
- [ ] Rate limiting defined

### Documentation
- [ ] OpenAPI spec is complete
- [ ] All endpoints documented
- [ ] Examples for requests/responses
- [ ] Error cases documented


## Quality Checks

| Check | Question |
|-------|----------|
| **Consistency** | Do all endpoints follow the same patterns? |
| **Completeness** | Are all CRUD operations covered where needed? |
| **Documentation** | Is the OpenAPI spec up to date? |
| **Errors** | Are all error scenarios handled? |
| **Security** | Is authentication/authorization defined? |
| **Versioning** | Is the versioning strategy clear? |


## Anti-Patterns

| Pattern | Problem | Fix |
|---------|---------|-----|
| Verbs in URLs | `/getUsers`, `/createOrder` | Use HTTP methods |
| Inconsistent naming | `/users` vs `/Order` | Establish conventions |
| Ignoring status codes | Always return 200 | Use semantic codes |
| Nested resources too deep | `/a/{}/b/{}/c/{}/d/{}` | Flatten at 3+ levels |
| No pagination | Return all records | Always paginate collections |
| Leaking internal IDs | Sequential database IDs | Use UUIDs for public APIs |
| No versioning | Breaking changes break clients | Version from start |
| Generic errors | `{ "error": "Something went wrong" }` | Specific, actionable messages |
| Timestamps without timezone | `"2024-01-15 10:30:00"` | ISO 8601 with timezone |
| Ignoring HATEOAS | No links in responses | Include navigation links |


## Related Skills

- database-design - Backend data modeling
- authentication - Security implementation
- validation - Input validation patterns
- error-handling - Error response design
