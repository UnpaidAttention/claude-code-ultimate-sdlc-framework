---
name: accessibility-testing
description: |
  Test software for WCAG 2.2 compliance and assistive technology compatibility.
---

  Use when: (1) Phase T3 requires accessibility testing, (2) verifying WCAG 2.2 Level AA
  conformance, (3) testing keyboard-only navigation and focus indicators, (4) screen
  reader compatibility testing (NVDA, VoiceOver, JAWS), (5) checking color contrast
  ratios and visual design, (6) validating form labels and ARIA attributes.

# Accessibility Testing

Systematic testing to ensure software is usable by people with diverse abilities. Covers WCAG 2.2 guidelines and assistive technology compatibility.

## WCAG 2.2 Principles (POUR)

### Perceivable
Information must be presentable in ways users can perceive.

**Test Areas:**
- Text alternatives for images
- Captions for video
- Color contrast
- Resizable text
- Audio descriptions

### Operable
Interface must be operable by users.

**Test Areas:**
- Keyboard accessibility
- Skip navigation links
- Sufficient time limits
- Seizure-safe design
- Clear navigation

### Understandable
Information and operation must be understandable.

**Test Areas:**
- Readable content
- Predictable behavior
- Input assistance
- Error identification
- Labels and instructions

### Robust
Content must be robust for assistive technologies.

**Test Areas:**
- Valid HTML
- Name, role, value
- Status messages
- Compatible with assistive tech

## Testing Checklist

### Keyboard Navigation
- [ ] All interactive elements focusable
- [ ] Focus order is logical
- [ ] Focus indicator visible
- [ ] No keyboard traps
- [ ] Skip links present
- [ ] Shortcuts don't conflict

### Screen Reader Compatibility
- [ ] All images have alt text
- [ ] Headings properly structured (h1→h2→h3)
- [ ] Form labels associated with inputs
- [ ] Tables have headers
- [ ] Links are descriptive
- [ ] ARIA attributes correct

### Visual Design
- [ ] Color contrast ratio ≥ 4.5:1 (normal text)
- [ ] Color contrast ratio ≥ 3:1 (large text)
- [ ] Information not conveyed by color alone
- [ ] Text resizable to 200% without loss
- [ ] Focus indicators visible

### Forms
- [ ] All inputs have labels
- [ ] Required fields indicated
- [ ] Error messages clear
- [ ] Error messages associated with fields
- [ ] Form submission confirmable

### Media
- [ ] Videos have captions
- [ ] Audio has transcript
- [ ] Media controllable by keyboard
- [ ] No auto-play audio

## Testing Tools

### Automated Testing
- axe DevTools
- WAVE
- Lighthouse
- pa11y

### Manual Testing
- Keyboard-only navigation
- Screen reader testing (NVDA, VoiceOver, JAWS)
- High contrast mode
- Zoom to 200%

## Screen Reader Testing Protocol

### NVDA (Windows)
1. Open application with NVDA running
2. Navigate using Tab, Arrow keys
3. Verify all content announced
4. Test form interactions
5. Check modal handling

### VoiceOver (macOS/iOS)
1. Enable VoiceOver (Cmd+F5)
2. Navigate using VO+Arrow keys
3. Verify rotor navigation
4. Test touch gestures (iOS)

### JAWS (Windows)
1. Launch with JAWS active
2. Use navigation commands
3. Verify virtual cursor behavior
4. Test forms mode

## Common Accessibility Issues

### Missing Alt Text
```html
<!-- Bad -->
<img src="chart.png">

<!-- Good -->
<img src="chart.png" alt="Sales chart showing 20% growth in Q4">
```

### Missing Form Labels
```html
<!-- Bad -->
<input type="email">

<!-- Good -->
<label for="email">Email Address</label>
<input type="email" id="email">
```

### Low Color Contrast
```css
/* Bad: contrast ratio 2.5:1 */
color: #999999;
background: #ffffff;

/* Good: contrast ratio 7:1 */
color: #595959;
background: #ffffff;
```

### Keyboard Trap
Ensure users can Tab in and out of all components.

## WCAG 2.2 New Criteria (Beyond 2.1)

WCAG 2.2 became ISO/IEC 40500:2025. Key new success criteria at AA level:

| Criterion | Level | Requirement |
|-----------|-------|-------------|
| **2.4.11 Focus Not Obscured (Minimum)** | AA | Focused element not entirely hidden by other content |
| **2.4.12 Focus Not Obscured (Enhanced)** | AAA | No part of focused element hidden |
| **2.5.7 Dragging Movements** | AA | Dragging has single-pointer alternative (click/tap) |
| **2.5.8 Target Size (Minimum)** | AA | Interactive targets at least 24x24 CSS pixels (or has spacing) |
| **3.3.7 Redundant Entry** | A | Don't re-ask for info already provided in same session |
| **3.3.8 Accessible Authentication (Minimum)** | AA | No cognitive function test for auth (allow paste, password managers) |

### Testing for WCAG 2.2 Additions

- [ ] Focus Not Obscured: Tab through all elements, check nothing is hidden behind sticky headers/footers
- [ ] Dragging Movements: All drag interactions have a click/tap alternative
- [ ] Target Size: Interactive elements are ≥24x24px or have ≥24px spacing from adjacent targets
- [ ] Redundant Entry: Auto-populate previously entered data (name, email, address)
- [ ] Accessible Authentication: Allow password managers, no CAPTCHAs without alternative

## WCAG Conformance Levels

| Level | Description |
|-------|-------------|
| A | Minimum (must address) |
| AA | Standard (should address) |
| AAA | Enhanced (nice to address) |

**Target: WCAG 2.2 Level AA**

## Issue Documentation

```markdown
## Accessibility Issue: [Title]

### WCAG Criterion
[e.g., 1.4.3 Contrast (Minimum)]

### Level
[A/AA/AAA]

### Location
[Where in application]

### Current State
[What's wrong]

### Required Fix
[What needs to change]

### Impact
[Who is affected]
```

## References

- See `references/wcag-checklist.md` for complete WCAG criteria
- See `references/aria-patterns.md` for ARIA implementation
