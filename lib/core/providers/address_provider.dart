import 'package:flutter/foundation.dart';
import 'package:storyzz/core/data/networking/states/address_load_state.dart';
import 'package:storyzz/core/data/repositories/maps_repository.dart';

/// A provider that handles fetching and storing address data from coordinates.
class AddressProvider extends ChangeNotifier {
  final MapsRepository _mapsRepository;

  AddressProvider(this._mapsRepository);

  /// Current state of the address loading process.
  AddressLoadState _state = const AddressLoadState.initial();
  AddressLoadState get state => _state;

  /// Fetches a formatted address and detailed info from given latitude and longitude.
  ///
  /// Notes:
  /// - The geocoding service has a rate limit of 1 request per second for free accounts (HTTP 429).
  /// - High traffic may lead to server rejections (HTTP 503).
  /// - https://geocode.maps.co/
  Future<void> getAddressFromCoordinates(double lat, double lon) async {
    _state = const AddressLoadState.loading();
    notifyListeners();

    try {
      final response = await _mapsRepository.getAddressFromCoordinates(
        lat,
        lon,
      );
      if (response != null) {
        _state = AddressLoadState.loaded(response.displayName);
      } else {
        _state = AddressLoadState.error('No address data returned');
      }
    } catch (e) {
      _state = AddressLoadState.error(e.toString());
    }

    notifyListeners();
  }

  /// Resets the state and clears any cached address data or errors.
  void reset() {
    _state = AddressLoadState.initial();
    notifyListeners();
  }
}
