---
name: database-design
description: Covers database schema design including normalization, entity relationships, constraints, and naming conventions. Use when designing new schemas, evaluating database technology choices, planning data relationships, optimizing queries, or reviewing existing schema designs.
---

# Database Design

> Master database schema design through principled thinking, not pattern copying. Learn to model data correctly for your specific context.


## Core Principles

| Principle | Rule |
|-----------|------|
| **Context First** | Choose database/ORM based on actual requirements, not defaults |
| **Ask Before Assuming** | Query user for database preferences when unclear |
| **Normalize Then Optimize** | Start normalized, denormalize only with evidence |
| **Constraints Are Documentation** | Use database constraints to enforce business rules |
| **Indexes Are Not Free** | Every index has write costs; measure before adding |
| **Names Are Contracts** | Table and column names should be self-documenting |


## When to Use

- Designing new database schemas
- Evaluating database technology choices
- Planning data relationships and constraints
- Optimizing query performance
- Reviewing existing schema designs
- Planning database migrations


## Selective Reading Rule

**Read ONLY files relevant to the request!** Check the content map, find what you need.

| File | Description | When to Read |
|------|-------------|--------------|
| `database-selection.md` | PostgreSQL vs Neon vs Turso vs SQLite | Choosing database |
| `orm-selection.md` | Drizzle vs Prisma vs Kysely | Choosing ORM |
| `schema-design.md` | Normalization, PKs, relationships | Designing schema |
| `indexing.md` | Index types, composite indexes | Performance tuning |
| `optimization.md` | N+1, EXPLAIN ANALYZE | Query optimization |
| `migrations.md` | Safe migrations, serverless DBs | Schema changes |


## Schema Design Principles

### Normalization Levels

| Normal Form | Rule | When to Apply |
|-------------|------|---------------|
| **1NF** | No repeating groups; atomic values | Always |
| **2NF** | No partial dependencies on composite keys | Multi-column PKs |
| **3NF** | No transitive dependencies | Most applications |
| **BCNF** | Every determinant is a candidate key | Complex domains |
| **4NF** | No multi-valued dependencies | Rare; analytics |

### When to Denormalize

| Scenario | Denormalization Strategy |
|----------|-------------------------|
| Read-heavy analytics | Materialized views or summary tables |
| Frequent joins hurting performance | Controlled redundancy with triggers |
| Caching derived values | Computed columns with update triggers |
| Document-style access patterns | JSON columns for nested data |

```sql
-- Example: Denormalized order total (update via trigger)
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  total_amount DECIMAL(10,2),  -- Denormalized
  item_count INTEGER,          -- Denormalized
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```


## Entity Relationship Modeling

### Relationship Types

| Type | Implementation | Example |
|------|---------------|---------|
| **One-to-One** | FK with UNIQUE constraint | user <-> profile |
| **One-to-Many** | FK on the "many" side | user -> orders |
| **Many-to-Many** | Junction/bridge table | users <-> roles |
| **Self-Referential** | FK to same table | employee -> manager |

### Junction Table Pattern

```sql
-- Many-to-many: Users and Roles
CREATE TABLE user_roles (
  user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  role_id INTEGER REFERENCES roles(id) ON DELETE CASCADE,
  assigned_at TIMESTAMPTZ DEFAULT NOW(),
  assigned_by INTEGER REFERENCES users(id),
  PRIMARY KEY (user_id, role_id)
);
```

### Polymorphic Relationships

| Pattern | Pros | Cons |
|---------|------|------|
| **Single Table Inheritance** | Simple queries | Nullable columns |
| **Class Table Inheritance** | Normalized | Complex joins |
| **Concrete Table Inheritance** | No joins | Duplicate schema |
| **Polymorphic FK** | Flexible | No referential integrity |

```sql
-- Polymorphic comments (use discriminator column)
CREATE TABLE comments (
  id SERIAL PRIMARY KEY,
  body TEXT NOT NULL,
  commentable_type VARCHAR(50) NOT NULL,  -- 'post', 'photo', 'video'
  commentable_id INTEGER NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_comments_target ON comments(commentable_type, commentable_id);
```


## Data Type Selection

### Numeric Types

| Use Case | Type | Notes |
|----------|------|-------|
| Primary keys | `INTEGER` / `BIGINT` | BIGINT for high-volume |
| Money/currency | `DECIMAL(precision,scale)` | Never FLOAT for money |
| Percentages | `DECIMAL(5,2)` | Or store as integer basis points |
| Counters | `INTEGER` | Consider overflow for BIGINT |
| Scientific | `DOUBLE PRECISION` | When approximation acceptable |

### String Types

| Use Case | Type | Notes |
|----------|------|-------|
| Fixed length codes | `CHAR(n)` | Country codes, status codes |
| Variable text | `VARCHAR(n)` | Names, titles, short text |
| Unlimited text | `TEXT` | Descriptions, content |
| Constrained values | `ENUM` or check constraint | Status, type fields |

### Temporal Types

