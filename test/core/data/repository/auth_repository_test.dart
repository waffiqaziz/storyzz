import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storyzz/core/constants/my_prefs_key.dart';
import 'package:storyzz/core/data/model/user.dart';
import 'package:storyzz/core/data/networking/responses/general_response.dart';
import 'package:storyzz/core/data/networking/responses/login_response.dart';
import 'package:storyzz/core/data/networking/responses/login_result.dart';
import 'package:storyzz/core/data/networking/utils/api_utils.dart';
import 'package:storyzz/core/data/repository/auth_repository.dart';

import '../../../tetsutils/mock.dart';

void main() {
  late MockSharedPreferences mockPreferences;
  late MockApiServices mockApiServices;
  late AuthRepository authRepository;
  final user = User(
    email: 'test@email.com',
    name: 'Test User',
    password: 'password',
    token: 'token123',
  );

  setUp(() {
    mockPreferences = MockSharedPreferences();
    mockApiServices = MockApiServices();
    authRepository = AuthRepository(mockPreferences, mockApiServices);
  });

  group('Local Storage Operations', () {
    test('isLoggedIn returns correct state', () async {
      when(
        () => mockPreferences.getBool(AuthPrefsKeys.stateKey),
      ).thenReturn(true);

      final result = await authRepository.isLoggedIn();
      expect(result, true);
    });

    test('login sets logged in state to true', () async {
      when(
        () => mockPreferences.setBool(AuthPrefsKeys.stateKey, true),
      ).thenAnswer((_) async => true);

      final result = await authRepository.login();
      expect(result, true);
      verify(
        () => mockPreferences.setBool(AuthPrefsKeys.stateKey, true),
      ).called(1);
    });

    test('logout sets logged in state to false', () async {
      when(
        () => mockPreferences.setBool(AuthPrefsKeys.stateKey, false),
      ).thenAnswer((_) async => true);

      final result = await authRepository.logout();
      expect(result, true);
      verify(
        () => mockPreferences.setBool(AuthPrefsKeys.stateKey, false),
      ).called(1);
    });

    test('saveUser stores user data in preferences', () async {
      when(
        () => mockPreferences.setString(any(), any()),
      ).thenAnswer((_) async => true);

      final result = await authRepository.saveUser(user);
      expect(result, true);
      verify(
        () => mockPreferences.setString(AuthPrefsKeys.userKey, any()),
      ).called(1);
    });

    test('deleteUser remove user data', () async {
      when(
        () => mockPreferences.setString(any(), any()),
      ).thenAnswer((_) async => true);

      final result = await authRepository.deleteUser();
      expect(result, true);
      verify(
        () => mockPreferences.setString(AuthPrefsKeys.userKey, ""),
      ).called(1);
    });

    test('getUser returns valid user', () async {
      when(
        () => mockPreferences.getString(AuthPrefsKeys.userKey),
      ).thenReturn(user.toJsonString());

      final result = await authRepository.getUser();

      expect(result?.email, user.email);
      expect(result?.name, user.name);
    });

    test('getUser returns null for invalid json', () async {
      when(
        () => mockPreferences.getString(AuthPrefsKeys.userKey),
      ).thenReturn("not a json string");

      final result = await authRepository.getUser();

      expect(result, isNull);
    });
  });

  group('Remote Operations', () {
    test('loginRemote success scenario', () async {
      final loginResult = LoginResult(
        userId: '1',
        name: 'Test User',
        token: 'token123',
      );
      final loginResponse = LoginResponse(
        error: false,
        message: 'Success',
        loginResult: loginResult,
      );

      when(
        () => mockApiServices.login(any(), any()),
      ).thenAnswer((_) async => ApiResult.success(loginResponse));
      when(
        () => mockPreferences.setString(any(), any()),
      ).thenAnswer((_) async => true);
      when(
        () => mockPreferences.setBool(any(), any()),
      ).thenAnswer((_) async => true);

      final result = await authRepository.loginRemote(
        'test@email.com',
        'password',
      );

      expect(result.data, loginResponse);
      verify(() => mockApiServices.login(any(), any())).called(1);
      verify(
        () => mockPreferences.setString(AuthPrefsKeys.userKey, any()),
      ).called(1);
      verify(
        () => mockPreferences.setBool(AuthPrefsKeys.stateKey, true),
      ).called(1);
    });

    test('register success scenario', () async {
      final user = User(
        email: 'test@email.com',
        name: 'Test User',
        password: 'password',
        token: '',
      );
      final response = GeneralResponse(error: false, message: 'Success');

      when(
        () => mockApiServices.register(user),
      ).thenAnswer((_) async => ApiResult.success(response));

      final result = await authRepository.register(user);

      expect(result.data, response);
      verify(() => mockApiServices.register(user)).called(1);
    });

    test('register failure scenario', () async {
      final user = User(
        email: 'test@email.com',
        name: 'Test User',
        password: 'password',
        token: '',
      );

      when(
        () => mockApiServices.register(user),
      ).thenAnswer((_) async => ApiResult.error('Registration failed'));

      final result = await authRepository.register(user);

      expect(result.message, 'Registration failed');
      verify(() => mockApiServices.register(user)).called(1);
    });

    test('loginRemote returns error when data is null', () async {
      when(
        () => mockApiServices.login(any(), any()),
      ).thenAnswer((_) async => ApiResult<LoginResponse>.error('Login failed'));

      final result = await authRepository.loginRemote('email', 'password');

      expect(result.message, 'Login failed');
      expect(result.data, isNull);
    });
  });
}
