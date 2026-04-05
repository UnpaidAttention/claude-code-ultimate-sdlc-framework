# Color System Reference

> Color theory principles, selection process, and decision-making guidelines.
> **No memorized hex codes - learn to THINK about color.**

---

## 1. Color Theory Fundamentals

### The Color Wheel

```
                    YELLOW
                      │
           Yellow-    │    Yellow-
           Green      │    Orange
              ╲       │       ╱
               ╲      │      ╱
    GREEN ─────────── ● ─────────── ORANGE
               ╱      │      ╲
              ╱       │       ╲
           Blue-      │    Red-
           Green      │    Orange
                      │
                     RED
                      │
                   PURPLE
                  ╱       ╲
             Blue-         Red-
             Purple        Purple
                  ╲       ╱
                    BLUE
```

### Color Relationships

| Scheme | How to Create | When to Use |
|--------|---------------|-------------|
| **Monochromatic** | Pick ONE hue, vary only lightness/saturation | Minimal, professional, cohesive |
| **Analogous** | Pick 2-3 ADJACENT hues on wheel | Harmonious, calm, nature-inspired |
| **Complementary** | Pick OPPOSITE hues on wheel | High contrast, vibrant, attention |
| **Split-Complementary** | Base + 2 colors adjacent to complement | Dynamic but balanced |
| **Triadic** | 3 hues EQUIDISTANT on wheel | Vibrant, playful, creative |

### How to Choose a Scheme:
1. **What's the project mood?** Calm → Analogous. Bold → Complementary.
2. **How many colors needed?** Minimal → Monochromatic. Complex → Triadic.
3. **Who's the audience?** Conservative → Monochromatic. Young → Triadic.

---

## 2. The 60-30-10 Rule

### Distribution Principle
```
┌─────────────────────────────────────────────────┐
│                                                 │
│     60% PRIMARY (Background, large areas)       │
│     → Should be neutral or calming              │
│     → Carries the overall tone                  │
│                                                 │
├────────────────────────────────────┬────────────┤
│                                    │            │
│   30% SECONDARY                    │ 10% ACCENT │
│   (Cards, sections, headers)       │ (CTAs,     │
│   → Supports without dominating    │ highlights)│
│                                    │ → Draws    │
│                                    │   attention│
└────────────────────────────────────┴────────────┘
```

### Implementation Pattern
```css
:root {
  /* 60% - Pick based on light/dark mode and mood */
  --color-bg: /* neutral: white, off-white, or dark gray */
  --color-surface: /* slightly different from bg */
  
  /* 30% - Pick based on brand or context */
  --color-secondary: /* muted version of primary or neutral */
  
  /* 10% - Pick based on desired action/emotion */
  --color-accent: /* vibrant, attention-grabbing */
}
```

---

## 3. Color Psychology - Meaning & Selection

### How to Choose Based on Context

| If Project Is... | Consider These Hues | Why |
|------------------|---------------------|-----|
| **Finance, Tech, Healthcare** | Blues, Teals | Trust, stability, calm |
| **Eco, Wellness, Nature** | Greens, Earth tones | Growth, health, organic |
| **Food, Energy, Youth** | Orange, Yellow, Warm | Appetite, excitement, warmth |
| **Luxury, Beauty, Creative** | Deep Teal, Gold, Black | Sophistication, premium |
| **Urgency, Sales, Alerts** | Red, Orange | Action, attention, passion |

### Emotional Associations (For Decision Making)

| Hue Family | Positive Associations | Cautions |
|------------|----------------------|----------|
| **Blue** | Trust, calm, professional | Can feel cold, corporate |
| **Green** | Growth, nature, success | Can feel boring if overused |
| **Red** | Passion, urgency, energy | High arousal, use sparingly |
| **Orange** | Warmth, friendly, creative | Can feel cheap if saturated |
| **Purple** | ⚠️ **BANNED** - AI overuses this! | Use Deep Teal/Maroon/Emerald instead |
| **Yellow** | Optimism, attention, happy | Hard to read, use as accent |
| **Black** | Elegance, power, modern | Can feel heavy |
| **White** | Clean, minimal, open | Can feel sterile |

