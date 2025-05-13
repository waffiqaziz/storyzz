import 'package:package_info_plus/package_info_plus.dart';

enum BuildVariant { free, paid }

/// Configuration class for app build variants (free vs. paid).
///
/// Determines variant-specific behavior at runtime by detecting the app's
/// package name suffix, which is set automatically when running with
/// `--flavor paid` (resulting in package name ending with ".paid").
///
/// This approach avoids compile-time constants and uses runtime detection
/// to determine the app variant, making it compatible with Flutter's flavor
/// system without requiring additional dart-define parameters.
///
/// Use [isPaidVersion] or [isFreeVersion] to check the current variant.
/// [appName] returns the app title based on the variant.
/// [canAddLocation] toggles location features availability.
///
/// IMPORTANT: Always call [initialize] before using this class, typically
/// in app's main() function before runApp().
class BuildConfig {
  static bool? _isPaidVersion;
  static bool _initialized = false;

  static void reset() {
    _isPaidVersion = false;
    _initialized = false;
  }

  static Future<void> initialize() async {
    if (_initialized) return;

    final packageInfo = await PackageInfo.fromPlatform();
    // Check if the application ID contains ".paid"
    _isPaidVersion = packageInfo.packageName.contains('.paid');
    _initialized = true;
  }

  static bool get isPaidVersion {
    assert(_initialized, 'BuildConfig must be initialized before use');
    return _isPaidVersion ?? false;
  }

  static bool get isFreeVersion => !isPaidVersion;
  static String get appName =>
      isPaidVersion ? 'Storyzz Premium' : 'Storyzz Free';
  static bool get canAddLocation => isPaidVersion;
}
