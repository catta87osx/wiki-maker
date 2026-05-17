# Wiki conventions — full reference

The 16 categories of best practices enforced by the `wiki-writer` skill. Each rule is annotated with its enforcement tier (see SKILL.md for tier definitions).

---

## 1. Frontmatter

| Rule | Tier |
|------|------|
| Required fields: `title`, `category`, `tags`, `updated` | 1 |
| Optional fields: `sorgente`, `aliases`, `status`, `parent`, `version` | — |
| Tags must come from `tags.md` (controlled vocabulary) | 1 |
| Every page must have one `tipo/*` tag and one or more `dominio/*` tags | 1 |
| Max ~10 tags per page | 2 |
| `updated:` bumped on every meaningful change (>1 line of content), ISO 8601 (`YYYY-MM-DD`) | 1 |
| `aliases:` only for realistic search variants (acronyms, nicknames, old names) — not banal synonyms | 3 |
| Pages with `tipo/sorgente` are never manually edited; only re-scraped | 1 |

## 2. File structure

| Rule | Tier |
|------|------|
| One-sentence summary directly under H1, before the first section | 2 |
| Single H1 per file (= the title). Never multiple H1s | 1 |
| Heading hierarchy without gaps (no H2 → H4 jumps). Max H4 | 2 |
| `---` separator only before major sections, not between every subsection | 3 |
| "See also" / "Related" footer if the page doesn't close the topic | 3 |
| TL;DR + ToC required on files > 20 KB | 2 |
| Files > 60 KB must be split into a multi-file folder | 2 |
| Heading text stable — no emoji in titles, no special characters that Obsidian slugifies badly | 2 |
| File < 200 bytes → merge into parent (too thin) | 3 |
| Atomicity: 1 page = 1 entity. Pages covering 2 things should be split | 3 |

## 3. Filesystem naming

| Rule | Tier |
|------|------|
| Lowercase, kebab-case | 1 |
| No spaces in folder names (breaks bash/grep) | 1 |
| Filename = title slug. e.g. title `"CN Zoho Sync — Schema DB"` → filename `schema-db.md` | 2 |
| File-system-safe: no `:`, `?`, `*`, `<`, `>`, `|`, `"` | 1 |
| Basename collisions across folders OK only if the user explicitly uses path-aware wikilinks (`[[path/to/page]]`) | 2 |

## 4. Links

| Rule | Tier |
|------|------|
| Internal wiki pages → wikilinks `[[basename]]` | 1 |
| Disambiguated wiki pages in nested folders → `[[path/sub/page\|Display]]` | 2 |
| External URLs → markdown `[text](URL)`. Never inside `[[...]]` | 1 |
| File system paths → inline code `` `/abs/path` `` | 2 |
| Every page must have ≥ 1 outgoing wikilink (no orphans) | 1 |
| Pages with > 20 outgoing wikilinks → too dense, consider split | 3 |
| Link an entity the **first** time it appears in the page, not every occurrence | 3 |
| Cross-reference: if A links B, consider whether B should link A (backlink) | 3 |

## 5. Writing style

| Rule | Tier |
|------|------|
| Language: per `wiki.config.yaml > language`. Technical terms (API names, hook names) stay in English regardless | 2 |
| Absolute dates (`2026-05-17`). Never relative (`yesterday`, `last week`) | 2 |
| Third person or neutral imperative. Avoid "I" / "we" | 3 |
| Pronouns always have an explicit referent ("this rule..." not "this...") | 3 |
| Consistent verb tense within a page | 3 |
| Tight, dense. Tables > long prose | 2 |
| Comparable lists → table. Sequential lists → ordered bullets | 3 |
| Active voice > passive where possible | 3 |

## 6. Code in examples

| Rule | Tier |
|------|------|
| Fenced blocks always have language: ` ```bash `, ` ```yaml `, etc. | 2 |
| Minimal reproducible (5-15 lines, no boilerplate) | 3 |
| Placeholders explicit with angle bracket notation: `<contact_id>`, not `X` or `id` | 3 |
| Expected output next to commands when relevant (e.g. `# → 200 OK`) | 3 |
| Code comments only for the *why*, not the *what* | 3 |

## 7. Security & privacy

