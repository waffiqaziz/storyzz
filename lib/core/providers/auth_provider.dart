import 'package:flutter/material.dart';
import 'package:storyzz/core/data/model/user.dart';
import 'package:storyzz/core/data/networking/responses/general_response.dart';
import 'package:storyzz/core/data/networking/responses/login_response.dart';
import 'package:storyzz/core/data/networking/utils/api_utils.dart';
import 'package:storyzz/core/data/repository/auth_repository.dart';

/// Provides authentication logic and state management.
///
/// Handles:
/// - Login, logout, and registration flows
/// - Persisting and retrieving the authenticated user
/// - Tracking loading and error states
///
/// Relies on [AuthRepository] for actual auth operations.
class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthProvider(this.authRepository);

  bool isLoadingLogin = false;
  bool isLoadingLogout = false;
  bool isLoadingRegister = false;
  bool isLoggedIn = false;
  bool logoutSuccess = false;
  User? user;
  String errorMessage = '';

  Future<bool> isLogged() async {
    isLoggedIn = await authRepository.isLoggedIn();
    return isLoggedIn;
  }

  Future<void> logout() async {
    isLoadingLogout = true;
    notifyListeners();

    try {
      final logout = await authRepository.logout();
      if (logout) {
        await authRepository.deleteUser();
      }
      isLoggedIn = await authRepository.isLoggedIn();
      logoutSuccess = true;
    } catch (e) {
      errorMessage = "An error occurred while logging out";
      logoutSuccess = false;
    }
    isLoadingLogout = false;
    notifyListeners();
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

  Future<ApiResult<GeneralResponse>> register(User user) async {
    isLoadingRegister = true;
    notifyListeners();

    final result = await authRepository.register(user);

    isLoadingRegister = false;
    notifyListeners();

    return result;
  }
}