### Selection Process:
1. **What industry?** → Narrow to 2-3 hue families
2. **What emotion?** → Pick primary hue
3. **What contrast?** → Decide light vs dark mode
4. **ASK USER** → Confirm before proceeding

---

## 4. Palette Generation Principles

### Color Space: OKLCH (Primary) vs HSL (Fallback)

**OKLCH** is the modern standard for perceptually uniform color manipulation. Use it as the primary color space; fall back to HSL only for legacy browser support.

```
OKLCH = Lightness, Chroma, Hue

Lightness (0-1): Perceptual brightness (0 = black, 1 = white)
  → Unlike HSL, equal L values LOOK equally bright
Chroma (0-0.4): Color intensity (0 = gray)
  → Unlike HSL saturation, perceptually linear
Hue (0-360): Color family (same as HSL)

WHY OKLCH over HSL:
├── Perceptually uniform: L 0.5 blue and L 0.5 yellow look equally bright
├── HSL is broken: hsl(60, 100%, 50%) yellow looks far brighter than hsl(240, 100%, 50%) blue
├── P3 wide gamut: OKLCH can express colors outside sRGB (vivid display colors)
├── Tailwind v4 default: Modern frameworks use OKLCH natively
└── Better palette generation: Consistent visual steps across the scale
```

### OKLCH Palette Generation

```css
/* OKLCH syntax in CSS */
color: oklch(0.7 0.15 250);  /* L=0.7, C=0.15, H=250 (blue) */

/* With P3 gamut for vivid colors */
color: oklch(0.65 0.25 150);  /* Vivid green, beyond sRGB */
```

Given ANY base color, create a perceptually uniform scale:

```
OKLCH Lightness Scale:
  50  (lightest) → L: 0.97
  100            → L: 0.93
  200            → L: 0.87
  300            → L: 0.77
  400            → L: 0.67
  500 (base)     → L: 0.55-0.60
  600            → L: 0.48
  700            → L: 0.40
  800            → L: 0.32
  900 (darkest)  → L: 0.22

Chroma: Keep consistent across the scale (±0.02)
Hue: Keep constant for monochromatic; shift ±5-10° for natural warmth
```

### HSL Reference (Legacy Fallback)

For browsers without OKLCH support, use HSL with `@supports` fallback:

```css
:root {
  /* Fallback for older browsers */
  --color-primary: hsl(220, 70%, 55%);
}

@supports (color: oklch(0 0 0)) {
  :root {
    --color-primary: oklch(0.55 0.18 250);
  }
}
```

```
HSL = Hue (0-360), Saturation (0-100%), Lightness (0-100%)
⚠️ WARNING: HSL is NOT perceptually uniform — equal L values at different hues
appear very different in brightness. Use OKLCH when possible.
```

### Chroma/Saturation Adjustments

| Context | OKLCH Chroma | HSL Saturation (fallback) |
|---------|-------------|--------------------------|
| **Professional/Corporate** | Lower (0.06-0.12) | Lower (40-60%) |
| **Playful/Youth** | Higher (0.15-0.25) | Higher (70-90%) |
| **Dark Mode** | Reduce by 0.02-0.04 | Reduce by 10-20% |
| **Accessibility** | Ensure contrast, may need adjustment | Same |

### Tinted Neutrals (Anti-Slop Essential)

**Never use pure gray neutrals** — they look lifeless and generic. Instead, tint your neutral palette with your brand hue for visual cohesion.

```
Pure Grays (❌ BANNED):
  #F8FAFC, #E2E8F0, #94A3B8, #64748B, #334155

Tinted Neutrals (✅ REQUIRED):
  Take your primary hue → reduce chroma dramatically → vary lightness

Example: Primary is Teal (H: 180)
  oklch(0.97 0.01 180)  → Barely-tinted off-white
  oklch(0.90 0.015 180) → Subtle teal-gray for surfaces
  oklch(0.70 0.02 180)  → Mid teal-gray for secondary text
  oklch(0.50 0.025 180) → Dark teal-gray for primary text
  oklch(0.20 0.03 180)  → Near-black with teal undertone
```

**How to create tinted neutrals**:
1. Take your primary color's **hue angle**
2. Set chroma to **0.005-0.03** (barely perceptible)
3. Generate lightness scale as normal
4. Result: Grays that subtly harmonize with your brand

