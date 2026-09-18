import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pikiva/app/pikiva_app.dart';
import 'package:pikiva/app/routing/app_router.dart';
import 'package:pikiva/app/shell_controller.dart';
import 'package:pikiva/core/config/app_config.dart';
import 'package:pikiva/core/storage/ui_preferences.dart';
import 'package:pikiva/features/home/home_page.dart';
import 'package:pikiva/features/onboarding/welcome_page.dart';

import '../support/fakes.dart';

const config = AppConfig(environment: AppEnvironment.production);
Future<(ShellController, GoRouter)> mount(
  WidgetTester tester, {
  MemoryPreferences? store,
  String? route,
  ThemeMode? theme,
  bool sample = false,
}) async {
  final controller = ShellController(
    preferences: store ?? MemoryPreferences(),
    samples: FakeSamples(),
  );
  await controller.initialize();
  if (sample) await controller.loadSample();
  final router = createAppRouter(
    controller: controller,
    initialLocation: route,
  );
  addTearDown(router.dispose);
  addTearDown(controller.dispose);
  await tester.pumpWidget(
    PikivaApp(
      config: config,
      controller: controller,
      router: router,
      themeMode: theme,
    ),
  );
  await tester.pumpAndSettle();
  return (controller, router);
}

Future<void> tapText(WidgetTester tester, String label) async {
  final finder = find.text(label).last;
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('first launch completes value and privacy steps', (tester) async {
    final store = MemoryPreferences(value: const UiPreferences());
    await mount(tester, store: store);
    expect(find.byType(WelcomePage), findsOneWidget);
    await tapText(tester, 'Continue');
    expect(find.text('Your memories.\nYour say.'), findsOneWidget);
    await tapText(tester, 'Get started');
    expect(find.byType(HomePage), findsOneWidget);
    expect(store.value.welcomed, isTrue);
  });
  testWidgets('onboarding save failure has session-only recovery', (
    tester,
  ) async {
    final store = MemoryPreferences(value: const UiPreferences())
      ..failSave = true;
    await mount(tester, store: store);
    await tapText(tester, 'Continue');
    await tapText(tester, 'Get started');
    expect(find.textContaining('couldn’t be saved'), findsOneWidget);
    await tapText(tester, 'Continue without saving');
    expect(find.byType(HomePage), findsOneWidget);
    expect(store.value.welcomed, isFalse);
  });
  testWidgets('four tabs, empty states, honest chooser and licenses back', (
    tester,
  ) async {
    await mount(tester);
    await tapText(tester, 'Choose Photos');
    expect(find.text('Your next memory starts here'), findsOneWidget);
    await tapText(tester, 'Not now');
    await tapText(tester, 'Sessions');
    expect(find.text('Your first collection awaits'), findsOneWidget);
    await tapText(tester, 'Creations');
    expect(find.text('Made by you, kept here'), findsOneWidget);
    await tapText(tester, 'Settings');
    await tapText(tester, 'Dark');
    expect(
      Theme.of(tester.element(find.text('Make it yours.'))).brightness,
      Brightness.dark,
    );
    await tapText(tester, 'Open-source licenses');
    expect(find.byType(LicensePage), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Make it yours.'), findsOneWidget);
  });
  testWidgets('sample results filter, detail selection, styles and clear', (
    tester,
  ) async {
    final (controller, router) = await mount(
      tester,
      sample: true,
      route: AppRoutes.sample,
    );
    await tapText(tester, 'Good');
    expect(find.text('Nothing in this view'), findsOneWidget);
    await tapText(tester, 'Review');
    await tapText(tester, 'View sample photo');
    await tapText(tester, 'Keep in sample set');
    expect(controller.keptCount, 2);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tapText(tester, 'Best Set');
    expect(find.text('Along the coastal path'), findsOneWidget);
    expect(find.text('The quiet cove'), findsOneWidget);
    router.go(AppRoutes.creations);
    await tester.pumpAndSettle();
    for (final label in ['Profile', 'Cover', 'Collage', 'Reels']) {
      await tapText(tester, label);
      expect(find.text('STYLE PREVIEW'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
    router.go(AppRoutes.settings);
    await tester.pumpAndSettle();
    await tapText(tester, 'Clear sample from this visit');
    await tapText(tester, 'Cancel');
    expect(controller.sampleStatus, SampleStatus.ready);
    await tapText(tester, 'Clear sample from this visit');
    await tapText(tester, 'Clear sample from this visit');
    expect(controller.sampleStatus, SampleStatus.empty);
  });
  testWidgets('unknown routes do not disclose URI and recover', (tester) async {
    await mount(tester, route: '/private-file?token=secret');
    expect(find.text('This page is unavailable'), findsOneWidget);
    expect(find.textContaining('secret'), findsNothing);
    await tapText(tester, 'Return to start');
    expect(find.byType(HomePage), findsOneWidget);
  });
  testWidgets('license deep link has Settings as back destination', (
    tester,
  ) async {
    await mount(tester, route: AppRoutes.licenses);
    expect(find.byType(LicensePage), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Make it yours.'), findsOneWidget);
  });
  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('$mode accessible navigation and filters', (tester) async {
      final semantics = tester.ensureSemantics();

      final (_, router) = await mount(tester, theme: mode, sample: true);
      for (final route in [
        AppRoutes.start,
        AppRoutes.sample,
        AppRoutes.settings,
      ]) {
        router.go(route);
        await tester.pumpAndSettle();
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));
      }
      semantics.dispose();
    });
  }
  testWidgets('system brightness and reduced motion are respected', (
    tester,
  ) async {
    final platform = tester.binding.platformDispatcher;
    platform.platformBrightnessTestValue = Brightness.light;
    platform.accessibilityFeaturesTestValue = const FakeAccessibilityFeatures(
      disableAnimations: true,
    );
    addTearDown(platform.clearPlatformBrightnessTestValue);
    addTearDown(platform.clearAccessibilityFeaturesTestValue);
    await mount(tester);
    platform.platformBrightnessTestValue = Brightness.dark;
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(HomePage))).brightness,
      Brightness.dark,
    );
    expect(
      tester
          .widget<MaterialApp>(find.byType(MaterialApp))
          .themeAnimationDuration,
      Duration.zero,
    );
  });
  for (final size in [
    const Size(320, 568),
    const Size(844, 390),
    const Size(1024, 1366),
  ]) {
    testWidgets('all screens at $size with 200% text', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      tester.binding.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(
        tester.binding.platformDispatcher.clearTextScaleFactorTestValue,
      );
      final (_, router) = await mount(tester, sample: true);
      for (final route in [
        AppRoutes.start,
        AppRoutes.creations,
        AppRoutes.sessions,
        AppRoutes.settings,
        AppRoutes.sample,
        '${AppRoutes.sample}/coast',
        '/creations/collage',
        '/unknown',
      ]) {
        router.go(route);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: route);
      }
      await tapText(tester, 'Return to start');
      expect(find.byType(HomePage), findsOneWidget);
    });
  }
}
