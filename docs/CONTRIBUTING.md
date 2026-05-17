# Contributing

PRs welcome. This skill is open-source and benefits from real-world feedback on how the conventions hold up in different wikis.

---

## Good first contributions

- **More language defaults**: Spanish / French / German variants of stock prose in `SKILL.md`
- **Specialized taxonomy presets**: e.g. researcher (with `tipo/paper`, `tipo/experiment`), legal practice, sales / RevOps
- **Better audit scripts**: `wiki-stats.sh` for link graph density, page count by category, tag frequency analysis
- **Plugin distribution**: package this as an installable Claude Code plugin
- **GitHub Actions workflow**: auto-run audits on PR commits

---

## What this skill aims for

In order of priority:

1. **AI-navigability** — every convention must reduce friction for Claude reading the wiki
2. **Human readability** — never sacrifice readability for AI-friendliness
3. **Low setup cost** — `wiki-init.sh` to working wiki should be < 2 minutes
4. **Easy to override** — users should be able to disable any rule with a config flag

---

## Out of scope

- Wiki *content* generation (we enforce structure, not write your notes for you)
- Sync with external wikis (Notion, Confluence, etc.) — that's a separate tool
- Real-time collaboration features — wikis here are personal, file-based
- Markdown rendering / theming — Obsidian, VSCode, etc. handle this

---

## Coding rules

### Bash scripts

- POSIX where possible, `bash` extensions only when necessary
- Macros for the sed `-i` GNU/BSD difference (see `wiki-init.sh` for the pattern)
- Always quote variable expansions
- Exit codes meaningful: 0 = success, 1 = user error, 2 = system error

### Markdown in the skill itself

- Follow the conventions the skill enforces (eat our own dogfood)
- Tag the SKILL.md frontmatter with `tipo/sistema, dominio/shared`
- Cross-link `SKILL.md ↔ conventions.md ↔ tag-taxonomy.md`

### Versioning

Semantic versioning:

- **Major**: breaking change to `wiki.config.yaml` schema or filesystem layout
- **Minor**: new convention or audit category
- **Patch**: bug fixes, doc improvements

Tag releases in git: `v1.0.0`, etc.

---

## PR process

1. Fork → branch → commit → PR
2. Reference the convention or issue your change addresses
3. Include an example: before / after, or a sample wiki demonstrating the change
4. If your PR adds a new convention, add it to `conventions.md` with an enforcement tier
5. Update `CHANGELOG.md`

---

## Testing locally

The simplest test: bootstrap a fresh wiki, exercise the skill, verify behavior.

```bash
# Set up a scratch wiki
bash scripts/wiki-init.sh /tmp/test-wiki

# Tell Claude about it
echo "Wiki at /tmp/test-wiki. Use wiki-maker skill." >> ~/.claude/CLAUDE.md

# In Claude Code:
# > add to wiki: <some content that exercises the rule you changed>

# Verify
bash scripts/wiki-audit.sh all --root /tmp/test-wiki
```

When done:

```bash
rm -rf /tmp/test-wiki
# revert your CLAUDE.md change
```

---

## Reporting issues

Open a GitHub issue with:

- Skill version (commit SHA or release tag)
- Excerpt of `wiki.config.yaml`
- The exact prompt you gave Claude
- What you expected vs what happened
- Output of `bash scripts/wiki-audit.sh all` if relevant
