name: react-design-patterns
description: React component architecture, UI state management, and design patterns. Use when implementing React hooks, component composition, TypeScript integration, loading states, error handling, empty states, form submission, or data fetching UI patterns.

# React Design Patterns

> Principles and patterns for building production-ready React applications.


## Part 1: Architecture & Design

### 1. Component Design Principles

#### Component Types

| Type | Use | State |
|------|-----|-------|
| **Server** | Data fetching, static | None |
| **Client** | Interactivity | useState, effects |
| **Presentational** | UI display | Props only |
| **Container** | Logic/state | Heavy state |

#### Design Rules

- One responsibility per component
- Props down, events up
- Composition over inheritance
- Prefer small, focused components


### 2. Hook Patterns

#### When to Extract Hooks

| Pattern | Extract When |
|---------|-------------|
| **useLocalStorage** | Same storage logic needed |
| **useDebounce** | Multiple debounced values |
| **useFetch** | Repeated fetch patterns |
| **useForm** | Complex form state |

#### Hook Rules

- Hooks at top level only
- Same order every render
- Custom hooks start with "use"
- Clean up effects on unmount


### 3. State Management Selection

| Complexity | Solution |
|------------|----------|
| Simple | useState, useReducer |
| Shared local | Context |
| Server state | React Query, SWR |
| Complex global | Zustand, Redux Toolkit |

#### State Placement

| Scope | Where |
|-------|-------|
| Single component | useState |
| Parent-child | Lift state up |
| Subtree | Context |
| App-wide | Global store |


### 4. React 19 Patterns

#### New Hooks

| Hook | Purpose |
|------|---------|
| **useActionState** | Form submission state |
| **useOptimistic** | Optimistic UI updates |
| **use** | Read resources in render |

#### Compiler Benefits

- Automatic memoization
- Less manual useMemo/useCallback
- Focus on pure components


### 5. Composition Patterns

#### Compound Components

- Parent provides context
- Children consume context
- Flexible slot-based composition
- Example: Tabs, Accordion, Dropdown

#### Render Props vs Hooks

| Use Case | Prefer |
|----------|--------|
| Reusable logic | Custom hook |
| Render flexibility | Render props |
| Cross-cutting | Higher-order component |


### 6. TypeScript Patterns

#### Props Typing

| Pattern | Use |
|---------|-----|
| Interface | Component props |
| Type | Unions, complex |
| Generic | Reusable components |

#### Common Types

| Need | Type |
|------|------|
| Children | ReactNode |
| Event handler | MouseEventHandler |
| Ref | RefObject<Element> |


### 7. Testing Principles

| Level | Focus |
|-------|-------|
| Unit | Pure functions, hooks |
| Integration | Component behavior |
| E2E | User flows |

#### Test Priorities

- User-visible behavior
- Edge cases
- Error states
- Accessibility


## Part 2: UI States & Data Handling

### Core Principles

1. **Never show stale UI** - Loading spinners only when actually loading
2. **Always surface errors** - Users must know when something fails
3. **Optimistic updates** - Make the UI feel instant
4. **Progressive disclosure** - Show content as it becomes available
5. **Graceful degradation** - Partial data is better than no data

### Loading State Patterns

#### The Golden Rule

**Show loading indicator ONLY when there's no data to display.**

```typescript
// CORRECT - Only show loading when no data exists
const { data, loading, error } = useGetItemsQuery();

if (error) return <ErrorState error={error} onRetry={refetch} />;
if (loading && !data) return <LoadingState />;
if (!data?.items.length) return <EmptyState />;

return <ItemList items={data.items} />;
```

```typescript
// WRONG - Shows spinner even when we have cached data
if (loading) return <LoadingState />; // Flashes on refetch!
```

#### Loading State Decision Tree

```
Is there an error?
  -> Yes: Show error state with retry option
  -> No: Continue

Is it loading AND we have no data?
  -> Yes: Show loading indicator (spinner/skeleton)
  -> No: Continue

Do we have data?
  -> Yes, with items: Show the data
  -> Yes, but empty: Show empty state
  -> No: Show loading (fallback)
```

