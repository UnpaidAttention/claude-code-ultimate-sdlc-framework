---
name: component-patterns
description: Covers UI component design patterns including composition, props design, state management, and testing strategies. Use when building UI components during Wave 5, designing component architecture, reviewing frontend code, establishing component library patterns, or refactoring complex components.
---

# Component Patterns

> Build maintainable, reusable, and testable UI components through proven patterns and principled design.


## Core Principles

| Principle | Rule |
|-----------|------|
| **Single Responsibility** | One component, one purpose |
| **Composition Over Inheritance** | Combine small components; avoid deep hierarchies |
| **Props Down, Events Up** | Data flows down, actions bubble up |
| **Explicit Dependencies** | All inputs visible in props; no hidden magic |
| **Colocation** | Keep related code together |
| **Accessibility First** | Semantic HTML, ARIA, keyboard navigation |


## When to Use

- Building UI components (Wave 5)
- Designing component architecture
- Reviewing frontend code
- Establishing component library patterns
- Refactoring complex components
- Creating design system components


## Component Composition Patterns

### Compound Components

Components that work together to form a complete UI unit.

```tsx
// Compound component pattern
const Tabs = ({ children, defaultTab }) => {
  const [activeTab, setActiveTab] = useState(defaultTab);
  return (
    <TabsContext.Provider value={{ activeTab, setActiveTab }}>
      <div className="tabs">{children}</div>
    </TabsContext.Provider>
  );
};

Tabs.List = ({ children }) => (
  <div role="tablist" className="tabs-list">{children}</div>
);

Tabs.Tab = ({ id, children }) => {
  const { activeTab, setActiveTab } = useTabsContext();
  return (
    <button
      role="tab"
      aria-selected={activeTab === id}
      onClick={() => setActiveTab(id)}
    >
      {children}
    </button>
  );
};

Tabs.Panel = ({ id, children }) => {
  const { activeTab } = useTabsContext();
  if (activeTab !== id) return null;
  return <div role="tabpanel">{children}</div>;
};

// Usage
<Tabs defaultTab="overview">
  <Tabs.List>
    <Tabs.Tab id="overview">Overview</Tabs.Tab>
    <Tabs.Tab id="details">Details</Tabs.Tab>
  </Tabs.List>
  <Tabs.Panel id="overview">Overview content</Tabs.Panel>
  <Tabs.Panel id="details">Details content</Tabs.Panel>
</Tabs>
```

### Render Props

Delegate rendering control to parent.

```tsx
// Render props pattern
interface MouseTrackerProps {
  render: (position: { x: number; y: number }) => ReactNode;
}

const MouseTracker = ({ render }: MouseTrackerProps) => {
  const [position, setPosition] = useState({ x: 0, y: 0 });

  const handleMouseMove = (e: MouseEvent) => {
    setPosition({ x: e.clientX, y: e.clientY });
  };

  return (
    <div onMouseMove={handleMouseMove}>
      {render(position)}
    </div>
  );
};

// Usage
<MouseTracker
  render={({ x, y }) => (
    <span>Mouse is at ({x}, {y})</span>
  )}
/>
```

### Slots Pattern

Named content areas for flexible composition.

```tsx
// Slots pattern
interface CardProps {
  header?: ReactNode;
  footer?: ReactNode;
  children: ReactNode;
}

const Card = ({ header, footer, children }: CardProps) => (
  <div className="card">
    {header && <div className="card-header">{header}</div>}
    <div className="card-body">{children}</div>
    {footer && <div className="card-footer">{footer}</div>}
  </div>
);

// Usage
<Card
  header={<h2>Title</h2>}
  footer={<Button>Action</Button>}
>
  <p>Card content goes here</p>
</Card>
```

### Higher-Order Components (HOC)

Enhance components with additional behavior.

```tsx
// HOC pattern
function withLoading<P>(WrappedComponent: ComponentType<P>) {
  return function WithLoading({ isLoading, ...props }: P & { isLoading: boolean }) {
    if (isLoading) return <LoadingSpinner />;
    return <WrappedComponent {...(props as P)} />;
  };
}

// Usage
const UserListWithLoading = withLoading(UserList);
<UserListWithLoading isLoading={loading} users={users} />
```

