import 'package:flutter/material.dart';
import 'package:pikiva/core/storage/ui_preferences.dart';
import 'package:pikiva/features/samples/sample_repository.dart';

enum SampleStatus { empty, loading, ready, failed }

/// Owns only UI preferences and ephemeral sample-preview state.
final class ShellController extends ChangeNotifier {
  ShellController({required this.preferences, required this.samples});
  final UiPreferenceStore preferences;
  final SampleRepository samples;
  bool initialized = false;
  bool startupFailed = false;
  bool welcomed = false;
  bool sessionOnly = false;
  bool saving = false;
  bool preferenceFailed = false;
  ThemeMode theme = ThemeMode.system;
  SampleStatus sampleStatus = SampleStatus.empty;
  List<SamplePhoto> photos = const [];
  final Set<String> _kept = {};
  bool _disposed = false;
  int _startupGeneration = 0;
  int _sampleGeneration = 0;

  bool isKept(String id) => _kept.contains(id);
  int get keptCount => _kept.length;
  void _emit() {
    if (!_disposed) notifyListeners();
  }

  Future<void> initialize() async {
    final generation = ++_startupGeneration;
    startupFailed = false;
    _emit();
    try {
      final value = await preferences.read();
      if (_disposed || generation != _startupGeneration) return;
      welcomed = value.welcomed;
      theme = value.theme;
      initialized = true;
    } catch (_) {
      if (_disposed || generation != _startupGeneration) return;
      startupFailed = true;
    }
    _emit();
  }

  void useSessionOnly() {
    _startupGeneration++;
    sessionOnly = true;
    initialized = true;
    startupFailed = false;
    preferenceFailed = false;
    _emit();
  }

  Future<void> finishWelcome() async {
    if (saving) return;
    saving = true;
    preferenceFailed = false;
    _emit();
    try {
      if (!sessionOnly) await preferences.saveWelcome();
      if (_disposed) return;
      welcomed = true;
    } catch (_) {
      preferenceFailed = true;
    }
    saving = false;
    _emit();
  }

  Future<void> changeTheme(ThemeMode value) async {
    if (saving) return;
    saving = true;
    preferenceFailed = false;
    _emit();
    try {
      if (!sessionOnly) await preferences.saveTheme(value);
      if (_disposed) return;
      theme = value;
    } catch (_) {
      preferenceFailed = true;
    }
    saving = false;
    _emit();
  }

  Future<void> loadSample() async {
    if (sampleStatus == SampleStatus.loading) return;
    final generation = ++_sampleGeneration;
    sampleStatus = SampleStatus.loading;
    _emit();
    try {
      final value = await samples.load();
      if (_disposed || generation != _sampleGeneration) return;
      photos = value;
      _kept
        ..clear()
        ..addAll(
          value.where((p) => p.group == SampleGroup.best).map((p) => p.id),
        );
      sampleStatus = value.isEmpty ? SampleStatus.empty : SampleStatus.ready;
    } catch (_) {
      if (_disposed || generation != _sampleGeneration) return;
      sampleStatus = SampleStatus.failed;
    }
    _emit();
  }

  void toggleKeep(String id) {
    if (!photos.any((photo) => photo.id == id)) return;
    if (!_kept.remove(id)) _kept.add(id);
    _emit();
  }

  void clearSample() {
    _sampleGeneration++;
    photos = const [];
    _kept.clear();
    sampleStatus = SampleStatus.empty;
    _emit();
  }

  @override
  void dispose() {
    _disposed = true;
    _startupGeneration++;
    _sampleGeneration++;
    super.dispose();
  }
}

class ShellScope extends InheritedNotifier<ShellController> {
  const ShellScope({
    required ShellController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);
  static ShellController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ShellScope>()!.notifier!;
}
