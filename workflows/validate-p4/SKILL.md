---
name: sdlc-validate-p4
description: |
  Execute Production Track P4 - Security Hardening. Final security review and hardening before release.
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
- Read `~/.claude/skills/ultimate-sdlc/knowledge/security-hardening/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/vulnerability-scanning/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/owasp-compliance/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/security-patterns/SKILL.md`
- Read `~/.claude/skills/ultimate-sdlc/knowledge/rarv-cycle/SKILL.md`


# /validate-p4 - Security Hardening

## Lens / Skills / Model
**Lens**: `[Security]` | **Model**: Claude Opus 4.5
> Apply RARV cycle, session protocol per council-validation.md

## Prerequisites

- P3 (Performance Optimization) must be complete

If prerequisites not met:
```
P3 not complete. Run /validate-p3 first.
```

---

## Workflow

### Step 1: Update Project State

Update `.ultimate-sdlc/project-context.md`:
- Set `Current Phase`: P4 - Security Hardening
- Set `Status`: in_progress

### Step 2: Security Checklist

Complete security hardening checklist:

Use **Display Template** from `council-validation.md` to show: Security Hardening Checklist

### Step 3: Vulnerability Scan

Run security scans using available tools (MCP servers preferred, terminal fallbacks provided):

**Dependency Scan** (always available via terminal):
- Node: `npm audit` or `npx snyk test`
- Python: `pip-audit` or `safety check`
- Rust: `cargo audit`

**SAST Scan:**
- Use Semgrep MCP if available (5,000+ rules, OWASP coverage)
- If Semgrep MCP unavailable: run `npx semgrep --config=auto .` via terminal
- Alternatively: use Snyk CLI (`npx snyk code test`) for code-level scanning

**DAST Scan (recommended):**
- Use ZAP MCP if available — run spider + active scan on running application
- If ZAP MCP unavailable: use Ultimate SDLC browser extension to manually test injection points (SQLi, XSS, CSRF) against running application
- If neither available: run `nikto -h <url>` via terminal for basic scanning

**Container Scan (if Docker used):**
- Use Trivy MCP if available for Docker image scanning
- If Trivy MCP unavailable: run `trivy image <image-name>` via terminal
- Alternatively: `docker scan <image-name>`

See `.reference/mcp-tool-guide.md` for tool setup and verification.

Use **Display Template** from `council-validation.md` to show: Security Scan Results

### Step 4: Remediation

For each finding:

Use **Display Template** from `council-validation.md` to show: Security Finding: [ID]

### Step 5: Phase Completion Criteria

- [ ] Security checklist complete
- [ ] All critical/high vulnerabilities resolved
- [ ] Dependency vulnerabilities addressed
- [ ] Security scan clean or accepted risk

### Step 6: Complete Phase

Use **Display Template** from `council-validation.md` to show: P4: Security Hardening - Complete

---
