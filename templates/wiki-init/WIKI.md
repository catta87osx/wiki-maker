# Wiki schema and conventions

This file defines the conventions for this wiki. **Do not edit unless you intend to change skill behavior** — the `wiki-maker` Claude Code skill reads it on every operation.

Configuration: [wiki.config.yaml](wiki.config.yaml)
Tag vocabulary: [tags.md](tags.md)
Page catalog: [index.md](index.md)
Change log: [log.md](log.md)

---

## Folder structure

```
wiki/
├── WIKI.md             ← this file (schema & conventions)
├── wiki.config.yaml    ← user-configurable settings (paths, language, tag values)
├── tags.md             ← controlled tag vocabulary
├── index.md            ← catalog of all pages
├── log.md              ← append-only change log (current month)
├── log/                ← monthly archive (YYYY-MM.md)
├── persone/            ← people / entities profiles
├── sistemi/            ← systems / infrastructure
├── progetti/           ← projects
├── concetti/           ← reusable technical knowledge
└── documenti/          ← received documents
```

Categories are configurable via `wiki.config.yaml > categories`.

---

## Frontmatter

Every page begins with:

```yaml
---
title: Human-readable title
category: persone | sistemi | progetti | concetti | documenti
tags: [tipo/progetto, dominio/personal, stack/wp, area/automation]
updated: YYYY-MM-DD
aliases: [optional, only for non-obvious search terms]
sorgente: optional URL or path if content derives from a source
status: produzione | wip | prototipo | archivio (optional)
parent: optional basename for subfolder pages
version: optional semver for versioned projects
---
```

**Tag rules:**
- Always namespaced (`tipo/X`, `dominio/Y`, etc.) — never free-form
- Mandatory: one `tipo/*`, one or more `dominio/*`
- Values must exist in [tags.md](tags.md)
- Max ~10 tags per page

---

## Wikilink rules

- Internal pages → `[[basename]]`
- Disambiguated nested pages → `[[path/to/page|Display]]`
- External URLs → markdown `[text](URL)`. **Never inside `[[...]]`**.
- Every page must have ≥ 1 outgoing wikilink (no orphans).

---

## Log format

```markdown
## [YYYY-MM-DD] type | short title
- specific detail 1
- specific detail 2
```

Types: `ingest` / `update` / `create` / `query` / `lint`

**Rules:**
- Append at the top of `log.md`. Never edit past entries.
- **Monthly rotation:** when `log.md` exceeds `limits.log_rotation_kb` (see [wiki.config.yaml](wiki.config.yaml)), move past entries into `log/YYYY-MM.md` and add a pointer in the *Archive* footer.

---

## When to update the wiki

| Event | Action |
|---|---|
| New info on an existing system/project | Update the page + bump `updated:` + log entry |
| New entity (person, system, project, concept) | Create page + add to `index.md` + log entry |
| Technical decision recorded | Update or create concept page + log entry |
| End of session with changes | Verify `log.md` and `index.md` reflect the work |

---

## Quality (manual audit, quarterly)

- Pages with no outgoing wikilinks (orphans) — should not exist
- `index.md` complete relative to all files on disk
- Contradictions between pages
- Stale info (pages with `status: produzione` and `updated:` > 6 months)
- Tag drift (values in pages not declared in `tags.md`)

Use the audit script: `bash scripts/wiki-audit.sh`. Add a `lint`-type log entry after each pass.

---

## Skill reference

This wiki is designed to be operated by the `wiki-maker` Claude Code skill. Full conventions: [wiki-maker/conventions.md](https://github.com/catta87osx/wiki-maker/blob/main/skill/wiki-maker/conventions.md).
