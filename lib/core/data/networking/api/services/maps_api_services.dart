import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:storyzz/core/data/networking/api/endpoints.dart';
import 'package:storyzz/core/data/networking/models/geocoding/geocoding_response.dart';
import 'package:storyzz/core/utils/environment.dart';

class MapsApiService {
  static const String _baseUrl = geocodeBaseURL;
  static const String _reversePath = '/reverse';
  static String get _apiKey => MapsEnvironment.mapsCoApiKey;

  final http.Client _httpClient;

  MapsApiService({required http.Client httpClient}) : _httpClient = httpClient;

  /// Reverse geocode to get address from latitude and longitude
  Future<GeocodingResponse> getAddressFromCoordinates(
    double lat,
    double lon,
  ) async {
    final queryParameters = {
      'lat': lat.toString(),
      'lon': lon.toString(),
      'api_key': _apiKey,
    };

    final uri = Uri.https(_baseUrl, _reversePath, queryParameters);

    try {
      final response = await _httpClient.get(uri);

      if (response.statusCode == 200) {
        return GeocodingResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to get address: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to maps.co API: $e');
    }
  }
}
