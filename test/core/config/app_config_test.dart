import 'package:flutter_test/flutter_test.dart';
import 'package:pikiva/core/config/app_config.dart';

void main() {
  test('omitted environment is production with integrations disabled', () {
    final config = AppConfig.fromEnvironment();
    expect(config.environment, AppEnvironment.production);
    expect(config.cloudTextEnabled, isFalse);
    expect(config.telemetryEnabled, isFalse);
  });

  for (final environment in AppEnvironment.values) {
    test('${environment.name} retains offline privacy defaults', () {
      final config = AppConfig.fromValues(environment: environment.name);
      expect(config.environment, environment);
      expect(config.cloudTextEnabled, isFalse);
      expect(config.telemetryEnabled, isFalse);
    });
  }

  test('unknown environments fail closed without echoing their contents', () {
    for (final value in ['', 'prod', 'Production', 'private-token']) {
      expect(
        () => AppConfig.fromValues(environment: value),
        throwsA(
          isA<FormatException>().having(
            (error) => error.message,
            'safe validation message',
            'APP_ENV must be development or production.',
          ),
        ),
      );
    }
  });
}
