import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pikiva/app/view/foundation_page.dart';
import 'package:pikiva/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('cold launch and local license navigation', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    expect(find.byType(FoundationPage), findsOneWidget);
    await tester.ensureVisible(find.text('Open-source licenses'));
    await tester.tap(find.text('Open-source licenses'));
    await tester.pumpAndSettle();
    expect(find.byType(LicensePage), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(FoundationPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
