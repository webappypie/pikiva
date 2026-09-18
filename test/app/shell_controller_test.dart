import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pikiva/app/shell_controller.dart';
import 'package:pikiva/core/storage/ui_preferences.dart';
import 'package:pikiva/features/samples/sample_repository.dart';

import '../support/fakes.dart';

class PendingSamples implements SampleRepository {
  final completer = Completer<List<SamplePhoto>>();
  @override
  Future<List<SamplePhoto>> load() => completer.future;
}

void main() {
  test(
    'first launch, theme and welcome survive controller recreation',
    () async {
      final store = MemoryPreferences(value: const UiPreferences());
      final first = ShellController(preferences: store, samples: FakeSamples());
      await first.initialize();
      expect(first.welcomed, isFalse);
      await first.finishWelcome();
      await first.changeTheme(ThemeMode.dark);
      first.dispose();
      final second = ShellController(
        preferences: store,
        samples: FakeSamples(),
      );
      addTearDown(second.dispose);
      await second.initialize();
      expect(second.welcomed, isTrue);
      expect(second.theme, ThemeMode.dark);
      expect(second.sampleStatus, SampleStatus.empty);
    },
  );
  test('read failure is retryable and session-only avoids writes', () async {
    final store = MemoryPreferences()..failRead = true;
    final state = ShellController(preferences: store, samples: FakeSamples());
    addTearDown(state.dispose);
    await state.initialize();
    expect(state.startupFailed, isTrue);
    expect(state.initialized, isFalse);
    store.failRead = false;
    await state.initialize();
    expect(state.initialized, isTrue);
    store.failSave = true;
    state.useSessionOnly();
    await state.changeTheme(ThemeMode.dark);
    expect(state.theme, ThemeMode.dark);
    expect(state.preferenceFailed, isFalse);
    expect(store.value.theme, ThemeMode.system);
  });
  test('failed writes preserve previous state and allow retry', () async {
    final store = MemoryPreferences(value: const UiPreferences())
      ..failSave = true;
    final state = ShellController(preferences: store, samples: FakeSamples());
    addTearDown(state.dispose);
    await state.initialize();
    await state.finishWelcome();
    expect(state.welcomed, isFalse);
    expect(state.preferenceFailed, isTrue);
    await state.changeTheme(ThemeMode.dark);
    expect(state.theme, ThemeMode.system);
    store.failSave = false;
    await state.finishWelcome();
    await state.changeTheme(ThemeMode.dark);
    expect(state.welcomed, isTrue);
    expect(state.theme, ThemeMode.dark);
    expect(state.preferenceFailed, isFalse);
  });
  test('sample failure, retry, selections, clear and empty load', () async {
    final samples = FakeSamples()..fail = true;
    final state = ShellController(
      preferences: MemoryPreferences(),
      samples: samples,
    );
    addTearDown(state.dispose);
    await state.loadSample();
    expect(state.sampleStatus, SampleStatus.failed);
    samples.fail = false;
    await state.loadSample();
    expect(state.keptCount, 1);
    state.toggleKeep('unknown');
    expect(state.keptCount, 1);
    state.toggleKeep('cove');
    expect(state.keptCount, 2);
    state.clearSample();
    expect(state.photos, isEmpty);
    expect(state.keptCount, 0);
    samples.photos = [];
    await state.loadSample();
    expect(state.sampleStatus, SampleStatus.empty);
  });
  test('clearing or disposing during load rejects stale completion', () async {
    final samples = PendingSamples();
    final state = ShellController(
      preferences: MemoryPreferences(),
      samples: samples,
    );
    final loading = state.loadSample();
    expect(state.sampleStatus, SampleStatus.loading);
    state.clearSample();
    samples.completer.complete(FakeSamples().photos);
    await loading;
    expect(state.sampleStatus, SampleStatus.empty);
    state.dispose();
    final pending = PendingSamples();
    final disposed = ShellController(
      preferences: MemoryPreferences(),
      samples: pending,
    );
    final operation = disposed.loadSample();
    disposed.dispose();
    pending.completer.completeError(StateError('unavailable'));
    await operation;
  });
}
