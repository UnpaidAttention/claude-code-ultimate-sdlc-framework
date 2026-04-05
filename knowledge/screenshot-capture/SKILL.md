name: screenshot-capture
description: Capture and organize screenshot evidence for defect documentation and correction verification. Use when logging defects with visual evidence, creating before/after correction proofs, or documenting 8-layer verification results.

# Screenshot Capture Guide

## Purpose

Screenshots are required evidence for defect documentation and correction verification. This guide provides platform-agnostic instructions for capturing and organizing screenshot evidence.

## When Screenshots Are Required

| Situation | Required Screenshots |
|-----------|---------------------|
| Defect logging | BEFORE: Issue visible in UI |
| Correction verification | BEFORE and AFTER |
| 8-layer verification L1 | UI element state |
| 8-layer verification L8 | Before/after restart |
| Accessibility issues | Affected UI component |
| Usability problems | Navigation flow |

## Capture Methods

### macOS
| Method | Shortcut |
|--------|----------|
| Full screen | `Cmd + Shift + 3` |
| Selection | `Cmd + Shift + 4` |
| Window | `Cmd + Shift + 4`, then `Space` |

### Windows
| Method | Shortcut |
|--------|----------|
| Full screen | `PrtScn` |
| Active window | `Alt + PrtScn` |
| Selection | `Win + Shift + S` |

### Linux
| Method | Tool |
|--------|------|
| Full screen | `gnome-screenshot` or `scrot` |
| Selection | `gnome-screenshot -a` or `scrot -s` |
| Window | `gnome-screenshot -w` or `scrot -u` |

## Naming Convention

```
{DEFECT-ID}-{state}-{timestamp}.png
```

**State identifiers**: `before`, `after`, `l1-ui`, `l8-restart`, `nav-flow`

**Examples**:
- `DEF-001-before-20260122-143052.png`
- `DEF-001-after-20260122-144523.png`

## Storage Locations

```
council-state/audit/screenshots/defects/      # Defect evidence
council-state/audit/screenshots/navigation/   # GUI flow docs
council-state/validation/screenshots/corrections/  # Before/after pairs
council-state/validation/screenshots/verification/ # 8-layer evidence
```

## Checklist

### For Defect Logging
- [ ] Capture shows the defect clearly visible
- [ ] UI context is visible (which screen/component)
- [ ] Named following convention
- [ ] Saved to `council-state/audit/screenshots/defects/`
- [ ] Referenced in `defect-log.md`

### For Correction Verification
- [ ] BEFORE screenshot captured (defect visible)
- [ ] AFTER screenshot captured (defect resolved)
- [ ] Both named consistently
- [ ] Both referenced in correction log