### Provider Pattern

Share state across component tree without prop drilling.

```tsx
// Provider pattern
const ThemeContext = createContext<ThemeContextType | null>(null);

export const ThemeProvider = ({ children }: { children: ReactNode }) => {
  const [theme, setTheme] = useState<'light' | 'dark'>('light');

  const toggleTheme = () => {
    setTheme(prev => prev === 'light' ? 'dark' : 'light');
  };

  return (
    <ThemeContext.Provider value={{ theme, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  );
};

export const useTheme = () => {
  const context = useContext(ThemeContext);
  if (!context) {
    throw new Error('useTheme must be used within ThemeProvider');
  }
  return context;
};
```


## Props Design Guidelines

### Props Interface Design

```tsx
// Well-designed props interface
interface ButtonProps {
  // Required props first
  children: ReactNode;

  // Variant props (use unions, not booleans)
  variant: 'primary' | 'secondary' | 'ghost' | 'danger';
  size: 'sm' | 'md' | 'lg';

  // Optional behavior props
  disabled?: boolean;
  loading?: boolean;
  fullWidth?: boolean;

  // Event handlers
  onClick?: (event: MouseEvent<HTMLButtonElement>) => void;

  // Escape hatch for HTML attributes
  className?: string;
  'aria-label'?: string;
}

// Default props
const defaultProps: Partial<ButtonProps> = {
  variant: 'primary',
  size: 'md',
  disabled: false,
  loading: false,
  fullWidth: false,
};
```

### Props Categories

| Category | Examples | Guidelines |
|----------|----------|------------|
| **Data** | `user`, `items`, `value` | Typed, validated |
| **Variant** | `size`, `variant`, `color` | Union types |
| **Behavior** | `disabled`, `loading` | Boolean flags |
| **Events** | `onClick`, `onChange` | Consistent naming |
| **Content** | `children`, `label`, `icon` | Flexible types |
| **Style** | `className`, `style` | Escape hatches |

### Props Anti-Patterns

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| Boolean variants | `<Button primary secondary />` | Union type: `variant="primary"` |
| Too many props | 15+ props | Split component |
| Prop drilling | Passing through 5+ levels | Context or composition |
| Exposing internals | `_internalState` | Keep private |
| Any types | `data: any` | Proper typing |

### Prop Spreading Safely

```tsx
// Safe prop spreading with explicit types
interface InputProps extends Omit<InputHTMLAttributes<HTMLInputElement>, 'size'> {
  label: string;
  error?: string;
  size?: 'sm' | 'md' | 'lg';
}

const Input = ({ label, error, size = 'md', className, ...props }: InputProps) => (
  <div className={cn('input-wrapper', `input-${size}`, className)}>
    <label>{label}</label>
    <input {...props} aria-invalid={!!error} />
    {error && <span className="error">{error}</span>}
  </div>
);
```


## State Management Patterns

### State Categories

| Type | Location | Examples |
|------|----------|----------|
| **UI State** | Local (useState) | Open/closed, hover, focus |
| **Form State** | Local or form library | Input values, validation |
| **Server State** | TanStack Query, SWR | API data, loading, error |
| **App State** | Context/Store | Auth, theme, settings |
| **URL State** | Router | Filters, pagination |

### Local State Pattern

```tsx
// Simple local state
const Toggle = () => {
  const [isOpen, setIsOpen] = useState(false);
  return (
    <button onClick={() => setIsOpen(!isOpen)}>
      {isOpen ? 'Close' : 'Open'}
    </button>
  );
};
```

### Reducer Pattern (Complex State)

```tsx
// Reducer for complex state logic
interface FormState {
  values: Record<string, string>;
  errors: Record<string, string>;
  touched: Record<string, boolean>;
  isSubmitting: boolean;
}

type FormAction =
  | { type: 'SET_FIELD'; field: string; value: string }
  | { type: 'SET_ERROR'; field: string; error: string }
  | { type: 'TOUCH_FIELD'; field: string }
  | { type: 'SUBMIT_START' }
  | { type: 'SUBMIT_END' }
  | { type: 'RESET' };

const formReducer = (state: FormState, action: FormAction): FormState => {
  switch (action.type) {
    case 'SET_FIELD':
      return {
        ...state,
        values: { ...state.values, [action.field]: action.value },
      };
    case 'SET_ERROR':
      return {
        ...state,
        errors: { ...state.errors, [action.field]: action.error },
      };
    // ... other cases
    default:
      return state;
  }
};
```

