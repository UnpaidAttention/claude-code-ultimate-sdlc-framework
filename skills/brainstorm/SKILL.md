---
name: sdlc-brainstorm
description: |
  Structured brainstorming with Socratic questioning and documentation workflow. Turns ideas into validated designs.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/creative-ideation/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/architecture-principles/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/conversation-manager/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /brainstorm - Structured Idea Exploration

## Arguments
| Argument | Required | Description |
|----------|----------|-------------|
| (none) | — | Session auto-detects state |

---

## Purpose

This command activates BRAINSTORM mode for structured idea exploration. Use when you need to explore options before committing to an implementation.

---

## Lens / Skills / Model
**Lens**: `[Requirements]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per the active council rules file

## The Process

### Phase 1: Understanding the Idea

1. **Check project context first** - Read files, docs, recent commits
2. **Ask questions ONE AT A TIME** - Don't overwhelm
3. **Prefer multiple choice** - Easier to answer when possible
4. **Focus on:** Purpose, constraints, success criteria

### Phase 2: Exploring Approaches

1. **Propose 2-3 different approaches** with trade-offs
2. **Present options conversationally** with your recommendation
3. **Lead with recommended option** and explain why
4. **Apply YAGNI ruthlessly** - Remove unnecessary features

### Phase 3: Presenting the Design

1. **Break design into sections** of 200-300 words
2. **Ask after each section** whether it looks right so far
3. **Cover:** Architecture, components, data flow, error handling, testing
4. **Be ready to go back** and clarify

---

## Question Generation (Dynamic)

### Core Principles

| Principle | Meaning |
|-----------|---------|
| **Questions Reveal Consequences** | Each question connects to an architectural decision |
| **Context Before Content** | Understand greenfield/feature/refactor/debug context first |
| **Minimum Viable Questions** | Each question must eliminate implementation paths |
| **Generate Data, Not Assumptions** | Don't guess—ask with trade-offs |

### Question Format

Use **Display Template** from `the active council rules file` to show: [PRIORITY] **[DECISION POINT]**

---

## Output Format

Use **Display Template** from `the active council rules file` to show: 🧠 Brainstorm: [Topic]

---

## Documentation Workflow (After Design Validation)

Once design is validated:

1. **Write to git:**
```
docs/plans/YYYY-MM-DD-<topic>-design.md
```

2. **Commit the design document**

3. **Ask:** "Ready to set up for implementation?"

4. **If yes, transition to:**
   - `using-git-worktrees` → Create isolated workspace
   - `writing-plans` → Create detailed implementation plan
   - `executing-plans` → Follow plan execution workflow

---

## Examples

```
/brainstorm authentication system
/brainstorm state management for complex form
/brainstorm database schema for social app
/brainstorm AI-powered feature
/brainstorm monetization strategy
```

---

## Related Skills

- `writing-plans` - Create implementation plans after design
- `executing-plans` - Execute plans step-by-step
- `using-git-worktrees` - Create isolated workspaces
- `software-architecture` - Architectural patterns
- `senior-architect` - Advanced architecture guidance

---

## Key Principles

| Principle | Meaning |
|-----------|---------|
| **One question at a time** | Don't overwhelm |
| **Multiple choice preferred** | Easier to answer |
| **YAGNI ruthlessly** | Remove unnecessary features |
| **Explore alternatives** | Always 2-3 approaches |
| **Incremental validation** | Present in sections |
| **Document to git** | Write validated designs |
| **Be flexible** | Go back and clarify |

## Agent Invocations

### Agent: sdlc-requirements
Invoke via Agent tool with `subagent_type: "sdlc-requirements"`:
- **Provide**: User's idea/topic, project context, existing codebase state, constraints
- **Request**: Apply structured ideation — Socratic questioning to explore approaches, evaluate trade-offs, and validate design decisions
- **Apply**: Use structured ideation results in Phases 1-3 to guide the brainstorming process and document validated designs
