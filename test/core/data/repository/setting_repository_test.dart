import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storyzz/core/constants/my_prefs_key.dart';
import 'package:storyzz/core/data/model/setting.dart';
import 'package:storyzz/core/data/repository/setting_repository.dart';

import '../../../tetsutils/mock.dart';

void main() {
  late SettingRepository settingRepository;
  late MockSharedPreferences mockPreferences;

  setUp(() {
    mockPreferences = MockSharedPreferences();
    settingRepository = SettingRepository(mockPreferences);
  });

  group('saveSettingValue', () {
    test('should save setting values successfully', () async {
      when(
        () => mockPreferences.setBool(any(), any()),
      ).thenAnswer((_) async => true);
      when(
        () => mockPreferences.setString(any(), any()),
      ).thenAnswer((_) async => true);
      final setting = Setting(isDark: true, locale: 'en');

      await settingRepository.saveSettingValue(setting);

      verify(
        () => mockPreferences.setBool(SettingsPrefsKeys.themeKey, true),
      ).called(1);
      verify(
        () => mockPreferences.setString(SettingsPrefsKeys.languageKey, 'en'),
      ).called(1);
    });

    test('should throw exception when saving fails', () async {
      when(() => mockPreferences.setBool(any(), any())).thenThrow(Exception());
      final setting = Setting(isDark: true, locale: 'en');

      expect(
        () => settingRepository.saveSettingValue(setting),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('setTheme', () {
    test('should set theme successfully', () async {
      when(
        () => mockPreferences.setBool(any(), any()),
      ).thenAnswer((_) async => true);

      await settingRepository.setTheme(true);

      verify(
        () => mockPreferences.setBool(SettingsPrefsKeys.themeKey, true),
      ).called(1);
    });

    test('should throw exception when setting theme fails', () async {
      when(() => mockPreferences.setBool(any(), any())).thenThrow(Exception());

      expect(() => settingRepository.setTheme(true), throwsA(isA<Exception>()));
    });
  });

  group('getSettingValue', () {
    test('should return setting with stored values', () {
      when(
        () => mockPreferences.getBool(SettingsPrefsKeys.themeKey),
      ).thenReturn(false);
      when(
        () => mockPreferences.getString(SettingsPrefsKeys.languageKey),
      ).thenReturn('id');

      final result = settingRepository.getSettingValue();

      expect(result.isDark, false);
      expect(result.locale, 'id');
    });

    test('should return setting with default values when no stored values', () {
      when(
        () => mockPreferences.getBool(SettingsPrefsKeys.themeKey),
      ).thenReturn(null);
      when(
        () => mockPreferences.getString(SettingsPrefsKeys.languageKey),
      ).thenReturn(null);

      final result = settingRepository.getSettingValue();

      expect(result.isDark, true);
      expect(result.locale, 'en');
    });
  });

  group('isDarkModeSet', () {
    test('should return true when theme is set', () {
      when(
        () => mockPreferences.containsKey(SettingsPrefsKeys.themeKey),
      ).thenReturn(true);

      final result = settingRepository.isDarkModeSet();

      expect(result, true);
    });

    test('should return false when theme is not set', () {
      when(
        () => mockPreferences.containsKey(SettingsPrefsKeys.themeKey),
      ).thenReturn(false);

      final result = settingRepository.isDarkModeSet();

      expect(result, false);
    });
  });

  group('setLocale', () {
    test('should set locale successfully', () async {
      when(
        () => mockPreferences.setString(any(), any()),
      ).thenAnswer((_) async => true);

      await settingRepository.setLocale('id');

      verify(
        () => mockPreferences.setString(SettingsPrefsKeys.languageKey, 'id'),
      ).called(1);
    });

    test('should throw exception when setting locale fails', () async {
      when(
        () => mockPreferences.setString(any(), any()),
      ).thenThrow(Exception());

      expect(
        () => settingRepository.setLocale('id'),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('getLanguage', () {
    test('should return stored language code', () {
      when(
        () => mockPreferences.getString(SettingsPrefsKeys.languageKey),
      ).thenReturn('id');

      final result = settingRepository.getLanguage();

      expect(result, 'id');
    });

    test('should return null when no language is stored', () {
      when(
        () => mockPreferences.getString(SettingsPrefsKeys.languageKey),
      ).thenReturn(null);

      final result = settingRepository.getLanguage();

      expect(result, null);
    });
  });
}
