import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pikiva/app/pikiva_app.dart';
import 'package:pikiva/app/routing/app_router.dart';
import 'package:pikiva/app/shell_controller.dart';
import 'package:pikiva/core/config/app_config.dart';
import 'package:pikiva/core/storage/ui_preferences.dart';

import '../support/fakes.dart';

class PendingPreferences extends MemoryPreferences {
  final result = Completer<UiPreferences>();
  @override
  Future<UiPreferences> read() => result.future;
}

void main() {
  testWidgets('real pending splash retains a cold-start deep link', (
    tester,
  ) async {
    final store = PendingPreferences();
    final controller = ShellController(
      preferences: store,
      samples: FakeSamples(),
    );
    final router = createAppRouter(
      controller: controller,
      initialLocation: AppRoutes.licenses,
    );
    addTearDown(router.dispose);
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      PikivaApp(
        config: const AppConfig(environment: AppEnvironment.production),
        controller: controller,
        router: router,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Opening your space…'), findsOneWidget);
    store.result.complete(const UiPreferences(welcomed: true));
    await tester.pumpAndSettle();
    expect(find.byType(LicensePage), findsOneWidget);
  });
  testWidgets('startup failure offers working session-only recovery', (
    tester,
  ) async {
    final controller = ShellController(
      preferences: MemoryPreferences()..failRead = true,
      samples: FakeSamples(),
    );
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      PikivaApp(
        config: const AppConfig(environment: AppEnvironment.production),
        controller: controller,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('We couldn’t load your preferences'), findsOneWidget);
    await tester.tap(find.text('Continue without saving'));
    await tester.pumpAndSettle();
    expect(find.text('Less sorting.\nMore remembering.'), findsOneWidget);
  });
  testWidgets('welcome remains accessible on a small screen at 200% text', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    tester.binding.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(
      tester.binding.platformDispatcher.clearTextScaleFactorTestValue,
    );
    final controller = ShellController(
      preferences: MemoryPreferences(value: const UiPreferences()),
      samples: FakeSamples(),
    );
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      PikivaApp(
        config: const AppConfig(environment: AppEnvironment.production),
        controller: controller,
      ),
    );
    await tester.pumpAndSettle();
    for (final label in ['Continue', 'Get started']) {
      await tester.ensureVisible(find.text(label));
      await tester.pumpAndSettle();
      expect(find.text(label).hitTestable(), findsOneWidget);
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });
}
