import 'package:flutter/material.dart';
import 'package:storyzz/core/data/networking/responses/login_response.dart';
import 'package:storyzz/core/data/networking/responses/register_response.dart';
import 'package:storyzz/core/data/networking/utils/api_utils.dart';

import '../data/repository/auth_repository.dart';
import '../data/model/user.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthProvider(this.authRepository);

  bool isLoadingLogin = false;
  bool isLoadingLogout = false;
  bool isLoadingRegister = false;
  bool isLoggedIn = false;
  User? user;
  String errorMessage = '';

  Future<bool> isLogged() async {
    isLoggedIn = await authRepository.isLoggedIn();
    return isLoggedIn;
  }

  Future<bool> logout() async {
    isLoadingLogout = true;
    notifyListeners();

    final logout = await authRepository.logout();
    if (logout) {
      await authRepository.deleteUser();
    }
    isLoggedIn = await authRepository.isLoggedIn();

    isLoadingLogout = false;
    notifyListeners();

    return !isLoggedIn;
  }

  Future<bool> saveUser(User user) async {
    isLoadingRegister = true;
    notifyListeners();

    final userState = await authRepository.saveUser(user);

    isLoadingRegister = false;
    notifyListeners();

    return userState;
  }

  Future<void> getUser() async {
    isLoadingLogin = true;
    notifyListeners();

    try {
      user = await authRepository.getUser();
      if (user == null) {
        errorMessage = "User not found";
      }
    } catch (e) {
      errorMessage = "An error occurred while fetching user";
    }

    isLoadingLogin = false;
    notifyListeners();
  }

  // remote
  Future<ApiResult<LoginResponse>> loginNetwork(
    String email,
    String pass,
  ) async {
    isLoadingLogin = true;
    notifyListeners();

    final result = await authRepository.loginRemote(email, pass);
    isLoggedIn = await authRepository.isLoggedIn();

    isLoadingLogin = false;
    notifyListeners();

    return result;
  }

  Future<ApiResult<RegisterResponse>> register(User user) async {
    isLoadingRegister = true;
    notifyListeners();

    final result = await authRepository.register(user);

    isLoadingRegister = false;
    notifyListeners();

    return result;
  }
}
