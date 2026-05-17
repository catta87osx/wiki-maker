---
title: Postgres Production Cluster
category: sistemi
tags: [tipo/sistema, stato/produzione, dominio/work, stack/postgres, area/performance, area/sicurezza, tecnica/backfill]
updated: 2026-05-17
status: produzione
---

# Postgres Production Cluster

Main transactional database for TechCo. AWS RDS Postgres 16.2, db.r6g.4xlarge, multi-AZ across us-east-1a/1c.

Cross-ref: [[jane-doe]] · [[stripe-webhook-rotation]]

---

## Architecture

| Component | Detail |
|---|---|
| Engine | PostgreSQL 16.2 |
| Instance class | db.r6g.4xlarge (16 vCPU, 128 GB RAM) |
| Storage | 4 TB gp3, 12,000 IOPS provisioned |
| Replication | Multi-AZ synchronous standby + 1 async read replica in us-west-2 |
| Backups | Automated daily, retained 30 days; manual snapshots before migrations |
| Connection pooler | PgBouncer 1.21, transaction mode, 200 connections per app pod |

## Access

- Read-write: `appserver-*` IAM roles (production VPC only)
- Read-only analytics: `dashboards-*` role via the us-west-2 replica
- Emergency superuser: rotate every 90 days; stored in 1Password "Infra" vault
- All connections require SSL (`rds.force_ssl = 1`)

## Monitoring

- CloudWatch dashboard: `prod-postgres-main`
- Alarms route to PagerDuty `db-oncall` service
- Slow query log: pg_stat_statements; weekly review by the platform team

## Anti-patterns to avoid

- **Long-running transactions** > 30s — they block VACUUM. Use server-side cursors or pagination.
- **Sequential scans on `events` table** — always filter on `(account_id, created_at)`. The index `events_account_created_idx` is the only path that doesn't melt the cluster.
- **`SELECT *` in app code** — the row is wider than people remember; only fetch needed columns.

## Capacity

Current utilization at 38% CPU, 62% memory peak. Free space sufficient through Q4 2026 at current growth rate (~80 GB/month). Storage auto-scaling is enabled; instance scaling is manual.
