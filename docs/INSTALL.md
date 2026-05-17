# Install

Three ways to install the `wiki-maker` skill.

---

## Method 1 — Clone & symlink (recommended)

```bash
cd ~/.claude/skills
git clone https://github.com/catta87osx/wiki-maker.git wiki-maker-repo
ln -s "$(pwd)/wiki-maker-repo/skill/wiki-maker" ./wiki-maker
```

You can `git pull` the repo for updates without touching the symlink.

---

## Method 2 — Direct copy

```bash
cd /tmp
git clone https://github.com/catta87osx/wiki-maker.git
cp -R wiki-maker/skill/wiki-maker ~/.claude/skills/
rm -rf wiki-maker
```

Simpler but you lose easy updates.

---

## Method 3 — Manual (any markdown editor)

Download these three files and place them in `~/.claude/skills/wiki-maker/`:

- [`SKILL.md`](../skill/wiki-maker/SKILL.md) — the skill prompt
- [`conventions.md`](../skill/wiki-maker/conventions.md) — full convention reference
- [`tag-taxonomy.md`](../skill/wiki-maker/tag-taxonomy.md) — tag namespace rationale

Folder structure:

```
~/.claude/skills/wiki-maker/
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

You should see `wiki-maker` in the list.

If you don't, check:

1. The folder name is exactly `wiki-maker` (no typos)
2. `SKILL.md` has valid frontmatter at the top (the `name:` and `description:` fields)
3. `~/.claude/skills/` exists (create it if not)

---

## Set up a wiki

After installing the skill, bootstrap your first wiki:

```bash
cd /path/to/wiki-maker   # or wherever the repo lives
bash scripts/wiki-init.sh ~/Documents/my-wiki
```

Then tell Claude where to find it. Add to `~/.claude/CLAUDE.md`:

```markdown
## Wiki

My wiki lives at `~/Documents/my-wiki/`. Use the `wiki-maker` skill for any
operation involving the wiki (add, update, audit, search).
```

Done. Try `add to my wiki: some test note` to verify end-to-end.

---

## Uninstall

```bash
rm -rf ~/.claude/skills/wiki-maker*
```

The wiki itself is untouched — it's just markdown files on disk and works fine without the skill.
