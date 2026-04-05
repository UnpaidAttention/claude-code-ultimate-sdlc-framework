---
name: audit-t5
description: |
  Execute Audit Track T5 - Performance and Security Testing. Load testing and security vulnerability assessment.
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Agent
  - AskUserQuestion
---

## Preamble (run first)

```bash
# Detect project state
AG_HOME="${HOME}/.antigravity"
AG_PROJECT=".antigravity"
AG_SKILLS="${HOME}/.claude/skills/antigravity"

# Check if project is initialized
if [ -d "$AG_PROJECT" ]; then
  echo "PROJECT: initialized"
  # Read current state
  if [ -f "$AG_PROJECT/project-context.md" ]; then
    COUNCIL=$(grep -A1 "## Active Council" "$AG_PROJECT/project-context.md" | tail -1 | tr -d ' ')
    PHASE=$(grep -A1 "## Current Phase" "$AG_PROJECT/project-context.md" | tail -1 | tr -d ' ')
    STATUS=$(grep -A1 "## Status" "$AG_PROJECT/project-context.md" | tail -1 | tr -d ' ')
    echo "COUNCIL: $COUNCIL"
    echo "PHASE: $PHASE"  
    echo "STATUS: $STATUS"
  fi
else
  echo "PROJECT: not initialized (run /init first)"
fi

# Read global config
if [ -f "$AG_HOME/config.yaml" ]; then
  GOV_MODE=$(grep "governance_mode:" "$AG_HOME/config.yaml" | awk '{print $2}')
  PROJ_TYPE=$(grep "project_type:" "$AG_HOME/config.yaml" | awk '{print $2}')
  echo "GOVERNANCE: ${GOV_MODE:-standard}"
  echo "PROJECT_TYPE: ${PROJ_TYPE:-web-app}"
fi
```

After the preamble runs, use the detected state to verify prerequisites for this workflow.

## Knowledge Skills

Load these knowledge skills for reference during this workflow:
- Read `~/.claude/skills/antigravity/knowledge/security-testing/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/performance-testing/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/vulnerability-assessment/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# /audit-t5 - Performance & Security

## Lens / Skills / Model
**Lens**: `[Quality] + [Performance]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per `council-audit.md`

## Prerequisites

- T4 (Integration Testing) must be complete

If prerequisites not met:
```
T4 not complete. Run /audit-t4 first.
```

---

## MCP Prerequisites

This workflow benefits from the following MCP servers (all optional — terminal fallbacks provided):

| MCP Server | Used For | Fallback |
|------------|----------|----------|
| Lighthouse MCP | Web vitals baseline | `npx lighthouse <url> --output=json` |
| k6 MCP | Load testing | Generate k6 script, run manually |
| Semgrep MCP | SAST scanning | `npx semgrep --config=auto .` |
| ZAP MCP | DAST scanning | Browser extension manual testing |

See `.reference/mcp-tool-guide.md` for setup and verification.

---

## Workflow

### Step 1: Update Project State

Update `.antigravity/project-context.md`:
- Set `Current Phase`: T5 - Performance & Security
- Set `Status`: in_progress

### Step 2: Performance Testing

#### Web Vitals Baseline
- Use Lighthouse MCP (`lighthouse_audit`) to capture: LCP, CLS, INP, TBT, Performance Score
- If Lighthouse MCP unavailable: run `npx lighthouse <url> --output=json --chrome-flags="--headless"` via terminal
- Document baseline metrics before load testing

#### Load Testing
- Use k6 MCP (`execute_k6_test`) to execute load test scenarios:
  - **Normal load**: 10 virtual users, 30 seconds
  - **Peak load**: 50 virtual users, 60 seconds
  - **Stress test**: Ramping from 10 to 200 virtual users over 120 seconds
- If k6 MCP unavailable: generate k6 script and instruct user to run `k6 run script.js` manually
- Capture response time percentiles (p50, p95, p99) and throughput from k6 output

#### Performance Metrics
- Response times (from k6 or manual load tests)
- Throughput (requests/second)
- Resource utilization (CPU, memory via terminal monitoring)
- Bottleneck identification

### Step 3: Security Audit

**MANDATORY**: Work through each applicable section systematically. For each check, record PASS/FAIL/N-A with evidence.

#### 3.1 Secrets Scan
- Run `gitleaks detect --no-git` on full codebase
- Search source for: `password`, `api_key`, `secret`, `token`, `credential`, `private_key` (exclude tests/.env.example)
- Check config files for default credentials or example values that persist
- **PASS criteria**: 0 matches in production code

#### 3.2 Input Validation & Injection
For EACH user input entry point (API endpoints, form handlers, URL parameters, file uploads):
- Trace input from entry to data sink (database query, shell command, HTML output, file path, log statement)
- Verify sanitization/validation exists at each step
- Check: parameterized queries (no string concatenation in SQL), output encoding (context-appropriate), command injection prevention (no user input in shell commands), path traversal prevention (no user input in file paths)
- **PASS criteria**: All input paths have validation; 0 raw user input reaching data sinks

#### 3.3 Authentication
- Verify auth check on EVERY endpoint (not just login page) — list unprotected endpoints
- Check password storage: must use bcrypt/argon2/scrypt (NOT MD5/SHA1/SHA256 alone)
- Check session tokens: cryptographically random, sufficient length (>=128 bits)
- Test: can expired/invalid tokens access protected resources?
- Test: does logout actually invalidate the session server-side?
- Check brute force protection: account lockout or rate limiting on login
- **PASS criteria**: All endpoints auth-protected (or explicitly public), proper password hashing, session invalidation works

