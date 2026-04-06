---
name: navigation-flow
description: |
  Analyze user navigation paths and information architecture for efficiency.
---

  Use when: (1) Phase T3 requires navigation mapping, (2) documenting all screens and
  page states, (3) identifying dead ends and circular navigation, (4) evaluating
  discoverability of features, (5) ensuring users can recover and return to previous
  states, (6) mapping optimal paths from entry points to user goals.

# Navigation Flow Analysis

Systematic analysis of how users navigate through an application. Identifies optimal paths, dead ends, and improvement opportunities.

## Navigation Mapping

### Step 1: Identify Entry Points
Document all ways users enter the application:
- Direct URL access
- Search engine results
- External links
- Deep links
- Bookmarks

### Step 2: Map All Screens/Pages
Create inventory of:
- Every unique screen
- Every unique page state
- Every modal/dialog
- Every overlay

### Step 3: Document Transitions
For each screen, record:
- What screens can be reached from here?
- What actions trigger transitions?
- Are transitions intuitive?

## Navigation Flow Diagram

```
Entry Points
     │
     ▼
┌─────────────┐
│   Home      │──────┬──────────────────────┐
└─────────────┘      │                      │
     │               ▼                      ▼
     ▼         ┌──────────┐          ┌──────────┐
┌─────────┐    │ Feature A │          │ Feature B │
│ Search  │    └──────────┘          └──────────┘
└─────────┘         │                      │
     │              ▼                      ▼
     └─────────► [Goal]  ◄─────────────────┘
```

## Flow Analysis Criteria

### Efficiency
- Minimum clicks to goal
- Logical progression
- No unnecessary steps

### Discoverability
- Features findable
- Labels clear
- Navigation consistent

### Recoverability
- Back navigation works
- Breadcrumbs present
- State preserved

### Orientation
- User knows where they are
- User knows where they can go
- User knows how to get back

## Common Navigation Problems

### Dead Ends
Screens with no clear next action:
- [ ] All screens have clear next steps
- [ ] Exit paths are obvious
- [ ] Goals are achievable from any screen

### Circular Navigation
Users looping without progress:
- [ ] Progress indicators present
- [ ] Steps don't repeat unnecessarily
- [ ] Clear completion state

### Hidden Features
Important functions hard to find:
- [ ] Primary actions prominent
- [ ] Search finds features
- [ ] Help guides users

### Broken Flows
Paths that fail:
- [ ] All links work
- [ ] All buttons respond
- [ ] Errors don't trap users

## Flow Documentation Template

```markdown
## User Flow: [Name]

### Goal
[What the user wants to accomplish]

### Entry Point
[How user starts this flow]

### Steps
1. [Screen] → [Action] → [Next Screen]
2. [Screen] → [Action] → [Next Screen]
3. ...

### Exit Points
- Success: [Outcome]
- Cancel: [Return to]
- Error: [Recovery path]

### Issues Found
- [Issue description]

### Recommendations
- [Improvement suggestion]
```

## References

For detailed analysis:
- See `references/navigation-patterns.md` for common patterns
- See `references/flow-diagram-examples.md` for diagram examples
