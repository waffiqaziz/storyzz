import 'package:shared_preferences/shared_preferences.dart';
import 'package:storyzz/core/data/networking/responses/login_response.dart';
import 'package:storyzz/core/data/networking/responses/register_response.dart';
import 'package:storyzz/core/data/networking/services/api_services.dart';
import 'package:storyzz/core/data/networking/utils/api_utils.dart';

import '../model/user.dart';

class AuthRepository {
  final SharedPreferences _preferences;
  final ApiServices _apiServices;

  AuthRepository(this._preferences, this._apiServices);

  final String stateKey = "state";
  final String userKey = "user";

  // shared preference
  Future<bool> isLoggedIn() async {
    return _preferences.getBool(stateKey) ?? false;
  }

  Future<bool> login() async {
    return _preferences.setBool(stateKey, true);
  }

  Future<bool> logout() async {
    return _preferences.setBool(stateKey, false);
  }

  Future<bool> saveUser(User user) async {
    return _preferences.setString(userKey, user.toJson());
  }

  Future<bool> deleteUser() async {
    return _preferences.setString(userKey, "");
  }

  Future<User?> getUser() async {
    await Future.delayed(const Duration(seconds: 2));
    final json = _preferences.getString(userKey) ?? "";
    User? user;
    try {
      user = User.fromJson(json);
    } catch (e) {
      user = null;
    }
    return user;
  }

  // remote
  Future<ApiResult<LoginResponse>> loginRemote(
    String email,
    String password,
  ) async {
    final response = await _apiServices.login(email, password);
    if (response.data != null && !response.data!.error) {
      final user = User(
        email: email,
        name: response.data!.loginResult.name,
        password: password,
        token: response.data!.loginResult.token,
        language: "en",
      );
      await saveUser(user); // save user data to shared preference
      await login(); // update is login flag
      return ApiResult.success(response.data!);
    }
    return ApiResult.error(response.message ?? "Unknown error");
  }

  Future<ApiResult<RegisterResponse>> register(User user) async {
    final response = await _apiServices.register(user);
    if (response.data != null && !response.data!.error) {
      return ApiResult.success(response.data!);
    }
    return ApiResult.error(response.message ?? "Unknown error");
  }
}
