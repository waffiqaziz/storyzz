import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyzz/core/data/networking/responses/login_result.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

@freezed
abstract class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required bool error,
    required String message,
    required LoginResult loginResult,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
