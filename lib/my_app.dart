import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/design/theme.dart';
import 'package:storyzz/core/design/util.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/navigation/app_router.dart';
import 'package:storyzz/core/providers/settings_provider.dart';
import 'package:storyzz/core/variant/build_configuration.dart';

/// Used to initialize the app and set up the main MaterialApp widget.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    late String appName;
    final settingsProvider = context.watch<SettingsProvider>();
    final isDark = settingsProvider.setting?.isDark ?? false;
    final router = context.read<AppRouter>().router;

    MaterialTheme theme = MaterialTheme(createTextTheme(context));

    /// Set the app name based on the build configuration
    /// This is for differentiating between free and paid versions of the app
    if (kIsWeb) {
      final appFlavor = const String.fromEnvironment(
        'APP_FLAVOR',
        defaultValue: 'free',
      );
      final isPaidVersion = appFlavor == 'paid';
      appName = isPaidVersion == true ? "Storyzz Premium" : "Storyzz Free";
    } else {
      appName = BuildConfig.appName;
    }

    return MaterialApp.router(
      title: appName,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: settingsProvider.locale,
      theme: theme.lightWithCustomStyles(),
      darkTheme: theme.darkWithCustomStyles(),
      themeMode: isDark ? .dark : .light,
      debugShowCheckedModeBanner: true, // show debug banner
      routerConfig: router,
    );
  }
}
