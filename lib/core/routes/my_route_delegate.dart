import 'package:flutter/material.dart';
import 'package:storyzz/core/data/networking/responses/list_story.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/provider/auth_provider.dart';
import 'package:storyzz/core/routes/app_route_path.dart';
import 'package:storyzz/core/utils/custom_page_transition.dart';
import 'package:storyzz/core/widgets/dialog_page.dart';
import 'package:storyzz/features/detail/presentation/screen/detail_dialog.dart';
import 'package:storyzz/features/detail/presentation/screen/detail_screen.dart';

import '../../features/auth/presentation/screen/login_screen.dart';
import '../../features/auth/presentation/screen/register_screen.dart';
import '../../features/home/presentation/screen/main_screen.dart';

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
  bool _isStoryDetailDialog = false;
  String? _currentStoryId;
  ListStory? _currentStory;

  // current tab index for bottom navigation
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

  int get currentTabIndex => _currentTabIndex;

  set currentTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  AppRoutePath get currentConfiguration {
    // both detail screen and dialog should use the same URL pattern
    if ((_isStoryDetail || _isStoryDetailDialog) && _currentStoryId != null) {
      return AppRoutePath.detailScreen(_currentStoryId!);
    }

    if (_isLoggedIn) {
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
    // handle pop for both story detail screen and dialog, go back to main screen
    if (_isStoryDetail || _isStoryDetailDialog) {
      _isStoryDetail = false;
      _isStoryDetailDialog = false;
      _isMainScreen = true;
      _currentStory = null;
      _currentStoryId = null;
      notifyListeners();
      return true;
    }

    // back button behavior after logged in
    if (_isLoggedIn && _isMainScreen) {
      // if not on the first tab, go back to first tab instead of exiting
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

    // if login status changed, update the local state
    if (isCurrentlyLoggedIn != _isLoggedIn) {
      _isLoggedIn = isCurrentlyLoggedIn;
      if (_isLoggedIn) {
        _isMainScreen = true;
        _isLoginScreen = false;
        _isRegisterScreen = false;
        _isStoryDetail = false;
        _isStoryDetailDialog = false;
      } else {
        _isMainScreen = false;
        _isLoginScreen = true;
        _isRegisterScreen = false;
        _isStoryDetail = false;
        _isStoryDetailDialog = false;
      }
    }

    // handle responsive layout transition for story detail
    if (_currentStory != null) {
      if (isDesktop) {
        // desktop should use dialog
        _isStoryDetailDialog = true;
        _isStoryDetail = false;
      } else {
        // mobile should use detail screen
        _isStoryDetail = true;
        _isStoryDetailDialog = false;
      }
    } else {
      _isStoryDetail = false;
      _isStoryDetailDialog = false;
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

        // main screen always in the stack when logged in
        if (_isMainScreen || _isStoryDetail || _isStoryDetailDialog)
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
                _currentTabIndex = 0; // reset tab index on logout
                _currentStory = null;
                _currentStoryId = null;
                notifyListeners();
              },
            ),
          ),

        // detail screen for mobile view
        if (_isStoryDetail && _currentStory != null)
          CustomPageTransition(
            transitionType: TransitionType.fade,
            key: ValueKey('StoryDetailScreen-${_currentStory!.id}'),
            child: StoryDetailScreen(
              story: _currentStory!,
              onBack: () {
                _isStoryDetail = false;
                _currentStory = null;
                _currentStoryId = null;
                notifyListeners();
              },
            ),
          ),

        // detail dialog overlay for desktop view
        if (_isStoryDetailDialog && _currentStory != null)
          DialogPage(
            key: ValueKey('StoryDetailDialog-${_currentStory!.id}'),
            barrierColor: Colors.black87,
            barrierDismissible: true,
            child: StoryDetailDialog(
              story: _currentStory!,
              onClose: () {
                _isStoryDetailDialog = false;
                _currentStory = null;
                _currentStoryId = null;
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
    /// Handle when open via url

    if (path.isUnknown) {
      _isLoginScreen = true;
      _isStoryDetailDialog = false;
      _isRegisterScreen = false;
      _isMainScreen = false;
      _isStoryDetail = false;
      _isLoggedIn = false;
      _currentStory = null;
      _currentStoryId = null;
      return;
    }

    if (path.storyId != null) {
      if (_isLoggedIn) {
        _isLoginScreen = false;
        _isRegisterScreen = false;
        _isMainScreen = true;
        _isStoryDetail = false;
        _currentStoryId = path.storyId!;

        // due it cant fetch individual story by ID, redirect to home screen
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
        _isStoryDetailDialog = false;
      }
      return;
    }

    if (path.isLoginScreen) {
      _isLoginScreen = true;
      _isRegisterScreen = false;
      _isMainScreen = false;
      _isStoryDetail = false;
      _isStoryDetailDialog = false;
      _isLoggedIn = false;
      _currentStory = null;
      _currentStoryId = null;
    } else if (path.isRegisterScreen) {
      _isLoginScreen = false;
      _isRegisterScreen = true;
      _isMainScreen = false;
      _isStoryDetail = false;
      _isStoryDetailDialog = false;
      _isLoggedIn = false;
      _currentStory = null;
      _currentStoryId = null;
    } else if (path.isMainScreen) {
      if (_isLoggedIn) {
        _isLoginScreen = false;
        _isRegisterScreen = false;
        _isMainScreen = true;
        _isStoryDetail = false;
        _isStoryDetailDialog = false;
        _currentStory = null;
        _currentStoryId = null;

        // update tab index if provided in the path
        if (path.tabIndex != null) {
          _currentTabIndex = path.tabIndex!;
        }
      } else {
        // open login if not logged in
        _isLoginScreen = true;
        _isRegisterScreen = false;
        _isMainScreen = false;
        _isStoryDetail = false;
        _isStoryDetailDialog = false;
      }
    }
  }

  void navigateToHome({int tabIndex = 0}) {
    _currentTabIndex = tabIndex;
    _isMainScreen = true;
    _isLoginScreen = false;
    _isRegisterScreen = false;
    _isStoryDetail = false;
    _isStoryDetailDialog = false;
    _currentStory = null;
    _currentStoryId = null;
    notifyListeners();
  }

  void navigateToStoryDetail(ListStory story) {
    _currentStory = story;
    _currentStoryId = story.id;

    if (MediaQuery.of(navigatorKey!.currentContext!).size.width > 600) {
      _isStoryDetailDialog = true;
      _isStoryDetail = false;
    } else {
      _isStoryDetail = true;
      _isStoryDetailDialog = false;
    }

    notifyListeners();
  }
}
