---
name: good-fullstack
description: Create distinctive, production-grade fullstack applications with exceptional design and engineering quality. Enforces high-quality React frontend development, secure backend practices, database design, logging/observability, and clean code organization. Automatically generates FILETREE.md documentation with styled summaries of all files and pages. Use when building UI components, APIs, database schemas, or any fullstack development work. Generates creative, polished code that avoids generic AI patterns.
---

# Good Fullstack Development (2025-2026 Edition)

This skill ensures all fullstack code follows modern best practices for beautiful, accessible, performant, secure, and maintainable applications. Updated with React 19, Tailwind CSS v4, Server Components, Core Web Vitals 2025, Node.js/Python backend security, and database design principles.

**CRITICAL**: This skill creates distinctive, production-grade applications that avoid generic "AI slop" patterns. Every interface should be MEMORABLE and every backend should be SECURE and OBSERVABLE.

---

## File Tree Documentation (FILETREE.md)

After completing significant work on a project, you MUST generate or update a `FILETREE.md` file in the project root. This file provides a comprehensive, styled overview of the project structure with summaries of what each file and folder does.

### When to Generate/Update FILETREE.md

**MANDATORY** - Generate or update `FILETREE.md` when:
- Creating a new project from scratch
- Adding new features with multiple files
- Completing a significant refactor
- After any session with 5+ file changes
- When user explicitly requests documentation

**SKIP** when:
- Making minor single-file edits
- Fixing typos or small bugs
- Updating only config files

### FILETREE.md Structure

The file should follow this format:

```markdown
# 📁 Project Structure

> Auto-generated file tree with descriptions. Last updated: [DATE]

## Overview

Brief 1-2 sentence description of what this project is.

## Directory Structure

\`\`\`
project-root/
├── 📂 src/
│   ├── 📂 app/                    # Next.js App Router pages
│   │   ├── 📄 layout.tsx          # Root layout with providers
│   │   ├── 📄 page.tsx            # Home page
│   │   └── 📂 (auth)/             # Auth route group
│   │       ├── 📄 login/page.tsx  # Login page
│   │       └── 📄 signup/page.tsx # Signup page
│   ├── 📂 components/
│   │   ├── 📂 ui/                 # Reusable UI primitives
│   │   │   ├── 📄 button.tsx      # Button component with variants
│   │   │   ├── 📄 input.tsx       # Form input component
│   │   │   └── 📄 card.tsx        # Card container component
│   │   └── 📂 features/           # Feature-specific components
│   │       └── 📂 auth/
│   │           ├── 📄 login-form.tsx    # Login form with validation
│   │           └── 📄 signup-form.tsx   # Signup form with validation
│   ├── 📂 hooks/                  # Custom React hooks
│   │   ├── 📄 use-auth.ts         # Authentication state hook
│   │   └── 📄 use-local-storage.ts # LocalStorage sync hook
│   ├── 📂 lib/                    # Utilities and helpers
│   │   ├── 📄 utils.ts            # General utility functions
│   │   ├── 📄 api.ts              # API client configuration
│   │   └── 📄 constants.ts        # App-wide constants
│   ├── 📂 types/                  # TypeScript type definitions
│   │   ├── 📄 user.ts             # User-related types
│   │   └── 📄 api.ts              # API response types
│   └── 📂 styles/                 # Global styles
│       └── 📄 globals.css         # Tailwind + custom CSS
├── 📂 public/                     # Static assets
│   ├── 🖼️ favicon.ico             # Site favicon
│   └── 📂 images/                 # Image assets
├── 📂 prisma/                     # Database schema (if using Prisma)
│   └── 📄 schema.prisma           # Prisma schema definition
├── 📄 package.json                # Dependencies and scripts
├── 📄 tsconfig.json               # TypeScript configuration
├── 📄 tailwind.config.ts          # Tailwind CSS configuration
├── 📄 next.config.js              # Next.js configuration
├── 📄 .env.example                # Environment variables template
└── 📄 README.md                   # Project documentation
\`\`\`

## Key Files

### App Router (`src/app/`)

| File | Purpose |
|------|---------|
| `layout.tsx` | Root layout with metadata, fonts, and providers |
| `page.tsx` | Home page - displays hero section and features |
| `loading.tsx` | Global loading skeleton |
| `error.tsx` | Global error boundary |
| `not-found.tsx` | 404 page |

### Components (`src/components/`)

#### UI Primitives (`src/components/ui/`)

| Component | Description | Props |
|-----------|-------------|-------|
| `Button` | Primary action button | `variant`, `size`, `isLoading` |
| `Input` | Form input with label/error | `label`, `error`, `description` |
| `Card` | Container with elevation | `variant`, `padding` |

#### Feature Components (`src/components/features/`)

| Component | Description |
|-----------|-------------|
| `LoginForm` | Email/password login with Zod validation |
| `SignupForm` | Registration form with password requirements |
| `UserAvatar` | User profile picture with fallback |

### Hooks (`src/hooks/`)

| Hook | Purpose | Returns |
|------|---------|---------|
| `useAuth` | Auth state management | `{ user, login, logout, isLoading }` |
| `useLocalStorage` | Persistent state | `[value, setValue]` |

### API Routes (`src/app/api/`)

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/auth/login` | POST | Authenticate user, return JWT |
| `/api/auth/signup` | POST | Create new user account |
| `/api/users/me` | GET | Get current user profile |

## Architecture Decisions

- **App Router**: Using Next.js 14+ App Router for server components
- **Styling**: Tailwind CSS v4 with custom design tokens
- **State**: Server Components for data, Zustand for client UI state
- **Forms**: React Hook Form + Zod validation
- **Auth**: JWT in HttpOnly cookies
- **Database**: Prisma ORM with PostgreSQL

## Scripts

| Command | Description |
|---------|-------------|
| `npm run dev` | Start development server |
| `npm run build` | Build for production |
| `npm run start` | Start production server |
| `npm run lint` | Run ESLint |
| `npm run test` | Run Vitest tests |
| `npm run db:push` | Push Prisma schema to database |

## Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `DATABASE_URL` | PostgreSQL connection string | Yes |
| `JWT_SECRET` | Secret for JWT signing | Yes |
| `NEXT_PUBLIC_APP_URL` | Public app URL | Yes |

---

*This file is auto-generated. Do not edit manually.*
```

### File Icons Reference

Use consistent icons for visual clarity:

| Type | Icon | Usage |
|------|------|-------|
| Folder | 📂 | All directories |
| TypeScript/TSX | 📄 | `.ts`, `.tsx` files |
| JavaScript | 📜 | `.js`, `.jsx` files |
| CSS/Styles | 🎨 | `.css`, `.scss` files |
| Image | 🖼️ | `.png`, `.jpg`, `.svg`, `.ico` |
| Config | ⚙️ | Config files (optional) |
| Database | 🗄️ | Schema files (optional) |
| Test | 🧪 | Test files (optional) |
| Documentation | 📝 | `.md` files (optional) |

### Description Guidelines

**For Directories:**
- Keep descriptions brief (3-6 words)
- Focus on what TYPE of files it contains
- Examples: "Next.js App Router pages", "Reusable UI primitives", "Custom React hooks"

**For Files:**
- Describe the PRIMARY purpose
- Include key exports if relevant
- Examples: "Button component with variants", "Authentication state hook", "API client configuration"

**For Components:**
- List important props in tables
- Note any special behavior
- Include return types for hooks

### Styling the FILETREE.md

Make it visually appealing:

1. **Use Tree Characters**: `├──`, `└──`, `│` for clean tree visualization
2. **Add Emojis**: Folder/file icons for quick scanning
3. **Tables for Details**: Component props, API endpoints, scripts
4. **Clear Sections**: Group by purpose (pages, components, hooks, etc.)
5. **Architecture Notes**: Brief explanation of key decisions

### Generation Process

When generating FILETREE.md:

1. **Scan Project Structure**
   - List all directories and files
   - Identify framework (Next.js, React, Vue, etc.)
   - Note any configuration files

2. **Analyze Each File**
   - Read component exports
   - Identify hook signatures
   - Map API endpoints
   - Note key functions/classes

3. **Categorize Content**
   - Group by purpose (UI, features, hooks, utils)
   - Identify patterns (compound components, providers)
   - Note dependencies between modules

4. **Generate Descriptions**
   - Write concise summaries for each file
   - Document component props
   - List hook return values
   - Describe API endpoints

5. **Add Context**
   - Include architecture decisions
   - Document environment variables
   - List available scripts
   - Note any special setup

### Example: Minimal FILETREE.md

For smaller projects:

```markdown
# 📁 Project Structure

> Simple React app for task management

## Structure

\`\`\`
task-app/
├── 📂 src/
│   ├── 📄 App.tsx            # Main app with routing
│   ├── 📄 main.tsx           # Entry point
│   ├── 📂 components/
│   │   ├── 📄 TaskList.tsx   # Displays all tasks
│   │   ├── 📄 TaskItem.tsx   # Single task with actions
│   │   └── 📄 AddTask.tsx    # Form to create tasks
│   ├── 📂 hooks/
│   │   └── 📄 useTasks.ts    # Task CRUD operations
│   └── 📂 types/
│       └── 📄 task.ts        # Task type definitions
├── 📄 package.json
└── 📄 vite.config.ts
\`\`\`

## Components

| Component | Description |
|-----------|-------------|
| `TaskList` | Maps tasks to TaskItem components |
| `TaskItem` | Task with complete/delete actions |
| `AddTask` | Form with title input |

## Hooks

| Hook | Returns |
|------|---------|
| `useTasks` | `{ tasks, addTask, toggleTask, deleteTask }` |
```

### Update Strategy

When updating existing FILETREE.md:

1. **Preserve Custom Content**: Keep any manually added notes
2. **Update Changed Files**: Refresh descriptions for modified files
3. **Add New Files**: Include newly created files/folders
4. **Remove Deleted**: Remove entries for deleted files
5. **Update Timestamp**: Change "Last updated" date

### FILETREE.md Checklist

- [ ] Project overview at top
- [ ] Complete directory tree with icons
- [ ] File descriptions are concise and accurate
- [ ] Key components documented with props
- [ ] Hooks documented with return values
- [ ] API endpoints listed if applicable
- [ ] Environment variables documented
- [ ] Scripts section included
- [ ] Architecture decisions noted
- [ ] Timestamp updated

---

## Image Analysis & Design Recreation

When the user provides an image (screenshot, design mockup, reference), you MUST analyze it deeply and recreate it with pixel-perfect accuracy and optimal performance.

### When You See an Image

**MANDATORY ANALYSIS PROCESS:**

1. **Visual Inventory** - Identify every element:
   - Layout structure (grid, flexbox, positioning)
   - Typography (fonts, sizes, weights, line-heights, letter-spacing)
   - Colors (exact values, gradients, opacity levels)
   - Spacing (margins, padding, gaps - measure precisely)
   - Shadows (blur, spread, color, offset)
   - Borders (width, style, color, radius)
   - Effects (blur, gradients, overlays, textures)
   - Animations/interactions (if visible or implied)

2. **Style Classification** - Determine the aesthetic:
   - What design system/style is this? (Material, iOS, custom, etc.)
   - What era/trend does it represent?
   - What makes it distinctive?
   - What's the color theory at play?
   - What's the typography strategy?

3. **Component Breakdown** - Map to code structure:
   - Identify reusable components
   - Determine component hierarchy
   - Note responsive behavior (if multiple sizes shown)
   - Identify interactive states

4. **Performance Planning** - Optimize recreation:
   - Use CSS over images where possible
   - Identify what can be CSS gradients/shadows vs assets
   - Plan efficient animation approach
   - Consider bundle size implications

### Image Analysis Template

When analyzing a design image, document:

```markdown
## Design Analysis

### Layout
- Grid: [12-col / custom / flexbox]
- Breakpoints: [mobile-first / desktop-first]
- Container: [max-width, padding]

### Typography
- Display Font: [identified or closest match]
- Body Font: [identified or closest match]
- Scale: [sizes used: h1=48px, h2=32px, body=16px, etc.]
- Weights: [regular, medium, semibold, bold]

### Colors
- Background: [#hex / oklch / rgb]
- Foreground: [#hex]
- Primary: [#hex]
- Accent: [#hex]
- Muted: [#hex]
- Borders: [#hex with opacity]

### Spacing
- Base unit: [4px / 8px]
- Section padding: [value]
- Component gaps: [value]
- Card padding: [value]

### Effects
- Shadows: [values]
- Borders: [values]
- Radii: [values]
- Blur effects: [values]

### Distinctive Elements
- [What makes this design unique]
- [Special effects or patterns]
- [Memorable visual elements]
```

