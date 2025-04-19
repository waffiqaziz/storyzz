import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storyzz/app_root.dart';
import 'package:storyzz/core/utils/environment.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MapsEnvironment.initialize();
  final prefs = await SharedPreferences.getInstance();

  runApp(AppRoot(prefs: prefs));
}
