import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storyzz/app_root.dart';
import 'package:storyzz/core/utils/environment.dart';
import 'package:storyzz/core/variant/build_configuration.dart';
import 'package:storyzz/common/url_strategy.dart';

void main() async {
  // ensure that plugin services are initialized before using any plugins.
  // this is especially important for plugins that require platform channels.
  WidgetsFlutterBinding.ensureInitialized();

  usePathUrlStrategy();

  // show url changes
  GoRouter.optionURLReflectsImperativeAPIs = true;

  // init environment variables
  await MapsEnvironment.initialize();

  // init build variant configuration
  await BuildConfig.initialize();

  // init shared preferences
  final prefs = await SharedPreferences.getInstance();

  // initialize all providers and services here
  runApp(AppRoot(prefs: prefs));
}
