---
name: sdlc-dev-ui-polish-research
description: |
  Phase 3 of UI Polish — research distinctive design alternatives for each slop finding category using design skills and search tools.
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Agent
  - AskUserQuestion
---

## Preamble (run first)

```bash
# Detect project state
AG_HOME="${HOME}/.Ultimate SDLC"
AG_PROJECT=".ultimate-sdlc"
AG_SKILLS="${HOME}/.claude/skills/ultimate-sdlc"

# Check if project is initialized
if [ -d "$AG_PROJECT" ]; then
  echo "PROJECT: initialized"
  # Read current state
  if [ -f "$AG_PROJECT/project-context.md" ]; then
    COUNCIL=$(grep -A1 "## Active Council" "$AG_PROJECT/project-context.md" | tail -1 | tr -d ' ')
    PHASE=$(grep -A1 "## Current Phase" "$AG_PROJECT/project-context.md" | tail -1 | tr -d ' ')
    STATUS=$(grep -A1 "## Status" "$AG_PROJECT/project-context.md" | tail -1 | tr -d ' ')
    echo "COUNCIL: $COUNCIL"
    echo "PHASE: $PHASE"  
    echo "STATUS: $STATUS"
  fi
else
  echo "PROJECT: not initialized (run /init first)"
fi

# Read global config
if [ -f "$AG_HOME/config.yaml" ]; then
  GOV_MODE=$(grep "governance_mode:" "$AG_HOME/config.yaml" | awk '{print $2}')
  PROJ_TYPE=$(grep "project_type:" "$AG_HOME/config.yaml" | awk '{print $2}')
  echo "GOVERNANCE: ${GOV_MODE:-standard}"
  echo "PROJECT_TYPE: ${PROJ_TYPE:-web-app}"
fi
```

After the preamble runs, use the detected state to verify prerequisites for this workflow.

## Knowledge Skills

Load these knowledge skills for reference during this workflow:
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/frontend-design/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/ui-ux-pro-max/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/component-patterns/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


# /dev-ui-polish-research - Phase 3: Research Design Alternatives

---

## Lens / Skills / Model
**Lens**: `[UX]` + `[Quality]` | **Model**: claude-opus-4-6
> Apply RARV cycle, session protocol per `council-development.md`

## Prerequisites

- `.ultimate-sdlc/council-state/development/ui-slop-report.md` must exist (Phase 2 complete)
- `design-system.md` exists (even if informal)

If prerequisite not met:
```
Slop report not found. Run /dev-ui-polish-report first.
Phase 3 requires the structured report from Phase 2.
```

---

## Instructions

For each finding category in the slop report, research replacements that:
1. Match the project's purpose and audience
2. Are distinctive (could NOT be confused with generic AI output)
3. Are cohesive with each other (form a consistent design language)
4. Are technically feasible (available Google Fonts, compatible with the framework)

### Step 1: Understand Project Identity

Read `.ultimate-sdlc/project-context.md`, `design-system.md`, and any product concept docs. Answer:
- What does this product do?
- Who is the target audience?
- What emotion should it evoke?
- What existing brand identity exists (if any)?

### Step 2: Typography Alternatives

Use `ui-ux-pro-max` search tool and `frontend-design` skill typography system.

Research distinctive font pairings (minimum: display + body + mono):
- Display font: Must have character; avoid top-10 most-used Google Fonts
- Body font: Must be highly readable; can be more neutral but not Inter/Roboto/Arial
- Mono font: For code blocks / technical content if applicable
- Document: font name, weight range, Google Fonts availability, character set support
- Provide at least 2-3 pairing options ranked by fit

### Step 3: Color Alternatives

Use `frontend-design` skill color system.

Colors must be derived from the PRODUCT's meaning, not decoration:
- Primary: derived from what the product does and who uses it
- Secondary: complements primary, serves a specific UI purpose
- Accent: for highlights, notifications, interactive elements
- Neutral scale: for backgrounds, text, borders
- Semantic colors: success, warning, error, info (these can be standard)
- Document: hex values, HSL values, contrast ratios against backgrounds
- Provide at least 2 palette options ranked by fit

### Step 4: Layout Alternatives

Reference `ui-design-research.md` if it exists, or research per `/dev-ui-research` methodology.

For each flagged page layout:
- Research alternatives justified by the page's content purpose
- Each page should have a layout driven by its content hierarchy, not a generic template
- Consider: information density, user task flow, visual rhythm, content types
- Provide specific structural alternatives (not just "make it different")

### Step 5: Component Style Alternatives

For each flagged component pattern:
- Research replacements that create intentional visual contrast
- Consider: border radius strategy (mix sharp + rounded), elevation system, color application
- Ensure alternatives work together as a cohesive system
- Reference existing component libraries for inspiration but adapt to project identity

### Step 6: Copy Alternatives

For each flagged text pattern:
- Draft replacement copy that is concrete and specific to the product
- Replace buzzwords with measurable value propositions
- Replace generic CTAs with action-specific language
- Ensure tone matches project identity

---

## Output

Save research results to `.ultimate-sdlc/council-state/development/ui-polish-alternatives.md`:

```markdown
# Design Alternatives Research

## Research Date: [date]
## Project Identity Summary
[Product purpose, audience, emotion, brand identity]

## Typography Alternatives

### Option A: [Display Font] + [Body Font] + [Mono Font]
- Display: [font name] — [weights], [why it fits]
- Body: [font name] — [weights], [why it fits]
- Mono: [font name] — [why it fits]
- Google Fonts: [all available? links]
- Fit score: [HIGH/MEDIUM]

### Option B: ...

## Color Alternatives

### Palette A: [Name/Theme]
- Primary: [hex] [hsl] — [derived from what?]
- Secondary: [hex] [hsl] — [purpose]
- Accent: [hex] [hsl] — [purpose]
- Neutrals: [scale]
- Contrast check: [passes WCAG AA? AA/AAA]

### Palette B: ...

## Layout Alternatives
[Per flagged page: current → proposed, with rationale]

## Component Style Alternatives
[Per flagged pattern: current → proposed, with rationale]

## Copy Alternatives
[Per flagged text: current → proposed replacement]
```

---

## Completion Condition

- Alternatives researched for every finding category in the slop report
- Typography: at least 2 font pairing options with availability confirmed
- Colors: at least 2 palette options with contrast ratios verified
- Layout: specific structural alternatives for each flagged page
- All alternatives are cohesive (work together as a design system)
- Results saved to `.ultimate-sdlc/council-state/development/ui-polish-alternatives.md`

---

## Next Step

```
## Phase 3 Complete: Design Alternatives Researched

**Typography options**: [N] font pairings researched
**Color options**: [N] palette options researched
**Layout/component/copy alternatives**: documented

**Results saved to**: .ultimate-sdlc/council-state/development/ui-polish-alternatives.md

**Next step**: Run `/dev-ui-polish-plan` to create the specific remediation plan from researched alternatives.
```

---

## Agent Invocations

### Agent: frontend-specialist
Invoke via Agent tool with `subagent_type: "sdlc-frontend-specialist"`:
- **Provide**: Slop report findings, project identity, current design system, technical framework (Tailwind/CSS/etc.)
- **Request**: Research technically feasible design alternatives for each finding category — verify font availability, color contrast ratios, component library compatibility, and implementation effort
- **Apply**: Integrate researched alternatives into the alternatives artifact with feasibility ratings

---
