# Skill Template

Use this template when creating new skills for the Ultimate SDLC Framework.

## File Location

```
.agent/skills/{skill-name}/SKILL.md
```

- Skill name should be lowercase, hyphenated
- One SKILL.md file per skill directory
- Supporting files can be in same directory if needed

---

## Template Structure

```markdown
---
name: {skill-name}
description: {One sentence describing what this skill covers and when to use it. Include specific triggers like council, phase, or task type.}
---

# {Skill Title}

> {One-line tagline summarizing the skill's purpose}

---

## Core Principles

| Principle | Rule |
|-----------|------|
| **Principle 1** | Brief rule statement |
| **Principle 2** | Brief rule statement |
| **Principle 3** | Brief rule statement |

---

## When to Use

- {Specific situation 1}
- {Specific situation 2}
- {Council/Phase reference if applicable}
- {Task type trigger}

---

## {Main Content Section 1}

{Detailed guidance, tables, code examples as needed}

---

## {Main Content Section 2}

{Additional content sections as needed}

---

## Quick Reference

{Optional: One-page summary or decision table}

---

## Anti-Patterns

| Mistake | Why It's Wrong | Do Instead |
|---------|----------------|------------|
| {Common mistake 1} | {Explanation} | {Correct approach} |
| {Common mistake 2} | {Explanation} | {Correct approach} |

---

## Related Skills

- `{related-skill-1}` - {When to use instead/together}
- `{related-skill-2}` - {When to use instead/together}
```

---

## Required Sections

Every skill MUST have:

| Section | Purpose |
|---------|---------|
| **Frontmatter** | YAML with name and description |
| **Title** | H1 header matching skill name |
| **Tagline** | One-line summary as blockquote |
| **Core Principles** | 3-6 guiding principles as table |
| **When to Use** | Specific triggers for loading |
| **Main Content** | The actual skill guidance |

## Optional Sections

| Section | When to Include |
|---------|-----------------|
| **Quick Reference** | Skill has many rules to remember |
| **Anti-Patterns** | Common mistakes need calling out |
| **Related Skills** | Disambiguation needed |
| **Examples** | Complex concepts need demonstration |
| **Checklists** | Process-oriented skills |

---

## Frontmatter Guidelines

### Name

- Lowercase, hyphenated
- Match directory name exactly
- Be specific but concise

**Good**: `api-design`, `security-testing`, `aiou-decomposition`
**Bad**: `api`, `testing`, `decomposition`

### Description

Must include:
1. **What** the skill covers (1-2 clauses)
2. **When** to use it (specific triggers)

**Template**:
```
{Covers X and Y}. Use when {trigger 1}, {trigger 2}, or during {Phase/Wave}.
```

**Example**:
```
description: Covers RESTful API design including resource modeling and OpenAPI specifications. Use when designing new API endpoints, reviewing API contracts, or implementing API layer during Wave 4.
```

---

## Content Guidelines

### Tables Over Prose

Prefer tables for:
- Rules and principles
- Decision matrices
- Comparisons
- Quick references

### Code Examples

Include when:
- Syntax matters
- Format is specific
- Pattern is easier to show than describe

### Actionable Language

- Use imperative voice: "Do X" not "You should do X"
- Be specific: "Use PascalCase" not "Use appropriate casing"
- Include the "why" when non-obvious

---

## Validation Checklist

Before adding a new skill:

- [ ] Frontmatter has name and description
- [ ] Name matches directory name
- [ ] Description includes triggers (when to use)
- [ ] Core Principles section present (3-6 principles)
- [ ] When to Use section is specific
- [ ] Content is actionable, not just informational
- [ ] Related skills section if overlap exists
- [ ] No duplication of content in existing skills