#### Skeleton vs Spinner

| Use Skeleton When | Use Spinner When |
|-------------------|------------------|
| Known content shape | Unknown content shape |
| List/card layouts | Modal actions |
| Initial page load | Button submissions |
| Content placeholders | Inline operations |

### Error Handling Patterns

#### The Error Handling Hierarchy

```
1. Inline error (field-level) -> Form validation errors
2. Toast notification -> Recoverable errors, user can retry
3. Error banner -> Page-level errors, data still partially usable
4. Full error screen -> Unrecoverable, needs user action
```

#### Always Show Errors

**CRITICAL: Never swallow errors silently.**

```typescript
// CORRECT - Error always surfaced to user
const [createItem, { loading }] = useCreateItemMutation({
  onCompleted: () => {
    toast.success({ title: 'Item created' });
  },
  onError: (error) => {
    console.error('createItem failed:', error);
    toast.error({ title: 'Failed to create item' });
  },
});

// WRONG - Error silently caught, user has no idea
const [createItem] = useCreateItemMutation({
  onError: (error) => {
    console.error(error); // User sees nothing!
  },
});
```

#### Error State Component Pattern

```typescript
interface ErrorStateProps {
  error: Error;
  onRetry?: () => void;
  title?: string;
}

const ErrorState = ({ error, onRetry, title }: ErrorStateProps) => (
  <div className="error-state">
    <Icon name="exclamation-circle" />
    <h3>{title ?? 'Something went wrong'}</h3>
    <p>{error.message}</p>
    {onRetry && (
      <Button onClick={onRetry}>Try Again</Button>
    )}
  </div>
);
```

#### Error Boundary Usage

| Scope | Placement |
|-------|-----------|
| App-wide | Root level |
| Feature | Route/feature level |
| Component | Around risky component |

#### Error Recovery

- Show fallback UI
- Log error
- Offer retry option
- Preserve user data

### Button State Patterns

#### Button Loading State

```tsx
<Button
  onClick={handleSubmit}
  isLoading={isSubmitting}
  disabled={!isValid || isSubmitting}
>
  Submit
</Button>
```

#### Disable During Operations

**CRITICAL: Always disable triggers during async operations.**

```tsx
// CORRECT - Button disabled while loading
<Button
  disabled={isSubmitting}
  isLoading={isSubmitting}
  onClick={handleSubmit}
>
  Submit
</Button>

// WRONG - User can tap multiple times
<Button onClick={handleSubmit}>
  {isSubmitting ? 'Submitting...' : 'Submit'}
</Button>
```

### Empty States

#### Empty State Requirements

Every list/collection MUST have an empty state:

```tsx
// WRONG - No empty state
return <FlatList data={items} />;

// CORRECT - Explicit empty state
return (
  <FlatList
    data={items}
    ListEmptyComponent={<EmptyState />}
  />
);
```

#### Contextual Empty States

```tsx
// Search with no results
<EmptyState
  icon="search"
  title="No results found"
  description="Try different search terms"
/>

// List with no items yet
<EmptyState
  icon="plus-circle"
  title="No items yet"
  description="Create your first item"
  action={{ label: 'Create Item', onClick: handleCreate }}
/>
```

### Form Submission Pattern

```tsx
const MyForm = () => {
  const [submit, { loading }] = useSubmitMutation({
    onCompleted: handleSuccess,
    onError: handleError,
  });

  const handleSubmit = async () => {
    if (!isValid) {
      toast.error({ title: 'Please fix errors' });
      return;
    }
    await submit({ variables: { input: values } });
  };

  return (
    <form>
      <Input
        value={values.name}
        onChange={handleChange('name')}
        error={touched.name ? errors.name : undefined}
      />
      <Button
        type="submit"
        onClick={handleSubmit}
        disabled={!isValid || loading}
        isLoading={loading}
      >
        Submit
      </Button>
    </form>
  );
};
```


