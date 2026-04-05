---
name: sdlc-dev-validate-css
description: |
  Verify all CSS variables are defined and synchronized
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/css-validation/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/design-tokens/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/ui-ux-analysis/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# Workflow: CSS Variable Validation

> **Command**: `/dev-validate-css`
> **Purpose**: Verify all CSS variables are defined and synchronized
> **When**: Before marking Layer 1 complete, after any design token changes

---

## Lens / Skills / Model
**Lens**: `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocols per `~/.claude/skills/ultimate-sdlc/rules/council-development.md`

## Overview

This workflow validates that:
1. All CSS variables used in components are defined in globals.css
2. Design token files are synchronized (no conflicting values)
3. Tailwind configuration properly references CSS variables
4. All semantic color variants exist (light, DEFAULT, dark)

---

## Execution Steps

### Step 1: Scan for CSS Variable Usage

Find all CSS variables referenced in the project:

// turbo
```bash
# Find all var(--*) references in TSX files
grep -r "var(--" src/ --include="*.tsx" --include="*.ts" | \
  grep -oP '\-\-[a-zA-Z0-9-]+' | sort -u > /tmp/used-css-vars.txt

echo "=== CSS Variables Used in Components ==="
cat /tmp/used-css-vars.txt
echo ""
echo "Total: $(wc -l < /tmp/used-css-vars.txt) variables"
```

### Step 2: Scan for CSS Variable Definitions

Find all CSS variables defined in stylesheets:

// turbo
```bash
# Find all CSS variable definitions
grep -oP '\-\-[a-zA-Z0-9-]+(?=:)' src/styles/globals.css | sort -u > /tmp/defined-css-vars.txt

echo "=== CSS Variables Defined in globals.css ==="
cat /tmp/defined-css-vars.txt
echo ""
echo "Total: $(wc -l < /tmp/defined-css-vars.txt) variables"
```

### Step 3: Find Missing Variables

Compare used vs defined:

// turbo
```bash
echo "=== MISSING CSS Variables (CRITICAL) ==="
comm -23 /tmp/used-css-vars.txt /tmp/defined-css-vars.txt

MISSING_COUNT=$(comm -23 /tmp/used-css-vars.txt /tmp/defined-css-vars.txt | wc -l)
if [ "$MISSING_COUNT" -gt 0 ]; then
  echo ""
  echo "ERROR: $MISSING_COUNT CSS variables are used but not defined!"
  echo "These MUST be added to globals.css before proceeding."
else
  echo "All CSS variables are properly defined."
fi
```

### Step 4: Verify Semantic Color Completeness

Check that all semantic colors have required variants:

// turbo
```bash
echo "=== Semantic Color Variant Check ==="

# Required semantic colors and their variants
SEMANTICS="success warning error info"
VARIANTS="light DEFAULT dark"

for semantic in $SEMANTICS; do
  echo "Checking $semantic..."
  for variant in $VARIANTS; do
    if [ "$variant" = "DEFAULT" ]; then
      VAR_NAME="--color-$semantic"
    else
      VAR_NAME="--color-$semantic-$variant"
    fi

    if grep -q "$VAR_NAME:" src/styles/globals.css; then
      echo "  $VAR_NAME"
    else
      echo "  MISSING: $VAR_NAME"
    fi
  done
done
```

### Step 5: Check Token Synchronization (if tokens.ts exists)

If the project has a tokens.ts file, verify it matches globals.css:

// turbo
```bash
if [ -f "src/lib/tokens.ts" ]; then
  echo "=== Token Synchronization Check ==="
  echo "tokens.ts exists - checking for value mismatches..."

  # Extract brand-500 from both files and compare
  TOKENS_BRAND=$(grep "500:" src/lib/tokens.ts | head -1)
  CSS_BRAND=$(grep "\-\-color-brand-500:" src/styles/globals.css | head -1)

  echo "tokens.ts brand-500: $TOKENS_BRAND"
  echo "globals.css brand-500: $CSS_BRAND"

  echo ""
  echo "WARNING: If these values differ, choose ONE source of truth:"
  echo "  Option A: Use tokens.ts and generate globals.css from it"
  echo "  Option B: Use globals.css as source and delete/ignore tokens.ts"
else
  echo "=== Token Synchronization Check ==="
  echo "No tokens.ts file found - globals.css is the source of truth."
