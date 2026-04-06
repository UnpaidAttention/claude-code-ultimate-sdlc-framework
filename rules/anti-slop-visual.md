---
trigger: conditional
load_when: "Wave 5 UI work, Audit T3 GUI Analysis, Validation E4 UX Polish, or any workflow with UI/frontend skills loaded"
---

# Anti-Slop Rules — Visual & UI (P0)

Every pattern below is BANNED. No exceptions unless the user explicitly approves. Flag violations as: `ANTI-SLOP VIOLATION: visual - [category] - [pattern]`

## 1. TYPOGRAPHY

**Banned fonts (absolute):** Inter, Roboto, Open Sans, Lato, Arial, system-ui, sans-serif, Space Grotesk.

**Banned behaviors:**
- Weight timidity (only 400-600) — use extremes: 100-200 against 800-900
- Modest heading scale (~1.5x body) — use 2.5x+ for drama
- Flat letter-spacing (same on all text) — tight on heroes (-0.02em), wide on labels (0.06-0.1em)
- Single-font syndrome — pair display + body (serif/sans, geometric/humanist)
- No line-height variation across element types

**Required:** Declare a display+body font pairing. Display: Playfair Display, Clash Display, Fraunces, Instrument Serif, Monument Extended, Recoleta. Body: Source Serif 4, Satoshi, DM Sans, Cabinet Grotesk, Literata, Lora. Mono: IBM Plex Mono, Fira Code, JetBrains Mono.

## 2. COLOR

**Absolute bans:**
- Purple-to-blue gradients, indigo/violet accents, `bg-indigo-*`/`bg-violet-*`/`bg-purple-*` as primary
- Specific shades: `#6366f1`, `#8b5cf6`, `#3b82f6`, gradient text with purple-blue fills
- Tailwind default colors as primary palette without redefinition (`blue-500`, `slate-*`)

**Banned behaviors:**
- Timid palette: safe grays/blues with no commitment — need dominant (85-95%) + sharp accent (5-15%)
- Even pastel distribution with no hierarchy or tension
- No CSS custom properties for colors
- Context-blind palette (tech-purple on a seafood restaurant)
- Neon-on-dark without purpose (cyan+purple on dark = cliche)
- Cold whites: pure `#ffffff` — use warm off-whites (`#faf9f6`). Pure `#000000` — use near-black with undertone (`#0D0D14`)

## 3. LAYOUT

**Absolute bans:**
- Three-box trinity: 3 cards/boxes with icons in symmetrical grid, same size/padding/radius/shadow
- Hero formula: centered big headline → subheadline → single CTA on white/gray background

**Banned behaviors:**
- Identical element treatment (same padding, heights, radius, shadow on everything)
- No asymmetry — everything centered and balanced
- Stat box bloat: single-number containers with no sparklines/comparisons/progress
- Hero metric layout: big number + small label + gradient accent = 90% of AI dashboards
- Clutter instinct: more elements than needed — edit ruthlessly
- Bento grid as default without content justification
- Predictable left-right-left-right section alternation

## 4. SHADOW & DEPTH

- Uniform shadow on every element — use hierarchy: flush → subtle → raised → floating → dramatic
- Shadow-as-decoration with no spatial reasoning
- Gray-only shadows (`rgba(0,0,0,x)`) — use colored shadows matching palette
- No shadow transitions on hover/click
- Blur-everything: `backdrop-filter: blur()` everywhere — glass ONLY where transparency serves hierarchy

## 5. CORNERS & BORDERS

- Rounded corner monoculture: `8px` or `16px` on everything — mix sharp and soft intentionally
- Card nesting: cards inside cards (3+ levels)
- Pill shape overuse: `9999px` on buttons/badges/tags/inputs indiscriminately
- Uniform borders: all solid 1px gray — vary weight, style, color

## 6. BACKGROUND

- Flat wasteland: solid `#ffffff` or `#f5f5f5` with no texture/depth — add noise, gradients, patterns
- Cold white/black: use warm off-whites and near-blacks with undertone
- Gradient-only backgrounds — use textures, patterns, layered elements
- No atmospheric relationship to project domain

## 7. MOTION & ANIMATION

