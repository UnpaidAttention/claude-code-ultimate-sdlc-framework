#!/usr/bin/env bash
set -euo pipefail

# USER_INVOCABLE_LIST — workflow names (without the sdlc- prefix, without .md suffix)
# that are user-facing entry points. All others get user_invocable: false.
USER_INVOCABLE_LIST="init adopt new-cycle close-cycle plan create enhance status continue recover amend rollback
planning-start planning-handoff planning-upgrade patch-planning maintenance-planning improvement-planning brainstorm
dev-start dev-status dev-complete dev-upgrade dev-wave-1 dev-wave-2 dev-wave-3 dev-wave-4 dev-wave-6 dev-wave5-start dev-wave5-status
dev-ui-research dev-ui-design-plan dev-ui-verify dev-ui-audit dev-ui-polish dev-ui-retheme dev-ui-redesign
audit-start audit-status audit-report audit-complete audit-defect audit-enhancement audit-feature audit-think
validate-start validate-status validate-complete validate-report validate-feature validate-production validate-framework
feedback-log feedback-review feedback-promote framework-retro
ag-help deploy preview release debug test orchestrate ui-ux-pro-max council-switch ralph-wave ralph-corrections ralph-defects"

cd "$(dirname "$0")/.."

for f in commands/sdlc-*.md; do
  name=$(basename "$f" .md | sed 's/^sdlc-//')

  if echo "$USER_INVOCABLE_LIST" | tr ' \n' '\n' | grep -qx "$name"; then
    flag="true"
  else
    flag="false"
  fi

  # Skip if already has user_invocable
  if grep -q "^user_invocable:" "$f"; then
    continue
  fi

  # Insert user_invocable line after description: in frontmatter
  awk -v flag="$flag" '
    BEGIN { in_fm=0; fm_count=0; inserted=0 }
    /^---$/ { fm_count++; print; if (fm_count==1) in_fm=1; else in_fm=0; next }
    in_fm && /^description:/ && !inserted { print; print "user_invocable: " flag; inserted=1; next }
    in_fm && fm_count==1 && !inserted && /^---$/ { print "user_invocable: " flag; print; inserted=1; next }
    { print }
  ' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
done
