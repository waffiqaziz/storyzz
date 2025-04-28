// lib/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storyzz/core/data/networking/responses/list_story.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/auth_provider.dart';
import 'package:storyzz/features/auth/presentation/screen/login_screen.dart';
import 'package:storyzz/features/auth/presentation/screen/register_screen.dart';
import 'package:storyzz/features/auth/presentation/transition/auth_screen_transition.dart';
import 'package:storyzz/features/detail/presentation/screen/detail_dialog.dart';
import 'package:storyzz/features/detail/presentation/screen/detail_screen.dart';
import 'package:storyzz/features/home/presentation/screen/home_screen.dart';
import 'package:storyzz/features/home/presentation/screen/main_screen.dart';
import 'package:storyzz/features/map/presentation/screen/map_screen.dart';
import 'package:storyzz/features/notfound/presentation/screen/not_found_screen.dart';
import 'package:storyzz/features/settings/presentation/screen/settings_screen.dart';
import 'package:storyzz/features/upload_story/presentation/screen/upload_story_screen.dart';

/// AppRouter is responsible for managing the navigation and routing of the app.
class AppRouter {
  static ListStory? _currentStory;
  final AuthProvider authProvider;
  final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> shellNavigatorKey =
      GlobalKey<NavigatorState>();

  AppRouter({required this.authProvider}) {
    _initAuthState();
  }

  Future<void> _initAuthState() async {
    await authProvider.isLogged();
  }

  late final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: false, // true for debugging
    refreshListenable: authProvider, // listen to auth changes
    redirect: _handleRedirect,
    errorBuilder: (context, state) => const NotFoundScreen(),
    routerNeglect: false,
    routes: [
      GoRoute(
        path: '/404',
        name: 'notFound',
        builder: (context, state) => const NotFoundScreen(),
      ),

      // auth routes - outside the shell
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder:
            (context, state) => AuthScreenTransition(
              child: LoginScreen(),
              isForward: false,
              key: state.pageKey,
            ),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        pageBuilder:
            (context, state) => AuthScreenTransition(
              child: RegisterScreen(),
              isForward: true,
              key: state.pageKey,
            ),
      ),
      GoRoute(
        path: '/story/:id',
        name: 'storyDetail',
        parentNavigatorKey: rootNavigatorKey,
        redirect: (context, state) async {
          if (state.extra is ListStory) {
            _currentStory = state.extra as ListStory;
          }
          // if accessed directly via URL, redirect to home
          if (state.extra == null) {
            // show message about direct access not supported
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(
                      context,
                    )!.direct_story_access_not_support,
                  ),
                ),
              );
            });
            return '/';
          }
          return null;
        },
        pageBuilder: (context, state) {
          // Use the stored story data
          return _buildStoryDetailPage(state, _currentStory);
        },
      ),

      // main app shell with bottom navigation
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          return MainScreen(
            currentIndex: _calculateSelectedIndex(state),
            onTabChanged: (index) {
              switch (index) {
                case 0:
                  router.go('/');
                  break;
                case 1:
                  router.go('/map');
                  break;
                case 2:
                  router.go('/upload');
                  break;
                case 3:
                  router.go('/settings');
                  break;
              }
            },
            onLogout: () async {
              await authProvider.logout();
              router.go('/login');
            },
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => HomeScreen(),
          ),
          GoRoute(
            path: '/map',
            name: 'map',
            builder: (context, state) => MapStoryScreen(),
          ),
          GoRoute(
            path: '/upload',
            name: 'upload',
            builder: (context, state) => UploadStoryScreen(),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => SettingsScreen(),
          ),
        ],
      ),
    ],
  );

  Future<String?> _handleRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    // get the path without query parameters and hash
    var path = Uri.parse(state.matchedLocation).path;
    path = path.replaceAll(RegExp(r'/+'), '/');
    if (path.length > 1 && path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }
    final bool isLoggedIn = await authProvider.isLogged();

    // Define valid paths
    final validPaths = [
      '/',
      '/login',
      '/register',
      '/map',
      '/upload',
      '/settings',
      '/404',
    ];

    final isValidPath =
        validPaths.contains(path) ||
        path.startsWith('/story/') ||
        path.startsWith('/map/story/');

    if (!isValidPath) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        router.go('/404');
      });
      return '/404';
    }

    final bool isGoingToAuth = path == '/login' || path == '/register';

    if (!isLoggedIn && !isGoingToAuth && path != '/404') {
      return '/login';
    }

    if (isLoggedIn && isGoingToAuth) {
      return '/';
    }

    return null;
  }

  int _calculateSelectedIndex(GoRouterState state) {
    final String location = state.matchedLocation;

    if (location.startsWith('/map')) {
      return 1;
    }
    if (location.startsWith('/upload')) {
      return 2;
    }
    if (location.startsWith('/settings')) {
      return 3;
    }
    return 0;
  }
}

/// Builds the story detail page based on the current platform (desktop or mobile).
///
/// Parameters:
/// - [state]: The current GoRouter state containing the story data.
///
/// Returns:
/// - A [CustomTransitionPage] with the appropriate story detail screen.
Page _buildStoryDetailPage(GoRouterState state, ListStory? persistedStory) {
  final story = persistedStory;

  // Handle the case when extra is null or not a ListStory
  if (story == null) {
    debugPrint('Warning: Invalid or missing story data. Redirecting to home.');
    // Return a redirect page or an error page
    return MaterialPage(
      key: state.pageKey,
      child: Builder(
        builder:
            (context) => Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Story not found'),
                    ElevatedButton(
                      onPressed: () => GoRouter.of(context).go('/'),
                      child: Text('Go Home'),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  return CustomTransitionPage(
    key: state.pageKey,
    fullscreenDialog: true,
    opaque: false,
    barrierDismissible: true,
    barrierColor: Colors.black54,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
    child: Builder(
      builder: (context) {
        final isDesktop =
            MediaQuery.of(context).size.width >= MainScreen.tabletBreakpoint;
        return isDesktop
            ? StoryDetailDialog(
              story: story,
              onClose: () => GoRouter.of(context).pop(),
            )
            : StoryDetailScreen(
              story: story,
              onBack: () => GoRouter.of(context).pop(),
            );
      },
    ),
  );
}

extension GoRouterExtension on BuildContext {
  void navigateToStoryDetail(ListStory story) {
    GoRouter.of(
      this,
    ).pushNamed('storyDetail', pathParameters: {'id': story.id}, extra: story);
  }

  void navigateToHome({int tabIndex = 0}) {
    switch (tabIndex) {
      case 0:
        GoRouter.of(this).go('/');
        break;
      case 1:
        GoRouter.of(this).go('/map');
        break;
      case 2:
        GoRouter.of(this).go('/upload');
        break;
      case 3:
        GoRouter.of(this).go('/settings');
        break;
      default:
        GoRouter.of(this).go('/');
    }
  }
}
