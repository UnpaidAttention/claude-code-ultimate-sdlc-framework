---
name: security-hardening
description: Security hardening procedures for production deployment. Use when preparing for security gates, hardening application surfaces, implementing OWASP Top 10 mitigations, reviewing authentication and authorization, or running security checklists before launch.
---

# Security Hardening

Go beyond basic security to production-hardened state.

## Purpose

Transform "secure enough for dev" into "hardened for production." Address OWASP Top 10 and beyond.

## Hardening Areas

### 1. Authentication Hardening
```markdown
## Authentication Review

### Current State
| Aspect | Implementation | Status |
|--------|----------------|--------|
| Password policy | [Description] | [Good/Needs Work] |
| MFA support | [Yes/No] | [Good/Needs Work] |
| Session management | [Description] | [Good/Needs Work] |
| Token handling | [Description] | [Good/Needs Work] |

### Hardening Actions
| Action | Priority | Status |
|--------|----------|--------|
| Enforce strong passwords | High | [Done/TODO] |
| Implement MFA | High | [Done/TODO] |
| Reduce session timeout | Medium | [Done/TODO] |
| Add brute force protection | High | [Done/TODO] |
| Implement token refresh | Medium | [Done/TODO] |
```

### 2. Authorization Hardening
```markdown
## Authorization Review

### Current State
| Resource | Protection | Principle | Status |
|----------|------------|-----------|--------|
| [API endpoint] | [How protected] | [Least privilege?] | |
| [Data access] | [How protected] | [Least privilege?] | |
| [Admin functions] | [How protected] | [Least privilege?] | |

### Hardening Actions
| Action | Priority | Status |
|--------|----------|--------|
| Implement RBAC | High | [Done/TODO] |
| Add resource-level checks | High | [Done/TODO] |
| Audit admin access | Medium | [Done/TODO] |
| Implement audit logging | High | [Done/TODO] |
```

### 3. Input Validation Hardening
```markdown
## Input Validation Review

### Current State
| Input Point | Validation | Sanitization | Status |
|-------------|------------|--------------|--------|
| [API param] | [Yes/No] | [Yes/No] | |
| [Form field] | [Yes/No] | [Yes/No] | |
| [File upload] | [Yes/No] | [Yes/No] | |
| [URL param] | [Yes/No] | [Yes/No] | |

### Hardening Actions
| Action | Priority | Status |
|--------|----------|--------|
| Validate all inputs | Critical | [Done/TODO] |
| Implement allow-lists | High | [Done/TODO] |
| Sanitize output | High | [Done/TODO] |
| Add file type validation | High | [Done/TODO] |
```

### 4. OWASP Top 10 Review
```markdown
## OWASP Top 10 Assessment

| # | Category | Status | Notes | Actions |
|---|----------|--------|-------|---------|
| A01 | Broken Access Control | [Safe/At Risk] | | |
| A02 | Cryptographic Failures | [Safe/At Risk] | | |
| A03 | Injection | [Safe/At Risk] | | |
| A04 | Insecure Design | [Safe/At Risk] | | |
| A05 | Security Misconfiguration | [Safe/At Risk] | | |
| A06 | Vulnerable Components | [Safe/At Risk] | | |
| A07 | Auth Failures | [Safe/At Risk] | | |
| A08 | Integrity Failures | [Safe/At Risk] | | |
| A09 | Logging Failures | [Safe/At Risk] | | |
| A10 | SSRF | [Safe/At Risk] | | |
```

### 5. Security Headers
```markdown
## Security Headers

| Header | Present | Value | Recommended |
|--------|---------|-------|-------------|
| Content-Security-Policy | [Yes/No] | [Value] | strict policy |
| Strict-Transport-Security | [Yes/No] | [Value] | max-age=31536000 |
| X-Content-Type-Options | [Yes/No] | [Value] | nosniff |
| X-Frame-Options | [Yes/No] | [Value] | DENY |
| X-XSS-Protection | [Yes/No] | [Value] | 1; mode=block |
| Referrer-Policy | [Yes/No] | [Value] | strict-origin |
| Permissions-Policy | [Yes/No] | [Value] | restrictive |
```

