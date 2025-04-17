import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_result.freezed.dart';
part 'login_result.g.dart';

@freezed
abstract class LoginResult with _$LoginResult {
  const factory LoginResult({
    required String userId,
    required String name,
    required String token,
  }) = _LoginResult;

  factory LoginResult.fromJson(Map<String, dynamic> json) =>
      _$LoginResultFromJson(json);
}
