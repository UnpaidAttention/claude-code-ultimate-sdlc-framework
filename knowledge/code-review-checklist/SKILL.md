name: code-review-checklist
description: Provides structured code review guidelines including checklists for correctness, security, and performance. Use when reviewing pull requests, conducting code audits, onboarding team members to codebase standards, performing self-review before PR submission, or establishing team coding standards.

# Code Review Checklist

> Systematic approach to code review ensuring correctness, security, performance, and maintainability through structured checklists and constructive feedback.


## Core Principles

| Principle | Rule |
|-----------|------|
| Constructive | Feedback improves code AND developer |
| Objective | Focus on code, not the person |
| Thorough | Check all dimensions, not just functionality |
| Timely | Review within 24 hours of submission |
| Educational | Explain the "why" behind suggestions |
| Balanced | Acknowledge good work, not just problems |


## When to Use

- Reviewing pull requests before merge
- Pair programming sessions
- Code audits and quality assessments
- Onboarding new team members to codebase
- Self-review before submitting PRs
- Establishing team coding standards


## Review Process Workflow

### 1. Pre-Review Preparation

```markdown
Before starting the review:
- [ ] Understand the context (read PR description, linked issues)
- [ ] Check the scope (is this the right size for one PR?)
- [ ] Identify the review type needed (quick check vs deep dive)
- [ ] Set aside focused time (no context switching)
```

### 2. Review Phases

```
Phase 1: High-Level Scan (5 min)
├── Read PR description and linked tickets
├── Scan file list for scope
├── Check for obvious red flags
└── Identify areas needing deep review

Phase 2: Deep Review (15-30 min)
├── Review changes file by file
├── Check each checklist category
├── Test mentally or locally
└── Note questions and concerns

Phase 3: Synthesis (5 min)
├── Prioritize feedback by severity
├── Write constructive comments
├── Make approval decision
└── Provide overall summary
```

### 3. Review Time Guidelines

| PR Size | Files Changed | Expected Time | Review Depth |
|---------|---------------|---------------|--------------|
| XS | 1-3 | 10-15 min | Quick scan |
| S | 4-10 | 15-30 min | Standard review |
| M | 11-20 | 30-60 min | Deep review |
| L | 21+ | Split PR | Requires breakdown |

### 4. Approval Criteria

| Decision | Criteria |
|----------|----------|
| Approve | No blocking issues, minor nits only |
| Request Changes | Blocking issues found, must address before merge |
| Comment | Questions or suggestions, no approval decision yet |


## Checklist Categories

### 1. Correctness

| Check | Question |
|-------|----------|
| Logic | Does the code do what it's supposed to do? |
| Edge Cases | Are boundary conditions handled? |
| Error Handling | Are errors caught and handled appropriately? |
| Null Safety | Are null/undefined cases handled? |
| Type Safety | Are types correct and complete? |
| Data Integrity | Is data validated before use? |
| Race Conditions | Are concurrent operations safe? |
| Resource Cleanup | Are resources (connections, files) properly closed? |

```typescript
// Edge case check example
// Question: What happens if items is empty?

// Before (missing edge case)
function calculateAverage(items: number[]): number {
  return items.reduce((a, b) => a + b, 0) / items.length;  // Division by zero!
}

// After (edge case handled)
function calculateAverage(items: number[]): number {
  if (items.length === 0) return 0;
  return items.reduce((a, b) => a + b, 0) / items.length;
}
```

### 2. Security

| Check | Question |
|-------|----------|
| Input Validation | Is all user input validated and sanitized? |
| SQL Injection | Are queries parameterized? |
| XSS Prevention | Is output properly escaped? |
| CSRF Protection | Are state-changing requests protected? |
| Authentication | Is auth required where needed? |
| Authorization | Are permissions checked correctly? |
| Secrets | Are there hardcoded secrets or credentials? |
| Data Exposure | Is sensitive data properly protected? |
| Logging | Are sensitive values excluded from logs? |

```python
# Security review examples

# SQL Injection vulnerability
cursor.execute(f"SELECT * FROM users WHERE id = {user_id}")  # BAD

# Parameterized query (safe)
cursor.execute("SELECT * FROM users WHERE id = ?", (user_id,))  # GOOD

# XSS vulnerability - rendering unsanitized user content
# BAD: Directly inserting user HTML without sanitization

# Safe rendering - use framework escaping or sanitization libraries
# GOOD: Let framework escape by default, or use DOMPurify for HTML
```

#### AI-Specific Security Checks

