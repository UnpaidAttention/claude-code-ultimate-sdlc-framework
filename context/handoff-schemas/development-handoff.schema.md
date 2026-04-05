# Development Handoff Schema

## Required Sections

A valid `development-handoff.md` MUST contain ALL of these sections:

### 1. Implementation Summary
**Required fields**:
- [ ] Total AIOUs implemented
- [ ] Wave completion status (all 7 waves)
- [ ] Key implementation decisions

### 2. Technical Documentation
**Required fields**:
- [ ] API documentation reference
- [ ] Database schema reference
- [ ] Component documentation reference

### 3. Test Coverage Report
**Required fields**:
- [ ] Unit test coverage percentage (must be minimum 80%)
- [ ] Integration test summary
- [ ] E2E test summary
- [ ] Test report link/reference

### 4. Known Issues
**Required fields**:
- [ ] List of known issues (or "None")
- [ ] Each issue has: ID, description, severity, workaround

### 5. Deployment Instructions
**Required fields**:
- [ ] Build commands
- [ ] Environment variables required
- [ ] Deployment steps
- [ ] Rollback procedure
- [ ] Operational runbook reference (`.ultimate-sdlc/specs/operations/runbook.md`) — or N/A if Lightweight/Standard
- [ ] SLI/SLO baselines from production (or "pending — first deploy")

### 5b. Technical Documentation (Standard/Enterprise only)
**Required fields**:
- [ ] README.md exists at project root
- [ ] ARCHITECTURE.md exists
- [ ] API_GUIDE.md exists (or N/A if no API)
- [ ] TROUBLESHOOTING.md exists
- [ ] All docs reference actual implemented state (not planning-phase specs)

### 6. Verification & Sign-off
**Required fields**:
- [ ] Verification agent: [AI model identifier]
- [ ] Verification timestamp: [ISO 8601]
- [ ] Verification method: [Artifact-based / Command-based / Manual review]
- [ ] Confirmation: "All waves complete" — evidence: [link to current-state.md showing all waves checked]
- [ ] Confirmation: "Gate I8 passed" — evidence: [link to gate checklist with all criteria PASS]
- [ ] Test results summary
- [ ] Development lead sign-off: [Agent ID]

---

## Validation Checklist

```markdown
## Development Handoff Validation

- [ ] Implementation Summary present (AIOUs: ___/___)
- [ ] Technical Documentation references present
- [ ] Test Coverage minimum 80%: YES/NO (actual: ___%)
- [ ] Known Issues documented (count: ___)
- [ ] Deployment Instructions complete
- [ ] Sign-off present and signed

- [ ] Operational Runbook present: YES/NO/N/A
- [ ] Technical Documentation present: YES/NO/N/A (count: ___)

**VALIDATION STATUS**: VALID / INVALID
```
