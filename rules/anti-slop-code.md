---
trigger: always_on
---

# Anti-Slop Rules — Code Quality

**Priority Level:** P0 — Always Active
**Purpose:** Strictly prohibit all known AI-generated code patterns. No exceptions.
**Enforcement:** Any violation MUST be flagged as `ANTI-SLOP VIOLATION: code - [category] - [specific pattern]` and corrected immediately.
**Scope:** Language-agnostic code quality. For visual/UI rules, see `anti-slop-visual.md` (loaded conditionally during UI work).

---

## Core Mandate

**Every line of code MUST be clean, intentional, and unmistakably professional. If it looks like AI generated it without thinking, it is slop. Fix it.**

---

## 1. CODE PATTERNS — BANNED

| Pattern | Why Banned | Required Alternative |
|---------|-----------|---------------------|
| `any` type | Defeats TypeScript's purpose entirely | Proper types, generics, type inference |
| Magic numbers/strings | Unclear intent, unmaintainable | Named constants, enums, config objects |
| Commented-out code | Clutter, confusion, version control exists | Delete it. Use git history. |
| Console.log left in | Unprofessional, leaks info to client | Remove before commit. Use structured logging. |
| Giant components (300+ lines) | Unmaintainable, untestable | Split into focused subcomponents (<150 lines) |
| Nested ternaries | Unreadable | Early returns, switch, lookup objects |
| Mixed import styles | Inconsistent, hard to scan | Strict ordering: framework → external → internal |
| Prop drilling 5+ levels | Coupling nightmare | Context, composition, or state management |
| Copy-pasted code blocks | Maintenance burden, divergence risk | Extract to reusable functions/components |
| `useEffect` for everything | Over-complicated, race conditions | Server Components, derived state, event handlers |
| Callback hell | Unreadable async code | async/await with proper error handling |

---

## 2. SECURITY PATTERNS — BANNED

| Pattern | Why Banned | Required Alternative |
|---------|-----------|---------------------|
| String concatenation in queries | SQL injection | Parameterized queries (Prisma, prepared statements) |
| Leaking internals to client | Information exposure | Generic messages to client, detailed to server logs |
| Tokens in localStorage | XSS vulnerable | HttpOnly cookies |
| No JWT validation | Security bypass | Verify iss, aud, exp claims on every request |
| Secrets in client code | Exposure risk | Server-side only, environment variables |
| No rate limiting | Brute force vulnerable | Rate limit ALL endpoints |
| No input validation | Injection risk | Schema validation on all inputs (Zod, Pydantic, etc.) |
| No authorization checks | Privilege escalation | Check authorization on EVERY endpoint |
| Hardcoded secrets | Credential exposure | Environment variables or secret manager |

---

## 3. STRUCTURE PATTERNS — BANNED

| Pattern | Why Banned | Required Alternative |
|---------|-----------|---------------------|
| Everything in one file | Impossible to navigate | One component/module per file |
| No folder structure | Chaos at scale | Feature-based or layer-based organization |
| Mixed concerns in components | Hard to test, hard to reuse | Separate UI, logic, data fetching |
| API calls in components | Tight coupling | Hooks, services, server actions |
| Business logic in UI | Untestable | Extract to pure functions |
| Styles mixed with logic | Hard to maintain | Design tokens, separate concerns |
| Single-file dumping | HTML+CSS+JS in one massive file | Component decomposition, proper modules |
| Inline styles mixed with utility classes | Inconsistent, unmaintainable | Choose one approach and commit |

---

## 4. LOGIC PATTERNS — BANNED

| Pattern | Why Banned | Required Alternative |
|---------|-----------|---------------------|
| Unnecessary state | Re-renders, bugs | Derive from existing state/props |
| State for server data | Stale data, sync issues | React Query, SWR, Server Components |
| Over-engineering | Complexity without benefit | YAGNI — build what you need now |
| Premature abstraction | Wrong abstractions lock you in | Wait for patterns to emerge (rule of three) |
| God components | Does everything, maintains nothing | Single responsibility principle |

---

## 5. MISSING STATES — REQUIRED

Omitting these is slop. Every async operation and interactive element MUST handle:

- **Loading states**: Skeleton screens, spinners, or progress indicators for every data fetch
- **Error states**: Meaningful error UI for every failure mode — not just console errors
- **Empty states**: Designed empty state for every list, table, and container
- **Disabled states**: Visual and functional disabled state for every interactive element
- **Optimistic updates**: Where appropriate, update UI before server confirmation

Only designing the "happy path" is the hallmark of AI-generated code. Real applications handle failure.

---

## 6. LOGGING — BANNED PATTERNS

**Never log:** passwords, tokens, credit card numbers, PII, session secrets, API keys.
**Always log:** safe identifiers only (userId, action, traceId, requestId).

Every log entry MUST include: `timestamp` (UTC ISO 8601), `level`, `service`, `traceId`.

Structured logging format required (JSON). No unstructured string concatenation in log messages.

---

## 7. ARCHITECTURAL — BANNED PATTERNS

- **No error boundary**: Applications MUST have error boundaries at route and component level
- **No retry logic**: Network requests MUST handle transient failures
- **No timeout handling**: External calls MUST have timeouts configured
- **No graceful degradation**: Features MUST degrade gracefully when dependencies are unavailable
- **No health checks**: Services MUST expose health/readiness endpoints

---

## Slop Detection Checklist

Before committing any code:

- [ ] Can I explain what this code does in one sentence?
- [ ] Is there duplicated code that should be extracted?
- [ ] Are there any `any` types I can eliminate?
- [ ] Is every component under 150 lines?
- [ ] Are all magic values named constants?
- [ ] Is there commented-out code to delete?
- [ ] Are console.logs removed?
- [ ] Does the file structure make sense?
- [ ] Would a new developer understand this in under 2 minutes?
- [ ] Is there unnecessary state that could be derived?
- [ ] Are all error/loading/empty states handled?
- [ ] Are all inputs validated at system boundaries?
- [ ] Are secrets in environment variables, not code?

---

## Enforcement

P0 violations MUST be corrected before any commit. There are NO acceptable exceptions. "It was faster" and "it works" are not justifications for slop.

Flag violations as: `ANTI-SLOP VIOLATION: code - [category] - [specific pattern]`
