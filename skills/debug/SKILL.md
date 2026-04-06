---
name: sdlc-debug
description: |
  Debugging command. Activates systematic 4-phase debugging with root cause analysis and evidence-based verification.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/systematic-debugging/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/tdd-workflow/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/test-fixing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /debug - Systematic Problem Investigation

## Arguments
| Argument | Required | Description |
|----------|----------|-------------|
| (none) | — | Session auto-detects state |

---

## Purpose

This command activates systematic debugging for any technical issue: bugs, test failures, unexpected behavior, performance problems, or build failures.

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per the active council rules file

## The Iron Law

```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

If you haven't completed Phase 1, you cannot propose fixes.

---

## The Four Phases

### Phase 1: Root Cause Investigation (MANDATORY FIRST)

### Agent: sdlc-debugger
Invoke via Agent tool with `subagent_type: "sdlc-debugger"`:
- **Provide**: Error messages, stack traces, reproduction steps, recent git changes, and affected component context
- **Request**: Systematic root cause analysis — trace data flow, identify failure point, gather evidence at layer boundaries, and form ranked hypotheses
- **Apply**: Use the debugger's root cause analysis to guide Phase 2-4. Do NOT skip to fixes without the debugger's investigation completing first

1. **Read Error Messages Carefully**
   - Don't skip past errors or warnings
   - Read stack traces completely
   - Note line numbers, file paths, error codes

2. **Reproduce Consistently**
   - Can you trigger it reliably?
   - What are the exact steps?
   - If not reproducible → gather more data, don't guess

3. **Check Recent Changes**
   - `git log --oneline -20`
   - `git diff HEAD~5`
   - New dependencies, config changes

4. **Gather Evidence in Multi-Component Systems**
   - Add diagnostic instrumentation at each layer boundary
   - Log what data enters/exits each component
   - Run once to gather evidence showing WHERE it breaks

5. **Trace Data Flow**
   - Where does bad value originate?
   - What called this with bad value?
   - Keep tracing up until you find the source

### Phase 2: Pattern Analysis

1. **Find Working Examples** - Locate similar working code
2. **Compare Against References** - Read reference implementation COMPLETELY
3. **Identify Differences** - List every difference, however small
4. **Understand Dependencies** - What other components does this need?

### Phase 3: Hypothesis and Testing

1. **Form Single Hypothesis** - "I think X is the root cause because Y"
2. **Test Minimally** - Make the SMALLEST possible change
3. **Verify Before Continuing** - Did it work? Yes → Phase 4, No → new hypothesis
4. **When You Don't Know** - Say "I don't understand X" - research more

### Phase 4: Implementation

1. **Create Failing Test Case** - MUST have before fixing
2. **Implement Single Fix** - ONE change at a time
3. **Verify Fix** - Test passes? Other tests still pass?
4. **If Fix Doesn't Work** - Count attempts. If ≥ 3, STOP and question architecture

---

## The 3+ Fixes Rule

**If 3+ fixes have failed:**
- STOP attempting more fixes
- Question the architecture
- Is this pattern fundamentally sound?
- Discuss with human before attempting more fixes

This is NOT a failed hypothesis - this is a wrong architecture.

---

## Output Format

Use **Display Template** from `the active council rules file` to show: 🔍 Debug: [Issue][language]
[Test code]
```

**Root Cause:**
🎯 **[Explanation of why this happened]**

**Fix:**
```[language]
// Before
[broken code]

// After
[fixed code]
### Defense-in-Depth Added

---

## Red Flags - STOP and Return to Phase 1

If you catch yourself thinking:
- "Quick fix for now, investigate later"
- "Just try changing X and see if it works"
- "I don't fully understand but this might work"
- "One more fix attempt" (when already tried 2+)

**ALL of these mean: STOP. Return to Phase 1.**

---

## Examples

```
/debug login not working
/debug API returns 500
/debug form doesn't submit
/debug flaky test in CI
/debug data not persisting after restart
```

---

## Related Skills

- `tdd-workflow` - For creating failing test case
- `verification-before-completion` - Verify fix worked before claiming success
- `test-fixing` - For fixing broken tests