#### 3.4 Authorization
- For each role defined in specs: test access to each resource type — verify deny-by-default
- Test vertical escalation: can a low-privilege user access admin endpoints?
- Test horizontal escalation: can user A access user B's resources by changing IDs in URLs/params?
- Check for IDOR: do all data access queries filter by authenticated user's ownership/permission?
- **PASS criteria**: Role matrix verified, 0 escalation paths found, IDOR checks present

#### 3.5 Session & Cookie Security
- Check cookie flags: Secure, HttpOnly, SameSite=Strict (or Lax with CSRF tokens)
- Verify session expiration: absolute timeout AND idle timeout configured
- Test session fixation: does login generate a new session ID?
- **PASS criteria**: All flags set, expiration configured, fixation protected

#### 3.6 CSRF/SSRF Protection
- Verify CSRF tokens on ALL state-changing requests (POST/PUT/DELETE)
- If server makes outbound requests from user input (URLs, webhooks): verify URL validation, block internal network ranges (SSRF)
- Check for open redirects in URL parameters
- **PASS criteria**: CSRF protection present on state-changing endpoints, SSRF mitigations on outbound request features

#### 3.7 Data Exposure
- Check error handlers: no stack traces, internal paths, or DB schema in production error responses
- Check API responses: no excessive data (returning full objects when subset needed)
- Check logs: no PII, tokens, passwords, or sensitive data in log output
- Check HTTP headers: no server version disclosure, no unnecessary headers
- Verify debug/verbose mode is disabled in production config
- **PASS criteria**: Error responses generic, API responses minimal, logs clean, debug off

#### 3.8 Cryptography
- Verify password hashing: bcrypt (cost >=10), argon2id, or scrypt — NOT MD5, SHA1, SHA256 alone
- Verify TLS: 1.2+ required for all external connections
- Check random number generation: crypto-secure sources only (crypto.randomBytes, secrets module, not Math.random)
- Verify no custom crypto implementations — must use established libraries
- Check encryption at rest: AES-256 or equivalent for sensitive data
- **PASS criteria**: Proper algorithms, crypto-secure randomness, no custom crypto

#### 3.9 API Security
- Verify rate limiting on: authentication endpoints, password reset, registration, high-cost operations
- Check input validation on all API parameters (type, length, range, format)
- Verify proper HTTP status codes (no 200 for errors that leak info)
- Check for mass assignment: can clients set fields they shouldn't (admin, role, internal IDs)?
- **PASS criteria**: Rate limiting present, input validated, no mass assignment

#### 3.10 Business Logic
- For features with financial/state-changing operations: test race conditions (concurrent requests)
- Verify workflow steps can't be skipped (e.g., bypassing payment)
- Check numeric inputs for bounds (quantity, price — can they be negative/zero/astronomical?)
- Verify idempotency on operations that should be idempotent
- **PASS criteria**: Race conditions mitigated, workflow enforced, bounds validated

#### 3.11 File Handling (if applicable)
- Verify upload type validation (content-type check, not just file extension)
- Verify file size limits enforced
- Verify uploaded files stored outside web root or with non-executable permissions
- Check for path traversal in file operation parameters
- **PASS criteria**: Validation on type/size/path, secure storage location

#### 3.12 Security Requirements Traceability
- Read `specs/security/threat-model.md`
- For each threat identified in STRIDE analysis: verify mitigation exists in code
- For each security requirement added to AIOUs (Phase 4 Step A5): verify implementation
- **PASS criteria**: All planned threats mitigated, all security requirements implemented

#### 3.13 Security Test Verification
- Search test suites for security-specific tests: injection attempts, auth bypass, data leakage, authorization boundary tests
- Verify at least ONE security test exists per input entry point
- Verify auth tests cover: valid auth, invalid auth, expired auth, missing auth
- **PASS criteria**: Security tests exist for critical paths; not just functional tests

### Step 4: Security Finding Remediation

For each SEC-CRITICAL or SEC-HIGH finding from Step 3:

1. **Document**: Log finding via `/audit-defect` with severity SEC-CRITICAL or SEC-HIGH, CWE reference, affected file:line, reproduction steps
2. **Fix**: Apply targeted fix to the specific vulnerability
3. **Verify**: Re-run the applicable check from Step 3 (not the full checklist — just the affected section)
4. **Regression**: Run test suite to verify fix didn't break functionality
5. **Re-scan**: Run SAST scan on the modified file(s) to verify no new issues

**Loop**: Repeat until all SEC-CRITICAL findings are resolved. SEC-HIGH findings must be resolved before Gate A3 (can continue to A1 with SEC-HIGH logged).

**Maximum iterations**: 3 per finding. If a SEC-CRITICAL finding cannot be resolved in 3 attempts, STOP and document as blocking issue requiring user guidance.

### Step 5: Document Findings

Use **Display Template** from `council-audit.md` to show: Performance Report

### Step 6: Phase Completion Criteria

- [ ] Performance benchmarks established
- [ ] Security scan complete
- [ ] Vulnerabilities documented
- [ ] Critical issues logged

### Step 7: Complete Phase

```
## T5: Performance & Security - Complete

**Performance**: [Summary]
**Security Findings**: [X] total, [Y] critical

**Next Step**: Run `/audit-a1` to begin Audit Track - Purpose Alignment
```

---
