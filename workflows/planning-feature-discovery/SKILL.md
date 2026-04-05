---
name: planning-feature-discovery
description: |
  Multi-agent deliberation to discover and specify ALL features for the product
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
- Read `~/.claude/skills/antigravity/knowledge/multi-perspective-analysis/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/feature-spec/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/prioritization/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/documentation-standards/SKILL.md`
- Read `~/.claude/skills/antigravity/knowledge/rarv-cycle/SKILL.md`


# Planning Feature Discovery Workflow

---

## Lens / Skills / Model
**Lens**: `[Requirements]` | **Model**: Claude Opus 4.5
> Apply RARV cycle, session protocol per council-planning.md

## Description

Orchestrates a comprehensive multi-agent deliberation to discover, evaluate, and prioritize ALL features that should be included in the software product. This phase ensures no critical features are missed before detailed specification begins.

## Why This Workflow Exists

Feature discovery is often incomplete when done by a single perspective. Critical features get missed, leading to scope creep, rework, and gaps in the final product. This workflow brings together five specialized agents to ensure comprehensive feature coverage from every angle: product vision, user experience, domain expertise, technical constraints, and business value.

## Pre-Conditions

- Phase 2 (Architecture) must be complete
- Architecture decisions (ADRs) are documented
- Technology stack is defined
- System boundaries are established

## Agents Involved

| Agent | Perspective | Focus |
|-------|-------------|-------|
| **Product Visionary** | Product Strategy | What features fulfill the vision? |
| **UX Strategist** | User Experience | What features support great UX? |
| **Domain Expert** | Industry Knowledge | What features are domain-required? |
| **Technical Validator** | Feasibility | What features are technically needed? |
| **Business Analyst** | Business Value | What features deliver ROI? |

## Steps

### Step 1: Initialize Discovery Session

Enter **Plan Mode** for comprehensive deliberation.

Load context:
- Product vision and goals from Phase 1
- Architecture decisions from Phase 2
- User personas and journeys
- Domain/industry context

Announce deliberation session:
```
Phase 2.5: Feature Discovery & Deliberation

Objective: Discover ALL features needed for [Product Name]

Engaging specialized agents:
- Product Visionary: Product strategy perspective
- UX Strategist: User experience perspective
- Domain Expert: Industry/domain perspective
- Technical Validator: Technical feasibility perspective
- Business Analyst: Business value perspective
```

### Step 2: Product Visionary Discovery

Delegate to `product-visionary` agent:

**Prompt**: "Analyze the product vision and identify ALL features needed to fulfill it. Consider:
- Core features that deliver the primary value proposition
- Table stakes features users expect as baseline
- Differentiating features that set us apart
- Delighter features that exceed expectations
- Enabling features that support other capabilities

Output a comprehensive feature inventory with rationale."

**Expected Output**: Feature inventory with categories and rationale

### Step 3: UX Strategist Discovery

Delegate to `ux-strategist` agent:

**Prompt**: "Analyze user journeys and identify ALL UX-related features needed. Consider:
- Onboarding and first-time user experience
- Navigation and wayfinding
- Feedback and status communication
- Help and support features
- Accessibility requirements (WCAG 2.2 AA)
- Error prevention and recovery
- Personalization and preferences

Output UX feature requirements with journey mapping."

**Expected Output**: UX feature analysis with journey integration

### Step 4: Domain Expert Discovery

Delegate to `domain-expert` agent:

**Prompt**: "Analyze domain/industry requirements and identify ALL domain-specific features. Consider:
- Regulatory and compliance requirements
- Industry standard workflows
- Domain-specific terminology support
- Required integrations and data standards
- Audit and reporting requirements
- Certification maintenance features

Output domain feature requirements with compliance mapping."

**Expected Output**: Domain feature analysis with compliance requirements

### Step 5: Technical Validator Assessment

Apply `[Quality]` lens:

**Prompt**: "Review all discovered features and:
1. Assess technical feasibility of each feature
2. Identify additional technical features needed (infrastructure, APIs, integrations)
3. Estimate implementation complexity
4. Map technical dependencies between features
5. Flag any features that are technically impractical

Output feasibility assessment and technical feature additions."

**Expected Output**: Technical validation report with additional technical features

### Step 6: Business Analyst Prioritization

Delegate to `business-analyst` agent:

**Prompt**: "Analyze all discovered features and:
1. Assess business value of each feature
2. Calculate RICE scores for implementation ordering
3. Perform cost-benefit analysis
4. Identify dependencies and logical build order
5. Group features by module/domain

Output feature analysis with business justification and recommended build order."

**Expected Output**: Business value analysis with implementation ordering

### Step 7: Deliberation Synthesis

As the hub, synthesize all agent outputs:

1. **Merge Feature Lists**: Combine all discovered features, removing duplicates
2. **Resolve Conflicts**: Address any conflicting assessments between agents
3. **Validate Completeness**: Ensure all perspectives are represented
4. **Apply Prioritization**: Use business analyst's prioritization as baseline
5. **Mark Dependencies**: Create dependency graph

### Step 8: Generate Comprehensive Feature Specification

Create the **Comprehensive Feature Specification** document using the template.

Generate a **Documentation Artifact** containing:

Use **Display Template** from `council-planning.md` to show: Comprehensive Feature Specification

### Step 9: Verify Completeness

Before finalizing, verify with all agents:

- [ ] Product Visionary: All vision-critical features included?
- [ ] UX Strategist: All UX requirements covered?
- [ ] Domain Expert: All compliance features included?
- [ ] Technical Validator: All technically feasible?
- [ ] Business Analyst: Prioritization agreed?

### Step 10: Save and Update Progress

1. Save Comprehensive Feature Specification to `specs/features/comprehensive-feature-specification.md`
2. Update `.antigravity/project-context.md` with Phase 2.5 completion
3. Update `.antigravity/progress.md` with deliberation summary
4. Save to Knowledge Base: `{PROJECT}-PLANNING-FEATURE-DISCOVERY-COMPLETE`

## Artifacts Generated

- **Plan Artifact**: Feature discovery approach
- **Documentation Artifact**: Comprehensive Feature Specification
- **Diagram Artifact**: Feature Dependency Graph (optional)

## Success Criteria

- [ ] All 5 agent perspectives represented
- [ ] Feature inventory is comprehensive (no obvious gaps)
- [ ] All features have implementation ordering assessed
- [ ] Full scope confirmed (all features in scope by default)
- [ ] Dependencies are mapped
- [ ] Risks are identified
- [ ] Document saved and progress updated

## Transition to Phase 3

After Phase 2.5 completion:
- Phase 3 uses the Comprehensive Feature Specification as input
- Each feature in scope-lock.md gets detailed 8-section matrix
- Dependency order and module grouping guide which features to specify first

## Tips for Quality

1. **Don't rush** - This phase prevents expensive rework later
2. **Challenge assumptions** - Each agent should push back on others
3. **Be comprehensive** - It's easier to cut features than add them later
4. **Document rationale** - Future decisions depend on understanding "why"
5. **Think about edge cases** - Features often hide in error scenarios