### Lifting State Up

```tsx
// Parent manages shared state
const FilterableList = () => {
  const [filter, setFilter] = useState('');
  const [items, setItems] = useState<Item[]>([]);

  const filteredItems = items.filter(item =>
    item.name.toLowerCase().includes(filter.toLowerCase())
  );

  return (
    <div>
      <SearchInput value={filter} onChange={setFilter} />
      <ItemList items={filteredItems} />
    </div>
  );
};
```

### Derived State (Don't Store What You Can Compute)

```tsx
// Bad: storing derived state
const [items, setItems] = useState([]);
const [filteredItems, setFilteredItems] = useState([]); // Don't do this

// Good: compute derived values
const [items, setItems] = useState([]);
const [filter, setFilter] = useState('');
const filteredItems = useMemo(
  () => items.filter(item => item.includes(filter)),
  [items, filter]
);
```


## Component Lifecycle Patterns

### Mounting Pattern

```tsx
// Data fetching on mount
const UserProfile = ({ userId }: { userId: string }) => {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    let cancelled = false;

    const fetchUser = async () => {
      try {
        setLoading(true);
        const data = await api.getUser(userId);
        if (!cancelled) {
          setUser(data);
        }
      } catch (e) {
        if (!cancelled) {
          setError(e as Error);
        }
      } finally {
        if (!cancelled) {
          setLoading(false);
        }
      }
    };

    fetchUser();

    return () => {
      cancelled = true;
    };
  }, [userId]);

  if (loading) return <Skeleton />;
  if (error) return <ErrorMessage error={error} />;
  if (!user) return null;

  return <UserCard user={user} />;
};
```

### Cleanup Pattern

```tsx
// Proper cleanup for subscriptions and timers
const RealTimeData = () => {
  const [data, setData] = useState(null);

  useEffect(() => {
    // Subscribe
    const subscription = dataStream.subscribe(setData);

    // Cleanup function
    return () => {
      subscription.unsubscribe();
    };
  }, []);

  useEffect(() => {
    // Timer with cleanup
    const timer = setInterval(() => {
      console.log('tick');
    }, 1000);

    return () => {
      clearInterval(timer);
    };
  }, []);

  return <Display data={data} />;
};
```

### Event Listener Pattern

```tsx
// Window/document event listeners
const useWindowSize = () => {
  const [size, setSize] = useState({
    width: window.innerWidth,
    height: window.innerHeight,
  });

  useEffect(() => {
    const handleResize = () => {
      setSize({
        width: window.innerWidth,
        height: window.innerHeight,
      });
    };

    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, []);

  return size;
};
```


## Reusability Patterns

### Headless Components

Logic without UI; consumer provides rendering.

```tsx
// Headless dropdown
interface UseDropdownReturn {
  isOpen: boolean;
  selectedItem: string | null;
  highlightedIndex: number;
  getToggleProps: () => ButtonHTMLAttributes<HTMLButtonElement>;
  getMenuProps: () => HTMLAttributes<HTMLUListElement>;
  getItemProps: (index: number) => LiHTMLAttributes<HTMLLIElement>;
}

const useDropdown = (items: string[]): UseDropdownReturn => {
  const [isOpen, setIsOpen] = useState(false);
  const [selectedItem, setSelectedItem] = useState<string | null>(null);
  const [highlightedIndex, setHighlightedIndex] = useState(0);

  const getToggleProps = () => ({
    onClick: () => setIsOpen(!isOpen),
    'aria-expanded': isOpen,
    'aria-haspopup': 'listbox' as const,
  });

  const getMenuProps = () => ({
    role: 'listbox' as const,
    'aria-hidden': !isOpen,
  });

  const getItemProps = (index: number) => ({
    role: 'option' as const,
    'aria-selected': items[index] === selectedItem,
    onClick: () => {
      setSelectedItem(items[index]);
      setIsOpen(false);
    },
    onMouseEnter: () => setHighlightedIndex(index),
  });

  return {
    isOpen,
    selectedItem,
    highlightedIndex,
    getToggleProps,
    getMenuProps,
    getItemProps,
  };
};
```

