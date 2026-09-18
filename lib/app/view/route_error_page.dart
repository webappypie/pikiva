import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pikiva/app/routing/app_router.dart';
import 'package:pikiva/core/design/app_tokens.dart';
import 'package:pikiva/core/design/reading_layout.dart';
import 'package:pikiva/l10n/generated/app_localizations.dart';

class RouteErrorPage extends StatelessWidget {
  const RouteErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(copy.appName)),
      body: ReadingLayout(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              child: Text(copy.routeErrorTitle, style: textTheme.headlineLarge),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(copy.routeErrorDescription, style: textTheme.bodyLarge),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: () => context.go(AppRoutes.start),
              child: Text(copy.returnToStart),
            ),
          ],
        ),
      ),
    );
  }
}
