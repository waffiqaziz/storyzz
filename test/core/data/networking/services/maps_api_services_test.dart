import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:storyzz/core/data/networking/responses/geocoding_response.dart';
import 'package:storyzz/core/data/networking/services/maps_api_services.dart';
import 'package:storyzz/core/utils/environment.dart';

import '../../../../tetsutils/mock.dart' show MockHttpClient;

class MockJsContextWrapper extends Mock implements JsContextWrapper {
  final String? apiKeyToReturn;

  MockJsContextWrapper({this.apiKeyToReturn});

  @override
  String? getApiKey() {
    return apiKeyToReturn;
  }
}

class MockEnvironmentProvider extends Mock implements EnvironmentProvider {
  @override
  bool get isWebPlatform => false;

  @override
  String getEnvValue(String key, {required String fallback}) {
    return 'test_api_key';
  }
}

void main() {
  group('MapsApiService', () {
    late MockHttpClient mockHttpClient;
    late MapsApiService mapsApiService;

    setUpAll(() {
      registerFallbackValue(Uri());
    });

    setUp(() {
      // Inject mock dependencies
      MapsEnvironment.injectDependencies(
        environmentProvider: MockEnvironmentProvider(),
        jsContextWrapper: MockJsContextWrapper(apiKeyToReturn: 'test_api_key'),
      );

      mockHttpClient = MockHttpClient();
      mapsApiService = MapsApiService(httpClient: mockHttpClient);
    });

    tearDown(() {
      // Reset environment dependencies after each test
      MapsEnvironment.resetDependencies();
    });

    test(
      'getAddressFromCoordinates returns GeocodingResponse on successful API call',
      () async {
        // Arrange
        final double lat = 37.7749;
        final double lon = -122.4194;

        final expectedUri = Uri.https('geocode.maps.co', '/reverse', {
          'lat': lat.toString(),
          'lon': lon.toString(),
          'api_key': 'test_api_key',
        });

        final mockResponseBody = '''
      {
        "place_id": 12345,
        "licence": "Data © OpenStreetMap contributors",
        "osm_type": "way",
        "osm_id": 67890,
        "lat": "37.7749",
        "lon": "-122.4194",
        "display_name": "San Francisco, California, USA",
        "address": {
          "city": "San Francisco",
          "state": "California",
          "country": "USA",
          "postcode": "94103"
        },
        "boundingbox": ["37.7", "37.8", "-122.5", "-122.3"]
      }
      ''';

        when(
          () => mockHttpClient.get(any()),
        ).thenAnswer((_) async => http.Response(mockResponseBody, 200));

        // Act
        final result = await mapsApiService.getAddressFromCoordinates(lat, lon);

        // Assert
        verify(() => mockHttpClient.get(expectedUri)).called(1);
        expect(result, isA<GeocodingResponse>());
        expect(result.displayName, 'San Francisco, California, USA');
        expect(result.address.city, 'San Francisco');
        expect(result.address.country, 'USA');
      },
    );

    test(
      'getAddressFromCoordinates throws exception on non-200 response',
      () async {
        // Arrange
        final double lat = 37.7749;
        final double lon = -122.4194;

        when(() => mockHttpClient.get(any())).thenAnswer(
          (_) async => http.Response('{"error": "API limit exceeded"}', 429),
        );

        // Act & Assert
        expect(
          () => mapsApiService.getAddressFromCoordinates(lat, lon),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Failed to get address: 429'),
            ),
          ),
        );
      },
    );

    test(
      'getAddressFromCoordinates throws exception on client error',
      () async {
        // Arrange
        final double lat = 37.7749;
        final double lon = -122.4194;

        when(
          () => mockHttpClient.get(any()),
        ).thenThrow(Exception('Connection failed'));

        // Act & Assert
        expect(
          () => mapsApiService.getAddressFromCoordinates(lat, lon),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Failed to connect to maps.co API'),
            ),
          ),
        );
      },
    );

    test(
      'getAddressFromCoordinates uses correct API key from environment',
      () async {
        // Arrange
        final double lat = 40.7128;
        final double lon = -74.0060;

        // Create a new service instance with the updated environment
        final newService = MapsApiService(httpClient: mockHttpClient);

        final expectedUri = Uri.https('geocode.maps.co', '/reverse', {
          'lat': lat.toString(),
          'lon': lon.toString(),
          'api_key': "test_api_key",
        });

        Uri? capturedUri;
        when(() => mockHttpClient.get(any())).thenAnswer((invocation) {
          capturedUri = invocation.positionalArguments.first as Uri;
          return Future.value(
            http.Response('''
            {
              "place_id": 12345,
              "licence": "Data © OpenStreetMap contributors",
              "osm_type": "way",
              "osm_id": 67890,
              "lat": "40.7128",
              "lon": "-74.0060",
              "display_name": "New York City",
              "address": {
                "city": "New York City",
                "state": "New York",
                "country": "USA",
                "postcode": "10007"
              },
              "boundingbox": ["40.7", "40.8", "-74.1", "-74.0"]
            }
          ''', 200),
          );
        });

        // Act
        await newService.getAddressFromCoordinates(lat, lon);

        // Assert
        expect(capturedUri, expectedUri, reason: 'URI mismatch');
        verify(() => mockHttpClient.get(expectedUri)).called(1);
      },
    );
  });
}
