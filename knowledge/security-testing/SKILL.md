---
name: security-testing
description: |
  Identify security vulnerabilities including OWASP Top 10 and authentication flaws.
---

  Use when: (1) Phase T5 requires security assessment, (2) testing for SQL injection,
  XSS, and other injection attacks, (3) validating authentication and session management,
  (4) checking access control and authorization, (5) verifying security headers and
  HTTPS enforcement, (6) API security validation for tokens and rate limiting.

# Security Testing

Identifying security vulnerabilities and validating controls.

## OWASP Top 10 Testing

### 1. Injection
**Test**: SQL, NoSQL, OS, LDAP injection

```markdown
## Test: SQL Injection

### Payloads to Try
- ' OR '1'='1
- '; DROP TABLE users;--
- ' UNION SELECT * FROM users--

### Test Points
- [ ] Login forms
- [ ] Search fields
- [ ] URL parameters
- [ ] API body parameters

### Result
- [ ] Vulnerable: [Details]
- [ ] Not Vulnerable
```

### 2. Broken Authentication
**Test**: Session management, credentials, tokens

- [ ] Password brute force protection
- [ ] Session timeout implemented
- [ ] Secure cookie flags (HttpOnly, Secure)
- [ ] Token invalidation on logout

### 3. Sensitive Data Exposure
**Test**: Data in transit and at rest

- [ ] HTTPS enforced
- [ ] Sensitive data not in URLs
- [ ] Passwords hashed (bcrypt/argon2)
- [ ] API responses don't leak data

### 4. Broken Access Control
**Test**: Authorization enforcement

```markdown
## Test: Horizontal Privilege Escalation

### Steps
1. Log in as User A
2. Access User A's resource: /api/users/123/data
3. Change ID to User B's: /api/users/456/data

### Expected
- 403 Forbidden or 404 Not Found

### Actual
- [ ] Properly denied
- [ ] Vulnerable: Can access other users' data
```

### 5. Security Misconfiguration
**Test**: Default settings, error handling

- [ ] Default credentials changed
- [ ] Unnecessary features disabled
- [ ] Error messages don't leak info
- [ ] Security headers present

## Security Headers Checklist

| Header | Purpose | Expected Value |
|--------|---------|----------------|
| `Strict-Transport-Security` | Force HTTPS | `max-age=31536000; includeSubDomains` |
| `Content-Security-Policy` | Prevent XSS | Restrictive policy |
| `X-Content-Type-Options` | Prevent MIME sniffing | `nosniff` |
| `X-Frame-Options` | Prevent clickjacking | `DENY` or `SAMEORIGIN` |

## Authentication Testing

### Test Matrix

| Test Case | Method | Expected |
|-----------|--------|----------|
| Valid credentials | POST /login | 200 + token |
| Invalid password | POST /login | 401, generic message |
| Invalid user | POST /login | 401, same message |
| Locked account | POST /login | 401 + lockout message |
| Expired token | GET /protected | 401 |

## API Security Testing

```markdown
## API: /api/users

### Authentication
- [ ] Requires valid token
- [ ] Rejects expired tokens
- [ ] Rejects malformed tokens

### Authorization
- [ ] Users can only access own data
- [ ] Admin endpoints protected
- [ ] Rate limiting active

### Input Validation
- [ ] Rejects invalid formats
- [ ] Handles special characters safely
- [ ] Size limits enforced
```

## Vulnerability Documentation

```markdown
## VULN-XXX: [Title]

**Severity**: Critical | High | Medium | Low
**OWASP Category**: [Category]
**CVSS Score**: [0.0 - 10.0]

### Description
[What the vulnerability is]

### Reproduction Steps
1. [Step to reproduce]
2. [Step to reproduce]

### Impact
[What an attacker could do]

### Evidence
[Screenshots, payloads, responses]

### Remediation
[How to fix]
```
