import 'package:flutter/material.dart';
import 'package:pikiva/core/storage/ui_preferences.dart';
import 'package:pikiva/features/samples/sample_repository.dart';

class MemoryPreferences implements UiPreferenceStore {
  MemoryPreferences({this.value = const UiPreferences(welcomed: true)});
  UiPreferences value;
  bool failRead = false;
  bool failSave = false;
  @override
  Future<UiPreferences> read() async {
    if (failRead) throw StateError('read failed');
    return value;
  }

  @override
  Future<void> saveWelcome() async {
    if (failSave) throw StateError('write failed');
    value = UiPreferences(welcomed: true, theme: value.theme);
  }

  @override
  Future<void> saveTheme(ThemeMode theme) async {
    if (failSave) throw StateError('write failed');
    value = UiPreferences(welcomed: value.welcomed, theme: theme);
  }
}

class FakeSamples implements SampleRepository {
  bool fail = false;
  List<SamplePhoto> photos = const [
    SamplePhoto(
      id: 'coast',
      asset: 'assets/samples/coast.png',
      group: SampleGroup.best,
    ),
    SamplePhoto(
      id: 'cove',
      asset: 'assets/samples/cove.png',
      group: SampleGroup.review,
    ),
  ];
  @override
  Future<List<SamplePhoto>> load() async {
    if (fail) throw StateError('sample failed');
    return photos;
  }
}
