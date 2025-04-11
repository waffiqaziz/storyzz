class AppRoutePath {
  final bool isUnknown;
  final bool isLoginScreen;
  final bool isRegisterScreen;
  final bool isMainScreen;
  final bool isDetailScreen;
  final String? storyId;
  final int? tabIndex;

  AppRoutePath.login()
    : isLoginScreen = true,
      isRegisterScreen = false,
      isMainScreen = false,
      isUnknown = false,
      isDetailScreen = false,
      storyId = null,
      tabIndex = null;

  AppRoutePath.register()
    : isLoginScreen = false,
      isRegisterScreen = true,
      isMainScreen = false,
      isUnknown = false,
      isDetailScreen = false,
      storyId = null,
      tabIndex = null;

  AppRoutePath.home({this.tabIndex = 0}) // default to first tab (home screen)
    : isLoginScreen = false,
      isRegisterScreen = false,
      isMainScreen = true,
      isDetailScreen = false,
      storyId = null,
      isUnknown = false;

  AppRoutePath.unknown()
    : isLoginScreen = false,
      isRegisterScreen = false,
      isMainScreen = false,
      isUnknown = true,
      isDetailScreen = false,
      storyId = null,
      tabIndex = null;

  // modified to indicate that detail screen is also part of main screen
  // ensures that the main screen remains in the stack
  AppRoutePath.detailScreen(this.storyId)
    : isLoginScreen = false,
      isRegisterScreen = false,
      isMainScreen = true, // keep main screen on stack
      isUnknown = false,
      isDetailScreen = true,
      tabIndex = null;
}
