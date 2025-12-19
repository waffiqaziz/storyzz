import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storyzz/core/data/networking/api/services/maps_api_services.dart';
import 'package:storyzz/core/data/networking/api/services/story_api_services.dart';
import 'package:storyzz/core/data/repositories/auth_repository.dart';
import 'package:storyzz/core/data/repositories/maps_repository.dart';
import 'package:storyzz/core/data/repositories/setting_repository.dart';
import 'package:storyzz/core/data/repositories/story_repository.dart';
import 'package:storyzz/core/navigation/app_router.dart';
import 'package:storyzz/core/providers/address_provider.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/core/providers/auth_provider.dart';
import 'package:storyzz/core/providers/settings_provider.dart';
import 'package:storyzz/core/providers/story_provider.dart';
import 'package:storyzz/core/utils/constants.dart';
import 'package:storyzz/features/detail/presentation/providers/geocoding_provider.dart';
import 'package:storyzz/features/map/presentations/providers/map_provider.dart';
import 'package:storyzz/features/upload_story/presentation/providers/upload_location_loading_provider.dart';
import 'package:storyzz/features/upload_story/presentation/providers/upload_map_controller_provider.dart';
import 'package:storyzz/features/upload_story/presentation/providers/upload_story_provider.dart';
import 'package:storyzz/my_app.dart';

/// Used to initialize all providers and services in the app.
class AppRoot extends StatelessWidget {
  final SharedPreferences prefs;

  const AppRoot({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => SettingRepository(prefs)),
        Provider(
          create: (_) => StoryApiServices(
            httpClient: http.Client(),
            appService: AppService(),
          ),
        ),
        Provider(create: (_) => MapsApiService(httpClient: http.Client())),
        Provider(
          create: (context) =>
              AuthRepository(prefs, context.read<StoryApiServices>()),
        ),
        Provider(
          create: (context) =>
              StoryRepository(context.read<StoryApiServices>()),
        ),
        Provider(
          create: (context) => MapsRepository(context.read<MapsApiService>()),
        ),
        ChangeNotifierProvider(create: (_) => GeocodingProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(
          create: (context) => UploadLocationLoadingProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UploadMapControllerProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(context.read<AuthRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) => UploadStoryProvider(
            storyRepository: context.read<StoryRepository>(),
            appService: AppService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => StoryProvider(context.read<StoryRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              SettingsProvider(context.read<SettingRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) => MapProvider(
            authProvider: context.read<AuthProvider>(),
            storyProvider: context.read<StoryProvider>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => AddressProvider(context.read<MapsRepository>()),
        ),
        Provider(
          create: (context) => AppRouter(
            appProvider: context.read<AppProvider>(),
            authProvider: context.read<AuthProvider>(),
          ),
        ),
      ],
      child: MyApp(),
    );
  }
}
