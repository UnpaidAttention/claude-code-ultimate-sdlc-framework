---
name: sdlc-orchestrate
description: |
  Coordinate multiple agents for complex tasks. Use for multi-perspective analysis, comprehensive reviews, or tasks requiring different domain expertise.
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
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/orchestration-patterns/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/aiou-decomposition/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/parallel-execution/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/task-delegation/SKILL.md`
- Read `~/.claude/plugins/cache/ultimate-sdlc/ultimate-sdlc/3.1.0/knowledge/rarv-cycle/SKILL.md`


# Multi-Agent Orchestration

---

## Lens / Skills / Model
**Lens**: `[Architecture]` | **Model**: Claude Sonnet 4
> Apply RARV cycle, session protocol per the active council rules file

You are now in **ORCHESTRATION MODE**. Your task: coordinate specialized agents to solve this complex problem.

## Task to Orchestrate
## Arguments
| Argument | Required | Description |
|----------|----------|-------------|
| (none) | — | Session auto-detects state |

---

## 🔴 CRITICAL: Minimum Agent Requirement

> ⚠️ **ORCHESTRATION = MINIMUM 3 DIFFERENT AGENTS**
> 
> If you use fewer than 3 agents, you are NOT orchestrating - you're just delegating.
> 
> **Validation before completion:**
> - Count invoked agents
> - If `agent_count < 3` → STOP and invoke more agents
> - Single agent = FAILURE of orchestration

### Agent Selection Matrix

| Task Type | REQUIRED Agents (minimum) |
|-----------|---------------------------|
| **Web App** | [UX], [Architecture], [Quality] |
| **API** | [Architecture], [Security], [Quality] |
| **UI/Design** | [UX], [Documentation], [Performance] |
| **Database** | [Architecture], [Operations], [Security] |
| **Full Stack** | [Requirements], [UX], [Architecture], [Operations] |
| **Debug** | debugger, explorer-agent, [Quality] |
| **Security** | [Security], [Security], [Operations] |

---

## Pre-Flight: Mode Check

| Current Mode | Task Type | Action |
|--------------|-----------|--------|
| **plan** | Any | ✅ Proceed with planning-first approach |
| **edit** | Simple execution | ✅ Proceed directly |
| **edit** | Complex/multi-file | ⚠️ Ask: "This task requires planning. Switch to plan mode?" |
| **ask** | Any | ⚠️ Ask: "Ready to orchestrate. Switch to edit or plan mode?" |

---

## 🔴 STRICT 2-PHASE ORCHESTRATION

### PHASE 1: PLANNING (Sequential - NO parallel agents)

| Step | Agent | Action |
|------|-------|--------|
| 1 | `[Requirements]` | Create docs/PLAN.md |
| 2 | (optional) `explorer-agent` | Codebase discovery if needed |

> 🔴 **NO OTHER AGENTS during planning!** Only [Requirements] and explorer-agent.

### ⏸️ CHECKPOINT: User Approval

```
After PLAN.md is complete, ASK:

"✅ Plan oluşturuldu: docs/PLAN.md

