import 'package:flutter/material.dart';
import 'package:pikiva/core/design/app_copy.dart';
import 'package:pikiva/core/design/app_tokens.dart';
import 'package:pikiva/core/design/shell_widgets.dart';

enum CreationKind { profile, cover, collage, reels }

extension CreationCopy on CreationKind {
  String title(BuildContext context) => [
    context.copy.profile,
    context.copy.cover,
    context.copy.collage,
    context.copy.reels,
  ][index];
  String description(BuildContext context) => [
    context.copy.profileDescription,
    context.copy.coverDescription,
    context.copy.collageDescription,
    context.copy.reelsDescription,
  ][index];
  String style(BuildContext context) => [
    context.copy.styleMinimal,
    context.copy.styleEditorial,
    context.copy.styleTogether,
    context.copy.styleMotion,
  ][index];
  IconData get icon => [
    Icons.account_circle_outlined,
    Icons.panorama_outlined,
    Icons.grid_view_outlined,
    Icons.movie_outlined,
  ][index];
}

class CreationShortcut extends StatelessWidget {
  const CreationShortcut({required this.kind, required this.onTap, super.key});
  final CreationKind kind;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => SurfaceCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(kind.icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: AppSpacing.md),
        Text(
          kind.description(context),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        TextButton(onPressed: onTap, child: Text(kind.title(context))),
      ],
    ),
  );
}

/// Static art direction only. This is not a template parser or an export engine.
class CreationPreview extends StatelessWidget {
  const CreationPreview({required this.kind, super.key});
  final CreationKind kind;
  @override
  Widget build(BuildContext context) {
    final copy = context.copy;
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (kind == CreationKind.profile)
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280),
                child: const ClipOval(child: SampleImage(ratio: 1)),
              ),
            )
          else if (kind == CreationKind.collage)
            const Row(
              children: [
                Expanded(child: SampleImage(ratio: 0.8)),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: SampleImage(
                    asset: 'assets/samples/cove.png',
                    ratio: 0.8,
                  ),
                ),
              ],
            )
          else
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: kind == CreationKind.reels ? 320 : 900,
                ),
                child: SampleImage(
                  ratio: kind == CreationKind.reels ? 0.75 : 2,
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          Eyebrow(copy.previewOnly),
          const SizedBox(height: AppSpacing.sm),
          Text(
            copy.previewTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(kind.style(context)),
        ],
      ),
    );
  }
}
