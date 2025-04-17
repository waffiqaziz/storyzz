import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting.freezed.dart';
// part 'setting.g.dart'; // uncomment JSON serialization

@freezed
abstract class Setting with _$Setting {
  const factory Setting({required bool isDark, required String locale}) =
      _Setting;

  // uncomment JSON serialization
  // factory Setting.fromJson(Map<String, dynamic> json) => _$SettingFromJson(json);
}
