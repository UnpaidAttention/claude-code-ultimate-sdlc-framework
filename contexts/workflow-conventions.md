# Workflow Conventions

Standard protocols applied to ALL workflows. Referenced from individual workflows via single-line directive.

---

## RARV Cycle

Before every significant action:
1. **REASON**: What am I doing? Why? What could go wrong?
2. **ACT**: Execute the action
3. **REFLECT**: Did it work? What did I learn?
4. **VERIFY**: Does it meet success criteria?

## Agent Loading

1. READ the agent file at `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/agents/{agent-name}.md`
2. APPLY the agent's domain expertise: Use "Core Principles" for decisions, "When to Use" for scope. Framework rules (P0-P3) override agent guidelines.
3. LOAD ONLY skills from this workflow's `skills_required` frontmatter. Do NOT auto-load agent skills. See UNIVERSAL-RULES §0.8.

## Session State Initialization (Step 0)

**Always read first:**
- `.ultimate-sdlc/council-state/{council}/WORKING-MEMORY.md` — Current session state
- `.ultimate-sdlc/council-state/{council}/run-tracker.md` — Check for multi-run mode (Development only)
- `.memory/semantic/patterns.md` — Relevant patterns to apply
- `.memory/semantic/anti-patterns.md` — Mistakes to avoid

**If run-tracker.md exists (Multi-Run Mode):**
1. Identify current run from tracker
2. Load ONLY the AIOUs assigned to current run
3. Display: "[Phase/Wave]: [Name] - Run [X] of [Y]"

**Update `.ultimate-sdlc/project-context.md`:**
- Set `Active Council`: {council}
- Set `Current Phase/Wave`: {phase/wave}
- Set `Status`: in_progress

## Session End Protocol

Before ending any session:

1. **Update WORKING-MEMORY.md**: Mark completed items, update in-progress state, add session learnings
2. **Record Metrics**: Create task metrics in `.metrics/tasks/{council}/` — track duration, retries, outcomes
3. **Write Episodic Memory** (significant sessions only): `.memory/episodic/{council}/YYYY-MM-DD-{topic}.md`

## Model Selection

Each workflow specifies its model. General guidance:
- **claude-opus-4-6**: Deep reasoning, architecture, analysis, assessment
- **claude-sonnet-4-6**: Fast execution, implementation, systematic tasks
- **claude-opus-4-6**: Visual/creative UI work (Wave 5 VISUAL only)
