import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:universal_html/js.dart' as js;

/// Wrapper for JavaScript context to access ENV variables
class JsContextWrapper {
  String? getApiKey() {
    try {
      final env = js.context['ENV'];
      if (env != null) {
        final apiKey = js.JsObject.fromBrowserObject(env)['GEOCODE_API_KEY'];
        if (apiKey != null) {
          return apiKey.toString();
        }
      }
    } catch (e) {
      log('Error accessing JS context: $e');
      return null;
    }
    return null;
  }
}

/// Environment provider abstraction to make testing easier
abstract class EnvironmentProvider {
  bool get isWebPlatform;
  Future<void> loadEnvFile(String fileName);
  String getEnvValue(String key, {required String fallback});
}

/// Default implementation of EnvironmentProvider that uses real implementations
///
/// This class is responsible for loading environment variables and providing
/// access to them. It uses the flutter_dotenv package to load variables from
/// a .env file and provides a method to access the API key from the JavaScript
/// context when running on the web platform.
class DefaultEnvironmentProvider implements EnvironmentProvider {
  final JsContextWrapper _jsContextWrapper;

  DefaultEnvironmentProvider({JsContextWrapper? jsContextWrapper})
    : _jsContextWrapper = jsContextWrapper ?? JsContextWrapper();

  @override
  bool get isWebPlatform => kIsWeb;

  @override
  Future<void> loadEnvFile(String fileName) async {
    await dotenv.load(fileName: fileName);
  }

  @override
  String getEnvValue(String key, {required String fallback}) {
    return dotenv.get(key, fallback: fallback);
  }

  String? getJsApiKey() {
    return _jsContextWrapper.getApiKey();
  }
}

/// MapsEnvironment class to manage environment variables and API keys
///
/// This class is responsible for loading environment variables and providing
class MapsEnvironment {
  static EnvironmentProvider _environmentProvider =
      DefaultEnvironmentProvider();
  static JsContextWrapper _jsContextWrapper = JsContextWrapper();

  /// For testing purposes only - allows injecting mock providers
  static void injectDependencies({
    EnvironmentProvider? environmentProvider,
    JsContextWrapper? jsContextWrapper,
  }) {
    if (environmentProvider != null) {
      _environmentProvider = environmentProvider;
    }
    if (jsContextWrapper != null) {
      _jsContextWrapper = jsContextWrapper;
    }
  }

  /// Reset injected dependencies to defaults
  static void resetDependencies() {
    _environmentProvider = DefaultEnvironmentProvider();
    _jsContextWrapper = JsContextWrapper();
  }

  /// Initialize the environment
  static Future<void> initialize() async {
    if (!_environmentProvider.isWebPlatform) {
      await _environmentProvider.loadEnvFile("assets/.env");
    }
  }

  /// Get the maps API key
  ///
  /// This method retrieves the API key for the maps service. If running on
  /// the web platform, it tries to access the key from the JavaScript context.
  /// If not found, it falls back to the .env file. If the key is not found
  /// in either place, it returns a default value of 'NO_API_KEY'.
  static String get mapsCoApiKey {
    if (_environmentProvider.isWebPlatform) {
      try {
        final apiKey = _jsContextWrapper.getApiKey();
        if (apiKey != null) {
          return apiKey;
        }
      } catch (e) {
        log('Error accessing ENV from JavaScript: $e');
      }
      return 'NO_API_KEY';
    } else {
      return _environmentProvider.getEnvValue(
        'GEOCODE_API_KEY',
        fallback: 'NO_API_KEY',
      );
    }
  }
}
