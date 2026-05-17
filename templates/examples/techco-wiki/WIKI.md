# Wiki schema and conventions

This is the showcase wiki for the `claude-wiki-skill` repo — a fictional company called TechCo. Use it to see what the skill's conventions look like in practice.

The real schema doc that ships with new wikis is in [`templates/wiki-init/WIKI.md`](../../wiki-init/WIKI.md). This file is identical to it but lightly trimmed for the demo.

Configuration: [wiki.config.yaml](wiki.config.yaml)
Tag vocabulary: [tags.md](tags.md)
Page catalog: [index.md](index.md)
Change log: [log.md](log.md)

---

## Folder structure

```
techco-wiki/
├── WIKI.md             ← this file
├── wiki.config.yaml    ← config
├── tags.md             ← controlled vocabulary
├── index.md            ← catalog
├── log.md              ← changes
├── persone/            ← [[jane-doe]]
├── sistemi/            ← [[postgres-prod-cluster]], [[stripe-webhook-rotation]]
├── progetti/           ← [[mobile-app-rewrite]]
├── concetti/           ← (empty in this showcase)
└── documenti/          ← (empty in this showcase)
```

---

## Frontmatter convention (demonstrated in each page)

```yaml
---
title: Human-readable title
category: persone | sistemi | progetti | concetti | documenti
tags: [tipo/X, dominio/Y, stack/Z, area/W]
updated: YYYY-MM-DD
status: produzione | wip | prototipo | archivio   (optional)
version: semver                                    (optional, projects)
aliases: [alt1, alt2]                              (optional)
---
```

**Mandatory tags:** `tipo/*` (one) and `dominio/*` (one or more).

---

## What you'll see in each example page

| Page | Demonstrates |
|------|--------------|
| [[jane-doe]] | `tipo/persona`, multi-`dominio` (work), aliases for nickname search |
| [[postgres-prod-cluster]] | `tipo/sistema` + `stato/produzione`, tables for structured data, anti-patterns section |
| [[stripe-webhook-rotation]] | `tipo/sistema` for a procedure, code blocks with language specifier, audit trail SQL |
| [[mobile-app-rewrite]] | `tipo/progetto` + `stato/wip`, decisions log, risk table, milestones |

Note how every page:
- Has a one-sentence summary directly under the H1
- Includes a `Cross-ref:` line linking to related pages
- Uses tables for comparable lists, not bullet lists
- Cites absolute dates only
- Has at least one outgoing wikilink

---

## Try the skill against this wiki

```bash
# Point Claude at this showcase
echo "Test wiki at $(pwd)/templates/examples/techco-wiki. Use wiki-writer skill." >> ~/.claude/CLAUDE.md

# Then in Claude Code:
# > add to wiki: <some test content>
# > update jane-doe with: she's now also leading the data infra hiring
# > audit wiki for stale pages

# Or run the audit script directly:
# bash scripts/wiki-audit.sh all --root templates/examples/techco-wiki
```

When done with the demo, remove the line you added to `~/.claude/CLAUDE.md`.
