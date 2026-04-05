name: efficiency-metrics
description: Use when completing tasks to track performance and identify bottlenecks across council workflows

# Efficiency Metrics

## Purpose

Track time, effort, and retry patterns per task to identify bottlenecks, optimize workflows, and improve framework effectiveness over time.

## Metrics Architecture

```
.metrics/
├── tasks/
│   ├── planning/       # Planning council task metrics
│   ├── development/    # Development council task metrics
│   ├── audit/          # Audit council task metrics
│   └── validation/     # Validation council task metrics
└── summaries/
    └── weekly/         # Aggregated weekly reports
```

## Task Metrics

Record for every completed task:

### Format: `.metrics/tasks/[council]/YYYY-MM-DD-[task-id].md`

```markdown
# Task Metrics: [Task ID/Name]

**Date**: YYYY-MM-DD
**Council**: [Council name]
**Phase**: [Phase number]

## Time Metrics

| Metric | Value |
|--------|-------|
| Start Time | HH:MM |
| End Time | HH:MM |
| Duration | [minutes] |
| Active Time | [minutes working vs waiting] |

## Effort Metrics

| Metric | Value |
|--------|-------|
| Agent Invocations | [count] |
| Subagent Dispatches | [count] |
| Files Modified | [count] |
| Lines Changed | [+added / -removed] |

## Quality Metrics

| Metric | Value |
|--------|-------|
| RARV Cycles | [count] |
| Retries | [count with reasons] |
| Review Rounds | [count] |
| Issues Found (Review) | [count by severity] |

## Outcome

**Status**: [Success/Partial/Failed]
**Artifacts**: [List of deliverables]

## Retry Log

| Attempt | Reason | Resolution |
|---------|--------|------------|
| 1 | Initial | - |
| 2 | [Why retry needed] | [What fixed it] |

## Notes

[Any context about efficiency or blockers]
```

## What to Track

### Always Track

- **Duration**: Total time from start to completion
- **Agent invocations**: How many agent calls needed
- **Retries**: Number of failed attempts before success
- **Review rounds**: How many review cycles before approval

### Track When Available

- **Active vs wait time**: Time actually working vs waiting for reviews/responses
- **Subagent dispatches**: Count of subagent tasks
- **Files and lines**: Scope of changes made

## Recording Workflow

1. **Task start**: Note start time in WORKING-MEMORY.md
2. **During task**: Increment counters as actions occur
3. **Task end**: Calculate totals, create metrics file
4. **Weekly**: Aggregate into summary

## Weekly Summary Format

### File: `.metrics/summaries/weekly/YYYY-WNN.md`

```markdown
# Weekly Metrics Summary: Week NN, YYYY

**Period**: YYYY-MM-DD to YYYY-MM-DD

## Overview

| Council | Tasks Completed | Avg Duration | Total Retries |
|---------|-----------------|--------------|---------------|
| Planning | [N] | [X min] | [N] |
| Development | [N] | [X min] | [N] |
| Audit | [N] | [X min] | [N] |
| Validation | [N] | [X min] | [N] |

## Efficiency Trends

### Time per Task

| Council | This Week | Last Week | Change |
|---------|-----------|-----------|--------|
| Planning | [X min] | [Y min] | [+/-Z%] |
| ... | | | |

### Retry Rate

| Council | This Week | Last Week | Change |
|---------|-----------|-----------|--------|
| Planning | [X%] | [Y%] | [+/-Z%] |
| ... | | | |

## Bottlenecks Identified

1. **[Bottleneck]**: [Description and impact]
   - Affected tasks: [List]
   - Recommendation: [How to address]

## Top Retry Causes

| Cause | Count | Councils Affected |
|-------|-------|-------------------|
| [Cause] | [N] | [List] |

## Wins This Week

- [Efficiency improvement noted]
- [Process that worked well]

## Action Items

- [ ] [Improvement to implement]
- [ ] [Pattern to investigate]
```

## Using Metrics for Improvement

### Identify Bottlenecks

Look for patterns:
- High retry counts → unclear specs or complex requirements
- Long durations → scope creep or blockers
- Many review rounds → quality issues in implementation

### Optimize Workflows

When metrics show:
- **Consistently high retries**: Improve spec detail before starting
- **Long wait times**: Parallel work opportunities
- **Many agent invocations**: Consider better context loading

### Benchmark Against Self

Track week-over-week:
- Is average task duration decreasing?
- Are retry rates dropping?
- Are fewer review rounds needed?

## Integration Points

### With WORKING-MEMORY.md

```markdown
## Metrics This Session

- Tasks started: [N]
- Tasks completed: [N]
- Total retries: [N]
- Active time: [X min]
```

### With Memory System

When writing episodic memory, include:
- Duration and efficiency observations
- Retry causes for future reference
- Bottleneck patterns to semantic memory

### With RARV Cycle

In REFLECT phase, note:
- Was this retry-heavy? Why?
- Was duration as expected?
- What would make this faster next time?

## Common Metrics Patterns

| Pattern | Indicates | Action |
|---------|-----------|--------|
| First attempt always fails | Spec gaps | Improve spec clarity |
| Review rounds > 2 | Quality issues | More thorough self-review |
| Long duration, low effort | Blockers | Better dependency tracking |
| High agent count | Context loss | Better context management |

## Quick Reference

```
RECORD at task end:
- Duration (start to end)
- Agent invocations
- Retries (count + causes)
- Review rounds
- Outcome

WEEKLY aggregate:
- Tasks per council
- Average duration
- Retry rates
- Bottlenecks

USE metrics to:
- Identify patterns
- Optimize workflows
- Track improvement
```

## Minimal Tracking (Quick Tasks)

For simple tasks, inline metrics in WORKING-MEMORY.md:

```markdown
## Completed This Session

| Task | Duration | Retries | Notes |
|------|----------|---------|-------|
| [Task] | 15 min | 0 | Clean execution |
| [Task] | 45 min | 2 | Spec unclear, clarified |
```

Graduate to full metrics files for complex tasks or when patterns emerge.
