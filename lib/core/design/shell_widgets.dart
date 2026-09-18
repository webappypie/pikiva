import 'package:flutter/material.dart';
import 'package:pikiva/core/design/app_copy.dart';
import 'package:pikiva/core/design/app_tokens.dart';

/// Bounded phone/tablet content, always scrollable at large accessibility sizes.
class PageContent extends StatelessWidget {
  const PageContent({
    required this.title,
    required this.subtitle,
    required this.children,
    this.eyebrow,
    super.key,
  });
  final String title;
  final String subtitle;
  final String? eyebrow;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: SingleChildScrollView(
      key: PageStorageKey(title),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1040),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (eyebrow != null) ...[
                Eyebrow(eyebrow!),
                const SizedBox(height: AppSpacing.md),
              ],
              Semantics(
                header: true,
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: AppSpacing.xl),
              ...children,
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    ),
  );
}

class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: Theme.of(context).textTheme.labelMedium?.copyWith(
      color: Theme.of(context).colorScheme.primary,
      letterSpacing: 1.2,
      fontWeight: FontWeight.w700,
    ),
  );
}

class SectionHeading extends StatelessWidget {
  const SectionHeading(this.title, {super.key});
  final String title;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppSpacing.xl, bottom: AppSpacing.md),
    child: Semantics(
      header: true,
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    ),
  );
}

class SampleImage extends StatelessWidget {
  const SampleImage({
    this.asset = 'assets/samples/coast.png',
    this.ratio = 1.5,
    this.label,
    super.key,
  });
  final String asset;
  final double ratio;
  final String? label;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(AppRadii.card),
    child: AspectRatio(
      aspectRatio: ratio,
      child: Image.asset(
        asset,
        fit: BoxFit.cover,
        width: double.infinity,
        cacheWidth: 1200,
        semanticLabel: label,
        excludeFromSemantics: label == null,
        errorBuilder: (context, error, stack) => ColoredBox(
          color: Theme.of(context).colorScheme.surfaceContainer,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(context.copy.previewImageUnavailable),
            ),
          ),
        ),
      ),
    ),
  );
}

class SurfaceCard extends StatelessWidget {
  const SurfaceCard({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      borderRadius: BorderRadius.circular(AppRadii.card),
    ),
    child: Padding(padding: const EdgeInsets.all(AppSpacing.lg), child: child),
  );
}

class MessageState extends StatelessWidget {
  const MessageState({
    required this.icon,
    required this.title,
    required this.body,
    this.action,
    this.onAction,
    super.key,
  });
  final IconData icon;
  final String title;
  final String body;
  final String? action;
  final VoidCallback? onAction;
  @override
  Widget build(BuildContext context) => SurfaceCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: AppIconSize.hero,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.sm),
        Text(body),
        if (action != null) ...[
          const SizedBox(height: AppSpacing.lg),
          FilledButton(onPressed: onAction, child: Text(action!)),
        ],
      ],
    ),
  );
}

/// Natural-height cards avoid clipped text from fixed grid aspect ratios.
class AdaptiveCards extends StatelessWidget {
  const AdaptiveCards({
    required this.children,
    this.minimumWidth = 280,
    super.key,
  });
  final List<Widget> children;
  final double minimumWidth;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final scale = MediaQuery.textScalerOf(context).scale(16) / 16;
      final columns =
          (constraints.maxWidth / (minimumWidth * scale.clamp(1, 1.5)))
              .floor()
              .clamp(1, 3);
      final width =
          (constraints.maxWidth - AppSpacing.md * (columns - 1)) / columns;
      return Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.md,
        children: children
            .map((child) => SizedBox(width: width, child: child))
            .toList(),
      );
    },
  );
}

/// Used only for state/selection transitions. Never loops or simulates progress.
class StateTransition extends StatelessWidget {
  const StateTransition({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
    duration: MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : AppMotion.standard,
    switchInCurve: AppMotion.curve,
    switchOutCurve: AppMotion.curve,
    child: child,
  );
}

Future<void> showInformation(BuildContext context, String title, String body) =>
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Text(body)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.copy.done),
          ),
        ],
      ),
    );
