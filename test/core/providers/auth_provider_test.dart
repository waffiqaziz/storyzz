import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storyzz/core/data/model/user.dart';
import 'package:storyzz/core/data/networking/responses/general_response.dart';
import 'package:storyzz/core/data/networking/responses/login_response.dart';
import 'package:storyzz/core/data/networking/responses/login_result.dart';
import 'package:storyzz/core/data/networking/utils/api_utils.dart';
import 'package:storyzz/core/providers/auth_provider.dart';

import '../../tetsutils/mock.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late AuthProvider authProvider;
  final testUser = User(
    name: 'Test User',
    password: '',
    email: 'test@test.com',
    token: 'token123',
  );

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authProvider = AuthProvider(mockAuthRepository);
  });

  group('AuthProvider Tests', () {
    test('initial values should be correct', () {
      expect(authProvider.isLoadingLogin, false);
      expect(authProvider.isLoadingLogout, false);
      expect(authProvider.isLoadingRegister, false);
      expect(authProvider.isLoggedIn, false);
      expect(authProvider.user, null);
      expect(authProvider.errorMessage, '');
    });
    group('isLogged Tests', () {
      test('should return true when user is logged in', () async {
        when(mockAuthRepository.isLoggedIn).thenAnswer((_) async => true);

        final result = await authProvider.isLogged();

        expect(result, true);
        expect(authProvider.isLoggedIn, true);
        verify(mockAuthRepository.isLoggedIn).called(1);
      });

      test('should return false when user is not logged in', () async {
        when(mockAuthRepository.isLoggedIn).thenAnswer((_) async => false);

        final result = await authProvider.isLogged();

        expect(result, false);
        expect(authProvider.isLoggedIn, false);
        verify(mockAuthRepository.isLoggedIn).called(1);
      });

      test('should handle errors gracefully', () async {
        when(
          () => mockAuthRepository.isLoggedIn(),
        ).thenAnswer((_) async => false);

        final result = await authProvider.isLogged();

        expect(authProvider.isLoggedIn, false);
        expect(result, false);
        verify(() => mockAuthRepository.isLoggedIn()).called(1);
      });
    });

    group('logout Tests', () {
      test('should handle successful logout', () async {
        when(() => mockAuthRepository.logout()).thenAnswer((_) async => true);
        when(
          () => mockAuthRepository.deleteUser(),
        ).thenAnswer((_) async => true);
        when(
          () => mockAuthRepository.isLoggedIn(),
        ).thenAnswer((_) async => false);

        await authProvider.logout();

        expect(authProvider.isLoggedIn, false);
        expect(authProvider.isLoadingLogout, false);
        verify(() => mockAuthRepository.logout()).called(1);
        verify(() => mockAuthRepository.deleteUser()).called(1);
      });

      test('should handle logout error correctly', () async {
        when(
          () => mockAuthRepository.logout(),
        ).thenThrow(Exception('Logout failed'));

        await authProvider.logout();

        expect(
          authProvider.errorMessage,
          'An error occurred while logging out',
        );
        expect(authProvider.logoutSuccess, false);
        expect(authProvider.isLoadingLogout, false);

        verify(() => mockAuthRepository.logout()).called(1);
        verifyNever(() => mockAuthRepository.deleteUser());
      });
    });

    group('saveUser Tests', () {
      test('should save user successfully', () async {
        when(
          () => mockAuthRepository.saveUser(testUser),
        ).thenAnswer((_) async => true);

        final result = await authProvider.saveUser(testUser);

        expect(result, true);
        expect(authProvider.isLoadingRegister, false);
        verify(() => mockAuthRepository.saveUser(testUser)).called(1);
      });
    });

    group('getUser Tests', () {
      test('should get user successfully', () async {
        when(
          () => mockAuthRepository.getUser(),
        ).thenAnswer((_) async => testUser);

        await authProvider.getUser();

        expect(authProvider.user, testUser);
        expect(authProvider.errorMessage, '');
        expect(authProvider.isLoadingLogin, false);
        verify(() => mockAuthRepository.getUser()).called(1);
      });

      test('should handle null user', () async {
        when(() => mockAuthRepository.getUser()).thenAnswer((_) async => null);

        await authProvider.getUser();

        expect(authProvider.user, null);
        expect(authProvider.errorMessage, 'User not found');
        expect(authProvider.isLoadingLogin, false);
      });

      test('should handle error', () async {
        when(
          () => mockAuthRepository.getUser(),
        ).thenThrow(Exception('Network error'));

        await authProvider.getUser();

        expect(authProvider.user, null);
        expect(
          authProvider.errorMessage,
          'An error occurred while fetching user',
        );
        expect(authProvider.isLoadingLogin, false);
      });
    });

    group('loginNetwork Tests', () {
      test('should handle successful login', () async {
        final loginResponse = LoginResponse(
          error: false,
          message: 'Success',
          loginResult: LoginResult(
            userId: '1',
            name: 'Test User',
            token: 'token123',
          ),
        );

        when(
          () => mockAuthRepository.loginRemote('test@test.com', 'password'),
        ).thenAnswer((_) async => ApiResult.success(loginResponse));
        when(
          () => mockAuthRepository.isLoggedIn(),
        ).thenAnswer((_) async => true);

        final result = await authProvider.loginNetwork(
          'test@test.com',
          'password',
        );

        expect(result.data, loginResponse);
        expect(authProvider.isLoggedIn, true);
        expect(authProvider.isLoadingLogin, false);
      });
    });

    group('register Tests', () {
      test('should handle successful registration', () async {
        final response = GeneralResponse(error: false, message: 'Success');

        when(
          () => mockAuthRepository.register(testUser),
        ).thenAnswer((_) async => ApiResult.success(response));

        final result = await authProvider.register(testUser);

        expect(result.data, response);
        expect(authProvider.isLoadingRegister, false);
      });
    });
  });
}
