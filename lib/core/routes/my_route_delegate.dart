import 'package:flutter/material.dart';
import 'package:storyzz/core/provider/auth_provider.dart';

import '../../ui/home/main_screen.dart';
import '../../ui/auth/login_screen.dart';
import '../../ui/auth/register_screen.dart';
import 'app_route_path.dart';

class MyRouteDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  final GlobalKey<NavigatorState> _navigatorKey;
  final AuthProvider authProvider;

  bool _isLoggedIn = false;
  bool _isLoginScreen = true;
  bool _isRegisterScreen = false;
  bool _isMainScreen = false;

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

    // if login status changed, update our local state
    if (isCurrentlyLoggedIn != _isLoggedIn) {
      _isLoggedIn = isCurrentlyLoggedIn;
      if (_isLoggedIn) {
        _isMainScreen = true;
        _isLoginScreen = false;
        _isRegisterScreen = false;
      } else {
        _isMainScreen = false;
        _isLoginScreen = true;
        _isRegisterScreen = false;
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
        if (_isMainScreen)
          MaterialPage(
            key: ValueKey('MainScreen'),
            child: MainScreen(
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
      ],
      onDidRemovePage: (page) {
        if (page.key == ValueKey('RegisterPage')) {
          _isRegisterScreen = false;
          _isLoginScreen = true;
          notifyListeners();
        }
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath path) async {
    if (path.isUnknown) {
      _isLoginScreen = true;
      _isRegisterScreen = false;
      _isMainScreen = false;
      _isLoggedIn = false;
      return;
    }

    if (path.isLoginScreen) {
      _isLoginScreen = true;
      _isRegisterScreen = false;
      _isMainScreen = false;
      _isLoggedIn = false;
    } else if (path.isRegisterScreen) {
      _isLoginScreen = false;
      _isRegisterScreen = true;
      _isMainScreen = false;
      _isLoggedIn = false;
    } else if (path.isMainScreen) {
      if (_isLoggedIn) {
        _isLoginScreen = false;
        _isRegisterScreen = false;
        _isMainScreen = true;
        // Update tab index if provided in the path
        if (path.tabIndex != null) {
          _currentTabIndex = path.tabIndex!;
        }
      } else {
        // open login if not logged in
        _isLoginScreen = true;
        _isRegisterScreen = false;
        _isMainScreen = false;
      }
    }
  }

  void navigateToHome({int tabIndex = 0}) {
    _currentTabIndex = tabIndex;
    _isMainScreen = true;
    _isLoginScreen = false;
    _isRegisterScreen = false;
    notifyListeners();
  }
}
