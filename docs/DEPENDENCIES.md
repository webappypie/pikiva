# Phase 0 dependency review

Reviewed 2026-09-18 using publisher documentation, actual resolved package
sources/licenses, and the installed Flutter stable toolchain. Versions are
locked in pubspec.lock. No dependency was inherited from an existing app.

| Direct dependency | Resolved | Purpose | License / platforms |
| --- | --- | --- | --- |
| flutter | SDK 3.47.1 | Widgets, themes, rendering | BSD-3-Clause; Android/iOS |
| flutter_localizations | SDK | Built-in widget translations, ARB generation | Flutter SDK license; Android/iOS |
| go_router | 18.0.1 | Declarative routes, deep links, back stack | BSD-3-Clause; Android/iOS; Flutter publisher |
| intl | 0.20.3 | Generated localization support | BSD-3-Clause; pure Dart |
| flutter_test | SDK, dev only | Unit/widget/accessibility tests | Flutter SDK license |
| integration_test | SDK, dev only | Native smoke test | Flutter SDK license; Android/iOS |
| flutter_lints | 6.0.0, dev only | Maintained Flutter lint baseline | BSD-3-Clause; tooling only |

The Flutter team's go_router changelog shows version 18 supports Flutter 3.44+
and Dart 3.12+ and uses material_ui/cupertino_ui. The installed Flutter 3.47.1
meets this floor. Flutter's empty template already chooses flutter_lints 6.
All hosted transitive packages have LICENSE files; the inspected licenses are
BSD-style or Apache-2.0. Runtime licenses are bundled by Flutter and available
through the app's Open-source licenses route. Preserve all required notices.
The lockfile includes test-only packages which do not ship as production app
code. No media codec binaries, cloud SDKs, downloaded fonts, or music assets
were added. Generated Flutter launcher assets are temporary SDK defaults.

Primary sources:
- https://pub.dev/packages/go_router
- https://pub.dev/packages/go_router/license
- https://pub.dev/packages/go_router/changelog
- https://pub.dev/packages/flutter_lints/license
- https://pub.dev/packages/intl/license
- https://github.com/flutter/flutter/blob/3.47.1/LICENSE
- https://docs.flutter.dev/reference/supported-platforms

No full application state package is necessary for the current scope. No
FFmpeg, image-analysis, gallery, Firebase, or AI dependency is selected. At the
actual integration phase, repeat maintenance, Android/iOS, license, codec,
binary-size, and store compatibility reviews against concrete requirements.
