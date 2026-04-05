name: database-patterns
description: Covers database design patterns including Repository, Unit of Work, CQRS, indexing strategies, and connection pooling. Use when implementing data access layers, optimizing query performance, planning database migrations, or choosing between SQL and NoSQL approaches.

# Database Patterns

> Best practices for database design, optimization, and management.
> The right pattern depends on your read/write ratio and consistency requirements.


## Core Principles

| Principle | Rule |
|-----------|------|
| **Data Integrity** | Constraints at the database level, not just application |
| **Query First** | Design schema around query patterns |
| **Minimize Latency** | Reduce round trips, optimize access patterns |
| **Plan for Scale** | Design for 10x current load |
| **Explicit Transactions** | Clear transaction boundaries |


## When to Use

- Designing database schemas
- Implementing data access layer
- Optimizing query performance
- Planning database migrations
- Choosing between SQL and NoSQL


## Design Patterns Catalog

### Repository Pattern

Abstracts data access behind a domain-focused interface.

```typescript
interface UserRepository {
  findById(id: string): Promise<User | null>;
  findByEmail(email: string): Promise<User | null>;
  findActive(): Promise<User[]>;
  save(user: User): Promise<void>;
  delete(id: string): Promise<void>;
}

class PostgresUserRepository implements UserRepository {
  constructor(private db: Database) {}

  async findById(id: string): Promise<User | null> {
    const row = await this.db.query(
      'SELECT * FROM users WHERE id = $1',
      [id]
    );
    return row ? this.toDomain(row) : null;
  }
  // ... other methods
}
```

**Benefits:**
- Testable with in-memory implementations
- Domain-focused query methods
- Centralized data access logic

### Unit of Work Pattern

Tracks changes and commits them in a single transaction.

```typescript
interface UnitOfWork {
  users: UserRepository;
  orders: OrderRepository;
  commit(): Promise<void>;
  rollback(): Promise<void>;
}

// Usage
const uow = await unitOfWorkFactory.create();
try {
  const user = await uow.users.findById(userId);
  user.updateEmail(newEmail);
  await uow.users.save(user);

  const order = new Order(user.id, items);
  await uow.orders.save(order);

  await uow.commit();
} catch (error) {
  await uow.rollback();
  throw error;
}
```

**Use when:**
- Multiple related changes must succeed or fail together
- Need to coordinate changes across aggregates

### CQRS (Command Query Responsibility Segregation)

Separate read and write models for different optimization strategies.

```
┌──────────────┐     Commands     ┌──────────────┐
│   Client     │ ───────────────► │ Write Model  │
└──────────────┘                  │  (Domain)    │
       │                          └──────┬───────┘
       │                                 │
       │ Queries                   Events│
       │                                 ▼
       │                          ┌──────────────┐
       └─────────────────────────►│  Read Model  │
                                  │ (Optimized)  │
                                  └──────────────┘
```

| Aspect | Write Model | Read Model |
|--------|-------------|------------|
| **Focus** | Business rules | Query performance |
| **Schema** | Normalized | Denormalized |
| **Updates** | Direct writes | Event-driven sync |
| **Scaling** | Vertical | Horizontal |

**Use when:**
- Read/write patterns differ significantly
- Read scalability is critical
- Complex domain logic on writes

### Active Record vs Data Mapper

| Aspect | Active Record | Data Mapper |
|--------|---------------|-------------|
| **Simplicity** | High | Lower |
| **Testing** | Harder (DB coupling) | Easier (isolation) |
| **Domain purity** | Mixed with persistence | Clean domain |
| **Best for** | Simple CRUD apps | Complex domains |


## Schema Design

### Normalization Levels

| Form | Rule | Example Violation |
|------|------|-------------------|
| **1NF** | Atomic values only | `tags: "a,b,c"` in single column |
| **2NF** | No partial key dependencies | `order_items(order_id, product_id, product_name)` |
| **3NF** | No transitive dependencies | `employees(dept_id, dept_name)` |

### When to Denormalize

| Scenario | Denormalization Strategy |
|----------|--------------------------|
| Reporting dashboards | Materialized views |
| Read-heavy APIs | Precomputed aggregates |
| Frequently joined data | Embedded documents (NoSQL) |
| Audit/history | Event sourcing tables |

### Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| Tables | plural, snake_case | `user_accounts` |
| Columns | snake_case | `created_at` |
| Primary keys | `id` | `id` |
| Foreign keys | `{singular_table}_id` | `user_id` |
| Junction tables | `{table1}_{table2}` | `users_roles` |
| Indexes | `idx_{table}_{columns}` | `idx_users_email` |
| Unique constraints | `uq_{table}_{columns}` | `uq_users_email` |


## Indexing Strategies

### Index Selection Guide

| Query Pattern | Index Type |
|---------------|------------|
| Exact match (`WHERE email = ?`) | B-tree (default) |
| Range (`WHERE date > ?`) | B-tree |
| Pattern match (`WHERE name LIKE 'A%'`) | B-tree (prefix only) |
| Full text search | GIN/Full-text index |
| JSON fields | GIN |
| Geospatial | GiST/R-tree |

### Composite Index Rules

```sql
-- Index: (a, b, c)
-- Supports these queries efficiently:
WHERE a = ?
WHERE a = ? AND b = ?
WHERE a = ? AND b = ? AND c = ?
WHERE a = ? AND b > ?

-- Does NOT efficiently support:
WHERE b = ?           -- Missing leftmost column
WHERE a = ? AND c = ? -- Gap in columns
```

### Index Anti-Patterns

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| Index everything | Write overhead, maintenance | Index for specific queries |
| Missing covering index | Extra table lookup | Include needed columns |
| Wrong column order | Index not used | Analyze query patterns |
| Too many single-column indexes | Won't combine efficiently | Use composite indexes |

