import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapsEnvironment {
  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
  }

  static String get mapsCoApiKey {
    return dotenv.env['GEOCODE_API_KEY'] ??
        const String.fromEnvironment(
          'GEOCODE_API_KEY',
          defaultValue: 'default_placeholder_key',
        );
  }
}
