# Configure

The wiki is driven by `wiki.config.yaml` at its root. All settings have sensible defaults; you only need to edit what you want to change.

---

## Full schema

```yaml
version: 1                     # config schema version (do not change)

language: en                   # en | it | es | fr | de | pt
                               # Used for Claude-generated text (log, index, TL;DR)
                               # Technical identifiers stay in English regardless

paths:
  root: .                      # relative to this config file
  log_archive: log/            # where to move monthly archives

categories:                    # top-level folders, created on init
  - persone
  - sistemi
  - progetti
  - concetti
  - documenti
  # add or remove freely

tags:                          # controlled vocabulary
  dominio: [personal, work, shared]
  stato: [produzione, wip, prototipo, idea, pausa, archivio, deprecato]
  stack: [wp, react, nextjs, ...]
  prodotto: []
  area: [crm, automation, marketing, ...]
  tecnica: [oauth, hmac, webhook, ...]
  # tipo: is fixed in the taxonomy doc, not in config

limits:
  tldr_threshold_kb: 20        # add TL;DR + ToC above this
  split_threshold_kb: 60       # propose multi-file split above this
  log_rotation_kb: 50          # suggest monthly archive when log.md > this
  thin_page_bytes: 200         # warn if a page is this small

aliases: {}                    # old-tag → canonical mapping for migrations
```

---

## Common customizations

### 1. Multi-client freelance setup

```yaml
tags:
  dominio:
    - personal
    - shared
    - client-acme
    - client-beta
    - client-gamma
```

Every project page now tags which client it belongs to. Filter with `grep -l "dominio/client-acme" wiki/`.

### 2. Team / company wiki

```yaml
tags:
  dominio:
    - eng-platform     # platform team
    - eng-frontend     # frontend team
    - eng-data         # data team
    - prod-design      # product design
    - shared
```

### 3. Personal-only with finance tracking

```yaml
categories:
  - persone
  - sistemi
  - progetti
  - concetti
  - documenti
  - finanza      # uncomment from defaults
```

### 4. Italian-language wiki

```yaml
language: it
```

Index descriptions, log entries, TL;DR sections are generated in Italian. Note: tag namespace names (`tipo/`, `stato/`, etc.) stay as-is since they're identifiers, not prose.

### 5. Smaller files (large wiki)

```yaml
limits:
  tldr_threshold_kb: 10        # more aggressive — TL;DR on smaller files
  split_threshold_kb: 30       # force splits earlier
  log_rotation_kb: 30          # rotate log more often
```

### 6. Larger files (small wiki)

```yaml
limits:
  tldr_threshold_kb: 40        # only TL;DR on really big files
  split_threshold_kb: 100      # rarely split
  log_rotation_kb: 100         # rotate log less often
```

---

## How the skill reads config

On every invocation, the skill:

1. Locates `wiki.config.yaml` (walks up from CWD or uses path from `CLAUDE.md`)
2. Reads it into memory
3. Validates `tags.md` against declared values
4. Applies the size `limits.*` to format decisions

You can change settings between sessions; the next invocation picks them up.

---

## Updating the schema

If a future version of this skill adds new config fields:

1. Increment `version` in your config
2. The skill will apply new defaults for missing fields
3. Manually add the new sections if you want to customize them

The `version` field exists so future skill versions can warn about incompatible configs.

---

## Where Claude finds your wiki

The skill looks for `wiki.config.yaml` in this order:

1. Path declared in `~/.claude/CLAUDE.md` (e.g. `My wiki is at ~/Documents/my-wiki/`)
2. Common paths: `~/Documents/wiki/`, `~/Desktop/wiki/`, `~/wiki/`, `~/notes/`
3. Ancestor of current working directory

To pin it explicitly, add to `~/.claude/CLAUDE.md`:

```markdown
## Wiki location

My wiki lives at `<absolute-path>/`. Use the wiki-maker skill for any operation
involving the wiki.
```

This is the most reliable method.
