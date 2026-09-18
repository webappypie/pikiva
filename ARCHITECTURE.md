# Architecture

## Scope and decisions

Phase 1 adds the premium UI shell specified by MASTER_PRD section 36. Phase 0
configuration/privacy/platform boundaries remain intact. No real media session,
analysis, template engine, render service or cloud integration is implemented.

```text
lib/
  main.dart                 binding initialization and public build config
  app/
    pikiva_app.dart         composition root, adapter/controller/router ownership
    shell_controller.dart  UI preference and ephemeral sample state
    routing/                startup redirect, four stateful branches, detail routes
    view/                   adaptive shell and safe route-error recovery
  core/
    config/                 immutable non-secret configuration
    design/                 tokens, themes, responsive cards, state transitions
    storage/                UI-only preference adapter
  features/
    onboarding/             value/privacy welcome, startup loading/retry
    home/                   photo-led home and sample entry points
    sessions/               empty and sample collection views
    samples/                validated bundled fixtures, mock results/detail
    creations/              static Profile/Cover/Collage/Reels previews
    settings/               theme, privacy, help, licenses, sample reset
  l10n/                     English ARB; generated output ignored
assets/samples/             two fictional photographs and authored fixture JSON
```

`PikivaApp` injects `UiPreferenceStore` and `SampleRepository` into a small
ChangeNotifier controller. Features never call the platform preferences plugin.
No global service locator or extra state package is needed for this scope.
Caller-injected controllers/routers remain caller-owned. Defaults are disposed
by the app. Async sample/startup generations reject stale completions after
clear, fallback or disposal. Repository output is immutable and local-only.

Only the non-sensitive welcome flag and system/light/dark choice persist through
SharedPreferencesAsync. Await writes before reporting success; failure preserves
the prior value and supports retry. Startup/onboarding also support an explicit
session-only fallback. Preferences are not suitable for critical session data.
Sample choices remain in memory, reset after restart, and never touch a library.

## Routing and presentation

The root `/` displays actual preference loading (no artificial delay). First
launch redirects to `/welcome`; completion enters `/home`. Incoming deep links
are retained in memory across startup/welcome and are never logged or displayed.
Stateful branches `/home`, `/creations`, `/sessions`, `/settings` retain tab
state and scroll positions. Nested sample/detail/style/licenses routes provide
parent back destinations. Unknown routes use generic recovery copy. The old
`/licenses` path redirects to `/settings/licenses`.

Navigation uses a bottom bar on phones, rail at 840 logical pixels and above,
and a wrapping two-column control layout for large text. Pages are scrollable
with bounded widths; cards use natural heights. No accessibility text scaling
is suppressed. Light/dark/system choices, semantic headings, padded targets,
localized copy and reduced-motion-aware state/theme transitions are shared.
System platform fonts and local imagery require no network fetches.

Sample loading has explicit empty/loading/error/retry/ready states. Photo results
are clearly labeled authored examples. Static style previews are UI art direction,
not parsed templates or playable/exportable video. Choose Photos explains that
selection is unavailable and offers the sample. Clear Sample confirms an in-memory
reset, never deletion of source images or bundled files.

## Configuration and privacy

Public build definitions select `development` or `production`; absent values
select production, and misspellings fail validation. Both environments keep
cloud text and telemetry disabled. No endpoints, credentials, or provider
selection exist. `AppConfig` is injected into the composition root for future
service composition; the UI does not need to consume it in Phase 1.

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
