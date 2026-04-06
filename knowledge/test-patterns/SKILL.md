---
name: test-patterns
description: Covers testing patterns including unit test structures, mocking strategies, fixtures, test organization, and the testing pyramid. Use when writing unit tests for new code, creating integration tests, setting up test infrastructure, refactoring test suites, establishing testing standards, reviewing test quality, or choosing the right test type.
---

# Test Patterns

> Proven patterns and practices for writing maintainable, reliable, and effective automated tests across unit, integration, and end-to-end testing levels.


## Core Principles

| Principle | Rule |
|-----------|------|
| FIRST | Fast, Independent, Repeatable, Self-validating, Timely |
| Quality Over Quantity | 3-8 focused tests per AIOU beats 50 shallow tests |
| Test Behavior | Test what code does, not how it does it |
| Isolation | Each test is independent and self-contained |
| Readability | Tests are documentation for expected behavior |
| Maintainability | Tests should be easy to update when requirements change |


## When to Use

- Writing unit tests for new code
- Creating integration tests for APIs and services
- Setting up test infrastructure for a project
- Refactoring existing test suites
- Establishing testing standards for a team
- Reviewing test quality in code reviews


## Unit Test Patterns

### 1. Arrange-Act-Assert (AAA)

The most common and recommended pattern for structuring tests.

```python
def test_calculate_total_with_discount():
    # Arrange - Set up test data and dependencies
    cart = ShoppingCart()
    cart.add_item(Product("Widget", price=100))
    cart.add_item(Product("Gadget", price=50))
    discount = PercentageDiscount(10)

    # Act - Execute the behavior being tested
    total = cart.calculate_total(discount)

    # Assert - Verify the expected outcome
    assert total == 135  # (100 + 50) * 0.90
```

```typescript
describe('calculateTotal', () => {
  it('should apply percentage discount to cart total', () => {
    // Arrange
    const cart = new ShoppingCart();
    cart.addItem({ name: 'Widget', price: 100 });
    cart.addItem({ name: 'Gadget', price: 50 });
    const discount = new PercentageDiscount(10);

    // Act
    const total = cart.calculateTotal(discount);

    // Assert
    expect(total).toBe(135);
  });
});
```

### 2. Given-When-Then (BDD Style)

Best for behavior-driven development and readability.

```python
def test_user_login():
    """
    Given a registered user with valid credentials
    When they attempt to log in
    Then they should receive an authentication token
    """
    # Given
    user = create_user(email="test@example.com", password="SecurePass123")

    # When
    result = auth_service.login(email="test@example.com", password="SecurePass123")

    # Then
    assert result.success is True
    assert result.token is not None
    assert result.user.email == "test@example.com"
```

```typescript
describe('User Authentication', () => {
  describe('given a registered user with valid credentials', () => {
    let user: User;

    beforeEach(async () => {
      user = await createUser({ email: 'test@example.com', password: 'SecurePass123' });
    });

    describe('when they attempt to log in', () => {
      let result: LoginResult;

      beforeEach(async () => {
        result = await authService.login('test@example.com', 'SecurePass123');
      });

      it('then they should receive an authentication token', () => {
        expect(result.success).toBe(true);
        expect(result.token).toBeDefined();
      });

      it('then their user data should be returned', () => {
        expect(result.user.email).toBe('test@example.com');
      });
    });
  });
});
```

### 3. Four-Phase Test

Explicit setup, exercise, verify, and teardown phases.

```python
class TestDatabaseOperations:
    def test_user_persistence(self):
        # Setup
        db = TestDatabase()
        db.connect()
        user_repo = UserRepository(db)

        # Exercise
        user_id = user_repo.create(User(name="John", email="john@example.com"))
        retrieved = user_repo.find_by_id(user_id)

        # Verify
        assert retrieved is not None
        assert retrieved.name == "John"
        assert retrieved.email == "john@example.com"

        # Teardown
        user_repo.delete(user_id)
        db.disconnect()
```


## Test Naming Conventions

### Pattern 1: Method_Scenario_ExpectedResult

```python
# Python
def test_create_user_valid_input_returns_user():
def test_create_user_duplicate_email_raises_conflict():
def test_get_user_not_found_returns_none():
def test_delete_user_unauthorized_raises_forbidden():
```

### Pattern 2: should_ExpectedBehavior_when_Condition