### Recreation Standards

When recreating a design:

```tsx
// 1. EXTRACT EXACT DESIGN TOKENS
const designTokens = {
  colors: {
    background: "oklch(0.98 0.01 240)",      // Measured from image
    foreground: "oklch(0.15 0.02 240)",
    primary: "oklch(0.55 0.25 260)",
    accent: "oklch(0.70 0.20 30)",
    muted: "oklch(0.95 0.01 240)",
    border: "oklch(0.90 0.01 240)",
  },
  typography: {
    display: '"Instrument Serif", Georgia, serif',
    body: '"DM Sans", system-ui, sans-serif',
  },
  spacing: {
    xs: "4px",
    sm: "8px",
    md: "16px",
    lg: "24px",
    xl: "32px",
    "2xl": "48px",
  },
  radii: {
    sm: "6px",
    md: "12px",
    lg: "16px",
    full: "9999px",
  },
  shadows: {
    sm: "0 1px 2px oklch(0 0 0 / 0.05)",
    md: "0 4px 12px oklch(0 0 0 / 0.08)",
    lg: "0 12px 40px oklch(0 0 0 / 0.12)",
  },
};

// 2. RECREATE WITH PIXEL-PERFECT ACCURACY
function RecreatedComponent() {
  return (
    <div 
      className="relative"
      style={{
        // Match EXACTLY what's in the image
        background: designTokens.colors.background,
        borderRadius: designTokens.radii.lg,
        padding: designTokens.spacing.xl,
        boxShadow: designTokens.shadows.md,
      }}
    >
      {/* Recreate every element precisely */}
    </div>
  );
}
```

### App Design Replacement

When asked to replace/redesign an existing app's design:

**MANDATORY RESEARCH PROCESS:**

1. **Current State Analysis**
   - Read all existing component files
   - Document current design tokens
   - Identify all UI patterns in use
   - Map component hierarchy
   - Note any design inconsistencies

2. **Reference Research** (if reference image provided)
   - Analyze the reference image thoroughly
   - Extract all design tokens
   - Identify the design system/philosophy
   - Note what makes it better than current

3. **Gap Analysis**
   - Compare current vs target design
   - List all changes needed
   - Prioritize by impact
   - Plan migration strategy

4. **Systematic Replacement**
   ```
   Step 1: Update design tokens (colors, fonts, spacing)
   Step 2: Update base components (Button, Input, Card, etc.)
   Step 3: Update composite components
   Step 4: Update page layouts
   Step 5: Add new effects/animations
   Step 6: Test responsive behavior
   Step 7: Performance audit
   ```

### Performance-Optimized Recreation

Always recreate with performance in mind:

```tsx
// ❌ BAD: Using images for effects that can be CSS
<img src="/gradient-background.png" className="absolute inset-0" />

// ✅ GOOD: CSS recreation
<div 
  className="absolute inset-0"
  style={{
    background: `
      radial-gradient(ellipse at 30% 20%, oklch(0.6 0.2 280 / 0.3), transparent 50%),
      radial-gradient(ellipse at 70% 80%, oklch(0.7 0.15 200 / 0.2), transparent 50%),
      oklch(0.98 0.01 240)
    `,
  }}
/>

// ❌ BAD: Heavy image shadows
<img src="/card-shadow.png" />

// ✅ GOOD: CSS shadows with performance
<div 
  className="transition-shadow duration-300"
  style={{
    boxShadow: `
      0 1px 2px oklch(0 0 0 / 0.03),
      0 4px 8px oklch(0 0 0 / 0.04),
      0 12px 24px oklch(0 0 0 / 0.05)
    `,
  }}
/>

// ❌ BAD: Complex SVG patterns as images
<img src="/pattern.svg" className="absolute inset-0" />

// ✅ GOOD: Inline SVG or CSS patterns
<svg className="absolute inset-0 w-full h-full opacity-5">
  <pattern id="grid" width="32" height="32" patternUnits="userSpaceOnUse">
    <path d="M 32 0 L 0 0 0 32" fill="none" stroke="currentColor" strokeWidth="1"/>
  </pattern>
  <rect width="100%" height="100%" fill="url(#grid)" />
</svg>
```

### Font Identification

When recreating a design, identify fonts accurately:

| If You See... | Likely Font | Alternatives |
|---------------|-------------|--------------|
| Elegant serifs, high contrast | Playfair Display | Cormorant, Libre Baskerville |
| Modern geometric sans | Satoshi, General Sans | Outfit, Urbanist |
| Humanist warmth | DM Sans, Plus Jakarta | Source Sans 3, Nunito |
| Monospace coding | JetBrains Mono | Fira Code, IBM Plex Mono |
| Display impact | Clash Display | Cabinet Grotesk, Syne |
| Classic editorial | Instrument Serif | Newsreader, Literata |
| Rounded friendly | Nunito, Quicksand | Varela Round, Comfortaa |
| Swiss precision | Helvetica Neue | Inter (if must), Switzer |

**Use web search to identify exact fonts when uncertain.**

---

## Core Principles

When writing frontend code, ALWAYS follow these principles:

1. **Distinctive Design** - Bold aesthetic choices, never generic or cookie-cutter
2. **Server-First Architecture** - Default to Server Components, use client only when needed
3. **Beautiful by Default** - Modern, polished UI with meticulous attention to detail
4. **Accessible First** - WCAG 2.2 AA compliance minimum
5. **Performance Optimized** - Target all Core Web Vitals in "Good" range
6. **Responsive** - Mobile-first, works on all screen sizes
7. **Type-Safe** - Full TypeScript with strict mode enabled
8. **Secure by Design** - Security built in from the start, not bolted on
9. **Observable** - Structured logging, tracing, and monitoring

---

## Planning & Request Breakdown

Before writing ANY code, you MUST complete this planning phase:

### Step 1: Understand the Request

- What is the user ACTUALLY asking for?
- What problem are they solving?
- What constraints exist (framework, design system, performance)?
- Is this frontend, backend, database, or fullstack work?

### Step 2: Scope Definition

- What's IN scope?
- What's OUT of scope?
- What assumptions are we making?
- What are the acceptance criteria?

### Step 3: Component/Module Decomposition

**Frontend:**
- Break the UI into atomic components
- Identify reusable patterns
- Map component hierarchy

**Backend:**
- Identify API endpoints needed
- Map data flow and transformations
- Define service boundaries

**Database:**
- Identify entities and relationships
- Plan schema changes
- Consider migration strategy

### Step 4: Technical Planning

- What hooks/state needed?
- What APIs/data sources?
- What animations/interactions?
- What security considerations?
- What logging/monitoring needed?

### Step 5: Risk Assessment

- What could go wrong?
- What are the edge cases?
- What are the failure modes?
- What's the rollback plan?

### Step 6: Implementation Order

- Create prioritized task list
- Identify dependencies between tasks
- Start with foundation, build up

---

## Problem Analysis (Before Any Fix)

**CRITICAL**: Before writing ANY solution, you MUST understand the problem deeply.

### The 5-Phase Problem Analysis

**Phase 1: REPRODUCE**
- Can you consistently trigger the issue?
- What are the exact steps to reproduce?
- What environment/conditions cause it?

**Phase 2: ISOLATE**
- What's the smallest code path that fails?
- Which component/layer is responsible?
- Is it frontend, backend, database, or integration?

**Phase 3: UNDERSTAND**
- WHY does it fail, not just WHERE?
- What's the root cause vs symptoms?
- What assumptions were wrong?

**Phase 4: RESEARCH**
- Is this a known issue? (search GitHub issues, Stack Overflow)
- Are there existing solutions/patterns?
- What do official docs say?

**Phase 5: PLAN**
- What's the minimal fix?
- What could break with this change?
- How will you verify it works?

### Common Issue Patterns

| Symptom | Likely Cause | Investigation |
|---------|--------------|---------------|
| `undefined is not a function` | Missing import, wrong reference | Check imports, verify function exists |
| `Cannot read property of null` | Async timing, missing data | Add null checks, check data flow |
| `Type mismatch` | Wrong data shape | Validate types, check API response |
| Component not rendering | State not updating | Check setState, verify re-render triggers |
| Infinite loop | Missing deps, bad condition | Review useEffect deps, check exit conditions |
| 500 Internal Server Error | Unhandled exception | Check server logs, add error handling |
| Slow queries | Missing index, N+1 | EXPLAIN ANALYZE, add indexes |
| Memory leak | Unclosed connections, listeners | Profile memory, cleanup in useEffect |

### Before Every Fix

- [ ] Can I reproduce the issue?
- [ ] Do I understand the root cause?
- [ ] What's the expected behavior?
- [ ] What edge cases exist?
- [ ] How will I verify the fix?
- [ ] What could this break?

---

## Design Thinking

Before coding ANY interface, understand the context and commit to a BOLD aesthetic direction:

### Pre-Implementation Analysis

1. **Purpose**: What problem does this interface solve? Who uses it?
2. **Tone**: Pick a clear aesthetic direction (see options below)
3. **Constraints**: Technical requirements (framework, performance, accessibility)
4. **Differentiation**: What makes this UNFORGETTABLE? What's the one thing someone will remember?

### Aesthetic Directions (Choose One)

| Direction | Characteristics | When to Use |
|-----------|-----------------|-------------|
| **Brutally Minimal** | Stark white space, single accent, extreme restraint | Developer tools, productivity apps |
| **Maximalist Chaos** | Layered elements, multiple textures, controlled density | Creative portfolios, art platforms |
| **Retro-Futuristic** | Neon accents, grid patterns, sci-fi inspired | Gaming, tech products |
| **Organic/Natural** | Soft curves, earth tones, flowing layouts | Wellness, sustainability brands |
| **Luxury/Refined** | Rich typography, generous spacing, subtle gold/cream | Premium products, finance |
| **Playful/Toy-like** | Bright colors, bouncy animations, rounded shapes | Kids' apps, casual games |
| **Editorial/Magazine** | Strong typography hierarchy, dramatic imagery | Content platforms, blogs |
| **Brutalist/Raw** | Exposed structure, monospace fonts, stark contrasts | Experimental, avant-garde |
| **Art Deco/Geometric** | Gold accents, symmetry, ornate patterns | Events, luxury retail |
| **Soft/Pastel** | Muted colors, gentle gradients, delicate shadows | Social apps, lifestyle brands |
| **Industrial/Utilitarian** | Exposed grids, functional aesthetics, metal tones | Manufacturing, logistics |

**CRITICAL**: Choose a clear conceptual direction and execute it with precision. Bold maximalism and refined minimalism both work - the key is intentionality, not intensity.

### Implementation Complexity Matching

Match implementation complexity to the aesthetic vision:

```tsx
// MAXIMALIST: Elaborate code with extensive animations and effects
<motion.div
  className="relative overflow-hidden"
  initial={{ opacity: 0, scale: 0.9, rotateX: -15 }}
  animate={{ opacity: 1, scale: 1, rotateX: 0 }}
  transition={{ type: "spring", stiffness: 200, damping: 20 }}
>
  <div className="absolute inset-0 bg-gradient-mesh opacity-30" />
  <div className="absolute inset-0 noise-texture mix-blend-overlay" />
  <div className="relative z-10 backdrop-blur-sm">
    {/* Rich, layered content */}
  </div>
</motion.div>

// MINIMALIST: Restraint, precision, careful attention to spacing
<div className="space-y-16 py-24">
  <h1 className="font-display text-6xl tracking-tight text-neutral-900">
    {title}
  </h1>
  <p className="max-w-2xl text-xl leading-relaxed text-neutral-600">
    {description}
  </p>
</div>
```

---

## Frontend Aesthetics Guidelines

### Typography - The Foundation

**NEVER** use generic fonts. Choose distinctive, characterful typefaces:

```css
/* ❌ BANNED: Generic AI-slop fonts */
font-family: Inter, Arial, Roboto, system-ui, sans-serif;

/* ✅ DISTINCTIVE: Memorable font choices */
@import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Source+Serif+4:opsz,wght@8..60,400;8..60,600&display=swap');

@theme {
  /* Display font: Characterful, memorable */
  --font-display: "Playfair Display", "Cormorant Garamond", "Libre Baskerville", serif;
  
  /* Body font: Refined, readable */
  --font-body: "Source Serif 4", "Literata", "Lora", serif;
  
  /* Mono font: Distinctive, not generic */
  --font-mono: "IBM Plex Mono", "Fira Code", "JetBrains Mono", monospace;
}
```

**Font Pairing Examples:**

