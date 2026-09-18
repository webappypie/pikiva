import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pikiva/app/routing/app_router.dart';
import 'package:pikiva/core/config/app_config.dart';
import 'package:pikiva/core/design/app_theme.dart';
import 'package:pikiva/core/design/app_tokens.dart';
import 'package:pikiva/l10n/generated/app_localizations.dart';

/// Composition root. Platform adapters and repositories belong here when added.
class PikivaApp extends StatefulWidget {
  const PikivaApp({
    required this.config,
    this.themeMode = ThemeMode.system,
    this.router,
    super.key,
  });

  final AppConfig config;
  final ThemeMode themeMode;

  /// Optional caller-owned router for tests; never disposed by this widget.
  final GoRouter? router;

  @override
  State<PikivaApp> createState() => _PikivaAppState();
}

class _PikivaAppState extends State<PikivaApp> {
  final GoRouter _defaultRouter = createAppRouter();

  @override
  void dispose() {
    _defaultRouter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    onGenerateTitle: (context) => AppLocalizations.of(context).appName,
    debugShowCheckedModeBanner: false,
    routerConfig: widget.router ?? _defaultRouter,
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    themeMode: widget.themeMode,
    themeAnimationDuration: MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : AppMotion.standard,
    themeAnimationCurve: AppMotion.curve,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    restorationScopeId: 'pikiva',
  );
}
