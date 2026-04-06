---
name: sdlc-planning-discover
description: |
  Discover and capture a new project idea through structured questioning
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
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/requirements-engineering/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/brainstorming/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/interview-techniques/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


# Workflow: planning-discover

// turbo-all

Transforms a raw idea into a structured concept ready for planning. Use this when you have an idea but haven't formalized it yet.

---

## Lens / Skills / Model
**Lens**: `[Requirements]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per council-planning.md

## When User Says
`/planning-discover` or "I have an idea" or "Start from scratch"

## Purpose

This workflow helps users who have a product idea but haven't gone through formal validation (like the AI Innovation Council). It asks structured questions to understand the concept thoroughly before proceeding to planning phases.

## Instructions

Execute these steps in order:

### Step 1: Load Framework Context

Read these files to understand your role:
- `CLAUDE.md` - Framework documentation
- `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/contexts/framework-overview.md` - Your role and purpose

### Step 2: Initial Idea Capture

Ask the user to describe their idea in their own words:

```
Tell me about your idea. What do you want to build?
Just describe it naturally - we'll extract the details together.
```

Let them explain freely. Do not interrupt with questions yet.

### Step 3: Structured Discovery Interview (Questions with Defaults)

### Agent: sdlc-requirements
Invoke via Agent tool with `subagent_type: "sdlc-requirements"`:
- **Provide**: User's initial idea description from Step 2, project type (if known)
- **Request**: Apply elicitation techniques (stakeholder analysis, goal modeling, context diagrams) to generate targeted follow-up questions per dimension
- **Apply**: Incorporate recommended questions into the structured interview below

After their initial description, conduct a structured interview across these 6 dimensions.

**IMPORTANT**: Use "Questions with Defaults" technique from AgentOS:
- Frame questions as assumptions: "Based on what you've described, I assume X. Is that correct?"
- Provide 2-3 suggested answers where applicable
- This makes it fast to confirm vs. answering from scratch
- User can always override with their own answer

#### Dimension 1: Problem & Purpose
**Goal**: Understand what problem this solves

Questions with defaults:
- "Based on your description, I'm assuming the core problem is [X]. Is that accurate, or would you frame it differently?"
- "It sounds like people currently solve this by [inferred approach], which is painful because [inferred reason]. Am I understanding that correctly?"
- "If this problem isn't solved, I assume [consequence]. Is that the main impact?"

#### Dimension 2: Target Users
**Goal**: Define who this is for

Questions with defaults:
- "I'm assuming your primary user is [inferred persona]. Does that match your vision?"
- "It sounds like these users would try your solution because [inferred motivation]. Is that the main driver?"
- "I'm thinking the typical user would discover this through [channel]. Sound right?"

#### Dimension 3: Core Value Proposition
**Goal**: Clarify what makes this valuable

Questions with defaults:
- "If I had to summarize in one sentence: 'This helps [user] to [outcome] by [method].' Does that capture it?"
- "The main differentiator from alternatives seems to be [inferred]. Is that your key edge?"
- "Success for a user would look like [inferred outcome]. Accurate?"

#### Dimension 4: Key Capabilities
**Goal**: Identify essential functionality

Questions with defaults:
- "Based on what you've described, the essential capabilities seem to be:
  1. [Inferred capability 1]
  2. [Inferred capability 2]
  3. [Inferred capability 3]

  Would you add, remove, or reorder any of these?"
- "I'm assuming [feature X] is nice-to-have rather than essential. Agree?"
- "Are there any features you specifically want to EXCLUDE from scope?"

#### Dimension 5: Constraints & Context
**Goal**: Understand limitations and environment

Questions with defaults:
- "I'm assuming this will be a [web app / mobile app / API / desktop app]. Correct?"
- "For timeline, I'm thinking [initial scope] in [timeframe]. Does that align with your expectations?"
- "I don't see any obvious compliance requirements (like HIPAA, GDPR, PCI). Am I missing any?"
- "This appears to be [standalone / needs integration with X]. Right?"

#### Dimension 6: Success Criteria
**Goal**: Define what "done" looks like

Questions with defaults:
- "For project success, I'm assuming you need to demonstrate [inferred outcome]. Is that the bar?"
- "The key metrics seem to be [inferred metrics]. Would you prioritize differently?"
- "I'm estimating this as a [Micro/Standard/Enterprise] project based on scope. Does that feel right?"

### Step 4: Synthesize Understanding

After the interview, create a synthesis document:

Use **Display Template** from `council-planning.md` to show: Idea Synthesis: [Concept Name]

### Step 5: User Validation

Present the synthesis to the user and ask:

```
Here's what I understand about your idea.
Please review and let me know:
1. Does this accurately capture your vision?
2. Is anything missing or misrepresented?
3. Are you ready to proceed to formal planning?
```

### Step 6: Capture to Template

Once validated, create the idea intake document:

1. **Create idea intake document** (`idea-intake.md`) with these sections:
   - **Problem Statement**: What problem does this solve?
   - **Proposed Solution**: High-level approach
   - **Target Users**: Who is this for?
   - **Success Criteria**: How do we know it works?
   - **Key Capabilities**: Essential features list
   - **Constraints**: Technical, timeline, or compliance limitations
   - Fill in all sections from the synthesis

2. **Announce**: "Idea captured. Ready for `/planning-start` to begin formal planning."

### Step 7: Transition to Planning

Ask the user:

```
Your idea is captured in idea-intake.md. Would you like to:
1. Start planning now (`/planning-start`)
2. Review/refine the idea intake first
3. Stop here and return later
```

If they choose option 1, execute `/planning-start` which will detect the idea-intake.md and use it as input for Phase 1.

## Adaptive Questioning Guidelines

- **Always provide defaults**: Frame questions as assumptions with suggested answers
- **Make confirmation easy**: "Is that correct?" is faster than "What is X?"
- **Don't ask questions already answered**: If the user covered something, state your understanding for confirmation
- **Go deeper on vague areas**: If an answer is unclear, probe with more specific defaults
- **Skip irrelevant dimensions**: If something clearly doesn't apply, state "I'm assuming [X] doesn't apply here" and move on
- **Read the room**: If the user is impatient, consolidate into batched confirmations; if engaged, explore thoroughly
- **Summarize periodically**: Every 2-3 questions, state what you've learned so far for validation

### Example Question Patterns

**Instead of:**
> "What problem does this solve?"

**Say:**
> "Based on what you've described, it sounds like the core problem is [X]. Is that accurate, or would you frame it differently?"

**Instead of:**
> "Who is your target user?"

**Say:**
> "I'm assuming your primary user is a [inferred persona] who needs to [inferred goal]. Does that match your vision?"

This approach:
- Shows you're actively listening
- Makes it fast to confirm (single word: "yes")
- Only requires detailed answers when you're wrong

## Output Files

| File | Purpose |
|------|---------|
| `idea-intake.md` | Structured capture of the project concept |

## Integration with planning-start

When `/planning-start` detects `idea-intake.md`:
- Skips basic project info questions (already captured)
- Uses idea-intake.md as input for Phase 1: Discovery
- Pre-populates .ultimate-sdlc/project-context.md with captured information

## Notes

- This workflow is **optional** - users can skip directly to `/planning-start` if they already have a clear concept
- The idea-intake.md serves a similar purpose to Innovation Council output but is lighter-weight
- This is meant to take 10-20 minutes of conversation, not hours
