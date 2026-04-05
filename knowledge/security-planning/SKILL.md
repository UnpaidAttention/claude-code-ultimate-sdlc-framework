name: security-planning
description: Provides security requirements analysis including STRIDE threat modeling, OWASP Top 10 mitigations, and authentication/authorization patterns. Use when designing authentication systems, planning data protection, analyzing security requirements, or conducting threat modeling during planning phases.

# Security Planning

> Proactive security analysis during the planning phase.
> Security is not a feature - it's a fundamental requirement.


## Core Principles

| Principle | Rule |
|-----------|------|
| **Defense in Depth** | Multiple layers of security controls |
| **Least Privilege** | Minimum permissions necessary |
| **Fail Secure** | Default to deny on errors |
| **Trust Nothing** | Validate all inputs, verify all claims |
| **Assume Breach** | Plan for when controls fail |


## When to Use

- Planning Phase 4 (Security)
- Designing authentication/authorization
- Data protection planning
- Compliance requirement analysis
- Security architecture review


## STRIDE Threat Model

### Threat Categories

| Threat | Description | Assets at Risk | Primary Mitigation |
|--------|-------------|----------------|-------------------|
| **S**poofing | Pretending to be someone/something else | Identity | Authentication |
| **T**ampering | Unauthorized modification of data | Data integrity | Integrity controls |
| **R**epudiation | Denying actions performed | Accountability | Audit logging |
| **I**nformation Disclosure | Exposing data to unauthorized parties | Confidentiality | Encryption, access control |
| **D**enial of Service | Making system unavailable | Availability | Rate limiting, scaling |
| **E**levation of Privilege | Gaining unauthorized capabilities | Authorization | Access controls |

### Threat Analysis Process

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Identify   │────►│   Analyze   │────►│  Mitigate   │
│   Assets    │     │   Threats   │     │   Risks     │
└─────────────┘     └─────────────┘     └─────────────┘
       │                   │                   │
       ▼                   ▼                   ▼
  What do we         What could         How do we
  need to protect?   go wrong?          prevent/detect?
```

### Per-Feature Threat Questions

| Question | Example Threats |
|----------|-----------------|
| What data is accessed? | Information disclosure, tampering |
| Who should have access? | Elevation of privilege, spoofing |
| What could go wrong? | All STRIDE categories |
| How would we detect abuse? | Repudiation |
| What's the blast radius? | DoS, data breach scope |


## OWASP Top 10 (2021) Checklist

| Rank | Risk | Mitigation |
|------|------|------------|
| **A01** | Broken Access Control | Deny by default, validate permissions server-side |
| **A02** | Cryptographic Failures | Use strong algorithms, protect keys, encrypt sensitive data |
| **A03** | Injection | Parameterized queries, input validation, output encoding |
| **A04** | Insecure Design | Threat modeling, secure design patterns |
| **A05** | Security Misconfiguration | Hardened defaults, automated config validation |
| **A06** | Vulnerable Components | Dependency scanning, regular updates |
| **A07** | Auth Failures | MFA, strong password policy, secure session management |
| **A08** | Data Integrity Failures | Verify software integrity, secure CI/CD |
| **A09** | Logging Failures | Comprehensive audit logs, monitoring |
| **A10** | SSRF | Validate/sanitize URLs, network segmentation |

### Implementation Checklist

```markdown
## A01: Broken Access Control
- [ ] Access control enforced server-side
- [ ] Deny by default
- [ ] Log and alert on failures
- [ ] Rate limit API access
- [ ] Invalidate sessions on logout

## A02: Cryptographic Failures
- [ ] Classify data by sensitivity
- [ ] Encrypt sensitive data at rest
- [ ] Use TLS 1.2+ for transit
- [ ] Use strong algorithms (AES-256, RSA-2048+)
- [ ] Secure key management

