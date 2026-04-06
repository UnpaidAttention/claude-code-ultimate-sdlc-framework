---
name: handoff-validation
description: Validate handoff documents against schemas before council transitions. Use when transitioning between Planning, Development, Audit, and Validation councils, or when checking handoff document completeness.
---

# Handoff Document Validation

## Purpose

Ensure handoff documents are complete before council transitions.

## Schemas

| Handoff | Schema Location |
|---------|-----------------|
| planning-handoff.md | `.context/handoff-schemas/planning-handoff.schema.md` |
| development-handoff.md | `.context/handoff-schemas/development-handoff.schema.md` |
| audit-handoff.md | `.context/handoff-schemas/audit-handoff.schema.md` |
| validation-handoff.md | `.context/handoff-schemas/validation-handoff.schema.md` |

## Validation Protocol

### Before Council Transition

1. Open the relevant schema document
2. Compare handoff document against schema
3. Check ALL required fields are present
4. Fill in the validation checklist
5. If ANY field missing → INVALID → Fix before proceeding
6. If all fields present → VALID → Proceed to next council

## Council Transition Requirements

| From | To | Required Handoff | Schema |
|------|-----|------------------|--------|
| Planning | Development | planning-handoff.md | planning-handoff.schema.md |
| Development | Audit | development-handoff.md | development-handoff.schema.md |
| Audit | Validation | audit-handoff.md, defect-log.md | audit-handoff.schema.md |
| Validation | Release | validation-handoff.md | validation-handoff.schema.md |

## Quick Reference

```
BEFORE TRANSITIONING COUNCILS:
1. Check handoff exists
2. Open schema for that handoff
3. Verify all sections present
4. All checkboxes checked → VALID
5. Any checkbox unchecked → INVALID → Fix first
```
