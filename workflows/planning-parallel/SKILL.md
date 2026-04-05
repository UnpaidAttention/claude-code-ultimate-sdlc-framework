---
name: planning-parallel
description: |
  Execute parallel planning for independent features
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
AG_HOME="${HOME}/.antigravity"
AG_PROJECT=".antigravity"
AG_SKILLS="${HOME}/.claude/skills/antigravity"

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
- Read `~/.claude/skills/antigravity/knowledge/parallel-execution/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/feature-spec/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/coordination-patterns/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# Parallel Feature Planning

---

## Lens / Skills / Model
**Lens**: `[Requirements]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per council-planning.md

## When to Use
- Phase 3 (Features) with multiple independent features
- Features have no dependencies on each other
- Need to accelerate planning timeline

## Prerequisites
- Phase 1-2 complete (Discovery, Architecture)
- Feature list defined
- Dependencies between features identified

## Trigger
```
/planning-parallel [feature-list]
```

## Steps

1. **Identify Independent Features**
   - Review feature list from Phase 1
   - Identify features with NO dependencies on each other
   - Group into parallelizable sets

   Example:
   ```
   Independent Set 1: [User Auth, Search]
   Independent Set 2: [Dashboard] (depends on Auth)
   Independent Set 3: [Reports] (depends on Dashboard)
   ```

2. **Prepare Shared Context**
   Create artifact with shared decisions:
   Use **Display Template** from `council-planning.md` to show: Shared Context for Parallel Planning

3. **Spawn Parallel Agents**
   Using Manager View:

   ```
   Agent 1: Feature Planning - [Feature A]
   Context: Shared context artifact
   Task: Create 8-section feature matrix for [Feature A]
   Output: feature-matrix-[feature-a].md

   Agent 2: Feature Planning - [Feature B]
   Context: Shared context artifact
   Task: Create 8-section feature matrix for [Feature B]
   Output: feature-matrix-[feature-b].md
   ```

4. **Monitor Progress**
   - Track each agent's status
   - Watch for blockers or questions
   - Ensure consistent quality across agents

5. **Merge Results**
   When all agents complete:
   - Collect all feature matrices
   - Verify consistency (naming, patterns)
   - Resolve any conflicts
   - Update .antigravity/progress.md with completion

6. **Cross-Reference Dependencies**
   After merge:
   - Verify no missing cross-references
   - Ensure API contracts align
   - Check data model consistency

## Agent Instructions Template

Use **Display Template** from `council-planning.md` to show: Feature Planning Agent

## Output Format

Use **Display Template** from `council-planning.md` to show: Parallel Planning Complete

## Conflict Resolution

If agents produce conflicting outputs:

1. **API Conflicts**: Same endpoint, different schemas
   - Resolution: Merge into single schema, update both matrices

2. **Data Conflicts**: Same entity, different attributes
   - Resolution: Create unified entity model

3. **Naming Conflicts**: Same name, different meanings
   - Resolution: Rename with domain prefix

## Best Practices

- Maximum 3-4 parallel agents for manageability
- Ensure shared context is complete before spawning
- Use Plan Mode in each agent for complex features
- Save progress frequently in each agent
- Main agent maintains overall coordination
