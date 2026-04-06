---
name: infrastructure-planning
description: |
  Design cloud infrastructure, CI/CD pipelines, and deployment architecture.
---

  Use when: (1) Planning infrastructure during Phase 7,
  (2) Designing CI/CD pipelines and deployment strategies,
  (3) Selecting cloud services and architecture patterns,
  (4) Planning monitoring, logging, and observability,
  (5) Estimating infrastructure costs and scaling needs.

# Infrastructure Planning

Cloud infrastructure and deployment architecture planning.

## Overview

This skill provides:
- Cloud architecture patterns
- CI/CD pipeline design
- Infrastructure as Code (IaC) planning
- Monitoring and observability design
- Cost estimation and optimization

## Cloud Architecture Patterns

### Single Region
```
┌─────────────────────────────────────┐
│ Region                              │
│  ┌─────────┐  ┌─────────┐          │
│  │ AZ-A    │  │ AZ-B    │          │
│  │ ┌─────┐ │  │ ┌─────┐ │          │
│  │ │ App │ │  │ │ App │ │          │
│  │ └─────┘ │  │ └─────┘ │          │
│  └─────────┘  └─────────┘          │
│       ↓            ↓                │
│    ┌────────────────────┐          │
│    │     Database       │          │
│    └────────────────────┘          │
└─────────────────────────────────────┘
```
Best for: MVPs, single-market apps

### Multi-Region (Active-Passive)
Best for: Disaster recovery, compliance

### Multi-Region (Active-Active)
Best for: Global apps, high availability

## CI/CD Pipeline Design

### Standard Pipeline Stages

```
┌──────┐   ┌───────┐   ┌──────┐   ┌────────┐   ┌────────┐
│ Code │ → │ Build │ → │ Test │ → │ Deploy │ → │ Deploy │
│      │   │       │   │      │   │ Stage  │   │ Prod   │
└──────┘   └───────┘   └──────┘   └────────┘   └────────┘
              │            │           │            │
           Compile     Unit/Int    Smoke/E2E    Canary
           Lint        Security    UAT          Release
           SAST        Coverage
```

### Pipeline Template

```yaml
# Pipeline Specification
stages:
  - name: build
    steps:
      - checkout
      - install_dependencies
      - lint
      - compile
      - sast_scan
    artifacts: [build_output]

  - name: test
    steps:
      - unit_tests
      - integration_tests
      - coverage_report
      - security_scan
    requirements:
      coverage: ">= 80%"
      security: "no critical"

  - name: deploy_staging
    steps:
      - deploy_to_staging
      - smoke_tests
      - e2e_tests
    approval: automatic

  - name: deploy_production
    steps:
      - canary_deploy (10%)
      - monitor (15 min)
      - full_deploy
    approval: manual
    rollback: automatic_on_failure
```

## Deployment Strategies

| Strategy | Risk | Downtime | Rollback | Use Case |
|----------|------|----------|----------|----------|
| Recreate | High | Yes | Slow | Dev/test |
| Rolling | Medium | No | Medium | Standard |
| Blue-Green | Low | No | Fast | Critical apps |
| Canary | Low | No | Fast | High traffic |
| A/B | Low | No | Fast | Feature testing |

## Infrastructure Specification Template

```markdown
## Infrastructure Specification

### Compute
| Component | Type | Size | Count | Scaling |
|-----------|------|------|-------|---------|
| API Server | Container/VM | [spec] | [n] | Auto (2-10) |
| Worker | Container | [spec] | [n] | Queue-based |
| Scheduler | Container | [spec] | 1 | None |

### Database
| Type | Service | Size | Replicas | Backup |
|------|---------|------|----------|--------|
| Primary | [service] | [spec] | [n] | Daily |
| Cache | Redis | [spec] | [n] | None |
| Search | Elastic | [spec] | [n] | Daily |

### Storage
| Type | Service | Size | Lifecycle |
|------|---------|------|-----------|
| Assets | S3/GCS | [est] | None |
| Logs | S3/GCS | [est] | 90 days |
| Backups | S3/GCS | [est] | 30 days |

### Networking
- VPC: [CIDR]
- Subnets: Public, Private, Database
- Load Balancer: [type]
- CDN: [yes/no]
- WAF: [yes/no]

### CI/CD
- Platform: [GitHub Actions/GitLab/etc]
- Environments: dev, staging, production
- Deployment: [strategy]
- Secrets: [management approach]

### Monitoring
- Metrics: [Prometheus/CloudWatch/etc]
- Logs: [ELK/CloudWatch/etc]
- Traces: [Jaeger/X-Ray/etc]
- Alerts: [PagerDuty/etc]

### Cost Estimate
| Component | Monthly | Notes |
|-----------|---------|-------|
| Compute | $X | [assumptions] |
| Database | $X | [assumptions] |
| Storage | $X | [assumptions] |
| Network | $X | [assumptions] |
| **Total** | **$X** | |
```

## Monitoring & Observability

### Three Pillars
1. **Metrics**: Quantitative measurements (CPU, memory, latency)
2. **Logs**: Event records (errors, audit trail)
3. **Traces**: Request flow across services

### Key Metrics (RED/USE)
- **R**ate: Requests per second
- **E**rrors: Error rate
- **D**uration: Latency percentiles

- **U**tilization: Resource usage %
- **S**aturation: Queue depth
- **E**rrors: Error counts

## Deliverables

- Infrastructure architecture diagram
- CI/CD pipeline specification
- Environment specifications
- Cost estimate
- Monitoring/alerting plan
- IaC approach decision
