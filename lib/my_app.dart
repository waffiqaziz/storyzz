import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storyzz/core/designsystem/theme.dart';
import 'package:storyzz/core/designsystem/util.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/provider/settings_provider.dart';
import 'package:storyzz/core/routes/my_route_delegate.dart';
import 'package:storyzz/core/routes/my_route_information_parser.dart';

class MyApp extends StatefulWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final isDark = settingsProvider.setting?.isDark ?? false;

    TextTheme textTheme = createTextTheme(context);
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp.router(
      title: 'Storyzz',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: settingsProvider.locale,
      theme: theme.lightWithCustomStyles(),
      darkTheme: theme.darkWithCustomStyles(),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: true, // show debug banner
      routeInformationParser: context.read<MyRouteInformationParser>(),
      routerDelegate: context.read<MyRouteDelegate>(),
    );
  }
}
