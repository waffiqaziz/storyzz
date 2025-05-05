import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:storyzz/core/data/repository/auth_repository.dart';
import 'package:storyzz/core/data/repository/maps_repository.dart';
import 'package:storyzz/core/data/repository/setting_repository.dart';
import 'package:storyzz/core/data/repository/story_repository.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/address_provider.dart';
import 'package:storyzz/core/providers/auth_provider.dart';
import 'package:storyzz/core/providers/settings_provider.dart';
import 'package:storyzz/core/providers/story_provider.dart';
import 'package:storyzz/core/utils/environment.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockAddressProvider extends Mock implements AddressProvider {}

class MockAuthProvider extends Mock implements AuthProvider {}

class MockSettingsProvider extends Mock implements SettingsProvider {}

class MockStoryProvider extends Mock implements StoryProvider {}

class MockMapsRepository extends Mock implements MapsRepository {}

class MockStoryRepository extends Mock implements StoryRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSettingRepository extends Mock implements SettingRepository {}

class MockPlatformDispatcher extends Mock implements PlatformDispatcher {}

class MockEnvironmentProvider extends Mock implements EnvironmentProvider {}

class MockJsContextWrapper extends Mock implements JsContextWrapper {}

class MockFile extends Mock implements File {}

class MockAppLocalizations extends Mock implements AppLocalizations {
  @override
  String get address_not_available => 'Address Not Available';
}

class MockBuildContext extends Mock implements BuildContext {}
