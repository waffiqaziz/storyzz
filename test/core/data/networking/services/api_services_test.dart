import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show ByteStream;
import 'package:mocktail/mocktail.dart';
import 'package:storyzz/core/data/models/user.dart';
import 'package:storyzz/core/data/networking/api/services/story_api_services.dart';
import 'package:storyzz/core/data/networking/models/general/general_response.dart';
import 'package:storyzz/core/data/networking/models/login/login_response.dart';
import 'package:storyzz/core/data/networking/models/story/stories_response.dart';
import 'package:storyzz/core/data/networking/utils/api_utils.dart';

import '../../../../tetsutils/mock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final mockFile = MockFile();
  final mockAppService = MockAppService();
  final mockHttpClient = MockHttpClient();
  late StoryApiServices apiServices;
  const baseUrl = "https://story-api.dicoding.dev/v1";

  const email = 'test@example.com';
  const password = 'password';
  const userId = 'user123';
  const name = 'Test User';
  const token = 'test_token';

  setUp(() {
    apiServices = StoryApiServices(
      httpClient: mockHttpClient,
      appService: mockAppService,
    );
    registerFallbackValue(Uri());
    registerFallbackValue(http.Request('POST', Uri.parse('')));
    registerFallbackValue(http.Request('POST', Uri()));
    registerFallbackValue(http.MultipartRequest('POST', Uri()));
    registerFallbackValue(MockStreamedResponse());

    when(() => mockAppService.getKIsWeb()).thenReturn(false);
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
        ).called(2);
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

      setUp(() {
        when(() => mockHttpClient.send(any())).thenAnswer((_) async {
          final bodyBytes = utf8.encode(jsonEncode(mockResponseSuccess));
          return http.StreamedResponse(
            Stream.fromIterable([bodyBytes]), // Use a proper stream
            201,
            contentLength: bodyBytes.length,
            headers: {'content-type': 'application/json'},
          );
        });
      });

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

          when(() => mockAppService.getKIsWeb()).thenReturn(false);
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
        expect(result.message, 'No image data provided');
      }, skip: kIsWeb);

      test(
        'should include lat and lon in the request when provided (web)',
        () async {
          final lat = 1.0;
          final lon = 2.0;

          when(() => mockAppService.getKIsWeb()).thenReturn(true);
          reset(mockHttpClient);
          when(() => mockHttpClient.send(any())).thenAnswer((_) async {
            final bodyBytes = utf8.encode(jsonEncode(mockResponseSuccess));
            return http.StreamedResponse(
              Stream.fromIterable([bodyBytes]),
              201,
              contentLength: bodyBytes.length,
              headers: {'content-type': 'application/json'},
            );
          });

          final result = await apiServices.uploadStory(
            token: token,
            description: description,
            photoBytes: photoBytes,
            fileName: fileName,
            lat: lat,
            lon: lon,
          );

          expect(result.data, isNotNull);
          expect(result.message, isNull);

          final capturedRequest =
              verify(() => mockHttpClient.send(captureAny())).captured.single
                  as http.MultipartRequest;
          expect(capturedRequest.fields['lat'], equals(lat.toString()));
          expect(capturedRequest.fields['lon'], equals(lon.toString()));
        },
      );

      test(
        'should include lat and lon in the request when provided (mobile)',
        () async {
          final lat = 1.0;
          final lon = 2.0;
          final mockFile = MockFile();

          when(() => mockAppService.getKIsWeb()).thenReturn(false);
          when(
            () => mockFile.openRead(),
          ).thenAnswer((_) => Stream.value(Uint8List(0)));
          when(() => mockFile.length()).thenAnswer((_) async => 100);
          when(() => mockFile.path).thenReturn('test.jpg');

          reset(mockHttpClient);

          when(() => mockHttpClient.send(any())).thenAnswer((_) async {
            final bodyBytes = utf8.encode(jsonEncode(mockResponseSuccess));
            return http.StreamedResponse(
              Stream.fromIterable([bodyBytes]),
              201,
              contentLength: bodyBytes.length,
              headers: {'content-type': 'application/json'},
            );
          });

          // Call the method being tested with photoFile ONLY
          final result = await apiServices.uploadStory(
            token: token,
            description: description,
            photoFile: mockFile, // Only include photoFile
            fileName: fileName,
            lat: lat,
            lon: lon,
          );

          expect(result.data, isNotNull);
          expect(result.message, isNull);

          final capturedRequest =
              verify(() => mockHttpClient.send(captureAny())).captured.single
                  as http.MultipartRequest;
          expect(capturedRequest.fields['lat'], equals(lat.toString()));
          expect(capturedRequest.fields['lon'], equals(lon.toString()));
        },
      );

      test('should send photoBytes in request when provided (web)', () async {
        reset(mockHttpClient);

        when(() => mockAppService.getKIsWeb()).thenReturn(true);
        when(() => mockHttpClient.send(any())).thenAnswer((_) async {
          final bodyBytes = utf8.encode(jsonEncode(mockResponseSuccess));
          return http.StreamedResponse(
            Stream.fromIterable([bodyBytes]),
            201,
            contentLength: bodyBytes.length,
            headers: {'content-type': 'application/json'},
          );
        });

        final result = await apiServices.uploadStory(
          token: token,
          description: description,
          photoBytes: photoBytes,
          fileName: fileName,
        );

        expect(result.data, isNotNull);

        final capturedRequest =
            verify(() => mockHttpClient.send(captureAny())).captured.single
                as http.MultipartRequest;
        expect(capturedRequest.files.length, 1);
        expect(capturedRequest.files.first.field, 'photo');
        expect(capturedRequest.files.first.filename, fileName);
      });

      test('should throw an exception if no image data is provided', () async {
        when(() => mockAppService.getKIsWeb()).thenReturn(false);
        when(() => mockHttpClient.send(any())).thenAnswer((_) async {
          final bodyBytes = utf8.encode(jsonEncode(mockResponseSuccess));
          return http.StreamedResponse(
            Stream.fromIterable([bodyBytes]),
            201,
            contentLength: bodyBytes.length,
            headers: {'content-type': 'application/json'},
          );
        });
        final result = await apiServices.uploadStory(
          token: token,
          description: description,
          fileName: fileName,
        );
        expect(result.message, contains('No image data provided'));
      });

      test(
        'should capture FormatException in ApiResult when JSON is invalid',
        () async {
          const description = 'Test description';
          final photoBytes = Uint8List.fromList([1, 2, 3]);
          const fileName = 'test.jpg';

          reset(mockHttpClient);

          when(() => mockHttpClient.send(any())).thenAnswer((_) async {
            return http.StreamedResponse(
              Stream.fromIterable([utf8.encode('This is not valid JSON')]),
              201, // Success status code
              contentLength: 'This is not valid JSON'.length,
              headers: {'content-type': 'text/plain'}, // Not JSON content type
            );
          });

          final result = await apiServices.uploadStory(
            token: token,
            description: description,
            photoBytes: photoBytes,
            photoFile: mockFile,
            fileName: fileName,
          );

          expect(result.data, isNull);
          expect(
            result.message,
            contains('Invalid response format. Please contact support'),
          );
        },
      );

      test('should return error message for server error', () async {
        final errorResponseBody = jsonEncode({
          "error": true,
          "message": "Invalid file format",
        });

        when(() => mockAppService.getKIsWeb()).thenReturn(true);
        when(() => mockHttpClient.send(any())).thenAnswer((_) async {
          final bodyBytes = utf8.encode(errorResponseBody);
          return http.StreamedResponse(
            Stream.value(bodyBytes),
            400,
            headers: {'content-type': 'application/json'},
            contentLength: bodyBytes.length,
          );
        });

        final result = await apiServices.uploadStory(
          token: token,
          description: description,
          photoBytes: photoBytes,
          fileName: fileName,
          lat: 1.0,
          lon: 2.0,
        );

        expect(result.message, equals("Invalid file format"));
        // verify(() => mockHttpClient.send(any())).called(1);
      });

      test('should handle non-JSON error responses', () async {
        final errorResponseBody = "Internal Server Error";

        when(() => mockAppService.getKIsWeb()).thenReturn(true);
        when(() => mockHttpClient.send(any())).thenAnswer((_) async {
          final bodyBytes = utf8.encode(errorResponseBody);
          return http.StreamedResponse(
            Stream.value(bodyBytes),
            500,
            headers: {'content-type': 'text/plain'},
            contentLength: bodyBytes.length,
          );
        });

        final result = await apiServices.uploadStory(
          token: token,
          description: description,
          photoBytes: photoBytes,
          fileName: fileName,
          lat: 1.0,
          lon: 2.0,
        );

        expect(result.message, equals("Server error: Status code 500"));
        // verify(() => mockHttpClient.send(any())).called(1);
      });
    });
  });
}