| Vibe | Display | Body |
|------|---------|------|
| **Luxury Editorial** | Playfair Display | Source Serif 4 |
| **Modern Tech** | Clash Display | Satoshi |
| **Playful Creative** | Fraunces | Cabinet Grotesk |
| **Brutalist** | Monument Extended | Space Mono |
| **Organic** | Recoleta | Nunito Sans |
| **Art Deco** | Poiret One | Josefin Sans |

### Color & Theme - Commit Fully

Dominant colors with sharp accents outperform timid, evenly-distributed palettes:

```css
@theme {
  /* BOLD: Dominant with sharp accent */
  --color-surface: oklch(0.12 0.02 280);        /* Deep purple-black */
  --color-foreground: oklch(0.95 0.01 280);    /* Near white */
  --color-accent: oklch(0.75 0.25 150);         /* Electric green */
  --color-accent-muted: oklch(0.75 0.25 150 / 0.15);
  
  /* NOT: Evenly distributed, safe palette */
  /* --color-primary: blue; */
  /* --color-secondary: gray; */
  /* --color-accent: purple; */
}

/* Create atmosphere, not just colors */
.hero-section {
  background: 
    radial-gradient(ellipse at 20% 50%, oklch(0.3 0.15 280 / 0.4), transparent 50%),
    radial-gradient(ellipse at 80% 20%, oklch(0.4 0.2 150 / 0.3), transparent 40%),
    var(--color-surface);
}
```

**Color Strategy Examples:**

