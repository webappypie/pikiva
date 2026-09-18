import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pikiva/app/pikiva_app.dart';
import 'package:pikiva/app/routing/app_router.dart';
import 'package:pikiva/app/view/foundation_page.dart';
import 'package:pikiva/core/config/app_config.dart';

const _config = AppConfig(environment: AppEnvironment.production);

void main() {
  testWidgets(
    'starts without platform services and navigates back from licenses',
    (tester) async {
      await tester.pumpWidget(const PikivaApp(config: _config));
      await tester.pumpAndSettle();
      expect(find.byType(FoundationPage), findsOneWidget);
      expect(
        find.text('Photo tools are not available in this build.'),
        findsOneWidget,
      );
      await tester.ensureVisible(find.text('Open-source licenses'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open-source licenses'));
      await tester.pumpAndSettle();
      expect(find.byType(LicensePage), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(FoundationPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('unknown route has a private, working recovery path', (
    tester,
  ) async {
    final router = createAppRouter(
      initialLocation: '/private-file?token=secret',
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(PikivaApp(config: _config, router: router));
    await tester.pumpAndSettle();
    expect(find.text('This page is unavailable'), findsOneWidget);
    expect(find.textContaining('private-file'), findsNothing);
    expect(find.textContaining('secret'), findsNothing);
    await tester.tap(find.text('Return to start'));
    await tester.pumpAndSettle();
    expect(find.byType(FoundationPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('license deep link retains a parent back destination', (
    tester,
  ) async {
    final router = createAppRouter(initialLocation: AppRoutes.licenses);
    addTearDown(router.dispose);
    await tester.pumpWidget(PikivaApp(config: _config, router: router));
    await tester.pumpAndSettle();
    expect(find.byType(LicensePage), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(FoundationPage), findsOneWidget);
  });

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('$mode uses correct brightness and accessible controls', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();

      await tester.pumpWidget(PikivaApp(config: _config, themeMode: mode));
      await tester.pumpAndSettle();
      expect(
        Theme.of(tester.element(find.byType(FoundationPage))).brightness,
        mode == ThemeMode.light ? Brightness.light : Brightness.dark,
      );
      await tester.ensureVisible(find.text('Open-source licenses'));
      await tester.pumpAndSettle();
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      semantics.dispose();
    });
  }

  testWidgets('system theme responds to brightness changes', (tester) async {
    final platform = tester.binding.platformDispatcher;
    addTearDown(platform.clearPlatformBrightnessTestValue);
    platform.platformBrightnessTestValue = Brightness.light;
    await tester.pumpWidget(const PikivaApp(config: _config));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(FoundationPage))).brightness,
      Brightness.light,
    );
    platform.platformBrightnessTestValue = Brightness.dark;
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.byType(FoundationPage))).brightness,
      Brightness.dark,
    );
  });

  testWidgets('reduced motion disables theme transition', (tester) async {
    tester.binding.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(
      tester.binding.platformDispatcher.clearAccessibilityFeaturesTestValue,
    );
    await tester.pumpWidget(const PikivaApp(config: _config));
    await tester.pumpAndSettle();
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
    testWidgets(
      'foundation and recovery remain usable at $size with 200% text',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = size;
        tester.binding.platformDispatcher.textScaleFactorTestValue = 2;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(
          tester.binding.platformDispatcher.clearTextScaleFactorTestValue,
        );
        final router = createAppRouter();
        addTearDown(router.dispose);
        await tester.pumpWidget(PikivaApp(config: _config, router: router));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.ensureVisible(find.text('Open-source licenses'));
        await tester.pumpAndSettle();
        expect(find.text('Open-source licenses').hitTestable(), findsOneWidget);
        router.go('/unknown');
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.ensureVisible(find.text('Return to start'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Return to start'));
        await tester.pumpAndSettle();
        expect(find.byType(FoundationPage), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