| Check | Question |
|-------|----------|
| Prompt Injection | Is user input properly isolated from system prompts? |
| Output Sanitization | Are AI outputs sanitized before use in critical sinks? |
| Context Limits | Are token limits enforced to prevent abuse? |
| Model Access | Is access to AI models properly authenticated? |

```typescript
// AI prompt injection prevention
// BAD: Direct user input in prompt
const response = await ai.generate(`Summarize: ${userInput}`);

// GOOD: Structured prompt with sanitization
const response = await ai.generate({
  system: "You are a summarization assistant. Only summarize the provided text.",
  input: sanitize(userInput),
  schema: SummaryResponseSchema
});
```

### 3. Performance

| Check | Question |
|-------|----------|
| N+1 Queries | Are there nested database calls in loops? |
| Unnecessary Operations | Are there redundant computations? |
| Memory Usage | Are large data sets handled efficiently? |
| Caching | Is appropriate caching in place? |
| Bundle Size | Does this significantly increase bundle size? |
| Lazy Loading | Are heavy resources loaded on demand? |
| Database Indexes | Are queries using appropriate indexes? |
| API Calls | Are external calls batched or minimized? |

```python
# N+1 query detection

# BAD: N+1 query
users = User.all()
for user in users:
    print(user.orders.count())  # Separate query for each user!

# GOOD: Eager loading
users = User.prefetch_related('orders').all()
for user in users:
    print(len(user.orders))  # Already loaded
```

### 4. Maintainability

| Check | Question |
|-------|----------|
| Naming | Are names clear and descriptive? |
| DRY | Is there duplicate code that should be extracted? |
| SOLID | Are SOLID principles followed? |
| Complexity | Are functions/methods too complex? |
| Documentation | Is complex logic documented? |
| Magic Values | Are magic numbers/strings defined as constants? |
| Abstraction | Is the abstraction level appropriate? |
| Testability | Is the code easy to test? |

```typescript
// Maintainability examples

// BAD: Magic numbers, unclear naming
if (status === 3) {
  setTimeout(() => refresh(), 300000);
}

// GOOD: Named constants, clear purpose
const ORDER_STATUS = {
  PENDING: 1,
  PROCESSING: 2,
  COMPLETED: 3,
} as const;

const REFRESH_INTERVAL_MS = 5 * 60 * 1000; // 5 minutes

if (status === ORDER_STATUS.COMPLETED) {
  setTimeout(() => refreshOrderList(), REFRESH_INTERVAL_MS);
}
```

### 5. Testing

| Check | Question |
|-------|----------|
| Coverage | Is new code covered by tests? |
| Edge Cases | Are edge cases tested? |
| Test Quality | Are tests meaningful, not just line coverage? |
| Test Naming | Do test names describe the scenario? |
| Test Independence | Are tests independent of each other? |
| Mocking | Are external dependencies properly mocked? |

### 6. Documentation

| Check | Question |
|-------|----------|
| Public APIs | Are public interfaces documented? |
| Complex Logic | Is non-obvious code explained? |
| Decisions | Are important decisions documented? |
| Examples | Are usage examples provided where helpful? |
| README | Is README updated if needed? |


## Severity Classification

### Severity Levels

| Level | Symbol | Criteria | Action Required |
|-------|--------|----------|-----------------|
| Blocking | BLOCKING | Must fix before merge | PR cannot be approved |
| Major | MAJOR | Should fix, significant issue | Fix required or strong justification |
| Minor | MINOR | Improvement suggestion | Nice to have, author discretion |
| Nit | NIT | Style/preference | Optional, take or leave |
| Question | QUESTION | Need clarification | Response needed before decision |
| Praise | PRAISE | Good work worth noting | Recognition, no action |

### Severity Decision Matrix

```
Is it a bug or security issue?
├── Yes → BLOCKING
└── No → Does it significantly impact:
         ├── Performance → MAJOR
         ├── Maintainability → MAJOR or MINOR
         ├── Readability → MINOR or NIT
         └── Personal preference → NIT
```


## Feedback Templates

### Comment Format

```markdown
**[SEVERITY]**: Brief summary

[Detailed explanation with reasoning]

[Code suggestion if applicable]
```

### Example Comments by Type

#### Blocking Issue
```markdown
**BLOCKING**: SQL injection vulnerability

This query concatenates user input directly into SQL, allowing injection attacks.

```python
# Current (vulnerable)
query = f"SELECT * FROM users WHERE name = '{name}'"

