# Tag taxonomy — 7-namespace controlled vocabulary

The wiki uses **seven fixed namespaces**, separated by `/` (Obsidian-native nested tag syntax). The structure is universal; the **values** inside each namespace are user-configurable via `tags.md` in the wiki root.

---

## Why 7 namespaces

Each namespace answers a single question. Together, the seven dimensions uniquely position a page:

| Namespace | Question | Required? | Cardinality |
|---|---|---|---|
| `tipo/` | What kind of page is this? | yes | exactly 1 |
| `dominio/` | Who / what does this belong to? | yes | 1 or more |
| `stato/` | What's its lifecycle state? | optional | exactly 1 |
| `stack/` | What technology stack is involved? | optional | any number |
| `prodotto/` | What specific products within the stack? | optional | any number |
| `area/` | What topical / functional domain? | optional | any number |
| `tecnica/` | What cross-cutting techniques / patterns? | optional | any number |

Free-form (un-namespaced) tags are forbidden.

---

## Why namespacing

| Problem | Free-form tags | Namespaced |
|---|---|---|
| `grep "wp"` matches `wp-admin`, `wpforms`, `wpbakery`, accidentally | `grep "stack/wp\b"` matches exactly your WordPress pages | ✓ |
| `m3` and `md3` and `material-design-3` exist as duplicates | `prodotto/m3` is canonical, others are aliases | ✓ |
| Tag count grows linearly with vocabulary | Adding a new product = one new entry in `prodotto:` list, doesn't pollute root | ✓ |
| Hard to filter "all my projects in production" | `grep -lF "tipo/progetto" -lF "stato/produzione"` is unambiguous | ✓ |

---

## The seven namespaces

### `tipo/*` — kind of page (required, single value)

| Value | Use for |
|---|---|
| `tipo/progetto` | An initiative, active or completed (an app, a refactor, a campaign) |
| `tipo/sistema` | A system in operation (a SaaS account, an instance, infrastructure) |
| `tipo/concetto` | Reusable technical knowledge (a pattern, a dialect, a constraint) |
| `tipo/persona` | A profile of a person, team, or organization |
| `tipo/documento` | A document you received (contract, letter, scanned PDF) |
| `tipo/riferimento` | A pointer page to an external resource (URL, dashboard, external system) |
| `tipo/mockup` | Design spec or UI mockup not yet implemented |
| `tipo/plan` | An implementation or strategy plan |
| `tipo/changelog` | Version history of a project or system |
| `tipo/indice` | A page that's purely navigation (catalog, sitemap, sub-index) |
| `tipo/sorgente` | A page imported via scraping — read-only, never manually edited |

### `dominio/*` — ownership (required, 1+ values)

This namespace is highly user-specific. Defaults shipped:

| Value | Use for |
|---|---|
| `dominio/personal` | Your own personal stuff (finance, health, hobbies) |
| `dominio/work` | Your employer / day job |
| `dominio/shared` | Universal knowledge not tied to any owner |

Extend in `tags.md` for: specific clients (`dominio/clientX`), business units, side projects, family members, etc. A page can have multiple `dominio/*` tags if it spans (e.g. an internal tool used at work but built for personal benefit).

### `stato/*` — lifecycle (optional, single value)

Only meaningful for `tipo/progetto` or `tipo/sistema`. Shipped values:

| Value | Meaning |
|---|---|
| `stato/produzione` | Live, in daily use |
| `stato/wip` | Active development |
| `stato/prototipo` | Mockup or PoC, not deployed |
| `stato/idea` | Brainstorming only, no code yet |
| `stato/pausa` | Started, parked, may resume |
| `stato/archivio` | Completed or abandoned, kept for history |
| `stato/deprecato` | Replaced by a newer solution |

### `stack/*` — technology (optional, repeatable)

User extends in `tags.md`. Suggested starter set:

```yaml
stack:
  - wp          # WordPress
  - woo         # WooCommerce
  - react
  - nextjs
  - svelte
  - vue
  - typescript
  - python
  - go
  - rust
  - php
  - nodejs
  - postgres
  - mysql
  - redis
  - supabase
  - firebase
  - stripe
  - tailwind
```

### `prodotto/*` — specific products (optional, repeatable)

Use alongside `stack/*` for granularity. The user populates this from their actual stack. Examples shipped:

```yaml
prodotto:
  - wp-acf          # Advanced Custom Fields
  - wp-funnelkit
  - aws-lambda
  - aws-rds
  - vercel
  - cloudflare-pages
```

### `area/*` — topical domain (optional, repeatable)

Shipped values (cross-functional, vendor-neutral):

```yaml
area:
  - crm
  - automation
  - marketing
  - email
  - seo
  - tracking
  - sicurezza      # security
  - performance
  - ui
  - design-system
  - dashboard
  - analytics
  - sales
  - finanza
  - carriera       # career / job search
  - scraping
  - social-media
  - content
  - legale         # legal
  - documenti
```

### `tecnica/*` — cross-cutting patterns (optional, repeatable)

Shipped values:

```yaml
tecnica:
  - oauth
  - hmac
  - aes-gcm
  - hkdf
  - webhook
  - rest-api
  - hook              # event hooks (WP, JS frameworks)
  - mcp               # Model Context Protocol
  - tdd
  - loop-prevention
  - idempotency
  - backfill
  - tz-aware
  - mapping
  - schema-db
  - sql
  - bidirezionale
  - wide-table
```

---

## Customizing for your wiki

In your wiki root, edit `tags.md` to add/remove values from any namespace. The file is the **single source of truth** — the skill validates against it on every write.

Example minimal `tags.md` for a freelance web dev who works for multiple clients:

```yaml
# tags.md (user-customized)
dominio:
  - personal
  - shared
  - client-acme
  - client-beta
  - client-gamma
stack:
  - wp
  - nextjs
  - react
  - tailwind
  - vercel
prodotto:
  - vercel
area:
  - performance
  - seo
  - design-system
```

The skill auto-fills the four mandatory namespaces (`tipo`, `stato`, `area` defaults, `tecnica` defaults from this taxonomy doc) so you don't have to re-declare them.

---

## Rules of thumb

1. **Lowercase, singular, kebab-case** for all tag values: `stack/wordpress`, not `Stack/WordPress` or `stacks/wordpress`.
2. **Max ~10 tags per page.** More than that = the page covers too much; consider splitting.
3. **Every page has `tipo/*` and `dominio/*`.** No exceptions.
4. **No free-form tags.** If you need a value not in `tags.md`, add it to `tags.md` first.
5. **`stato/*` only on `tipo/progetto` or `tipo/sistema`.** Concepts don't have a lifecycle.
6. **Alias mapping in `tags.md`.** Document old/free-form tags as aliases for their canonical replacement, so future migrations don't drift again.

---

## Migration from a free-form tag system

If you're adopting this skill on an existing wiki with free-form tags:

1. Don't migrate in batch — risk of typos / regressions.
2. Migrate on-touch: when you next edit a page, the skill enforces the new vocabulary.
3. Use the audit command (`bash scripts/wiki-audit.sh tag-drift`) to see which pages still have free-form tags.
4. Track migration progress in `log.md`.

This is exactly how the original wiki this skill was built from was migrated. The audit took ~3 hours; the on-touch approach took the remaining time.
