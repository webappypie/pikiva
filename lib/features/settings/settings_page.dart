import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pikiva/app/routing/app_routes.dart';
import 'package:pikiva/app/shell_controller.dart';
import 'package:pikiva/core/design/app_copy.dart';
import 'package:pikiva/core/design/shell_widgets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ShellScope.of(context);
    final copy = context.copy;
    return PageContent(
      title: copy.settingsTitle,
      subtitle: copy.settingsBody,
      children: [
        SectionHeading(copy.appearance),
        SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(copy.themeDescription),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final mode in ThemeMode.values)
                    ChoiceChip(
                      label: Text(switch (mode) {
                        ThemeMode.system => copy.systemTheme,
                        ThemeMode.light => copy.lightTheme,
                        ThemeMode.dark => copy.darkTheme,
                      }),
                      selected: controller.theme == mode,
                      onSelected: controller.saving
                          ? null
                          : (_) => controller.changeTheme(mode),
                    ),
                ],
              ),
              if (controller.saving) Text(copy.saving),
              if (controller.preferenceFailed)
                Semantics(liveRegion: true, child: Text(copy.saveError)),
              if (controller.sessionOnly) Text(copy.sessionOnlyNote),
            ],
          ),
        ),
        SectionHeading(copy.privacy),
        SurfaceCard(child: Text(copy.privacyDetails)),
        SectionHeading(copy.processing),
        SurfaceCard(child: Text(copy.processingDetails)),
        SectionHeading(copy.exportQuality),
        SurfaceCard(child: Text(copy.exportDetails)),
        SectionHeading(copy.cloudText),
        SurfaceCard(child: Text(copy.cloudTextDetails)),
        SectionHeading(copy.sampleStorage),
        SurfaceCard(
          child: controller.sampleStatus == SampleStatus.empty
              ? Text(copy.noSample)
              : OutlinedButton.icon(
                  onPressed: () async {
                    final clear = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: Text(copy.clearSampleTitle),
                        content: Text(copy.clearSampleBody),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(dialogContext, false),
                            child: Text(copy.cancel),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(dialogContext, true),
                            child: Text(copy.clearSample),
                          ),
                        ],
                      ),
                    );
                    if (clear == true && context.mounted) {
                      controller.clearSample();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(copy.sampleCleared)),
                      );
                    }
                  },
                  icon: const Icon(Icons.clear_all_rounded),
                  label: Text(copy.clearSample),
                ),
        ),
        SectionHeading(copy.help),
        SurfaceCard(child: Text(copy.helpDetails)),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: () => context.push(AppRoutes.licenses),
            child: Text(copy.licensesLabel),
          ),
        ),
      ],
    );
  }
}
