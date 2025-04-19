import 'package:flutter/foundation.dart';
import 'package:storyzz/core/data/networking/responses/geocoding_response.dart';
import 'package:storyzz/core/data/repository/maps_repository.dart';

/// Represents the loading state of an address fetch operation.
enum AddressLoadState { initial, loading, loaded, error }

/// A provider that handles fetching and storing address data from coordinates.
class AddressProvider extends ChangeNotifier {
  final MapsRepository _mapsRepository;

  AddressLoadState _state = AddressLoadState.initial;
  String? _formattedAddress;
  GeocodingResponse? _detailedAddress;
  String? _errorMessage;

  AddressProvider(this._mapsRepository);

  /// Current state of the address loading process.
  AddressLoadState get state => _state;

  /// A human-readable formatted address (e.g., "123 Main St, City").
  String? get formattedAddress => _formattedAddress;

  /// Detailed geocoding response with full address info.
  GeocodingResponse? get detailedAddress => _detailedAddress;

  /// Error message if address fetching fails.
  String? get errorMessage => _errorMessage;

  /// Fetches a formatted address and detailed info from given latitude and longitude.
  ///
  /// Updates [state], [formattedAddress], [detailedAddress], and [errorMessage] accordingly.
  ///
  /// Notes:
  /// - The geocoding service has a rate limit of 1 request per second for free accounts (HTTP 429).
  /// - High traffic may lead to server rejections (HTTP 503).
  /// - https://geocode.maps.co/
  Future<void> getAddressFromCoordinates(double lat, double lon) async {
    _state = AddressLoadState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _mapsRepository.getAddressFromCoordinates(
        lat,
        lon,
      );
      if (response != null) {
        _formattedAddress = response.displayName;
        _detailedAddress = response;
        _state = AddressLoadState.loaded;
      } else {
        throw Exception('No address data returned');
      }
    } catch (e) {
      _state = AddressLoadState.error;
      _errorMessage = 'Failed to load address: $e';
    }

    notifyListeners();
  }

  /// Resets the state and clears any cached address data or errors.
  void reset() {
    _state = AddressLoadState.initial;
    _formattedAddress = null;
    _detailedAddress = null;
    _errorMessage = null;
    notifyListeners();
  }
}
