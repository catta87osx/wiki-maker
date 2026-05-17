---
title: Stripe Webhook Secret Rotation
category: sistemi
tags: [tipo/sistema, stato/produzione, dominio/work, stack/stripe, area/sicurezza, tecnica/webhook, tecnica/hmac]
updated: 2026-05-12
status: produzione
---

# Stripe Webhook Secret Rotation

Quarterly rotation procedure for the Stripe webhook signing secret used by the payments service. Also triggered on-demand if a secret is suspected leaked.

Cross-ref: [[postgres-prod-cluster]] · [[jane-doe]]

---

## When to rotate

| Trigger | Action |
|---|---|
| Quarterly (Jan, Apr, Jul, Oct) | Scheduled rotation — calendar reminder in payments oncall calendar |
| Suspected leak (commit, log line, etc.) | Rotate immediately + audit access log |
| Stripe account compromise | Stripe rotates automatically; we replay |
| Employee with access leaves | Rotate within 24h |

## Procedure

```bash
# 1. Generate a new endpoint in Stripe dashboard (Developers → Webhooks)
#    URL stays the same; only the signing secret changes.
#    Stripe shows the new secret ONCE — copy immediately.

# 2. Add the new secret to AWS Secrets Manager (dual-active period)
aws secretsmanager update-secret \
  --secret-id prod/stripe/webhook-secret-new \
  --secret-string "whsec_..."

# 3. Update payments service config to accept BOTH old and new secrets
#    (PR: payments-service#stripe-rotation-q2)

# 4. Deploy to production
#    Verify metric `stripe_webhook_verified_total` continues incrementing on both keys

# 5. Disable the old endpoint in Stripe dashboard (keep configured but inactive)
#    Wait 24h for any retried webhooks to process

# 6. Remove the OLD secret from Secrets Manager and from app config
aws secretsmanager delete-secret \
  --secret-id prod/stripe/webhook-secret-old \
  --recovery-window-in-days 7

# 7. Promote new secret to canonical name
aws secretsmanager update-secret \
  --secret-id prod/stripe/webhook-secret \
  --secret-string "whsec_..."
```

## Verification

After rotation completes:

```bash
# Trigger a test event from Stripe dashboard
# Watch the application log
kubectl logs -n payments -l app=payments-svc --tail=20 -f
# → expect: "stripe_webhook_signature_verified ok"
```

If you see `signature_verification_failed`, rollback to the old secret and investigate before disabling.

## Audit trail

Every rotation generates an entry in `audit_log`:

```sql
SELECT created_at, actor, payload_excerpt
FROM audit_log
WHERE event_type = 'stripe_webhook_secret_rotated'
ORDER BY created_at DESC
LIMIT 10;
```

## Anti-patterns to avoid

- **Single-secret hot swap**: deploying the new secret without the dual-active period guarantees missed webhooks during the window. Always overlap.
- **Storing the secret in env vars on local laptops**: Secrets Manager only. The whole point of rotation is to limit blast radius from leaks.
- **Skipping the 24h wait**: Stripe retries failed webhooks for up to 3 days. Disabling the old endpoint too early means lost events.
