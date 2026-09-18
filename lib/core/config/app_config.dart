/// Non-secret build configuration. Values in a mobile binary are public.
enum AppEnvironment { development, production }

/// Immutable, injectable local configuration; no network or platform access.
final class AppConfig {
  const AppConfig({required this.environment});

  factory AppConfig.fromEnvironment() => AppConfig.fromValues(
    environment: const String.fromEnvironment(
      'APP_ENV',
      defaultValue: 'production',
    ),
  );

  factory AppConfig.fromValues({required String environment}) {
    final parsed = switch (environment) {
      'development' => AppEnvironment.development,
      'production' => AppEnvironment.production,
      _ => throw const FormatException(
        'APP_ENV must be development or production.',
      ),
    };
    return AppConfig(environment: parsed);
  }

  final AppEnvironment environment;

  // Privacy boundaries are not remotely configurable feature flags.
  bool get cloudTextEnabled => false;
  bool get telemetryEnabled => false;
}
