import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

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

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003d3c),
      surfaceTint: Color(0xff006a68),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff177977),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff213a3a),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff587271),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff213751),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff596f8b),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff4fbf9),
      onSurface: Color(0xff0c1212),
      onSurfaceVariant: Color(0xff2e3837),
      outline: Color(0xff4a5454),
      outlineVariant: Color(0xff656f6e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3231),
      inversePrimary: Color(0xff80d5d2),
      primaryFixed: Color(0xff177977),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff005f5e),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff587271),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff405958),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff596f8b),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff405671),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc1c8c7),
      surfaceBright: Color(0xfff4fbf9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff5f4),
      surfaceContainer: Color(0xffe3e9e8),
      surfaceContainerHigh: Color(0xffd8dedd),
      surfaceContainerHighest: Color(0xffccd3d2),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003231),
      surfaceTint: Color(0xff006a68),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff005251),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff17302f),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff344e4d),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff162d46),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff354b65),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff4fbf9),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff242e2d),
      outlineVariant: Color(0xff414b4a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3231),
      inversePrimary: Color(0xff80d5d2),
      primaryFixed: Color(0xff005251),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff003938),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff344e4d),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff1e3736),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff354b65),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff1d344d),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb3bab9),
      surfaceBright: Color(0xfff4fbf9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffecf2f1),
      surfaceContainer: Color(0xffdde4e3),
      surfaceContainerHigh: Color(0xffcfd6d5),
      surfaceContainerHighest: Color(0xffc1c8c7),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
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

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff96ebe8),
      surfaceTint: Color(0xff80d5d2),
      onPrimary: Color(0xff002b2a),
      primaryContainer: Color(0xff479e9c),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffc6e2e0),
      onSecondary: Color(0xff102a29),
      secondaryContainer: Color(0xff7b9694),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffc7deff),
      onTertiary: Color(0xff0f2740),
      tertiaryContainer: Color(0xff7c92b0),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff0e1514),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd4dedd),
      outline: Color(0xffaab4b3),
      outlineVariant: Color(0xff889291),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdde4e3),
      inversePrimary: Color(0xff005150),
      primaryFixed: Color(0xff9cf1ee),
      onPrimaryFixed: Color(0xff001414),
      primaryFixedDim: Color(0xff80d5d2),
      onPrimaryFixedVariant: Color(0xff003d3c),
      secondaryFixed: Color(0xffcce8e6),
      onSecondaryFixed: Color(0xff001414),
      secondaryFixedDim: Color(0xffb0ccca),
      onSecondaryFixedVariant: Color(0xff213a3a),
      tertiaryFixed: Color(0xffd2e4ff),
      onTertiaryFixed: Color(0xff001225),
      tertiaryFixedDim: Color(0xffb2c8e8),
      onTertiaryFixedVariant: Color(0xff213751),
      surfaceDim: Color(0xff0e1514),
      surfaceBright: Color(0xff3f4645),
      surfaceContainerLowest: Color(0xff040808),
      surfaceContainerLow: Color(0xff181f1e),
      surfaceContainer: Color(0xff232929),
      surfaceContainerHigh: Color(0xff2d3433),
      surfaceContainerHighest: Color(0xff383f3e),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffaafffc),
      surfaceTint: Color(0xff80d5d2),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff7cd1ce),
      onPrimaryContainer: Color(0xff000e0d),
      secondary: Color(0xffd9f6f4),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffadc8c6),
      onSecondaryContainer: Color(0xff000e0d),
      tertiary: Color(0xffe9f0ff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffaec4e4),
      onTertiaryContainer: Color(0xff000c1c),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff0e1514),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffe8f2f1),
      outlineVariant: Color(0xffbac5c4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdde4e3),
      inversePrimary: Color(0xff005150),
      primaryFixed: Color(0xff9cf1ee),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff80d5d2),
      onPrimaryFixedVariant: Color(0xff001414),
      secondaryFixed: Color(0xffcce8e6),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffb0ccca),
      onSecondaryFixedVariant: Color(0xff001414),
      tertiaryFixed: Color(0xffd2e4ff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffb2c8e8),
      onTertiaryFixedVariant: Color(0xff001225),
      surfaceDim: Color(0xff0e1514),
      surfaceBright: Color(0xff4b5151),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1a2120),
      surfaceContainer: Color(0xff2b3231),
      surfaceContainerHigh: Color(0xff363d3c),
      surfaceContainerHighest: Color(0xff414847),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData lightWithCustomStyles() {
    final baseTheme = light();
    return baseTheme.copyWith(
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: baseTheme.colorScheme.primary),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: baseTheme.colorScheme.primary,
          elevation: 0,
          textStyle: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: baseTheme.colorScheme.surfaceContainerHigh,
        behavior: SnackBarBehavior.floating,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentTextStyle: TextStyle(
          fontWeight: FontWeight.w400,
          color: baseTheme.colorScheme.onSurface,
        ),
      ),
    );
  }

  // Same for dark theme
  ThemeData darkWithCustomStyles() {
    final baseTheme = dark();
    return baseTheme.copyWith(
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade800,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: baseTheme.colorScheme.primary),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black, // text color
          backgroundColor: baseTheme.colorScheme.primary,
          elevation: 0,
          textStyle: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: baseTheme.colorScheme.surfaceContainerHigh,
        behavior: SnackBarBehavior.floating,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentTextStyle: TextStyle(
          fontWeight: FontWeight.w400,
          color: baseTheme.colorScheme.onSurface,
        ),
      ),
    );
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => [];
}

InputDecoration customInputDecoration({
  required String label,
  IconData? prefixIcon,
  Widget? suffixIcon,
  EdgeInsets prefixMargin = const EdgeInsets.only(left: 10.0),
  EdgeInsets suffixMargin = const EdgeInsets.only(right: 8.0),
}) {
  return InputDecoration(
    labelText: label,
    prefixIcon:
        prefixIcon != null
            ? Container(margin: prefixMargin, child: Icon(prefixIcon))
            : null,
    suffixIcon:
        suffixIcon != null
            ? Container(margin: suffixMargin, child: suffixIcon)
            : null,
  );
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
