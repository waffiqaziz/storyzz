import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:storyzz/core/data/networking/states/geocoding_state.dart';
import 'package:storyzz/features/detail/presentation/providers/geocoding_provider.dart';

void main() {
  late GeocodingProvider provider;
  const invalidLat = 37.7749;
  const invalidLon = -122.4194;
  const validLat = 37.422;
  const validLon = -122.084;

  setUp(() {
    provider = GeocodingProvider();
  });

  group('GeocodingProvider', () {
    test('initial state should be GeocodingState.initial', () {
      expect(provider.state, const GeocodingState.initial());
    });

    test('fetchAddress should transition through loading state', () async {
      bool wasLoading = false;
      provider.addListener(() {
        if (provider.state is GeocodingStateLoading) {
          wasLoading = true;
        }
      });

      await provider.fetchAddress(invalidLat, invalidLon);

      expect(
        wasLoading,
        true,
        reason: 'Should have transitioned to loading state',
      );
    });

    test('fetchAddress should end in loaded or error state', () async {
      await provider.fetchAddress(invalidLat, invalidLon);

      expect(
        provider.state is GeocodingStateLoaded ||
            provider.state is GeocodingStateError,
        true,
        reason: 'Should end in either loaded or error state',
      );
    });

    test(
      'fetchAddress should return loaded state with placemark and formatted address',
      () async {
        // valid placemark
        final mockPlacemark = Placemark(
          street: '123 Main St',
          locality: 'San Francisco',
          administrativeArea: 'CA',
          postalCode: '94102',
          country: 'USA',
        );

        final testProvider = GeocodingProvider(
          geocodingFunction: (validLat, validLon) async => [mockPlacemark],
        );

        final states = <GeocodingState>[];
        testProvider.addListener(() {
          states.add(testProvider.state);
        });

        await testProvider.fetchAddress(37.7749, -122.4194);

        // from loading then loaded
        expect(states.length, 2);
        expect(states[0], const GeocodingState.loading());
        expect(states[1], isA<GeocodingStateLoaded>());

        // verify loaded state contains placemark and formatted address
        final loadedState = testProvider.state as GeocodingStateLoaded;
        expect(loadedState.placemark, mockPlacemark);
        expect(loadedState.formattedAddress, isNotEmpty);
      },
    );

    test(
      'fetchAddress with invalid coordinates should handle gracefully',
      () async {
        await provider.fetchAddress(0.0, 0.0);

        expect(
          provider.state is GeocodingStateError ||
              (provider.state is GeocodingStateLoaded &&
                  (provider.state as GeocodingStateLoaded)
                      .formattedAddress
                      .isNotEmpty),
          true,
        );
      },
    );

    test('reset should change state back to initial', () async {
      await provider.fetchAddress(validLat, validLon);

      expect(provider.state, isNot(const GeocodingState.initial()));

      final states = <GeocodingState>[];
      provider.addListener(() {
        states.add(provider.state);
      });

      provider.reset();

      expect(states.length, 1);
      expect(states[0], const GeocodingState.initial());
      expect(provider.state, const GeocodingState.initial());
    });

    test('state transitions are in correct order', () async {
      final states = <String>[];
      provider.addListener(() {
        states.add(provider.state.runtimeType.toString());
      });

      await provider.fetchAddress(validLat, validLon);

      // should  loading -> (loaded or error)
      expect(states.length, greaterThanOrEqualTo(2));
      expect(states[0], contains('Loading'));
      expect(states[1].contains('Loaded') || states[1].contains('Error'), true);
    });

    test(
      'fetchAddress should return error when placemarks are empty',
      () async {
        final testProvider = GeocodingProvider(
          geocodingFunction: (validLat, validLon) async => [],
        );

        await testProvider.fetchAddress(0.0, 0.0);

        expect(
          testProvider.state,
          const GeocodingState.error('No address found'),
        );
      },
    );

    test(
      'fetchAddress should return error when placemarks are empty',
      () async {
        final testProvider = GeocodingProvider(
          geocodingFunction: (validLat, validLon) async => [],
        );

        final states = <GeocodingState>[];
        testProvider.addListener(() {
          states.add(testProvider.state);
        });

        await testProvider.fetchAddress(0.0, 0.0);

        expect(states.length, 2);
        expect(states[0], const GeocodingState.loading());
        expect(states[1], const GeocodingState.error('No address found'));
        expect(
          testProvider.state,
          const GeocodingState.error('No address found'),
        );
      },
    );
  });
}
