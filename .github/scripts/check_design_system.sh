#!/usr/bin/env bash
# check_design_system.sh
#
# Scans a list of changed Swift files for hardcoded values that should instead
# use FulhamKit design tokens. Exits 1 if any violations are found.
#
# Usage:
#   check_design_system.sh <path-to-file-listing-swift-files>
#
# Each line of the input file should be a path to a .swift file (relative or
# absolute). Lines for files that no longer exist on disk are skipped silently.
#
# Escape hatch:
#   Append  // fk:ignore  to any line to suppress that line's violation.

set -uo pipefail

INPUT_FILE="${1:-}"
if [[ -z "$INPUT_FILE" ]]; then
  echo "Usage: $0 <changed-files-list>"
  exit 1
fi

# ---------------------------------------------------------------------------
# Patterns — each entry is:  "DESCRIPTION@@REGEX"
# The regex is passed to grep -E (extended regex — works on macOS and Linux).
# A line is only flagged if it does NOT contain the escape hatch comment.
# ---------------------------------------------------------------------------
declare -a PATTERNS=(
  "Hardcoded hex color literal@@Color\(hex:"
  "Hardcoded UIColor(red:)@@UIColor\(red:"
  "Hardcoded padding value@@\.padding\([0-9]"
  "Hardcoded frame width/height@@\.frame\(.*(width|height): [0-9]"
  "Hardcoded cornerRadius@@\.cornerRadius\([0-9]"
  "Hardcoded system font size@@\.font\(\.system\(size"
  "Hardcoded animation duration@@\.animation\(.*duration: [0-9]"
  "Hardcoded shadow radius@@\.shadow\(.*radius: [0-9]"
  "Hardcoded named color literal@@foreground(Color|Style)\(\.(red|green|blue|black|white|gray|orange|yellow|pink|purple|cyan|mint|indigo|teal)"
)

VIOLATION_COUNT=0

while IFS= read -r swift_file || [[ -n "$swift_file" ]]; do
  # Skip blank lines
  [[ -z "$swift_file" ]] && continue
  # Skip files that don't exist (e.g. deleted in this PR)
  [[ ! -f "$swift_file" ]] && continue

  FILE_HAD_VIOLATION=0

  for pattern_entry in "${PATTERNS[@]}"; do
    description="${pattern_entry%%@@*}"
    regex="${pattern_entry##*@@}"

    # Find matching lines; exclude lines with the fk:ignore escape hatch
    matches=$(grep -nE "$regex" "$swift_file" 2>/dev/null | grep -v "fk:ignore" || true)

    if [[ -n "$matches" ]]; then
      if [[ $FILE_HAD_VIOLATION -eq 0 ]]; then
        echo ""
        echo "❌  $swift_file"
        FILE_HAD_VIOLATION=1
      fi

      while IFS= read -r line; do
        echo "    ${swift_file}:${line}  # ${description}"
        VIOLATION_COUNT=$(( VIOLATION_COUNT + 1 ))
      done <<< "$matches"
    fi
  done

done < "$INPUT_FILE"

echo ""

if [[ $VIOLATION_COUNT -gt 0 ]]; then
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  FulhamKit design system lint: $VIOLATION_COUNT violation(s) found."
  echo ""
  echo "  Replace hardcoded values with FulhamKit tokens:"
  echo "    Colors     → FKColor.*"
  echo "    Spacing    → FKSpacing.*"
  echo "    Radius     → FKRadius.*"
  echo "    Typography → FKTypography.*"
  echo "    Animation  → FKAnimation.*"
  echo "    Shadow     → FKShadow.*"
  echo "    Border     → FKBorder.*"
  echo ""
  echo "  To suppress a false positive, add  // fk:ignore  to that line."
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  exit 1
else
  echo "✅  FulhamKit design system lint: no violations found."
  exit 0
fi
