import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pikiva/app/routing/app_routes.dart';
import 'package:pikiva/app/shell_controller.dart';
import 'package:pikiva/core/design/app_copy.dart';
import 'package:pikiva/core/design/app_tokens.dart';
import 'package:pikiva/core/design/shell_widgets.dart';

class SampleCollectionCard extends StatelessWidget {
  const SampleCollectionCard({super.key});
  @override
  Widget build(BuildContext context) {
    final state = ShellScope.of(context);
    final copy = context.copy;
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SampleImage(),
          const SizedBox(height: AppSpacing.lg),
          Eyebrow(copy.sampleBadge),
          const SizedBox(height: AppSpacing.sm),
          Text(copy.sampleTitle, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(copy.sampleSubtitle),
          const SizedBox(height: AppSpacing.md),
          if (state.sampleStatus == SampleStatus.loading)
            Semantics(liveRegion: true, child: Text(copy.sampleLoading))
          else if (state.sampleStatus == SampleStatus.failed) ...[
            Text(copy.sampleErrorBody),
            const SizedBox(height: AppSpacing.sm),
            FilledButton(onPressed: state.loadSample, child: Text(copy.retry)),
          ] else
            FilledButton.tonal(
              onPressed: () async {
                if (state.sampleStatus != SampleStatus.ready) {
                  await state.loadSample();
                }
                if (context.mounted &&
                    state.sampleStatus == SampleStatus.ready) {
                  context.go(AppRoutes.sample);
                }
              },
              child: Text(
                state.sampleStatus == SampleStatus.ready
                    ? copy.viewCollection
                    : copy.exploreSample,
              ),
            ),
        ],
      ),
    );
  }
}

Future<void> showChoosePhotos(BuildContext context) async {
  final explore = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(context.copy.chooseUnavailableTitle),
      content: SingleChildScrollView(
        child: Text(context.copy.chooseUnavailableBody),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(context.copy.notNow),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(context.copy.exploreSample),
        ),
      ],
    ),
  );
  if (explore == true && context.mounted) {
    final state = ShellScope.of(context);
    context.go(AppRoutes.sample);
    if (state.sampleStatus != SampleStatus.ready) {
      await state.loadSample();
    }
  }
}

class SampleGate extends StatelessWidget {
  const SampleGate({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final state = ShellScope.of(context);
    final copy = context.copy;
    return StateTransition(
      child: switch (state.sampleStatus) {
        SampleStatus.ready => child,
        SampleStatus.loading => SurfaceCard(
          key: const ValueKey('loading'),
          child: Semantics(liveRegion: true, child: Text(copy.sampleLoading)),
        ),
        SampleStatus.failed => MessageState(
          key: const ValueKey('error'),
          icon: Icons.refresh,
          title: copy.sampleErrorTitle,
          body: copy.sampleErrorBody,
          action: copy.retry,
          onAction: state.loadSample,
        ),
        SampleStatus.empty => MessageState(
          key: const ValueKey('empty'),
          icon: Icons.photo_library_outlined,
          title: copy.sessionsEmptyTitle,
          body: copy.sessionsEmptyBody,
          action: copy.exploreSample,
          onAction: state.loadSample,
        ),
      },
    );
  }
}
