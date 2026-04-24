# Anti-Slop Code — Extended Reference

**Load when**: Writing code in an AIOU that touches a banned pattern's domain (security code, component decomposition, state management, error handling, async logic, logging, or architectural wiring).
**Load mechanism**: Explicit Read at AIOU start when the AIOU spec mentions a domain covered below.

This is the extended rationale for `rules/anti-slop-code.md`. The core rules file stays minimal for always-on loading; this file provides the "why" and concrete examples when an agent is about to write code that might violate a banned pattern.

---

## Section 1 Rationale: Code Patterns

**`any` type**
TypeScript's entire value proposition is catching type errors at compile time. Using `any` silently opts out, turning the type checker into decoration. Recognize it as explicit annotations (`x: any`), implicit inference from untyped third-party code, and casts like `as any`. Replace with concrete types, generics (`<T>`), or `unknown` (which forces explicit narrowing).

**Magic numbers/strings**
A bare `7` or `"active"` communicates nothing about meaning, origin, or whether it should match other instances. When the same value appears in three places and one copy gets updated, the bug is invisible. Use named constants (`const MAX_RETRIES = 7`) or enums so every reference is self-documenting and change-safe.

**Commented-out code**
Dead code in comments creates confusion about what the system actually does. Future readers wonder if it was intentionally disabled, partially relevant, or forgotten. Git history preserves every deletion permanently — delete it without hesitation.

**`console.log` left in**
Browser console output is readable by any user who opens DevTools. In production it leaks internal state, variable names, and data shapes. Replace all debug logging with a structured logger that writes to the server (Winston, Pino, structlog) and is controlled by log level.

**Giant components (300+ lines)**
Large components conflate rendering, state, side effects, and business logic into one untestable blob. A component over 150 lines almost always contains at least two distinct responsibilities. Split along those lines: one component renders, another manages state, a third coordinates data flow.

```tsx
// Before: one 400-line component doing everything
export function UserDashboard() { /* ... renders, fetches, transforms, sorts ... */ }

// After: focused subcomponents
export function UserDashboard() {
  const { users, isLoading, error } = useUsers();
  return <UserList users={users} isLoading={isLoading} error={error} />;
}
```

**Nested ternaries**
A ternary inside a ternary is impossible to read under time pressure. Recognize them as `condition ? a : condition2 ? b : c`. Replace with early returns, a `switch` statement, or a lookup object.

```ts
// Before
const label = status === 'active' ? 'Live' : status === 'draft' ? 'Draft' : 'Archived';

// After
const STATUS_LABELS: Record<string, string> = {
  active: 'Live',
  draft: 'Draft',
  archived: 'Archived',
};
const label = STATUS_LABELS[status] ?? 'Unknown';
```

**Mixed import styles**
Mixing `import React from 'react'`, `import { useState } from 'react'`, and `const path = require('path')` in the same file makes the import block unreadable. Enforce strict ordering: framework imports first, then external packages, then internal modules. Pick ESM or CJS and stick to it.

**Prop drilling 5+ levels**
Passing the same prop through five intermediate components means five components are coupled to a data shape they don't use. Recognize it when intermediate components accept a prop only to forward it. Use React Context, component composition, Zustand, or a co-located server component to deliver data where it's needed without threading it through the tree.

**Copy-pasted code blocks**
Duplicated blocks diverge over time — one copy gets a bug fix, the other doesn't. If the same logic appears twice, extract it to a shared function. Apply the Rule of Three: extract on the third occurrence.

**`useEffect` for everything**
`useEffect` is designed for synchronizing with external systems (DOM, network, subscriptions). Using it to compute derived values, handle events, or orchestrate data fetches leads to stale closures and race conditions. Prefer: Server Components for data fetching, `useMemo`/`useCallback` for derived state, event handlers for user actions.

**Callback hell**
Deeply nested callbacks (`.then().then().then()`) are hard to read, hard to debug, and make error handling inconsistent. Flatten all async code with `async/await` and handle errors with `try/catch` or a result type.

---

## Section 2 Rationale: Security Patterns

**String concatenation in queries**
Concatenating user input into a SQL string (`"SELECT * FROM users WHERE id = " + userId`) allows an attacker to inject arbitrary SQL. This is OWASP A03 Injection and has been exploited in virtually every major data breach. Always use parameterized queries via an ORM (Prisma, SQLAlchemy) or prepared statements where the database driver separates code from data.

```ts
// Before — NEVER
const result = await db.query(`SELECT * FROM users WHERE email = '${email}'`);

// After
const result = await prisma.user.findUnique({ where: { email } });
```