| Aesthetic | Dominant | Accent | Usage |
|-----------|----------|--------|-------|
| **Dark Luxury** | Near-black (#0a0a0a) | Gold (#d4af37) | 95% / 5% |
| **Bold Tech** | Deep blue (#0f172a) | Electric cyan (#00fff0) | 90% / 10% |
| **Warm Editorial** | Cream (#faf7f2) | Terracotta (#c77b58) | 85% / 15% |
| **Brutalist** | Pure white (#ffffff) | Pure black (#000000) | 50% / 50% |

### Backgrounds & Visual Details - Create Atmosphere

Never default to solid colors. Add depth and texture:

```css
/* Gradient Mesh Background */
.gradient-mesh {
  background: 
    radial-gradient(at 40% 20%, hsla(280, 80%, 60%, 0.3) 0px, transparent 50%),
    radial-gradient(at 80% 0%, hsla(189, 100%, 56%, 0.2) 0px, transparent 50%),
    radial-gradient(at 0% 50%, hsla(355, 85%, 63%, 0.2) 0px, transparent 50%),
    radial-gradient(at 80% 50%, hsla(240, 80%, 70%, 0.2) 0px, transparent 50%),
    radial-gradient(at 0% 100%, hsla(22, 100%, 50%, 0.15) 0px, transparent 50%);
}

/* Noise Texture Overlay */
.noise-texture {
  background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.8' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)'/%3E%3C/svg%3E");
  opacity: 0.03;
  pointer-events: none;
}

/* Geometric Pattern */
.geometric-pattern {
  background-image: 
    linear-gradient(30deg, var(--color-accent) 12%, transparent 12.5%, transparent 87%, var(--color-accent) 87.5%, var(--color-accent)),
    linear-gradient(150deg, var(--color-accent) 12%, transparent 12.5%, transparent 87%, var(--color-accent) 87.5%, var(--color-accent)),
    linear-gradient(30deg, var(--color-accent) 12%, transparent 12.5%, transparent 87%, var(--color-accent) 87.5%, var(--color-accent)),
    linear-gradient(150deg, var(--color-accent) 12%, transparent 12.5%, transparent 87%, var(--color-accent) 87.5%, var(--color-accent));
  background-size: 80px 140px;
  background-position: 0 0, 0 0, 40px 70px, 40px 70px;
  opacity: 0.05;
}

/* Layered Glass Effect */
.glass-panel {
  background: oklch(1 0 0 / 0.05);
  backdrop-filter: blur(12px) saturate(180%);
  border: 1px solid oklch(1 0 0 / 0.1);
  box-shadow: 
    0 4px 30px oklch(0 0 0 / 0.1),
    inset 0 1px 0 oklch(1 0 0 / 0.1);
}
```

### Spatial Composition - Break the Grid

Unexpected layouts create memorable interfaces:

```tsx
// UNEXPECTED: Overlapping elements, asymmetry
<div className="relative min-h-screen">
  {/* Off-grid positioned element */}
  <div className="absolute -left-20 top-1/4 w-96 h-96 rounded-full bg-accent/10 blur-3xl" />
  
  {/* Diagonal flow */}
  <div className="grid grid-cols-12 gap-4">
    <div className="col-span-5 col-start-2 row-start-1">
      <h1 className="text-8xl font-display -rotate-2">Title</h1>
    </div>
    <div className="col-span-4 col-start-8 row-start-1 translate-y-16">
      <p className="text-lg">Offset description...</p>
    </div>
  </div>
  
  {/* Overlapping card */}
  <div className="relative z-10 -mt-24 ml-[15%] max-w-2xl">
    <Card className="transform rotate-1 hover:-rotate-1 transition-transform" />
  </div>
</div>

// GENEROUS NEGATIVE SPACE (Minimalist)
<section className="py-40 px-8">
  <div className="max-w-xl mx-auto space-y-24">
    <h2 className="text-5xl">One powerful statement.</h2>
    <p className="text-xl leading-relaxed">
      Let it breathe. White space is a design element.
    </p>
  </div>
</section>
```

### Motion - High-Impact Moments

Focus on orchestrated reveals over scattered micro-interactions:

```tsx
// PAGE LOAD: Staggered reveal with animation-delay
function HeroSection() {
  return (
    <motion.section
      initial="hidden"
      animate="visible"
      variants={{
        visible: { transition: { staggerChildren: 0.1, delayChildren: 0.2 } }
      }}
    >
      <motion.span
        variants={{
          hidden: { opacity: 0, y: 40, filter: "blur(10px)" },
          visible: { opacity: 1, y: 0, filter: "blur(0px)" }
        }}
        transition={{ duration: 0.8, ease: [0.22, 1, 0.36, 1] }}
        className="block text-sm uppercase tracking-[0.3em] text-accent"
      >
        Welcome
      </motion.span>
      
      <motion.h1
        variants={{
          hidden: { opacity: 0, y: 60, filter: "blur(10px)" },
          visible: { opacity: 1, y: 0, filter: "blur(0px)" }
        }}
        transition={{ duration: 1, ease: [0.22, 1, 0.36, 1] }}
        className="mt-4 text-7xl font-display"
      >
        Something Memorable
      </motion.h1>
      
      <motion.div
        variants={{
          hidden: { opacity: 0, scaleX: 0 },
          visible: { opacity: 1, scaleX: 1 }
        }}
        transition={{ duration: 0.8, ease: [0.22, 1, 0.36, 1] }}
        className="mt-8 h-px w-24 bg-accent origin-left"
      />
    </motion.section>
  );
}

// SCROLL-TRIGGERED: Reveal on scroll
function ScrollReveal({ children }: { children: React.ReactNode }) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 60 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true, margin: "-100px" }}
      transition={{ duration: 0.8, ease: [0.22, 1, 0.36, 1] }}
    >
      {children}
    </motion.div>
  );
}

// HOVER: Surprising, delightful
<motion.button
  whileHover={{ 
    scale: 1.02,
    boxShadow: "0 20px 40px -15px var(--color-accent-muted)"
  }}
  whileTap={{ scale: 0.98 }}
  transition={{ type: "spring", stiffness: 400, damping: 25 }}
  className="relative overflow-hidden group"
>
  <span className="relative z-10">Explore</span>
  <motion.div
    className="absolute inset-0 bg-accent"
    initial={{ x: "-100%" }}
    whileHover={{ x: 0 }}
    transition={{ duration: 0.3, ease: "easeInOut" }}
  />
</motion.button>
```

---

## Generic AI Aesthetics to AVOID

**NEVER** use these patterns that scream "AI-generated":

### Visual Slop Patterns

| Anti-Pattern | Why It's Bad | Better Alternative |
|--------------|--------------|-------------------|
| Inter/Roboto/Arial fonts | Overused, no character | Distinctive display + refined body fonts |
| Purple gradients on white | AI's default "pretty" | Commit to a real color story |
| Centered everything | Boring, predictable | Asymmetry, off-grid positioning |
| Blue primary buttons | Generic, forgettable | Context-specific accent colors |
| Evenly-spaced cards grid | Cookie-cutter layout | Varied sizes, overlaps, masonry |
| Stock illustration style | Instantly recognizable as AI | Custom graphics, photography, abstract shapes |
| "Clean and modern" as goal | Says nothing, means nothing | Specific aesthetic with clear POV |
| Rounded corners on everything | Softens everything into sameness | Mix sharp and soft intentionally |
| Gradient backgrounds only | Lazy depth creation | Textures, patterns, layered elements |
| Generic hero sections | "Big text + CTA + image" | Unexpected compositions |

### Code Slop Patterns

| Anti-Pattern | Why It's Bad | Better Alternative |
|--------------|--------------|-------------------|
| Mixed import styles | Inconsistent, hard to scan | Strict import ordering (React → external → internal) |
| `any` type everywhere | Defeats TypeScript's purpose | Proper types, generics, inference |
| Giant components (300+ lines) | Impossible to maintain | Split into focused subcomponents |
| Prop drilling 5+ levels | Coupling, hard to refactor | Context, composition, or state management |
| `useEffect` for everything | Over-complicated, race conditions | Server Components, derived state, event handlers |
| Copy-pasted code blocks | Maintenance nightmare | Extract to reusable functions/components |
| Magic numbers/strings | Unclear intent | Named constants, enums, config objects |
| Nested ternaries | Unreadable | Early returns, switch, lookup objects |
| Console.log debugging left in | Unprofessional, leaks info | Proper logging, remove before commit |
| Commented-out code | Clutters, causes confusion | Delete it, use git history |

### Structure Slop Patterns

| Anti-Pattern | Why It's Bad | Better Alternative |
|--------------|--------------|-------------------|
| Everything in one file | Impossible to navigate | One component per file, logical grouping |
| No folder structure | Chaos at scale | Feature-based or layer-based organization |
| Mixed concerns in components | Hard to test, reuse | Separate UI, logic, data fetching |
| API calls in components | Tight coupling | Hooks, services, server actions |
| Business logic in UI | Hard to test | Extract to pure functions |
| Styles mixed with logic | Hard to maintain | Separate concerns, design tokens |

### Logic Slop Patterns

| Anti-Pattern | Why It's Bad | Better Alternative |
|--------------|--------------|-------------------|
| Unnecessary state | Re-renders, bugs | Derive from existing state/props |
| State for server data | Stale data, sync issues | React Query, Server Components |
| Over-engineering | Complexity without benefit | YAGNI - build what you need |
| Premature abstraction | Wrong abstractions | Wait for patterns to emerge |
| God components | Does everything, maintains nothing | Single responsibility |
| Callback hell | Unreadable async code | async/await, proper error handling |

### Slop Detection Checklist

Before committing any code, ask:

- [ ] Can I explain what this code does in one sentence?
- [ ] Is there duplicated code that should be extracted?
- [ ] Are there any `any` types I can eliminate?
- [ ] Is this component under 150 lines?
- [ ] Are all magic values named constants?
- [ ] Is there commented-out code to delete?
- [ ] Are console.logs removed?
- [ ] Does the file structure make sense?
- [ ] Would a new developer understand this quickly?
- [ ] Is there unnecessary state that could be derived?

```tsx
// ❌ GENERIC AI SLOP
<section className="bg-gradient-to-br from-purple-500 to-blue-500 py-20">
  <div className="container mx-auto text-center">
    <h1 className="text-5xl font-bold text-white">Welcome to Our Platform</h1>
    <p className="mt-4 text-xl text-white/80">The best solution for your needs</p>
    <button className="mt-8 rounded-lg bg-white px-8 py-3 font-semibold text-purple-600">
      Get Started
    </button>
  </div>
</section>

// ✅ DISTINCTIVE & MEMORABLE
<section className="relative min-h-screen bg-[#0a0a0a] overflow-hidden">
  {/* Atmospheric background */}
  <div className="absolute inset-0">
    <div className="absolute top-0 left-1/4 w-[500px] h-[500px] bg-amber-500/10 rounded-full blur-[100px]" />
    <div className="absolute bottom-0 right-1/4 w-[400px] h-[400px] bg-rose-500/10 rounded-full blur-[80px]" />
    <div className="noise-texture absolute inset-0" />
  </div>
  
  {/* Content with asymmetric layout */}
  <div className="relative z-10 grid grid-cols-12 min-h-screen items-center px-8">
    <div className="col-span-7 col-start-2">
      <motion.span 
        initial={{ opacity: 0, x: -20 }}
        animate={{ opacity: 1, x: 0 }}
        className="text-xs uppercase tracking-[0.4em] text-amber-400"
      >
        Est. 2024
      </motion.span>
      <motion.h1 
        initial={{ opacity: 0, y: 40 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.1 }}
        className="mt-6 font-display text-8xl leading-[0.9] text-white"
      >
        Craft<br />
        <span className="text-amber-400">Matters</span>
      </motion.h1>
    </div>
    
    <motion.div 
      initial={{ opacity: 0, scale: 0.9 }}
      animate={{ opacity: 1, scale: 1 }}
      transition={{ delay: 0.3 }}
      className="col-span-3 col-start-9"
    >
      <div className="aspect-square rounded-2xl border border-white/10 bg-white/5 backdrop-blur-sm p-8 transform rotate-3 hover:-rotate-1 transition-transform">
        <p className="font-body text-lg text-white/70 leading-relaxed">
          We believe in the power of intentional design.
        </p>
        <button className="mt-8 group flex items-center gap-2 text-amber-400">
          <span>Explore</span>
          <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
        </button>
      </div>
    </motion.div>
  </div>
</section>
```

---

## React 19 & Server Components

### Server-First Architecture

```tsx
// DEFAULT: Server Components (no directive needed)
// - Data fetching
// - Heavy computations
// - Non-interactive UI
// - Access to backend resources

async function ProductList() {
  const products = await db.products.findMany();
  return (
    <ul>
      {products.map(p => <ProductCard key={p.id} product={p} />)}
    </ul>
  );
}

// ONLY when needed: Client Components
"use client";
// - Event handlers (onClick, onChange)
// - Browser APIs (localStorage, geolocation)
// - Hooks (useState, useEffect)
// - Third-party client libraries

function AddToCartButton({ productId }: { productId: string }) {
  const [isPending, startTransition] = useTransition();
  // ...
}
```

### Component Boundaries

```
src/
├── components/
│   ├── server/          # Server Components (default)
│   │   ├── ProductList.tsx
│   │   └── UserProfile.tsx
│   ├── client/          # Client Components ("use client")
│   │   ├── AddToCartButton.tsx
│   │   └── SearchInput.tsx
│   └── ui/              # Shared primitives
└── app/                 # App Router pages
```

### React 19 New Hooks

```tsx
// useOptimistic - Instant UI feedback
function LikeButton({ postId, initialLikes }: Props) {
  const [likes, setLikes] = useState(initialLikes);
  const [optimisticLikes, addOptimisticLike] = useOptimistic(
    likes,
    (current, _) => current + 1
  );

  async function handleLike() {
    addOptimisticLike(null); // Show immediately
    await likePost(postId);  // Server action
    setLikes(prev => prev + 1);
  }

  return <button onClick={handleLike}>❤️ {optimisticLikes}</button>;
}

// useFormStatus - Form submission state
function SubmitButton() {
  const { pending, data } = useFormStatus();
  return (
    <button type="submit" disabled={pending} aria-busy={pending}>
      {pending ? "Submitting..." : "Submit"}
    </button>
  );
}

// use() - Promise resolution in render
function UserData({ userPromise }: { userPromise: Promise<User> }) {
  const user = use(userPromise);
  return <Profile user={user} />;
}

// useTransition - Non-blocking state updates
function SearchResults() {
  const [isPending, startTransition] = useTransition();
  const [query, setQuery] = useState("");

  function handleSearch(value: string) {
    startTransition(() => {
      setQuery(value); // Low priority, won't block typing
    });
  }
}
```

### Suspense & Streaming

```tsx
// Granular Suspense boundaries for streaming
export default function Page() {
  return (
    <main>
      <h1>Dashboard</h1>
      
      {/* Critical content renders immediately */}
      <UserHeader />
      
      {/* Streamed with skeleton */}
      <Suspense fallback={<StatsSkeleton />}>
        <StatsPanel />
      </Suspense>
      
      {/* Streamed independently */}
      <Suspense fallback={<ActivitySkeleton />}>
        <RecentActivity />
      </Suspense>
    </main>
  );
}

// Parallel data fetching - avoid waterfalls
async function Dashboard() {
  // GOOD: Parallel fetches
  const [user, stats, activity] = await Promise.all([
    getUser(),
    getStats(),
    getActivity(),
  ]);

  // BAD: Sequential waterfalls
  // const user = await getUser();
  // const stats = await getStats();
  // const activity = await getActivity();
}
```

---

## Tailwind CSS v4

### CSS-First Configuration

```css
/* app/globals.css */
@import "tailwindcss";

@theme {
  /* Design Tokens */
  --color-primary-50: oklch(0.97 0.02 250);
  --color-primary-500: oklch(0.55 0.2 250);
  --color-primary-900: oklch(0.25 0.15 250);

  /* Semantic Colors */
  --color-success: oklch(0.7 0.15 145);
  --color-warning: oklch(0.8 0.15 85);
  --color-error: oklch(0.65 0.2 25);

  /* Typography Scale */
  --font-sans: "Inter Variable", system-ui, sans-serif;
  --font-mono: "JetBrains Mono", monospace;

  /* Spacing (4px grid) */
  --spacing-xs: 0.25rem;
  --spacing-sm: 0.5rem;
  --spacing-md: 1rem;
  --spacing-lg: 1.5rem;
  --spacing-xl: 2rem;

  /* Radii */
  --radius-sm: 0.25rem;
  --radius-md: 0.5rem;
  --radius-lg: 0.75rem;
  --radius-full: 9999px;

  /* Shadows */
  --shadow-sm: 0 1px 2px oklch(0 0 0 / 0.05);
  --shadow-md: 0 4px 6px oklch(0 0 0 / 0.1);
  --shadow-lg: 0 10px 15px oklch(0 0 0 / 0.1);

  /* Animation */
  --ease-spring: cubic-bezier(0.34, 1.56, 0.64, 1);
  --duration-fast: 150ms;
  --duration-normal: 250ms;
}

/* Dark mode tokens */
@theme dark {
  --color-primary-500: oklch(0.7 0.18 250);
  --color-surface: oklch(0.15 0.01 250);
}
```

### Cascade Layers

```css
@layer base {
  html {
    font-family: var(--font-sans);
    scroll-behavior: smooth;
  }

  body {
    @apply bg-surface text-foreground antialiased;
  }

  /* Focus styles */
  :focus-visible {
    @apply outline-2 outline-offset-2 outline-primary-500;
  }
}

@layer components {
  .btn {
    @apply inline-flex items-center justify-center gap-2
           rounded-md px-4 py-2 font-medium
           transition-colors duration-fast
           focus-visible:outline focus-visible:outline-2;
  }

  .btn-primary {
    @apply btn bg-primary-500 text-white
           hover:bg-primary-600 active:bg-primary-700;
  }
}
```

### Modern Utilities

```tsx
// Container Queries
<div className="@container">
  <div className="grid @sm:grid-cols-2 @lg:grid-cols-3">
    {items.map(item => <Card key={item.id} {...item} />)}
  </div>
</div>

// State-driven styling with data attributes
<button
  data-state={isOpen ? "open" : "closed"}
  className="data-[state=open]:bg-primary-100 data-[state=open]:rotate-180"
>
  Toggle
</button>

// Group and peer modifiers
<label className="group">
  <input type="checkbox" className="peer sr-only" />
  <span className="peer-checked:bg-primary-500 peer-focus-visible:ring-2">
    Checkbox
  </span>
</label>

// Modern color functions
<div className="bg-primary-500/80 text-color-mix(in oklch, white 80%, black)">
  Semi-transparent with mixed colors
</div>
```

---

## UI/UX Standards

### Visual Design System

| Property | Value | Usage |
|----------|-------|-------|
| **Spacing** | 4px grid (4, 8, 12, 16, 24, 32, 48, 64) | All margins, padding, gaps |
| **Radius** | 4px (buttons), 8px (cards), 12px (modals) | Consistent rounding |
| **Shadows** | sm/md/lg elevation system | Depth hierarchy |
| **Transitions** | 150ms (micro), 250ms (standard), 350ms (emphasis) | Smooth state changes |

### Interactive States

```tsx
// Every interactive element needs ALL states
function Button({ children, ...props }: ButtonProps) {
  return (
    <button
      className={cn(
        // Base
        "relative inline-flex items-center justify-center",
        "rounded-md px-4 py-2 font-medium",
        "transition-all duration-150",
        
        // Default
        "bg-primary-500 text-white",
        
        // Hover
        "hover:bg-primary-600 hover:shadow-md",
        
        // Focus (keyboard)
        "focus-visible:outline-none focus-visible:ring-2",
        "focus-visible:ring-primary-500 focus-visible:ring-offset-2",
        
        // Active (pressed)
        "active:scale-[0.98] active:bg-primary-700",
        
        // Disabled
        "disabled:opacity-50 disabled:cursor-not-allowed",
        "disabled:hover:bg-primary-500 disabled:hover:shadow-none",
      )}
      {...props}
    >
      {children}
    </button>
  );
}
```

### Loading & Empty States

```tsx
// ALWAYS handle all states
interface DataDisplayProps<T> {
  data: T[] | undefined;
  isLoading: boolean;
  error: Error | null;
  emptyMessage?: string;
  children: (items: T[]) => React.ReactNode;
}

function DataDisplay<T>({
  data,
  isLoading,
  error,
  emptyMessage = "No items found",
  children,
}: DataDisplayProps<T>) {
  if (isLoading) return <Skeleton />;
  if (error) return <ErrorMessage error={error} />;
  if (!data?.length) return <EmptyState message={emptyMessage} />;
  return <>{children(data)}</>;
}

// Skeleton loading (prefer over spinners)
function CardSkeleton() {
  return (
    <div className="animate-pulse space-y-3 rounded-lg border p-4">
      <div className="h-4 w-3/4 rounded bg-muted" />
      <div className="h-4 w-1/2 rounded bg-muted" />
      <div className="h-20 rounded bg-muted" />
    </div>
  );
}
```

---

## Animation Best Practices

### Motion Library (formerly Framer Motion)

```tsx
import { motion, AnimatePresence } from "motion/react";

// Layout animations
function ExpandableCard({ isExpanded }: { isExpanded: boolean }) {
  return (
    <motion.div
      layout
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, y: -20 }}
      transition={{ type: "spring", stiffness: 300, damping: 25 }}
      className="rounded-lg border bg-card p-4"
    >
      <motion.h3 layout="position">Title</motion.h3>
      <AnimatePresence>
        {isExpanded && (
          <motion.div
            initial={{ height: 0, opacity: 0 }}
            animate={{ height: "auto", opacity: 1 }}
            exit={{ height: 0, opacity: 0 }}
          >
            Expanded content
          </motion.div>
        )}
      </AnimatePresence>
    </motion.div>
  );
}

// Staggered list animations
function AnimatedList({ items }: { items: Item[] }) {
  return (
    <motion.ul
      initial="hidden"
      animate="visible"
      variants={{
        visible: { transition: { staggerChildren: 0.05 } },
      }}
    >
      {items.map((item) => (
        <motion.li
          key={item.id}
          variants={{
            hidden: { opacity: 0, x: -20 },
            visible: { opacity: 1, x: 0 },
          }}
        >
          {item.name}
        </motion.li>
      ))}
    </motion.ul>
  );
}
```

### CSS-Only Animations

```css
/* Prefer CSS for simple micro-interactions */
@keyframes fade-in {
  from { opacity: 0; transform: translateY(8px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes scale-in {
  from { opacity: 0; transform: scale(0.95); }
  to { opacity: 1; transform: scale(1); }
}

.animate-fade-in {
  animation: fade-in var(--duration-normal) var(--ease-spring);
}

.animate-scale-in {
  animation: scale-in var(--duration-normal) var(--ease-spring);
}

/* Respect user preferences */
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

---

## Accessibility Checklist

### Semantic HTML

```tsx
// GOOD: Semantic structure
<article aria-labelledby="post-title">
  <header>
    <h2 id="post-title">{title}</h2>
    <time dateTime={date}>{formattedDate}</time>
  </header>
  <p>{excerpt}</p>
  <footer>
    <a href={`/posts/${slug}`}>Read more<span className="sr-only"> about {title}</span></a>
  </footer>
</article>

// BAD: Div soup
<div className="post">
  <div className="title">{title}</div>
  <div onClick={onClick}>Read more</div>
</div>
```

### Keyboard Navigation

```tsx
// Focus management for modals
function Modal({ isOpen, onClose, children }: ModalProps) {
  const modalRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (isOpen) {
      const previousActiveElement = document.activeElement as HTMLElement;
      modalRef.current?.focus();
      
      return () => previousActiveElement?.focus();
    }
  }, [isOpen]);

  useEffect(() => {
    function handleKeyDown(e: KeyboardEvent) {
      if (e.key === "Escape") onClose();
    }
    
    if (isOpen) {
      document.addEventListener("keydown", handleKeyDown);
      return () => document.removeEventListener("keydown", handleKeyDown);
    }
  }, [isOpen, onClose]);

  if (!isOpen) return null;

  return (
    <div
      ref={modalRef}
      role="dialog"
      aria-modal="true"
      aria-labelledby="modal-title"
      tabIndex={-1}
      className="fixed inset-0 z-50 flex items-center justify-center"
    >
      {children}
    </div>
  );
}
```

### ARIA Patterns

| Element | Required ARIA |
|---------|--------------|
| Icon button | `aria-label="Action description"` |
| Toggle | `aria-pressed="true/false"` |
| Expandable | `aria-expanded="true/false"` + `aria-controls="id"` |
| Tab panel | `role="tablist"` + `role="tab"` + `aria-selected` |
| Live region | `aria-live="polite"` or `role="alert"` |
| Loading | `aria-busy="true"` + `aria-live="polite"` |
| Form error | `aria-invalid="true"` + `aria-describedby="error-id"` |

### Form Accessibility

```tsx
function FormField({ 
  label, 
  error, 
  description,
  required,
  ...inputProps 
}: FormFieldProps) {
  const id = useId();
  const errorId = `${id}-error`;
  const descriptionId = `${id}-description`;

  return (
    <div className="space-y-1.5">
      <label htmlFor={id} className="text-sm font-medium">
        {label}
        {required && <span className="text-error ml-1" aria-hidden>*</span>}
        {required && <span className="sr-only">(required)</span>}
      </label>
      
      {description && (
        <p id={descriptionId} className="text-sm text-muted-foreground">
          {description}
        </p>
      )}
      
      <input
        id={id}
        aria-required={required}
        aria-invalid={!!error}
        aria-describedby={cn(
          description && descriptionId,
          error && errorId
        )}
        className={cn(
          "w-full rounded-md border px-3 py-2",
          error && "border-error focus:ring-error"
        )}
        {...inputProps}
      />
      
      {error && (
        <p id={errorId} role="alert" className="text-sm text-error">
          {error}
        </p>
      )}
    </div>
  );
}
```

---

## Performance Optimization

### Core Web Vitals Targets (2025)

| Metric | Good | Needs Work | Poor |
|--------|------|------------|------|
| **LCP** (Largest Contentful Paint) | ≤2.5s | 2.5-4s | >4s |
| **INP** (Interaction to Next Paint) | ≤200ms | 200-500ms | >500ms |
| **CLS** (Cumulative Layout Shift) | ≤0.1 | 0.1-0.25 | >0.25 |

### Optimizing INP (Interaction to Next Paint)

```tsx
// 1. Use transitions for non-urgent updates
function FilteredList({ items }: { items: Item[] }) {
  const [filter, setFilter] = useState("");
  const [isPending, startTransition] = useTransition();

  function handleFilterChange(value: string) {
    // Urgent: update input immediately
    setFilter(value);
    // Non-urgent: filter list in background
    startTransition(() => {
      // Complex filtering happens without blocking input
    });
  }

  return (
    <div>
      <input value={filter} onChange={(e) => handleFilterChange(e.target.value)} />
      {isPending && <span className="text-muted">Filtering...</span>}
      <List items={filteredItems} />
    </div>
  );
}

// 2. Defer expensive computations
function HeavyComponent() {
  const deferredValue = useDeferredValue(expensiveValue);
  // Renders with stale value first, updates when idle
}

// 3. Break up long tasks
async function processLargeDataset(items: Item[]) {
  const CHUNK_SIZE = 100;
  
  for (let i = 0; i < items.length; i += CHUNK_SIZE) {
    const chunk = items.slice(i, i + CHUNK_SIZE);
    processChunk(chunk);
    
    // Yield to main thread between chunks
    await new Promise(resolve => setTimeout(resolve, 0));
  }
}
```

### Code Splitting & Lazy Loading

```tsx
// Route-level splitting (automatic in App Router)
// app/dashboard/page.tsx - only loads when visiting /dashboard

// Component-level splitting
const HeavyChart = lazy(() => import("@/components/HeavyChart"));
const MarkdownEditor = lazy(() => import("@/components/MarkdownEditor"));

function Dashboard() {
  return (
    <div>
      <QuickStats /> {/* Loads immediately */}
      
      <Suspense fallback={<ChartSkeleton />}>
        <HeavyChart /> {/* Loaded on demand */}
      </Suspense>
    </div>
  );
}

// Dynamic imports for conditional features
async function handleExport() {
  const { exportToPDF } = await import("@/lib/pdf-export");
  await exportToPDF(data);
}
```

### Image Optimization

```tsx
import Image from "next/image";

// ALWAYS use next/image for images
function ProductImage({ src, alt }: { src: string; alt: string }) {
  return (
    <Image
      src={src}
      alt={alt}                    // Required for accessibility
      width={800}                  // Prevents CLS
      height={600}                 // Prevents CLS
      placeholder="blur"           // Show blur while loading
      blurDataURL={blurDataUrl}   // Base64 placeholder
      sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
      priority={false}            // true only for above-fold LCP images
    />
  );
}

// For LCP images (hero, first visible)
<Image priority src={heroImage} alt="Hero" />
```

### Memoization (Use Sparingly)

```tsx
// ONLY memoize when:
// 1. Component re-renders frequently with same props
// 2. Computation is expensive (>10ms)
// 3. You've measured and confirmed the benefit

// Expensive list filtering
const filteredItems = useMemo(() => 
  items
    .filter(item => item.category === selectedCategory)
    .sort((a, b) => a.name.localeCompare(b.name)),
  [items, selectedCategory]
);

// Callback passed to memoized child
const handleItemClick = useCallback((id: string) => {
  selectItem(id);
}, [selectItem]);

// Memoized component
const ExpensiveList = memo(function ExpensiveList({ items }: Props) {
  return items.map(item => <ExpensiveItem key={item.id} {...item} />);
});

// DON'T memoize everything - adds overhead
// DON'T memoize primitives or simple objects
// DON'T memoize without measuring first
```

---

## Component Architecture

### File Structure

```
src/
├── app/                      # App Router
│   ├── (auth)/              # Route groups
│   ├── api/                 # API routes
│   └── layout.tsx
├── components/
│   ├── ui/                  # Primitives (Button, Input, Card)
│   │   ├── button.tsx
│   │   ├── input.tsx
│   │   └── index.ts
│   ├── features/            # Feature components
│   │   ├── auth/
│   │   └── dashboard/
│   └── layouts/             # Layout components
├── hooks/                   # Custom hooks
├── lib/                     # Utilities & helpers
├── types/                   # TypeScript types
└── styles/                  # Global styles
```

### Component Template

```tsx
import { forwardRef } from "react";
import { cn } from "@/lib/utils";

// 1. Types at top
interface CardProps extends React.HTMLAttributes<HTMLDivElement> {
  variant?: "default" | "outlined" | "elevated";
  padding?: "none" | "sm" | "md" | "lg";
}

// 2. Variants/styles
const variants = {
  default: "bg-card border",
  outlined: "bg-transparent border-2",
  elevated: "bg-card shadow-lg border-0",
} as const;

const paddings = {
  none: "",
  sm: "p-3",
  md: "p-4",
  lg: "p-6",
} as const;

// 3. Component with forwardRef for DOM access
const Card = forwardRef<HTMLDivElement, CardProps>(function Card(
  { variant = "default", padding = "md", className, children, ...props },
  ref
) {
  return (
    <div
      ref={ref}
      className={cn(
        "rounded-lg",
        variants[variant],
        paddings[padding],
        className
      )}
      {...props}
    >
      {children}
    </div>
  );
});

Card.displayName = "Card";

export { Card };
export type { CardProps };
```

### Compound Components Pattern

```tsx
// Flexible, composable API
import { createContext, useContext } from "react";

interface TabsContextValue {
  activeTab: string;
  setActiveTab: (id: string) => void;
}

const TabsContext = createContext<TabsContextValue | null>(null);

function useTabs() {
  const context = useContext(TabsContext);
  if (!context) throw new Error("useTabs must be used within Tabs");
  return context;
}

function Tabs({ defaultValue, children }: TabsProps) {
  const [activeTab, setActiveTab] = useState(defaultValue);
  return (
    <TabsContext.Provider value={{ activeTab, setActiveTab }}>
      <div role="tablist">{children}</div>
    </TabsContext.Provider>
  );
}

function TabsTrigger({ value, children }: TabsTriggerProps) {
  const { activeTab, setActiveTab } = useTabs();
  return (
    <button
      role="tab"
      aria-selected={activeTab === value}
      onClick={() => setActiveTab(value)}
    >
      {children}
    </button>
  );
}

function TabsContent({ value, children }: TabsContentProps) {
  const { activeTab } = useTabs();
  if (activeTab !== value) return null;
  return <div role="tabpanel">{children}</div>;
}

// Usage
<Tabs defaultValue="tab1">
  <TabsTrigger value="tab1">Tab 1</TabsTrigger>
  <TabsTrigger value="tab2">Tab 2</TabsTrigger>
  <TabsContent value="tab1">Content 1</TabsContent>
  <TabsContent value="tab2">Content 2</TabsContent>
</Tabs>
```

---

## Clean Code Organization

### Import Order (Strict)

Always order imports consistently:

```tsx
// 1. React/Next.js core
import { useState, useEffect, useCallback } from "react";
import { useRouter } from "next/navigation";
import Image from "next/image";
import Link from "next/link";

// 2. External packages (alphabetical)
import { motion } from "motion/react";
import { useQuery } from "@tanstack/react-query";
import { z } from "zod";

// 3. Internal components
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { UserAvatar } from "@/components/features/user-avatar";

// 4. Hooks
import { useAuth } from "@/hooks/use-auth";
import { useProducts } from "@/hooks/use-products";

// 5. Utils, types, constants
import { cn, formatDate } from "@/lib/utils";
import { API_ENDPOINTS } from "@/lib/constants";
import type { User, Product } from "@/types";

// 6. Styles (if any)
import styles from "./component.module.css";
```

### Component File Structure

Every component file should follow this order:

```tsx
// ============================================
// 1. IMPORTS (ordered as above)
// ============================================
import { forwardRef } from "react";
import { cn } from "@/lib/utils";

// ============================================
// 2. TYPES & INTERFACES
// ============================================
interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: "primary" | "secondary" | "ghost";
  size?: "sm" | "md" | "lg";
  isLoading?: boolean;
}

// ============================================
// 3. CONSTANTS & VARIANTS
// ============================================
const BUTTON_VARIANTS = {
  primary: "bg-primary text-primary-foreground hover:bg-primary/90",
  secondary: "bg-secondary text-secondary-foreground hover:bg-secondary/80",
  ghost: "hover:bg-accent hover:text-accent-foreground",
} as const;

const BUTTON_SIZES = {
  sm: "h-8 px-3 text-sm",
  md: "h-10 px-4",
  lg: "h-12 px-6 text-lg",
} as const;

// ============================================
// 4. HELPER FUNCTIONS (if any)
// ============================================
function getButtonClasses(variant: string, size: string) {
  return cn(BUTTON_VARIANTS[variant], BUTTON_SIZES[size]);
}

// ============================================
// 5. SUBCOMPONENTS (if any)
// ============================================
function ButtonSpinner() {
  return <span className="animate-spin">⏳</span>;
}

// ============================================
// 6. MAIN COMPONENT
// ============================================
const Button = forwardRef<HTMLButtonElement, ButtonProps>(function Button(
  { variant = "primary", size = "md", isLoading, className, children, ...props },
  ref
) {
  return (
    <button
      ref={ref}
      className={cn(getButtonClasses(variant, size), className)}
      disabled={isLoading}
      {...props}
    >
      {isLoading ? <ButtonSpinner /> : children}
    </button>
  );
});

Button.displayName = "Button";

// ============================================
// 7. EXPORTS
// ============================================
export { Button };
export type { ButtonProps };
```

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Components | PascalCase | `UserProfile`, `ProductCard` |
| Hooks | useCamelCase | `useAuth`, `useLocalStorage` |
| Utilities | camelCase | `formatDate`, `calculateTotal` |
| Constants | SCREAMING_SNAKE_CASE | `API_BASE_URL`, `MAX_RETRIES` |
| Types/Interfaces | PascalCase | `User`, `ProductResponse` |
| Files (components) | kebab-case.tsx | `user-profile.tsx` |
| Files (hooks) | use-*.ts | `use-auth.ts` |
| Files (utils) | kebab-case.ts | `format-date.ts` |
| Folders | kebab-case | `user-settings/` |
| CSS classes | kebab-case | `card-header` |
| Event handlers | handleEventName | `handleClick`, `handleSubmit` |
| Boolean props | is/has/can/should | `isLoading`, `hasError`, `canEdit` |

### Single Responsibility

Each file/function/component should do ONE thing well:

```tsx
// ❌ BAD: Component does too much
function UserDashboard() {
  // Fetches data
  // Handles auth
  // Renders UI
  // Manages state
  // Handles errors
  // 400+ lines...
}

// ✅ GOOD: Separated concerns
// hooks/use-dashboard-data.ts
function useDashboardData() { /* data fetching */ }

// components/dashboard/dashboard-header.tsx
function DashboardHeader() { /* just header UI */ }

// components/dashboard/dashboard-stats.tsx
function DashboardStats({ stats }) { /* just stats UI */ }

// components/dashboard/dashboard-activity.tsx
function DashboardActivity({ activities }) { /* just activity UI */ }

// app/dashboard/page.tsx
function DashboardPage() {
  const { data, isLoading, error } = useDashboardData();
  
  return (
    <div>
      <DashboardHeader />
      <DashboardStats stats={data.stats} />
      <DashboardActivity activities={data.activities} />
    </div>
  );
}
```

### Code Grouping

Group related code together:

```tsx
// ❌ BAD: Related code scattered
const [name, setName] = useState("");
const handleSubmit = () => {};
const [email, setEmail] = useState("");
const validateName = () => {};
const [age, setAge] = useState(0);
const validateEmail = () => {};

// ✅ GOOD: Related code grouped
// -- Form State --
const [name, setName] = useState("");
const [email, setEmail] = useState("");
const [age, setAge] = useState(0);

// -- Validation --
const validateName = () => {};
const validateEmail = () => {};

// -- Handlers --
const handleSubmit = () => {};
```

---

## State Management

### State Selection Guide

| Use Case | Solution |
|----------|----------|
| Form state | `react-hook-form` + `zod` |
| Server state | `@tanstack/react-query` or Server Components |
| URL state | `nuqs` or `useSearchParams` |
| Local UI state | `useState` / `useReducer` |
| Global UI state | `zustand` or `jotai` |
| Theme/locale | React Context |

### Server State with React Query

```tsx
// hooks/use-products.ts
export function useProducts(categoryId: string) {
  return useQuery({
    queryKey: ["products", categoryId],
    queryFn: () => fetchProducts(categoryId),
    staleTime: 1000 * 60 * 5, // 5 minutes
    placeholderData: keepPreviousData,
  });
}

export function useCreateProduct() {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: createProduct,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["products"] });
      toast.success("Product created!");
    },
    onError: (error) => {
      toast.error(error.message);
    },
  });
}
```

### Global State with Zustand

```tsx
// stores/ui-store.ts
interface UIStore {
  sidebarOpen: boolean;
  toggleSidebar: () => void;
  theme: "light" | "dark" | "system";
  setTheme: (theme: UIStore["theme"]) => void;
}

