import 'dart:developer';

import 'package:storyzz/core/data/networking/api/services/maps_api_services.dart';
import 'package:storyzz/core/data/networking/models/geocoding/geocoding_response.dart';

class MapsRepository {
  final MapsApiService _mapsApiService;

  MapsRepository(this._mapsApiService);

  /// Get full geocoding response from latitude and longitude
  Future<GeocodingResponse?> getAddressFromCoordinates(
    double lat,
    double lon,
  ) async {
    try {
      final response = await _mapsApiService.getAddressFromCoordinates(
        lat,
        lon,
      );
      return response;
    } catch (e) {
      log('Error getting address from coordinates: $e');
      return null;
    }
  }
}
