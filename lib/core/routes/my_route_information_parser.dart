import 'package:flutter/material.dart';
import 'package:storyzz/core/routes/app_route_path.dart';

class MyRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = Uri.parse(routeInformation.uri.toString());

    if (uri.pathSegments.isEmpty) {
      return AppRoutePath.unknown();
    }

    if (uri.pathSegments.first == 'login') {
      return AppRoutePath.login();
    }

    if (uri.pathSegments.first == 'register') {
      return AppRoutePath.register();
    }

    if (uri.pathSegments.first == 'home') {
      return AppRoutePath.home(tabIndex: 0);
    }

    if (uri.pathSegments.first == 'upload') {
      return AppRoutePath.home(tabIndex: 1);
    }

    if (uri.pathSegments.first == 'settings') {
      return AppRoutePath.home(tabIndex: 2);
    }

    if (uri.pathSegments.first == 'story' && uri.pathSegments.length == 2) {
      return AppRoutePath.detailScreen(uri.pathSegments[1]);
    }

    return AppRoutePath.unknown();
  }

  @override
  RouteInformation restoreRouteInformation(AppRoutePath configuration) {
    if (configuration.isUnknown) {
      return RouteInformation(uri: Uri.parse('/404'));
    }
    if (configuration.isLoginScreen) {
      return RouteInformation(uri: Uri.parse('/login'));
    }
    if (configuration.isRegisterScreen) {
      return RouteInformation(uri: Uri.parse('/register'));
    }
    if (configuration.isDetailScreen) {
      return RouteInformation(
        uri: Uri.parse('/story/${configuration.storyId}'),
      );
    }
    if (configuration.isMainScreen) {
      final tabIndex = configuration.tabIndex ?? 0;
      if (tabIndex == 0) {
        return RouteInformation(uri: Uri.parse('/home'));
      }
      if (tabIndex == 1) {
        return RouteInformation(uri: Uri.parse('/upload'));
      }
      if (tabIndex == 2) {
        return RouteInformation(uri: Uri.parse('/settings'));
      }
      return RouteInformation(uri: Uri.parse('/'));
    }
    return RouteInformation(uri: Uri.parse('/'));
  }
}