## A03: Injection
- [ ] Use parameterized queries
- [ ] Validate input (whitelist)
- [ ] Encode output
- [ ] Use ORM safely
- [ ] Limit SQL privileges
```


## Authentication Patterns

### Authentication Methods

| Method | Security Level | Best For | Considerations |
|--------|----------------|----------|----------------|
| **Password** | Medium | Legacy systems | Require strong passwords, salt+hash |
| **MFA** | High | Sensitive apps | SMS is weakest, prefer TOTP/WebAuthn |
| **OAuth 2.0** | High | Third-party auth | Use PKCE, validate tokens |
| **WebAuthn/Passkeys** | Very High | Modern apps | Phishing resistant |
| **API Keys** | Medium | Server-to-server | Scope limitations, rotation |
| **JWT** | High | Stateless services | Short expiry, RS256 |

### Authentication Requirements Checklist

| Requirement | Implementation |
|-------------|----------------|
| Strong password policy | Min 12 chars, complexity, no common passwords |
| Secure credential storage | bcrypt/argon2 with salt |
| Account lockout | After 5-10 failed attempts |
| Session management | Secure cookies, proper expiry |
| MFA support | TOTP, WebAuthn, backup codes |
| Secure password reset | Time-limited tokens, verify identity |

### Session Security

| Control | Implementation |
|---------|----------------|
| **Session ID** | Cryptographically random, 128+ bits |
| **Cookie flags** | Secure, HttpOnly, SameSite=Strict |
| **Session expiry** | Absolute and idle timeout |
| **Session invalidation** | On logout, password change, privilege change |


## Authorization Patterns

### Authorization Models

| Model | Description | Best For |
|-------|-------------|----------|
| **RBAC** | Role-Based Access Control | Predictable permissions |
| **ABAC** | Attribute-Based Access Control | Complex, dynamic rules |
| **ReBAC** | Relationship-Based Access Control | Social/collaborative apps |
| **ACL** | Access Control Lists | File/resource permissions |

### RBAC Implementation

```typescript
// Permission definition
const permissions = {
  'users:read': ['admin', 'manager', 'user'],
  'users:write': ['admin', 'manager'],
  'users:delete': ['admin'],
  'reports:read': ['admin', 'manager'],
  'reports:write': ['admin'],
};

// Authorization check
function hasPermission(user: User, permission: string): boolean {
  const allowedRoles = permissions[permission] || [];
  return user.roles.some(role => allowedRoles.includes(role));
}
```

### Authorization Requirements Checklist

| Requirement | Status |
|-------------|--------|
| Role definitions documented | [ ] |
| Permission matrix complete | [ ] |
| Resource ownership rules defined | [ ] |
| Admin access controls | [ ] |
| Separation of duties | [ ] |
| Principle of least privilege | [ ] |


## Data Protection Requirements

### Data Classification

| Level | Description | Examples | Controls |
|-------|-------------|----------|----------|
| **Public** | No protection needed | Marketing content | None |
| **Internal** | Basic access controls | Internal docs | Authentication |
| **Confidential** | Encryption required | Customer data | Encryption + ACL |
| **Restricted** | Strict access + audit | PII, financial, health | Encryption + ACL + audit + DLP |

### PII Handling Requirements

| Requirement | Implementation |
|-------------|----------------|
| **Identification** | Catalog all PII fields |
| **Minimization** | Collect only what's needed |
| **Encryption** | At rest and in transit |
| **Access control** | Need-to-know basis |
| **Retention** | Define and enforce limits |
| **Deletion** | Secure erasure procedures |
| **Portability** | Export in standard format |

### Encryption Requirements

| Data State | Minimum Standard | Recommended |
|------------|------------------|-------------|
| At rest | AES-256 | AES-256-GCM |
| In transit | TLS 1.2 | TLS 1.3 |
| Passwords | bcrypt (cost 10) | Argon2id |
| API tokens | SHA-256 hash | HMAC-SHA256 |


## Compliance Considerations

### Common Frameworks

| Framework | Scope | Key Requirements |
|-----------|-------|------------------|
| **GDPR** | EU personal data | Consent, right to erasure, DPO |
| **CCPA** | California consumers | Disclosure, opt-out, delete |
| **HIPAA** | US health data | PHI protection, BAA |
| **PCI DSS** | Payment card data | Network security, encryption |
| **SOC 2** | Service organizations | Trust principles |

### GDPR Checklist

| Requirement | Implementation |
|-------------|----------------|
| Lawful basis | Consent or legitimate interest documented |
| Privacy notice | Clear, accessible privacy policy |
| Data subject rights | Support access, rectification, erasure |
| Data minimization | Collect only necessary data |
| Breach notification | 72-hour reporting process |
| Data protection by design | Privacy in architecture |


## Secrets Management

### Secret Types

| Type | Storage | Rotation |
|------|---------|----------|
| Database credentials | Vault/secrets manager | 90 days |
| API keys | Vault/secrets manager | 90 days or on compromise |
| Encryption keys | HSM/KMS | Annually |
| JWT signing keys | Vault/secrets manager | 90 days |
| SSL certificates | Certificate manager | Before expiry |

### Secrets Management Checklist

| Practice | Status |
|----------|--------|
| No secrets in code | [ ] |
| No secrets in logs | [ ] |
| Encrypted at rest | [ ] |
| Access audited | [ ] |
| Rotation automated | [ ] |
| Emergency rotation process | [ ] |


## Audit Logging

### What to Log

| Event Category | Examples |
|----------------|----------|
| Authentication | Login success/failure, logout, MFA |
| Authorization | Permission denied, role changes |
| Data access | Read/write of sensitive data |
| Admin actions | User creation, config changes |
| Security events | Brute force, unusual patterns |

### Log Format

```json
{
  "timestamp": "2024-01-15T10:30:00Z",
  "level": "INFO",
  "event": "USER_LOGIN",
  "actor": {
    "id": "user_123",
    "ip": "192.168.1.1",
    "user_agent": "Mozilla/5.0..."
  },
  "action": "authentication",
  "resource": {
    "type": "session",
    "id": "sess_abc"
  },
  "outcome": "success",
  "metadata": {
    "mfa_used": true,
    "auth_method": "password"
  }
}
```

### Log Protection

| Requirement | Implementation |
|-------------|----------------|
| Integrity | Append-only, signed logs |
| Confidentiality | Encrypt sensitive fields |
| Availability | Redundant storage |
| Retention | Per compliance requirements |


## Security Requirements Template

```markdown
## Security Requirements for [Feature]

