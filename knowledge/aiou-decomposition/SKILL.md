name: aiou-decomposition
description: Decomposes features into AI-Implementable Operational Units with dependency ordering and wave assignment. Use during Planning Phase 3.5, when breaking features into development tasks, ordering work by dependencies for parallel execution, estimating project effort, or creating implementation roadmaps.

# AIOU Decomposition

> Systematic methodology for breaking down features into atomic, implementable work units that can be executed by AI agents or developers in single sessions.


## Core Principles

| Principle | Rule |
|-----------|------|
| Atomicity | Each AIOU cannot be meaningfully split further |
| Independence | Minimal coupling with other units |
| Testability | Clear, verifiable acceptance criteria |
| Sizeability | Completable in a single session (2-4 hours) |
| Traceability | Maps directly to features and requirements |
| Orderable | Dependencies enable clear execution sequence |


## When to Use

- Planning Phase 3.5 (AIOU Gate) in project lifecycle
- Breaking features into development tasks for sprint planning
- Ordering work by dependencies for parallel execution
- Estimating project effort and timeline
- Assigning work to agents or team members
- Creating implementation roadmaps


## AIOU Structure and Format

### Standard AIOU Document Structure

```markdown
### AIOU-[PREFIX]-[NUMBER]: [Descriptive Name]

**Metadata**
| Field | Value |
|-------|-------|
| Wave | [0-6] |
| Feature | FEAT-XXX |
| Size | XS / S / M / L |
| Priority | P0 / P1 / P2 |
| Estimate | [hours] |
| Dependencies | AIOU-XXX, AIOU-YYY |
| Blocked By | [external blockers if any] |

#### Purpose
[Clear statement of what this AIOU accomplishes and why]

#### Inputs
- Input 1: [description and source]
- Input 2: [description and source]

#### Outputs
- Output 1: [description and destination]
- Output 2: [description and destination]

#### Implementation Notes
[Key technical decisions, constraints, or approaches]

#### Acceptance Criteria
- [ ] AC-1: [Specific, measurable criterion]
- [ ] AC-2: [Specific, measurable criterion]
- [ ] AC-3: [Specific, measurable criterion]

#### Files to Create/Modify
- `src/path/to/new-file.ts` (create)
- `src/path/to/existing-file.ts` (modify)

#### Test Requirements
- Unit test: [what to test]
- Integration test: [what to verify]
```


## Size Estimation Guidelines

### Size Categories

| Size | Code Lines | Time Estimate | Typical Scope | Complexity |
|------|------------|---------------|---------------|------------|
| XS | < 50 | 30 min - 1 hr | Single function, type definition | Trivial |
| S | 50-100 | 1-2 hours | Single component/function set | Low |
| M | 100-300 | 2-4 hours | Related functions/module | Medium |
| L | 300-500 | 4-6 hours | Complex feature slice | High |

### Size Estimation Factors

```
Size Score = Base Complexity + Integration Points + Domain Complexity

Base Complexity:
- Simple CRUD: +1
- Business logic: +2
- Algorithm: +3
- State machine: +3

Integration Points:
- No external deps: +0
- 1-2 integrations: +1
- 3+ integrations: +2

Domain Complexity:
- Standard patterns: +0
- Domain-specific: +1
- Novel approach: +2

Total 1-3: XS    Total 4-5: S    Total 6-7: M    Total 8+: L
```

### Size Red Flags

| Indicator | Problem | Action |
|-----------|---------|--------|
| L size | Too large for single session | Split into 2-3 smaller AIOs |
| Multiple "ands" in name | Doing too much | Separate by responsibility |
| 5+ files modified | Cross-cutting concern | Consider vertical slicing |
| Dependencies on 4+ AIOs | Integration heavy | May need prerequisite wave |


## Decomposition Strategies

### 1. Vertical Slice Decomposition

**Best for**: User-facing features, full-stack work

Slices through all layers for a single capability:

```
Feature: User Authentication

Vertical Slice 1: Email Login
├── AIOU-001: Login form component (UI)
├── AIOU-002: Auth API endpoint (API)
├── AIOU-003: User validation service (Service)
└── AIOU-004: Session management (Data)

Vertical Slice 2: Password Reset
├── AIOU-005: Reset form component (UI)
├── AIOU-006: Reset API endpoint (API)
├── AIOU-007: Token generation service (Service)
└── AIOU-008: Token storage (Data)
```