Onaylıyor musunuz? (Y/N)
- Y: Implementation başlatılır
- N: Planı düzeltirim"
```

> 🔴 **DO NOT proceed to Phase 2 without explicit user approval!**

### PHASE 2: IMPLEMENTATION (Parallel agents after approval)

| Parallel Group | Agents |
|----------------|--------|
| Foundation | `[Architecture]`, `[Security]` |
| Core | `[Architecture]`, `[UX]` |
| Polish | `[Quality]`, `[Operations]` |

> ✅ After user approval, invoke multiple agents in PARALLEL.

## Available Agents (17 total)

| Agent | Domain | Use When |
|-------|--------|----------|
| `[Requirements]` | Planning | Task breakdown, PLAN.md |
| `explorer-agent` | Discovery | Codebase mapping |
| `[UX]` | UI/UX | React, Vue, CSS, HTML |
| `[Architecture]` | Server | API, Node.js, Python |
| `[Architecture]` | Data | SQL, NoSQL, Schema |
| `[Security]` | Security | Vulnerabilities, Auth |
| `[Security]` | Security | Active testing |
| `[Quality]` | Testing | Unit, E2E, Coverage |
| `[Operations]` | Ops | CI/CD, Docker, Deploy |
| `mobile-developer` | Mobile | React Native, Flutter |
| `[Performance]` | Speed | Lighthouse, Profiling |
| `[Documentation]` | SEO | Meta, Schema, Rankings |
| `[Documentation]` | Docs | README, API docs |
| `debugger` | Debug | Error analysis |
| `game-developer` | Games | Unity, Godot |
| `orchestrator` | Meta | Coordination |

---

## Orchestration Protocol

### Step 1: Analyze Task Domains
Identify ALL domains this task touches:
```
□ Security     → [Security], [Security]
□ Backend/API  → [Architecture]
□ Frontend/UI  → [UX]
□ Database     → [Architecture]
□ Testing      → [Quality]
□ DevOps       → [Operations]
□ Mobile       → mobile-developer
□ Performance  → [Performance]
□ SEO          → [Documentation]
□ Planning     → [Requirements]
```

### Step 2: Phase Detection

| If Plan Exists | Action |
|----------------|--------|
| NO `docs/PLAN.md` | → Go to PHASE 1 (planning only) |
| YES `docs/PLAN.md` + user approved | → Go to PHASE 2 (implementation) |

### Step 3: Execute Based on Phase

**PHASE 1 (Planning):**
```
Use the [Requirements] agent to create PLAN.md
→ STOP after plan is created
→ ASK user for approval
```

**PHASE 2 (Implementation - after approval):**
```
Invoke agents in PARALLEL:
Use the [UX] agent to [task]
Use the [Architecture] agent to [task]
Use the [Quality] agent to [task]
```

**🔴 CRITICAL: Context Passing (MANDATORY)**

When invoking ANY subagent, you MUST include:

1. **Original User Request:** Full text of what user asked
2. **Decisions Made:** All user answers to Socratic questions
3. **Previous Agent Work:** Summary of what previous agents did
4. **Current Plan State:** If `~/.claude/plans/` has a plan, include it

**Example with FULL context:**
```
Use the [Requirements] agent to create PLAN.md:

**CONTEXT:**
- User Request: "Öğrenciler için sosyal platform, mock data ile"
- Decisions: Tech=Vue 3, Layout=Grid Widget, Auth=Mock, Design=Genç Dinamik
- Previous Work: Orchestrator asked 6 questions, user chose all options
- Current Plan: ~/.claude/plans/playful-roaming-dream.md exists with initial structure

**TASK:** Create detailed PLAN.md based on ABOVE decisions. Do NOT infer from folder name.
```

> ⚠️ **VIOLATION:** Invoking subagent without full context = subagent will make wrong assumptions!


### Step 4: Verification (MANDATORY)
The LAST agent must run appropriate verification scripts:
```bash
python ~/.claude/skills/vulnerability-scanner/scripts/security_scan.py .
python ~/.claude/skills/lint-and-validate/scripts/lint_runner.py .
```

### Step 5: Synthesize Results
Combine all agent outputs into unified report.

---

## Output Format

Use **Display Template** from `the active council rules file` to show: 🎼 Orchestration Report

---

## 🔴 EXIT GATE

Before completing orchestration, verify:

1. ✅ **Agent Count:** `invoked_agents >= 3`
2. ✅ **Scripts Executed:** At least `security_scan.py` ran
3. ✅ **Report Generated:** Orchestration Report with all agents listed

> **If any check fails → DO NOT mark orchestration complete. Invoke more agents or run scripts.**

---

**Begin orchestration now. Select 3+ agents, execute sequentially, run verification scripts, synthesize results.**
