import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pikiva/app/view/foundation_page.dart';
import 'package:pikiva/app/view/route_error_page.dart';
import 'package:pikiva/l10n/generated/app_localizations.dart';

abstract final class AppRoutes {
  static const start = '/';
  static const licenses = '/licenses';
}

GoRouter createAppRouter({String? initialLocation}) => GoRouter(
  initialLocation: initialLocation,
  debugLogDiagnostics: false,
  restorationScopeId: 'router',
  routes: [
    GoRoute(
      path: AppRoutes.start,
      builder: (context, state) => const FoundationPage(),
      routes: [
        GoRoute(
          path: 'licenses',
          builder: (context, state) => LicensePage(
            applicationName: AppLocalizations.of(context).appName,
          ),
        ),
      ],
    ),
  ],
  // Do not render or log the incoming URI: it can contain private data.
  errorBuilder: (context, state) => const RouteErrorPage(),
);