**Advantages**:
- Each slice delivers user value
- Enables incremental delivery
- Clear end-to-end testing

### 2. Horizontal Layer Decomposition

**Best for**: Infrastructure, shared services, platform work

Builds complete layers before moving up:

```
Feature: Data Platform

Layer 1: Data Layer
├── AIOU-001: Database schema
├── AIOU-002: Repository interfaces
└── AIOU-003: Repository implementations

Layer 2: Service Layer
├── AIOU-004: Domain services
├── AIOU-005: Validation services
└── AIOU-006: Business rules engine

Layer 3: API Layer
├── AIOU-007: REST controllers
├── AIOU-008: GraphQL resolvers
└── AIOU-009: API documentation
```

**Advantages**:
- Establishes solid foundation
- Maximizes code reuse
- Clear architectural boundaries

### 3. Hybrid Decomposition

**Best for**: Complex features requiring both approaches

```
Phase 1 (Horizontal): Foundation
├── AIOU-001: Core types and interfaces
├── AIOU-002: Shared utilities
└── AIOU-003: Base components

Phase 2 (Vertical): Feature Slices
├── Slice A: [User Management vertical]
└── Slice B: [Content Management vertical]

Phase 3 (Horizontal): Cross-cutting
├── AIOU-020: Error handling standardization
└── AIOU-021: Logging integration
```


## Dependency Mapping Patterns

### Dependency Types

| Type | Symbol | Description | Example |
|------|--------|-------------|---------|
| Hard | `-->` | Must complete before | Types before implementation |
| Soft | `..>` | Should complete before | Helps but not blocking |
| Data | `==>` | Shares data contract | API and consumer |
| Test | `~~>` | Testing dependency | Mocks before tests |

### Dependency Graph Construction

```
Step 1: List all AIOs
Step 2: For each AIOU, ask:
  - What must exist for this to start?
  - What does this produce that others need?
  - What interfaces does this consume?
  - What interfaces does this expose?
Step 3: Draw edges between dependent AIOs
Step 4: Verify no cycles
Step 5: Assign waves based on longest path
```

### Example Dependency Graph

```
                    ┌─────────────────┐
                    │   AIOU-001      │
                    │  Types/Interfaces│
                    └────────┬────────┘
                             │
           ┌─────────────────┼─────────────────┐
           │                 │                 │
           ▼                 ▼                 ▼
    ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
    │  AIOU-002    │ │  AIOU-003    │ │  AIOU-004    │
    │  Utilities   │ │  DB Schema   │ │  Config      │
    └──────┬───────┘ └──────┬───────┘ └──────────────┘
           │                │
           │                ▼
           │        ┌──────────────┐
           │        │  AIOU-005    │
           │        │  Repository  │
           │        └──────┬───────┘
           │                │
           └────────┬───────┘
                    ▼
             ┌──────────────┐
             │  AIOU-006    │
             │  Service     │
             └──────┬───────┘
                    │
                    ▼
             ┌──────────────┐
             │  AIOU-007    │
             │  API Layer   │
             └──────────────┘
```

### Cycle Detection and Resolution

```python
# Pseudo-code for cycle detection
def detect_cycles(aious):
    for aiou in aious:
        visited = set()
        if has_cycle(aiou, visited, aious):
            print(f"Cycle detected involving {aiou}")
            suggest_resolution(aiou, visited)

# Resolution strategies:
# 1. Extract shared interface to earlier wave
# 2. Use dependency injection
# 3. Introduce event-based decoupling
# 4. Merge tightly coupled AIOs
```


## Acceptance Criteria Patterns

### SMART Criteria Format

| Component | Question | Example |
|-----------|----------|---------|
| Specific | What exactly? | "User can log in with email" |
| Measurable | How to verify? | "Returns JWT token within 500ms" |
| Achievable | Within scope? | "Uses existing auth library" |
| Relevant | Tied to feature? | "Enables user session management" |
| Time-bound | When done? | "Verified by automated test" |

### Acceptance Criteria Templates

**Functional Criteria**:
```markdown
- [ ] Given [precondition], when [action], then [result]
- [ ] System accepts [valid inputs] and produces [expected output]
- [ ] System rejects [invalid inputs] with [specific error]
```

