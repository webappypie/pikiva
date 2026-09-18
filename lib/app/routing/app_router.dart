import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pikiva/app/routing/app_routes.dart';
import 'package:pikiva/app/shell_controller.dart';
import 'package:pikiva/app/view/app_shell.dart';
import 'package:pikiva/app/view/route_error_page.dart';
import 'package:pikiva/features/creations/creation_widgets.dart';
import 'package:pikiva/features/creations/creations_page.dart';
import 'package:pikiva/features/home/home_page.dart';
import 'package:pikiva/features/onboarding/welcome_page.dart';
import 'package:pikiva/features/samples/results_page.dart';
import 'package:pikiva/features/sessions/sessions_page.dart';
import 'package:pikiva/features/settings/settings_page.dart';
import 'package:pikiva/l10n/generated/app_localizations.dart';

export 'app_routes.dart';

GoRouter createAppRouter({
  required ShellController controller,
  String? initialLocation,
}) {
  final root = GlobalKey<NavigatorState>();
  String? pendingLocation;
  return GoRouter(
    navigatorKey: root,
    initialLocation: initialLocation ?? AppRoutes.splash,
    refreshListenable: controller,
    debugLogDiagnostics: false,
    restorationScopeId: 'router',
    redirect: (context, state) {
      if ((!controller.initialized || !controller.welcomed) &&
          state.uri.path != AppRoutes.splash &&
          state.uri.path != AppRoutes.welcome) {
        pendingLocation = state.uri.toString();
      }
      if (!controller.initialized) {
        return state.matchedLocation == AppRoutes.splash
            ? null
            : AppRoutes.splash;
      }
      if (!controller.welcomed) {
        return state.matchedLocation == AppRoutes.welcome
            ? null
            : AppRoutes.welcome;
      }
      if (state.matchedLocation == AppRoutes.splash ||
          state.matchedLocation == AppRoutes.welcome) {
        final destination = pendingLocation ?? AppRoutes.start;
        pendingLocation = null;
        return destination;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const StartupPage(),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: '/licenses',
        redirect: (context, state) => AppRoutes.licenses,
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigation) =>
            AppShell(navigation: navigation),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.start,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.creations,
                builder: (context, state) => const CreationsPage(),
                routes: [
                  GoRoute(
                    path: ':kind',
                    parentNavigatorKey: root,
                    builder: (context, state) {
                      final kinds = CreationKind.values.where(
                        (kind) => kind.name == state.pathParameters['kind'],
                      );
                      return kinds.isEmpty
                          ? const RouteErrorPage()
                          : CreationPreviewPage(kind: kinds.first);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.sessions,
                builder: (context, state) => const SessionsPage(),
                routes: [
                  GoRoute(
                    path: 'sample',
                    parentNavigatorKey: root,
                    builder: (context, state) => const ResultsPage(),
                    routes: [
                      GoRoute(
                        path: ':id',
                        parentNavigatorKey: root,
                        builder: (context, state) =>
                            SamplePhotoPage(id: state.pathParameters['id']!),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) => const SettingsPage(),
                routes: [
                  GoRoute(
                    path: 'licenses',
                    parentNavigatorKey: root,
                    builder: (context, state) => LicensePage(
                      applicationName: AppLocalizations.of(context).appName,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
    // Incoming URIs may include private data; never render or log them.
    errorBuilder: (context, state) => const RouteErrorPage(),
  );
}
