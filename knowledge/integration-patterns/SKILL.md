---
name: integration-patterns
description: |
  Implement integration patterns for connecting services and components.
---

  Use when: (1) Building Wave 6 integration layer,
  (2) Connecting frontend to backend APIs,
  (3) Implementing service-to-service communication,
  (4) Setting up message queues and event systems,
  (5) Building end-to-end data flows.

# Integration Patterns

Service integration and communication patterns.

## Overview

This skill provides:
- API integration patterns
- Service communication patterns
- Message queue patterns
- Event-driven patterns
- Data synchronization

## API Client Patterns

### Typed API Client
```typescript
// api/client.ts
class ApiClient {
  constructor(private baseUrl: string) {}

  private async request<T>(
    method: string,
    path: string,
    options?: RequestInit
  ): Promise<T> {
    const response = await fetch(`${this.baseUrl}${path}`, {
      method,
      headers: {
        'Content-Type': 'application/json',
        ...options?.headers,
      },
      ...options,
    });

    if (!response.ok) {
      const error = await response.json();
      throw new ApiError(error.code, error.message, response.status);
    }

    return response.json();
  }

  get<T>(path: string) {
    return this.request<T>('GET', path);
  }

  post<T>(path: string, data: unknown) {
    return this.request<T>('POST', path, { body: JSON.stringify(data) });
  }

  put<T>(path: string, data: unknown) {
    return this.request<T>('PUT', path, { body: JSON.stringify(data) });
  }

  delete<T>(path: string) {
    return this.request<T>('DELETE', path);
  }
}

// api/users.ts
export const usersApi = {
  list: () => client.get<User[]>('/users'),
  get: (id: string) => client.get<User>(`/users/${id}`),
  create: (data: CreateUserDto) => client.post<User>('/users', data),
  update: (id: string, data: UpdateUserDto) => client.put<User>(`/users/${id}`, data),
  delete: (id: string) => client.delete<void>(`/users/${id}`),
};
```

### Request Interceptors
```typescript
// Add auth token
api.interceptors.request.use((config) => {
  const token = getAuthToken();
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Handle token refresh
api.interceptors.response.use(
  (response) => response,
  async (error) => {
    if (error.response?.status === 401) {
      const newToken = await refreshToken();
      error.config.headers.Authorization = `Bearer ${newToken}`;
      return api.request(error.config);
    }
    throw error;
  }
);
```

## Service Communication Patterns

### Request-Response (Sync)
```typescript
// Direct HTTP call
async function getUserOrders(userId: string): Promise<Order[]> {
  const orders = await ordersService.getByUserId(userId);
  return orders;
}
```

### Async with Message Queue
```typescript
// Producer
async function createOrder(order: CreateOrderDto) {
  const created = await ordersRepository.create(order);

  // Publish event for async processing
  await messageQueue.publish('orders.created', {
    orderId: created.id,
    userId: order.userId,
    items: order.items,
  });

  return created;
}

// Consumer
messageQueue.subscribe('orders.created', async (message) => {
  const { orderId, userId, items } = message.data;

  // Process asynchronously
  await inventoryService.reserveItems(items);
  await notificationService.sendOrderConfirmation(userId, orderId);
  await analyticsService.trackOrder(orderId);
});
```

### Event Sourcing
```typescript
// Event store
interface Event {
  type: string;
  aggregateId: string;
  data: unknown;
  timestamp: Date;
  version: number;
}

class OrderAggregate {
  private events: Event[] = [];

  apply(event: Event) {
    this.events.push(event);

    switch (event.type) {
      case 'OrderCreated':
        this.status = 'pending';
        break;
      case 'OrderPaid':
        this.status = 'paid';
        break;
      case 'OrderShipped':
        this.status = 'shipped';
        break;
    }
  }

  createOrder(data: CreateOrderDto) {
    this.apply({
      type: 'OrderCreated',
      aggregateId: this.id,
      data,
      timestamp: new Date(),
      version: this.events.length + 1,
    });
  }
}
```

## Frontend-Backend Integration

### Data Fetching Layer
```typescript
// hooks/useUsers.ts
export function useUsers() {
  return useQuery({
    queryKey: ['users'],
    queryFn: usersApi.list,
  });
}

export function useUser(id: string) {
  return useQuery({
    queryKey: ['users', id],
    queryFn: () => usersApi.get(id),
    enabled: !!id,
  });
}

export function useCreateUser() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: usersApi.create,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] });
    },
  });
}
```

### Real-time Updates (WebSocket)
```typescript
// hooks/useRealtimeOrders.ts
export function useRealtimeOrders(userId: string) {
  const queryClient = useQueryClient();

  useEffect(() => {
    const ws = new WebSocket(`${WS_URL}/orders?userId=${userId}`);

    ws.onmessage = (event) => {
      const update = JSON.parse(event.data);

      switch (update.type) {
        case 'ORDER_CREATED':
          queryClient.setQueryData(['orders', userId], (old: Order[]) =>
            [...old, update.order]
          );
          break;
        case 'ORDER_UPDATED':
          queryClient.setQueryData(['orders', userId], (old: Order[]) =>
            old.map(o => o.id === update.order.id ? update.order : o)
          );
          break;
      }
    };

    return () => ws.close();
  }, [userId, queryClient]);
}
```

## Data Synchronization Patterns

### Optimistic Updates
```typescript
const mutation = useMutation({
  mutationFn: updateTodo,
  onMutate: async (newTodo) => {
    await queryClient.cancelQueries({ queryKey: ['todos'] });
    const previous = queryClient.getQueryData(['todos']);
    queryClient.setQueryData(['todos'], (old) =>
      old.map(t => t.id === newTodo.id ? newTodo : t)
    );
    return { previous };
  },
  onError: (err, newTodo, context) => {
    queryClient.setQueryData(['todos'], context.previous);
  },
});
```

### Conflict Resolution
```typescript
interface VersionedEntity {
  id: string;
  version: number;
  updatedAt: Date;
}

async function updateWithConflictResolution<T extends VersionedEntity>(
  entity: T,
  update: Partial<T>
): Promise<T> {
  try {
    return await api.put(`/entities/${entity.id}`, {
      ...update,
      version: entity.version,
    });
  } catch (error) {
    if (error.code === 'VERSION_CONFLICT') {
      // Fetch latest and let user resolve
      const latest = await api.get(`/entities/${entity.id}`);
      throw new ConflictError(entity, latest, update);
    }
    throw error;
  }
}
```

## Integration Testing

```typescript
describe('Order Integration', () => {
  it('should create order and update inventory', async () => {
    // Arrange
    const product = await createTestProduct({ stock: 10 });

    // Act
    const order = await ordersApi.create({
      items: [{ productId: product.id, quantity: 2 }],
    });

    // Assert - order created
    expect(order.status).toBe('pending');

    // Assert - inventory updated (async, may need polling)
    await waitFor(async () => {
      const updatedProduct = await productsApi.get(product.id);
      expect(updatedProduct.stock).toBe(8);
    });
  });
});
```

## Integration Checklist

For Wave 6, verify:
- [ ] API clients typed and tested
- [ ] Error handling for all API calls
- [ ] Auth token handling implemented
- [ ] Real-time updates working (if applicable)
- [ ] Optimistic updates for mutations
- [ ] Integration tests passing
- [ ] E2E flows verified
