# Phase 0 execution plan and acceptance criteria

Recorded 2026-09-18. Source: MASTER_PRD.md sections 33, 36 (Phase 0), 37, 41, 46,
and the owner's explicit Phase 0-only instruction.

## Initial inspection

The complete initial folder contained only MASTER_PRD.md,
CODEX_SETUP_CHECKLIST.md, and CODEX_START_AND_PHASE_CONTROL.md under docs/.
All three were read. No existing Flutter code, assets, dependencies, configs,
partial work, AGENTS.md, or Git repository was present. Git status/diff failed
because no repository existed. The supplied GitHub remote returned no refs.
Original documents were committed unchanged as a baseline before scaffolding.

Installed: Flutter 3.47.1 stable, Dart 3.13.1, Android Studio JDK 21.0.8,
Android SDK/platforms through 37, build-tools 36.1.0, Git 2.53.0. Shell Java is
25.0.2; Flutter correctly uses Android Studio's JDK 21. Android licenses accepted.
No Android device or configured AVD initially; API 36 images are installed.
Windows desktop lacks Visual Studio, which is irrelevant to Android/iOS targets.
No Mac/Xcode is available locally. Windows sandbox startup failed; authorized
commands use the working reviewed execution path.

## Deliverables and acceptance

| Required deliverable | Concrete acceptance check |
| --- | --- |
| Flutter project | Android/iOS hosts, runnable offline foundation, Android debug build; iOS CI compile gate |
| Configuration/flavors if needed | Immutable injectable config; documented dev/prod defines, production default, invalid-value test; no native flavors needed yet |
| Routing | Root plus licenses route, parent back behavior, unknown route recovery without private URI disclosure |
| Theme tokens | Central spacing/radii/type/colors/elevation/motion/easing/icons; tested light/dark/system and reduced motion |
| Core architecture | Composition root, core/config/design, documented feature/service boundaries; no direct platform calls in presentation |
| Test scaffolding | Useful config/widget tests and native integration smoke test; formatting and clean analysis |
| CI baseline | Locked dependency install, format/analyze/test, Android debug and macOS unsigned simulator compile jobs |
| README / ARCHITECTURE | Reproducible setup/check commands, privacy and future boundary map, explicit phase stop |
| Cross-cutting gates | Responsive and accessible foundation; no secrets or build artifacts staged; final diff review; practical native smoke attempt |

## Required dependencies

Flutter SDK and its localization/test/integration-test libraries; go_router for
maintained declarative navigation; intl for generated localization;
flutter_lints for static checks. Full rationale/license/platform review is in
DEPENDENCIES.md. No database, state framework, cloud, media, video, or AI package.

## Risks and platform considerations

- Package/bundle ID, branding, and OS floors are provisional until confirmed.
- Windows cannot prove iOS compilation or device behavior; macOS CI is required.
- Android emulator availability/graphics may limit local native smoke testing.
- Existing SDK has duplicate API 37 directory metadata; avoid changing global SDK
  files. Resolve only if it blocks this build.
- No production signing or store assets are required; release stays unsigned.
- SDK-resolved transitive dependencies are pinned; do not force upgrades past
  Flutter's constraints without compatibility testing.
- Video codec, FFmpeg, binary-size, music/font redistribution reviews are deferred
  to the phases that choose those dependencies, not waived.

## Required checks

`flutter doctor -v`, dependency/license/platform inspection, formatting,
`flutter analyze --fatal-infos`, `flutter test --coverage`, debug APK build,
native cold-launch/navigation test where possible, light/dark and 200% text
widget checks, Git diff/whitespace/secret-artifact review. Record actual outcomes
in PHASE_0_REPORT.md without treating unrun checks as passed.

## Scope stop

No splash/onboarding/home/tabs/mock results, import, DB, analysis, templates,
reels, Firebase, or cloud text implementation. The next authorized work would
be **Phase 1 — Premium UI shell**, only after a separate owner prompt.