export const useUIStore = create<UIStore>()(
  persist(
    (set) => ({
      sidebarOpen: true,
      toggleSidebar: () => set((s) => ({ sidebarOpen: !s.sidebarOpen })),
      theme: "system",
      setTheme: (theme) => set({ theme }),
    }),
    { name: "ui-store" }
  )
);

// Usage
function Sidebar() {
  const { sidebarOpen, toggleSidebar } = useUIStore();
  // ...
}
```

---

## Forms & Validation

### React Hook Form + Zod

```tsx
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";

// 1. Schema
const signupSchema = z.object({
  email: z.string().email("Invalid email address"),
  password: z
    .string()
    .min(8, "Password must be at least 8 characters")
    .regex(/[A-Z]/, "Password must contain an uppercase letter")
    .regex(/[0-9]/, "Password must contain a number"),
  confirmPassword: z.string(),
}).refine((data) => data.password === data.confirmPassword, {
  message: "Passwords don't match",
  path: ["confirmPassword"],
});

type SignupFormData = z.infer<typeof signupSchema>;

// 2. Form component
function SignupForm() {
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
  } = useForm<SignupFormData>({
    resolver: zodResolver(signupSchema),
  });

  async function onSubmit(data: SignupFormData) {
    const result = await signupAction(data);
    if (result.error) {
      toast.error(result.error);
    }
  }

  return (
    <form onSubmit={handleSubmit(onSubmit)} noValidate>
      <FormField
        label="Email"
        type="email"
        error={errors.email?.message}
        {...register("email")}
      />
      <FormField
        label="Password"
        type="password"
        error={errors.password?.message}
        {...register("password")}
      />
      <FormField
        label="Confirm Password"
        type="password"
        error={errors.confirmPassword?.message}
        {...register("confirmPassword")}
      />
      <Button type="submit" disabled={isSubmitting}>
        {isSubmitting ? "Creating account..." : "Sign up"}
      </Button>
    </form>
  );
}
```

### Server Actions with next-safe-action

```tsx
// actions/user.ts
"use server";