```typescript
// TypeScript/JavaScript
describe('UserService', () => {
  it('should return user when valid ID provided', () => {});
  it('should throw NotFoundError when user does not exist', () => {});
  it('should hash password when creating user', () => {});
  it('should emit event when user is deleted', () => {});
});
```

### Pattern 3: Descriptive Sentence

```python
# Python with pytest
def test_users_can_update_their_own_profile():
def test_admins_can_delete_any_user():
def test_expired_tokens_are_rejected():
def test_rate_limiting_kicks_in_after_100_requests():
```

### Naming Guidelines

| Do | Don't |
|----|-------|
| `test_calculate_tax_with_discount_applies_discount_first` | `test_tax` |
| `should_return_404_when_resource_not_found` | `test_error` |
| `test_password_reset_token_expires_after_24_hours` | `test_token_expiry` |
| `it('validates email format on registration')` | `it('works')` |


## Mock/Stub/Spy Patterns

### Understanding Test Doubles

| Type | Purpose | Returns | Verifies Calls |
|------|---------|---------|----------------|
| Dummy | Fill parameter lists | N/A | No |
| Stub | Provide canned responses | Preset values | No |
| Spy | Record interactions | Real or preset | Yes |
| Mock | Verify interactions | Preset values | Yes |
| Fake | Working implementation | Computed | No |

### Stub Pattern

Provide predetermined responses without behavior verification.

```python
# Python with unittest.mock
def test_get_user_profile_returns_formatted_data():
    # Stub the repository
    user_repo = Mock()
    user_repo.find_by_id.return_value = User(
        id=1,
        name="John Doe",
        email="john@example.com"
    )

    service = UserService(user_repo)
    profile = service.get_profile(user_id=1)

    assert profile.display_name == "John Doe"
    assert profile.email_masked == "j***@example.com"
```

```typescript
// TypeScript with Jest
describe('UserService', () => {
  it('should return formatted profile data', async () => {
    // Stub
    const userRepo = {
      findById: jest.fn().mockResolvedValue({
        id: 1,
        name: 'John Doe',
        email: 'john@example.com'
      })
    };

    const service = new UserService(userRepo);
    const profile = await service.getProfile(1);

    expect(profile.displayName).toBe('John Doe');
    expect(profile.emailMasked).toBe('j***@example.com');
  });
});
```

### Mock Pattern

Verify that expected interactions occurred.

```python
def test_create_user_sends_welcome_email():
    # Mock the email service
    email_service = Mock()
    user_repo = Mock()
    user_repo.create.return_value = User(id=1, email="new@example.com")

    service = UserService(user_repo, email_service)
    service.create_user(email="new@example.com", name="New User")

    # Verify the mock was called correctly
    email_service.send_welcome_email.assert_called_once_with(
        to="new@example.com",
        name="New User"
    )
```

```typescript
describe('UserService', () => {
  it('should send welcome email when user is created', async () => {
    const emailService = {
      sendWelcomeEmail: jest.fn().mockResolvedValue(undefined)
    };
    const userRepo = {
      create: jest.fn().mockResolvedValue({ id: 1, email: 'new@example.com' })
    };

    const service = new UserService(userRepo, emailService);
    await service.createUser({ email: 'new@example.com', name: 'New User' });

    expect(emailService.sendWelcomeEmail).toHaveBeenCalledWith({
      to: 'new@example.com',
      name: 'New User'
    });
  });
});
```

### Spy Pattern

Record calls while preserving real behavior.

```python
def test_cache_is_used_for_repeated_requests():
    real_repo = UserRepository(database)
    spy_repo = Mock(wraps=real_repo)

    service = UserService(spy_repo)

    # First call - should hit database
    service.get_user(1)
    # Second call - should use cache
    service.get_user(1)

    # Verify only one database call was made
    assert spy_repo.find_by_id.call_count == 1
```

### Fake Pattern

Lightweight working implementation for testing.

```python
class FakeUserRepository:
    def __init__(self):
        self.users = {}
        self.next_id = 1

    def create(self, user: User) -> User:
        user.id = self.next_id
        self.users[self.next_id] = user
        self.next_id += 1
        return user

    def find_by_id(self, user_id: int) -> Optional[User]:
        return self.users.get(user_id)

    def delete(self, user_id: int) -> bool:
        if user_id in self.users:
            del self.users[user_id]
            return True
        return False

def test_user_lifecycle():
    repo = FakeUserRepository()
    service = UserService(repo)

    user = service.create_user(name="Test", email="test@example.com")
    assert service.get_user(user.id) is not None

    service.delete_user(user.id)
    assert service.get_user(user.id) is None
```

