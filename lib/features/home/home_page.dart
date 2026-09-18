import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pikiva/app/routing/app_routes.dart';
import 'package:pikiva/app/shell_controller.dart';
import 'package:pikiva/core/design/app_copy.dart';
import 'package:pikiva/core/design/app_tokens.dart';
import 'package:pikiva/core/design/shell_widgets.dart';
import 'package:pikiva/features/creations/creation_widgets.dart';
import 'package:pikiva/features/samples/sample_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final copy = context.copy;
    final state = ShellScope.of(context);
    return PageContent(
      eyebrow: copy.homeEyebrow,
      title: copy.homeTitle,
      subtitle: copy.homeBody,
      children: [
        const SampleImage(ratio: 1.8),
        const SizedBox(height: AppSpacing.lg),
        FilledButton.icon(
          onPressed: () => showChoosePhotos(context),
          icon: const Icon(Icons.add_photo_alternate_outlined),
          label: Text(copy.choosePhotos),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(copy.privacyShort),
        SectionHeading(
          state.sampleStatus == SampleStatus.ready
              ? copy.continueSession
              : copy.exploreSample,
        ),
        const SampleCollectionCard(),
        SectionHeading(copy.quickCreate),
        Text(copy.quickCreateBody),
        const SizedBox(height: AppSpacing.md),
        AdaptiveCards(
          children: [
            for (final kind in [
              CreationKind.profile,
              CreationKind.collage,
              CreationKind.reels,
            ])
              CreationShortcut(
                kind: kind,
                onTap: () => context.go('${AppRoutes.creations}/${kind.name}'),
              ),
          ],
        ),
        if (state.sampleStatus == SampleStatus.ready) ...[
          SectionHeading(copy.recentCreations),
          CreationShortcut(
            kind: CreationKind.cover,
            onTap: () => context.go('${AppRoutes.creations}/cover'),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(copy.sampleRecentNote),
        ],
      ],
    );
  }
}
