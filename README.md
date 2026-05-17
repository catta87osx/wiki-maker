# claude-wiki-skill

A [Claude Code](https://claude.com/claude-code) skill that turns your Obsidian/markdown wiki into a structured, AI-friendly knowledge base — with enforced frontmatter, controlled tag vocabulary, automatic indexing, and log rotation.

Built for personal wikis used by Claude as a long-term memory layer.

---

## What it does

When you ask Claude *"add this to my wiki"* or *"save this as a wiki page"*, this skill:

1. **Determines the right folder** based on content type (people / systems / projects / concepts / documents).
2. **Generates valid frontmatter** with mandatory `tipo/*` and `dominio/*` tags from your controlled vocabulary.
3. **Cross-links automatically** to known entities mentioned in the content.
4. **Applies size rules** — adds a TL;DR + ToC to files > 20 KB, splits monoliths > 60 KB into a multi-file folder.
5. **Updates `index.md`** with the new entry and pushes it to the *Last 10 Updated* table.
6. **Appends a `log.md` entry** with a structured changelog line.
7. **Validates wikilinks** before writing — no broken `[[references]]` shipped.
8. **Reminds you to rotate** `log.md` when it crosses your size threshold.

The skill enforces ~50 best practices across 16 categories (see [conventions.md](skill/wiki-writer/conventions.md)) split into four tiers:

- **Tier 1 — hard blocks** (missing frontmatter, invalid tag, wrong folder)
- **Tier 2 — confirm before override** (no TL;DR on a 30 KB file)
- **Tier 3 — soft warnings** (file < 200 bytes, stale links)
- **Tier 4 — manual audit commands** (broken-link sweep, tag drift, log rotation)

---

## Quickstart

### 1. Install the skill

```bash
git clone https://github.com/<you>/claude-wiki-skill.git ~/.claude/skills/wiki-writer-repo
ln -s ~/.claude/skills/wiki-writer-repo/skill/wiki-writer ~/.claude/skills/wiki-writer
```

Or copy `skill/wiki-writer/` directly into `~/.claude/skills/`.

### 2. Bootstrap a new wiki

```bash
bash scripts/wiki-init.sh ~/Documents/my-wiki
```

This copies `templates/wiki-init/` into the target folder and creates:

```
my-wiki/
├── WIKI.md             # the schema doc (don't edit unless needed)
├── tags.md             # your controlled vocabulary — extend freely
├── index.md            # catalog of all pages
├── log.md              # append-only changelog
├── wiki.config.yaml    # paths, language, size thresholds
└── log/                # monthly archive folder (auto-managed)
```

### 3. Tell Claude where your wiki lives

Add to your `~/.claude/CLAUDE.md`:

```markdown
My wiki lives at `~/Documents/my-wiki/`. Use the `wiki-writer` skill whenever I ask to add, save, or document something there.
```

### 4. Try it

```
> add to my wiki: I'm using Stripe with webhook secret rotation every 90 days
```

Claude will:
- Decide this is a `tipo/sistema` page about Stripe (`stack/stripe`)
- Place it at `sistemi/stripe-webhook-rotation.md` (or ask if unclear)
- Generate frontmatter with `tipo/sistema`, `dominio/personal`, `stack/stripe`, `area/sicurezza`, `tecnica/webhook`
- Cross-link any other Stripe-related pages already in your wiki
- Append a `log.md` entry
- Confirm before writing

---

## Configuration

The `wiki.config.yaml` in your wiki root drives everything. Defaults are sensible for a solo wiki; customize for teams, multi-client work, or non-English content.

See [docs/CONFIGURE.md](docs/CONFIGURE.md) for full schema and examples.

Key knobs:

| Setting | Default | Purpose |
|---|---|---|
| `language` | `en` | Language Claude writes log entries, index descriptions, and TL;DR sections in |
| `categories` | persone, sistemi, progetti, concetti, documenti | Top-level folder names |
| `tags.dominio` | personal, work, shared | Who/what each page belongs to (clients, business units, owners) |
| `tags.stack`, `tags.prodotto`, etc. | (empty) | You add your own tech stack and product names |
| `limits.tldr_threshold_kb` | 20 | Add TL;DR + ToC to files larger than this |
| `limits.split_threshold_kb` | 60 | Suggest splitting monolith files larger than this |
| `limits.log_rotation_kb` | 50 | Trigger monthly log rotation when `log.md` exceeds this |

---

## The tag taxonomy

Seven fixed namespaces (structure is universal; **values** you customize):

| Namespace | Purpose | Required? |
|---|---|---|
| `tipo/*` | What kind of page is this (project / system / concept / person / document / source / index ...) | yes, 1 value |
| `dominio/*` | Whose / what business it belongs to | yes, 1+ values |
| `stato/*` | Lifecycle (active / wip / archived ...) | optional |
| `stack/*` | Technology (wp, react, postgres, ha ...) | optional, repeatable |
| `prodotto/*` | Specific products within stacks | optional, repeatable |
| `area/*` | Topical domain (marketing, security, performance ...) | optional, repeatable |
| `tecnica/*` | Cross-cutting techniques (oauth, hmac, mcp ...) | optional, repeatable |

Full details and rationale: [skill/wiki-writer/tag-taxonomy.md](skill/wiki-writer/tag-taxonomy.md).

---

## Why this skill exists

Plain markdown wikis become unreadable for AI agents at scale:

- Free-form tags drift (`m3`, `md3`, `material-design`, `material-design-3` — all the same thing)
- Monolith files burn the context window (a 300 KB page is unworkable)
- Missing frontmatter means no filtering, no aliases, no relevance signal
- Inconsistent folder naming breaks `grep` and `find`
- Orphan log entries lose track of *why* something changed

This skill is the result of auditing a real personal wiki (~500 files, 1.5 MB) and identifying every friction point an LLM hits when navigating it. The conventions are battle-tested.

---

## Showcase

See [`templates/examples/techco-wiki/`](templates/examples/techco-wiki/) for a fictional 4-page wiki demonstrating every convention in practice.

---

## Roadmap

- [ ] Plugin distribution via Claude Code marketplace
- [ ] `wiki-stats` script (page-count, link graph density, stale pages)
- [ ] Optional GitHub Actions integration for auto-lint on commit
- [ ] Theming support for Obsidian Publish exports

---

## Contributing

PRs welcome. See [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md).

## License

MIT — see [LICENSE](LICENSE).