### Data Classification
- Data handled: [List data types]
- Classification: [Public/Internal/Confidential/Restricted]

### Authentication
- [ ] Auth method defined: [method]
- [ ] Session management approach: [approach]
- [ ] MFA requirement: [yes/no/optional]

### Authorization
- [ ] Roles: [list roles that access this]
- [ ] Permissions: [specific permissions needed]
- [ ] Resource ownership: [ownership rules]

### Data Protection
- [ ] Encryption at rest: [yes/no, algorithm]
- [ ] Encryption in transit: [TLS version]
- [ ] PII handling: [approach]

### Audit
- [ ] Events logged: [list]
- [ ] Retention period: [duration]

### Compliance
- [ ] Applicable regulations: [list]
- [ ] Specific requirements: [details]

### Threat Model
- [ ] STRIDE analysis complete
- [ ] Top risks: [list]
- [ ] Mitigations: [list]
```


## Quality Checks

| Check | Question |
|-------|----------|
| **Authentication** | Is every endpoint protected appropriately? |
| **Authorization** | Are permissions checked at every access point? |
| **Input validation** | Is all input validated server-side? |
| **Output encoding** | Is output encoded for context? |
| **Secrets** | Are all secrets in secure storage? |
| **Logging** | Are security events logged? |
| **Encryption** | Is sensitive data encrypted? |


## Anti-Patterns

| Pattern | Problem | Fix |
|---------|---------|-----|
| **Security by obscurity** | Not actual protection | Use proven controls |
| **Client-side auth only** | Easily bypassed | Always validate server-side |
| **Hardcoded secrets** | Exposed in code/logs | Use secrets manager |
| **Verbose errors** | Information disclosure | Generic user errors, log details |
| **Missing rate limiting** | DoS/brute force | Implement rate limits |
| **Rolling your own crypto** | Likely flawed | Use established libraries |


## Related Skills

| Need | Skill |
|------|-------|
| API security | `@[skills/api-patterns]` |
| Architecture | `@[skills/architecture-principles]` |
| Database security | `@[skills/database-patterns]` |
