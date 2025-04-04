import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:storyzz/core/data/model/setting.dart';
import 'package:storyzz/core/data/repository/setting_repository.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingRepository _settingRepository;

  String _message = "";
  String get message => _message;

  Setting? _setting;
  Setting? get setting => _setting;

  SettingsProvider(this._settingRepository) {
    _initializeSettings();
  }

  void _initializeSettings() {
    try {
      final savedSetting = _settingRepository.getSettingValue();

      final isDarkSystem =
          WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
      _setting = Setting(
        isDark:
            _settingRepository.isDarkModeSet()
                ? savedSetting.isDark
                : isDarkSystem,
      );
      _message = "Settings initialized successfully";
    } catch (e) {
      _message = "Failed to initialize settings";
    }
    notifyListeners();
  }

  Future<void> saveSettingValue(Setting value) async {
    try {
      await _settingRepository.saveSettingValue(value);
      _setting = value;
      _message = "Your data is saved";
    } catch (e) {
      _message = "Failed to save your data";
    }
    notifyListeners();
  }

  Future<void> setTheme(bool isDark) async {
    try {
      await _settingRepository.setTheme(isDark);
      _setting = Setting(isDark: isDark);
      _message = "Theme successfully updated.";
    } catch (e) {
      _message = "Failed to update theme. Please try again.";
    }
    notifyListeners();
  }
}
