import 'package:flutter/material.dart';
import 'package:pikiva/core/design/app_tokens.dart';

/// Scrollable, bounded content that preserves system text scaling and insets.
class ReadingLayout extends StatelessWidget {
  const ReadingLayout({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppLayout.readingWidth),
          child: SizedBox(width: double.infinity, child: child),
        ),
      ),
    ),
  );
}