import { actionClient } from "@/lib/safe-action";
import { z } from "zod";

export const updateProfile = actionClient
  .schema(z.object({
    name: z.string().min(1),
    bio: z.string().max(500).optional(),
  }))
  .action(async ({ parsedInput, ctx }) => {
    const { name, bio } = parsedInput;
    
    await db.user.update({
      where: { id: ctx.userId },
      data: { name, bio },
    });

    revalidatePath("/profile");
    return { success: true };
  });

// Component usage
function ProfileForm() {
  const { execute, status } = useAction(updateProfile, {
    onSuccess: () => toast.success("Profile updated!"),
    onError: ({ error }) => toast.error(error.serverError),
  });
}
```

---

## Testing Strategy

### Testing Pyramid

```
       E2E (Playwright)           ← Critical user flows
      /                \
    Integration (RTL)              ← Component interactions
   /                    \
  Unit (Vitest)                    ← Pure functions, hooks
```

### Component Testing

```tsx
// __tests__/Button.test.tsx
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { Button } from "@/components/ui/button";

describe("Button", () => {
  it("renders children correctly", () => {
    render(<Button>Click me</Button>);
    expect(screen.getByRole("button", { name: /click me/i })).toBeInTheDocument();
  });

  it("calls onClick when clicked", async () => {
    const handleClick = vi.fn();
    render(<Button onClick={handleClick}>Click me</Button>);
    
    await userEvent.click(screen.getByRole("button"));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });

  it("is disabled when isLoading", () => {
    render(<Button isLoading>Submit</Button>);
    expect(screen.getByRole("button")).toBeDisabled();
    expect(screen.getByRole("button")).toHaveAttribute("aria-busy", "true");
  });

  it("has proper focus styles", async () => {
    render(<Button>Focus me</Button>);
    const button = screen.getByRole("button");
    
    await userEvent.tab();
    expect(button).toHaveFocus();
  });
});
```

### E2E Testing

```tsx
// e2e/auth.spec.ts
import { test, expect } from "@playwright/test";

test.describe("Authentication", () => {
  test("user can sign up and log in", async ({ page }) => {
    await page.goto("/signup");
    
    await page.getByLabel(/email/i).fill("test@example.com");
    await page.getByLabel(/^password$/i).fill("SecurePass123");
    await page.getByLabel(/confirm password/i).fill("SecurePass123");
    await page.getByRole("button", { name: /sign up/i }).click();
    
    await expect(page).toHaveURL("/dashboard");
    await expect(page.getByRole("heading", { name: /welcome/i })).toBeVisible();
  });
});
```

---

## Frontend Security Best Practices

### XSS Prevention

```tsx
// ❌ NEVER: Raw HTML without sanitization
<div dangerouslySetInnerHTML={{ __html: userContent }} />

// ✅ GOOD: Sanitize with DOMPurify when raw HTML is absolutely needed
import DOMPurify from "dompurify";

function SafeHTML({ html }: { html: string }) {
  const sanitized = DOMPurify.sanitize(html, {
    ALLOWED_TAGS: ["b", "i", "em", "strong", "a", "p", "br"],
    ALLOWED_ATTR: ["href", "target", "rel"],
  });
  return <div dangerouslySetInnerHTML={{ __html: sanitized }} />;
}

// ✅ BETTER: Use markdown renderer with sanitization
import ReactMarkdown from "react-markdown";
<ReactMarkdown>{userContent}</ReactMarkdown>

// ❌ NEVER: Direct DOM manipulation
ref.current.innerHTML = userInput;

// ✅ GOOD: Block dangerous URL protocols
function SafeLink({ href, children }: { href: string; children: React.ReactNode }) {
  const isSafe = /^(https?:|mailto:|tel:)/.test(href) || href.startsWith("/");
  if (!isSafe) return <span>{children}</span>;
  return <a href={href}>{children}</a>;
}
```

### CSRF Protection

```tsx
// ❌ NEVER: Auth tokens in localStorage
localStorage.setItem("token", authToken); // Vulnerable to XSS

// ✅ GOOD: HttpOnly + Secure + SameSite cookies
// Set on server:
// Set-Cookie: token=xxx; HttpOnly; Secure; SameSite=Strict; Path=/

// ✅ GOOD: CSRF token for state-changing operations
async function submitForm(data: FormData) {
  const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute("content");
  
  await fetch("/api/submit", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": csrfToken ?? "",
    },
    body: JSON.stringify(data),
    credentials: "include", // Include cookies
  });
}
```

### Authentication & Authorization

```tsx
// ❌ NEVER: Secrets in client-side code
const API_KEY = "sk_live_xxx"; // Exposed in bundle!
const secret = process.env.NEXT_PUBLIC_SECRET; // Also exposed!

// ✅ GOOD: Secrets only on server
// .env (NOT .env.local with NEXT_PUBLIC_)
API_SECRET=sk_live_xxx

// Server Component or API route
const secret = process.env.API_SECRET; // Safe, never sent to client

// ❌ NEVER: Client-only route guards
function ProtectedPage() {
  const { isAuthenticated } = useAuth();
  if (!isAuthenticated) return <Redirect to="/login" />;
  return <SecretContent />; // Content still in bundle!
}

// ✅ GOOD: Server-side authorization
// app/protected/page.tsx
import { redirect } from "next/navigation";
import { getSession } from "@/lib/auth";

export default async function ProtectedPage() {
  const session = await getSession();
  if (!session) redirect("/login");
  
  return <SecretContent />; // Never sent to unauthorized users
}
```

### Next.js App Router Security

```tsx
// ✅ Use server-only for server-exclusive modules
// lib/db.ts
import "server-only";
import { prisma } from "./prisma";
export { prisma }; // Error if imported in client component

// ✅ Treat all inputs as untrusted
export default async function Page({ 
  searchParams 
}: { 
  searchParams: Promise<{ query?: string }> 
}) {
  const { query } = await searchParams;
  
  // Validate before use
  const validatedQuery = z.string().max(100).optional().parse(query);
  // ...
}

// ✅ Server Actions are public endpoints - ALWAYS authorize
"use server";

export async function deletePost(postId: string) {
  const session = await getSession();
  if (!session) throw new Error("Unauthorized");
  
  // Verify ownership
  const post = await db.post.findUnique({ where: { id: postId } });
  if (post?.authorId !== session.userId) {
    throw new Error("Forbidden");
  }
  
  await db.post.delete({ where: { id: postId } });
}
```

### Security Headers

```typescript
// next.config.js
const securityHeaders = [
  {
    key: "Content-Security-Policy",
    value: `
      default-src 'self';
      script-src 'self' 'unsafe-eval' 'unsafe-inline';
      style-src 'self' 'unsafe-inline';
      img-src 'self' blob: data:;
      font-src 'self';
      object-src 'none';
      base-uri 'self';
      form-action 'self';
      frame-ancestors 'none';
      upgrade-insecure-requests;
    `.replace(/\s{2,}/g, " ").trim(),
  },
  { key: "X-Content-Type-Options", value: "nosniff" },
  { key: "X-Frame-Options", value: "DENY" },
  { key: "X-XSS-Protection", value: "1; mode=block" },
  { key: "Referrer-Policy", value: "strict-origin-when-cross-origin" },
  { key: "Permissions-Policy", value: "camera=(), microphone=(), geolocation=()" },
];

