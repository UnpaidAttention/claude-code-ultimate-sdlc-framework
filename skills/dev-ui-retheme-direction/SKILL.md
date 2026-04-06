---
name: sdlc-dev-ui-retheme-direction
description: |
  "Phase 2 of UI Retheme: Research new theme direction — present options to user, wait for input, research based on choice. Produces retheme-direction artifact."
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
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


# /dev-ui-retheme-direction - Phase 2: Research New Direction

## Lens / Skills / Model
**Lens**: `[UX]` + `[Quality]` | **Model**: claude-opus-4-6
> Apply RARV cycle, session protocol per `council-development.md`

## Prerequisites

- Phase 1 complete: `.ultimate-sdlc/council-state/development/current-theme-snapshot.md` exists
- Git tag `pre-retheme-baseline` exists

If prerequisites not met:
```
Phase 2 requires the current theme snapshot.
Run /dev-ui-retheme-snapshot first.
```

---

## Workflow

### Step 2.1: Review Current Theme

Read `.ultimate-sdlc/council-state/development/current-theme-snapshot.md` and summarize the current visual identity.

### Step 2.2: User Direction Input

Present the user with direction options:

```
## Theme Direction

Current theme summary:
- Typography: [current fonts]
- Primary color: [current]
- Style: [current aesthetic — minimal, corporate, playful, etc.]

What direction would you like for the new theme?

1. **Specific direction** — You provide colors, fonts, aesthetic, and/or references
2. **Research-driven** — I'll research design approaches for [application type] and propose options
3. **Reference-based** — Provide URL(s) of sites whose visual style you like
4. **Contrast approach** — The opposite of the current theme (if dark → light, if minimal → expressive)

Your preference?
```

**HARD STOP** — Wait for user input before proceeding. Do NOT assume a direction.

### Step 2.3: Research New Direction

Based on user input:

- **If user provided specifics**: Validate the choices work together — contrast ratios, readability, cohesion. Note any concerns.
- **If research-driven**: Execute `/dev-ui-research` methodology for the new direction — search Dribbble, analyze references, document findings with rationale.
- **If reference-based**: Analyze the provided reference sites for their design patterns — colors, typography, spacing, component styles, overall aesthetic.
- **If contrast approach**: Invert key design decisions from current theme. Document each inversion with rationale.

### Step 2.4: Synthesize Direction

Combine research findings into a clear direction statement:
- Overall aesthetic (2-3 sentences)
- Key design decisions and their rationale
- Any constraints or considerations identified during research

---

## Output Artifact

Save to `.ultimate-sdlc/council-state/development/retheme-direction.md`:

```markdown
# Retheme Direction

## User Choice
- **Approach**: [specific / research-driven / reference-based / contrast]
- **Input**: [what the user provided]

## Current Theme Summary
[Brief summary from snapshot]

## Research Findings
[Research results, reference analysis, or direction validation]

## Direction Decision
### Overall Aesthetic
[2-3 sentences describing the target visual identity]

### Key Design Decisions
| Decision | Current | New Direction | Rationale |
|----------|---------|---------------|-----------|
| Color mood | [current] | [new] | [why] |
| Typography voice | [current] | [new] | [why] |
| Density | [current] | [new] | [why] |
| Shape language | [current] | [new] | [why] |

### Constraints & Considerations
- [Any identified constraints — accessibility, brand requirements, technical limits]

## References
- [URLs, screenshots, or descriptions of reference material]
```

---

## Completion Condition

- User has provided direction input
- Research or validation has been performed based on user choice
- Direction is clearly documented with rationale
- `.ultimate-sdlc/council-state/development/retheme-direction.md` exists and is complete

---

## Next Step

```
## Phase 2 Complete: Direction Established

**Approach**: [user's chosen approach]
**Direction**: [brief description of new aesthetic]
**Key changes**: [top 3-4 changes from current theme]

Direction saved to: .ultimate-sdlc/council-state/development/retheme-direction.md

Next step: Run /dev-ui-retheme-propose to create the complete new design system proposal.
```

---

## Agent Invocations

### Agent: ux
Invoke via Agent tool with `subagent_type: "sdlc-ux"`:
- **Provide**: Current theme snapshot, project identity, user's direction input, competitive/reference analysis
- **Request**: Research the new theme direction — analyze reference sites, validate user choices for contrast/readability/cohesion, synthesize research into a clear direction statement with rationale
- **Apply**: Integrate UX-informed direction into the retheme-direction artifact

---
