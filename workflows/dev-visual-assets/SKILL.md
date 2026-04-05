---
name: sdlc-dev-visual-assets
description: |
  Manage visual assets during UI development (Wave 5)
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/visual-asset-management/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/ui-ux-analysis/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/evidence-capture/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/verification-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# Visual Assets Protocol

// turbo-all

---

## Lens / Skills / Model
**Lens**: `[UX]` + `[Quality]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol, code review protocol per `council-development.md`

## Trigger
- `/dev-visual-assets check` - Check for visual assets in project
- `/dev-visual-assets capture AIOU-XXX` - Capture implementation screenshot
- `/dev-visual-assets compare AIOU-XXX` - Compare implementation to mockup

## Purpose

Visual assets are critical for UI development:
1. **Mockups/Wireframes** - Reference for what to build
2. **Implementation Screenshots** - Evidence that UI matches design
3. **Comparison** - Verify implementation matches intent

## Visual Asset Protocol

### MANDATORY Check at Wave 5 Start

Before starting any Wave 5 (UI) AIOU, run:

```
/dev-visual-assets check
```

This will:
1. Search for visual assets in project (even if user said "no mockups")
2. Document what was found
3. Create tracking file for visual-to-implementation mapping

**Why mandatory?** Users often upload mockups without mentioning them. Always check.

### Search Locations

```bash
# Common locations for visual assets
ls -la mockups/ 2>/dev/null
ls -la designs/ 2>/dev/null
ls -la assets/mockups/ 2>/dev/null
ls -la docs/designs/ 2>/dev/null
ls -la *.png *.jpg *.jpeg *.gif *.svg *.fig *.sketch 2>/dev/null

# Planning handoff may reference visuals
grep -i "mockup\|wireframe\|design\|figma\|sketch" planning-handoff.md
### Visual Asset Categories
1. Implement the UI component/screen
2. Run the application locally
3. Navigate to the implemented UI
4. Capture screenshot: /dev-visual-assets capture AIOU-XXX
5. Store in verification/screenshots/
6. If mockup exists: /dev-visual-assets compare AIOU-XXX
```

### Screenshot Naming Convention

```
verification/screenshots/
├── AIOU-XXX-component-name.png           # Main implementation
├── AIOU-XXX-component-name-mobile.png    # Mobile breakpoint
├── AIOU-XXX-component-name-hover.png     # Hover state
├── AIOU-XXX-component-name-error.png     # Error state
└── AIOU-XXX-comparison.png               # Side-by-side with mockup
### Capture Methods
browser_navigate → target URL
browser_take_screenshot → saves screenshot data
```

**Using Browser DevTools (fallback):**
1. Open DevTools (F12)
2. Cmd/Ctrl + Shift + P → "Capture screenshot"
3. Save to `verification/screenshots/`

**Manual Screenshot (last resort):**
1. Navigate to UI
2. System screenshot (Cmd+Shift+4 on Mac, Win+Shift+S on Windows)
3. Save to `verification/screenshots/`

See `.reference/screenshot-capture-guide.md` for full capture guide and `.reference/mcp-tool-guide.md` for tool setup.

## Comparison Protocol

When mockup exists, compare implementation:

### Step 1: Gather Assets
Use **Display Template** from `council-development.md` to show: Visual Comparison: AIOU-XXX

### Step 2: Document Differences

Use **Display Template** from `council-development.md` to show: Comparison Results

### Step 3: Fidelity-Appropriate Comparison

| Mockup Fidelity | Compare For |
|-----------------|-------------|
| **Low (Wireframe)** | Layout, structure, element presence |
| **Medium (Lo-Fi)** | Above + spacing, hierarchy, flow |
| **High (Hi-Fi)** | Above + exact colors, fonts, pixel alignment |

## Visual Tracking File

Create `verification/visual-tracking.md` at Wave 5 start:

Use **Display Template** from `council-development.md` to show: Visual Asset Tracking

## Integration with AIOU Verification

`/dev-verify-aiou` for Wave 5 AIOUs will check:

- [ ] Implementation screenshot exists
- [ ] If mockup exists: comparison documented
- [ ] Visual tracking file updated
- [ ] Responsive screenshots (if applicable)

## Output

### Check Output
Use **Display Template** from `council-development.md` to show: Visual Assets Check

### Capture Output
Use **Display Template** from `council-development.md` to show: Screenshot Captured
