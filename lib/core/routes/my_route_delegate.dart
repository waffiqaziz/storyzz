import 'package:flutter/material.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/provider/auth_provider.dart';
import 'package:storyzz/core/routes/app_route_path.dart';
import 'package:storyzz/core/utils/custom_page_transition.dart';
import 'package:storyzz/ui/detail/detail_dialog.dart';
import 'package:storyzz/ui/detail/detail_screen.dart';

import '../../ui/auth/login_screen.dart';
import '../../ui/auth/register_screen.dart';
import '../../ui/home/main_screen.dart';
import '../data/networking/responses/stories_response.dart' show ListStory;

class MyRouteDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  final GlobalKey<NavigatorState> _navigatorKey;
  final AuthProvider authProvider;
  final _mainScreenKey = GlobalKey();

  bool _isLoggedIn = false;
  bool _isLoginScreen = true;
  bool _isRegisterScreen = false;
  bool _isMainScreen = false;
  bool _isStoryDetail = false;
  String? _currentStoryId;
  ListStory? _currentStory;

  // Add current tab index for bottom navigation
  int _currentTabIndex = 0;

  MyRouteDelegate(this.authProvider)
    : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  _init() async {
    _isLoggedIn = await authProvider.isLogged();
    if (_isLoggedIn) {
      _isMainScreen = true;
      _isLoginScreen = false;
      _isRegisterScreen = false;
    }
    notifyListeners();
  }

  // Add getter and setter for the current tab
  int get currentTabIndex => _currentTabIndex;

  set currentTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  AppRoutePath get currentConfiguration {
    if (_isStoryDetail && _currentStoryId != null) {
      return AppRoutePath.detailScreen(_currentStoryId!);
    }

    if (_isLoggedIn) {
      // Add tab information to the route path
      return AppRoutePath.home(tabIndex: _currentTabIndex);
    } else if (_isLoginScreen) {
      return AppRoutePath.login();
    } else if (_isRegisterScreen) {
      return AppRoutePath.register();
    } else {
      return AppRoutePath.unknown();
    }
  }

  @override
  Future<bool> popRoute() async {
    // if on story detail screen, go back to main screen
    if (_isStoryDetail) {
      _isStoryDetail = false;
      _isMainScreen = true;
      _currentStory = null;
      _currentStoryId = null;
      notifyListeners();
      return true;
    }

    // back button behavior after logged in
    if (_isLoggedIn && _isMainScreen) {
      // If we're not on the first tab, go back to first tab instead of exiting
      if (_currentTabIndex != 0) {
        _currentTabIndex = 0;
        notifyListeners();
        return true;
      }
      return false;
    }

    // if on register screen, go back to login screen
    if (_isRegisterScreen) {
      _isRegisterScreen = false;
      _isLoginScreen = true;
      notifyListeners();
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    bool isCurrentlyLoggedIn = authProvider.isLoggedIn;
    final isDesktop = MediaQuery.of(context).size.width > 600;

    // if login status changed, update our local state
    if (isCurrentlyLoggedIn != _isLoggedIn) {
      _isLoggedIn = isCurrentlyLoggedIn;
      if (_isLoggedIn) {
        _isMainScreen = true;
        _isLoginScreen = false;
        _isRegisterScreen = false;
        _isStoryDetail = false;
      } else {
        _isMainScreen = false;
        _isLoginScreen = true;
        _isRegisterScreen = false;
        _isStoryDetail = false;
      }
    }

    // handle responsive layout transition when on detail screen
    if (_isStoryDetail && isDesktop) {
      // when transitioning to desktop while on detail screen,
      // change to main screen to avoid Navigator issues
      _isMainScreen = true;
      _isStoryDetail = false;

      // show the dialog for desktop view after the frame is built
      if (_currentStory != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (navigatorKey?.currentContext != null) {
            showDialog(
              context: navigatorKey!.currentContext!,
              barrierColor: Colors.black87,
              builder: (context) => StoryDetailDialog(story: _currentStory!),
            );
          }
        });
      }
    }

    return Navigator(
      key: navigatorKey,
      pages: [
        if (_isLoginScreen)
          MaterialPage(
            key: ValueKey('LoginScreen'),
            child: LoginScreen(
              onLogin: () {
                _isLoggedIn = true;
                _isMainScreen = true;
                _isLoginScreen = false;
                notifyListeners();
              },
              onRegister: () {
                _isRegisterScreen = true;
                _isLoginScreen = false;
                notifyListeners();
              },
            ),
          ),
        if (_isRegisterScreen)
          MaterialPage(
            key: ValueKey('RegisterScreen'),
            child: RegisterScreen(
              onRegister: () {
                _isLoggedIn = true;
                _isMainScreen = true;
                _isRegisterScreen = false;
                notifyListeners();
              },
              onLogin: () {
                _isLoginScreen = true;
                _isRegisterScreen = false;
                notifyListeners();
              },
            ),
          ),
        if (_isMainScreen ||
            _isStoryDetail) // keep MainScreen in the stack even when showing detail
          MaterialPage(
            key: ValueKey('MainScreen'),
            child: MainScreen(
              key: _mainScreenKey,
              currentIndex: _currentTabIndex,
              onTabChanged: (index) {
                _currentTabIndex = index;
                notifyListeners();
              },
              onLogout: () {
                _isLoggedIn = false;
                _isMainScreen = false;
                _isLoginScreen = true;
                _currentTabIndex = 0; // Reset tab index on logout
                notifyListeners();
              },
            ),
          ),

        // only add detail screen as an overlay
        if (_isStoryDetail && _currentStory != null)
          if (MediaQuery.of(context).size.width <= 600)
            CustomPageTransition(
              transitionType: TransitionType.fade,
              key: ValueKey('StoryDetailScreen-${_currentStory!.id}'),
              child: StoryDetailScreen(
                story: _currentStory!,
                onBack: () {
                  _isStoryDetail = false;
                  notifyListeners();
                },
              ),
            ),
      ],

      onDidRemovePage: (page) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (page.key == ValueKey('RegisterPage')) {
            _isRegisterScreen = false;
            _isLoginScreen = true;
            notifyListeners();
          } else if (page.key.toString().startsWith(
            'ValueKey<StoryDetailScreen-',
          )) {
            _isStoryDetail = false;
            _isMainScreen = true;
            _currentStory = null;
            _currentStoryId = null;
            notifyListeners();
          } else if (page.key.toString().contains('StoryDetailScreen')) {
            _isStoryDetail = false;
            _isMainScreen = true;
            notifyListeners();
          }
        });
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath path) async {
    if (path.isUnknown) {
      _isLoginScreen = true;
      _isRegisterScreen = false;
      _isMainScreen = false;
      _isStoryDetail = false;
      _isLoggedIn = false;
      return;
    }

    if (path.storyId != null) {
      if (_isLoggedIn) {
        // due it cant fetch individual story by ID, redirect to home screen
        _isLoginScreen = false;
        _isRegisterScreen = false;
        _isMainScreen = true;
        _isStoryDetail = false;
        _currentStoryId = path.storyId!;

        // show a message after navigation completes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final context = navigatorKey?.currentContext;
          if (context != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.direct_story_access_not_support,
                ),
                duration: Duration(seconds: 3),
              ),
            );
          }
        });
      } else {
        _isLoginScreen = true;
        _isRegisterScreen = false;
        _isMainScreen = false;
        _isStoryDetail = false;
      }
      return;
    }

    if (path.isLoginScreen) {
      _isLoginScreen = true;
      _isRegisterScreen = false;
      _isMainScreen = false;
      _isStoryDetail = false;
      _isLoggedIn = false;
    } else if (path.isRegisterScreen) {
      _isLoginScreen = false;
      _isRegisterScreen = true;
      _isMainScreen = false;
      _isStoryDetail = false;
      _isLoggedIn = false;
    } else if (path.isMainScreen) {
      if (_isLoggedIn) {
        _isLoginScreen = false;
        _isRegisterScreen = false;
        _isMainScreen = true;
        _isStoryDetail = false;

        // Update tab index if provided in the path
        if (path.tabIndex != null) {
          _currentTabIndex = path.tabIndex!;
        }
      } else {
        // open login if not logged in
        _isLoginScreen = true;
        _isRegisterScreen = false;
        _isMainScreen = false;
        _isStoryDetail = false;
      }
    }
  }

  void navigateToHome({int tabIndex = 0}) {
    _currentTabIndex = tabIndex;
    _isMainScreen = true;
    _isLoginScreen = false;
    _isRegisterScreen = false;
    _isStoryDetail = false;
    notifyListeners();
  }

  void navigateToStoryDetail(ListStory story) {
    _currentStory = story;
    _currentStoryId = story.id;

    // check if context is available
    final context = navigatorKey?.currentContext;

    if (context == null) {
      // if no context, just update the navigation state
      _isStoryDetail = true;
      notifyListeners();
      return;
    }

    // only change navigation state for mobile views
    if (MediaQuery.of(context).size.width <= 600) {
      // add detail screen on top, MainScreen remains in the stack
      _isStoryDetail = true;
      notifyListeners();
    } else {
      // for web dekstop, show dialog without changing navigation state
      showDialog(
        context: context,
        barrierColor: Colors.black87,
        builder: (context) => StoryDetailDialog(story: story),
      );
    }
  }
}
