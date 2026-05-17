# Tag vocabulary

Controlled vocabulary for this wiki. **Only the values listed here are valid as tags.**

The `wiki-writer` skill validates against this file on every write. To add a new tag value, edit this file *first*.

See also: [`wiki.config.yaml`](wiki.config.yaml) for runtime configuration · [`skill/wiki-writer/tag-taxonomy.md`](https://github.com/catta87osx/claude-wiki-skill/blob/main/skill/wiki-writer/tag-taxonomy.md) for the namespace rationale.

---

## Rules

1. **Always lowercase, singular, kebab-case**: `automation`, not `Automation` or `automations`
2. **Namespacing with `/`** (Obsidian nested-tag syntax): `tipo/progetto`, `stack/wordpress`
3. **Every page must have at least**: one `tipo/*` tag, one `dominio/*` tag. All others optional
4. **Free-form tags forbidden**: if a tag is needed, add it to this file first, then use it
5. **`stato/*` only on `tipo/progetto`** or `tipo/sistema` pages with real lifecycle
6. **Max ~10 tags per page**: beyond that = the page is doing too much
7. Frontmatter syntax: `tags: [tipo/progetto, stato/wip, dominio/personal, stack/wp]`

---

## `tipo/*` — kind of page (required, 1 value)

| Value | Use for |
|---|---|
| `tipo/progetto` | An initiative (active or completed) |
| `tipo/sistema` | A system in operation (SaaS, server, infrastructure) |
| `tipo/concetto` | Reusable technical knowledge (a pattern, a dialect) |
| `tipo/persona` | A person or entity profile |
| `tipo/documento` | A document you received (contract, letter, scan) |
| `tipo/riferimento` | Pointer page to an external resource |
| `tipo/mockup` | UI or output spec not yet implemented |
| `tipo/plan` | An implementation or strategy plan |
| `tipo/changelog` | Version history of a project or system |
| `tipo/indice` | A page that's purely navigation |
| `tipo/sorgente` | A page imported via scraping — read-only |

## `dominio/*` — ownership (required, 1+ values)

| Value | Meaning |
|---|---|
| `dominio/personal` | Your personal stuff |
| `dominio/work` | Your employer / day job |
| `dominio/shared` | Universal knowledge not tied to any owner |

**Extend freely**: clients (`dominio/client-acme`), business units, side projects, family members. A page may have multiple `dominio/*` if it spans.

## `stato/*` — lifecycle (optional, 1 value)

| Value | Meaning |
|---|---|
| `stato/produzione` | Live, in daily use |
| `stato/wip` | Active development |
| `stato/prototipo` | Mockup or PoC, not deployed |
| `stato/idea` | Brainstorming only |
| `stato/pausa` | Started, parked |
| `stato/archivio` | Completed / abandoned, kept for history |
| `stato/deprecato` | Replaced by a newer solution |

## `stack/*` — technology (optional, repeatable)

| Value | Tech |
|---|---|
| `stack/wp` | WordPress |
| `stack/woo` | WooCommerce |
| `stack/react` | React |
| `stack/nextjs` | Next.js |
| `stack/typescript` | TypeScript |
| `stack/python` | Python |
| `stack/postgres` | PostgreSQL |
| `stack/mysql` | MySQL / MariaDB |
| `stack/redis` | Redis |
| `stack/supabase` | Supabase |
| `stack/stripe` | Stripe |
| `stack/tailwind` | Tailwind CSS |

*(Extend this table as your stack grows.)*

## `prodotto/*` — specific products (optional, repeatable)

| Value | Product |
|---|---|
| *(empty — populate as you adopt specific products)* | |

## `area/*` — topical domain (optional, repeatable)

| Value | Area |
|---|---|
| `area/crm` | CRM, contact management |
| `area/automation` | Marketing automation, flows, triggers |
| `area/marketing` | Marketing general (campaigns, content) |
| `area/email` | Email marketing, deliverability |
| `area/seo` | SEO/SEM, audit |
| `area/tracking` | Pixels, events, dataLayer |
| `area/sicurezza` | Security, crypto, threat model |
| `area/performance` | Load time, optimization |
| `area/ui` | User interfaces, interaction |
| `area/design-system` | Design tokens, system |
| `area/dashboard` | Dashboards, BI |
| `area/analytics` | KPIs, funnel analysis |
| `area/finanza` | Personal finance |
| `area/carriera` | Career / job search / CV |
| `area/scraping` | Web scraping, crawl |
| `area/social-media` | LinkedIn / social content |
| `area/content` | Copywriting, content strategy |
| `area/legale` | Legal, compliance |
| `area/documenti` | Personal / work documents |

## `tecnica/*` — cross-cutting patterns (optional, repeatable)

| Value | Pattern |
|---|---|
| `tecnica/oauth` | OAuth flow |
| `tecnica/hmac` | HMAC SHA256 webhook signing |
| `tecnica/aes-gcm` | AES-256-GCM encryption |
| `tecnica/webhook` | Webhook in/outbound |
| `tecnica/rest-api` | REST API |
| `tecnica/hook` | Framework event hooks |
| `tecnica/mcp` | Model Context Protocol server |
| `tecnica/tdd` | Test-driven development |
| `tecnica/loop-prevention` | Anti-loop in bidirectional syncs |
| `tecnica/idempotency` | Idempotency hash / key |
| `tecnica/backfill` | Batch backfill job |
| `tecnica/tz-aware` | Timezone-aware datetime |
| `tecnica/mapping` | Field / value mapping |
| `tecnica/schema-db` | DB schema, migrations |
| `tecnica/sql` | SQL queries, optimization |

---

## Aliases (legacy → canonical)

When you migrate from a free-form tag system, record old values here so they're remembered as aliases. The skill won't auto-rewrite but won't flag pages still using them either.

| Legacy tag | Canonical |
|---|---|
| *(empty — populate during migration)* | |

---

*Last updated: <YYYY-MM-DD>*
