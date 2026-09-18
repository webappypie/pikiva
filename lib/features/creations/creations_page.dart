import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pikiva/app/routing/app_routes.dart';
import 'package:pikiva/app/shell_controller.dart';
import 'package:pikiva/core/design/app_copy.dart';
import 'package:pikiva/core/design/app_tokens.dart';
import 'package:pikiva/core/design/shell_widgets.dart';
import 'package:pikiva/features/creations/creation_widgets.dart';
import 'package:pikiva/features/samples/sample_widgets.dart';

class CreationsPage extends StatefulWidget {
  const CreationsPage({super.key});
  @override
  State<CreationsPage> createState() => _CreationsPageState();
}

class _CreationsPageState extends State<CreationsPage> {
  CreationKind _kind = CreationKind.profile;
  @override
  Widget build(BuildContext context) {
    final copy = context.copy;
    final state = ShellScope.of(context);
    return PageContent(
      title: copy.creationsTitle,
      subtitle: copy.creationsBody,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final kind in CreationKind.values)
              ChoiceChip(
                label: Text(kind.title(context)),
                selected: _kind == kind,
                onSelected: (_) => setState(() => _kind = kind),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        if (state.sampleStatus == SampleStatus.empty)
          MessageState(
            icon: Icons.auto_awesome_mosaic_outlined,
            title: copy.creationsEmptyTitle,
            body: copy.creationsEmptyBody,
            action: copy.exploreSample,
            onAction: state.loadSample,
          )
        else
          SampleGate(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CreationPreview(kind: _kind),
                const SizedBox(height: AppSpacing.md),
                Text(copy.previewNote),
                const SizedBox(height: AppSpacing.md),
                FilledButton.tonal(
                  onPressed: () =>
                      context.go('${AppRoutes.creations}/${_kind.name}'),
                  child: Text(copy.previewStyle),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class CreationPreviewPage extends StatelessWidget {
  const CreationPreviewPage({required this.kind, super.key});
  final CreationKind kind;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(kind.title(context))),
    body: PageContent(
      title: kind.description(context),
      subtitle: context.copy.previewNote,
      children: [
        CreationPreview(kind: kind),
        const SizedBox(height: AppSpacing.lg),
        Text(context.copy.sampleAssetNote),
        const SizedBox(height: AppSpacing.lg),
        OutlinedButton(
          onPressed: () => showInformation(
            context,
            context.copy.createUnavailable,
            context.copy.createUnavailableBody,
          ),
          child: Text(context.copy.notAvailable),
        ),
      ],
    ),
  );
}
