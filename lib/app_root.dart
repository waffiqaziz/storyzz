import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storyzz/core/data/networking/services/api_services.dart';
import 'package:storyzz/core/data/repository/auth_repository.dart';
import 'package:storyzz/core/data/repository/setting_repository.dart';
import 'package:storyzz/core/data/repository/story_repository.dart';
import 'package:storyzz/core/provider/auth_provider.dart';
import 'package:storyzz/core/provider/settings_provider.dart';
import 'package:storyzz/core/provider/story_provider.dart';
import 'package:storyzz/core/provider/upload_story_provider.dart';
import 'package:storyzz/core/routes/my_route_delegate.dart';
import 'package:storyzz/core/routes/my_route_information_parser.dart';
import 'package:storyzz/features/map/provider/map_provider.dart';
import 'package:storyzz/my_app.dart';

class AppRoot extends StatelessWidget {
  final SharedPreferences prefs;

  const AppRoot({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => SettingRepository(prefs)),
        Provider(create: (_) => MyRouteInformationParser()),
        Provider(create: (_) => ApiServices(httpClient: http.Client())),
        Provider(
          create:
              (context) => AuthRepository(prefs, context.read<ApiServices>()),
        ),
        Provider(
          create: (context) => StoryRepository(context.read<ApiServices>()),
        ),

        ChangeNotifierProvider(
          create: (context) => AuthProvider(context.read<AuthRepository>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) => UploadStoryProvider(context.read<StoryRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) => StoryProvider(context.read<StoryRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) => MyRouteDelegate(context.read<AuthProvider>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) => SettingsProvider(context.read<SettingRepository>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) => MapProvider(
                authProvider: context.read<AuthProvider>(),
                storyProvider: context.read<StoryProvider>(),
              ),
        ),
      ],
      child: MyApp(),
    );
  }
}