### Polymorphic Components

Components that can render as different elements.

```tsx
// Polymorphic "as" prop pattern
type BoxProps<E extends ElementType> = {
  as?: E;
  children: ReactNode;
} & Omit<ComponentPropsWithoutRef<E>, 'as' | 'children'>;

const Box = <E extends ElementType = 'div'>({
  as,
  children,
  ...props
}: BoxProps<E>) => {
  const Component = as || 'div';
  return <Component {...props}>{children}</Component>;
};

// Usage
<Box>Default div</Box>
<Box as="section">Renders as section</Box>
<Box as="a" href="/home">Renders as link</Box>
<Box as={CustomComponent} customProp="value">Custom component</Box>
```

### Controlled vs Uncontrolled

```tsx
// Support both controlled and uncontrolled usage
interface InputProps {
  value?: string;
  defaultValue?: string;
  onChange?: (value: string) => void;
}

const Input = ({ value, defaultValue, onChange }: InputProps) => {
  // Internal state for uncontrolled mode
  const [internalValue, setInternalValue] = useState(defaultValue ?? '');

  // Use external value if controlled
  const isControlled = value !== undefined;
  const currentValue = isControlled ? value : internalValue;

  const handleChange = (e: ChangeEvent<HTMLInputElement>) => {
    const newValue = e.target.value;
    if (!isControlled) {
      setInternalValue(newValue);
    }
    onChange?.(newValue);
  };

  return <input value={currentValue} onChange={handleChange} />;
};

// Controlled usage
<Input value={name} onChange={setName} />

// Uncontrolled usage
<Input defaultValue="John" onChange={handleChange} />
```


## Testing Patterns for Components

### Unit Testing (Component Logic)

```tsx
// Testing with React Testing Library
import { render, screen, fireEvent } from '@testing-library/react';
import userEvent from '@testing-library/user-event';

describe('Button', () => {
  it('renders children', () => {
    render(<Button variant="primary">Click me</Button>);
    expect(screen.getByText('Click me')).toBeInTheDocument();
  });

  it('calls onClick when clicked', async () => {
    const handleClick = jest.fn();
    render(
      <Button variant="primary" onClick={handleClick}>
        Click me
      </Button>
    );

    await userEvent.click(screen.getByRole('button'));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });

  it('is disabled when disabled prop is true', () => {
    render(
      <Button variant="primary" disabled>
        Click me
      </Button>
    );
    expect(screen.getByRole('button')).toBeDisabled();
  });

  it('shows loading spinner when loading', () => {
    render(
      <Button variant="primary" loading>
        Click me
      </Button>
    );
    expect(screen.getByRole('button')).toHaveAttribute('aria-busy', 'true');
    expect(screen.getByTestId('spinner')).toBeInTheDocument();
  });
});
```

### Integration Testing (Component Interactions)

```tsx
// Testing compound components
describe('Tabs', () => {
  it('switches panels when tabs are clicked', async () => {
    render(
      <Tabs defaultTab="tab1">
        <Tabs.List>
          <Tabs.Tab id="tab1">Tab 1</Tabs.Tab>
          <Tabs.Tab id="tab2">Tab 2</Tabs.Tab>
        </Tabs.List>
        <Tabs.Panel id="tab1">Content 1</Tabs.Panel>
        <Tabs.Panel id="tab2">Content 2</Tabs.Panel>
      </Tabs>
    );

    // Initially shows first tab
    expect(screen.getByText('Content 1')).toBeInTheDocument();
    expect(screen.queryByText('Content 2')).not.toBeInTheDocument();

    // Click second tab
    await userEvent.click(screen.getByRole('tab', { name: 'Tab 2' }));

    // Shows second tab content
    expect(screen.queryByText('Content 1')).not.toBeInTheDocument();
    expect(screen.getByText('Content 2')).toBeInTheDocument();
  });
});
```

### Accessibility Testing

