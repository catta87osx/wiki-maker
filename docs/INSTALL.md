# Install

Three ways to install the `wiki-writer` skill.

---

## Method 1 — Clone & symlink (recommended)

```bash
cd ~/.claude/skills
git clone https://github.com/catta87osx/claude-wiki-skill.git wiki-writer-repo
ln -s "$(pwd)/wiki-writer-repo/skill/wiki-writer" ./wiki-writer
```

You can `git pull` the repo for updates without touching the symlink.

---

## Method 2 — Direct copy

```bash
cd /tmp
git clone https://github.com/catta87osx/claude-wiki-skill.git
cp -R claude-wiki-skill/skill/wiki-writer ~/.claude/skills/
rm -rf claude-wiki-skill
```

Simpler but you lose easy updates.

---

## Method 3 — Manual (any markdown editor)

Download these three files and place them in `~/.claude/skills/wiki-writer/`:

- [`SKILL.md`](../skill/wiki-writer/SKILL.md) — the skill prompt
- [`conventions.md`](../skill/wiki-writer/conventions.md) — full convention reference
- [`tag-taxonomy.md`](../skill/wiki-writer/tag-taxonomy.md) — tag namespace rationale

Folder structure:

```
~/.claude/skills/wiki-writer/
├── SKILL.md
├── conventions.md
└── tag-taxonomy.md
```

---

## Verify install

After installation, in a new Claude Code session, ask:

```
What skills do you have access to?
```

You should see `wiki-writer` in the list.

If you don't, check:

1. The folder name is exactly `wiki-writer` (no typos)
2. `SKILL.md` has valid frontmatter at the top (the `name:` and `description:` fields)
3. `~/.claude/skills/` exists (create it if not)

---

## Set up a wiki

After installing the skill, bootstrap your first wiki:

```bash
cd /path/to/claude-wiki-skill   # or wherever the repo lives
bash scripts/wiki-init.sh ~/Documents/my-wiki
```

Then tell Claude where to find it. Add to `~/.claude/CLAUDE.md`:

```markdown
## Wiki

My wiki lives at `~/Documents/my-wiki/`. Use the `wiki-writer` skill for any
operation involving the wiki (add, update, audit, search).
```

Done. Try `add to my wiki: some test note` to verify end-to-end.

---

## Uninstall

```bash
rm -rf ~/.claude/skills/wiki-writer*
```

The wiki itself is untouched — it's just markdown files on disk and works fine without the skill.
