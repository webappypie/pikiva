import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UiPreferences {
  const UiPreferences({this.welcomed = false, this.theme = ThemeMode.system});
  final bool welcomed;
  final ThemeMode theme;
}

abstract interface class UiPreferenceStore {
  Future<UiPreferences> read();
  Future<void> saveWelcome();
  Future<void> saveTheme(ThemeMode theme);
}

/// Only non-sensitive UI choices. Never store sessions, photos, or credentials.
final class LocalUiPreferenceStore implements UiPreferenceStore {
  final SharedPreferencesAsync _store = SharedPreferencesAsync();
  static const _welcomeKey = 'pikiva.ui.welcomed.v1';
  static const _themeKey = 'pikiva.ui.theme.v1';

  @override
  Future<UiPreferences> read() async {
    final welcomed = await _store.getBool(_welcomeKey) ?? false;
    final theme = await _store.getString(_themeKey);
    return UiPreferences(
      welcomed: welcomed,
      theme: switch (theme) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      },
    );
  }

  @override
  Future<void> saveWelcome() => _store.setBool(_welcomeKey, true);

  @override
  Future<void> saveTheme(ThemeMode theme) =>
      _store.setString(_themeKey, theme.name);
}
