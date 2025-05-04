// lib/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:storyzz/core/data/networking/responses/list_story.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/core/providers/auth_provider.dart';
import 'package:storyzz/core/utils/constants.dart';
import 'package:storyzz/core/widgets/language_dialog_screen.dart';
import 'package:storyzz/core/widgets/not_found_widget.dart';
import 'package:storyzz/features/auth/presentation/screen/login_screen.dart';
import 'package:storyzz/features/auth/presentation/screen/register_screen.dart';
import 'package:storyzz/features/auth/presentation/transition/auth_screen_transition.dart';
import 'package:storyzz/features/detail/presentation/screen/detail_dialog.dart';
import 'package:storyzz/features/detail/presentation/screen/detail_screen.dart';
import 'package:storyzz/features/home/presentation/screen/home_screen.dart';
import 'package:storyzz/features/home/presentation/screen/main_screen.dart';
import 'package:storyzz/features/home/presentation/widgets/logout_confirmation_dialog.dart';
import 'package:storyzz/features/map/presentation/screen/map_screen.dart';
import 'package:storyzz/features/notfound/presentation/screen/not_found_screen.dart';
import 'package:storyzz/features/settings/presentation/screen/settings_screen.dart';
import 'package:storyzz/features/upload_story/presentation/screen/upload_story_screen.dart';
import 'package:storyzz/features/upload_story/presentation/widgets/location_map_fullscreen.dart';
import 'package:storyzz/features/upload_story/presentation/widgets/upgrade_dialog.dart';

/// AppRouter is responsible for managing the navigation and routing of the app.
class AppRouter {
  final AuthProvider authProvider;
  final AppProvider appProvider;

  final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>();

  AppRouter({required this.appProvider, required this.authProvider}) {
    _initAuthState();
  }