| Use Case | Type | Notes |
|----------|------|-------|
| Points in time | `TIMESTAMPTZ` | Always use timezone-aware |
| Calendar dates | `DATE` | Birthdays, deadlines |
| Time of day | `TIME` | Store opening hours |
| Durations | `INTERVAL` | Subscription periods |

```sql
-- Temporal best practices
CREATE TABLE events (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  starts_at TIMESTAMPTZ NOT NULL,      -- Always TIMESTAMPTZ
  ends_at TIMESTAMPTZ NOT NULL,
  duration INTERVAL GENERATED ALWAYS AS (ends_at - starts_at) STORED,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

### Special Types

| Use Case | Type | Notes |
|----------|------|-------|
| UUIDs | `UUID` | Distributed systems, public IDs |
| IP addresses | `INET` | Network applications |
| JSON data | `JSONB` | Semi-structured data (prefer over JSON) |
| Arrays | `type[]` | Small, fixed collections |
| Binary data | `BYTEA` | Files, images (consider external storage) |


## Constraint Patterns

### Primary Keys

| Strategy | Pros | Cons | Use When |
|----------|------|------|----------|
| **Serial/Identity** | Simple, compact, ordered | Predictable, single DB | Most applications |
| **UUID** | Globally unique, secure | Larger, random I/O | Distributed, public IDs |
| **Natural Key** | Meaningful, no lookup | Can change, composite | Immutable business keys |
| **Composite** | No surrogate needed | Complex FKs | Junction tables |

```sql
-- Modern identity column (preferred over SERIAL)
CREATE TABLE users (
  id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  email VARCHAR(255) NOT NULL UNIQUE
);

-- UUID for public-facing IDs
CREATE TABLE api_keys (
  id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  public_id UUID DEFAULT gen_random_uuid() UNIQUE,
  secret_hash VARCHAR(255) NOT NULL
);
```

### Foreign Keys

```sql
-- Referential actions
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id)
    ON DELETE RESTRICT      -- Prevent user deletion with orders
    ON UPDATE CASCADE,      -- Update FK if user.id changes
  shipping_address_id INTEGER REFERENCES addresses(id)
    ON DELETE SET NULL      -- Allow address deletion
);
```

| Action | Behavior | Use When |
|--------|----------|----------|
| `RESTRICT` | Prevent parent deletion | Critical relationships |
| `CASCADE` | Delete/update children | Owned relationships |
| `SET NULL` | Nullify FK | Optional relationships |
| `SET DEFAULT` | Use default value | Fallback needed |
| `NO ACTION` | Check deferred | Complex transactions |

### Check Constraints

```sql
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
  discount_percent INTEGER CHECK (discount_percent BETWEEN 0 AND 100),
  status VARCHAR(20) CHECK (status IN ('draft', 'active', 'archived')),

  -- Multi-column constraint
  sale_start DATE,
  sale_end DATE,
  CONSTRAINT valid_sale_period CHECK (sale_end IS NULL OR sale_end > sale_start)
);
```

### Unique Constraints

```sql
-- Simple unique
ALTER TABLE users ADD CONSTRAINT unique_email UNIQUE (email);

-- Partial unique (only active users)
CREATE UNIQUE INDEX unique_active_username
  ON users(username)
  WHERE deleted_at IS NULL;

-- Composite unique
ALTER TABLE order_items ADD CONSTRAINT unique_order_product
  UNIQUE (order_id, product_id);
```


## Table Naming Conventions

### General Rules

| Rule | Good | Bad |
|------|------|-----|
| Plural table names | `users`, `orders` | `user`, `order` |
| Snake_case | `user_profiles` | `userProfiles`, `UserProfiles` |
| No prefixes | `orders` | `tbl_orders`, `t_orders` |
| Full words | `categories` | `cats`, `ctgrs` |
| Junction tables | `user_roles` | `users_roles_link` |

### Column Naming

| Pattern | Example | Notes |
|---------|---------|-------|
| Foreign keys | `user_id` | Table singular + `_id` |
| Booleans | `is_active`, `has_children` | Prefix with `is_`/`has_` |
| Timestamps | `created_at`, `updated_at` | Suffix with `_at` |
| Dates | `birth_date`, `due_date` | Suffix with `_date` |
| Counts | `comment_count` | Suffix with `_count` |
| Status | `status`, `state` | Use enum or check constraint |

### Index Naming

```sql
-- Convention: idx_{table}_{columns}_{type}
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_orders_user_created ON orders(user_id, created_at);
CREATE UNIQUE INDEX idx_users_username_unique ON users(username);
```


## Performance Considerations

### Index Strategy

| Query Pattern | Index Type |
|---------------|------------|
| Equality lookup | B-tree (default) |
| Range queries | B-tree |
| Full-text search | GIN with tsvector |
| JSON queries | GIN on JSONB |
| Array contains | GIN |
| Geospatial | GiST or SP-GiST |

### Composite Index Order

```sql
-- Order matters: leftmost columns first
-- Good for: WHERE status = ? AND created_at > ?
CREATE INDEX idx_orders_status_created ON orders(status, created_at);

