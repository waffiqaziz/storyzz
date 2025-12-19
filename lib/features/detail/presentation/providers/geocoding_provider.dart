import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:storyzz/core/data/networking/states/geocoding_state.dart';
import 'package:storyzz/core/utils/helper.dart';

class GeocodingProvider extends ChangeNotifier {
  GeocodingState _state = const GeocodingState.initial();

  GeocodingState get state => _state;

  /// Fetches address from coordinates using geocoding package
  Future<void> fetchAddress(double latitude, double longitude) async {
    _state = const GeocodingState.loading();
    notifyListeners();

    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isEmpty) {
        _state = const GeocodingState.error('No address found');
        notifyListeners();
        return;
      }

      final placemark = placemarks.first;
      final formattedAddress = formatAddress(placemark);

      _state = GeocodingState.loaded(
        formattedAddress: formattedAddress,
        placemark: placemark,
      );
      notifyListeners();
    } catch (e) {
      _state = GeocodingState.error(e.toString());
      notifyListeners();
    }
  }

  /// Resets the state to initial
  void reset() {
    _state = const GeocodingState.initial();
    notifyListeners();
  }
}
