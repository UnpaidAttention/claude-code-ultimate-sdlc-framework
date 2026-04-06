---
name: sdlc-planning-adr
description: |
  Create Architecture Decision Record for technical decisions
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/architecture-principles/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/decision-making/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/trade-off-analysis/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# Planning ADR Workflow

---

## Lens / Skills / Model
**Lens**: `[Architecture]` | **Model**: Claude Opus 4.5
> Apply RARV cycle, session protocol per council-planning.md

## Description

Creates an Architecture Decision Record (ADR) to document significant technical decisions. Ensures decisions are recorded with context, rationale, and consequences.

## Why This Workflow Exists

Architecture decisions are often made but not documented. When team members change or time passes, the "why" behind decisions is lost. ADRs create institutional memory and prevent re-litigating settled decisions.

## Pre-Conditions

- Should be in Phase 2 (Architecture) or when making significant technical decisions
- Decision should have been discussed/analyzed

## Steps

### Step 1: Gather Decision Context

Ask user for:
- What decision needs to be made?
- What options were considered?
- What is the recommended choice?
- Why is this decision significant?

### Step 2: Create ADR

Generate a **Documentation Artifact** using this template:

Use **Display Template** from `council-planning.md` to show: ADR-[XXX]: [Decision Title]

### Agent: sdlc-architecture
Invoke via Agent tool with `subagent_type: "sdlc-architecture"`:
- **Provide**: Draft ADR (context, options considered, recommended decision, consequences), existing ADRs for consistency check, system architecture context
- **Request**: Review ADR for architectural soundness — validate that options analysis is thorough, trade-offs are honest, consequences (positive and negative) are complete, decision aligns with existing architectural principles and ADRs, and no conflicting decisions exist
- **Apply**: Incorporate architecture review findings before finalizing the ADR

### Step 3: Verify ADR Quality

Before finalizing, verify:
- [ ] Context clearly explains the problem
- [ ] At least 2 options were considered
- [ ] Decision rationale is clear and references drivers
- [ ] Consequences (positive and negative) are documented
- [ ] Risks are identified with mitigations
- [ ] Implementation notes are actionable

### Step 4: Assign ADR Number

- Read existing ADRs to find next number
- Use format: ADR-001, ADR-002, etc.

### Step 5: Save ADR

- Save to `specs/adrs/ADR-XXX-[title].md`
- Update `.ultimate-sdlc/progress.md` with new ADR
- Update architecture section in `.ultimate-sdlc/project-context.md`

### Step 6: Knowledge Base

Save to Knowledge Base:
- Decision pattern for future reference
- Technology choice rationale
- Trade-offs analysis

## Artifacts Generated

- **Documentation Artifact**: Complete ADR document

## When to Create an ADR

Create an ADR for decisions that:
- Are hard to reverse
- Have significant cost implications
- Affect multiple components/teams
- Involve trade-offs between competing concerns
- Will be questioned later ("why did we do it this way?")

## ADR Principles

1. **Immutable once accepted** - Don't edit history; create new ADRs to supersede
2. **Capture the "why"** - The decision itself is less important than the reasoning
3. **Be honest about trade-offs** - Every decision has cons
4. **Keep it concise** - ADRs should be readable in 5 minutes