module.exports = {
  async headers() {
    return [{ source: "/:path*", headers: securityHeaders }];
  },
  // Disable source maps in production
  productionBrowserSourceMaps: false,
};
```

### Frontend Security Checklist

- [ ] No `dangerouslySetInnerHTML` without DOMPurify sanitization
- [ ] All user inputs validated with Zod/schema before use
- [ ] Auth tokens in HttpOnly cookies (NOT localStorage)
- [ ] CSRF protection on all state-changing operations
- [ ] No secrets in client-side code or `NEXT_PUBLIC_` vars
- [ ] Server-side authorization on all protected routes/actions
- [ ] CSP headers configured properly
- [ ] Source maps disabled in production
- [ ] Dependencies audited regularly (`npm audit`)
- [ ] Error messages don't leak sensitive info
- [ ] Links validated for safe protocols (no `javascript:`)

---

## Backend Security Best Practices

### API Security Fundamentals

```typescript
// Authentication: OAuth 2.0 + OpenID Connect
// Use Authorization Code Flow with PKCE for web/mobile apps
// Use Client Credentials flow for service-to-service

// ✅ JWT Validation - verify ALL claims
import { jwtVerify } from "jose";

async function validateToken(token: string) {
  try {
    const { payload } = await jwtVerify(
      token,
      new TextEncoder().encode(process.env.JWT_SECRET),
      {
        issuer: "https://your-app.com",
        audience: "your-api",
        algorithms: ["HS256"],
      }
    );
    
    // Check expiration
    if (payload.exp && payload.exp < Date.now() / 1000) {
      throw new Error("Token expired");
    }
    
    return payload;
  } catch {
    throw new Error("Invalid token");
  }
}
```

### Authorization & Access Control

```typescript
// ✅ RBAC Implementation
type Role = "admin" | "editor" | "viewer";
type Permission = "create" | "read" | "update" | "delete";

const ROLE_PERMISSIONS: Record<Role, Permission[]> = {
  admin: ["create", "read", "update", "delete"],
  editor: ["create", "read", "update"],
  viewer: ["read"],
};

function hasPermission(userRole: Role, requiredPermission: Permission): boolean {
  return ROLE_PERMISSIONS[userRole]?.includes(requiredPermission) ?? false;
}

// ✅ Middleware pattern
async function requirePermission(permission: Permission) {
  return async (req: Request) => {
    const session = await getSession(req);
    if (!session) {
      return new Response("Unauthorized", { status: 401 });
    }
    
    if (!hasPermission(session.role, permission)) {
      return new Response("Forbidden", { status: 403 });
    }
    
    return null; // Continue to handler
  };
}
```

### SQL Injection Prevention

```typescript
// ❌ NEVER: String concatenation
const query = `SELECT * FROM users WHERE email = '${email}'`; // SQL Injection!

// ✅ GOOD: Parameterized queries
// With Prisma
const user = await prisma.user.findUnique({
  where: { email: validatedEmail },
});

// With Drizzle
const users = await db.select()
  .from(usersTable)
  .where(eq(usersTable.email, validatedEmail));

// With raw SQL (parameterized)
const result = await sql`
  SELECT * FROM users WHERE email = ${validatedEmail}
`;

// ✅ Always validate inputs first
import { z } from "zod";

const emailSchema = z.string().email().max(255);
const validatedEmail = emailSchema.parse(userInput);
```

### Node.js / Express Security

```typescript
// Required security middleware
import helmet from "helmet";
import rateLimit from "express-rate-limit";
import cors from "cors";
import { randomBytes } from "crypto";

const app = express();

// Security headers
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      scriptSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
    },
  },
}));

// CORS - be specific
app.use(cors({
  origin: ["https://your-frontend.com"],
  credentials: true,
  methods: ["GET", "POST", "PUT", "DELETE"],
}));

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // Limit each IP
  standardHeaders: true,
  legacyHeaders: false,
});
app.use(limiter);

// Stricter rate limit for auth endpoints
const authLimiter = rateLimit({
  windowMs: 60 * 60 * 1000, // 1 hour
  max: 5, // 5 attempts per hour
  message: "Too many login attempts, please try again later",
});
app.use("/api/auth", authLimiter);

// Don't reveal technology stack
app.disable("x-powered-by");

// Session security
app.use(session({
  name: randomBytes(8).toString("hex"), // Random session name
  secret: process.env.SESSION_SECRET!,
  cookie: {
    httpOnly: true,
    secure: process.env.NODE_ENV === "production",
    sameSite: "strict",
    maxAge: 24 * 60 * 60 * 1000, // 24 hours
  },
  resave: false,
  saveUninitialized: false,
}));
```

### Python (FastAPI/Django) Security

```python
# FastAPI Security
from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from pydantic import BaseModel, EmailStr, Field
import jwt

app = FastAPI(
    # Lock down docs in production
    docs_url="/docs" if DEBUG else None,
    redoc_url="/redoc" if DEBUG else None,
)

# Pydantic validation for ALL inputs
class UserCreate(BaseModel):
    email: EmailStr
    password: str = Field(min_length=8, max_length=128)
    
# JWT validation
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

async def get_current_user(token: str = Depends(oauth2_scheme)):
    try:
        payload = jwt.decode(
            token, 
            SECRET_KEY, 
            algorithms=["HS256"],
            audience="your-api",
        )
        return payload
    except jwt.InvalidTokenError:
        raise HTTPException(status_code=401, detail="Invalid token")
```

```python
# Django Security Settings
# settings.py

DEBUG = False  # NEVER True in production

ALLOWED_HOSTS = ["your-domain.com", "www.your-domain.com"]

# Security cookies
SESSION_COOKIE_SECURE = True
SESSION_COOKIE_HTTPONLY = True
CSRF_COOKIE_SECURE = True
CSRF_COOKIE_HTTPONLY = True

# HTTPS
SECURE_SSL_REDIRECT = True
SECURE_HSTS_SECONDS = 31536000  # 1 year
SECURE_HSTS_INCLUDE_SUBDOMAINS = True
SECURE_HSTS_PRELOAD = True

# Content security
SECURE_CONTENT_TYPE_NOSNIFF = True
X_FRAME_OPTIONS = "DENY"
```

### Error Handling

```typescript
// ❌ NEVER: Leak internal errors
app.use((err, req, res, next) => {
  res.status(500).json({
    error: err.message,        // May contain sensitive info!
    stack: err.stack,          // Never in production!
    query: req.query,          // Don't echo input
  });
});

// ✅ GOOD: Generic client errors, detailed server logs
import { logger } from "@/lib/logger";

app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  // Log full details server-side
  logger.error({
    message: err.message,
    stack: err.stack,
    path: req.path,
    method: req.method,
    userId: req.user?.id,
    traceId: req.headers["x-trace-id"],
  });
  
  // Generic error to client
  const statusCode = err instanceof AppError ? err.statusCode : 500;
  res.status(statusCode).json({
    error: statusCode === 500 
      ? "An unexpected error occurred" 
      : err.message,
    traceId: req.headers["x-trace-id"], // For support tickets
  });
});
```

### Backend Security Checklist

- [ ] OAuth 2.0 / OIDC for authentication
- [ ] JWT tokens validated with all claims (iss, aud, exp)
- [ ] RBAC/ABAC implemented for authorization
- [ ] Authorization checked on EVERY endpoint
- [ ] Parameterized queries only (no string concatenation)
- [ ] All inputs validated with schemas (Zod, Pydantic)
- [ ] Rate limiting on all endpoints, stricter on auth
- [ ] Helmet/security headers configured
- [ ] CORS properly restricted
- [ ] Session cookies: HttpOnly, Secure, SameSite
- [ ] No sensitive data in error responses
- [ ] Detailed errors logged server-side only
- [ ] Dependencies scanned for vulnerabilities
- [ ] Running on LTS Node.js/Python versions
- [ ] Non-root user in containers

---

## Database Design Best Practices

### PostgreSQL

#### Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| Tables | plural snake_case | `users`, `order_items` |
| Columns | singular snake_case | `user_id`, `created_at` |
| Primary keys | `id` or `{table}_id` | `id`, `user_id` |
| Foreign keys | `{referenced_table}_id` | `user_id`, `order_id` |
| Indexes | `idx_{table}_{columns}` | `idx_users_email` |
| Unique constraints | `uq_{table}_{columns}` | `uq_users_email` |
| Check constraints | `chk_{table}_{column}` | `chk_users_age` |

#### Schema Design

```sql
-- Good: Proper naming, types, and constraints
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  display_name VARCHAR(100),
  role VARCHAR(20) NOT NULL DEFAULT 'user',
  email_verified_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  -- Constraints
  CONSTRAINT uq_users_email UNIQUE (email),
  CONSTRAINT chk_users_email CHECK (email ~* '^.+@.+\..+$'),
  CONSTRAINT chk_users_role CHECK (role IN ('admin', 'editor', 'user'))
);

-- Proper indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role) WHERE role != 'user';
CREATE INDEX idx_users_created_at ON users(created_at DESC);

-- Foreign key with proper naming
CREATE TABLE posts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  author_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  content TEXT,
  published_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  -- Indexes for common queries
  CONSTRAINT fk_posts_author FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE INDEX idx_posts_author_id ON posts(author_id);
CREATE INDEX idx_posts_published_at ON posts(published_at DESC) 
  WHERE published_at IS NOT NULL;
```

#### Indexing Strategy

```sql
-- Index columns used in WHERE, ORDER BY, JOIN
-- ✅ Good: Supports common queries
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created_at ON orders(created_at DESC);

-- Compound index for multi-column queries
CREATE INDEX idx_orders_user_status ON orders(user_id, status);

-- Partial index for filtered queries
CREATE INDEX idx_orders_pending ON orders(created_at) 
  WHERE status = 'pending';

-- Verify index usage
EXPLAIN ANALYZE SELECT * FROM orders WHERE user_id = 'xxx';
```

### MongoDB

#### Schema Design Principles

```javascript
// Design around access patterns

// ✅ Embed: one-to-few, always accessed together
{
  _id: ObjectId("..."),
  email: "user@example.com",
  profile: {  // Embedded - always fetched with user
    displayName: "John Doe",
    avatar: "https://...",
    bio: "..."
  },
  addresses: [  // Embedded - few items, always needed
    { type: "home", street: "...", city: "..." },
    { type: "work", street: "...", city: "..." }
  ]
}

// ✅ Reference: one-to-many, high cardinality, shared data
{
  _id: ObjectId("..."),
  email: "user@example.com",
  // Reference - many orders, not always needed
  // orderIds: [...] // Don't embed - unbounded array!
}

// Separate orders collection
{
  _id: ObjectId("..."),
  userId: ObjectId("..."),  // Reference to user
  items: [...],
  total: 99.99,
  createdAt: ISODate("...")
}
```

#### Schema Validation

```javascript
db.createCollection("users", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["email", "passwordHash", "createdAt"],
      properties: {
        email: {
          bsonType: "string",
          pattern: "^.+@.+\\..+$",
          description: "Must be a valid email"
        },
        passwordHash: {
          bsonType: "string",
          minLength: 60,
          description: "Must be a bcrypt hash"
        },
        role: {
          enum: ["admin", "editor", "user"],
          description: "Must be a valid role"
        },
        createdAt: {
          bsonType: "date"
        }
      }
    }
  }
});

// Indexes
db.users.createIndex({ email: 1 }, { unique: true });
db.users.createIndex({ createdAt: -1 });
db.orders.createIndex({ userId: 1, createdAt: -1 });
```

### Database Security

```sql
-- PostgreSQL: Use roles with least privilege
CREATE ROLE app_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO app_readonly;

CREATE ROLE app_readwrite;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO app_readwrite;

-- Never use superuser for application connections
-- Use connection pooling (PgBouncer, Prisma)
-- Enable SSL for connections
-- Encrypt sensitive columns (PII, payment data)
```

### Database Checklist

- [ ] Consistent naming conventions (snake_case for SQL)
- [ ] Proper data types (UUID, TIMESTAMPTZ, JSONB)
- [ ] Constraints: NOT NULL, UNIQUE, CHECK, FOREIGN KEY
- [ ] Indexes on columns used in WHERE, ORDER BY, JOIN
- [ ] No unbounded arrays (MongoDB 16MB limit)
- [ ] Schema validation enabled (MongoDB)
- [ ] Connection pooling configured
- [ ] SSL/TLS for connections
- [ ] Least privilege database users
- [ ] Sensitive data encrypted
- [ ] Regular backups tested

---

## Logging & Observability

### Structured Logging

```typescript
// ✅ Use structured JSON logs
import pino from "pino";