### When to Use Each

| Situation | Recommended Double |
|-----------|-------------------|
| External API calls | Stub (for responses) or Mock (for verification) |
| Database operations | Fake (in-memory) or Stub |
| Email/SMS sending | Mock (verify sent, don't actually send) |
| Time-dependent code | Stub (freeze time) |
| Logging | Spy (verify logs without changing behavior) |
| Cache | Fake (simple in-memory cache) |


## Fixture Patterns

### 1. Object Mother Pattern

Factory methods that create pre-configured test objects.

```python
class UserMother:
    @staticmethod
    def create_admin(**overrides):
        defaults = {
            "name": "Admin User",
            "email": "admin@example.com",
            "role": "admin",
            "is_active": True
        }
        return User(**{**defaults, **overrides})

    @staticmethod
    def create_regular_user(**overrides):
        defaults = {
            "name": "Regular User",
            "email": f"user_{uuid4()}@example.com",
            "role": "user",
            "is_active": True
        }
        return User(**{**defaults, **overrides})

    @staticmethod
    def create_inactive_user(**overrides):
        return UserMother.create_regular_user(is_active=False, **overrides)

# Usage
def test_admin_can_delete_users():
    admin = UserMother.create_admin()
    target = UserMother.create_regular_user()
    # ...
```

### 2. Builder Pattern

Fluent interface for constructing complex test objects.

```typescript
class UserBuilder {
  private user: Partial<User> = {};

  withName(name: string): this {
    this.user.name = name;
    return this;
  }

  withEmail(email: string): this {
    this.user.email = email;
    return this;
  }

  withRole(role: 'admin' | 'user'): this {
    this.user.role = role;
    return this;
  }

  active(): this {
    this.user.isActive = true;
    return this;
  }

  inactive(): this {
    this.user.isActive = false;
    return this;
  }

  withOrders(count: number): this {
    this.user.orders = Array.from({ length: count }, (_, i) =>
      new OrderBuilder().withId(i + 1).build()
    );
    return this;
  }

  build(): User {
    return new User({
      name: this.user.name ?? 'Test User',
      email: this.user.email ?? `test_${Date.now()}@example.com`,
      role: this.user.role ?? 'user',
      isActive: this.user.isActive ?? true,
      orders: this.user.orders ?? []
    });
  }
}

// Usage
describe('OrderHistory', () => {
  it('should show order count for active users with orders', () => {
    const user = new UserBuilder()
      .withName('John')
      .active()
      .withOrders(5)
      .build();

    const history = new OrderHistory(user);
    expect(history.getOrderCount()).toBe(5);
  });
});
```

### 3. Fixture Files

External files for large or complex test data.

```
tests/
├── fixtures/
│   ├── users/
│   │   ├── admin.json
│   │   ├── regular_user.json
│   │   └── user_with_orders.json
│   ├── products/
│   │   ├── simple_product.json
│   │   └── product_with_variants.json
│   └── api_responses/
│       ├── success_response.json
│       └── error_responses/
│           ├── validation_error.json
│           └── not_found.json
```

```python
import json
from pathlib import Path

FIXTURES_DIR = Path(__file__).parent / "fixtures"

def load_fixture(path: str) -> dict:
    with open(FIXTURES_DIR / path) as f:
        return json.load(f)

def test_api_returns_user_data():
    expected = load_fixture("users/admin.json")
    response = api_client.get("/users/1")
    assert response.json() == expected
```

### 4. Database Fixtures with Setup/Teardown

```python
import pytest

@pytest.fixture
def db_session():
    """Create a fresh database session for each test."""
    session = create_test_session()
    yield session
    session.rollback()
    session.close()

@pytest.fixture
def seeded_db(db_session):
    """Database with standard test data."""
    # Seed users
    db_session.add(User(id=1, name="Admin", role="admin"))
    db_session.add(User(id=2, name="User", role="user"))

    # Seed products
    db_session.add(Product(id=1, name="Widget", price=100))
    db_session.add(Product(id=2, name="Gadget", price=50))

    db_session.commit()
    yield db_session

def test_user_can_purchase_product(seeded_db):
    user = seeded_db.query(User).get(2)
    product = seeded_db.query(Product).get(1)

    order = OrderService(seeded_db).create_order(user, [product])

    assert order.total == 100
    assert order.user_id == 2
```


## Test Data Management

### Unique Data Generation

```python
from uuid import uuid4
from datetime import datetime

def unique_email():
    return f"test_{uuid4().hex[:8]}@example.com"

def unique_username():
    return f"user_{datetime.now().strftime('%Y%m%d%H%M%S')}_{uuid4().hex[:4]}"

def test_user_registration():
    email = unique_email()
    result = register_user(email=email, password="SecurePass123")
    assert result.email == email
```

### Test Data Factories

```typescript
// factories/user.factory.ts
import { faker } from '@faker-js/faker';

export const createTestUser = (overrides: Partial<User> = {}): User => ({
  id: faker.string.uuid(),
  name: faker.person.fullName(),
  email: faker.internet.email(),
  createdAt: faker.date.past(),
  isActive: true,
  ...overrides
});

export const createTestUsers = (count: number, overrides: Partial<User> = {}): User[] =>
  Array.from({ length: count }, () => createTestUser(overrides));

// Usage
describe('UserList', () => {
  it('should display all users', () => {
    const users = createTestUsers(5);
    render(<UserList users={users} />);
    expect(screen.getAllByRole('listitem')).toHaveLength(5);
  });

  it('should highlight inactive users', () => {
    const users = [
      createTestUser({ isActive: true }),
      createTestUser({ isActive: false })
    ];
    render(<UserList users={users} />);
    expect(screen.getByText(/inactive/i)).toBeInTheDocument();
  });
});
```


## Test Isolation Strategies

### 1. Database Isolation

```python
# Transaction rollback
@pytest.fixture
def isolated_db(db_connection):
    transaction = db_connection.begin()
    yield db_connection
    transaction.rollback()

# Separate database per test
@pytest.fixture
def isolated_db():
    db_name = f"test_{uuid4().hex[:8]}"
    create_database(db_name)
    yield get_connection(db_name)
    drop_database(db_name)
```

### 2. Service Isolation

```typescript
describe('OrderService', () => {
  let orderService: OrderService;
  let mockPaymentGateway: jest.Mocked<PaymentGateway>;
  let mockInventoryService: jest.Mocked<InventoryService>;
  let mockNotificationService: jest.Mocked<NotificationService>;

  beforeEach(() => {
    // Fresh mocks for each test
    mockPaymentGateway = {
      charge: jest.fn(),
      refund: jest.fn()
    };
    mockInventoryService = {
      reserve: jest.fn(),
      release: jest.fn()
    };
    mockNotificationService = {
      sendOrderConfirmation: jest.fn()
    };

    orderService = new OrderService(
      mockPaymentGateway,
      mockInventoryService,
      mockNotificationService
    );
  });

  afterEach(() => {
    jest.clearAllMocks();
  });
});
```

### 3. Time Isolation

```python
from freezegun import freeze_time

@freeze_time("2024-01-15 12:00:00")
def test_subscription_expires_after_30_days():
    subscription = create_subscription()  # Created at 2024-01-15

    with freeze_time("2024-02-14 12:00:00"):
        assert subscription.is_active() is True

    with freeze_time("2024-02-15 12:00:01"):
        assert subscription.is_active() is False
```

```typescript
describe('Subscription', () => {
  beforeEach(() => {
    jest.useFakeTimers();
    jest.setSystemTime(new Date('2024-01-15T12:00:00Z'));
  });

  afterEach(() => {
    jest.useRealTimers();
  });

  it('should expire after 30 days', () => {
    const subscription = createSubscription();

    // 29 days later - still active
    jest.advanceTimersByTime(29 * 24 * 60 * 60 * 1000);
    expect(subscription.isActive()).toBe(true);

    // 30 days + 1 second - expired
    jest.advanceTimersByTime(24 * 60 * 60 * 1000 + 1000);
    expect(subscription.isActive()).toBe(false);
  });
});
```


## Test Organization Patterns

### 1. File Structure by Feature

```
src/
├── users/
│   ├── user.service.ts
│   ├── user.repository.ts
│   └── __tests__/
│       ├── user.service.test.ts
│       └── user.repository.test.ts
├── orders/
│   ├── order.service.ts
│   └── __tests__/
│       └── order.service.test.ts
```

### 2. File Structure by Test Type

```
src/
├── services/
│   └── user.service.ts
tests/
├── unit/
│   └── services/
│       └── user.service.test.ts
├── integration/
│   └── api/
│       └── users.api.test.ts
└── e2e/
    └── user-registration.e2e.ts
```

### 3. Describe Block Organization

```typescript
describe('UserService', () => {
  // Group by method
  describe('createUser', () => {
    describe('with valid input', () => {
      it('should create user in database', () => {});
      it('should hash the password', () => {});
      it('should send welcome email', () => {});
    });

    describe('with invalid input', () => {
      it('should throw ValidationError for invalid email', () => {});
      it('should throw ValidationError for short password', () => {});
    });

    describe('when user already exists', () => {
      it('should throw ConflictError', () => {});
    });
  });

  describe('deleteUser', () => {
    describe('as admin', () => {
      it('should delete any user', () => {});
    });

    describe('as regular user', () => {
      it('should only delete own account', () => {});
      it('should throw ForbiddenError for other users', () => {});
    });
  });
});
```


## Tests by Wave

| Wave | Test Focus | Test Count | Patterns |
|------|------------|------------|----------|
| 0-1 | Type validation, utilities | 2-4 | Unit, property-based |
| 2 | CRUD operations, repositories | 3-5 | Integration, fixtures |
| 3 | Business logic, services | 4-6 | Unit with mocks |
| 4 | API contracts, controllers | 3-5 | Integration, contract |
| 5 | Component behavior, UI | 3-5 | Component, snapshot |
| 6 | E2E critical paths | 5-10 total | E2E, smoke |


## Quality Checks

| Check | Question |
|-------|----------|
| Independence | Can tests run in any order? |
| Isolation | Does each test clean up after itself? |
| Speed | Do unit tests run in < 100ms each? |
| Clarity | Can someone understand the test without reading the code? |
| Single Assertion | Does each test verify one behavior? |
| No Logic | Are there no if/else/loops in tests? |
| Deterministic | Do tests always produce the same result? |
| Maintainable | Will this test break for the right reasons? |


## Anti-Patterns

| Pattern | Problem | Fix |
|---------|---------|-----|
| Test Bloat | Testing every permutation | Focus on boundaries and partitions |
| Brittle Tests | Testing implementation details | Test behavior and outcomes |
| Slow Tests | Not mocking external dependencies | Mock I/O, use fakes |
| Flaky Tests | Relying on timing or order | Use deterministic waits, isolate |
| Mystery Guest | Test data defined elsewhere | Make test data explicit in test |
| Eager Test | One test verifies too much | Split into focused tests |
| Test Logic | Conditionals in tests | Remove logic, use parameterized tests |
| Shared State | Tests share mutable data | Fresh fixtures per test |
| Hidden Dependencies | Implicit setup requirements | Explicit arrange phase |


## What to Test vs What NOT to Test

### Test These

- Business logic and calculations
- State transitions and workflows
- Input validation and error handling
- Security-critical operations
- Integration points and contracts
- Edge cases and boundaries

### Skip These

- Framework/library internals
- Simple getters/setters without logic
- Configuration file loading
- Third-party service implementations
- Private methods (test through public interface)
- Trivial constructors


## Related Skills

- **functional-testing**: Higher-level test design techniques
- **code-review-checklist**: Reviewing test quality
- **aiou-decomposition**: Planning tests per work unit
- **mocking-strategies**: Deep dive on test doubles
- **test-automation**: CI/CD integration and test infrastructure


## Additional Patterns

### Testing Pyramid

```
        /\          E2E (Few)
       /  \         Critical flows
      /----\
     /      \       Integration (Some)
    /--------\      API, DB queries
   /          \
  /------------\    Unit (Many)
                    Functions, classes
```

### Test Type Selection

| Type | Best For | Speed |
|------|----------|-------|
| **Unit** | Pure functions, logic | Fast (<50ms) |
| **Integration** | API, DB, services | Medium |
| **E2E** | Critical user flows | Slow |

### Mocking Quick Reference

**When to Mock:**

| Mock | Don't Mock |
|------|------------|
| External APIs | The code under test |
| Database (unit) | Simple dependencies |
| Time/random | Pure functions |
| Network | In-memory stores |

### Test Best Practices Summary

| Practice | Why |
|----------|-----|
| One assert per test | Clear failure reason |
| Independent tests | No order dependency |
| Fast tests | Run frequently |
| Descriptive names | Self-documenting |
| Clean up | Avoid side effects |
