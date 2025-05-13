import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storyzz/core/design/theme.dart';

void main() {
  late MaterialTheme materialTheme;
  late TextTheme textTheme;

  setUp(() {
    textTheme = const TextTheme();
    materialTheme = MaterialTheme(textTheme);
  });

  group('MaterialTheme', () {
    test('should create instance with text theme', () {
      expect(materialTheme.textTheme, equals(textTheme));
    });

    group('Light Theme', () {
      late ColorScheme lightScheme;
      late ThemeData lightTheme;

      setUp(() {
        lightScheme = MaterialTheme.lightScheme();
        lightTheme = materialTheme.light();
      });

      test('should create light color scheme with correct properties', () {
        expect(lightScheme.brightness, equals(Brightness.light));
        expect(lightScheme.primary, equals(const Color(0xff006a68)));
        expect(lightScheme.surfaceTint, equals(const Color(0xff006a68)));
      });

      test('should create light theme with correct properties', () {
        expect(lightTheme.brightness, equals(Brightness.light));
        expect(lightTheme.useMaterial3, isTrue);
        expect(lightTheme.colorScheme, equals(lightScheme));
      });

      test('should have correct elevated button theme', () {
        final theme = materialTheme.light();
        final buttonStyle = theme.elevatedButtonTheme.style;

        expect(
          buttonStyle?.padding?.resolve({}),
          equals(const EdgeInsets.symmetric(vertical: 16)),
        );
        expect(buttonStyle?.elevation?.resolve({}), equals(0));
        expect(
          buttonStyle?.shape?.resolve({}),
          isA<RoundedRectangleBorder>().having(
            (shape) => shape.borderRadius,
            'borderRadius',
            equals(BorderRadius.circular(25)),
          ),
        );
      });

      test('should have correct snackbar theme', () {
        final theme = materialTheme.light();
        final snackBarTheme = theme.snackBarTheme;

        expect(snackBarTheme.behavior, equals(SnackBarBehavior.floating));
        expect(snackBarTheme.elevation, equals(6));
        expect(
          snackBarTheme.shape,
          isA<RoundedRectangleBorder>().having(
            (shape) => shape.borderRadius,
            'borderRadius',
            equals(BorderRadius.circular(12)),
          ),
        );
      });

      test('should apply correct text theme', () {
        final theme = materialTheme.light();

        expect(theme.textTheme.bodyMedium?.fontFamily, equals('Nunito'));
        expect(
          theme.textTheme.bodyMedium?.fontFamilyFallback,
          equals(['Nunito']),
        );
      });
    });

    group('Dark Theme', () {
      late ColorScheme darkScheme;
      late ThemeData darkTheme;

      setUp(() {
        darkScheme = MaterialTheme.darkScheme();
        darkTheme = materialTheme.dark();
      });

      test('should create dark color scheme with correct properties', () {
        expect(darkScheme.brightness, equals(Brightness.dark));
        expect(darkScheme.primary, equals(const Color(0xff80d5d2)));
        expect(darkScheme.surfaceTint, equals(const Color(0xff80d5d2)));
      });

      test('should create dark theme with correct properties', () {
        expect(darkTheme.brightness, equals(Brightness.dark));
        expect(darkTheme.useMaterial3, isTrue);
        expect(darkTheme.colorScheme, equals(darkScheme));
      });
    });

    group('Custom Styles', () {
      test(
        'lightWithCustomStyles should have correct input decoration theme',
        () {
          final theme = materialTheme.lightWithCustomStyles();
          final inputDecoration = theme.inputDecorationTheme;

          expect(inputDecoration.filled, isTrue);
          expect(inputDecoration.fillColor, equals(Colors.grey.shade100));
          expect(inputDecoration.border, isA<OutlineInputBorder>());
          expect(
            (inputDecoration.border as OutlineInputBorder).borderRadius,
            equals(BorderRadius.circular(25)),
          );
        },
      );

      test(
        'darkWithCustomStyles should have correct input decoration theme',
        () {
          final theme = materialTheme.darkWithCustomStyles();
          final inputDecoration = theme.inputDecorationTheme;

          expect(inputDecoration.filled, isTrue);
          expect(inputDecoration.fillColor, equals(Colors.grey.shade800));
          expect(inputDecoration.border, isA<OutlineInputBorder>());
          expect(
            (inputDecoration.border as OutlineInputBorder).borderRadius,
            equals(BorderRadius.circular(25)),
          );
        },
      );

      test(
        'lightMediumContrast should create theme with correct properties',
        () {
          final scheme = MaterialTheme.lightMediumContrastScheme();
          final theme = materialTheme.lightMediumContrast();

          expect(scheme.brightness, equals(Brightness.light));
          expect(scheme.primary, equals(const Color(0xff003d3c)));
          expect(theme.colorScheme, equals(scheme));
        },
      );

      test('lightHighContrast should create theme with correct properties', () {
        final scheme = MaterialTheme.lightHighContrastScheme();
        final theme = materialTheme.lightHighContrast();

        expect(scheme.brightness, equals(Brightness.light));
        expect(scheme.primary, equals(const Color(0xff003231)));
        expect(theme.colorScheme, equals(scheme));
      });

      test(
        'darkMediumContrast should create theme with correct properties',
        () {
          final scheme = MaterialTheme.darkMediumContrastScheme();
          final theme = materialTheme.darkMediumContrast();

          expect(scheme.brightness, equals(Brightness.dark));
          expect(scheme.primary, equals(const Color(0xff96ebe8)));
          expect(theme.colorScheme, equals(scheme));
        },
      );

      test('darkHighContrast should create theme with correct properties', () {
        final scheme = MaterialTheme.darkHighContrastScheme();
        final theme = materialTheme.darkHighContrast();

        expect(scheme.brightness, equals(Brightness.dark));
        expect(scheme.primary, equals(const Color(0xffaafffc)));
        expect(theme.colorScheme, equals(scheme));
      });

      group('Custom Input Decoration', () {
        test('should create input decoration with custom margins', () {
          final customMargin = const EdgeInsets.only(left: 20.0);
          final decoration = customInputDecoration(
            label: 'Test',
            prefixIcon: Icons.email,
            prefixMargin: customMargin,
          );

          expect(
            (decoration.prefixIcon as Container).margin,
            equals(customMargin),
          );
        });

        test('should create input decoration with default margins', () {
          final decoration = customInputDecoration(
            label: 'Test',
            prefixIcon: Icons.email,
          );

          expect(
            (decoration.prefixIcon as Container).margin,
            equals(const EdgeInsets.only(left: 10.0)),
          );
        });
      });

      group('Extended Colors', () {
        test('should create ExtendedColor with all required properties', () {
          final colorFamily = const ColorFamily(
            color: Colors.blue,
            onColor: Colors.white,
            colorContainer: Colors.lightBlue,
            onColorContainer: Colors.black,
          );

          final extendedColor = ExtendedColor(
            seed: Colors.blue,
            value: Colors.blue,
            light: colorFamily,
            lightHighContrast: colorFamily,
            lightMediumContrast: colorFamily,
            dark: colorFamily,
            darkHighContrast: colorFamily,
            darkMediumContrast: colorFamily,
          );

          expect(extendedColor.seed, equals(Colors.blue));
          expect(extendedColor.value, equals(Colors.blue));
          expect(extendedColor.light, equals(colorFamily));
          expect(extendedColor.dark, equals(colorFamily));
        });
      });

      test('should create input decoration with all properties', () {
        final decoration = customInputDecoration(
          label: 'Test Label',
          prefixIcon: Icons.search,
          suffixIcon: const Icon(Icons.clear),
        );

        expect(decoration.labelText, equals('Test Label'));
        expect(decoration.prefixIcon, isA<Container>());
        expect(decoration.suffixIcon, isA<Container>());
      });
    });

    test('extendedColors should return empty list by default', () {
      expect(materialTheme.extendedColors, isEmpty);
    });

    group('ColorFamily', () {
      test('should create instance with required colors', () {
        const family = ColorFamily(
          color: Colors.blue,
          onColor: Colors.white,
          colorContainer: Colors.lightBlue,
          onColorContainer: Colors.black,
        );

        expect(family.color, equals(Colors.blue));
        expect(family.onColor, equals(Colors.white));
        expect(family.colorContainer, equals(Colors.lightBlue));
        expect(family.onColorContainer, equals(Colors.black));
      });
    });
  });
}
