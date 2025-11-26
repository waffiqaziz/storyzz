import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storyzz/core/data/model/user.dart';
import 'package:storyzz/core/data/networking/services/api_services.dart';
import 'package:storyzz/core/data/networking/services/maps_api_services.dart';
import 'package:storyzz/core/data/repository/auth_repository.dart';
import 'package:storyzz/core/data/repository/maps_repository.dart';
import 'package:storyzz/core/data/repository/setting_repository.dart';
import 'package:storyzz/core/data/repository/story_repository.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/address_provider.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/core/providers/auth_provider.dart';
import 'package:storyzz/core/providers/geocoding_provider.dart';
import 'package:storyzz/core/providers/settings_provider.dart';
import 'package:storyzz/core/providers/story_provider.dart';
import 'package:storyzz/core/utils/constants.dart';
import 'package:storyzz/core/utils/environment.dart';
import 'package:storyzz/features/map/provider/map_provider.dart';
import 'package:storyzz/features/upload_story/presentation/providers/upload_story_provider.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockAddressProvider extends Mock implements AddressProvider {}

class MockAuthProvider extends Mock implements AuthProvider {}

class MockSettingsProvider extends Mock implements SettingsProvider {}

class MockStoryProvider extends Mock implements StoryProvider {}

class MockGeocodingProvider extends Mock implements GeocodingProvider {}

class MockAppProvider extends Mock implements AppProvider {}

class MockMapProvider extends Mock implements MapProvider {}

class MockUploadStoryProvider extends Mock implements UploadStoryProvider {}

class MockMapsRepository extends Mock implements MapsRepository {}

class MockStoryRepository extends Mock implements StoryRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockApiServices extends Mock implements ApiServices {}

class MockGoRouter extends Mock implements GoRouter {}

class MockMapsApiService extends Mock implements MapsApiService {}

class MockSettingRepository extends Mock implements SettingRepository {}

class MockPlatformDispatcher extends Mock implements PlatformDispatcher {}

class MockEnvironmentProvider extends Mock implements EnvironmentProvider {}

class MockJsContextWrapper extends Mock implements JsContextWrapper {}

class MockFile extends Mock implements File {}

// ignore_for_file: non_constant_identifier_names
class MockAppLocalizations extends Mock implements AppLocalizations {
  AppLocalizations? call(BuildContext context);

  @override
  String get address_not_available => 'Address Not Available';

  @override
  String get d_ago_singular => 'day ago';

  @override
  String get d_ago_plural => 'days ago';

  @override
  String get h_ago_singular => 'hour ago';

  @override
  String get h_ago_plural => 'hours ago';

  @override
  String get m_ago_singular => 'minute ago';

  @override
  String get m_ago_plural => 'minutes ago';

  @override
  String get just_now => 'just now';

  @override
  String get loading_address => 'Loading address...';
}

class MockBuildContext extends Mock implements BuildContext {}

class MockUser extends Mock implements User {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockAppService extends Mock implements AppService {}

class MockStreamedResponse extends Mock implements http.StreamedResponse {}