- Motion desert (zero animation) OR motion circus (everything animates identically)
- Same `fade-in-up` on every element — stagger delays, orchestrate reveals
- `ease-in-out` only — use custom cubic-bezier curves
- Uncalibrated durations — micro: 100-200ms, state: 200-400ms, page: 400-800ms
- Hover = color change only — include lift, shadow, scale, or revealed detail
- No press states — buttons must scale ~0.97, differentiate hover/active/focus

## 8. MODALS & DIALOGS

- Generic modal: centered white box, `rgba(0,0,0,0.5)` overlay, no animation, generic "X" close
- "Are you sure?" confirmation for everything — use inline confirms, undo, progressive disclosure
- Alert modals for non-critical info — use inline notifications or toasts
- No modal vs drawer vs inline decision per context

## 9. DASHBOARD-SPECIFIC

- Template structure: dark left sidebar + top bar (search/bell/avatar) + stat cards → chart → table
- Default Chart.js/Recharts with no customization — customize axes, tooltips, colors
- Only line/bar charts — consider creative visualizations for the data type
- Zebra-striped tables only — add sorting, column grouping, density options
- Dark sidebar with icon+label, active=background-color-only — create nav group hierarchy

## 10. COMPONENTS

**Buttons:** No blue/purple primary + gray secondary. No `padding:8px 16px; border-radius:8px` on everything. Hover must be multi-property, not "slightly darker." No generic labels ("Get Started"/"Learn More"/"Sign Up") — be specific.

**Forms:** No gray bordered rectangles with blue-outline focus. Integrate errors into design, not just red text below. Vary label treatments.

**Navigation:** No logo-left/links-center/CTA-right without variation. No standard hamburger on mobile without creativity.

**Cards:** No image-top/title/desc/button-bottom always. `translateY(-4px)` hover is an AI signature — never use it. Vary card types: horizontal, compact, expanded, media-forward.

**Toasts:** No green/red/yellow rectangle in corner auto-dismissing 3s. Differentiate severity beyond color. Include brand voice.

## 11. COPY & CONTENT

**Banned headlines:** "Build the future of X", "Your all-in-one X", "Scale without limits", "Empowering [noun] with [adj] [noun]", "Revolutionize your X", "The [adj] way to [verb]", "Your [noun] journey starts here"

**Banned CTAs:** "Get Started", "Learn More", "Sign Up", "Try Free" — specify what happens on click.

**Banned descriptions:** "Powerful analytics to drive decisions", "Seamless integration", "Built for teams of all sizes" — any vague, interchangeable copy.

**Banned buzzwords:** Orchestrate, Empower, Elevate, Supercharge, Seamlessly, Effortlessly, Revolutionize, Leverage, Unlock, Transform, Streamline, Next-gen, Cutting-edge, State-of-the-art

## 12. IMAGERY & ICONS

Banned: abstract 3D blobs, isometric office illustrations, Lucide/Heroicons defaults without customization, icons as decoration, emoji placeholders (rocket/chart/lightbulb/lightning), random gradient circles in corners, floating geometric shapes, grid dot patterns overlaying content.

## 13. DARK MODE

- No lazy inversion (`#fff`→`#000`) — use near-black with undertone (`#0D0D14`)
- No pure white text — use off-white (`#E8E8F0`)
- Adjust shadows for dark context (black shadows are invisible on dark)
- Differentiate card/surface layers with subtle color variation
- Adjust accent saturation/lightness for dark context

## 14. RESPONSIVE

- No binary breakpoints (3-col → 1-col, nothing between)
- No uniform spacing at all breakpoints
- Touch targets must be 44x44px minimum
- No sidebar→hamburger as only mobile strategy
- Use spacing scale (4,8,12,16,24,32,48,64px) with hierarchy

## 15. TREND ABUSE

- Glassmorphism everywhere — glass ONLY where transparency serves purpose
- Neumorphism — causes usability problems
- Bento grid as default "modern" layout without content justification

## 16. REQUIRED STATES

Missing these is slop: loading states, error states, empty states, disabled states, skeleton screens, ARIA labels, keyboard navigation, visible focus indicators, WCAG AA contrast, `prefers-reduced-motion` support, color never as sole indicator.

## 30-Second Slop Test

Three or more = reject and redo: (1) Generic font (2) Purple/indigo accent (3) Three equal icon cards (4) Uniform radius+shadow on everything (5) White/gray background with no atmosphere.