# Suggested (safe)
query = "SELECT * FROM users WHERE name = ?"
cursor.execute(query, (name,))
```

Reference: OWASP SQL Injection Prevention
```

#### Major Issue
```markdown
**MAJOR**: Missing error handling for API call

If the API call fails, the error will propagate unhandled and crash the request.

```typescript
// Current
const data = await fetch('/api/users').then(r => r.json());

// Suggested
try {
  const response = await fetch('/api/users');
  if (!response.ok) {
    throw new Error(`API error: ${response.status}`);
  }
  const data = await response.json();
} catch (error) {
  logger.error('Failed to fetch users', error);
  throw new UserFetchError('Unable to load users');
}
```
```

#### Minor Suggestion
```markdown
**MINOR**: Consider extracting repeated validation logic

This validation pattern appears in 3 places. Consider extracting to a shared validator.

```typescript
// Suggested extraction
const validateEmail = (email: string): ValidationResult => {
  if (!email) return { valid: false, error: 'Email required' };
  if (!EMAIL_REGEX.test(email)) return { valid: false, error: 'Invalid email format' };
  return { valid: true };
};
```
```

#### Nit
```markdown
**NIT**: Prefer const over let for immutable variable

`processedItems` is never reassigned, so `const` better communicates intent.

```typescript
// Current
let processedItems = items.map(transform);

// Suggested
const processedItems = items.map(transform);
```
```

#### Question
```markdown
**QUESTION**: What's the expected behavior when user is null?

I see we're accessing `user.email` without a null check. Is it guaranteed to exist at this point, or should we handle the null case?
```

#### Praise
```markdown
**PRAISE**: Great error handling pattern

Really like how you've structured the error recovery here with progressive fallbacks. This will make debugging much easier in production.
```


## Common Issues by Language

### TypeScript/JavaScript

| Issue | Example | Fix |
|-------|---------|-----|
| any type | `const data: any` | Use specific types or unknown |
| == instead of === | `if (a == b)` | Use strict equality |
| Missing null check | `user.name.toLowerCase()` | Optional chaining: `user?.name?.toLowerCase()` |
| Unhandled promise | `fetchData()` | `await fetchData()` or `.catch()` |
| Mutation in reducer | `state.items.push(item)` | Return new array: `[...state.items, item]` |

```typescript
// TypeScript-specific checks

// BAD: Using any
function process(data: any): any {
  return data.value * 2;
}

// GOOD: Proper typing
interface DataItem {
  value: number;
}

function process(data: DataItem): number {
  return data.value * 2;
}
```

### Python

| Issue | Example | Fix |
|-------|---------|-----|
| Mutable default args | `def fn(items=[])` | `def fn(items=None)` |
| Bare except | `except:` | `except Exception as e:` |
| Not using context managers | `f = open('file')` | `with open('file') as f:` |
| String formatting | `"Hello " + name` | `f"Hello {name}"` |
| No type hints | `def process(data):` | `def process(data: dict) -> list:` |

```python
# Python-specific checks

# BAD: Mutable default argument
def add_item(item, items=[]):  # items is shared across calls!
    items.append(item)
    return items

# GOOD: None default with initialization
def add_item(item, items=None):
    if items is None:
        items = []
    items.append(item)
    return items
```

### Go

| Issue | Example | Fix |
|-------|---------|-----|
| Ignored error | `result, _ := doSomething()` | Handle or explicitly document |
| Nil pointer | `user.Name` without check | Check nil before access |
| Goroutine leak | Unbounded goroutine creation | Use worker pools |
| Missing defer | `file.Close()` at end | `defer file.Close()` immediately after open |

```go
// Go-specific checks

// BAD: Ignored error
data, _ := json.Marshal(user)

// GOOD: Error handling
data, err := json.Marshal(user)
if err != nil {
    return fmt.Errorf("failed to marshal user: %w", err)
}
```

### React/Frontend

| Issue | Example | Fix |
|-------|---------|-----|
| Missing key prop | `items.map(i => <Item />)` | `items.map(i => <Item key={i.id} />)` |
| useEffect deps | Empty deps with state usage | Include all dependencies |
| Prop drilling | Passing through many levels | Use context or state management |
| Inline functions | `onClick={() => handle(id)}` | Use useCallback for stable references |

