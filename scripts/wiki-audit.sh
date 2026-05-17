#!/usr/bin/env bash
# wiki-audit.sh — audit a wiki for health issues
#
# Usage: bash wiki-audit.sh [broken-links|tag-drift|stale|all] [--months N] [--root PATH]
#
# Defaults: --root . --months 6

set -euo pipefail

MODE="${1:-all}"
shift || true

WIKI_ROOT="."
MONTHS=6

while [ $# -gt 0 ]; do
  case "$1" in
    --root) WIKI_ROOT="$2"; shift 2 ;;
    --months) MONTHS="$2"; shift 2 ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
done

cd "$WIKI_ROOT"

if [ ! -f "wiki.config.yaml" ]; then
  echo "ERROR: no wiki.config.yaml in $WIKI_ROOT. Are you in the right folder?" >&2
  exit 1
fi

audit_broken_links() {
  echo "=== Broken wikilinks ==="
  # Build the list of existing basenames
  find . -type f -name "*.md" -exec basename {} .md \; | sort -u > /tmp/wiki_basenames.txt

  broken=0
  while IFS= read -r f; do
    grep -oE '\[\[[^]]+\]\]' "$f" 2>/dev/null | sed 's/\[\[//;s/\]\]//' | while IFS= read -r link; do
      target="${link%%|*}"
      target="${target%%#*}"
      target=$(basename "$target")
      [ -z "$target" ] && continue
      # Skip http(s)://
      [[ "$target" =~ ^https?: ]] && continue
      if ! grep -qx "$target" /tmp/wiki_basenames.txt; then
        echo "BROKEN: $f -> [[$link]]"
        broken=$((broken+1))
      fi
    done
  done < <(find . -type f -name "*.md")
  rm -f /tmp/wiki_basenames.txt
}

audit_tag_drift() {
  echo "=== Tag drift (values not declared in tags.md) ==="
  # Extract declared tag values from tags.md (lines that look like tipo/X or stack/Y)
  grep -oE '`[a-z]+/[a-z0-9_-]+`' tags.md | tr -d '`' | sort -u > /tmp/declared_tags.txt

  # Extract used tags from all pages
  find . -type f -name "*.md" ! -name "tags.md" -exec awk '/^---$/{c++; next} c==1 && /^tags:/{print}' {} \; \
    | sed 's/tags: *\[//;s/\]//' | tr ',' '\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' \
    | grep -E '^[a-z]+/[a-z0-9_-]+$' | sort -u > /tmp/used_tags.txt

  comm -23 /tmp/used_tags.txt /tmp/declared_tags.txt > /tmp/drift.txt
  if [ -s /tmp/drift.txt ]; then
    echo "Tags used in pages but NOT declared in tags.md:"
    cat /tmp/drift.txt
  else
    echo "No drift. All tags used are declared."
  fi

  echo ""
  echo "=== Free-form tags (not namespaced) ==="
  find . -type f -name "*.md" ! -name "tags.md" -exec awk '/^---$/{c++; next} c==1 && /^tags:/{print FILENAME": "$0}' {} \; \
    | grep -E '\b[a-z][a-z0-9_-]+\b' | grep -vE 'tipo/|dominio/|stato/|stack/|prodotto/|area/|tecnica/' \
    | head -20 || true

  rm -f /tmp/declared_tags.txt /tmp/used_tags.txt /tmp/drift.txt
}

audit_stale() {
  echo "=== Stale pages (status: produzione, updated > $MONTHS months ago) ==="
  cutoff=$(date -v-"${MONTHS}"m +%Y-%m-%d 2>/dev/null || date -d "$MONTHS months ago" +%Y-%m-%d)
  echo "Cutoff date: $cutoff"
  echo ""
  find . -type f -name "*.md" | while IFS= read -r f; do
    status=$(awk '/^---$/{c++; next} c==1 && /^status:/{sub(/^status: */, ""); print; exit}' "$f")
    updated=$(awk '/^---$/{c++; next} c==1 && /^updated:/{sub(/^updated: */, ""); print; exit}' "$f")
    if [ "$status" = "produzione" ] && [ -n "$updated" ] && [[ "$updated" < "$cutoff" ]]; then
      echo "STALE: $f (updated: $updated)"
    fi
  done
}

audit_orphans() {
  echo "=== Orphan pages (no outgoing wikilinks) ==="
  find . -type f -name "*.md" ! -name "WIKI.md" ! -name "tags.md" ! -name "_index.md" ! -name "log.md" | while IFS= read -r f; do
    if ! grep -qE '\[\[[^]]+\]\]' "$f" 2>/dev/null; then
      echo "ORPHAN: $f"
    fi
  done
}

case "$MODE" in
  broken-links) audit_broken_links ;;
  tag-drift) audit_tag_drift ;;
  stale) audit_stale ;;
  orphans) audit_orphans ;;
  all)
    audit_broken_links
    echo ""
    audit_tag_drift
    echo ""
    audit_stale
    echo ""
    audit_orphans
    ;;
  *)
    echo "Usage: $0 [broken-links|tag-drift|stale|orphans|all] [--months N] [--root PATH]" >&2
    exit 1
    ;;
esac