  Future<void> _initAuthState() async {
    await authProvider.isLogged();
  }

  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: false, // true for debugging
    refreshListenable: Listenable.merge([authProvider, appProvider]),
    redirect: _handleRedirect,
    errorBuilder: (context, state) => const NotFoundScreen(),
    routerNeglect: false,
    routes: [
      GoRoute(
        path: '/404',
        name: 'notFound',
        builder: (context, state) => const NotFoundScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        redirect: (context, state) {
          if (appProvider.isRegister) {
            return '/register';
          }
          if (appProvider.isLanguageDialogOpen) {
            return '/login/language-dialog';
          }
          return null;
        },
        routes: [_languageDialogRoute('login')],

        pageBuilder: (context, state) {
          return AuthScreenTransition(
            child: LoginScreen(),
            isForward: false,
            key: state.pageKey,
          );
        },
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        redirect: (context, state) {
          if (appProvider.isLogin) {
            return '/login';
          }
          if (appProvider.isLanguageDialogOpen) {
            return '/register/language-dialog';
          }
          return null;
        },
        routes: [_languageDialogRoute('register')],
        pageBuilder: (context, state) {
          return AuthScreenTransition(
            child: RegisterScreen(),
            isForward: true,
            key: state.pageKey,
          );
        },
      ),

      // main app shell with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
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
            redirect: (context, state) {
              // open detail page
              if (appProvider.selectedStory != null) {
                return '/story/${appProvider.selectedStory!.id}';
              }
              if (appProvider.isDialogLogOutOpen) {
                return '/logout-confirmation';
              }
              if (!appProvider.isDialogLogOutOpen) {
                return '/';
              }

              return null;
            },
            routes: [
              _detailRoute(''),
              GoRoute(
                path: 'logout-confirmation',
                name: 'dialogLogOut',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) {
                  return _dialogTransition(state, LogoutConfirmationDialog());
                },
              ),
            ],
          ),
          GoRoute(
            path: '/map',
            name: 'map',
            builder: (context, state) => MapStoryScreen(),
            redirect: (context, state) {
              // open detail page
              if (appProvider.selectedStory != null) {
                return '/map/story/${appProvider.selectedStory!.id}';
              }
              return null;
            },
            routes: [_detailRoute('map')],
          ),
          GoRoute(
            path: '/upload',
            name: 'upload',
            builder: (context, state) => UploadStoryScreen(),
            redirect: (context, state) {
              // open dialog upgrade promotion
              if (appProvider.isUpDialogOpen) {
                return '/upload/upgrade';
              }
              // show map as fullscreen
              if (appProvider.isUploadFullScreenMap) {
                return '/upload/map';
              }
              // back to upload screen
              if (!appProvider.isUpDialogOpen &&
                  !appProvider.isUploadFullScreenMap) {
                return '/upload';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'upgrade',
                name: 'upgradeDialog',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) {
                  return _dialogTransition(state, UpgradeDialog());
                },
              ),
              GoRoute(
                path: 'map',
                name: 'uploadMap',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) {
                  return _dialogTransition(state, MapFullScreen());
                },
              ),
            ],
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
      '/logout-confirmation',
      '/login',
      '/login/language-dialog',
      '/register',
      '/register/language-dialog',
      '/map',
      '/upload',
      '/upload/upgrade',
      '/upload/map',
      '/settings',
      '/story',
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

    if (!isLoggedIn &&
        !isGoingToAuth &&
        path != '/404' &&
        !appProvider.isLanguageDialogOpen) {
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

  GoRoute _languageDialogRoute(String name) {
    return GoRoute(
      path: '/language-dialog',
      name: "${name}LanguageDialog",
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) {
        return _dialogTransition(state, LanguageDialogScreen());
      },
    );
  }

  GoRoute _detailRoute(String name) {
    return GoRoute(
      path: 'story/:id',
      name: "${name}StoryDetail",
      parentNavigatorKey: _rootNavigatorKey,
      redirect: (context, state) {
        debugPrint('isFullScreenMap: ${appProvider.isDetailFullScreenMap}');
        debugPrint(
          'selectedStory != null: ${appProvider.selectedStory != null}',
        );
        debugPrint('ID from path: ${state.pathParameters['id']}');

        // close the detail page
        if (appProvider.selectedStory == null && appProvider.isFromDetail) {
          return '/$name';
        }

        /// Shows message not support direct access
        if (appProvider.selectedStory == null && !appProvider.isFromDetail) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.direct_story_access_not_support,
                ),
              ),
            );
          });
          return '/$name';
        }
        return null;
      },
      pageBuilder: (context, state) {
        return _buildStoryDetailPage(
          appProvider,
          state,
          appProvider.selectedStory,
        );
      },
    );
  }
}

/// Builds the story detail page based on the current platform (desktop or mobile).
Page _buildStoryDetailPage(
  AppProvider appProvider,
  GoRouterState state,
  ListStory? persistedStory,
) {
  if (persistedStory == null) {
    debugPrint('Warning: Invalid or missing story data. Redirecting to home.');
    // Return a redirect page or an error page
    return MaterialPage(key: state.pageKey, child: NotFoundWidget());
  }

  return _dialogTransition(
    state,
    Builder(
      builder: (context) {
        final isDesktop = MediaQuery.of(context).size.width >= tabletBreakpoint;
        return isDesktop ? StoryDetailDialog() : StoryDetailScreen();
      },
    ),
  );
}

/// Extension to add a method for navigating to the home screen with a specific tab index.
extension GoRouterExtension on BuildContext {
  void navigateToHome({int tabIndex = 0}) {
    final String path = switch (tabIndex) {
      0 => '/',
      1 => '/map',
      2 => '/upload',
      3 => '/settings',
      _ => '/',
    };
    GoRouter.of(this).go(path);
  }
}

CustomTransitionPage<dynamic> _dialogTransition(
  GoRouterState state,
  Widget childWidget,
) {
  return CustomTransitionPage(
    key: state.pageKey,
    fullscreenDialog: true,
    maintainState: true,
    opaque: false,
    barrierDismissible: true,
    barrierColor: Colors.black54,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          child: child,
        ),
      );
    },
    child: childWidget,
  );
}
