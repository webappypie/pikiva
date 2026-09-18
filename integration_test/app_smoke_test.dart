import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pikiva/features/home/home_page.dart';
import 'package:pikiva/core/storage/ui_preferences.dart';
import 'package:pikiva/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('native offline onboarding, sample, settings and licenses', (
    tester,
  ) async {
    app.main();
    await tester.pumpAndSettle();
    Future<void> tap(String label) async {
      final finder = find.text(label).last;
      await tester.ensureVisible(finder);
      await tester.pumpAndSettle();
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }

    if (find.text('Continue').evaluate().isNotEmpty) {
      await tap('Continue');
      await tap('Get started');
    }
    expect(find.byType(HomePage), findsOneWidget);
    await tap('Choose Photos');
    await tap('Explore a sample');
    expect(find.text('The moments that stand out.'), findsOneWidget);
    await tap('Review');
    await tap('View sample photo');
    await tap('Keep in sample set');
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tap('Settings');
    await tap('Light');
    await tap('Dark');
    final saved = await LocalUiPreferenceStore().read();
    expect(saved.welcomed, isTrue);
    expect(saved.theme, ThemeMode.dark);
    await tap('Open-source licenses');
    expect(find.byType(LicensePage), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Make it yours.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