```tsx
// Testing accessibility
import { axe, toHaveNoViolations } from 'jest-axe';

expect.extend(toHaveNoViolations);

describe('Form accessibility', () => {
  it('has no accessibility violations', async () => {
    const { container } = render(
      <Form>
        <Input label="Email" name="email" type="email" />
        <Input label="Password" name="password" type="password" />
        <Button type="submit">Submit</Button>
      </Form>
    );

    const results = await axe(container);
    expect(results).toHaveNoViolations();
  });

  it('associates labels with inputs', () => {
    render(<Input label="Email" name="email" />);

    const input = screen.getByLabelText('Email');
    expect(input).toBeInTheDocument();
  });

  it('shows error messages with proper aria', () => {
    render(<Input label="Email" error="Invalid email" />);

    const input = screen.getByLabelText('Email');
    expect(input).toHaveAttribute('aria-invalid', 'true');
    expect(input).toHaveAccessibleDescription('Invalid email');
  });
});
```

### Snapshot Testing (Use Sparingly)

```tsx
// Snapshot for stable UI components
describe('Icon', () => {
  it('renders correctly', () => {
    const { container } = render(<Icon name="check" size="md" />);
    expect(container).toMatchSnapshot();
  });
});
```

### Custom Hook Testing

```tsx
// Testing custom hooks
import { renderHook, act } from '@testing-library/react';

describe('useCounter', () => {
  it('initializes with default value', () => {
    const { result } = renderHook(() => useCounter(10));
    expect(result.current.count).toBe(10);
  });

  it('increments count', () => {
    const { result } = renderHook(() => useCounter(0));

    act(() => {
      result.current.increment();
    });

    expect(result.current.count).toBe(1);
  });
});
```


## Component Types Reference

| Type | Purpose | State | Example |
|------|---------|-------|---------|
| **Presentational** | Display data | None/minimal | `UserAvatar`, `Badge` |
| **Container** | Data/logic | Complex | `UserProfileContainer` |
| **Layout** | Structure | None | `Grid`, `Stack`, `Sidebar` |
| **Compound** | Multi-part UI | Shared context | `Tabs`, `Accordion` |
| **Controlled** | External state | Props only | `<Input value={} />` |
| **Uncontrolled** | Internal state | Local | `<Input defaultValue={} />` |
| **Headless** | Logic only | Yes | `useDropdown` |
| **Polymorphic** | Flexible element | Varies | `<Box as="section">` |


## Accessibility Checklist

| Requirement | Implementation |
|-------------|---------------|
| Semantic HTML | Use `<button>`, `<nav>`, `<main>`, etc. |
| ARIA labels | `aria-label`, `aria-labelledby` for icons/custom controls |
| Keyboard navigation | Tab order, Enter/Space activation, arrow keys |
| Focus management | Visible focus, focus trap for modals |
| Color contrast | 4.5:1 for normal text, 3:1 for large text |
| Screen reader | Hidden text, live regions for updates |
| Reduced motion | `prefers-reduced-motion` media query |


## Quality Checks

| Check | Question |
|-------|----------|
| **Responsibility** | Does this component do one thing well? |
| **Reusability** | Can this be used in multiple contexts? |
| **Props** | Are props minimal, typed, and well-named? |
| **State** | Is state at the right level? |
| **Accessibility** | Is it keyboard accessible? Screen reader friendly? |
| **Testing** | Are key behaviors covered by tests? |


## Anti-Patterns

| Pattern | Problem | Fix |
|---------|---------|-----|
| God component | 500+ lines, does everything | Split into smaller components |
| Prop drilling | Props through 5+ levels | Use Context or composition |
| Boolean props for variants | `<Btn primary secondary />` | Union type: `variant="primary"` |
| useEffect for derived state | `useEffect(() => setX(compute(y)))` | `useMemo` or inline compute |
| Index as key | `{items.map((x, i) => <Item key={i} />)}` | Use stable unique ID |
| Inline function props | `onClick={() => handleClick(id)}` | Use `useCallback` or move outside |
| State for everything | Storing computed values | Derive from source of truth |
| Ignoring memo | Re-rendering unchanged data | `React.memo`, `useMemo` |


## Related Skills

- accessibility - Detailed a11y patterns
- state-management - App-level state
- testing-patterns - Comprehensive testing
- design-systems - Component library design
