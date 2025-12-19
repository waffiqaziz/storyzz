import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storyzz/core/data/networking/models/geocoding/geocoding_address.dart';
import 'package:storyzz/core/data/networking/models/geocoding/geocoding_response.dart';
import 'package:storyzz/core/data/repositories/maps_repository.dart';

import '../../../tetsutils/mock.dart';

void main() {
  late MapsRepository repository;
  late MockMapsApiService mockMapsApiService;

  setUp(() {
    mockMapsApiService = MockMapsApiService();
    repository = MapsRepository(mockMapsApiService);
  });

  group('getAddressFromCoordinates', () {
    const testLat = 40.7128;
    const testLon = -74.0060;

    test(
      'should return GeocodingResponse when service call is successful',
      () async {
        final mockResponse = GeocodingResponse(
          placeId: 1,
          licence: 'test',
          osmType: 'way',
          osmId: 1,
          lat: testLat.toString(),
          lon: testLon.toString(),
          displayName: 'Test Location',
          address: GeocodingAddress(),
          boundingbox: ['1', '2', '3', '4'],
        );

        when(
          () => mockMapsApiService.getAddressFromCoordinates(testLat, testLon),
        ).thenAnswer((_) async => mockResponse);

        final result = await repository.getAddressFromCoordinates(
          testLat,
          testLon,
        );

        expect(result, equals(mockResponse));
        verify(
          () => mockMapsApiService.getAddressFromCoordinates(testLat, testLon),
        ).called(1);
      },
    );

    test('should return null when service call throws exception', () async {
      when(
        () => mockMapsApiService.getAddressFromCoordinates(testLat, testLon),
      ).thenThrow(Exception('Network error'));

      final result = await repository.getAddressFromCoordinates(
        testLat,
        testLon,
      );

      expect(result, isNull);
      verify(
        () => mockMapsApiService.getAddressFromCoordinates(testLat, testLon),
      ).called(1);
    });
  });
}
