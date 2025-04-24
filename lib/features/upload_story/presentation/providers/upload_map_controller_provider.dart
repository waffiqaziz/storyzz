import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Provider that used as controller google map
class UploadMapControllerProvider extends ChangeNotifier {
  GoogleMapController? _mapController;

  GoogleMapController? get mapController => _mapController;

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  void disposeController() {
    _mapController?.dispose();
    _mapController = null;
    notifyListeners();
  }

  Future<void> animateCamera(CameraPosition position) async {
    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(position),
      );
    }
  }
}
