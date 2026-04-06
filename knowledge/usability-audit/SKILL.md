---
name: usability-audit
description: |
  Evaluate software usability using Nielsen's 10 heuristics and user-centered criteria.
---

  Use when: (1) Phase T3 requires usability evaluation, (2) assessing visibility of
  system status and feedback, (3) checking consistency and standards across UI,
  (4) evaluating error prevention and recovery, (5) rating usability issues by severity
  (0-4 scale), (6) documenting friction points and improvement recommendations.

# Usability Audit

Systematic evaluation of software usability. Identifies friction points and improvement opportunities for user experience.

## Nielsen's 10 Usability Heuristics

### 1. Visibility of System Status
The system should keep users informed through appropriate feedback.

**Audit Questions:**
- Does the system show loading states?
- Are errors clearly communicated?
- Is progress visible for long operations?
- Do actions provide confirmation?

### 2. Match Between System and Real World
Use familiar language and concepts.

**Audit Questions:**
- Is terminology user-friendly?
- Are icons recognizable?
- Do metaphors make sense?
- Is information logically ordered?

### 3. User Control and Freedom
Support undo and easy exit from states.

**Audit Questions:**
- Can users undo actions?
- Is there a clear "emergency exit"?
- Can users cancel operations?
- Is data preserved on accidental navigation?

### 4. Consistency and Standards
Follow platform conventions and be internally consistent.

**Audit Questions:**
- Are similar actions named consistently?
- Do patterns repeat across the app?
- Are platform conventions followed?
- Is visual design consistent?

### 5. Error Prevention
Design to prevent errors before they occur.

**Audit Questions:**
- Are destructive actions confirmed?
- Is input validated before submission?
- Are constraints visible (e.g., character limits)?
- Are ambiguous actions clarified?

### 6. Recognition Rather Than Recall
Minimize memory load; make information visible.

**Audit Questions:**
- Are options visible rather than hidden?
- Are recent items remembered?
- Is context provided for choices?
- Are instructions available when needed?

### 7. Flexibility and Efficiency of Use
Accelerators for expert users.

**Audit Questions:**
- Are keyboard shortcuts available?
- Can frequent actions be customized?
- Are there expert and novice modes?
- Can users personalize the experience?

### 8. Aesthetic and Minimalist Design
Only relevant information; no visual clutter.

**Audit Questions:**
- Is every element necessary?
- Is visual hierarchy clear?
- Is the design distracting?
- Is content easy to scan?

### 9. Help Users Recognize and Recover from Errors
Error messages should be clear and suggest solutions.

**Audit Questions:**
- Are error messages human-readable?
- Do they explain what went wrong?
- Do they suggest how to fix it?
- Is recovery straightforward?

### 10. Help and Documentation
Provide easy-to-search, task-focused help.

**Audit Questions:**
- Is help easily accessible?
- Is it searchable?
- Is it task-focused?
- Is it concise?

## Usability Audit Checklist

### Learnability
- [ ] New users can complete basic tasks
- [ ] UI elements are self-explanatory
- [ ] Onboarding is effective
- [ ] Help is available when needed

### Efficiency
- [ ] Experienced users can work quickly
- [ ] Common tasks require few steps
- [ ] Shortcuts are available
- [ ] Unnecessary steps eliminated

### Memorability
- [ ] Users can return after absence
- [ ] UI patterns are consistent
- [ ] Important features are prominent
- [ ] Conventions are standard

### Error Rate
- [ ] Users rarely make errors
- [ ] Errors are preventable
- [ ] Recovery is easy
- [ ] Consequences are minimal

### Satisfaction
- [ ] Experience is pleasant
- [ ] Design is professional
- [ ] Performance feels responsive
- [ ] Goals are achievable

## Severity Rating Scale

| Rating | Description | Action |
|--------|-------------|--------|
| 0 | Not a usability problem | None |
| 1 | Cosmetic only | Fix if time permits |
| 2 | Minor problem | Low priority fix |
| 3 | Major problem | Important to fix |
| 4 | Usability catastrophe | Must fix before release |

## Finding Documentation

```markdown
## Usability Issue: [Title]

### Heuristic Violated
[Which heuristic?]

### Severity
[0-4]

### Location
[Where in the application?]

### Description
[What is the problem?]

### User Impact
[How does it affect users?]

### Evidence
[Screenshot, user quote, etc.]

### Recommendation
[How to fix it]
```

## References

For detailed heuristics:
- See `references/heuristic-details.md`
- See `references/usability-examples.md`
