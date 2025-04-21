import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:universal_html/js.dart' as js;

class MapsEnvironment {
  static Future<void> initialize() async {
    if (!kIsWeb) {
      await dotenv.load(fileName: "assets/.env");
    }
  }

  static String get mapsCoApiKey {
    if (kIsWeb) {
      try {
        final env = js.context['ENV'];
        if (env != null) {
          final apiKey = js.JsObject.fromBrowserObject(env)['GEOCODE_API_KEY'];
          if (apiKey != null) {
            return apiKey.toString();
          }
        }
      } catch (e) {
        debugPrint('Error accessing ENV from JavaScript: $e');
      }
      return 'NO_API_KEY';
    } else {
      return dotenv.get('GEOCODE_API_KEY', fallback: 'NO_API_KEY');
    }
  }
}
