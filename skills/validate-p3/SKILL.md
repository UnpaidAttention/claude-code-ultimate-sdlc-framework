---
name: sdlc-validate-p3
description: |
  Execute Production Track P3 - Performance Optimization. Optimize application performance for production.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/performance-optimization/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/load-testing/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/profiling-analysis/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/resource-optimization/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /validate-p3 - Performance Optimization

## Lens / Skills / Model
**Lens**: `[Performance]` | **Model**: Claude Opus 4.5
> Apply RARV cycle, session protocol per council-validation.md

## Prerequisites

- P2 (Failure Mode Analysis) must be complete

If prerequisites not met:
```
P2 not complete. Run /validate-p2 first.
```

---

## Workflow

### Step 1: Update Project State

Update `.ultimate-sdlc/project-context.md`:
- Set `Current Phase`: P3 - Performance Optimization
- Set `Status`: in_progress

### Agent: performance
Invoke via Agent tool with `subagent_type: "sdlc-performance"`:
- **Provide**: Current performance baselines, Lighthouse reports, load test results, profiling data, bundle analysis
- **Request**: Analyze performance data and recommend optimizations — identify top bottlenecks by impact, suggest specific database/application/frontend optimizations, and define target metrics
- **Apply**: Use optimization recommendations to guide Steps 3 and 4

### Step 2: Performance Baseline

Establish baseline metrics using available tools:

**Web Vitals (for web applications):**
- Run Lighthouse MCP audit (`lighthouse_audit`) to capture LCP, CLS, INP, TBT, and Performance Score
- If Lighthouse MCP unavailable: run `npx lighthouse <url> --output=json --chrome-flags="--headless"` via terminal
- Use Chrome DevTools MCP for runtime performance traces (if available)

**Bundle Analysis (for frontend applications):**
- Run `npx bundlesize` or equivalent for bundle size analysis
- Check tree-shaking effectiveness and code splitting

Use **Display Template** from `council-validation.md` to show: Performance Baseline

### Step 3: Optimization Areas

Identify and address optimization areas:

#### Database Optimization
- [ ] Query analysis (slow queries)
- [ ] Index optimization
- [ ] Connection pooling
- [ ] Query caching

#### Application Optimization
- [ ] Code profiling
- [ ] Memory leak detection
- [ ] Algorithm optimization
- [ ] Caching strategy

#### Frontend Optimization
- [ ] Bundle size analysis
- [ ] Lazy loading
- [ ] Image optimization
- [ ] CDN configuration

### Step 4: Load Testing

Conduct load tests using k6 MCP (`execute_k6_test`) or terminal fallback:

**Using k6 MCP:**
1. Generate k6 load test script for critical API endpoints
2. Execute scenarios via k6 MCP:
   - **Normal load**: 10 VUs, 30 seconds
   - **Peak load**: 50 VUs, 60 seconds
   - **Stress test**: Ramping from 10 to 200 VUs over 120 seconds
3. Capture response time percentiles (p50, p95, p99) and throughput from k6 output

**If k6 MCP unavailable:** Generate k6 script and instruct user to run `k6 run load-test.js` manually. Alternatively, use `ab -n 1000 -c 50 <url>` for basic throughput testing via terminal.

Use **Display Template** from `council-validation.md` to show: Load Test Results

### Step 5: Phase Completion Criteria

- [ ] Baseline established
- [ ] Optimizations implemented
- [ ] Load testing complete
- [ ] Performance targets met

### Step 6: Complete Phase

```
## P3: Performance Optimization - Complete

**Optimizations Made**: [X]
**Performance Improvement**: [Y]%
**All Targets Met**: [Yes/No]

**Next Step**: Run `/validate-p4` to continue to Security Hardening
```

---
