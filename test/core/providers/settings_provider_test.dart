import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storyzz/core/data/models/setting.dart';
import 'package:storyzz/core/providers/settings_provider.dart';

import '../../tetsutils/mock.dart';

void main() {
  // Ensure  Flutter framework is initialized before running tests
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSettingRepository mockRepository;
  late SettingsProvider provider;
  final testSetting = Setting(isDark: false, locale: 'es');

  setUp(() {
    mockRepository = MockSettingRepository();

    // Setup default mock responses
    when(() => mockRepository.isDarkModeSet()).thenReturn(true);
    when(
      () => mockRepository.getSettingValue(),
    ).thenReturn(Setting(isDark: true, locale: 'en'));

    TestWidgetsFlutterBinding
            .instance
            .platformDispatcher
            .platformBrightnessTestValue =
        Brightness.dark;
    provider = SettingsProvider(mockRepository);
    TestWidgetsFlutterBinding
            .instance
            .platformDispatcher
            .platformBrightnessTestValue =
        Brightness.light;

    reset(mockRepository);
  });

  group('SettingsProvider initialization', () {
    test('should initialize with default values', () {
      expect(provider.message, 'Settings initialized successfully');
      expect(provider.setting?.isDark, true);
      expect(provider.setting?.locale, 'en');
      expect(provider.locale.languageCode, 'en');
    });

    test('should handle initialization error', () {
      when(
        () => mockRepository.isDarkModeSet(),
      ).thenThrow(Exception('Test error'));

      provider = SettingsProvider(mockRepository);

      expect(provider.message, 'Failed to initialize settings');
    });
  });

  group('saveSettingValue', () {
    test('should save settings successfully', () async {
      when(
        () => mockRepository.saveSettingValue(testSetting),
      ).thenAnswer((_) async => {});

      await provider.saveSettingValue(testSetting);

      expect(provider.setting, testSetting);
      expect(provider.locale.languageCode, 'es');
      expect(provider.message, 'Your data is saved');
      verify(() => mockRepository.saveSettingValue(testSetting)).called(1);
    });

    test('should handle save error', () async {
      when(
        () => mockRepository.saveSettingValue(testSetting),
      ).thenThrow(Exception('Test error'));

      await provider.saveSettingValue(testSetting);

      expect(provider.message, 'Failed to save your data');
    });
  });

  group('setTheme', () {
    test('should update theme successfully', () async {
      when(() => mockRepository.setTheme(false)).thenAnswer((_) async => {});

      await provider.setTheme(false);

      expect(provider.setting?.isDark, false);
      expect(provider.message, 'Theme successfully updated.');
      verify(() => mockRepository.setTheme(false)).called(1);
    });

    test('should handle theme update error', () async {
      when(
        () => mockRepository.setTheme(false),
      ).thenThrow(Exception('Test error'));

      await provider.setTheme(false);

      expect(provider.message, 'Failed to update theme. Please try again.');
    });

    test('should create new setting if null', () async {
      provider = SettingsProvider(mockRepository); // Reset provider
      when(() => mockRepository.setTheme(false)).thenAnswer((_) async => {});

      await provider.setTheme(false);

      expect(provider.setting?.isDark, false);
      expect(provider.setting?.locale, 'en');
    });
  });

  // TODO: missing test
  group('setLocale', () {
    test('should handle locale update error when preferences fails', () async {
      when(
        () => mockRepository.setLocale('es'),
      ).thenThrow(Exception("Failed setting locale."));

      await provider.setLocale('es');

      expect(provider.message, 'Failed to update language. Please try again.');
      verify(() => mockRepository.setLocale('es')).called(1);
    });
  });
}
