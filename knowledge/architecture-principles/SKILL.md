name: architecture-principles
description: Provides system architecture guidance including SOLID principles, layered and hexagonal patterns, and quality attribute trade-offs. Use when designing new systems, evaluating architectural decisions, reviewing system structure, or planning for scalability and maintainability.

# Architecture Principles

> Foundational patterns and principles for designing robust, maintainable systems.
> Architecture is about managing complexity through good abstractions.


## Core Principles

| Principle | Rule |
|-----------|------|
| **Separation of Concerns** | Each component has one clear responsibility |
| **High Cohesion** | Related functionality stays together |
| **Low Coupling** | Components minimize dependencies on each other |
| **Abstraction** | Hide complexity behind simple interfaces |
| **Explicit Dependencies** | Make all dependencies visible and injectable |


## When to Use

- Designing new systems or features
- Evaluating architectural trade-offs
- Reviewing system structure
- Making technology decisions
- Planning for scalability


## SOLID Principles

### Single Responsibility Principle (SRP)

> A class should have only one reason to change.

| Violation | Better Design |
|-----------|---------------|
| `UserService` handles auth, email, and reporting | Split into `AuthService`, `EmailService`, `ReportService` |
| Controller validates, processes, and persists | Controller delegates to validators and services |

### Open/Closed Principle (OCP)

> Software entities should be open for extension but closed for modification.

```
Bad:  if (type === 'pdf') {...} else if (type === 'csv') {...}
Good: exporters.get(type).export(data)  // Add new exporters without changing code
```

### Liskov Substitution Principle (LSP)

> Subtypes must be substitutable for their base types.

| Violation | Problem |
|-----------|---------|
| `Square extends Rectangle` | Setting width changes height unexpectedly |
| `ReadOnlyFile extends File` | `write()` throws exception |

### Interface Segregation Principle (ISP)

> Clients should not be forced to depend on methods they don't use.

```
Bad:  interface Worker { work(); eat(); sleep(); }
Good: interface Workable { work(); }
      interface Feedable { eat(); }
```

### Dependency Inversion Principle (DIP)

> Depend on abstractions, not concretions.

| Layer | Should Depend On |
|-------|------------------|
| Controllers | Service interfaces |
| Services | Repository interfaces |
| Repositories | Database abstraction |


## Architectural Patterns

### Layered Architecture

```
┌─────────────────────────────┐
│      Presentation Layer     │  UI, API Controllers
├─────────────────────────────┤
│      Application Layer      │  Use Cases, Orchestration
├─────────────────────────────┤
│        Domain Layer         │  Business Logic, Entities
├─────────────────────────────┤
│     Infrastructure Layer    │  Database, External Services
└─────────────────────────────┘
```

| Rule | Description |
|------|-------------|
| Dependencies flow downward | Upper layers depend on lower |
| No skipping layers | Presentation cannot access Infrastructure directly |
| Interfaces at boundaries | Define contracts between layers |

### Hexagonal Architecture (Ports & Adapters)

```
         ┌──────────────────────┐
         │    Primary Adapters  │  REST API, CLI, GraphQL
         │    (Driving Side)    │
         └──────────┬───────────┘
                    │
         ┌──────────▼───────────┐
         │     Application      │
         │    ┌──────────┐      │
         │    │  Domain  │      │  Business Logic
         │    └──────────┘      │
         └──────────┬───────────┘
                    │
         ┌──────────▼───────────┐
         │  Secondary Adapters  │  Database, Cache, APIs
         │    (Driven Side)     │
         └──────────────────────┘
```

**Benefits**: Domain is isolated, easy to test, adapters are swappable.

### Microservices Architecture

| Aspect | Guideline |
|--------|-----------|
| **Service Boundary** | Aligned with business domain (DDD bounded contexts) |
| **Communication** | Sync (REST/gRPC) for queries, async (events) for commands |
| **Data** | Each service owns its data, no shared databases |
| **Size** | Small enough to rewrite in 2 weeks |

### Event-Driven Architecture

| Pattern | Use Case |
|---------|----------|
| **Event Sourcing** | Audit trail required, temporal queries |
| **CQRS** | Different read/write models, high read scalability |
| **Pub/Sub** | Loose coupling, async processing |
| **Saga** | Distributed transactions across services |


## Common Design Patterns

### Repository Pattern

```typescript
interface UserRepository {
  findById(id: string): Promise<User | null>;
  findByEmail(email: string): Promise<User | null>;
  save(user: User): Promise<void>;
  delete(id: string): Promise<void>;
}
```

