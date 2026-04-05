name: rarv-cycle
description: Use before every significant action to ensure deliberate reasoning and verification

# RARV Cycle - Reason, Act, Reflect, Verify

## Purpose

Every significant action follows the RARV cycle to prevent mistakes, ensure quality, and create auditable decision trails.

## The Cycle

```
    ┌─────────┐
    │ REASON  │ ← Start here
    └────┬────┘
         │
         ▼
    ┌─────────┐
    │   ACT   │
    └────┬────┘
         │
         ▼
    ┌─────────┐
    │ REFLECT │
    └────┬────┘
         │
         ▼
    ┌─────────┐     ┌─────────────┐
    │ VERIFY  │────►│ Next action │
    └────┬────┘     └─────────────┘
         │
         │ (if failed)
         ▼
    ┌─────────┐
    │ REASON  │ ← Retry with learnings
    └─────────┘
```

## Phase Details

### REASON

Before acting, explicitly state:

1. **What** am I about to do?
2. **Why** am I doing this?
3. **What could go wrong?**
4. **Am I violating any constitutional principles?**

```markdown
**REASON:**
- Task: [Specific action]
- Purpose: [Why this action advances the goal]
- Risks: [What could fail]
- Constitutional check: [Principles that apply]
```

### ACT

Execute the planned action:

- One action at a time
- Document what was done
- Capture any unexpected behavior

```markdown
**ACT:**
- Executed: [What was done]
- Output: [Result or artifact]
- Observations: [Anything unexpected]
```

### REFLECT

After acting, assess:

1. Did the action succeed?
2. Did anything unexpected happen?
3. What did I learn?
4. Should I update working memory?

```markdown
**REFLECT:**
- Outcome: [Success/Partial/Failed]
- Unexpected: [Any surprises]
- Learning: [What to remember]
- Memory update needed: [Yes/No - what]
```

### VERIFY

Confirm the action achieved its purpose:

1. Does the result meet success criteria?
2. Did I introduce any problems?
3. Is verification evidence captured?

```markdown
**VERIFY:**
- Criteria met: [List with checkmarks]
- Side effects: [None / List any]
- Evidence: [Test results, screenshots, etc.]
```

## When to Apply RARV

### Always (Full Cycle)

- Writing or modifying code
- Creating or editing specs
- Phase transitions
- Handoffs between councils
- Any destructive operation

### Quick RARV (Abbreviated)

For low-risk actions, use inline:

```
[RARV: Reading file X to understand pattern Y. Expect to find Z.]
```

### Skip RARV

- Reading files for context (no action taken)
- Asking clarifying questions
- Updating working memory

## Integration with Working Memory

At each RARV phase, consider working memory:

**REASON phase:**
- Read WORKING-MEMORY.md for context
- Check session learnings for similar past mistakes

**REFLECT phase:**
- Add learnings to Session Learnings table
- Update In Progress section

**VERIFY phase:**
- Mark completed tasks in Completed This Session
- Update blockers if verification failed

## Example: Code Change

```markdown
**REASON:**
- Task: Add input validation to createUser function
- Purpose: Prevent SQL injection per AIOU-015 requirement
- Risks: Could break existing tests, might miss edge cases
- Constitutional check: Principle 9 (read before modify) - reviewed function

**ACT:**
- Executed: Added Zod schema validation at function entry
- Output: Modified src/users/createUser.ts lines 15-28
- Observations: Found existing partial validation, consolidated it

**REFLECT:**
- Outcome: Success
- Unexpected: Existing validation was inconsistent
- Learning: Check for partial implementations before adding new
- Memory update needed: Yes - add pattern "check for existing validation"

**VERIFY:**
- Criteria met:
  - [x] SQL injection prevented
  - [x] Zod schema validates all inputs
  - [x] Tests updated and passing (12/12)
- Side effects: None detected
- Evidence: `npm test -- --grep createUser` passes
```

## Common Mistakes

| Mistake | Impact | Prevention |
|---------|--------|------------|
| Skipping REASON | Acting without understanding why | Make REASON step mandatory |
| Multiple actions in ACT | Can't isolate failures | One action per cycle |
| Skipping REFLECT | Repeating mistakes | Always capture learnings |
| Weak VERIFY | Claiming done without proof | Require evidence |

## Council-Specific Focus

### Planning Council

- REASON: Focus on requirement completeness
- VERIFY: Stakeholder approval, spec quality

### Development Council

- REASON: Check for existing patterns
- VERIFY: Tests pass, no regressions

### Audit Council

- REASON: Test coverage analysis
- VERIFY: All test cases executed with evidence

### Validation Council

- REASON: Layer-by-layer checklist
- VERIFY: Screenshots, before/after comparison

## RARV Modes

### Full RARV (Default)

Use for:
- Multi-step tasks
- Tasks affecting multiple files
- Tasks with potential side effects
- Unfamiliar code areas
- Complex logic changes

Full cycle: Reason → Act → Reflect → Verify

### RARV Lite

Use for:
- Single-file, single-function changes
- Typo fixes, comment updates
- Simple configuration changes
- Tasks where verification is trivial

Lite cycle: Act → Quick Verify

**RARV Lite Criteria** (ALL must be true):
- [ ] Affects exactly 1 file
- [ ] Change is ≤20 lines
- [ ] Change type is one of: typo fix, comment update, import statement, single-line config value
- [ ] No conditional logic (if/else, switch, ternary) is added or modified
- [ ] Running `lint` and `compile` commands would catch any error introduced

**RARV Lite Protocol**:
```markdown
1. ACT: Make the change
2. QUICK VERIFY:
   - File saves without error
   - If code: compiles/lints
   - Change matches intent
3. DONE (no formal Reason/Reflect needed)
```

### Mode Selection

```
Is task complex, multi-file, or risky?
│
├─ YES → Full RARV
│
└─ NO → Does task meet ALL Lite criteria?
         │
         ├─ YES → RARV Lite
         │
         └─ NO → Full RARV
```

**When in doubt: Use Full RARV**


## Quick Reference Card

```
FULL RARV:
  REASON: What? Why? Risks? Constitutional?
  ACT:    Execute single action, capture output
  REFLECT: Success? Surprises? Learnings?
  VERIFY:  Criteria met? Evidence captured?

RARV LITE (simple tasks only):
  ACT:    Make the change
  VERIFY: Compiles? Matches intent?

DEFAULT: Full RARV unless ALL Lite criteria met
```