## Part 3: Anti-Patterns

### Architecture Anti-Patterns

| Don't | Do |
|-------|-----|
| Prop drilling deep | Use context |
| Giant components | Split smaller |
| useEffect for everything | Server components |
| Premature optimization | Profile first |
| Index as key | Stable unique ID |

### UI State Anti-Patterns

```typescript
// WRONG - Spinner when data exists (causes flash)
if (loading) return <Spinner />;

// CORRECT - Only show loading without data
if (loading && !data) return <Spinner />;
```

```typescript
// WRONG - Error swallowed
try {
  await mutation();
} catch (e) {
  console.log(e); // User has no idea!
}

// CORRECT - Error surfaced
onError: (error) => {
  console.error('operation failed:', error);
  toast.error({ title: 'Operation failed' });
}
```

```typescript
// WRONG - Button not disabled during submission
<Button onClick={submit}>Submit</Button>

// CORRECT - Disabled and shows loading
<Button onClick={submit} disabled={loading} isLoading={loading}>
  Submit
</Button>
```

### React Slop Patterns (PROHIBITED)

#### Component Patterns

```tsx
// NEVER - "use client" everywhere
"use client"; // Only when actually needed!

// NEVER - Div with onClick (accessibility violation)
<div onClick={handleClick}>Click me</div>
// ALWAYS - Semantic button element
<button onClick={handleClick}>Click me</button>

// NEVER - Missing loading/error states
{data && <List items={data} />}
// ALWAYS - Handle all states
<DataDisplay data={data} isLoading={isLoading} error={error}>
  {(items) => <List items={items} />}
</DataDisplay>

// NEVER - Index as key for dynamic lists
{items.map((item, i) => <Item key={i} />)}
// ALWAYS - Stable unique key
{items.map((item) => <Item key={item.id} />)}

// NEVER - Inline objects/functions in JSX (causes re-renders)
<Component style={{ padding: 16 }} onClick={() => doThing(id)} />
// ALWAYS - Stable references
<Component style={styles} onClick={handleClick} />
```

#### Data Fetching Patterns

```tsx
// NEVER - Sequential fetches when parallel possible
const user = await getUser();
const posts = await getPosts(user.id);
// ALWAYS - Parallel when independent
const [user, settings] = await Promise.all([getUser(), getSettings()]);

// NEVER - Prop drilling through many levels
<App user={user}>
  <Layout user={user}>
    <Sidebar user={user}>
      <UserAvatar user={user} />
// ALWAYS - Context or composition
<UserProvider value={user}>
  <App>
    <Layout>
      <Sidebar>
        <UserAvatar /> {/* Uses context */}
```

#### Optimization Patterns

```tsx
// NEVER - Memoizing everything
const value = useMemo(() => x + 1, [x]); // Simple math, not needed
// ONLY - Memoize expensive operations
const sorted = useMemo(() => items.sort(complexSort), [items]);

// NEVER - useEffect for everything
useEffect(() => {
  setDerivedValue(items.filter(x => x.active));
}, [items]);
// ALWAYS - Derive from existing state
const derivedValue = items.filter(x => x.active);
```


## Part 4: Implementation Checklist

Before completing any UI component:

**UI States:**
- [ ] Error state handled and shown to user
- [ ] Loading state shown only when no data exists
- [ ] Empty state provided for collections
- [ ] Buttons disabled during async operations
- [ ] Buttons show loading indicator when appropriate

**Data & Mutations:**
- [ ] Mutations have onError handler
- [ ] All user actions have feedback (toast/visual)

## Integration with Other Skills

- **graphql-schema**: Use mutation patterns with proper error handling
- **testing-patterns**: Test all UI states (loading, error, empty, success)
- **formik-patterns**: Apply form submission patterns
- **react-performance-optimization**: Apply Vercel performance rules
