import 'package:flutter/material.dart';
import 'package:storyzz/core/routes/app_route_path.dart';

class MyRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = Uri.parse(routeInformation.uri.toString());

    if (uri.pathSegments.isEmpty) {
      return AppRoutePath.login();
    }

    if (uri.pathSegments.first == 'login') {
      return AppRoutePath.login();
    }

    if (uri.pathSegments.first == 'register') {
      return AppRoutePath.register();
    }

    if (uri.pathSegments.first == 'home') {
      // Check if there's a tab parameter
      final tabIndex = int.tryParse(uri.queryParameters['tab'] ?? '0') ?? 0;
      return AppRoutePath.home(tabIndex: tabIndex);
    }

    return AppRoutePath.unknown();
  }

  @override
  RouteInformation restoreRouteInformation(AppRoutePath path) {
    if (path.isUnknown) {
      return RouteInformation(uri: Uri.parse('/404'));
    }
    if (path.isLoginScreen) {
      return RouteInformation(uri: Uri.parse('/login'));
    }
    if (path.isRegisterScreen) {
      return RouteInformation(uri: Uri.parse('/register'));
    }
    if (path.isMainScreen) {
      // Include the tab index in the URI
      return RouteInformation(
        uri: Uri.parse('/home?tab=${path.tabIndex ?? 0}'),
      );
    }
    return RouteInformation(uri: Uri.parse('/'));
  }
}
