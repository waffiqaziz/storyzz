import "package:flutter/material.dart";
import "package:storyzz/core/design/insets.dart";

/// Custom colors and theme
class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);
  static EdgeInsetsGeometry buttonPadding = Insets.h16v12;

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff006a68),
      surfaceTint: Color(0xff006a68),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff9cf1ee),
      onPrimaryContainer: Color(0xff00504e),
      secondary: Color(0xff4a6362),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffcce8e6),
      onSecondaryContainer: Color(0xff324b4a),
      tertiary: Color(0xff4a607b),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffd2e4ff),
      onTertiaryContainer: Color(0xff324863),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff4fbf9),
      onSurface: Color(0xff161d1c),
      onSurfaceVariant: Color(0xff3f4948),
      outline: Color(0xff6f7978),
      outlineVariant: Color(0xffbec9c7),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3231),
      inversePrimary: Color(0xff80d5d2),
      primaryFixed: Color(0xff9cf1ee),
      onPrimaryFixed: Color(0xff00201f),
      primaryFixedDim: Color(0xff80d5d2),
      onPrimaryFixedVariant: Color(0xff00504e),
      secondaryFixed: Color(0xffcce8e6),
      onSecondaryFixed: Color(0xff051f1f),
      secondaryFixedDim: Color(0xffb0ccca),
      onSecondaryFixedVariant: Color(0xff324b4a),
      tertiaryFixed: Color(0xffd2e4ff),
      onTertiaryFixed: Color(0xff031d35),
      tertiaryFixedDim: Color(0xffb2c8e8),
      onTertiaryFixedVariant: Color(0xff324863),
      surfaceDim: Color(0xffd5dbda),
      surfaceBright: Color(0xfff4fbf9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5f4),
      surfaceContainer: Color(0xffe9efee),
      surfaceContainerHigh: Color(0xffe3e9e8),
      surfaceContainerHighest: Color(0xffdde4e3),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff80d5d2),
      surfaceTint: Color(0xff80d5d2),
      onPrimary: Color(0xff003736),
      primaryContainer: Color(0xff00504e),
      onPrimaryContainer: Color(0xff9cf1ee),
      secondary: Color(0xffb0ccca),
      onSecondary: Color(0xff1b3534),
      secondaryContainer: Color(0xff324b4a),
      onSecondaryContainer: Color(0xffcce8e6),
      tertiary: Color(0xffb2c8e8),
      onTertiary: Color(0xff1b324b),
      tertiaryContainer: Color(0xff324863),
      onTertiaryContainer: Color(0xffd2e4ff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff0e1514),
      onSurface: Color(0xffdde4e3),
      onSurfaceVariant: Color(0xffbec9c7),
      outline: Color(0xff889392),
      outlineVariant: Color(0xff3f4948),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdde4e3),
      inversePrimary: Color(0xff006a68),
      primaryFixed: Color(0xff9cf1ee),
      onPrimaryFixed: Color(0xff00201f),
      primaryFixedDim: Color(0xff80d5d2),
      onPrimaryFixedVariant: Color(0xff00504e),
      secondaryFixed: Color(0xffcce8e6),
      onSecondaryFixed: Color(0xff051f1f),
      secondaryFixedDim: Color(0xffb0ccca),
      onSecondaryFixedVariant: Color(0xff324b4a),
      tertiaryFixed: Color(0xffd2e4ff),
      onTertiaryFixed: Color(0xff031d35),
      tertiaryFixedDim: Color(0xffb2c8e8),
      onTertiaryFixedVariant: Color(0xff324863),
      surfaceDim: Color(0xff0e1514),
      surfaceBright: Color(0xff343a3a),
      surfaceContainerLowest: Color(0xff090f0f),
      surfaceContainerLow: Color(0xff161d1c),
      surfaceContainer: Color(0xff1a2120),
      surfaceContainerHigh: Color(0xff252b2b),
      surfaceContainerHighest: Color(0xff2f3636),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  ThemeData lightWithCustomStyles() {
    final baseTheme = light();
    return baseTheme.copyWith(
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: .circular(25),
          borderSide: .none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: .circular(25),
          borderSide: BorderSide(color: baseTheme.colorScheme.primary),
        ),
        contentPadding: Insets.all16,
      ),
    );
  }

  ThemeData darkWithCustomStyles() {
    final baseTheme = dark();
    return baseTheme.copyWith(
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade800,
        border: OutlineInputBorder(
          borderRadius: .circular(25),
          borderSide: .none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: .circular(25),
          borderSide: BorderSide(color: baseTheme.colorScheme.primary),
        ),
        contentPadding: Insets.all16,
      ),
    );
  }

  ThemeData theme(ColorScheme colorScheme) {
    final textTheme = this.textTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      fontFamily: 'Nunito',
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: colorScheme.surfaceContainerLowest,
          backgroundColor: colorScheme.primary,
          elevation: 0,
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          padding: .all(20),
          shape: RoundedRectangleBorder(borderRadius: .circular(50)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        behavior: SnackBarBehavior.floating,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: .circular(12)),
        contentTextStyle: TextStyle(fontWeight: .w500, color: Colors.black87),
      ),
      scaffoldBackgroundColor: colorScheme.surface,
      canvasColor: colorScheme.surface,
      navigationDrawerTheme: NavigationDrawerThemeData(
        surfaceTintColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        indicatorShape: RoundedRectangleBorder(borderRadius: .circular(8)),
      ),
    );
  }
}

InputDecoration customInputDecoration({
  required String label,
  IconData? prefixIcon,
  Widget? suffixIcon,
  EdgeInsets prefixMargin = const .only(left: 14.0),
  EdgeInsets suffixMargin = const .only(right: 8.0),
}) {
  return InputDecoration(
    labelText: label,
    prefixIcon: prefixIcon != null
        ? Container(margin: prefixMargin, child: Icon(prefixIcon))
        : null,
    suffixIcon: suffixIcon != null
        ? Container(margin: suffixMargin, child: suffixIcon)
        : null,
  );
}
