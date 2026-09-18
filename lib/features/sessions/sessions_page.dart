import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pikiva/app/routing/app_routes.dart';
import 'package:pikiva/app/shell_controller.dart';
import 'package:pikiva/core/design/app_copy.dart';
import 'package:pikiva/core/design/app_tokens.dart';
import 'package:pikiva/core/design/shell_widgets.dart';
import 'package:pikiva/features/samples/sample_widgets.dart';

class SessionsPage extends StatelessWidget {
  const SessionsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final copy = context.copy;
    final state = ShellScope.of(context);
    return PageContent(
      title: copy.sessionsTitle,
      subtitle: copy.sessionsBody,
      children: [
        SampleGate(
          child: SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Eyebrow(copy.sampleBadge),
                const SizedBox(height: AppSpacing.md),
                const SampleImage(),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  copy.sampleTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(copy.sampleDate),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    Chip(
                      label: Text('${state.photos.length} ${copy.photosLabel}'),
                    ),
                    Chip(
                      avatar: const Icon(Icons.check_circle_outline),
                      label: Text(copy.sampleReady),
                    ),
                    Chip(
                      label: Text('${copy.selectedLabel} · ${state.keptCount}'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                FilledButton(
                  onPressed: () => context.go(AppRoutes.sample),
                  child: Text(copy.viewCollection),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
