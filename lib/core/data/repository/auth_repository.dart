import 'package:shared_preferences/shared_preferences.dart';
import 'package:storyzz/core/constants/my_prefs_key.dart';
import 'package:storyzz/core/data/networking/responses/login_response.dart';
import 'package:storyzz/core/data/networking/responses/general_response.dart';
import 'package:storyzz/core/data/networking/services/api_services.dart';
import 'package:storyzz/core/data/networking/utils/api_utils.dart';

import '../model/user.dart';

class AuthRepository {
  final SharedPreferences _preferences;
  final ApiServices _apiServices;

  AuthRepository(this._preferences, this._apiServices);

  // shared preference
  Future<bool> isLoggedIn() async {
    return _preferences.getBool(AuthPrefsKeys.stateKey) ?? false;
  }

  Future<bool> login() async {
    return _preferences.setBool(AuthPrefsKeys.stateKey, true);
  }

  Future<bool> logout() async {
    return _preferences.setBool(AuthPrefsKeys.stateKey, false);
  }

  Future<bool> saveUser(User user) async {
    return _preferences.setString(AuthPrefsKeys.userKey, user.toJsonString());
  }

  Future<bool> deleteUser() async {
    return _preferences.setString(AuthPrefsKeys.userKey, "");
  }

  Future<User?> getUser() async {
    await Future.delayed(const Duration(seconds: 2));
    final json = _preferences.getString(AuthPrefsKeys.userKey) ?? "";
    User? user;
    try {
      user = UserExtension.fromJsonString(json);
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
        password: "password", // for security password not saved to local
        token: response.data!.loginResult.token,
      );
      await saveUser(user); // save user data to shared preference
      await login(); // update is login flag
      return ApiResult.success(response.data!);
    }
    return ApiResult.error(response.message ?? "Unknown error");
  }

  Future<ApiResult<GeneralResponse>> register(User user) async {
    final response = await _apiServices.register(user);
    if (response.data != null && !response.data!.error) {
      return ApiResult.success(response.data!);
    }
    return ApiResult.error(response.message ?? "Unknown error");
  }
}
