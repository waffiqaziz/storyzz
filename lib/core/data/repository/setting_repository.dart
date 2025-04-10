import 'package:shared_preferences/shared_preferences.dart';
import 'package:storyzz/core/data/model/setting.dart';

class SettingRepository {
  final SharedPreferences _preferences;

  SettingRepository(this._preferences);

  static const String themeKey = "STORYZZ_THEME";
  static const String languageKey = "STORYZZ_LANGUAGE";

  Future<void> saveSettingValue(Setting setting) async {
    try {
      await _preferences.setBool(themeKey, setting.isDark);
      await _preferences.setString(languageKey, setting.locale);
    } catch (e) {
      throw Exception("Shared preferences cannot save the setting value.");
    }
  }

  Future<void> setTheme(bool isDark) async {
    try {
      await _preferences.setBool(themeKey, isDark);
    } catch (e) {
      throw Exception("Failed setting theme.");
    }
  }

  Setting getSettingValue() {
    return Setting(
        isDark: _preferences.getBool(themeKey) ?? true,
        locale: _preferences.getString(languageKey) ?? 'en');
  }

  bool isDarkModeSet() {
    return _preferences.containsKey(themeKey);
  }

  Future<void> setLocale(String languageCode) async {
    try {
      await _preferences.setString(languageKey, languageCode);
    } catch (e) {
      throw Exception("Failed setting locale.");
    }
  }

  String? getString(String key) {
    return _preferences.getString(key);
  }
}
