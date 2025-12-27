import 'package:flutter_test/flutter_test.dart';
import 'package:storyzz/core/data/networking/models/login/login_response.dart';
import 'package:storyzz/core/data/networking/models/login/login_result.dart';

void main() {
  group('LoginResponse', () {
    test('fromJson should correctly parse JSON', () {
      final json = {
        'error': true,
        'message': 'This is an error message',
        'loginResult': {
          'userId': '123',
          'name': 'Test User',
          'token': 'test_token',
        },
      };

      final loginResponse = LoginResponse.fromJson(json);

      expect(loginResponse.error, true);
      expect(loginResponse.message, 'This is an error message');
      expect(loginResponse.loginResult, isA<LoginResult>());
      expect(loginResponse.loginResult.userId, '123');
      expect(loginResponse.loginResult.name, 'Test User');
      expect(loginResponse.loginResult.token, 'test_token');
    });

    test('toJson should correctly convert to JSON', () {
      const loginResponse = LoginResponse(
        error: false,
        message: 'Success!',
        loginResult: LoginResult(
          userId: '123',
          name: 'Test User',
          token: 'test_token',
        ),
      );

      final json = loginResponse.toJson();

      expect(json['error'], false);
      expect(json['message'], 'Success!');
      expect(json['loginResult']['userId'], '123');
      expect(json['loginResult']['name'], 'Test User');
      expect(json['loginResult']['token'], 'test_token');
    });
  });

  group('LoginResult', () {
    test('fromJson should correctly parse JSON', () {
      final json = {
        'userId': '123',
        'name': 'Test User',
        'token': 'test_token',
      };

      final loginResult = LoginResult.fromJson(json);

      expect(loginResult.userId, '123');
      expect(loginResult.name, 'Test User');
      expect(loginResult.token, 'test_token');
    });

    test('toJson should correctly convert to JSON', () {
      const loginResult = LoginResult(
        userId: '123',
        name: 'Test User',
        token: 'test_token',
      );

      final json = loginResult.toJson();

      expect(json['userId'], '123');
      expect(json['name'], 'Test User');
      expect(json['token'], 'test_token');
    });
  });
}
