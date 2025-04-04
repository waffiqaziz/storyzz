import 'package:shared_preferences/shared_preferences.dart';
import 'package:storyzz/core/data/model/setting.dart';

class SettingRepository {
  final SharedPreferences _preferences;

  SettingRepository(this._preferences);

  static const String keyIsDark = "STORYZZ_THEME";

  Future<void> saveSettingValue(Setting setting) async {
    try {
      await _preferences.setBool(keyIsDark, setting.isDark);
    } catch (e) {
      throw Exception("Shared preferences cannot save the setting value.");
    }
  }

  Future<void> setTheme(bool isDark) async {
    try {
      await _preferences.setBool(keyIsDark, isDark);
    } catch (e) {
      throw Exception("Failed setting theme.");
    }
  }

  Setting getSettingValue() {
    return Setting(isDark: _preferences.getBool(keyIsDark) ?? true);
  }

  bool isDarkModeSet() {
    return _preferences.containsKey(keyIsDark);
  }
}
