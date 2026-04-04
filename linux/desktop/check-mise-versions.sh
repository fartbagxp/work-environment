#!/usr/bin/env bash
# check-mise-versions.sh
#
# Supply chain security audit for mise-managed tools.
#
# Usage: ./check-mise-versions.sh [--outdated-only]
#
# Reports:
#   1. Tools pinned to "latest" (security risk — should be pinned to a specific version)
#   2. Pinned tools that have a newer version available (may need a pin bump)
#   3. Tools in config but not installed (or vice versa)
#
# The "INSTALLED VERSION" column in section 1 is a suggested pin value.

set -euo pipefail

OUTDATED_ONLY=false
if [[ "${1:-}" == "--outdated-only" ]]; then
  OUTDATED_ONLY=true
fi

# Capture mise list once; columns are: TOOL  VERSION  SOURCE  REQUESTED
MISE_LIST=$(mise list 2>/dev/null)

# ---------------------------------------------------------------------------
# Section 1: Tools without a pinned version
# ---------------------------------------------------------------------------
if ! $OUTDATED_ONLY; then
  echo ""
  echo "╔══════════════════════════════════════════════════════════════════════════╗"
  echo "║  SECTION 1: Tools pinned to 'latest' (unpinned — supply chain risk)     ║"
  echo "╚══════════════════════════════════════════════════════════════════════════╝"
  echo "  These resolve to whatever the upstream releases next."
  echo "  Pin them in config.toml to the INSTALLED VERSION shown below."
  echo ""
  printf "  %-58s  %s\n" "TOOL" "INSTALLED VERSION (suggested pin)"
  printf "  %-58s  %s\n" "$(printf '%.0s-' {1..58})" "$(printf '%.0s-' {1..35})"

  unpinned_count=0
  while IFS= read -r line; do
    # Skip blank lines
    [[ -z "$line" ]] && continue

    tool=$(awk '{print $1}' <<< "$line")
    installed=$(awk '{print $2}' <<< "$line")
    requested=$(awk '{print $NF}' <<< "$line")

    # "latest" is unpinned; also catch bare major pins like "24" or "3.13" for node/python
    if [[ "$requested" == "latest" ]]; then
      printf "  %-58s  %s\n" "$tool" "$installed"
      (( unpinned_count++ )) || true
    fi
  done <<< "$MISE_LIST"

  echo ""
  echo "  Total unpinned tools: $unpinned_count"
fi

# ---------------------------------------------------------------------------
# Section 2: Pinned tools with a newer version available
# ---------------------------------------------------------------------------
echo ""
echo "╔══════════════════════════════════════════════════════════════════════════╗"
echo "║  SECTION 2: Pinned tools with a newer version available                 ║"
echo "╚══════════════════════════════════════════════════════════════════════════╝"
echo "  These are pinned but behind the current upstream release."
echo "  Review changelogs for security fixes before deciding whether to bump."
echo ""

# mise outdated output: TOOL  REQUESTED  INSTALLED  LATEST  SOURCE
OUTDATED=$(mise outdated 2>/dev/null || true)

if [[ -z "$OUTDATED" ]]; then
  echo "  All pinned tools are up to date."
else
  printf "  %-50s  %-15s  %-15s  %s\n" "TOOL" "INSTALLED" "LATEST" "REQUESTED"
  printf "  %-50s  %-15s  %-15s  %s\n" "$(printf '%.0s-' {1..50})" "$(printf '%.0s-' {1..15})" "$(printf '%.0s-' {1..15})" "$(printf '%.0s-' {1..10})"
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    tool=$(awk '{print $1}' <<< "$line")
    requested=$(awk '{print $2}' <<< "$line")
    installed=$(awk '{print $3}' <<< "$line")
    latest=$(awk '{print $4}' <<< "$line")
    printf "  %-50s  %-15s  %-15s  %s\n" "$tool" "$installed" "$latest" "$requested"
  done <<< "$OUTDATED"
fi

# ---------------------------------------------------------------------------
# Section 3: Loose major/minor pins (partial pins — still somewhat flexible)
# ---------------------------------------------------------------------------
if ! $OUTDATED_ONLY; then
  echo ""
  echo "╔══════════════════════════════════════════════════════════════════════════╗"
  echo "║  SECTION 3: Loose major/minor pins (e.g. '24', '3.13', '8.9')          ║"
  echo "╚══════════════════════════════════════════════════════════════════════════╝"
  echo "  These will auto-upgrade within the pinned range."
  echo "  Consider pinning to a full version (e.g. '24.14.1') for full lockdown."
  echo ""
  printf "  %-58s  %-20s  %s\n" "TOOL" "REQUESTED (loose)" "INSTALLED (full)"
  printf "  %-58s  %-20s  %s\n" "$(printf '%.0s-' {1..58})" "$(printf '%.0s-' {1..20})" "$(printf '%.0s-' {1..16})"

  loose_count=0
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    tool=$(awk '{print $1}' <<< "$line")
    installed=$(awk '{print $2}' <<< "$line")
    requested=$(awk '{print $NF}' <<< "$line")

    # A loose pin: not "latest", not containing a patch version (x.y only, or bare integer)
    # Matches: "24", "3.13", "8.9", "openjdk-21" but NOT "openjdk-21.0.2" or "24.14.1"
    if [[ "$requested" != "latest" ]] && \
       [[ "$requested" =~ ^[0-9]+$ ]] || \
       [[ "$requested" =~ ^[0-9]+\.[0-9]+$ ]] || \
       [[ "$requested" =~ ^[a-z]+-[0-9]+$ ]]; then
      printf "  %-58s  %-20s  %s\n" "$tool" "$requested" "$installed"
      (( loose_count++ )) || true
    fi
  done <<< "$MISE_LIST"

  echo ""
  echo "  Total loosely-pinned tools: $loose_count"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Tip: After pinning, run 'mise install' to validate all versions resolve."
echo "  Run this script with --outdated-only to skip sections 1 & 3."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
