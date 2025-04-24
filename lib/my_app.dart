import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/designsystem/theme.dart';
import 'package:storyzz/core/designsystem/util.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/settings_provider.dart';
import 'package:storyzz/core/routes/my_route_delegate.dart';
import 'package:storyzz/core/routes/my_route_information_parser.dart';
import 'package:storyzz/core/variant/build_configuration.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final isDark = settingsProvider.setting?.isDark ?? false;

    MaterialTheme theme = MaterialTheme(createTextTheme(context));

    return MaterialApp.router(
      title: BuildConfig.appName,
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
