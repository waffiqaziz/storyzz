import 'package:flutter/foundation.dart';
import 'package:storyzz/core/data/networking/responses/geocoding_response.dart';
import 'package:storyzz/core/data/networking/services/maps_api_services.dart';

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
      debugPrint('Error getting address from coordinates: $e');
      return null;
    }
  }
}
