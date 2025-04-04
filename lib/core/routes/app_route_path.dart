class AppRoutePath {
  final bool isUnknown;
  final bool isLoginScreen;
  final bool isRegisterScreen;
  final bool isMainScreen;
  final int? tabIndex;

  AppRoutePath.login()
    : isLoginScreen = true,
      isRegisterScreen = false,
      isMainScreen = false,
      isUnknown = false,
      tabIndex = null;

  AppRoutePath.register()
    : isLoginScreen = false,
      isRegisterScreen = true,
      isMainScreen = false,
      isUnknown = false,
      tabIndex = null;

  AppRoutePath.home({this.tabIndex = 0}) // default to first tab (home screen)
    : isLoginScreen = false,
      isRegisterScreen = false,
      isMainScreen = true,
      isUnknown = false;

  AppRoutePath.unknown()
    : isLoginScreen = false,
      isRegisterScreen = false,
      isMainScreen = false,
      isUnknown = true,
      tabIndex = null;
}
