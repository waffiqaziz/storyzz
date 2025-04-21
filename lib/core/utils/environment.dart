import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapsEnvironment {
  static Future<void> initialize() async {
    await dotenv.load(fileName: "assets/.env");
  }

  static String get mapsCoApiKey {
    return dotenv.get('GEOCODE_API_KEY', fallback: 'NO_API_KEY');
  }
}
