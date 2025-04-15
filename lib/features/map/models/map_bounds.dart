import 'package:google_maps_flutter/google_maps_flutter.dart';

/// A class representing the bounds of a map defined by north, south, east, and west coordinates.
///
/// The bounds can be calculated from a list of [LatLng] locations, or they can be manually set.
///
/// Example usage:
/// ```dart
/// final mapBounds = MapBounds.fromLatLngList(locations);
/// final bounds = mapBounds.toBounds();
/// ```
class MapBounds {
  final double? north;
  final double? south;
  final double? east;
  final double? west;

  MapBounds({this.north, this.south, this.east, this.west});

  /// A factory constructor that calculates the bounds based on a list of [LatLng] locations.
  ///
  /// This method loops through the list of locations and calculates the north, south, east, and west boundaries.
  /// If the list is empty or contains a single point, default values are used.
  ///
  /// [locations] A list of [LatLng] objects to compute the bounds.
  ///
  /// Returns a [MapBounds] object representing the computed boundaries.
  factory MapBounds.fromLatLngList(List<LatLng> locations) {
    double? x0, x1, y0, y1;

    for (LatLng latLng in locations) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }

    return MapBounds(north: x1, south: x0, east: y1, west: y0);
  }

  /// Converts the [MapBounds] to a [LatLngBounds] object, which is used by the Google Maps API.
  ///
  /// If any of the bounds values are null (such as from an empty list of locations), this method returns default bounds
  /// that represent the maximum map area.
  ///
  /// Returns a [LatLngBounds] representing the map bounds.
  LatLngBounds toBounds() {
    // Default bounds if values are null (empty list or single point)
    if (north == null || south == null || east == null || west == null) {
      return LatLngBounds(
        northeast: const LatLng(85, 180), // max bounds
        southwest: const LatLng(-85, -180), // min bounds
      );
    }

    return LatLngBounds(
      northeast: LatLng(north!, east!),
      southwest: LatLng(south!, west!),
    );
  }
}
