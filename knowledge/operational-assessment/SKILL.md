---
name: operational-assessment
description: Evaluate production readiness across logging, monitoring, alerting, and recovery dimensions. Use during Audit Council operations review, when assessing deployment readiness, reviewing observability gaps, or checking disaster recovery and incident response procedures.
---

# Operational Assessment

Evaluate production readiness: logging, monitoring, alerting, recovery.

## Purpose

Ensure software can be operated, debugged, and recovered in production environments.

## Assessment Areas

### 1. Logging
Can we see what's happening?

| Check | Criteria |
|-------|----------|
| Coverage | All key operations logged |
| Level | Appropriate log levels used |
| Context | Logs include relevant context |
| Searchable | Logs can be queried effectively |
| Rotation | Logs don't fill disk |

### 2. Monitoring
Can we measure health?

| Check | Criteria |
|-------|----------|
| Metrics | Key metrics collected |
| Dashboards | Visualizations available |
| Baselines | Normal ranges known |
| Trends | Can see changes over time |
| Custom | Business metrics included |

### 3. Alerting
Will we know when things break?

| Check | Criteria |
|-------|----------|
| Coverage | Critical failures alerted |
| Thresholds | Sensible alert thresholds |
| Routing | Right team gets alerts |
| Actionable | Alerts lead to clear actions |
| Noise | Not too many false positives |

### 4. Recovery
Can we restore service?

| Check | Criteria |
|-------|----------|
| Procedures | Documented recovery steps |
| Automation | Scripted where possible |
| Tested | Recovery actually works |
| Time | Recovery time acceptable |
| Data | Data recovery possible |

## Assessment Process

### Step 1: Logging Assessment
```markdown
## Logging Assessment

### Coverage Analysis
| Component | Logged | Level | Context | Notes |
|-----------|--------|-------|---------|-------|
| [API requests] | Yes/No | [Level] | [Context included] | |
| [Database ops] | Yes/No | [Level] | | |
| [Auth events] | Yes/No | [Level] | | |
| [Errors] | Yes/No | [Level] | | |
| [Business events] | Yes/No | [Level] | | |

### Log Quality
| Aspect | Rating | Notes |
|--------|--------|-------|
| Structured | 1-5 | JSON/structured vs plain text |
| Consistent | 1-5 | Same format across app |
| Useful | 1-5 | Actually helps debugging |
| Performant | 1-5 | Doesn't slow app |

### Gaps
| Gap | Impact | Recommendation |
|-----|--------|----------------|
| [Missing log] | [Impact] | [Add logging for X] |

### Logging Score: [X]/10
```

### Step 2: Monitoring Assessment
```markdown
## Monitoring Assessment

### Metrics Coverage
| Metric Type | Collected | Location | Notes |
|-------------|-----------|----------|-------|
| Request rate | Yes/No | [Where] | |
| Error rate | Yes/No | [Where] | |
| Latency (p50/p95/p99) | Yes/No | [Where] | |
| CPU/Memory | Yes/No | [Where] | |
| Database connections | Yes/No | [Where] | |
| Queue depth | Yes/No | [Where] | |
| Business metrics | Yes/No | [Where] | |

### Dashboard Status
| Dashboard | Exists | Useful | Notes |
|-----------|--------|--------|-------|
| Overview | Yes/No | [1-5] | |
| Performance | Yes/No | [1-5] | |
| Errors | Yes/No | [1-5] | |
| Business | Yes/No | [1-5] | |

### Gaps
| Gap | Impact | Recommendation |
|-----|--------|----------------|
| [Missing metric] | [Impact] | [Add metric for X] |

### Monitoring Score: [X]/10
```

### Step 3: Alerting Assessment
```markdown
## Alerting Assessment

### Alert Coverage
| Condition | Alerted | Threshold | Routing | Notes |
|-----------|---------|-----------|---------|-------|
| Service down | Yes/No | [Value] | [Team] | |
| High error rate | Yes/No | [Value] | [Team] | |
| High latency | Yes/No | [Value] | [Team] | |
| Resource exhaustion | Yes/No | [Value] | [Team] | |
| Security events | Yes/No | [Value] | [Team] | |

### Alert Quality
| Aspect | Rating | Notes |
|--------|--------|-------|
| Actionable | 1-5 | Clear what to do |
| Timely | 1-5 | Fires soon enough |
| Accurate | 1-5 | Low false positive |
| Routed | 1-5 | Right person notified |

### Gaps
| Gap | Impact | Recommendation |
|-----|--------|----------------|
| [Missing alert] | [Impact] | [Add alert for X] |

### Alerting Score: [X]/10
```

### Step 4: Recovery Assessment
```markdown
## Recovery Assessment

### Recovery Procedures
| Scenario | Documented | Automated | Tested | Time |
|----------|------------|-----------|--------|------|
| Service restart | Yes/No | Yes/No | Yes/No | [Time] |
| Database failover | Yes/No | Yes/No | Yes/No | [Time] |
| Cache clear | Yes/No | Yes/No | Yes/No | [Time] |
| Rollback | Yes/No | Yes/No | Yes/No | [Time] |
| Data restore | Yes/No | Yes/No | Yes/No | [Time] |

### Disaster Recovery
| Aspect | Status | Notes |
|--------|--------|-------|
| Backup frequency | [Value] | |
| Backup tested | Yes/No | |
| RTO target | [Value] | |
| RPO target | [Value] | |
| DR site | Yes/No | |

### Gaps
| Gap | Impact | Recommendation |
|-----|--------|----------------|
| [Missing procedure] | [Impact] | [Document/automate X] |

### Recovery Score: [X]/10
```

### Step 5: Compile Results
```markdown
## Operational Readiness Summary

| Area | Score | Status |
|------|-------|--------|
| Logging | [X]/10 | [Ready/Needs Work] |
| Monitoring | [X]/10 | [Ready/Needs Work] |
| Alerting | [X]/10 | [Ready/Needs Work] |
| Recovery | [X]/10 | [Ready/Needs Work] |
| **Overall** | **[X]/10** | |

### Critical Gaps
| Priority | Gap | Area | Impact |
|----------|-----|------|--------|
| 1 | [Gap] | [Area] | [Impact] |

### Recommendations
1. [High priority recommendation]
2. [Medium priority recommendation]
```

## Operational Requirements by Environment

### Development
- Basic logging
- Local debugging tools

### Staging
- Production-like logging
- Basic monitoring
- Alert testing

### Production
- Full logging coverage
- Complete monitoring
- Active alerting
- Tested recovery procedures

## Output Format

```markdown
# Operational Assessment Report

## Summary
- **Overall Score**: [X]/10
- **Status**: [Production Ready / Needs Work]
- **Critical Gaps**: [X]

## Scores
| Area | Score | Status |
|------|-------|--------|
| Logging | [X]/10 | |
| Monitoring | [X]/10 | |
| Alerting | [X]/10 | |
| Recovery | [X]/10 | |

## Key Findings

### Logging
[Summary of logging status and gaps]

### Monitoring
[Summary of monitoring status and gaps]

### Alerting
[Summary of alerting status and gaps]

### Recovery
[Summary of recovery status and gaps]

## Priority Actions
| Priority | Action | Area | Effort |
|----------|--------|------|--------|
| 1 | [Action] | [Area] | [H/M/L] |

## Conclusion
[Final assessment of operational readiness]
```

## Quality Checklist

- [ ] Logging coverage assessed
- [ ] Monitoring metrics reviewed
- [ ] Alert coverage checked
- [ ] Recovery procedures evaluated
- [ ] Gaps identified
- [ ] Priorities assigned
- [ ] Recommendations made
