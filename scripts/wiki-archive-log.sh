#!/usr/bin/env bash
# wiki-archive-log.sh — rotate log.md by moving past months into log/YYYY-MM.md
#
# Usage: bash wiki-archive-log.sh [--root PATH] [--keep-month YYYY-MM]
#
# By default, keeps current month entries in log.md, moves all older months to log/

set -euo pipefail

WIKI_ROOT="."
KEEP_MONTH=$(date +%Y-%m)

while [ $# -gt 0 ]; do
  case "$1" in
    --root) WIKI_ROOT="$2"; shift 2 ;;
    --keep-month) KEEP_MONTH="$2"; shift 2 ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
done

cd "$WIKI_ROOT"

if [ ! -f "log.md" ]; then
  echo "ERROR: no log.md in $WIKI_ROOT" >&2
  exit 1
fi

mkdir -p log

# Find all unique YYYY-MM in log.md, except the keep-month
months=$(grep -oE '^## \[[0-9]{4}-[0-9]{2}-[0-9]{2}\]' log.md | sed 's/^## \[//;s/-[0-9]\{2\}\]$//' | sort -u)
moved=0

for ym in $months; do
  if [ "$ym" = "$KEEP_MONTH" ]; then
    continue
  fi

  archive_file="log/${ym}.md"
  if [ -f "$archive_file" ]; then
    echo "  (already archived: $archive_file — skipping $ym)"
    continue
  fi

  # Extract entries for this month using awk
  awk -v month="$ym" '
    /^## \[/ {
      if (match($0, /\[([0-9]{4}-[0-9]{2})-/, arr)) {
        in_section = (arr[1] == month)
      } else {
        in_section = 0
      }
    }
    in_section { print }
  ' log.md > "/tmp/wiki_archive_$ym.md"

  if [ ! -s "/tmp/wiki_archive_$ym.md" ]; then
    rm -f "/tmp/wiki_archive_$ym.md"
    continue
  fi

  # Write archive file with header
  {
    echo "---"
    echo "title: Change Log — $ym (archive)"
    echo "category: log"
    echo "tags: [tipo/indice, dominio/shared]"
    echo "updated: $(date +%Y-%m-%d)"
    echo "parent: log"
    echo "---"
    echo ""
    echo "# Change Log — $ym (archive)"
    echo ""
    echo "Archived entries from $ym. Append-only sealed on $(date +%Y-%m-%d)."
    echo ""
    echo "Current log: [[log]] · Schema: [[WIKI]]"
    echo ""
    echo "---"
    echo ""
    cat "/tmp/wiki_archive_$ym.md"
  } > "$archive_file"
  rm -f "/tmp/wiki_archive_$ym.md"

  moved=$((moved+1))
  echo "  ✓ Archived $ym -> $archive_file"
done

if [ "$moved" -eq 0 ]; then
  echo "Nothing to archive (only $KEEP_MONTH entries in log.md)."
  exit 0
fi

# Now remove archived months from log.md
# Use awk to keep only current month entries + intro
awk -v keep="$KEEP_MONTH" '
  BEGIN { in_archive = 0; header_done = 0 }
  /^## \[/ {
    if (match($0, /\[([0-9]{4}-[0-9]{2})-/, arr)) {
      in_archive = (arr[1] != keep)
    }
    header_done = 1
  }
  /^## Archive$/ { in_archive = 1 }
  !in_archive { print }
' log.md > log.md.new

# Append updated archive footer
{
  cat log.md.new
  echo ""
  echo "---"
  echo ""
  echo "## Archive"
  echo ""
  for archive in $(ls -r log/*.md 2>/dev/null); do
    ym=$(basename "$archive" .md)
    count=$(grep -cE "^## \[" "$archive" 2>/dev/null || echo 0)
    echo "- **$ym** ($count entries): [[log/$ym|log/$ym.md]]"
  done
  echo ""
  echo "_Policy: at end of each month, past entries are moved to \`log/YYYY-MM.md\` to keep \`log.md\` < 50 KB._"
} > log.md
rm -f log.md.new

echo ""
echo "✓ Done. $moved month(s) archived. log.md now contains $KEEP_MONTH only."
