---
title: Mobile App Rewrite (React Native)
category: progetti
tags: [tipo/progetto, stato/wip, dominio/work, stack/react-native, stack/typescript, area/performance, area/ui]
updated: 2026-05-16
status: wip
version: 0.6.0
---

# Mobile App Rewrite (React Native)

Replacement of the legacy native iOS (Swift) and Android (Kotlin) apps with a single React Native codebase. Target ship date: Q3 2026.

Cross-ref: [[jane-doe]] (sponsor) · [[postgres-prod-cluster]] (backend dependency)

---

## Status (2026-05-16)

| Workstream | Owner | Progress |
|---|---|---|
| Core navigation | mobile team | 100% — shipped to internal alpha |
| Authentication | mobile + platform | 85% — biometric flow blocked on iOS keychain edge case |
| Payments integration | mobile + payments | 60% — needs Stripe SDK 3.0 upgrade |
| Push notifications | mobile + platform | 40% — APNs token refresh logic in review |
| Offline mode | mobile | 10% — design phase, no code |

## Why this rewrite

- **Maintenance cost**: two native codebases means duplicated features, bugs, release cycles
- **Hiring**: React Native developers are easier to source than Swift+Kotlin pairs
- **Feature velocity**: one PR ships everywhere instead of three
- **Design system reuse**: the web app uses the same component library; mobile inherits 60% of it

## Anti-patterns to avoid (lessons from sister projects)

- **Don't ship two stores at once**: roll out iOS first to gather early signal; Android two weeks behind
- **Don't replace Firebase Crashlytics with a custom solution**: it works, leave it alone
- **Don't try to ship offline mode in v1**: scope creep that killed an earlier rewrite attempt in 2024

## Risks

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Apple App Review rejection on TestFlight upgrade flow | Medium | High | Pre-submit a build at 50% feature completion to surface issues early |
| Stripe SDK 3.0 breaking changes | High | Medium | Pin to 3.0.x and assign one engineer to track changelog |
| Engineer ramp-up time on React Native | Medium | Low | Pair-programming for the first sprint; Jane runs weekly tech-share |

## Decisions log

- **2026-04-12**: Decided RN over Flutter. Reason: existing React expertise on the web team, ability to share component library.
- **2026-05-03**: Adopted Expo for OTA updates. Reason: pushing critical fixes without App Store review.
- **2026-05-15**: Postponed offline mode to v1.1. Reason: scope risk for Q3 ship date.

## Next milestones

| Date | Milestone |
|---|---|
| 2026-06-01 | Internal beta (employees only) — all core flows working |
| 2026-07-15 | Public TestFlight + Google Play closed testing |
| 2026-09-01 | App Store / Play Store public launch |
