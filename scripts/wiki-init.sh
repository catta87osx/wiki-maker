#!/usr/bin/env bash
# wiki-init.sh — bootstrap a new wiki from the template
#
# Usage: bash wiki-init.sh <target-path>
# Example: bash wiki-init.sh ~/Documents/my-wiki

set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <target-path>" >&2
  echo "Example: $0 ~/Documents/my-wiki" >&2
  exit 1
fi

TARGET="$1"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/../templates/wiki-init"

if [ ! -d "$TEMPLATE_DIR" ]; then
  echo "ERROR: template not found at $TEMPLATE_DIR" >&2
  echo "Run this script from the repo root, or ensure the path resolves correctly." >&2
  exit 1
fi

if [ -e "$TARGET" ] && [ "$(ls -A "$TARGET" 2>/dev/null)" ]; then
  echo "ERROR: target path '$TARGET' is not empty. Refusing to overwrite." >&2
  exit 1
fi

mkdir -p "$TARGET"
cp -R "$TEMPLATE_DIR/." "$TARGET/"

# Create category folders from wiki.config.yaml
CONFIG="$TARGET/wiki.config.yaml"
if [ -f "$CONFIG" ]; then
  # Extract category names (simple YAML parser — assumes one per line under 'categories:')
  in_categories=0
  while IFS= read -r line; do
    if [[ "$line" =~ ^categories: ]]; then
      in_categories=1
      continue
    fi
    if [ "$in_categories" -eq 1 ]; then
      if [[ "$line" =~ ^[[:space:]]+-[[:space:]]+([a-z][a-z0-9_-]*) ]]; then
        cat="${BASH_REMATCH[1]}"
        mkdir -p "$TARGET/$cat"
        echo "  + $cat/"
      elif [[ "$line" =~ ^[^[:space:]] ]]; then
        # Reached a new top-level key
        in_categories=0
      fi
    fi
  done < "$CONFIG"
fi

# Replace YYYY-MM-DD placeholders with today's date
TODAY=$(date +%Y-%m-%d)
# Use a portable in-place sed (macOS BSD requires '', GNU doesn't)
if sed --version >/dev/null 2>&1; then
  # GNU sed
  find "$TARGET" -maxdepth 1 -type f -name "*.md" -exec sed -i "s/<YYYY-MM-DD>/$TODAY/g" {} +
else
  # BSD sed (macOS)
  find "$TARGET" -maxdepth 1 -type f -name "*.md" -exec sed -i '' "s/<YYYY-MM-DD>/$TODAY/g" {} +
fi

echo ""
echo "✓ Wiki bootstrapped at: $TARGET"
echo ""
echo "Next steps:"
echo "  1. Edit $TARGET/wiki.config.yaml — set 'language', extend 'tags.stack', 'tags.area', etc."
echo "  2. Edit $TARGET/tags.md — add domain-specific values (clients, products)"
echo "  3. Tell Claude where your wiki lives by adding to ~/.claude/CLAUDE.md:"
echo "       \"My wiki lives at $TARGET. Use the wiki-maker skill for wiki operations.\""
echo "  4. Try: 'add to my wiki: <some note>'"
