---
name: wiki-maker
description: Add, update, or maintain pages in a markdown/Obsidian wiki with enforced frontmatter, controlled tag vocabulary, automatic indexing, cross-linking, log entries, and size-based formatting rules. Triggers on phrases like "add to wiki", "save to my wiki", "create a wiki page", "document in wiki", "wiki entry", "new wiki page", "update wiki", or when the user references their personal knowledge base or Obsidian vault. Also handles wiki maintenance: audit broken links, rotate monthly log archive, detect stale pages, validate tag drift.
---

# wiki-maker

You manage a markdown/Obsidian wiki that the user uses as a long-term knowledge base for Claude. Your job is to add, update, and maintain pages while enforcing a set of conventions that keep the wiki AI-navigable and human-readable.

The conventions are documented in:

- `conventions.md` (this folder) — 16 categories of best practices, ~50 rules total
- `tag-taxonomy.md` (this folder) — the 7-namespace tag system

Both files are reference material. Load them when you need to verify a specific rule.

---

## Bootstrap (read on every invocation)

Before doing anything, locate the wiki and its config:

1. **Find `wiki.config.yaml`** by looking at common locations:
   - The user's CLAUDE.md may declare the path explicitly
   - Otherwise check `~/Documents/wiki/`, `~/Desktop/wiki/`, `~/wiki/`, current working directory ancestors
2. **Read `wiki.config.yaml`** — get `paths.root`, `language`, `categories`, `tags.*`, `limits.*`
3. **Read `tags.md`** at the wiki root — controlled vocabulary the user maintains
4. **Read `WIKI.md`** at the wiki root — frontmatter schema and any user-specific conventions
5. **Read `index.md`** at the wiki root — current page catalog (for cross-link detection)

If `wiki.config.yaml` doesn't exist, ask the user to run `wiki-init.sh` first or to confirm the wiki path manually.

---

## Decision tree

When the user requests a wiki operation, classify the intent:

### A. Add new page
Trigger phrases: "add to wiki", "save in wiki", "create wiki page", "document this", "new wiki page", "wiki entry for X".

### B. Update existing page
Trigger phrases: "update wiki page X", "change wiki entry Y", "amend the page about Z".

### C. Audit / maintenance
Trigger phrases: "audit wiki", "check wiki health", "lint wiki", "broken links in wiki", "rotate log", "wiki stale pages".

### D. Search / query
Trigger phrases: "find in wiki", "what does my wiki say about X", "search wiki for Y". → Use grep on the wiki tree; not a write operation, no skill enforcement needed.

---

## A. Add new page — workflow

### Step 1. Classify the content (Tier 1)

Determine which top-level category the page belongs to. Defaults from `wiki.config.yaml > categories`:

| Category | Use for |
|---|---|
| `persone/` | A person, organization, or entity profile |
| `sistemi/` | A system you operate (server, SaaS, infrastructure) |
| `progetti/` | A project (active, paused, archived, abandoned) |
| `concetti/` | Reusable technical knowledge (patterns, dialects, principles) |
| `documenti/` | A document you received (contract, letter, PDF scan) |
| `finanza/` | Personal finance records (optional category) |

If unclear between two, **ask the user**.

### Step 2. Compose the filename (Tier 1)

- Lowercase
- Kebab-case (hyphens, not underscores or spaces)
- Slug derived from the title
- No `:`, `?`, `*`, `<`, `>`, `|`, `"` characters
- Extension `.md` always

Example: title `"Postgres Cluster — Backup Procedure"` → filename `postgres-cluster-backup-procedure.md` (or just `backup-procedure.md` if it lives inside a `postgres-cluster/` project subfolder).

### Step 3. Build frontmatter (Tier 1)

```yaml
---
title: <Human readable title>
category: <category folder name>
tags: [tipo/<X>, dominio/<Y>, ...]
updated: <YYYY-MM-DD>
aliases: [alt1, alt2]        # optional, only for non-obvious search terms
sorgente: <URL or path>      # optional, if content derives from a source
status: <produzione|wip|...> # optional, mirrors stato/* tag
parent: <basename>           # optional, for pages inside a project subfolder
version: <semver>            # optional, for versioned projects
---
```

**Mandatory tags:**
- Exactly one `tipo/*` (the kind of page)
- One or more `dominio/*` (who/what it belongs to)

**Validate every tag against the values listed in `tags.md`.** If the user mentions a tag value not in the vocabulary, ask before adding it:
- *"`stack/golang` isn't in your tags.md. Add it to the vocabulary, or use an existing tag?"*

Max ~10 tags per page. More = the page is doing too much, suggest splitting.

### Step 4. Compose the body (Tier 2 + 3)

Structure:

```markdown
# <Title>            ← single H1, matches frontmatter title

<one-sentence summary describing what this page is>

<one-line of cross-links to closely related pages, prefixed by category>
Cross-ref: [[entity-a]] · [[entity-b]]

---

## <First major section>
...
```

