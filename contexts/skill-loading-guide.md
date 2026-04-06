# Selective Skill Loading Guide

## Purpose

Agents list many skills in their frontmatter, but loading ALL skills would overflow context and degrade performance. This guide specifies which skills to load for each task type.

---

## Workflow Primacy

**IMPORTANT**: When a workflow has a `skills_required` field in its frontmatter, those skills take precedence over any other loading instruction.

### Hierarchy

1. **Workflow `skills_required`** (highest priority) - If present, load exactly these skills
2. **This guide's matrix** (fallback) - Use when workflow lacks `skills_required`
3. **Agent frontmatter** (reference only) - Shows available skills, not loading instructions

### Example

```yaml
# In workflow frontmatter
---
description: Execute a specific AIOU
skills_required:
  - clean-code
  - testing-patterns
  - aiou-decomposition
  - verification-testing
  - rarv-cycle
---
```

When you see `skills_required`, load **exactly those skills** - no more, no less.

---

## Loading Rules

### Rule 1: Never Load All Skills
- Maximum skills per task: **7 skills** (including rarv-cycle)
- Always load: `rarv-cycle` (1 skill)
- Task-specific: **6 skills maximum** in addition to rarv-cycle

### Rule 2: Task-Type Determines Skills
Match your current task to a category below, then load ONLY those skills.

### Rule 3: Load on Demand
If mid-task you need a skill not loaded, load it then. Don't preload "just in case."

---

## Skill Loading Matrix by Task Type

### Planning Council Tasks

| Task Type | Required Skills | Optional Skills |
|-----------|-----------------|-----------------|
| Requirements gathering | `requirements-engineering`, `brainstorming` | `structured-prompting` |
| Architecture decisions | `architecture`, `architecture-principles`, `risk-assessment` | `senior-architect` |
| Feature specification | `requirements-engineering`, `api-patterns` | `database-design` |
| AIOU decomposition | `aiou-decomposition`, `planning-orchestration` | `feature-deliberation` |
| Security planning | `security-planning`, `top-web-vulnerabilities` | `threat-modeling` |
| Test strategy | `test-strategy`, `testing-patterns` | `tdd-workflow` |
| Infrastructure planning | `infrastructure-planning`, `deployment-procedures` | `docker-expert` |

### Development Council Tasks

| Task Type | Required Skills | Optional Skills |
|-----------|-----------------|-----------------|
| Type definitions | `typescript-expert`, `clean-code` | `api-patterns` |
| Database/data layer | `database-design`, `prisma-expert`, `clean-code` | `database-patterns` |
| API implementation | `api-design`, `api-patterns`, `clean-code` | `security-planning` |
| Service logic | `clean-code`, `error-handling` | `integration-patterns` |
| Frontend components | `react-design-patterns`, `frontend-design`, `clean-code` | `tailwind-patterns` |
| Integration work | `integration-patterns`, `testing-patterns` | `api-patterns` |

### Audit Council Tasks

| Task Type | Required Skills | Optional Skills |
|-----------|-----------------|-----------------|
| Feature inventory | `audit-orchestration`, `navigation-flow` | `gap-analysis` |
| Functional testing | `functional-testing`, `edge-case-discovery` | `testing-patterns` |
| GUI/accessibility | `usability-audit`, `accessibility-testing` | `ui-ux-pro-max` |
| Integration testing | `integration-testing`, `testing-patterns` | `api-patterns` |
| Security testing | `security-testing`, `top-web-vulnerabilities` | `penetration-testing` |
| Quality assessment | `systematic-evaluation`, `gap-analysis` | `completeness-matrix` |

### Validation Council Tasks

| Task Type | Required Skills | Optional Skills |
|-----------|-----------------|-----------------|
| Intent extraction | `intent-extraction`, `multi-lens-analysis` | `purpose-alignment` |
| Gap detection | `gap-detection`, `gap-analysis` | `completeness-matrix` |
| Corrections | `targeted-correction`, `systematic-debugging` | `error-handling` |
| Verification | `verification-testing`, `runtime-verification` | `regression-validation` |
| Security hardening | `security-hardening`, `top-web-vulnerabilities` | `owasp-testing` |
| Performance optimization | `performance-optimization`, `performance-profiling` | `performance-testing` |
| Documentation | `documentation-standards`, `documentation-update` | `clean-code` |

---

## Loading Protocol

### Before Starting Any Task

```markdown
1. CHECK: Does the workflow have `skills_required` field?
   - YES → Load exactly those skills, skip steps 2-5
   - NO → Continue to step 2

2. Identify task type from matrix above
3. Load `rarv-cycle` (always required)
4. Load 2-3 "Required Skills" for your task type
5. Load 1-2 "Optional Skills" only if directly relevant
6. Total loaded: 4-6 skills maximum (never exceed 7)
```

### Skill Loading Syntax

When loading a skill, read ONLY the sections you need:

```markdown
**Loading skill: [skill-name]**
- Reading: Overview, Quick Reference
- Skipping: Detailed examples (will reference if needed)
```

### Mid-Task Skill Addition

If you need a skill not initially loaded:

```markdown
**Adding skill: [skill-name]**
- Reason: [why needed now]
- Dropping: [skill-name] (if at limit)
```

---

## Anti-Patterns

| Anti-Pattern | Why It's Wrong | Do This Instead |
|--------------|----------------|-----------------|
| Load all agent skills | Context overflow, drift | Load 5-7 max per task |
| Load skills "just in case" | Wastes context | Load on demand |
| Read entire SKILL.md files | Most content not needed | Read Overview + Quick Reference |
| Keep all skills loaded across tasks | Stale context | Reset skills per task |

---

## Quick Reference

```
BEFORE TASK:
1. What type of task? → Check matrix
2. Load rarv-cycle + 3-5 task-specific skills
3. Max 7 skills total

DURING TASK:
- Need new skill? Add it, drop least-used
- Reference skill details only when needed

AFTER TASK:
- Mental reset of loaded skills
- Next task gets fresh skill selection
```
