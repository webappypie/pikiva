import 'dart:convert';

import 'package:flutter/services.dart';

enum SampleGroup { best, review }

final class SamplePhoto {
  const SamplePhoto({
    required this.id,
    required this.asset,
    required this.group,
  });
  final String id;
  final String asset;
  final SampleGroup group;
}

abstract interface class SampleRepository {
  Future<List<SamplePhoto>> load();
}

/// Loads authored UI fixtures. Does not inspect or score any photo.
final class BundledSampleRepository implements SampleRepository {
  BundledSampleRepository({AssetBundle? bundle})
    : _bundle = bundle ?? rootBundle;
  final AssetBundle _bundle;

  @override
  Future<List<SamplePhoto>> load() async {
    final decoded = jsonDecode(
      await _bundle.loadString('assets/samples/collection.json'),
    );
    if (decoded is! Map<String, dynamic> ||
        decoded['version'] != 1 ||
        decoded['photos'] is! List) {
      throw const FormatException('Unsupported sample collection.');
    }
    final photos = <SamplePhoto>[];
    final ids = <String>{};
    for (final row in decoded['photos'] as List<dynamic>) {
      if (row is! Map<String, dynamic> ||
          row['id'] is! String ||
          !const [
            'assets/samples/coast.png',
            'assets/samples/cove.png',
          ].contains(row['asset']) ||
          !const ['best', 'review'].contains(row['group']) ||
          !ids.add(row['id'] as String)) {
        throw const FormatException('Invalid sample photo.');
      }
      photos.add(
        SamplePhoto(
          id: row['id'] as String,
          asset: row['asset'] as String,
          group: row['group'] == 'best' ? SampleGroup.best : SampleGroup.review,
        ),
      );
    }
    return List.unmodifiable(photos);
  }
}
