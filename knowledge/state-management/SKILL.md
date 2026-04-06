---
name: state-management
description: |
  Implement frontend state management patterns and solutions.
---

  Use when: (1) Designing state architecture for Wave 5 UI work,
  (2) Choosing between local, shared, and server state,
  (3) Implementing React context, Redux, or other state solutions,
  (4) Managing async state and caching,
  (5) Optimizing re-renders and state updates.

# State Management

Frontend state management patterns and best practices.

## Overview

This skill provides:
- State categorization
- State solution selection
- Implementation patterns
- Performance optimization
- Testing strategies

## State Categories

| Category | Description | Examples | Solution |
|----------|-------------|----------|----------|
| **UI State** | Local component state | Open/closed, hover | useState |
| **Form State** | Form inputs, validation | Form fields, errors | React Hook Form |
| **Server State** | Remote data, caching | API responses | TanStack Query |
| **Global State** | App-wide shared state | User, theme | Context/Redux |
| **URL State** | Route parameters | Filters, pagination | Router |

## Decision Matrix

```
Is it used by multiple components?
├── No → useState/useReducer (local)
└── Yes → Is it server data?
    ├── Yes → TanStack Query / SWR
    └── No → Does it change frequently?
        ├── Yes → Zustand / Jotai
        └── No → React Context
```

## Local State (useState/useReducer)

### useState for Simple State
```typescript
function Counter() {
  const [count, setCount] = useState(0);

  return (
    <button onClick={() => setCount(c => c + 1)}>
      Count: {count}
    </button>
  );
}
```

### useReducer for Complex State
```typescript
type State = { count: number; step: number };
type Action =
  | { type: 'increment' }
  | { type: 'decrement' }
  | { type: 'setStep'; step: number };

function reducer(state: State, action: Action): State {
  switch (action.type) {
    case 'increment':
      return { ...state, count: state.count + state.step };
    case 'decrement':
      return { ...state, count: state.count - state.step };
    case 'setStep':
      return { ...state, step: action.step };
  }
}

function Counter() {
  const [state, dispatch] = useReducer(reducer, { count: 0, step: 1 });
  // ...
}
```

## Server State (TanStack Query)

### Basic Query
```typescript
function UserProfile({ userId }: { userId: string }) {
  const { data, isLoading, error } = useQuery({
    queryKey: ['user', userId],
    queryFn: () => fetchUser(userId),
    staleTime: 5 * 60 * 1000, // 5 minutes
  });

  if (isLoading) return <Spinner />;
  if (error) return <Error message={error.message} />;

  return <div>{data.name}</div>;
}
```

### Mutation with Optimistic Updates
```typescript
function UpdateUser() {
  const queryClient = useQueryClient();

  const mutation = useMutation({
    mutationFn: updateUser,
    onMutate: async (newUser) => {
      // Cancel outgoing refetches
      await queryClient.cancelQueries({ queryKey: ['user', newUser.id] });

      // Snapshot previous value
      const previousUser = queryClient.getQueryData(['user', newUser.id]);

      // Optimistically update
      queryClient.setQueryData(['user', newUser.id], newUser);

      return { previousUser };
    },
    onError: (err, newUser, context) => {
      // Rollback on error
      queryClient.setQueryData(['user', newUser.id], context.previousUser);
    },
    onSettled: () => {
      // Refetch after mutation
      queryClient.invalidateQueries({ queryKey: ['user'] });
    },
  });

  return (/* ... */);
}
```

## Global State (Context)

### Context with Reducer
```typescript
// context/auth.tsx
type AuthState = { user: User | null; isLoading: boolean };
type AuthAction =
  | { type: 'login'; user: User }
  | { type: 'logout' }
  | { type: 'setLoading'; isLoading: boolean };

const AuthContext = createContext<{
  state: AuthState;
  dispatch: Dispatch<AuthAction>;
} | null>(null);

function authReducer(state: AuthState, action: AuthAction): AuthState {
  switch (action.type) {
    case 'login':
      return { ...state, user: action.user, isLoading: false };
    case 'logout':
      return { ...state, user: null };
    case 'setLoading':
      return { ...state, isLoading: action.isLoading };
  }
}

export function AuthProvider({ children }: { children: ReactNode }) {
  const [state, dispatch] = useReducer(authReducer, {
    user: null,
    isLoading: true
  });

  return (
    <AuthContext.Provider value={{ state, dispatch }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) throw new Error('useAuth must be within AuthProvider');
  return context;
}
```

## Global State (Zustand)

```typescript
// stores/userStore.ts
interface UserStore {
  user: User | null;
  isLoading: boolean;
  login: (user: User) => void;
  logout: () => void;
  setLoading: (loading: boolean) => void;
}

export const useUserStore = create<UserStore>((set) => ({
  user: null,
  isLoading: false,
  login: (user) => set({ user, isLoading: false }),
  logout: () => set({ user: null }),
  setLoading: (isLoading) => set({ isLoading }),
}));

// Usage
function Header() {
  const user = useUserStore((state) => state.user);
  const logout = useUserStore((state) => state.logout);
  // ...
}
```

## Performance Optimization

### Preventing Unnecessary Re-renders

```typescript
// 1. Memoize expensive computations
const sortedItems = useMemo(
  () => items.sort((a, b) => a.name.localeCompare(b.name)),
  [items]
);

// 2. Memoize callbacks
const handleClick = useCallback((id: string) => {
  setSelected(id);
}, []);

// 3. Split context to reduce re-renders
const UserDataContext = createContext<User | null>(null);
const UserActionsContext = createContext<UserActions | null>(null);

// 4. Use selectors with Zustand
const userName = useUserStore((state) => state.user?.name);
```

## State Testing

```typescript
// Testing hooks
import { renderHook, act } from '@testing-library/react';

describe('useCounter', () => {
  it('should increment count', () => {
    const { result } = renderHook(() => useCounter());

    act(() => {
      result.current.increment();
    });

    expect(result.current.count).toBe(1);
  });
});

// Testing context
function renderWithAuth(ui: ReactElement, initialUser?: User) {
  return render(
    <AuthProvider initialUser={initialUser}>
      {ui}
    </AuthProvider>
  );
}
```

## State Management Checklist

For Wave 5 UI work, verify:
- [ ] State categories identified
- [ ] Appropriate solution for each category
- [ ] Server state using query library
- [ ] Global state minimized
- [ ] Re-render optimization applied
- [ ] State updates tested