### Index Monitoring

```sql
-- PostgreSQL: Find unused indexes
SELECT indexrelid::regclass AS index,
       idx_scan AS scans
FROM pg_stat_user_indexes
WHERE idx_scan = 0
  AND indexrelid::regclass::text NOT LIKE '%_pkey';

-- MySQL: Find unused indexes
SELECT * FROM sys.schema_unused_indexes;
```


## Performance Optimization

### Query Optimization Checklist

| Check | Action |
|-------|--------|
| **EXPLAIN** | Analyze execution plan |
| **Index usage** | Verify indexes are being used |
| **N+1 queries** | Use eager loading/joins |
| **SELECT *** | Select only needed columns |
| **Pagination** | Use cursor-based for large sets |
| **Subqueries** | Consider CTEs or JOINs |

### Common Performance Patterns

```sql
-- Use EXISTS instead of IN for large subqueries
-- Bad
SELECT * FROM orders WHERE user_id IN (SELECT id FROM users WHERE active);

-- Good
SELECT * FROM orders o WHERE EXISTS (
  SELECT 1 FROM users u WHERE u.id = o.user_id AND u.active
);

-- Use covering index to avoid table lookup
CREATE INDEX idx_users_email_name ON users(email) INCLUDE (name);

-- Batch inserts
INSERT INTO logs (message, created_at)
VALUES
  ('msg1', NOW()),
  ('msg2', NOW()),
  ('msg3', NOW());
```

### Read Replica Patterns

| Pattern | Use Case |
|---------|----------|
| Read from replica | Reporting, analytics |
| Read-your-writes | Read from primary after write |
| Session consistency | Sticky sessions to same replica |


## Migration Best Practices

### Migration Principles

| Principle | Implementation |
|-----------|----------------|
| **Reversible** | Every migration has a rollback |
| **Atomic** | One logical change per migration |
| **Tested** | Run against production-like data |
| **Documented** | Clear description of change |

### Zero-Downtime Migrations

| Change | Safe Approach |
|--------|---------------|
| Add column | Add nullable, deploy code, backfill, add constraint |
| Remove column | Remove code references first, then column |
| Rename column | Add new, copy data, update code, remove old |
| Change type | Add new column, migrate data, swap references |
| Add index | CREATE INDEX CONCURRENTLY (Postgres) |

### Migration Example

```sql
-- migrations/20240115_add_user_status.up.sql
-- Add status column for user account states

ALTER TABLE users ADD COLUMN status VARCHAR(20);

-- Backfill existing users as active
UPDATE users SET status = 'active' WHERE status IS NULL;

-- Add constraint after backfill
ALTER TABLE users ALTER COLUMN status SET NOT NULL;
ALTER TABLE users ALTER COLUMN status SET DEFAULT 'pending';

-- migrations/20240115_add_user_status.down.sql
ALTER TABLE users DROP COLUMN status;
```


## Connection Pooling

### Pool Configuration

| Setting | Guideline | Notes |
|---------|-----------|-------|
| **Min connections** | 2-5 | Keep warm connections ready |
| **Max connections** | (CPU cores * 2) + disk spindles | Per application instance |
| **Idle timeout** | 10-30 minutes | Return unused connections |
| **Max lifetime** | 30-60 minutes | Prevent stale connections |
| **Validation query** | `SELECT 1` | Verify connection health |

### Pool Sizing Formula

```
Optimal pool size = (core_count * 2) + effective_spindle_count

Example: 4-core server with SSD
Pool size = (4 * 2) + 1 = 9 connections
```

### Connection Management

| Pattern | Description |
|---------|-------------|
| **Acquire on demand** | Get connection when needed |
| **Return promptly** | Use try-finally to ensure return |
| **Health checks** | Validate before use from pool |
| **Circuit breaker** | Stop attempting if pool exhausted |

```typescript
// Good: Connection scoped to request
async function handleRequest(req: Request) {
  const conn = await pool.acquire();
  try {
    return await processWithConnection(conn, req);
  } finally {
    pool.release(conn);
  }
}
```


## Soft Delete Pattern

```sql
-- Table structure
CREATE TABLE documents (
  id UUID PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  content TEXT,
  deleted_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create partial index for active records
CREATE INDEX idx_documents_active ON documents(title)
WHERE deleted_at IS NULL;

-- Soft delete
UPDATE documents SET deleted_at = NOW() WHERE id = $1;

-- Query active only (default)
SELECT * FROM documents WHERE deleted_at IS NULL;

-- Query including deleted
SELECT * FROM documents;
```


## Quality Checks

| Check | Question |
|-------|----------|
| **Indexes** | Are all WHERE/JOIN columns indexed? |
| **Constraints** | Are foreign keys and unique constraints defined? |
| **Transactions** | Are transaction boundaries explicit? |
| **Connection handling** | Are connections properly returned to pool? |
| **N+1 queries** | Are related records fetched efficiently? |
| **Migrations** | Are migrations reversible and tested? |


## Anti-Patterns

| Pattern | Problem | Fix |
|---------|---------|-----|
| **Storing JSON blobs** | Can't query, no constraints | Normalize or use proper JSON columns |
| **No foreign keys** | Orphaned data, integrity issues | Define relationships at DB level |
| **SELECT in loop** | N+1 queries | Use JOINs or batch queries |
| **Huge transactions** | Lock contention | Break into smaller units |
| **No indexes** | Full table scans | Analyze query patterns, add indexes |
| **Premature sharding** | Complexity without benefit | Scale vertically first |


## Related Skills

| Need | Skill |
|------|-------|
| API design | `@[skills/api-patterns]` |
| Architecture | `@[skills/architecture-principles]` |
| Security | `@[skills/security-planning]` |
