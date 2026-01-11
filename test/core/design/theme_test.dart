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
          equals(const EdgeInsets.all(18)),
        );
        expect(buttonStyle?.elevation?.resolve({}), equals(0));
        expect(
          buttonStyle?.shape?.resolve({}),
          isA<RoundedRectangleBorder>().having(
            (shape) => shape.borderRadius,
            'borderRadius',
            equals(BorderRadius.circular(50)),
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
            equals(const EdgeInsets.only(left: 14.0)),
          );
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
  });
}
