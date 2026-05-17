# Changelog

All notable changes to `claude-wiki-skill`. Format based on [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

## [1.0.0] — 2026-05-17

Initial public release.

### Added
- `SKILL.md` with trigger phrases, decision tree, 9-step add-page workflow
- `conventions.md` with 16 categories of best practices, ~50 rules total
- `tag-taxonomy.md` documenting the 7-namespace tag system
- `wiki-init.sh` to bootstrap a fresh wiki from the template
- `wiki-audit.sh` with subcommands: `broken-links`, `tag-drift`, `stale`, `orphans`, `all`
- `wiki-archive-log.sh` for monthly log rotation
- `wiki.config.yaml` schema with `language`, `categories`, `tags.*`, `limits.*`
- Fictional showcase wiki (`templates/examples/techco-wiki/`) demonstrating every convention
- Full docs: `README`, `INSTALL`, `CONFIGURE`, `CONTRIBUTING`

### Conventions derived from
A real-world audit of a personal wiki (~500 files, 1.5 MB) over a one-day session. The skill is the result of identifying every friction point an LLM hit while navigating that wiki and codifying the fixes.
