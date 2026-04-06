---
name: sdlc-dev-wave5-start
description: |
  Start Wave 5 UI development. Initializes wave context, discovers MCP servers,
  classifies AIOUs for model routing, and begins UI implementation.
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Agent
---

# Wave 5 Start — UI Development

Initialize Wave 5 UI development session. Sets up wave context, discovers available
MCP servers for UI generation, classifies AIOUs for optimal model routing, and
begins the UI implementation phase.

## Prerequisites
- Gate I4 must be PASSED (backend complete)
- UI Design Plan must exist (from `/sdlc-dev-ui-design-plan`)

## Steps
1. Read project context and planning handoff
2. Scan for UI-related AIOUs assigned to Wave 5
3. Discover available MCP servers (Stitch, shadcn/ui, Playwright, etc.)
4. Classify AIOUs for model routing (Opus for complex, Sonnet for standard)
5. Create `wave5-context.md` with classifications and MCP choices
6. Establish component architecture and accessibility baseline
7. Begin first AIOU implementation

### Agent: sdlc-frontend-specialist
Invoke via Agent tool with `subagent_type: "sdlc-frontend-specialist"`:
- **Provide**: Wave 5 AIOU list, ui-design-plan.md, design-system.md, route tree, component inventory
- **Request**: Design component architecture — shared layout components, state management strategy, routing structure, and reusable UI patterns
- **Apply**: Record architecture decisions in wave5-context.md before starting individual AIOUs

### Agent: sdlc-ux
Invoke via Agent tool with `subagent_type: "sdlc-ux"`:
- **Provide**: UI design plan, design system tokens, WCAG requirements, target user profiles
- **Request**: Define accessibility baseline (ARIA patterns, keyboard navigation plan, color contrast requirements) and usability heuristics for Wave 5
- **Apply**: Record a11y requirements in wave5-context.md as mandatory constraints for all Wave 5 AIOUs

Use `/sdlc-dev-wave5-status` to check progress, `/sdlc-dev-wave5-next` to advance.