Rules:
- Single H1 (= the title). Never multiple H1s in one file.
- One-sentence summary directly under H1. Tells the reader what the page is in one line.
- Heading hierarchy without gaps (no H2 → H4 jumps). Max H4.
- `---` separator only before major sections, not between every subsection.
- Code blocks always have language specifier: ` ```bash `, ` ```yaml `, ` ```sql `, etc.
- Absolute dates (`2026-05-17`), never relative (`yesterday`, `last week`).
- Italian text for descriptions if `language: it` in config, English otherwise. Technical identifiers (API names, hook names, code) stay in English regardless.
- No first-person pronouns ("I", "we") — use third person or neutral imperative.
- Every pronoun has an explicit referent ("this rule..." not "this...").
- Cross-link entities the **first** time they appear in the page, not every occurrence.

### Step 5. Size-aware formatting (Tier 2)

After composing the body, estimate the file size:

- **> 20 KB** → add a `## TL;DR` section right after the intro paragraph, with 3-5 bullets summarizing the page + a warning about size. Then a `## Indice (line ranges)` table mapping H2 sections to their approximate line numbers. Tell the user: *"This is a 25 KB page; I've added a TL;DR and ToC so Claude can navigate without loading the whole file."*
- **> 60 KB** → don't write it as a single file. Propose a folder split:
  - Create `<category>/<page-slug>/` directory
  - Inside: `<page-slug>.md` as the **landing** (slim, with index of subpages)
  - Plus one file per major section
  - Confirm structure with user before writing

### Step 6. Cross-linking (Tier 2)

Scan the body for mentions of entities that already exist in the wiki:

- Run `grep -l "<entity-name>"` against `index.md` and other curated pages
- Replace the **first** mention in the body with `[[entity-basename]]` (Obsidian wikilink)
- If two pages share a basename, use path-aware form: `[[path/to/page|Display]]`

Also check: every page must have **≥1 outgoing link**. If the body lacks any, add a `Cross-ref:` line under the summary linking to the most relevant existing page.

### Step 7. Update `index.md` (Tier 1)

Append the new page to the appropriate category table:

```markdown
## <Category>

| Page | Description |
|------|-------------|
| [[new-page]] | <one-line description, < 140 chars> |
| ... |
```

Also push the new page to the top of `## Last 10 Updated`:

```markdown
| 2026-05-17 | [[new-page]] |
```

Remove the 11th oldest entry from that list.

### Step 8. Append `log.md` entry (Tier 1)

Add to the top of `log.md` (append-in-head):

```markdown
## [YYYY-MM-DD] create | <page-basename> — <short title>
- <what was created and why>
- <key entities cross-linked>
- <any non-obvious decisions>
```

Use the configured `language` for the prose. Type values: `create` / `update` / `ingest` / `query` / `lint`.

If `log.md` size exceeds `limits.log_rotation_kb` after the append, suggest running `wiki-archive-log.sh` (Tier 4).

### Step 9. Final validation (Tier 1)

Before announcing success:

- All wikilinks `[[...]]` in the new page resolve to existing files (run `grep -l basename <wiki-root>`)
- Frontmatter `tags:` only contains values from `tags.md` (or freshly added with user approval)
- Filename matches title slug
- `updated:` is today's date
- `index.md` and `log.md` were both updated

---

## B. Update existing page — workflow

Same rules as add, but:

1. **Read the existing page first** before any edit.
2. Use `Edit` not `Write` — preserves file history.
3. Bump `updated:` to today's date.
4. Append a `log.md` entry of type `update`, listing what changed.
5. If the change creates duplicate info with another page, propose merging instead of duplicating.

---

## C. Audit / maintenance commands

The user can invoke any of these explicitly:

### Broken links sweep

```bash
bash scripts/wiki-audit.sh broken-links
```

Walks every `[[wikilink]]` and reports targets that don't resolve to a file.

### Tag drift detection

```bash
bash scripts/wiki-audit.sh tag-drift
```

Lists tag values found in pages but not declared in `tags.md`. Helps catch when conventions slip.

### Stale page report

```bash
bash scripts/wiki-audit.sh stale --months 6
```

Lists pages with `status: produzione` and `updated:` older than N months — likely need review.

### Monthly log rotation

```bash
bash scripts/wiki-archive-log.sh
```

Moves entries older than the current month into `log/YYYY-MM.md`. Updates the *Archive* footer in `log.md`. Suggest this when `log.md` > `limits.log_rotation_kb`.

Run an audit after each maintenance pass and add a `lint`-type entry to `log.md`.

---

## Tiering rules summary

| Tier | Behaviour |
|---|---|
| **Tier 1 — hard block** | Refuse to write if any of these violated: missing `tipo/*` or `dominio/*` tag, invalid filename, missing frontmatter field, no outgoing wikilinks |
| **Tier 2 — confirm before override** | Page > 20 KB without TL;DR; > 60 KB without split; ≥ 1 wikilink unresolved; over the 10-tag soft limit |
| **Tier 3 — soft warning** | File < 200 bytes (too thin?); duplicate-looking content; stale-but-related pages; informal style (first-person, ambiguous pronouns); inconsistent verb tense |
| **Tier 4 — manual command** | Broken-link sweep, tag drift, stale audit, log rotation — only on explicit user request |

---

## What NOT to put in the wiki

Refuse and suggest alternatives:

- **Temporary notes / scratchpad** → suggest the user's TodoWrite tool or a notes app instead
- **Binary files (screenshots, PDFs, audio)** → store outside the wiki; link to the path
- **Cron-style work logs** ("today I did X") → these go in `log.md`, not as standalone pages
- **Content already in CLAUDE.md** → it's already loaded; no need to duplicate
- **Documentation that belongs in a commit message / PR description** → keep it where it serves
- **Secrets**: API keys, passwords, tokens, JWTs, session cookies — refuse always