**Benefits**: Abstracts data access, enables testing with mocks, centralizes queries.

### Service Layer Pattern

| Responsibility | Example |
|----------------|---------|
| Orchestration | Coordinate multiple repositories |
| Transaction boundaries | Begin/commit/rollback |
| Business rules | Validate complex constraints |
| Cross-cutting concerns | Logging, caching |

### Factory Pattern

**Use when:**
- Object creation is complex
- Creation logic should be centralized
- Runtime type selection needed

### Strategy Pattern

**Use when:**
- Multiple algorithms for same operation
- Algorithm selection at runtime
- Avoiding large conditional blocks


## Quality Attributes

### Decision Matrix

| Attribute | Measurement | Trade-offs |
|-----------|-------------|------------|
| **Scalability** | Requests/sec at load | Cost, complexity |
| **Availability** | Uptime percentage (99.9%) | Cost, consistency |
| **Performance** | Latency p50, p95, p99 | Resource usage |
| **Maintainability** | Time to implement change | Initial complexity |
| **Security** | Vulnerabilities, compliance | Usability, performance |
| **Testability** | Code coverage, test time | Development time |

### Scalability Patterns

| Pattern | Description | When to Use |
|---------|-------------|-------------|
| **Horizontal Scaling** | Add more instances | Stateless services |
| **Vertical Scaling** | Bigger machines | Database, quick fix |
| **Caching** | Store computed results | Read-heavy workloads |
| **Sharding** | Partition data | Large datasets |
| **Load Balancing** | Distribute requests | Multiple instances |

### Availability Patterns

| Pattern | Description |
|---------|-------------|
| **Redundancy** | Multiple instances, regions |
| **Circuit Breaker** | Fail fast, prevent cascade |
| **Bulkhead** | Isolate failures |
| **Health Checks** | Detect and remove unhealthy instances |


## Trade-off Analysis Framework

### ATAM (Architecture Trade-off Analysis Method)

| Step | Action |
|------|--------|
| 1. Identify scenarios | What does the system need to do? |
| 2. Prioritize | Which scenarios matter most? |
| 3. Analyze | How does the architecture address each? |
| 4. Identify risks | Where might the architecture fail? |
| 5. Document | Record decisions and rationale |

### Decision Factors

| Factor | Questions to Ask |
|--------|------------------|
| **Complexity** | How much does this add? Can the team handle it? |
| **Scalability** | Will this work at 10x load? 100x? |
| **Maintainability** | Can new developers understand this? |
| **Testability** | Can we test components in isolation? |
| **Performance** | What's the latency impact? |
| **Cost** | Infrastructure, development, maintenance? |
| **Time to Market** | How quickly can we ship? |


## Decision Documentation (ADR)

### Template

```markdown
# ADR-XXX: [Decision Title]

## Status
Proposed | Accepted | Deprecated | Superseded by ADR-YYY

## Context
What is the issue? What forces are at play?

## Decision
What is the proposed change?

## Consequences
What are the results? Positive and negative.

## Alternatives Considered
What other options were evaluated and why rejected?
```

### When to Write an ADR

- Choosing between technologies
- Defining system boundaries
- Establishing patterns or conventions
- Making irreversible decisions
- Introducing significant dependencies


## Quality Checks

| Check | Question |
|-------|----------|
| **Cohesion** | Does each component do one thing well? |
| **Coupling** | Can components change independently? |
| **Testability** | Can you test without external dependencies? |
| **Clarity** | Can a new team member understand the structure? |
| **Consistency** | Are similar problems solved similarly? |
| **Flexibility** | How hard is it to add new features? |


## Anti-Patterns

| Pattern | Problem | Fix |
|---------|---------|-----|
| **Big Ball of Mud** | No clear structure | Define layers and boundaries |
| **God Class** | One class does everything | Split by responsibility |
| **Spaghetti Code** | Tangled dependencies | Apply dependency inversion |
| **Golden Hammer** | Same solution for everything | Choose tools for the job |
| **Premature Optimization** | Optimizing before measuring | Profile first, optimize second |
| **Cargo Cult** | Copying without understanding | Understand the "why" |


## Related Skills

| Need | Skill |
|------|-------|
| Database design | `@[skills/database-patterns]` |
| API design | `@[skills/api-patterns]` |
| Security architecture | `@[skills/security-planning]` |
| Documentation | `@[skills/documentation-standards]` |
