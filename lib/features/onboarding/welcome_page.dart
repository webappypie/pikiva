import 'package:flutter/material.dart';
import 'package:pikiva/app/shell_controller.dart';
import 'package:pikiva/core/design/app_copy.dart';
import 'package:pikiva/core/design/app_tokens.dart';
import 'package:pikiva/core/design/shell_widgets.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _privacy = false;
  @override
  Widget build(BuildContext context) {
    final controller = ShellScope.of(context);
    final copy = context.copy;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    copy.appName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const SampleImage(ratio: 1.5),
                  const SizedBox(height: AppSpacing.lg),
                  Eyebrow(_privacy ? copy.welcomeStepTwo : copy.welcomeStepOne),
                  const SizedBox(height: AppSpacing.md),
                  StateTransition(
                    child: Column(
                      key: ValueKey(_privacy),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Semantics(
                          header: true,
                          child: Text(
                            _privacy ? copy.privacyTitle : copy.welcomeTitle,
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          _privacy ? copy.privacyBody : copy.welcomeBody,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(copy.welcomeNote),
                  if (controller.preferenceFailed) ...[
                    const SizedBox(height: AppSpacing.md),
                    Text(copy.saveError),
                    TextButton(
                      onPressed: () {
                        controller.useSessionOnly();
                        controller.finishWelcome();
                      },
                      child: Text(copy.sessionOnly),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: controller.saving
                          ? null
                          : () {
                              if (_privacy) {
                                controller.finishWelcome();
                              } else {
                                setState(() => _privacy = true);
                              }
                            },
                      child: Text(
                        controller.saving
                            ? copy.saving
                            : _privacy
                            ? copy.getStarted
                            : copy.continueLabel,
                      ),
                    ),
                  ),
                  if (_privacy)
                    TextButton(
                      onPressed: controller.saving
                          ? null
                          : () => setState(() => _privacy = false),
                      child: Text(copy.backLabel),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StartupPage extends StatelessWidget {
  const StartupPage({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = ShellScope.of(context);
    final copy = context.copy;
    return Scaffold(
      body: PageContent(
        title: copy.appName,
        subtitle: copy.localFirst,
        children: [
          if (controller.startupFailed) ...[
            MessageState(
              icon: Icons.settings_backup_restore,
              title: copy.startupErrorTitle,
              body: copy.startupErrorBody,
              action: copy.retry,
              onAction: controller.initialize,
            ),
            TextButton(
              onPressed: controller.useSessionOnly,
              child: Text(copy.sessionOnly),
            ),
          ] else
            Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.photo_library_outlined,
                    size: AppIconSize.hero,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Semantics(
                    liveRegion: true,
                    child: Text(copy.loadingPreferences),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
