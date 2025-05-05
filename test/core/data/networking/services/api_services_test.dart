// filepath: d:\pem\Dart\Flutter\intermediate\submission\storyzz\test\core\data\networking\services\api_services_test.dart
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show ByteStream;
import 'package:mocktail/mocktail.dart';
import 'package:storyzz/core/data/model/user.dart';
import 'package:storyzz/core/data/networking/responses/general_response.dart';
import 'package:storyzz/core/data/networking/responses/login_response.dart';
import 'package:storyzz/core/data/networking/responses/stories_response.dart';
import 'package:storyzz/core/data/networking/services/api_services.dart';
import 'package:storyzz/core/data/networking/utils/api_utils.dart';

import '../../../../tetsutils/mock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockHttpClient mockHttpClient;
  late ApiServices apiServices;
  const baseUrl = "https://story-api.dicoding.dev/v1";

  const email = 'test@example.com';
  const password = 'password';
  const userId = 'user123';
  const name = 'Test User';
  const token = 'test_token';

  setUp(() {
    mockHttpClient = MockHttpClient();
    apiServices = ApiServices(httpClient: mockHttpClient);
    registerFallbackValue(Uri());
    registerFallbackValue(http.Request('POST', Uri.parse('')));
  });

  group('ApiServices', () {
    group('login', () {
      test('should return LoginResponse on successful login', () async {
        final mockResponse = {
          'error': false,
          'message': 'Login successful',
          'loginResult': {'userId': userId, 'name': name, 'token': token},
        };

        when(
          () => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

        final result = await apiServices.login(email, password);

        expect(result, isA<ApiResult<LoginResponse>>());
        expect(result.data!.loginResult.userId, userId);
        expect(result.data!.loginResult.name, name);
        expect(result.data!.loginResult.token, token);
        expect(result.message, isNull);
      });

      test('should return error message on failed login', () async {
        final mockResponse = {'error': true, 'message': 'Invalid credentials'};

        when(
          () => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 401));

        final result = await apiServices.login(email, password);

        expect(result, isA<ApiResult<LoginResponse>>());
        expect(result.data, isNull);
        expect(result.message, 'Invalid credentials');
      });
    });

    group('register', () {
      const user = User(
        name: 'Test User',
        email: 'test@example.com',
        password: 'password',
      );
      final mockResponseSuccess = {
        'error': false,
        'message': 'Registration successful',
      };

      test(
        'should return GeneralResponse on successful registration',
        () async {
          when(
            () => mockHttpClient.post(
              any(),
              headers: any(named: 'headers'),
              body: any(named: 'body'),
            ),
          ).thenAnswer(
            (_) async => http.Response(jsonEncode(mockResponseSuccess), 201),
          );

          final result = await apiServices.register(user);

          expect(result, isA<ApiResult<GeneralResponse>>());
          expect(result.data!.error, false);
          expect(result.data!.message, 'Registration successful');
          expect(result.message, isNull);
        },
      );

      test('should call register endpoint with correct body', () async {
        when(
          () => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).thenAnswer(
          (_) async => http.Response(jsonEncode(mockResponseSuccess), 201),
        );

        await apiServices.register(user);

        final expectedBody = jsonEncode({
          'name': user.name,
          'email': user.email,
          'password': user.password,
        });
        verify(
          () => mockHttpClient.post(
            Uri.parse('$baseUrl/register'),
            headers: {'Content-Type': 'application/json'},
            body: expectedBody,
          ),
        ).called(1);
      });

      test('should return error message on failed registration', () async {
        final mockResponse = {'error': true, 'message': 'Email already exists'};

        when(
          () => mockHttpClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 400));

        final result = await apiServices.register(user);

        expect(result, isA<ApiResult<GeneralResponse>>());
        expect(result.data, isNull);
        expect(result.message, 'Email already exists');
      });
    });

    group('getStories', () {
      const user = User(
        name: 'Test User',
        email: 'test@example.com',
        password: 'password',
        token: 'test_token',
      );

      test('should return StoriesResponse on successful fetch', () async {
        final mockResponse = {
          'error': false,
          'message': 'Stories fetched successfully',
          'listStory': [
            {
              'id': 'story1',
              'name': 'Story 1',
              'description': 'Description 1',
              'photoUrl': 'url1',
              'createdAt': DateTime.now().toIso8601String(),
              'lat': 1.0,
              'lon': 2.0,
            },
          ],
        };

        when(
          () => mockHttpClient.get(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

        final result = await apiServices.getStories(user: user);

        expect(result, isA<ApiResult<StoriesResponse>>());
        expect(result.data!.listStory.length, 1);
        expect(result.data!.listStory[0].id, 'story1');
        expect(result.message, isNull);
      });

      test('should return error message on failed fetch', () async {
        when(
          () => mockHttpClient.get(any(), headers: any(named: 'headers')),
        ).thenAnswer(
          (_) async => http.Response('Failed to fetch stories', 500),
        );

        final result = await apiServices.getStories(user: user);

        expect(result, isA<ApiResult<StoriesResponse>>());
        expect(result.data, isNull);
        expect(result.message, 'Failed to get stories. Status code: 500');
      });

      test('should include pagination parameters in the request', () async {
        const page = 2;
        const size = 10;
        final mockResponse = {
          'error': false,
          'message': 'Stories fetched successfully',
          'listStory': [],
        };

        when(
          () => mockHttpClient.get(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

        await apiServices.getStories(user: user, page: page, size: size);

        verify(
          () => mockHttpClient.get(
            any(
              that: predicate<Uri>(
                (uri) =>
                    uri.toString().startsWith('$baseUrl/stories') &&
                    uri.queryParameters['page'] == '$page' &&
                    uri.queryParameters['size'] == '$size' &&
                    uri.queryParameters['location'] == '0',
              ),
            ),
            headers: any(named: 'headers'),
          ),
        ).called(1);
      });
    });

    group('uploadStory', () {
      const description = 'Test description';
      final photoBytes = Uint8List.fromList([1, 2, 3]);
      const fileName = 'test.jpg';
      final mockResponseSuccess = {
        'error': false,
        'message': 'Story uploaded successfully',
      };

      test(
        'should return GeneralResponse on successful upload (web)',
        () async {
          when(() => mockHttpClient.send(any())).thenAnswer((_) async {
            return http.StreamedResponse(
              ByteStream.fromBytes(
                utf8.encode(jsonEncode(mockResponseSuccess)),
              ),
              201,
            );
          });

          final result = await apiServices.uploadStory(
            token: token,
            description: description,
            photoBytes: photoBytes,
            fileName: fileName,
          );

          expect(result, isA<ApiResult<GeneralResponse>>());
          expect(result.data!.message, 'Story uploaded successfully');
          expect(result.message, isNull);
        },
        skip: !kIsWeb,
      );

      test(
        'should return GeneralResponse on successful upload (mobile)',
        () async {
          final mockJsonResponse = jsonEncode(mockResponseSuccess);

          final mockFile = MockFile();
          when(
            () => mockFile.openRead(),
          ).thenAnswer((_) => Stream.value(Uint8List(0)));
          when(() => mockFile.length()).thenAnswer((_) async => 100);
          when(() => mockFile.path).thenReturn('test.jpg');

          when(() => mockHttpClient.send(any())).thenAnswer((_) async {
            final bodyBytes = utf8.encode(mockJsonResponse);
            final stream = http.ByteStream.fromBytes(bodyBytes);

            return http.StreamedResponse(
              stream,
              201,
              contentLength: bodyBytes.length,
              headers: {'content-type': 'application/json; charset=utf-8'},
            );
          });

          final result = await apiServices.uploadStory(
            token: token,
            description: description,
            photoFile: mockFile,
            fileName: fileName,
          );

          expect(result, isA<ApiResult<GeneralResponse>>());
          expect(
            result.data,
            isNotNull,
            reason:
                "Response data should not be null - Error message: ${result.message}",
          );
          if (result.data != null) {
            expect(result.data!.error, false);
            expect(result.data!.message, 'Story uploaded successfully');
          }
          expect(result.message, isNull);
        },
      );

      test('should return error message on failed upload', () async {
        final mockResponse = {'error': true, 'message': 'Upload failed'};

        when(() => mockHttpClient.send(any())).thenAnswer((_) async {
          return http.StreamedResponse(
            ByteStream.fromBytes(utf8.encode(jsonEncode(mockResponse))),
            400,
          );
        });

        final result = await apiServices.uploadStory(
          token: token,
          description: description,
          photoBytes: photoBytes,
          fileName: fileName,
        );

        expect(result, isA<ApiResult<GeneralResponse>>());
        expect(result.data, isNull);
        expect(result.message, 'Upload failed');
      }, skip: !kIsWeb);
    });
  });
}