**Non-Functional Criteria**:
```markdown
- [ ] Response time < [X]ms for [operation]
- [ ] Handles [N] concurrent requests without degradation
- [ ] Gracefully degrades when [dependency] unavailable
```

**Quality Criteria**:
```markdown
- [ ] Code coverage >= [X]% for new code
- [ ] No TypeScript errors or warnings
- [ ] Passes all linting rules
- [ ] Documentation for public APIs
```

### Common Criteria by AIOU Type

| AIOU Type | Essential Criteria |
|-----------|-------------------|
| Type Definition | Compiles, exported, documented |
| API Endpoint | Status codes, validation, auth |
| UI Component | Renders, accessible, responsive |
| Service | Input validation, error handling, logging |
| Database | Schema valid, migrations work, indexes |
| Integration | Contract tests pass, retry logic works |


## Wave Assignment Guidelines

### Standard Wave Structure

```
Wave 0: Foundation (No Dependencies)
├── Type definitions
├── Interfaces
├── Constants
└── Configuration schemas

Wave 1: Core Utilities (Depends on Wave 0)
├── Helper functions
├── Validation utilities
├── Formatting utilities
└── Common components

Wave 2: Data Layer (Depends on Wave 0-1)
├── Database schemas
├── Repository interfaces
├── Repository implementations
└── Data migrations

Wave 3: Business Services (Depends on Wave 2)
├── Domain services
├── Business rules
├── Workflows
└── External service clients

Wave 4: API Layer (Depends on Wave 3)
├── REST endpoints
├── GraphQL resolvers
├── WebSocket handlers
└── API middleware

Wave 5: UI Components (Depends on Wave 4)
├── Feature components
├── Pages/views
├── Forms
└── Data display components

Wave 6: Integration & Polish (Depends on Wave 5)
├── E2E flows
├── Performance optimization
├── Cross-cutting concerns
└── Documentation
```

### Wave Assignment Algorithm

```
function assignWave(aiou):
    if aiou.dependencies.isEmpty():
        return 0

    maxDependencyWave = 0
    for dep in aiou.dependencies:
        depWave = assignWave(dep)
        maxDependencyWave = max(maxDependencyWave, depWave)

    return maxDependencyWave + 1
```

### Wave Parallelization

```
Within each wave, AIOs can execute in parallel if:
├── No shared file modifications
├── No data dependencies
├── No resource conflicts
└── Independent test execution

Wave 3 Parallel Execution Example:
├── Thread 1: AIOU-301 (User Service)
├── Thread 2: AIOU-302 (Product Service)
├── Thread 3: AIOU-303 (Order Service)
└── Thread 4: AIOU-304 (Notification Service)
```


## Priority Assignment

### Priority Levels

| Priority | Code | Criteria | SLA |
|----------|------|----------|-----|
| Critical | P0 | Blocks all progress, security issue | Immediate |
| High | P1 | Blocks major feature, dependencies wait | This wave |
| Medium | P2 | Important but not blocking | Next wave |
| Low | P3 | Nice to have, can defer | Backlog |

### Priority Matrix

```
                    IMPACT
                Low    Medium    High
            ┌────────┬────────┬────────┐
      High  │   P2   │   P1   │   P0   │
URGENCY     ├────────┼────────┼────────┤
      Med   │   P3   │   P2   │   P1   │
            ├────────┼────────┼────────┤
      Low   │   P3   │   P3   │   P2   │
            └────────┴────────┴────────┘
```

### Priority Factors

| Factor | Weight | Questions |
|--------|--------|-----------|
| Dependency Count | High | How many AIOs are blocked by this? |
| Business Value | High | Does this enable revenue/users? |
| Technical Risk | Medium | Is this on the critical path? |
| Effort | Low | Is this quick win or complex? |


## Complete Example: E-commerce Cart Feature