This single technique is the biggest differentiator between generic AI output and professional design.

---

## 5. Context-Based Selection Guide

### Instead of Copying Palettes, Follow This Process:

**Step 1: Identify the Context**
```
What type of project?
├── E-commerce → Need trust + urgency balance
├── SaaS/Dashboard → Need low-fatigue, data focus
├── Health/Wellness → Need calming, natural feel
├── Luxury/Premium → Need understated elegance
├── Creative/Portfolio → Need personality, memorable
└── Other → ASK the user
```

**Step 2: Select Primary Hue Family**
```
Based on context, pick ONE:
- Blue family (trust)
- Green family (growth)
- Warm family (energy)
- Neutral family (elegant)
- OR ask user preference
```

**Step 3: Decide Light/Dark Mode**
```
Consider:
- User preference?
- Industry standard?
- Content type? (text-heavy = light preferred)
- Time of use? (evening app = dark option)
```

**Step 4: Generate Palette Using Principles**
- Use OKLCH manipulation (HSL as fallback)
- Follow 60-30-10 rule
- Check contrast (WCAG)
- Test with actual content

---

## 6. Dark Mode Principles

### Key Rules (No Fixed Codes)

1. **Never pure black** → Use very dark gray with slight hue
2. **Never pure white text** → Use 87-92% lightness
3. **Reduce saturation** → Vibrant colors strain eyes in dark mode
4. **Elevation = brightness** → Higher elements slightly lighter

### Contrast in Dark Mode

```
Background layers (darker → lighter as elevation increases):
Layer 0 (base)    → Darkest
Layer 1 (cards)   → Slightly lighter
Layer 2 (modals)  → Even lighter
Layer 3 (popups)  → Lightest dark
```

### Adapting Colors for Dark Mode

| Light Mode | Dark Mode Adjustment |
|------------|---------------------|
| High saturation accent | Reduce saturation 10-20% |
| Pure white background | Dark gray with brand hue tint |
| Black text | Light gray (not pure white) |
| Colorful backgrounds | Desaturated, darker versions |

---

## 7. Accessibility Guidelines

### Contrast Requirements (WCAG)

| Level | Normal Text | Large Text |
|-------|-------------|------------|
| AA (minimum) | 4.5:1 | 3:1 |
| AAA (enhanced) | 7:1 | 4.5:1 |

### How to Check Contrast

1. **Convert colors to luminance**
2. **Calculate ratio**: (lighter + 0.05) / (darker + 0.05)
3. **Adjust until ratio meets requirement**

### Safe Patterns

| Use Case | Guideline |
|----------|-----------|
| **Text on light bg** | Use lightness 35% or less |
| **Text on dark bg** | Use lightness 85% or more |
| **Primary on white** | Ensure dark enough variant |
| **Buttons** | High contrast between bg and text |

---

## 8. Color Selection Checklist

Before finalizing any color choice, verify:

- [ ] **Asked user preference?** (if not specified)
- [ ] **Matches project context?** (industry, audience)
- [ ] **Follows 60-30-10?** (proper distribution)
- [ ] **Using OKLCH?** (preferred over HSL for perceptual uniformity)
- [ ] **Tinted neutrals?** (grays hue-tinted to match brand, not pure gray)
- [ ] **WCAG compliant?** (contrast checked)
- [ ] **Works in both modes?** (if dark mode needed)
- [ ] **NOT your default/favorite?** (variety check)
- [ ] **Different from last project?** (avoid repetition)

---

## 9. Anti-Patterns to Avoid

### ❌ DON'T:
- Copy the same hex codes every project
- Default to purple/violet (AI tendency)
- Default to dark mode + neon (AI tendency)
- Use pure black (#000000) backgrounds
- Use pure white (#FFFFFF) text on dark
- Ignore user's industry context
- Skip asking user preference

### ✅ DO:
- Generate fresh palette per project
- Ask user about color preferences
- Consider industry and audience
- Use OKLCH for perceptually uniform palette generation (HSL as fallback)
- Always tint neutrals with brand hue (never pure gray)
- Test contrast and accessibility
- Offer light AND dark options

---

> **Remember**: Colors are decisions, not defaults. Every project deserves thoughtful selection based on its unique context.
