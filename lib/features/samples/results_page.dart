import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pikiva/app/routing/app_routes.dart';
import 'package:pikiva/app/shell_controller.dart';
import 'package:pikiva/core/design/app_copy.dart';
import 'package:pikiva/core/design/app_tokens.dart';
import 'package:pikiva/core/design/shell_widgets.dart';
import 'package:pikiva/features/samples/sample_repository.dart';
import 'package:pikiva/features/samples/sample_widgets.dart';

enum ResultFilter { best, set, good, review, remove }

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});
  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  ResultFilter _filter = ResultFilter.best;
  @override
  Widget build(BuildContext context) {
    final state = ShellScope.of(context);
    final copy = context.copy;
    final labels = [
      copy.bestPicks,
      copy.bestSet,
      copy.goodLabel,
      copy.reviewLabel,
      copy.suggestedRemove,
    ];
    final photos = state.photos
        .where(
          (photo) => switch (_filter) {
            ResultFilter.best => photo.group == SampleGroup.best,
            ResultFilter.set => state.isKept(photo.id),
            ResultFilter.review => photo.group == SampleGroup.review,
            _ => false,
          },
        )
        .toList();
    return Scaffold(
      appBar: AppBar(title: Text(copy.sampleTitle)),
      body: PageContent(
        eyebrow: copy.sampleBadge,
        title: copy.resultsTitle,
        subtitle: copy.sampleDisclosure,
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final filter in ResultFilter.values)
                ChoiceChip(
                  label: Text(labels[filter.index]),
                  selected: _filter == filter,
                  onSelected: (_) => setState(() => _filter = filter),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SampleGate(
            child: photos.isEmpty
                ? MessageState(
                    icon: Icons.filter_alt_off_outlined,
                    title: copy.filterEmptyTitle,
                    body: copy.filterEmptyBody,
                  )
                : AdaptiveCards(
                    children: [
                      for (final photo in photos)
                        SurfaceCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SampleImage(asset: photo.asset),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                photo.id == 'coast'
                                    ? copy.coastTitle
                                    : copy.coveTitle,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Chip(
                                avatar: Icon(
                                  photo.group == SampleGroup.best
                                      ? Icons.star_outline
                                      : Icons.visibility_outlined,
                                ),
                                label: Text(
                                  photo.group == SampleGroup.best
                                      ? copy.bestLabel
                                      : copy.reviewLabel,
                                ),
                              ),
                              Text(
                                photo.id == 'coast'
                                    ? copy.coastReason
                                    : copy.coveReason,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              TextButton(
                                onPressed: () => context.go(
                                  '${AppRoutes.sample}/${photo.id}',
                                ),
                                child: Text(copy.viewPhoto),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(copy.sampleSelectionNote),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(
            onPressed: () => context.go(AppRoutes.creations),
            child: Text(copy.makeCreation),
          ),
        ],
      ),
    );
  }
}

class SamplePhotoPage extends StatelessWidget {
  const SamplePhotoPage({required this.id, super.key});
  final String id;
  @override
  Widget build(BuildContext context) {
    final state = ShellScope.of(context);
    final copy = context.copy;
    final candidates = state.photos.where((p) => p.id == id);
    final photo = candidates.isEmpty ? null : candidates.first;
    return Scaffold(
      appBar: AppBar(title: Text(copy.viewPhoto)),
      body: PageContent(
        eyebrow: copy.sampleBadge,
        title: id == 'coast' ? copy.coastTitle : copy.coveTitle,
        subtitle: copy.sampleDisclosure,
        children: [
          SampleGate(
            child: photo == null
                ? MessageState(
                    icon: Icons.photo_outlined,
                    title: copy.routeErrorTitle,
                    body: copy.routeErrorDescription,
                    action: copy.viewCollection,
                    onAction: () => context.go(AppRoutes.sample),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SampleImage(asset: photo.asset, ratio: 1),
                      SectionHeading(copy.exampleReason),
                      Text(
                        photo.id == 'coast'
                            ? copy.coastReason
                            : copy.coveReason,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      FilledButton.icon(
                        onPressed: () {
                          state.toggleKeep(photo.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(copy.sampleChoiceSaved)),
                          );
                        },
                        icon: Icon(
                          state.isKept(id)
                              ? Icons.check_circle
                              : Icons.add_circle_outline,
                        ),
                        label: Text(
                          state.isKept(id) ? copy.keptPhoto : copy.keepPhoto,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(copy.sampleSelectionNote),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
