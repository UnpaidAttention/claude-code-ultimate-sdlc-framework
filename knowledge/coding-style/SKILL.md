name: coding-style
description: Naming conventions, formatting, and commenting standards. Use when starting implementation, naming functions or variables, deciding file organization, or writing and reviewing code.

# Skill: Coding Style

## When to Use This Skill

Use this skill when:
- Starting implementation of any AIOU
- Naming new functions, classes, or variables
- Deciding on file organization
- Writing or reviewing code

## Quick Reference

### Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| Functions | verb_noun / verbNoun | `get_user()`, `getUser()` |
| Booleans | is_/has_/can_ prefix | `is_active`, `has_permission` |
| Constants | UPPER_SNAKE | `MAX_RETRIES` |
| Classes | PascalCase | `UserService` |
| Files | kebab-case / snake_case | `user-service.ts` |

### Before Creating Anything New

**MANDATORY**: Search codebase first
1. Search for similar functionality
2. Check if pattern already exists
3. Reuse existing patterns when possible
4. Only create new if nothing suitable exists

## Patterns

### Good Naming
```python
# Clear intent
user_count = get_active_users().count()
is_valid = validate_email(email)

# Descriptive function names
def get_active_users_by_role(role: str) -> List[User]:
    ...
```

### Bad Naming (Avoid)
```python
# Unclear
n = get_u().c()
v = val_e(e)

# Abbreviated
def get_usr_by_r(r):
    ...
```

## Formatting

- **Line length**: Maximum 100 characters
- **Indentation**: Consistent per project config
- **Whitespace**: One blank line between functions, two between classes
- **No trailing whitespace**

## Comments

### Do Comment
- Complex business logic
- Non-obvious decisions (with rationale)
- Public API documentation

### Don't Comment
- Self-explanatory code
- Obvious operations
- Disabled code (delete instead)

## Anti-Patterns

- **Magic numbers**: Use named constants
- **Deep nesting**: Extract to functions
- **Long functions**: Split into focused units
- **Duplicate code**: Extract to shared utilities
- **Unclear names**: Be explicit over brief
