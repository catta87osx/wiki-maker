# Change Log

Append-only record of every change to the wiki. Most recent entries at the top.

**Format:**
```
## [YYYY-MM-DD] type | short title
- detail 1
- detail 2
```

**Types:** `ingest` / `update` / `create` / `query` / `lint`

**Rotation policy:** When this file exceeds `limits.log_rotation_kb` (see [wiki.config.yaml](wiki.config.yaml)), past months are moved to `log/YYYY-MM.md` by `scripts/wiki-archive-log.sh`. Archive links live in the *Archive* footer below.

---

## [YYYY-MM-DD] create | wiki initialized
- Bootstrapped via `wiki-init.sh`
- Empty folders created: persone, sistemi, progetti, concetti, documenti
- `tags.md` populated with default vocabulary (extend as needed)

---

## Archive

*(empty — populated as months are rotated)*
