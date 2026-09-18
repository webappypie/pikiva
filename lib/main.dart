import 'package:flutter/widgets.dart';
import 'package:pikiva/app/pikiva_app.dart';
import 'package:pikiva/core/config/app_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(PikivaApp(config: AppConfig.fromEnvironment()));
}