| Rule | Tier |
|------|------|
| NEVER commit secrets: API keys, passwords, refresh tokens, JWTs, session cookies | 1 |
| Emails / phones only where essential (CV yes, log entries no) | 2 |
| Private IPs (192.168.x) OK. Public IPs of third parties → redact | 2 |
| Third-party PII: SHA256 hash prefix, or dotted-name format `M. R.` | 2 |
| Local paths with usernames (`/Users/<you>/`) OK in a private wiki | — |

## 8. Read performance (for Claude)

| Rule | Tier |
|------|------|
| Files > 20 KB → TL;DR + ToC with line ranges | 2 |
| Files > 100 KB → grep patterns documented in addition to anchors | 2 |
| TL;DR fixed structure: 3-5 bullets + size warning + "do not read whole file" | 2 |
| ToC entries use line ranges, not just anchors (Obsidian anchor + Claude `Read offset/limit`) | 2 |
| DRY: if info exists in page A, link from B, don't duplicate | 3 |
| Lists > 30 items → table, not flat bullets | 3 |

## 9. Subtrees and indexes

| Rule | Tier |
|------|------|
| Every subfolder with ≥ 1 markdown file gets an `_index.md` | 2 |
| Top-level product indexes (e.g. `zoho-crm/index.md` for a flat scrape) preserved as-is | — |
| Recursive index: every node lists direct children + sub-folders with counts | 2 |
| `tipo/indice` pages have no original content, only navigation | 2 |

## 10. Log & tracking

| Rule | Tier |
|------|------|
| Append-in-head to `log.md` | 1 |
| Format: `## [YYYY-MM-DD] type \| short title` | 1 |
| Types: `ingest` / `update` / `create` / `query` / `lint` | 1 |
| Monthly rotation into `log/YYYY-MM.md` when root log exceeds `limits.log_rotation_kb` | 2 |
| Each entry links to the wiki pages it touches (wikilinks, not bare names) | 2 |
| Concrete bullet detail — what changed, why. No vague entries | 3 |

## 11. Main index

| Rule | Tier |
|------|------|
| Macro categories: People, Systems, Projects, Concepts, Documents (per config) | 1 |
| "Last 10 Updated" section at the top | 2 |
| Header links to `[[WIKI]]`, `[[tags]]`, `[[log]]` | 2 |
| One line per page, description < 140 chars (scannable) | 2 |
| Pages newest-first in each table | 3 |

## 12. Discoverability (for Claude)

| Rule | Tier |
|------|------|
| TL;DR contains the trigger phrase / common question a user would ask | 2 |
| Aliases for non-obvious acronyms (e.g. `RS`, `CTE`, `ELC` if they're internal terms) | 2 |
| `aliases:` field is read by Obsidian for autocompletion | — |
| Tag values from `tags.md` for precise grep filtering | 1 |

## 13. Maintenance

| Rule | Tier |
|------|------|
| Quarterly audit: broken links, tag drift, stale pages | 4 |
| Stale check: pages with `status: produzione` and `updated:` > 6 months → mandatory review | 4 |
| `lint`-type entry in `log.md` after every audit | 4 |
| Renaming a page → grep-replace path-aware wikilinks (Obsidian updates basenames but not paths) | 2 |

## 14. What NOT to put in the wiki

| Don't | Use instead |
|---|---|
| Temporary notes / scratchpad | TodoWrite or a notes app |
| Binary files (screenshots, PDFs, audio) | Store outside; link to path |
| Cron-style work logs ("today I did X") | Goes in `log.md`, not as standalone pages |
| Duplicates of CLAUDE.md content | It's already loaded |
| Documentation that belongs in commit messages / PR descriptions | Keep it where it serves |
| Secrets of any kind | Refused always, regardless of context |

## 15. Special conventions

| Rule | Tier |
|------|------|
| Scraped files: `tipo/sorgente`, `sorgente: <full URL>`, explicit scrape date, immutable | 1 |
| Index files: `tipo/indice`, tables/lists only, no original content | 2 |
| Log files: append-only, no rewrite of past entries | 1 |
| `_index.md` for navigation vs `index.md` for top-level products (both valid) | — |

## 16. Write idempotency

| Rule | Tier |
|------|------|
| Prefer `Edit` over `Write` for existing files (preserves mtime / history) | 2 |
| Full `Write` only when macro structure changes | 3 |
| Every significant Edit/Write → bump `updated:` in frontmatter + log entry | 1 |
