import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:storyzz/features/map/models/map_bounds.dart';

void main() {
  group('MapBounds', () {
    test('constructor initializes all fields correctly', () {
      final bounds = MapBounds(north: 10.0, south: 5.0, east: 20.0, west: 15.0);

      expect(bounds.north, 10.0);
      expect(bounds.south, 5.0);
      expect(bounds.east, 20.0);
      expect(bounds.west, 15.0);
    });

    test('constructor allows null values', () {
      final bounds = MapBounds();

      expect(bounds.north, isNull);
      expect(bounds.south, isNull);
      expect(bounds.east, isNull);
      expect(bounds.west, isNull);
    });

    group('fromLatLngList', () {
      test('calculates bounds from multiple locations', () {
        final locations = [
          const LatLng(10.0, 20.0),
          const LatLng(5.0, 15.0),
          const LatLng(15.0, 25.0),
          const LatLng(8.0, 18.0),
        ];

        final bounds = MapBounds.fromLatLngList(locations);

        expect(bounds.north, 15.0);
        expect(bounds.south, 5.0);
        expect(bounds.east, 25.0);
        expect(bounds.west, 15.0);
      });

      test('handles single location', () {
        final locations = [const LatLng(10.0, 20.0)];

        final bounds = MapBounds.fromLatLngList(locations);

        expect(bounds.north, 10.0);
        expect(bounds.south, 10.0);
        expect(bounds.east, 20.0);
        expect(bounds.west, 20.0);
      });

      test('handles empty list', () {
        final locations = <LatLng>[];

        final bounds = MapBounds.fromLatLngList(locations);

        expect(bounds.north, isNull);
        expect(bounds.south, isNull);
        expect(bounds.east, isNull);
        expect(bounds.west, isNull);
      });

      test('handles negative coordinates', () {
        final locations = [
          const LatLng(-10.0, -20.0),
          const LatLng(-5.0, -15.0),
          const LatLng(-15.0, -25.0),
        ];

        final bounds = MapBounds.fromLatLngList(locations);

        expect(bounds.north, -5.0);
        expect(bounds.south, -15.0);
        expect(bounds.east, -15.0);
        expect(bounds.west, -25.0);
      });
    });

    group('toBounds', () {
      test('converts to LatLngBounds with valid values', () {
        final mapBounds = MapBounds(
          north: 10.0,
          south: 5.0,
          east: 20.0,
          west: 15.0,
        );

        final latLngBounds = mapBounds.toBounds();

        expect(latLngBounds.northeast.latitude, 10.0);
        expect(latLngBounds.northeast.longitude, 20.0);
        expect(latLngBounds.southwest.latitude, 5.0);
        expect(latLngBounds.southwest.longitude, 15.0);
      });

      test('returns default bounds when all values are null', () {
        final mapBounds = MapBounds();

        final latLngBounds = mapBounds.toBounds();

        expect(latLngBounds.northeast.latitude, 85);
        expect(latLngBounds.northeast.longitude, -180.0);
        expect(latLngBounds.southwest.latitude, -85);
        expect(latLngBounds.southwest.longitude, -180.0);
      });

      test('returns default bounds when north is null', () {
        final mapBounds = MapBounds(south: 5.0, east: 20.0, west: 15.0);

        final latLngBounds = mapBounds.toBounds();

        expect(latLngBounds.northeast.latitude, 85);
        expect(latLngBounds.northeast.longitude, -180.0);
      });

      test('returns default bounds when south is null', () {
        final mapBounds = MapBounds(north: 10.0, east: 20.0, west: 15.0);

        final latLngBounds = mapBounds.toBounds();

        expect(latLngBounds.northeast.latitude, 85);
        expect(latLngBounds.northeast.longitude, -180.0);
      });

      test('returns default bounds when east is null', () {
        final mapBounds = MapBounds(north: 10.0, south: 5.0, west: 15.0);

        final latLngBounds = mapBounds.toBounds();

        expect(latLngBounds.northeast.latitude, 85);
        expect(latLngBounds.northeast.longitude, -180.0);
      });

      test('returns default bounds when west is null', () {
        final mapBounds = MapBounds(north: 10.0, south: 5.0, east: 20.0);

        final latLngBounds = mapBounds.toBounds();

        expect(latLngBounds.northeast.latitude, 85);
        expect(latLngBounds.northeast.longitude, -180.0);
      });
    });
  });
}
