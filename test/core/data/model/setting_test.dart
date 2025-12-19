// filepath: lib/core/data/model/setting_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:storyzz/core/data/models/setting.dart';

void main() {
  group('Setting', () {
    test('can be created with correct values', () {
      const setting = Setting(isDark: true, locale: 'en');
      expect(setting.isDark, true);
      expect(setting.locale, 'en');
    });

    test('two Setting objects with the same values are equal', () {
      const setting1 = Setting(isDark: true, locale: 'en');
      const setting2 = Setting(isDark: true, locale: 'en');
      expect(setting1, setting2);
    });

    test('copyWith method correctly updates isDark property', () {
      const initialSetting = Setting(isDark: true, locale: 'en');
      final updatedSetting = initialSetting.copyWith(isDark: false);
      expect(updatedSetting.isDark, false);
      expect(updatedSetting.locale, 'en');
    });

    test('copyWith method correctly updates locale property', () {
      const initialSetting = Setting(isDark: true, locale: 'en');
      final updatedSetting = initialSetting.copyWith(locale: 'es');
      expect(updatedSetting.isDark, true);
      expect(updatedSetting.locale, 'es');
    });
  });
}