```tsx
// React-specific checks

// BAD: Missing dependency in useEffect
useEffect(() => {
  fetchUser(userId);  // userId not in deps!
}, []);

// GOOD: Complete dependencies
useEffect(() => {
  fetchUser(userId);
}, [userId]);

// BAD: Creating new function on every render
<button onClick={() => handleClick(item.id)}>Click</button>

// GOOD: Memoized callback
const handleItemClick = useCallback((id: string) => {
  // handle click
}, []);
```


## Automated vs Manual Review

### What to Automate

| Category | Tools |
|----------|-------|
| Formatting | Prettier, Black, gofmt |
| Linting | ESLint, Pylint, golangci-lint |
| Type Checking | TypeScript, mypy, go vet |
| Security Scanning | Snyk, CodeQL, Semgrep |
| Test Coverage | Jest, pytest-cov, go test -cover |
| Dependency Audit | npm audit, safety, govulncheck |
| Code Complexity | SonarQube, CodeClimate |

### What Requires Human Review

| Category | Why |
|----------|-----|
| Architecture Decisions | Context and trade-offs need judgment |
| Business Logic | Domain knowledge required |
| Algorithm Correctness | Edge cases need reasoning |
| Naming and Clarity | Subjective quality assessment |
| Performance Implications | System-wide impact analysis |
| Security Logic Flaws | Attacker mindset needed |
| Code Organization | Team conventions and patterns |

### Automation Setup Checklist

```yaml
# .github/workflows/code-quality.yml
name: Code Quality

on: [pull_request]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Lint
        run: npm run lint

      - name: Type Check
        run: npm run type-check

      - name: Test
        run: npm run test:coverage

      - name: Security Scan
        run: npm audit --audit-level=high
```


## Anti-Patterns to Flag

### Code Anti-Patterns

```typescript
// Deep nesting (hard to follow)
if (a) {
  if (b) {
    if (c) {
      if (d) {
        // actual logic buried here
      }
    }
  }
}

// Better: Early returns
if (!a) return;
if (!b) return;
if (!c) return;
if (!d) return;
// clear, focused logic here
```

```typescript
// Long functions (100+ lines)
function processOrder(order: Order) {
  // 150 lines of mixed concerns
}

// Better: Small, focused functions
function processOrder(order: Order) {
  validateOrder(order);
  calculateTotals(order);
  applyDiscounts(order);
  processPayment(order);
  sendConfirmation(order);
}
```

```typescript
// God objects (class doing too much)
class UserManager {
  createUser() {}
  deleteUser() {}
  sendEmail() {}
  generateReport() {}
  processPayment() {}
  // ... 50 more methods
}

// Better: Single responsibility
class UserService { /* user CRUD only */ }
class EmailService { /* email only */ }
class ReportService { /* reports only */ }
```


## Review Comment Etiquette

### Do

- Use "we" instead of "you" ("We should handle this case")
- Ask questions instead of demands ("What if this is null?")
- Provide context for suggestions ("This pattern helps with X")
- Acknowledge constraints ("I know this is a quick fix, but...")
- Offer to pair on complex changes
- Recognize good work explicitly

### Don't

- Be condescending ("This is obviously wrong")
- Make personal remarks ("You always do this")
- Leave vague comments ("This is bad")
- Pile on with repeated comments about the same issue
- Review when frustrated or tired
- Block on pure style preferences not in guidelines


## Quality Checks

| Check | Question |
|-------|----------|
| Completeness | Did I review all changed files? |
| Depth | Did I understand what the code does? |
| Context | Did I consider the broader system impact? |
| Objectivity | Are my comments about code, not person? |
| Actionability | Can the author act on my feedback? |
| Prioritization | Are blocking vs nice-to-have clear? |
| Timeliness | Am I reviewing within reasonable time? |
| Balance | Did I acknowledge what's done well? |


## Review Anti-Patterns

| Pattern | Problem | Fix |
|---------|---------|-----|
| Rubber Stamping | Approving without reading | Take time to understand changes |
| Nitpicking | All minor issues, missing major ones | Focus on impact, automate style |
| Blocking on Style | Refusing merge over preferences | Distinguish standards from preferences |
| Drive-by Reviews | Comments without resolution | Stay engaged until merged |
| Review Hoarding | One person reviews everything | Distribute reviews across team |
| Late Reviews | Reviewing days after submission | Set and honor SLAs |
| Rewrite Requests | "I would have done it differently" | Accept working solutions |


## Related Skills

- **test-patterns**: Understanding test quality in reviews
- **functional-testing**: Verifying functional requirements
- **aiou-decomposition**: Understanding change scope
- **security-review**: Deep security analysis
- **performance-review**: Deep performance analysis