fi
```

### Step 6: Verify Tailwind Config

Check that Tailwind properly references CSS variables:

// turbo
```bash
echo "=== Tailwind Configuration Check ==="

if [ -f "tailwind.config.js" ]; then
  # Check for CSS variable usage
  if grep -q "var(--" tailwind.config.js; then
    echo "Tailwind config references CSS variables."
  else
    echo "WARNING: Tailwind config may not be using CSS variables."
  fi

  # Check for version consistency
  if grep -q "@import.*tailwindcss" src/styles/globals.css; then
    echo "globals.css uses Tailwind v4 syntax (@import)"
    if grep -q "content:" tailwind.config.js; then
      echo "WARNING: tailwind.config.js uses v3 syntax (content:)"
      echo "This may cause configuration conflicts."
    fi
  fi
fi
```

### Step 7: Visual Render Test

Create a test component to verify colors render:

```tsx
// Create temporary test file: src/__css-validation-test__.tsx
export function CSSValidationTest() {
  return (
    <div className="p-8 space-y-4">
      <h1 className="text-2xl font-bold">CSS Variable Validation</h1>

      {/* Brand Colors */}
      <div>
        <h2 className="font-semibold mb-2">Brand Colors</h2>
        <div className="flex gap-2">
          {[50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950].map(n => (
            <div
              key={n}
              className={`w-10 h-10 rounded bg-brand-${n}`}
              title={`brand-${n}`}
            />
          ))}
        </div>
      </div>

      {/* Semantic Colors */}
      <div>
        <h2 className="font-semibold mb-2">Semantic Colors</h2>
        <div className="grid grid-cols-4 gap-4">
          <div className="space-y-1">
            <div className="h-8 rounded bg-[var(--color-success-light)]" />
            <div className="h-8 rounded bg-[var(--color-success)]" />
            <div className="h-8 rounded bg-[var(--color-success-dark)]" />
            <span className="text-xs">Success</span>
          </div>
          <div className="space-y-1">
            <div className="h-8 rounded bg-[var(--color-warning-light)]" />
            <div className="h-8 rounded bg-[var(--color-warning)]" />
            <div className="h-8 rounded bg-[var(--color-warning-dark)]" />
            <span className="text-xs">Warning</span>
          </div>
          <div className="space-y-1">
            <div className="h-8 rounded bg-[var(--color-error-light)]" />
            <div className="h-8 rounded bg-[var(--color-error)]" />
            <div className="h-8 rounded bg-[var(--color-error-dark)]" />
            <span className="text-xs">Error</span>
          </div>
          <div className="space-y-1">
            <div className="h-8 rounded bg-[var(--color-info-light)]" />
            <div className="h-8 rounded bg-[var(--color-info)]" />
            <div className="h-8 rounded bg-[var(--color-info-dark)]" />
            <span className="text-xs">Info</span>
          </div>
        </div>
      </div>

      {/* Background/Foreground */}
      <div>
        <h2 className="font-semibold mb-2">Base Colors</h2>
        <div className="p-4 rounded border border-[var(--color-border)] bg-[var(--color-background)]">
          <p className="text-[var(--color-foreground)]">Foreground text on background</p>
          <p className="text-[var(--color-muted-foreground)]">Muted foreground text</p>
        </div>
      </div>
    </div>
  );
}
```

### Output: CSS Validation Report

```css
--color-success-dark: hsl(142, 72%, 32%);
--color-warning-dark: hsl(38, 92%, 35%);
--color-error-dark: hsl(0, 84%, 40%);
--color-info-dark: hsl(199, 89%, 32%);
```

### Missing Input Background

Add to globals.css:
```css
--color-input: hsl(220, 14%, 96%);

.dark {
  --color-input: hsl(220, 14%, 14%);
}
```

### Token Mismatch

Choose ONE source of truth:
1. **Use globals.css as source**: Delete or ignore tokens.ts
2. **Use tokens.ts as source**: Generate globals.css from tokens.ts

---

## Integration

This workflow should be run:
- Automatically by `/dev-wave5-start` for Layer 1 validation
- Manually with `/dev-validate-css` when troubleshooting
- Before marking any Layer 1 AIOU as complete

---

## Related

- `wave5-foundation-validation.md` - Full Layer 1 validation
- `wave5-ui-layers.md` - Layer completion requirements