-- Also covers: WHERE status = ?
-- Does NOT cover: WHERE created_at > ?
```

### Partial Indexes

```sql
-- Only index what you query
CREATE INDEX idx_orders_pending ON orders(created_at)
  WHERE status = 'pending';

-- Much smaller than full index
CREATE INDEX idx_users_active ON users(email)
  WHERE deleted_at IS NULL;
```

### Query Optimization Checklist

| Check | Command |
|-------|---------|
| Execution plan | `EXPLAIN ANALYZE SELECT ...` |
| Index usage | `EXPLAIN (ANALYZE, BUFFERS) SELECT ...` |
| Table statistics | `ANALYZE table_name;` |
| Index bloat | `SELECT * FROM pg_stat_user_indexes;` |


## Decision Checklist

Before designing schema:

- [ ] Asked user about database preference?
- [ ] Chosen database appropriate for THIS context?
- [ ] Considered deployment environment (serverless, edge)?
- [ ] Defined entity relationships and cardinality?
- [ ] Normalized to appropriate level (usually 3NF)?
- [ ] Identified denormalization needs with evidence?
- [ ] Selected appropriate data types?
- [ ] Defined all constraints (PK, FK, unique, check)?
- [ ] Planned index strategy for query patterns?
- [ ] Established naming conventions?


## Quality Checks

| Check | Question |
|-------|----------|
| **Normalization** | Is data duplicated unnecessarily? |
| **Constraints** | Are business rules enforced at DB level? |
| **Types** | Are types appropriate for the data? |
| **Indexes** | Do indexes match query patterns? |
| **Names** | Are names consistent and self-documenting? |
| **Relationships** | Are FKs defined with appropriate actions? |


## Anti-Patterns

| Pattern | Problem | Fix |
|---------|---------|-----|
| Default to PostgreSQL | Overkill for simple apps | Consider SQLite for single-user |
| Skip indexing | Slow queries at scale | Plan indexes with schema |
| Use SELECT * | Wasteful, breaks on schema change | Select specific columns |
| Store JSON for relational data | Lose query power, constraints | Use proper tables |
| Ignore N+1 queries | Performance death spiral | Use joins or batch loading |
| VARCHAR(255) everywhere | Wastes space, unclear intent | Size appropriately |
| No FK constraints | Orphaned data, integrity issues | Always define relationships |
| FLOAT for money | Precision errors | Use DECIMAL |
| Timestamp without TZ | Timezone bugs | Always use TIMESTAMPTZ |
| No updated_at column | Can't track changes | Add to all mutable tables |


## Database Security (CRITICAL)

### SQL Injection Prevention

```typescript
// ❌ NEVER: String concatenation
const query = `SELECT * FROM users WHERE email = '${email}'`; // SQL INJECTION!

// ✅ ALWAYS: Parameterized queries
// Prisma
const user = await prisma.user.findUnique({ where: { email: validatedEmail } });

// Drizzle
const users = await db.select().from(usersTable).where(eq(usersTable.email, validatedEmail));

// Raw SQL (always parameterized)
const result = await sql`SELECT * FROM users WHERE email = ${validatedEmail}`;

// ALWAYS validate inputs first
import { z } from "zod";
const emailSchema = z.string().email().max(255);
const validatedEmail = emailSchema.parse(userInput);
```

### Access Control

```sql
-- PostgreSQL: Use roles with least privilege
CREATE ROLE app_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO app_readonly;

CREATE ROLE app_readwrite;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO app_readwrite;

-- NEVER use superuser for application connections
-- Use connection pooling (PgBouncer, Prisma)
-- Enable SSL for connections
-- Encrypt sensitive columns (PII, payment data)
```

### Database Security Checklist

- [ ] Parameterized queries only (no string concatenation)
- [ ] All inputs validated before reaching database
- [ ] Least privilege database roles
- [ ] Connection pooling configured
- [ ] SSL/TLS for all connections
- [ ] Sensitive data encrypted at rest
- [ ] No unbounded arrays (MongoDB 16MB limit)
- [ ] Regular backups tested
- [ ] No secrets in schema/migration files


## Schema Design Example (Secure + Well-Structured)

```sql
-- Complete example following all conventions
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  display_name VARCHAR(100),
  role VARCHAR(20) NOT NULL DEFAULT 'user',
  email_verified_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  -- Constraints enforce business rules at DB level
  CONSTRAINT uq_users_email UNIQUE (email),
  CONSTRAINT chk_users_email CHECK (email ~* '^.+@.+\..+$'),
  CONSTRAINT chk_users_role CHECK (role IN ('admin', 'editor', 'user'))
);

-- Proper indexes for common queries
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role) WHERE role != 'user';
CREATE INDEX idx_users_created_at ON users(created_at DESC);
```


## Related Skills

- api-design - API layer over database
- data-modeling - Conceptual data design
- performance-optimization - Query tuning
- migrations - Schema evolution