**Leaking internals to client**
Stack traces, file paths, database error messages, and column names in API error responses provide attackers with a map of your system. A database constraint error like `duplicate key value violates unique constraint "users_email_key"` tells an attacker what columns exist and how the schema is structured. Send a generic message to the client (`"Email already in use"`) and log the full error server-side with a trace ID.

**Tokens in localStorage**
Data in `localStorage` is accessible to any JavaScript running on the page, including injected scripts (XSS). An attacker who achieves XSS can exfiltrate every token stored there. Use `HttpOnly` cookies, which the browser sends automatically but JavaScript cannot read.

**No JWT validation**
Accepting a JWT without verifying `iss` (issuer), `aud` (audience), and `exp` (expiry) allows attackers to use tokens from other services or tokens that should have expired. Validate all three claims on every request, using a library that does so by default (e.g., `jsonwebtoken`, `python-jose`).

**Secrets in client code**
Any value bundled into client-side JavaScript is publicly readable — anyone can open DevTools or inspect the bundle. API keys, database credentials, and signing secrets must live exclusively in server-side environment variables and never be imported in files that are sent to the browser.

**No rate limiting**
Endpoints without rate limiting can be brute-forced indefinitely. A login endpoint without rate limiting can be attacked with millions of password attempts. Apply rate limiting to every endpoint, with stricter limits on authentication, password reset, and expensive operations.

**No input validation**
Accepting untrusted input without schema validation is the root cause of injection attacks, data corruption, and unexpected application states. Validate type, length, format, and allowed values at every system boundary using a schema library (Zod, Pydantic, Joi). Fail fast and return a clear error rather than processing bad data.

**No authorization checks**
Authentication (who you are) is not the same as authorization (what you can do). An authenticated user should not be able to access or modify another user's data by guessing an ID. Check ownership or role on every endpoint that accesses data, not just at the route level.

**Hardcoded secrets**
A secret committed to source code is permanently exposed — git history preserves it even after deletion, and anyone with repository access has it. Use environment variables (`.env`) or a secret manager (AWS Secrets Manager, Vault, Doppler). Rotate any secret that was ever hardcoded.

---

## Section 3 Rationale: Structure Patterns

**Everything in one file**
A single file with hundreds of functions, classes, or components has no coherent mental model. Developers can't navigate it, can't test it in isolation, and can't understand what a change affects. One component or module per file creates clear boundaries.

**No folder structure**
A flat directory of 50 files is as navigable as a pile of papers. Group files by feature or layer so that everything related to "user authentication" lives together. This enables a new developer to find all relevant code without searching globally.

**Mixed concerns in components**
A component that fetches data, transforms it, manages form state, and renders HTML has four responsibilities. Any one of those responsibilities changing requires understanding the other three. Separate: UI rendering (the component), data access (a service or hook), and business logic (pure functions).

**API calls in components**
Calling `fetch` directly in a component body tightly couples the UI to a specific endpoint URL, response shape, and error format. If that API changes, every component that calls it must be updated. Centralize API calls in hooks or services; components receive data as props.

**Business logic in UI**
Logic embedded in event handlers or render methods cannot be unit-tested without mounting a component. Extract pure functions (calculate, transform, validate) that can be tested independently of the rendering environment.

**Styles mixed with logic**
Inline styles inside component logic create a maintenance burden — the same component file must be understood by both the developer adding features and the designer adjusting visuals. Use design tokens and CSS modules, or a utility class strategy (Tailwind), applied consistently.

**Single-file dumping**
A single HTML file containing inline `<style>` blocks and inline `<script>` blocks cannot be tested, cannot be cached independently, and cannot be composed. Break HTML, CSS, and JS into separate modules at the start of any project.

**Inline styles mixed with utility classes**
Mixing `style={{ color: '#ff0000' }}` and `className="text-red-500"` on the same elements creates two competing styling systems in one codebase. Maintain a single source of truth for styles.

---

## Section 4 Rationale: Logic Patterns

**Unnecessary state**
Every piece of state triggers a re-render when it changes. Storing a value in state that can be derived from existing state (`const fullName = state.firstName + ' ' + state.lastName`) means two sources of truth that can diverge. Derive it during render or in a `useMemo`.

**State for server data**
Storing API responses in `useState` creates stale-data bugs (the data goes stale when the server updates), loading/error state management burden, and cache-invalidation complexity. Libraries like React Query and SWR solve all three with a few lines of code. Server Components eliminate the problem entirely by fetching at render time.

