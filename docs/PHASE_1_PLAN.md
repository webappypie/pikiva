# Phase 1 — Premium UI shell

Scope: MASTER_PRD section 36 and the explicit Phase 1 prompt. Starting commit
eda5081; clean working tree; Phase 0 preserved. No Phase 2 implementation.

Acceptance:
- Real preference-loading splash, first-launch value/privacy onboarding, then
  Home / Creations / Sessions / Settings with appropriate back navigation.
- Photo-led Home, intentional empty states, local sample collection, labeled
  mock result filters and photo-detail view; no claimed real analysis.
- Profile/Cover/Collage/Reels browsing with clearly labeled static previews.
- Persistent light/dark/system and onboarding preferences, privacy/help/licenses.
- Loading, retryable errors, empty and populated states; no fake progress.
- Responsive phone/tablet/landscape layouts, large text, semantic labels,
  minimum targets, contrast, reduced-motion-aware animation primitives.
- Tests for controller/storage failure, first/returning launch, navigation,
  sample results, preference changes, responsive layouts and accessibility.
- Format, analyze, tests, Android build/native smoke and iOS CI compilation.

Changes: app routing/composition, shared visual primitives, feature screens,
non-sensitive UI preference adapter, sample fixtures/assets, tests, docs, CI
format scope. Only new runtime package: shared_preferences (Flutter publisher,
BSD-3-Clause, Android 24+/iOS 13+); use its async API behind an injected adapter.
Preferences are not a session database and do not hold media or secrets.

Risks: iOS runtime still requires Mac/device; low-memory Windows emulator should
run after builds; native preferences can fail and must offer retry/session-only
fallback; generated sample photos must be attributed as samples, never user data.
Real picker, persistence of photo sessions, ranking, deletion, templates,
rendering, Firebase, cloud AI and monetization remain deferred.

Visual direction: retain sage/ink/chalk tokens, large photographic cards,
editorial hierarchy, restrained borders, generous spacing. Two original
AI-generated fictional landscapes are bundled offline; no runtime AI dependency.
