import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storyzz/core/data/networking/models/geocoding/geocoding_address.dart';
import 'package:storyzz/core/data/networking/models/geocoding/geocoding_response.dart';
import 'package:storyzz/core/data/networking/states/address_load_state.dart';
import 'package:storyzz/core/data/repositories/maps_repository.dart';
import 'package:storyzz/core/providers/address_provider.dart';

import '../../tetsutils/mock.dart';

void main() {
  late MapsRepository mockMapsRepository;
  late AddressProvider addressProvider;

  setUp(() {
    mockMapsRepository = MockMapsRepository();
    addressProvider = AddressProvider(mockMapsRepository);
  });

  group('AddressProvider', () {
    const double testLat = 40.7128;
    const double testLon = -74.0060;
    const String testAddress = "New York City, NY, USA";

    test('initial state should be AddressLoadState.initial', () {
      expect(addressProvider.state, const AddressLoadState.initial());
    });

    test(
      'getAddressFromCoordinates success should update state to loaded',
      () async {
        when(
          () => mockMapsRepository.getAddressFromCoordinates(testLat, testLon),
        ).thenAnswer(
          (_) async => GeocodingResponse(
            placeId: 1,
            licence: "test",
            osmType: "test",
            osmId: 1,
            lat: testLat.toString(),
            lon: testLon.toString(),
            displayName: testAddress,
            address: GeocodingAddress(),
            boundingbox: [],
          ),
        );

        await addressProvider.getAddressFromCoordinates(testLat, testLon);

        expect(addressProvider.state, AddressLoadState.loaded(testAddress));
        verify(
          () => mockMapsRepository.getAddressFromCoordinates(testLat, testLon),
        ).called(1);
      },
    );

    test(
      'getAddressFromCoordinates failure should update state to error',
      () async {
        when(
          () => mockMapsRepository.getAddressFromCoordinates(testLat, testLon),
        ).thenAnswer((_) async => null);

        await addressProvider.getAddressFromCoordinates(testLat, testLon);
        expect(
          addressProvider.state,
          const AddressLoadState.error('No address data returned'),
        );
        verify(
          () => mockMapsRepository.getAddressFromCoordinates(testLat, testLon),
        ).called(1);
      },
    );

    test(
      'getAddressFromCoordinates exception should update state to error',
      () async {
        when(
          () => mockMapsRepository.getAddressFromCoordinates(testLat, testLon),
        ).thenThrow('Network error');

        await addressProvider.getAddressFromCoordinates(testLat, testLon);
        expect(
          addressProvider.state,
          const AddressLoadState.error('Network error'),
        );
        verify(
          () => mockMapsRepository.getAddressFromCoordinates(testLat, testLon),
        ).called(1);
      },
    );

    test('reset should return state to initial', () async {
      when(
        () => mockMapsRepository.getAddressFromCoordinates(testLat, testLon),
      ).thenAnswer(
        (_) async => GeocodingResponse(
          placeId: 1,
          licence: "test",
          osmType: "test",
          osmId: 1,
          lat: testLat.toString(),
          lon: testLon.toString(),
          displayName: testAddress,
          address: GeocodingAddress(),
          boundingbox: [],
        ),
      );
      await addressProvider.getAddressFromCoordinates(testLat, testLon);

      addressProvider.reset();
      expect(addressProvider.state, const AddressLoadState.initial());
    });
  });
}