```markdown
## Feature: Shopping Cart (FEAT-015)

### Wave 0: Types

#### AIOU-015-001: Cart Domain Types
**Size**: XS | **Priority**: P0 | **Estimate**: 1 hr

**Purpose**: Define TypeScript types for cart entities

**Acceptance Criteria**:
- [ ] CartItem interface with product, quantity, price
- [ ] Cart interface with items, totals, metadata
- [ ] CartEvent union type for state changes
- [ ] All types exported from index

**Files**: `src/types/cart.ts`

---

### Wave 2: Data Layer

#### AIOU-015-002: Cart Repository
**Size**: S | **Priority**: P1 | **Estimate**: 2 hr
**Dependencies**: AIOU-015-001

**Purpose**: Implement cart persistence operations

**Acceptance Criteria**:
- [ ] Create cart with session ID
- [ ] Add/remove/update items
- [ ] Calculate totals correctly
- [ ] Handle concurrent modifications

**Files**:
- `src/repositories/cart.repository.ts`
- `src/repositories/__tests__/cart.repository.test.ts`

---

### Wave 3: Service Layer

#### AIOU-015-003: Cart Service
**Size**: M | **Priority**: P1 | **Estimate**: 3 hr
**Dependencies**: AIOU-015-002

**Purpose**: Business logic for cart operations

**Acceptance Criteria**:
- [ ] Validate product availability before add
- [ ] Apply quantity limits
- [ ] Calculate taxes and shipping estimates
- [ ] Emit cart events for analytics

**Files**:
- `src/services/cart.service.ts`
- `src/services/__tests__/cart.service.test.ts`

---

### Wave 4: API Layer

#### AIOU-015-004: Cart API Endpoints
**Size**: M | **Priority**: P1 | **Estimate**: 3 hr
**Dependencies**: AIOU-015-003

**Purpose**: REST API for cart operations

**Acceptance Criteria**:
- [ ] GET /cart - retrieve current cart
- [ ] POST /cart/items - add item
- [ ] PATCH /cart/items/:id - update quantity
- [ ] DELETE /cart/items/:id - remove item
- [ ] All endpoints return consistent response format

**Files**:
- `src/api/cart.controller.ts`
- `src/api/__tests__/cart.controller.test.ts`

---

### Wave 5: UI Components

#### AIOU-015-005: Cart Component
**Size**: M | **Priority**: P1 | **Estimate**: 4 hr
**Dependencies**: AIOU-015-004

**Purpose**: Interactive cart UI component

**Acceptance Criteria**:
- [ ] Display cart items with images, prices
- [ ] Quantity adjustment controls
- [ ] Remove item functionality
- [ ] Real-time total updates
- [ ] Empty cart state handling
- [ ] Loading and error states

**Files**:
- `src/components/Cart/Cart.tsx`
- `src/components/Cart/CartItem.tsx`
- `src/components/Cart/__tests__/Cart.test.tsx`
```


## Quality Checks

| Check | Question |
|-------|----------|
| Coverage | Does every feature map to at least one AIOU? |
| Atomicity | Can any AIOU be split further meaningfully? |
| Independence | Are dependencies minimized and explicit? |
| Testability | Does each AIOU have verifiable acceptance criteria? |
| Sizing | Are all AIOs completable in single sessions? |
| Ordering | Is the dependency graph acyclic? |
| Traceability | Can each AIOU trace back to requirements? |
| Completeness | Are all system layers covered? |


## Anti-Patterns

| Pattern | Problem | Fix |
|---------|---------|-----|
| Mega-AIOU | Too large, takes multiple days | Split by responsibility or layer |
| Orphan AIOU | No clear feature mapping | Link to feature or remove |
| Circular Dependency | Cannot determine order | Extract shared interface |
| Implicit Dependency | Missing in graph, causes failures | Document all inputs/outputs |
| Kitchen Sink | AIOU touches too many files | Apply single responsibility |
| Vague Criteria | "Should work well" | Make SMART and testable |
| Missing Wave 0 | Start coding without types | Always begin with foundation |
| Premature Integration | Wave 6 work in Wave 2 | Defer integration concerns |


## Validation Checklist

Before finalizing AIOU decomposition:

- [ ] Every feature maps to at least one AIOU
- [ ] No circular dependencies exist
- [ ] All dependencies assigned to earlier waves
- [ ] Each AIOU has 3+ acceptance criteria
- [ ] Size estimates are realistic for single sessions
- [ ] Priority assignments reflect business value
- [ ] Wave 0 contains all foundational types
- [ ] Integration points are explicitly identified
- [ ] Test requirements are documented
- [ ] Files to modify are listed


## Related Skills

- **feature-spec-writing**: Defines features that become AIOs
- **test-patterns**: Testing approach for each AIOU
- **dependency-analysis**: Deep dive on dependency mapping
- **estimation-techniques**: Detailed estimation methods
- **sprint-planning**: Using AIOs for sprint organization
