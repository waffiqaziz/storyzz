import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storyzz/app_root.dart';
import 'package:storyzz/core/utils/environment.dart';
import 'package:storyzz/core/variant/build_configuration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MapsEnvironment.initialize();
  final prefs = await SharedPreferences.getInstance();

  if (!kIsWeb) {
    debugPrint(
      'Running ${BuildConfig.isPaidVersion ? "PAID" : "FREE"} version',
    );
  }
  runApp(AppRoot(prefs: prefs));
}