const logger = pino({
  level: process.env.LOG_LEVEL || "info",
  formatters: {
    level: (label) => ({ level: label }),
  },
  timestamp: () => `,"timestamp":"${new Date().toISOString()}"`,
  // CRITICAL: Redact sensitive fields
  redact: {
    paths: ["password", "token", "authorization", "cookie", "*.password", "*.token"],
    censor: "[REDACTED]",
  },
  // Add base context
  base: {
    service: process.env.SERVICE_NAME || "api",
    environment: process.env.NODE_ENV || "development",
    version: process.env.APP_VERSION || "unknown",
  },
});

// Usage with context
logger.info({
  userId: user.id,
  action: "user_login",
  traceId: req.headers["x-trace-id"],
  duration: Date.now() - startTime,
}, "User logged in successfully");

// Error logging with full context
logger.error({
  err: error,
  userId: user?.id,
  path: req.path,
  method: req.method,
  traceId: req.headers["x-trace-id"],
}, "Failed to process request");
```

```python
# Python with structlog
import structlog

structlog.configure(
    processors=[
        structlog.stdlib.filter_by_level,
        structlog.stdlib.add_logger_name,
        structlog.stdlib.add_log_level,
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.JSONRenderer()
    ],
)

logger = structlog.get_logger()

# Usage
logger.info(
    "user_logged_in",
    user_id=user.id,
    action="login",
    trace_id=request.headers.get("x-trace-id"),
    duration_ms=duration,
)
```

### Required Log Context

Every log entry MUST include:

| Field | Description | Example |
|-------|-------------|---------|
| `timestamp` | UTC, ISO 8601, ms precision | `2024-01-15T10:30:45.123Z` |
| `level` | Log severity | `INFO`, `ERROR` |
| `service` | Service/component name | `api`, `worker` |
| `traceId` | Request correlation ID | `abc123-def456` |
| `environment` | Deployment environment | `production`, `staging` |
| `message` | Human-readable description | `User logged in` |

### Log Levels

| Level | When to Use | Example |
|-------|-------------|---------|
| DEBUG | Development only, verbose | Variable values, flow tracing |
| INFO | Normal operations | User actions, API calls |
| WARN | Anomalies, recoverable | Rate limit approached, retry succeeded |
| ERROR | Failures needing attention | API errors, validation failures |
| FATAL | Application crash | Unrecoverable errors, process exit |

### Request Logging Middleware

```typescript
// Middleware for request/response logging
function requestLogger(req: Request, res: Response, next: NextFunction) {
  const startTime = Date.now();
  const traceId = req.headers["x-trace-id"] || crypto.randomUUID();
  
  // Add traceId to request for downstream use
  req.traceId = traceId;
  res.setHeader("x-trace-id", traceId);
  
  // Log request
  logger.info({
    type: "request",
    traceId,
    method: req.method,
    path: req.path,
    query: req.query,
    userAgent: req.headers["user-agent"],
    ip: req.ip,
  });
  
  // Log response on finish
  res.on("finish", () => {
    const duration = Date.now() - startTime;
    const logLevel = res.statusCode >= 500 ? "error" : 
                     res.statusCode >= 400 ? "warn" : "info";
    
    logger[logLevel]({
      type: "response",
      traceId,
      method: req.method,
      path: req.path,
      statusCode: res.statusCode,
      duration,
    });
  });
  
  next();
}
```

### Security in Logging

```typescript
// ❌ NEVER log sensitive data
logger.info({ password: user.password }); // NEVER!
logger.info({ token: authToken }); // NEVER!
logger.info({ creditCard: cardNumber }); // NEVER!
logger.info({ ssn: socialSecurityNumber }); // NEVER!

// ✅ GOOD: Log only safe identifiers
logger.info({
  userId: user.id,
  email: maskEmail(user.email), // j***@example.com
  action: "payment_processed",
  amount: transaction.amount,
  // cardLast4: "4242" // Only last 4 if needed
});

// Helper for masking
function maskEmail(email: string): string {
  const [local, domain] = email.split("@");
  return `${local[0]}***@${domain}`;
}
```

### Observability Stack

```typescript
// OpenTelemetry setup for traces + metrics + logs
import { NodeSDK } from "@opentelemetry/sdk-node";
import { getNodeAutoInstrumentations } from "@opentelemetry/auto-instrumentations-node";
import { OTLPTraceExporter } from "@opentelemetry/exporter-trace-otlp-http";

const sdk = new NodeSDK({
  traceExporter: new OTLPTraceExporter({
    url: process.env.OTEL_EXPORTER_OTLP_ENDPOINT,
  }),
  instrumentations: [getNodeAutoInstrumentations()],
  serviceName: process.env.SERVICE_NAME,
});

sdk.start();

// Include traceId in all logs for correlation
import { trace } from "@opentelemetry/api";

function getTraceId(): string {
  const span = trace.getActiveSpan();
  return span?.spanContext().traceId || "no-trace";
}
```

### Logging Checklist

- [ ] Structured JSON logs (not plain text)
- [ ] Consistent schema across all services
- [ ] Required fields: timestamp, level, service, traceId
- [ ] Sensitive data redacted (passwords, tokens, PII)
- [ ] Request/response logging with duration
- [ ] Error logs include stack traces (server-side only)
- [ ] Log levels used appropriately
- [ ] TraceId propagated across services
- [ ] Logs shipped to centralized system
- [ ] Alerts configured for ERROR/FATAL levels

---

## Anti-Patterns to Avoid

```tsx
// ❌ BAD: "use client" everywhere
"use client"; // Don't add this unless needed!

// ❌ BAD: Div with onClick
<div onClick={handleClick}>Click me</div>
// ✅ GOOD: Button element
<button onClick={handleClick}>Click me</button>

// ❌ BAD: Missing loading/error states
{data && <List items={data} />}
// ✅ GOOD: Handle all states
<DataDisplay data={data} isLoading={isLoading} error={error}>
  {(items) => <List items={items} />}
</DataDisplay>

// ❌ BAD: Index as key for dynamic lists
{items.map((item, i) => <Item key={i} />)}
// ✅ GOOD: Stable unique key
{items.map((item) => <Item key={item.id} />)}

// ❌ BAD: Inline objects/functions in JSX
<Component style={{ padding: 16 }} onClick={() => doThing(id)} />
// ✅ GOOD: Stable references
<Component style={styles} onClick={handleClick} />

// ❌ BAD: Sequential fetches
const user = await getUser();
const posts = await getPosts(user.id);
// ✅ GOOD: Parallel when possible
const [user, settings] = await Promise.all([getUser(), getSettings()]);

// ❌ BAD: Prop drilling through many levels
<App user={user}>
  <Layout user={user}>
    <Sidebar user={user}>
      <UserAvatar user={user} />
// ✅ GOOD: Context or composition
<UserProvider value={user}>
  <App>
    <Layout>
      <Sidebar>
        <UserAvatar /> {/* Uses context */}

// ❌ BAD: Memoizing everything
const value = useMemo(() => x + 1, [x]); // Simple math, not needed
// ✅ GOOD: Memoize only expensive operations
const sorted = useMemo(() => items.sort(complexSort), [items]);
```

---

## Quick Reference

| Need | Solution |
|------|----------|
| Button | `<button>` with all states |
| Link navigation | `<Link>` from next/link |
| Icon button | `<button aria-label="...">` |
| Form field | `<label>` + `<input>` + error handling |
| Dynamic content | `aria-live="polite"` |
| Modal | Focus trap + `aria-modal` + Escape |
| Loading | Skeleton + `aria-busy` |
| Error message | `role="alert"` |
| Instant feedback | `useOptimistic` |
| Form status | `useFormStatus` |
| Non-blocking update | `useTransition` |
| Server data | Server Component or React Query |
| Animation | Motion library or CSS transitions |

---

## Review Checklist

Before completing any fullstack work:

### Planning & Analysis (BEFORE coding)
- [ ] Understood what user ACTUALLY needs vs what they asked for
- [ ] Defined scope: what's in, what's out, what assumptions
- [ ] Broke down into components/modules
- [ ] Identified dependencies and implementation order
- [ ] Assessed risks and edge cases
- [ ] Created prioritized task list

### Problem Analysis (When debugging/fixing)
- [ ] Can reproduce the issue consistently
- [ ] Isolated to smallest code path
- [ ] Understood root cause, not just symptoms
- [ ] Researched for known issues/solutions
- [ ] Planned minimal fix with verification strategy

### Image Analysis (When Reference Provided)
- [ ] Thoroughly analyzed every visual element in reference image
- [ ] Extracted exact colors, fonts, spacing, shadows, radii
- [ ] Identified the design system/aesthetic style
- [ ] Documented distinctive elements that make it unique
- [ ] Planned performance-optimized recreation (CSS over images)
- [ ] Identified or researched fonts accurately

### Design Thinking
- [ ] Clear aesthetic direction chosen (not generic/default)
- [ ] Distinctive typography (NO Inter/Roboto/Arial)
- [ ] Bold color story (dominant + sharp accent)
- [ ] Memorable visual element (what will users remember?)
- [ ] Implementation complexity matches aesthetic vision
- [ ] NO generic AI patterns (purple gradients, centered everything, etc.)

### Architecture
- [ ] Server Components used by default, "use client" only when needed
- [ ] Proper Suspense boundaries for streaming
- [ ] No sequential data fetching waterfalls

### Visual
- [ ] Polished UI with consistent design tokens
- [ ] All interactive states (hover, focus, active, disabled)
- [ ] Smooth transitions (150-300ms)
- [ ] Loading skeletons, error states, empty states
- [ ] Atmospheric backgrounds (gradients, textures, patterns)
- [ ] Unexpected layouts (asymmetry, overlap, grid-breaking)

### Animation
- [ ] Orchestrated page load with staggered reveals
- [ ] Scroll-triggered reveals for below-fold content
- [ ] Delightful hover states that surprise
- [ ] Respects prefers-reduced-motion

### Accessibility
- [ ] Semantic HTML elements
- [ ] Keyboard navigable (Tab, Enter, Escape)
- [ ] Screen reader friendly (ARIA labels, live regions)
- [ ] Color contrast ≥4.5:1

### Performance
- [ ] INP ≤200ms, LCP ≤2.5s, CLS ≤0.1
- [ ] Images optimized with next/image
- [ ] Code splitting for heavy components
- [ ] No unnecessary re-renders

### Code Quality & Organization
- [ ] Full TypeScript with proper types (no `any`)
- [ ] No console errors or warnings
- [ ] Components under 150 lines
- [ ] Tests for critical functionality
- [ ] Imports ordered correctly (React → external → internal)
- [ ] Consistent naming conventions
- [ ] No code slop (duplicate code, magic numbers, commented code)

### Frontend Security
- [ ] No `dangerouslySetInnerHTML` without sanitization
- [ ] All user inputs validated with Zod/schema
- [ ] Auth tokens in HttpOnly cookies (not localStorage)
- [ ] CSRF protection on state-changing operations
- [ ] No secrets in client-side code or `NEXT_PUBLIC_` vars
- [ ] Server-side authorization on all protected routes/actions
- [ ] CSP headers configured
- [ ] Links validated for safe protocols

### Backend Security
- [ ] OAuth 2.0 / JWT with proper validation
- [ ] Authorization checked on EVERY endpoint
- [ ] Parameterized queries only (no SQL concatenation)
- [ ] All inputs validated with schemas
- [ ] Rate limiting on all endpoints
- [ ] Security headers configured (Helmet)
- [ ] No sensitive data in error responses
- [ ] Session cookies: HttpOnly, Secure, SameSite

### Database
- [ ] Consistent naming conventions
- [ ] Proper data types and constraints
- [ ] Indexes on frequently queried columns
- [ ] No unbounded arrays (MongoDB)
- [ ] Connection pooling configured
- [ ] Least privilege database users

### Logging & Observability
- [ ] Structured JSON logs
- [ ] Required fields: timestamp, level, service, traceId
- [ ] Sensitive data redacted
- [ ] Request/response logging with duration
- [ ] TraceId propagated across services
- [ ] Alerts configured for errors

### Documentation
- [ ] FILETREE.md generated/updated for significant changes
- [ ] All directories have descriptions
- [ ] Components documented with props
- [ ] Hooks documented with return values
- [ ] API endpoints listed
- [ ] Environment variables documented
- [ ] Scripts section included

---

## Remember

Claude is capable of extraordinary creative work. Don't hold back - show what can truly be created when thinking outside the box and committing fully to a distinctive vision.

**Every interface should be UNFORGETTABLE. No two designs should look the same. Vary between light and dark themes, different fonts, different aesthetics. NEVER converge on common choices across generations.**

**Every backend should be SECURE and OBSERVABLE. Security is not optional - it's built in from the start.**
