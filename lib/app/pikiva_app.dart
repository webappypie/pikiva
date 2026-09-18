import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pikiva/app/routing/app_router.dart';
import 'package:pikiva/app/shell_controller.dart';
import 'package:pikiva/core/config/app_config.dart';
import 'package:pikiva/core/design/app_theme.dart';
import 'package:pikiva/core/design/app_tokens.dart';
import 'package:pikiva/core/storage/ui_preferences.dart';
import 'package:pikiva/features/samples/sample_repository.dart';
import 'package:pikiva/l10n/generated/app_localizations.dart';

/// Owns platform adapters; feature widgets depend on the controller contract.
class PikivaApp extends StatefulWidget {
  const PikivaApp({
    required this.config,
    this.themeMode,
    this.controller,
    this.router,
    super.key,
  });
  final AppConfig config;
  final ThemeMode? themeMode;

  /// Injected controllers and routers remain owned by the caller.
  final ShellController? controller;
  final GoRouter? router;
  @override
  State<PikivaApp> createState() => _PikivaAppState();
}

class _PikivaAppState extends State<PikivaApp> {
  late final ShellController _controller;
  late final GoRouter _router;
  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
        ShellController(
          preferences: LocalUiPreferenceStore(),
          samples: BundledSampleRepository(),
        );
    _router = widget.router ?? createAppRouter(controller: _controller);
    if (!_controller.initialized) unawaited(_controller.initialize());
  }

  @override
  void dispose() {
    if (widget.router == null) _router.dispose();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ShellScope(
    controller: _controller,
    child: ListenableBuilder(
      listenable: _controller,
      builder: (context, _) => MaterialApp.router(
        onGenerateTitle: (context) => AppLocalizations.of(context).appName,
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: widget.themeMode ?? _controller.theme,
        themeAnimationDuration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : AppMotion.standard,
        themeAnimationCurve: AppMotion.curve,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        restorationScopeId: 'pikiva',
      ),
    ),
  );
}
