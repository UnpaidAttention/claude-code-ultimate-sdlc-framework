---
name: performance-optimization
description: Identify and resolve performance bottlenecks across frontend rendering, API latency, database queries, and memory usage. Use during Enhancement Council phases, when profiling application performance, optimizing critical paths, or establishing performance budgets and targets.
---

# Performance Optimization

Identify and fix performance bottlenecks.

## Purpose

Ensure software performs well under expected and peak load conditions.

## Performance Targets

| Application Type | p50 Target | p95 Target | p99 Target |
|------------------|------------|------------|------------|
| API endpoint | <100ms | <500ms | <1000ms |
| Page load | <1000ms | <3000ms | <5000ms |
| Background job | <5000ms | <30000ms | <60000ms |

## Bottleneck Categories

### Database Bottlenecks
- N+1 queries
- Missing indexes
- Unoptimized queries
- Connection pool exhaustion

### CPU Bottlenecks
- Inefficient algorithms
- Unnecessary computation
- Blocking operations
- Memory allocation churn

### I/O Bottlenecks
- Synchronous file operations
- Uncompressed data transfer
- Missing caching
- Serial processing

### Network Bottlenecks
- Too many requests
- Large payloads
- Missing compression
- No connection pooling

## Optimization Process

### Step 1: Measure Baseline
```markdown
## Performance Baseline

**Feature/Endpoint**: [Name]
**Date**: [Date]
**Conditions**: [Load, data size, etc.]

### Response Time
| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| p50 | [X]ms | [Y]ms | [OK/Slow] |
| p95 | [X]ms | [Y]ms | [OK/Slow] |
| p99 | [X]ms | [Y]ms | [OK/Slow] |

### Throughput
| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Requests/sec | [X] | [Y] | [OK/Low] |
| Concurrent users | [X] | [Y] | [OK/Low] |
```

### Step 2: Profile and Identify Bottlenecks
```markdown
## Bottleneck Analysis

### Profile Results
| Location | Time % | Calls | Avg Time |
|----------|--------|-------|----------|
| [Function/Query] | [X]% | [N] | [Xms] |

### Identified Bottlenecks
| ID | Type | Location | Impact |
|----|------|----------|--------|
| BTL-001 | [Database/CPU/IO/Network] | `file:line` | [Xms] |
```

### Step 3: Implement Optimizations
```markdown
## Optimization: BTL-001

### Issue
**Type**: [Database/CPU/IO/Network]
**Location**: `path/to/file.ts:line`
**Current Time**: [X]ms
**Target Time**: [Y]ms

### Root Cause
[Why it's slow]

### Solution
```typescript
// Before (slow)
const users = await db.query('SELECT * FROM users');
for (const user of users) {
  const orders = await db.query(`SELECT * FROM orders WHERE user_id = ${user.id}`);
}

// After (fast)
const usersWithOrders = await db.query(`
  SELECT u.*, o.*
  FROM users u
  LEFT JOIN orders o ON o.user_id = u.id
`);
```

### Verification
**After Time**: [Y]ms
**Improvement**: [X]%
```

### Step 4: Implement Caching
```markdown
## Caching Strategy

### Data Analysis
| Data | Read Frequency | Write Frequency | Cache Candidate |
|------|----------------|-----------------|-----------------|
| [Data type] | [High/Med/Low] | [High/Med/Low] | [Yes/No] |

### Cache Implementation
| Data | Strategy | TTL | Invalidation |
|------|----------|-----|--------------|
| [Data] | [Write-through/aside/etc] | [Duration] | [Trigger] |

### Cache Code
```typescript
// Example caching implementation
async function getUser(id: string) {
  const cached = await cache.get(`user:${id}`);
  if (cached) return cached;

  const user = await db.users.findById(id);
  await cache.set(`user:${id}`, user, { ttl: 300 });
  return user;
}
```
```

### Step 5: Load Test
```markdown
## Load Test Results

### Test Configuration
- Tool: [k6/JMeter/etc]
- Duration: [X minutes]
- Ramp up: [Pattern]

### Results
| Scenario | Users | RPS | p50 | p95 | Errors |
|----------|-------|-----|-----|-----|--------|
| Baseline | [N] | [X] | [X]ms | [X]ms | [X]% |
| Medium load | [N] | [X] | [X]ms | [X]ms | [X]% |
| High load | [N] | [X] | [X]ms | [X]ms | [X]% |
| Peak load | [N] | [X] | [X]ms | [X]ms | [X]% |

### Findings
- Breaking point: [N users / X RPS]
- First bottleneck: [Description]
```

## Common Optimizations

### Database Optimization
```sql
-- Add index for common queries
CREATE INDEX idx_orders_user_id ON orders(user_id);

-- Optimize query
EXPLAIN ANALYZE SELECT ...
```

### Query Batching
```typescript
// Instead of N queries
for (const id of ids) {
  await db.getById(id); // N queries
}

// Use single query
await db.getByIds(ids); // 1 query
```

### Lazy Loading
```typescript
// Don't load everything upfront
const user = await db.users.findById(id);
// Only load orders when needed
const orders = await user.loadOrders();
```

### Pagination
```typescript
// Don't return all records
const results = await db.query({
  limit: 50,
  offset: page * 50
});
```

## Output Format

```markdown
# Performance Optimization Report

## Summary
- **Baseline p95**: [X]ms
- **Optimized p95**: [Y]ms
- **Improvement**: [Z]%
- **Bottlenecks Fixed**: [N]

## Baseline vs Optimized
| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| p50 | [X]ms | [Y]ms | [Z]% |
| p95 | [X]ms | [Y]ms | [Z]% |
| Throughput | [X]rps | [Y]rps | [Z]% |

## Optimizations Applied

### BTL-001: [Description]
- **Type**: [Category]
- **Before**: [X]ms
- **After**: [Y]ms
- **Solution**: [Brief description]

## Caching Implemented
| Data | Strategy | TTL | Expected Hit Rate |
|------|----------|-----|-------------------|
| [Data] | [Strategy] | [Time] | [X]% |

## Load Test Results
[Summary of load test]

## Recommendations
[Any remaining optimizations]
```

## Quality Checklist

- [ ] Baseline measured
- [ ] Bottlenecks identified
- [ ] Optimizations implemented
- [ ] Improvements verified
- [ ] Caching considered
- [ ] Load tested
- [ ] Documentation updated
