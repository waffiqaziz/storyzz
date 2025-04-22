enum BuildVariant { free, paid }

/// Configuration class for app build variants (free vs. paid).
///
/// Determines variant-specific behavior at runtime using a compile-time
/// constant set via the `--dart-define=IS_PAID_VERSION=true` flag. or
/// `--flavor paid`
///
/// Use [isPaidVersion] or [isFreeVersion] to check the current variant.
/// [appName] returns the app title based on the variant.
/// [canAddLocation] toggles location features availability.
class BuildConfig {
  static const BuildVariant _buildVariant =
      // This will be replaced during build time based on the flavor
      bool.fromEnvironment('IS_PAID_VERSION')
          ? BuildVariant.paid
          : BuildVariant.free;

  static bool get isPaidVersion => _buildVariant == BuildVariant.paid;
  static bool get isFreeVersion => _buildVariant == BuildVariant.free;

  static String get appName =>
      isPaidVersion ? 'Storyzz Premium' : 'Storyzz Free';

  static bool get canAddLocation => isPaidVersion;
}
