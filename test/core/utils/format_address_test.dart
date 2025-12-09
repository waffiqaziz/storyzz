import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:storyzz/core/utils/helper.dart';

void main() {
  group('formatAddress', () {
    test('formats complete address with all fields', () {
      final placemark = Placemark(
        street: '123 Main St',
        subLocality: 'Downtown',
        locality: 'New York',
        administrativeArea: 'NY',
        postalCode: '10001',
        country: 'United States',
      );

      final result = formatAddress(placemark);
      expect(
        result,
        '123 Main St, Downtown, New York, NY, 10001, United States',
      );
    });

    test('formats address with only street', () {
      final placemark = Placemark(street: '456 Oak Ave');

      final result = formatAddress(placemark);
      expect(result, '456 Oak Ave');
    });

    test('formats address with only locality and country', () {
      final placemark = Placemark(locality: 'Paris', country: 'France');

      final result = formatAddress(placemark);
      expect(result, 'Paris, France');
    });

    test('formats address with only administrative area and postal code', () {
      final placemark = Placemark(
        administrativeArea: 'California',
        postalCode: '90210',
      );

      final result = formatAddress(placemark);
      expect(result, 'California, 90210');
    });

    test('skips empty string fields', () {
      final placemark = Placemark(
        street: '789 Pine Rd',
        subLocality: '', // Empty string
        locality: 'Boston',
        administrativeArea: '', // Empty string
        postalCode: '02101',
        country: 'USA',
      );

      final result = formatAddress(placemark);
      expect(result, '789 Pine Rd, Boston, 02101, USA');
    });

    test('skips null fields', () {
      final placemark = Placemark(
        street: '321 Elm St',
        subLocality: null,
        locality: 'Seattle',
        administrativeArea: null,
        postalCode: null,
        country: 'USA',
      );

      final result = formatAddress(placemark);
      expect(result, '321 Elm St, Seattle, USA');
    });

    test('returns "Unknown location" when all fields are null', () {
      final placemark = Placemark(
        street: null,
        subLocality: null,
        locality: null,
        administrativeArea: null,
        postalCode: null,
        country: null,
      );

      final result = formatAddress(placemark);
      expect(result, 'Unknown location');
    });

    test('returns "Unknown location" when all fields are empty strings', () {
      final placemark = Placemark(
        street: '',
        subLocality: '',
        locality: '',
        administrativeArea: '',
        postalCode: '',
        country: '',
      );

      final result = formatAddress(placemark);
      expect(result, 'Unknown location');
    });

    test('returns "Unknown location" when placemark has no data', () {
      final placemark = Placemark();

      final result = formatAddress(placemark);
      expect(result, 'Unknown location');
    });

    test('formats address with mixed null and empty values', () {
      final placemark = Placemark(
        street: '',
        subLocality: null,
        locality: 'Miami',
        administrativeArea: '',
        postalCode: null,
        country: 'USA',
      );

      final result = formatAddress(placemark);
      expect(result, 'Miami, USA');
    });

    test('formats international address', () {
      final placemark = Placemark(
        street: '1-1-1 Shibuya',
        locality: 'Tokyo',
        administrativeArea: 'Tokyo',
        postalCode: '150-0002',
        country: 'Japan',
      );

      final result = formatAddress(placemark);
      expect(result, '1-1-1 Shibuya, Tokyo, Tokyo, 150-0002, Japan');
    });

    test('handles address with only country', () {
      final placemark = Placemark(country: 'Antarctica');

      final result = formatAddress(placemark);
      expect(result, 'Antarctica');
    });

    test('handles subLocality without street', () {
      final placemark = Placemark(
        subLocality: 'Brooklyn',
        locality: 'New York',
        country: 'USA',
      );

      final result = formatAddress(placemark);
      expect(result, 'Brooklyn, New York, USA');
    });
  });
}
