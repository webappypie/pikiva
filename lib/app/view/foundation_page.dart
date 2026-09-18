import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pikiva/app/routing/app_router.dart';
import 'package:pikiva/core/design/app_tokens.dart';
import 'package:pikiva/core/design/reading_layout.dart';
import 'package:pikiva/l10n/generated/app_localizations.dart';

/// Minimal runnable foundation. Product navigation and screens start in Phase 1.
class FoundationPage extends StatelessWidget {
  const FoundationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final copy = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(copy.appName)),
      body: ReadingLayout(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.xl),
            ExcludeSemantics(
              child: Icon(
                Icons.photo_library_outlined,
                size: AppIconSize.hero,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Semantics(
              header: true,
              child: Text(
                copy.foundationTitle,
                style: theme.textTheme.headlineLarge,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(copy.foundationDescription, style: theme.textTheme.bodyLarge),
            const SizedBox(height: AppSpacing.xl),
            Text(
              copy.foundationAvailability,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(AppRadii.card),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  copy.privacyNote,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextButton(
              onPressed: () => context.go(AppRoutes.licenses),
              child: Text(copy.licensesLabel),
            ),
          ],
        ),
      ),
    );
  }
}
