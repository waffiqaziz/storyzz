import 'package:flutter_test/flutter_test.dart';
import 'package:storyzz/core/data/model/user.dart';

void main() {
  group('User Model', () {
    test('fromJson should correctly deserialize a JSON map', () {
      final jsonMap = {
        'name': 'Test User',
        'email': 'test@example.com',
        'password': 'password123',
        'token': 'testToken',
      };

      final user = User.fromJson(jsonMap);

      expect(user.name, 'Test User');
      expect(user.email, 'test@example.com');
      expect(user.password, 'password123');
      expect(user.token, 'testToken');
    });

    test('toJson should correctly serialize a User object to a JSON map', () {
      const user = User(
        name: 'Test User',
        email: 'test@example.com',
        password: 'password123',
        token: 'testToken',
      );

      final jsonMap = user.toJson();

      expect(jsonMap['name'], 'Test User');
      expect(jsonMap['email'], 'test@example.com');
      expect(jsonMap['password'], 'password123');
      expect(jsonMap['token'], 'testToken');
    });
  });

  group('UserExtension', () {
    test(
      'toJsonString should correctly convert a User object to a JSON string',
      () {
        const user = User(
          name: 'Test User',
          email: 'test@example.com',
          password: 'password123',
          token: 'testToken',
        );

        final jsonString = user.toJsonString();
        final expectedJsonString =
            '{"name":"Test User","email":"test@example.com","password":"password123","token":"testToken"}';

        expect(jsonString, expectedJsonString);
      },
    );

    test(
      'fromJsonString should correctly parse a JSON string into a User object',
      () {
        const jsonString =
            '{"name":"Test User","email":"test@example.com","password":"password123","token":"testToken"}';

        final user = UserExtension.fromJsonString(jsonString);

        expect(user.name, 'Test User');
        expect(user.email, 'test@example.com');
        expect(user.password, 'password123');
        expect(user.token, 'testToken');
      },
    );

    test(
      'fromJsonString should throw a FormatException when given an empty string',
      () {
        expect(
          () => UserExtension.fromJsonString(''),
          throwsA(isA<FormatException>()),
        );
      },
    );
  });
}
