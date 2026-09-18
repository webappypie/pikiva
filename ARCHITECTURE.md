# Architecture

## Scope and decisions

Phase 0 establishes a small composition root and cross-platform foundation.
Product behavior is specified by `docs/MASTER_PRD.md`; the current user request
limits implementation to section 36, Phase 0. No future service is represented
by a fake implementation and no product flow is claimed complete.

```text
lib/
  main.dart                  binding initialization and immutable build config
  app/
    pikiva_app.dart           composition root and router lifecycle
    routing/                 paths, nested navigation, safe route-error recovery
    view/                    foundation screen and route fallback only
  core/
    config/                  validated, public local configuration
    design/                  tokens, themes, accessible reading layout
  l10n/                      English ARB; generated output is ignored
  features/                  documented boundary; implementations by phase
  services/                  documented boundary; adapters by phase
config/                      public development and production definitions
test/                        config and app/widget behavior checks
integration_test/            native cold-launch/navigation smoke test
android/, ios/               Flutter-generated platform hosts
.github/workflows/           version-pinned quality baseline
```

`app` composes UI and dependencies. Features own presentation and domain
behavior. `core` contains shared policies/primitives, not unrelated business
logic. `services` will wrap external SDKs and native APIs. Presentation must not
call platform media or cloud plugins. Domain calculations should be pure Dart
unless a native computation adapter is necessary. Dependencies are injected at
the composition root; avoid global service locators and hidden singletons.

Use Flutter's built-in local widget state and explicit constructor injection
for the foundation. No state-management package is justified yet. If later
long-running cross-screen work requires one, document one consistent choice;
job lifecycle must be independent of an individual screen.

## Routing and presentation

`go_router` implements `/` and nested `/licenses` with a real parent back stack.
Unknown routes produce a generic recovery screen; incoming paths/query strings
are neither displayed nor logged. No four-tab UI exists before Phase 1.
The app owns/disposes its default router; a test-injected router remains owned
by its caller. The router remains stable through theme rebuilds.

Central tokens define spacing, radii, colors, type, elevation, icon sizes,
timing, and easing. Material 3 supplies platform interaction behavior. Light,
dark, and system modes are supported at the app boundary. The default is system;
persistence and the Settings control belong to later product implementation.
A bounded, scrollable SafeArea layout accommodates small displays, rotation,
and large text without clamping the system's accessibility scaling. Theme
transitions honor reduced motion. English ARB strings establish localization.
Platform fonts avoid network font loading and extra font licensing/binary cost.

Startup is synchronous with no I/O, so artificial loading, progress, and success
states would misrepresent behavior. The foundation explicitly communicates
unavailable photo tools. A route error has an actionable recovery. Feature
loading/empty/error/success states are required when those features arrive.

## Configuration and privacy

Public build definitions select `development` or `production`; absent values
select production, and misspellings fail validation. Both environments keep
cloud text and telemetry disabled. No endpoints, credentials, or provider
selection exist. `AppConfig` is injected into the composition root for future
service composition; the UI does not need to consume it in Phase 0.

Native flavors are not needed with one offline binary identity. Add separate
native configurations at Firebase integration if required. Never interpret
Dart defines or Remote Config as a secret store or as enforcement of a backend
security policy. Native release signing must be configured securely later.

Android's release manifest requests no network/media permission and disables
app backup before private local storage is introduced. Debug/profile Internet
permission is Flutter tooling only. iOS has no photo usage prompts or cloud
entitlements. iOS file protection/backup exclusions must be applied and tested
when actual private storage is created in Phase 2. No photo is accessed today.

## Future boundaries (design constraints, not implemented services)

| Phase | Responsibility | Boundary/invariants |
| --- | --- | --- |
| 2 | Media library and local sessions | System picker, selected/limited access, native API adapter, migration-capable local DB; never original image blobs in DB |
| 3–6 | Analysis, ranking, faces, Best Set | Bounded thumbnails/cache, workers off UI thread, deterministic reason codes, diverse selection, no sensitive inference or identity store |
| 7 | Review Bin | Local reversible decisions; final deletion only after explicit confirmation and OS flow; reconcile partial failures |
| 8 | Lightweight editor | Non-destructive adjustments, preserve original, new exports; no professional editor expansion |
| 9 | Shared template engine | Immutable IDs, versions, minimum app version, local JSON/assets, safe handling of unknown data, face-safe crops |
| 10 | Reel scene/preview engine | Deterministic scene transforms/transitions/text/beat metadata and licensed audio; no manual timeline or generated video |
| 11 | Video renderer | Replaceable native adapter with progress/cancel, codec/license/size/store review, bounded temporary storage and cleanup |
| 12 | Firebase support layer | Privacy-filtered diagnostics, Remote Config, App Check; never original photos or routine session storage |
| 13 | Optional text suggestions | Local fallback, secure backend, provider abstraction, explicit request, timeout/quota/cache; text metadata only |

Future analysis metadata and session data stay local. Cache eviction must never
delete source media or active render files. User-written text is not overwritten.
Normal photos, crops, embeddings, filenames, location EXIF, and private text must
not enter diagnostics. User media is never a fallback payload for cloud APIs.
No FFmpeg/media dependency is selected in this phase.

## Quality and evolution

Tests cover config defaults/validation, startup without platform services,
routing/deep links/back/recovery, privacy-safe error copy, theme changes,
reduced motion, Android/iOS target sizes, labels/contrast, and layouts at phone,
landscape, and tablet widths with 200% text. A device integration test covers
cold launch and local navigation. Tests for media safety, DB migrations,
analysis, and rendering belong with their real implementations.

CI pins Flutter and action revisions, installs from the lockfile, and needs no
secrets. Android and iOS compile in separate jobs. Add device matrices and
release-signing checks when their phases justify them. macOS compilation and
physical-device accessibility/performance checks cannot be inferred from a
Windows widget-test pass.