### 6. Secrets Management
```markdown
## Secrets Review

| Secret | Storage | Rotation | Access | Status |
|--------|---------|----------|--------|--------|
| DB credentials | [Where] | [Policy] | [Who] | |
| API keys | [Where] | [Policy] | [Who] | |
| JWT secret | [Where] | [Policy] | [Who] | |
| Encryption keys | [Where] | [Policy] | [Who] | |

### Hardening Actions
| Action | Priority | Status |
|--------|----------|--------|
| Move secrets to vault | High | [Done/TODO] |
| Implement rotation | Medium | [Done/TODO] |
| Audit access | High | [Done/TODO] |
| Remove hardcoded | Critical | [Done/TODO] |
```

## Hardening Process

### Step 1: Vulnerability Scan
```markdown
## Vulnerability Scan Results

**Tool Used**: [Tool name]
**Date**: [Date]

| Severity | Count | Details |
|----------|-------|---------|
| Critical | [X] | [List] |
| High | [X] | [List] |
| Medium | [X] | [List] |
| Low | [X] | [List] |

### Critical Findings
| Finding | Location | Remediation |
|---------|----------|-------------|
| [Finding] | [Location] | [Fix] |
```

### Step 2: Dependency Audit
```markdown
## Dependency Audit

**Tool Used**: npm audit / safety / etc.

| Package | Version | Vulnerability | Severity | Fix |
|---------|---------|---------------|----------|-----|
| [Package] | [Ver] | [CVE] | [Sev] | [Update to] |

### Actions
- Update [X] packages
- Replace [Y] deprecated packages
- Monitor [Z] advisories
```

### Step 3: Penetration Testing Mindset
```markdown
## Attack Surface Analysis

### Entry Points
| Entry Point | Protection | Bypass Potential |
|-------------|------------|------------------|
| [API endpoint] | [Protection] | [Risk] |
| [Login form] | [Protection] | [Risk] |
| [File upload] | [Protection] | [Risk] |

### Attack Scenarios
| Scenario | Possible | Mitigated |
|----------|----------|-----------|
| SQL injection | [Yes/No] | [Yes/No] |
| XSS | [Yes/No] | [Yes/No] |
| CSRF | [Yes/No] | [Yes/No] |
| Auth bypass | [Yes/No] | [Yes/No] |
| Privilege escalation | [Yes/No] | [Yes/No] |
```

### Step 4: Implement Hardening
```markdown
## Hardening Implementation

### Completed
| Hardening | Files Changed | Verified |
|-----------|---------------|----------|
| [Action] | [Files] | [Yes/No] |

### Pending
| Hardening | Blocker | ETA |
|-----------|---------|-----|
| [Action] | [Blocker] | [When] |
```

## Output Format

```markdown
# Security Hardening Report

## Summary
- **Security Score**: [X]/10
- **OWASP Status**: [X]/10 addressed
- **Critical Issues**: [X]
- **Hardening Complete**: [X]%

## Assessment Results

### Authentication: [X]/10
[Key findings and recommendations]

### Authorization: [X]/10
[Key findings and recommendations]

### Input Validation: [X]/10
[Key findings and recommendations]

### OWASP Top 10
| Category | Status |
|----------|--------|
| A01-A10 | [Summary] |

### Security Headers
[X]/7 properly configured

### Secrets Management
[Status and recommendations]

## Priority Actions
| Priority | Action | Category | Effort |
|----------|--------|----------|--------|
| 1 | [Action] | [Category] | [H/M/L] |

## Conclusion
[Final security posture assessment]
```

## Quality Checklist

- [ ] Authentication reviewed and hardened
- [ ] Authorization verified
- [ ] Input validation complete
- [ ] OWASP Top 10 assessed
- [ ] Security headers configured
- [ ] Secrets properly managed
- [ ] Dependencies audited
- [ ] Vulnerability scan clean
