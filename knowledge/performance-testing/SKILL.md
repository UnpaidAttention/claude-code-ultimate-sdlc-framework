name: performance-testing
description: |
  Evaluate system performance under load including response times, throughput, and resources.

  Use when: (1) Phase T5 requires performance and load testing, (2) validating response
  time targets (P50, P95, P99), (3) stress testing to find system breaking points,
  (4) spike testing for auto-scaling validation, (5) soak testing to identify memory
  leaks, (6) bottleneck identification in database, network, or code.

# Performance Testing

Evaluating system performance under various conditions.

## Performance Test Types

| Type | Purpose | When to Use |
|------|---------|-------------|
| **Load Testing** | Normal expected load | Verify typical usage |
| **Stress Testing** | Beyond normal capacity | Find breaking point |
| **Spike Testing** | Sudden load increases | Test auto-scaling |
| **Soak Testing** | Extended duration | Find memory leaks |

## Key Metrics

### Response Time
| Percentile | Target | Meaning |
|------------|--------|---------|
| P50 (median) | < 200ms | Typical user experience |
| P90 | < 500ms | Most users' experience |
| P95 | < 1s | Edge case users |
| P99 | < 2s | Worst case acceptable |

### Throughput
- **Requests per second (RPS)**: How many requests handled
- **Transactions per second (TPS)**: How many complete operations

### Resource Utilization
- **CPU**: Should stay < 80% under normal load
- **Memory**: Watch for growth over time (leaks)
- **Network**: Bandwidth and connection limits
- **Database**: Query times, connection pool usage

## Test Execution

### Load Test Plan Template

```markdown
## Performance Test: [Name]

### Objectives
- Verify system handles [N] concurrent users
- Response time P95 < [target]ms
- No errors under normal load

### Load Profile
| Phase | Duration | Users | RPS Target |
|-------|----------|-------|------------|
| Ramp Up | 5 min | 0 → 100 | 0 → 50 |
| Steady | 30 min | 100 | 50 |
| Ramp Down | 5 min | 100 → 0 | 50 → 0 |

### Scenarios
1. User login (weight: 10%)
2. Browse products (weight: 60%)
3. Add to cart (weight: 20%)
4. Checkout (weight: 10%)

### Success Criteria
- [ ] Error rate < 1%
- [ ] P95 response time < 500ms
- [ ] No OOM errors
- [ ] CPU < 80%
```

### Results Documentation

```markdown
## Results: [Test Name]

**Date**: YYYY-MM-DD
**Duration**: 40 minutes
**Environment**: [Production-like / Staging]

### Summary
| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| P50 Response | < 200ms | 150ms | ✓ Pass |
| P95 Response | < 500ms | 480ms | ✓ Pass |
| Error Rate | < 1% | 0.5% | ✓ Pass |
| Max CPU | < 80% | 72% | ✓ Pass |

### Findings
1. [Finding with impact]
2. [Finding with impact]

### Recommendations
1. [Optimization suggestion]
2. [Scaling suggestion]
```

## Bottleneck Identification

### Investigation Checklist
When performance degrades:

- [ ] **Database**: Slow queries? Missing indexes?
- [ ] **Network**: Latency? Bandwidth limits?
- [ ] **CPU**: Processing bottleneck?
- [ ] **Memory**: Garbage collection pauses?
- [ ] **External Services**: Third-party slowdowns?
- [ ] **Connection Pools**: Exhausted connections?

### Common Bottlenecks

| Symptom | Likely Cause | Investigation |
|---------|--------------|---------------|
| Increasing response time | Database queries | Check slow query log |
| Timeout errors | Connection exhaustion | Monitor pool usage |
| Memory growth | Memory leak | Heap dump analysis |
| CPU spikes | Inefficient code | Profile hot paths |
