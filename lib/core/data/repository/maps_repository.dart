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

  /// Get formatted address from latitude and longitude
  Future<String?> getFormattedAddress(double lat, double lon) async {
    try {
      final response = await _mapsApiService.getAddressFromCoordinates(
        lat,
        lon,
      );
      return response.displayName;
    } catch (e) {
      debugPrint('Error getting formatted address: $e');
      return null;
    }
  }

  /// Get coordinates from address string - implementation would depend on the API
  Future<Map<String, double>?> getCoordinatesFromAddress(String address) async {
    try {
      // This needs to be implemented if maps.co provides a forward geocoding service
      // For now, this is a placeholder
      throw UnimplementedError(
        'Forward geocoding not implemented for maps.co API',
      );
    } catch (e) {
      debugPrint('Error getting coordinates: $e');
      return null;
    }
  }
}
