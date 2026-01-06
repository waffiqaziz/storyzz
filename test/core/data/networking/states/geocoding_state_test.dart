import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:storyzz/core/data/networking/states/geocoding_state.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';

import '../../../../tetsutils/mock.dart';

void main() {
  group('GeocodingState', () {
    test('GeocodingState.initial is created correctly', () {
      const state = GeocodingState.initial();
      expect(state, isA<GeocodingStateInitial>());
    });

    test('GeocodingState.loading is created correctly', () {
      const state = GeocodingState.loading();
      expect(state, isA<GeocodingStateLoading>());
    });

    test('GeocodingState.loaded is created correctly', () {
      const state = GeocodingState.loaded(
        formattedAddress: 'Test Address',
        placemark: Placemark(),
      );
      expect(state, isA<GeocodingStateLoaded>());
    });

    test('GeocodingState.error is created correctly', () {
      const state = GeocodingState.error('Test Error');
      expect(state, isA<GeocodingStateError>());
    });
  });

  group('GeocodingStateX Extension', () {
    late MockAppLocalizations mockL10n;

    setUp(() {
      mockL10n = MockAppLocalizations();
    });

    test('getAddressOrFallback returns fallback for initial state', () {
      const state = GeocodingState.initial();
      final result = state.getAddressOrFallback(
        MockBuildContext(),
        localizations: mockL10n,
      );
      expect(result, 'Address Not Available');
    });

    test('getAddressOrFallback returns loading message for loading state', () {
      const state = GeocodingState.loading();
      final result = state.getAddressOrFallback(
        MockBuildContext(),
        localizations: mockL10n,
      );
      expect(result, 'Loading address...');
    });

    test('getAddressOrFallback returns address for loaded state', () {
      const state = GeocodingState.loaded(
        formattedAddress: 'Test Address',
        placemark: Placemark(),
      );
      final result = state.getAddressOrFallback(
        MockBuildContext(),
        localizations: mockL10n,
      );
      expect(result, 'Test Address');
    });

    test('getAddressOrFallback returns fallback for error state', () {
      const state = GeocodingState.error('Test Error');
      final result = state.getAddressOrFallback(
        MockBuildContext(),
        localizations: mockL10n,
      );
      expect(result, 'Address Not Available');
    });

    test('isLoading returns true for loading state', () {
      const state = GeocodingState.loading();
      expect(state.isLoading, true);
    });

    test('isLoading returns false for non-loading states', () {
      expect(const GeocodingState.initial().isLoading, false);
      expect(
        const GeocodingState.loaded(
          formattedAddress: 'Test',
          placemark: Placemark(),
        ).isLoading,
        false,
      );
      expect(const GeocodingState.error('Error').isLoading, false);
    });

    test('hasError returns true for error state', () {
      const state = GeocodingState.error('Test Error');
      expect(state.hasError, true);
    });

    test('hasError returns false for non-error states', () {
      expect(const GeocodingState.initial().hasError, false);
      expect(const GeocodingState.loading().hasError, false);
      expect(
        const GeocodingState.loaded(
          formattedAddress: 'Test',
          placemark: Placemark(),
        ).hasError,
        false,
      );
    });

    test('hasAddress returns true for loaded state', () {
      const state = GeocodingState.loaded(
        formattedAddress: 'Test Address',
        placemark: Placemark(),
      );
      expect(state.hasAddress, true);
    });

    test('hasAddress returns false for non-loaded states', () {
      expect(const GeocodingState.initial().hasAddress, false);
      expect(const GeocodingState.loading().hasAddress, false);
      expect(const GeocodingState.error('Error').hasAddress, false);
    });
  });

  group('GeocodingStateX Extension - Context Localizations', () {
    testWidgets(
      'getAddressOrFallback uses AppLocalizations.of(context) when localizations parameter is null',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                const state = GeocodingState.initial();
                // Call without localizations parameter to trigger fallback
                final result = state.getAddressOrFallback(context);
                expect(result, isA<String>());
                expect(result, isNotEmpty);
                return Container();
              },
            ),
          ),
        );
      },
    );
  });
}
