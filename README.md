# Pikiva

Private photo curation and template-driven memories for Android and iOS.
**Current scope: Phase 1 — Premium UI shell.** Onboarding, four-tab navigation,
sample results/style previews and saved theme preferences work offline.
Real photo selection, analysis, editing and export remain future phases.

## Source of truth

- [Master PRD](docs/MASTER_PRD.md)
- [Setup checklist](docs/CODEX_SETUP_CHECKLIST.md)
- [Phase-control instructions](docs/CODEX_START_AND_PHASE_CONTROL.md)
- [Architecture](ARCHITECTURE.md)
- [Phase 0 plan and acceptance criteria](docs/PHASE_0_PLAN.md)
- [Dependency review](docs/DEPENDENCIES.md)

The owner's explicit one-phase instruction supersedes older combined Phase 0/1
examples in the original documents. Those documents are preserved unchanged.
Phase 1 was explicitly authorized. Do not start Phase 2 without a new instruction.

## Toolchain

Use Flutter **3.47.1 stable** with bundled Dart **3.13.1**. CI pins this version.
Android builds use **JDK 21**, AGP 9.1.0, and Gradle 9.3.1 from the generated
Flutter template. Java/Kotlin source targets remain 17. Flutter uses Android
Studio's bundled JDK here; the system Java 25 is not used for Android builds.
Use `flutter doctor -v` to confirm which JDK your installation selects.

Development targets: Android API 24+ and iOS 15+. The final supported OS range,
app name, and `com.webappypie.pikiva` identifier require owner confirmation before
Firebase registration or store distribution. iOS requires macOS and Xcode.

## Run

```sh
flutter doctor -v
flutter pub get --enforce-lockfile
flutter gen-l10n
flutter run --dart-define-from-file=config/development.json
```

A device/emulator must be connected. First launch shows the value/privacy welcome.
Home, Creations, Sessions and Settings use offline sample content, saved theme
choices, accessible layouts and honest unavailable-feature explanations. No media
permission is requested. Only onboarding/theme choices persist between launches.

`config/development.json` and `config/production.json` contain **public build
values only**. Omitted `APP_ENV` defaults to production. Invalid values fail
validation at startup. Native flavors are deferred until distinct native
service configurations or install IDs are actually needed. These files do not
change the native application identifier or enable cloud services.

## Check

```sh
dart format --output=none --set-exit-if-changed lib/app lib/core lib/features lib/main.dart test integration_test
flutter analyze --fatal-infos
flutter test --coverage
flutter build apk --debug --dart-define-from-file=config/development.json
flutter test integration_test/app_smoke_test.dart -d <device-id>
```

On a Mac:

```sh
flutter build ios --simulator --debug --no-codesign --dart-define-from-file=config/development.json
flutter test integration_test/app_smoke_test.dart -d <ios-simulator-id>
```

CI runs formatting, analysis, unit/widget tests, Android debug compilation, and
iOS simulator compilation. Native smoke tests run separately on a connected
device; they are not silently treated as covered by widget tests.

Generated localization, local SDK paths, coverage, emulator data, signing files,
private configuration, and build artifacts are ignored. Commit `pubspec.lock`.
Android release signing is deliberately unconfigured; no production credentials
are needed in Phase 1. Default Flutter launcher/launch assets remain until the
final branding/export preparation. This foundation is not a store-ready application.

## Privacy boundaries

- No runtime networking, telemetry, cloud SDKs, media permissions, or user photos.
- Core photo processing will stay on-device; originals must be preserved.
- Review Bin will be reversible staging before explicit OS-confirmed deletion.
- Templates will drive creations; no generative image/video service.
- Optional cloud text later uses a secure backend, never a secret in the app.
- Firebase later supports configuration/diagnostics, not photo storage.

## Phase 1 evidence

- [Plan and acceptance criteria](docs/PHASE_1_PLAN.md)
- [Completion report](docs/PHASE_1_REPORT.md)
- [Sample asset provenance and generation prompts](docs/SAMPLE_ASSETS.md)

## Next phase

**Phase 2 — Photo selection/session**, only after explicit authorization: system
picker, selected-photo preview, session creation, thumbnails, local persistence,
and permission/limited-access UX. No Phase 2 work is included here.
