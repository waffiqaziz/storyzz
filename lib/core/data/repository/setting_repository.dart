import 'package:shared_preferences/shared_preferences.dart';
import 'package:storyzz/core/constants/my_prefs_key.dart';
import 'package:storyzz/core/data/model/setting.dart';

class SettingRepository {
  final SharedPreferences _preferences;

  SettingRepository(this._preferences);

  Future<void> saveSettingValue(Setting setting) async {
    try {
      await _preferences.setBool(SettingsPrefsKeys.themeKey, setting.isDark);
      await _preferences.setString(
        SettingsPrefsKeys.languageKey,
        setting.locale,
      );
    } catch (e) {
      throw Exception("Shared preferences cannot save the setting value.");
    }
  }

  Future<void> setTheme(bool isDark) async {
    try {
      await _preferences.setBool(SettingsPrefsKeys.themeKey, isDark);
    } catch (e) {
      throw Exception("Failed setting theme.");
    }
  }

  Setting getSettingValue() {
    return Setting(
      isDark: _preferences.getBool(SettingsPrefsKeys.themeKey) ?? true,
      locale: _preferences.getString(SettingsPrefsKeys.languageKey) ?? 'en',
    );
  }

  bool isDarkModeSet() {
    return _preferences.containsKey(SettingsPrefsKeys.themeKey);
  }

  Future<void> setLocale(String languageCode) async {
    try {
      await _preferences.setString(SettingsPrefsKeys.languageKey, languageCode);
    } catch (e) {
      throw Exception("Failed setting locale.");
    }
  }

  String? getLanguage() {
    return _preferences.getString(SettingsPrefsKeys.languageKey);
  }
}