**Over-engineering**
Abstracting a solution for a use case that doesn't exist yet means writing and maintaining code that may never be needed. The abstraction layer is also often wrong — built for an imagined future rather than the actual requirements that emerge. Build the simplest thing that works now (YAGNI) and refactor when the pattern is clear.

**Premature abstraction**
The first implementation of a pattern reveals its rough shape. The second reveals variations. Only by the third can you see what the abstraction should actually look like. Creating an abstraction from one or two instances produces an over-fitted, inflexible interface. Wait for the Rule of Three.

**God components**
A component that manages global state, fetches from five endpoints, contains five sub-views, and handles navigation is impossible to reason about. It violates the Single Responsibility Principle and becomes the source of the hardest bugs. Split it — one component, one job.

---

## Section 5 Rationale: Missing States

Every async operation passes through multiple states before completion. Omitting any state leaves users confused or stuck.

**Loading states**
Without a loading indicator, a user who clicks a button doesn't know if their action registered. They click again. The request fires twice. Use skeleton screens (preferred for content areas), spinners (for actions), or progress bars (for uploads) for every data fetch and every mutation.

**Error states**
When a request fails and nothing changes on screen, users assume the app is broken or their action failed silently. Display a meaningful error message that tells users what went wrong and what they can do (retry, contact support, check their input). Never log only to the console.

**Empty states**
An empty list with no message looks like a loading failure. A designed empty state ("No items yet — add your first one") confirms to the user that the data loaded correctly and guides them to the next action. Required for every list, table, and container.

**Disabled states**
A button that looks clickable but does nothing is a confusing bug. A form field that accepts input but has no effect is worse. Every interactive element must have a visible disabled state (reduced opacity, `cursor: not-allowed`, `aria-disabled`) that activates during loading or when the action is unavailable.

**Optimistic updates**
For low-risk mutations (marking a todo done, liking a post), updating the UI before the server responds makes the app feel instant. If the server returns an error, revert to the previous state and show an error message. This pattern requires explicit rollback logic — do not omit it.

---

## Section 6 Rationale: Logging

**What never to log**
Passwords, tokens, credit card numbers, PII (email, name, SSN), session secrets, and API keys in log output create a secondary attack surface. Log aggregation services, log files, and monitoring dashboards are often less protected than the primary data store. A token in a log line is an exploitable credential.

**What to always log**
Safe identifiers — `userId`, `action`, `traceId`, `requestId` — give enough context to trace a request through the system without exposing sensitive data. A `traceId` that threads through every log line for a request is more useful than the raw data itself.

**Required fields**
A log line without a timestamp cannot be correlated with other events. A line without a level cannot be filtered by severity. A line without a `service` name cannot be attributed in a distributed system. A line without a `traceId` cannot be followed across service boundaries. These four fields must be present on every log entry.

**Structured JSON logging**
String concatenation (`"User " + userId + " logged in"`) produces log lines that are human-readable but machine-hostile. Grep-based log analysis doesn't scale. JSON log output (`{ "userId": 42, "action": "login", "timestamp": "..." }`) enables indexing, filtering, and aggregation in any log management platform (Datadog, Loki, CloudWatch).

---

## Section 7 Rationale: Architectural Patterns

**No error boundary**
An unhandled React error in a deeply nested component will unmount the entire application, showing a blank white screen with no indication of what failed. Error boundaries catch rendering errors and display a fallback UI. Place them at route level (to scope failures to one page) and at critical component level (to protect independent widgets).

**No retry logic**
Network requests to external services fail transiently — a brief overload, a DNS hiccup, a connection reset. A request that fails once and gives up produces an error that would have succeeded on a second attempt 200ms later. Implement exponential backoff retry for all outbound network requests. Libraries like `axios-retry`, `tenacity`, and `net/http` retriers make this straightforward.

**No timeout handling**
An HTTP request to an external API with no timeout will hang indefinitely if the remote server stops responding. This blocks a thread (or a promise) forever, eventually exhausting the connection pool. Every outbound call must have an explicit timeout; exceed it and fail fast with a clear error.

**No graceful degradation**
A feature that crashes or shows an error screen when its downstream dependency is unavailable provides worse UX than a feature that says "this section is temporarily unavailable." Design every feature to degrade gracefully: show cached data, show a placeholder, or hide the section entirely rather than breaking the page.

**No health checks**
A service without a `/health` or `/readiness` endpoint cannot be monitored by orchestrators (Kubernetes, ECS), load balancers, or on-call alerting. Implement a health endpoint that returns `200 OK` when the service is ready to accept traffic and a non-2xx response with diagnostic detail when it is not.
