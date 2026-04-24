---
trigger: always_on
---
# Anti-Slop Rules — Code Quality
**Priority Level:** P0 — Always Active. Flag violations as `ANTI-SLOP VIOLATION: code - [category] - [specific pattern]` and correct immediately. Language-agnostic; for visual/UI rules see `anti-slop-visual.md`.

**Every line of code MUST be clean, intentional, and unmistakably professional. If it looks like AI generated it without thinking, it is slop. Fix it.**
## 1. CODE PATTERNS — BANNED
| Pattern | Required Alternative |
|---------|---------------------|
| `any` type | Proper types, generics, type inference |
| Magic numbers/strings | Named constants, enums, config objects |
| Commented-out code | Delete it. Use git history. |
| `console.log` left in | Remove before commit. Use structured logging. |
| Giant components (300+ lines) | Split into focused subcomponents (<150 lines) |
| Nested ternaries | Early returns, switch, lookup objects |
| Mixed import styles | Strict ordering: framework → external → internal |
| Prop drilling 5+ levels | Context, composition, or state management |
| Copy-pasted code blocks | Extract to reusable functions/components |
| `useEffect` for everything | Server Components, derived state, event handlers |
| Callback hell | async/await with proper error handling |

## 2. SECURITY PATTERNS — BANNED
| Pattern | Required Alternative |
|---------|---------------------|
| String concatenation in queries | Parameterized queries (Prisma, prepared statements) |
| Leaking internals to client | Generic messages to client, detailed to server logs |
| Tokens in localStorage | HttpOnly cookies |
| No JWT validation | Verify iss, aud, exp on every request |
| Secrets in client code | Server-side only, environment variables |
| No rate limiting | Rate limit ALL endpoints |
| No input validation | Schema validation (Zod, Pydantic, etc.) on all inputs |
| No authorization checks | Check authorization on EVERY endpoint |
| Hardcoded secrets | Environment variables or secret manager |

## 3. STRUCTURE PATTERNS — BANNED
| Pattern | Required Alternative |
|---------|---------------------|
| Everything in one file | One component/module per file |
| No folder structure | Feature-based or layer-based organization |
| Mixed concerns in components | Separate UI, logic, data fetching |
| API calls in components | Hooks, services, server actions |
| Business logic in UI | Extract to pure functions |
| Styles mixed with logic | Design tokens, separate concerns |
| Single-file dumping (HTML+CSS+JS) | Component decomposition, proper modules |
| Inline styles mixed with utility classes | Choose one approach and commit |

## 4. LOGIC PATTERNS — BANNED
| Pattern | Required Alternative |
|---------|---------------------|
| Unnecessary state | Derive from existing state/props |
| State for server data | React Query, SWR, Server Components |
| Over-engineering | YAGNI — build what you need now |
| Premature abstraction | Wait for patterns to emerge (rule of three) |
| God components | Single responsibility principle |

## 5. MISSING STATES — REQUIRED
Every async operation and interactive element MUST handle: **Loading** (skeleton/spinner), **Error** (meaningful UI — not console-only), **Empty** (designed state for every list/container), **Disabled** (visual + functional), **Optimistic updates** (where appropriate). Only the happy path is slop.

## 6. LOGGING — BANNED PATTERNS
**Never log:** passwords, tokens, PII, session secrets, API keys. **Always log:** safe identifiers only (userId, action, traceId, requestId). Every entry MUST include `timestamp` (UTC ISO 8601), `level`, `service`, `traceId`. Structured JSON only — no string concatenation.

## 7. ARCHITECTURAL — BANNED PATTERNS
| Missing | Required |
|---------|----------|
| No error boundary | Error boundaries at route and component level |
| No retry logic | Retry with backoff on all network requests |
| No timeout handling | Explicit timeout on every external call |
| No graceful degradation | Features degrade gracefully when dependencies fail |
| No health checks | `/health` or `/readiness` endpoint on every service |

---
## Slop Detection Checklist
Before committing: no `any` types · no magic values · no commented-out code · no `console.log` · components under 150 lines · no duplicated code · file structure makes sense · new dev understands in 2 min · no unnecessary state · error/loading/empty states all handled · inputs validated at boundaries · secrets in env vars, not code.

## Enforcement
P0 violations MUST be corrected before any commit. No exceptions. Flag: `ANTI-SLOP VIOLATION: code - [category] - [specific pattern]`

## Extended Rationale
"Why Banned" rationale and code examples for every pattern above are in `rules/anti-slop-code-reference.md` — loaded on demand when an AIOU touches a relevant pattern domain.
