import 'dart:developer' show log;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:storyzz/core/data/networking/responses/list_story.dart';
import 'package:storyzz/features/map/models/map_bounds.dart';

/// A service class for:
/// - handling Google Maps interactions,
/// - managing markers,
/// - tracking processed stories,
/// - and animating the camera to show valid story locations.
class MapService {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  int _validLocationCount = 0;
  final Set<String> _processedIds = {};

  Set<Marker> get markers => _markers;
  int getValidLocationCount() => _validLocationCount;
  Set<String> getProcessedIds() => _processedIds;

  /// Sets the [GoogleMapController] instance used to control the map.
  ///
  /// This should typically be called when the map is first created.
  void setController(GoogleMapController controller) {
    _mapController = controller;
  }

  /// Disposes the current [GoogleMapController] instance.
  ///
  /// Call this method during cleanup (e.g., in `dispose`) to prevent memory leaks.
  void disposeController() {
    _mapController.dispose();
  }

  /// Animates the map camera to the given [position] with the specified [zoom] level.
  void animateCameraToPosition(LatLng position, double zoom) {
    _mapController.animateCamera(CameraUpdate.newLatLngZoom(position, zoom));
  }

  /// Updates the markers on the map based on a list of [stories].
  ///
  /// - Clear existing markers and reset the IDs.
  /// - Only adds markers for stories that have valid latitude and longitude.
  /// - Skips duplicates based on story ID.
  /// - Calls [onStoryTap] when a marker is tapped.
  /// - Automatically adjusts the camera to fit all new markers in view.
  ///
  /// [onStoryTap] is a callback function triggered when a marker is tapped.
  void updateMarkers(
    List<ListStory> stories, {
    required Function(LatLng) onStoryTap,
  }) {
    _markers.clear();
    _processedIds.clear();
    _validLocationCount = 0;
    final List<LatLng> locations = [];

    log("Updating markers for ${stories.length} stories");

    for (final story in stories) {
      // skip if a story already based on the story ID (avoid duplicates)
      if (_processedIds.contains(story.id)) continue;
      _processedIds.add(story.id);

      // log("Story ${story.id}: lat=${story.lat}, lon=${story.lon}");

      if (story.lat != null && story.lon != null) {
        _validLocationCount++;
        final position = LatLng(story.lat!, story.lon!);
        locations.add(position);

        // shows title and description on the marker when tapping
        _markers.add(
          Marker(
            markerId: MarkerId(story.id),
            position: position,
            infoWindow: InfoWindow(
              title: story.name,
              snippet: story.description.length > 50
                  ? '${story.description.substring(0, 50)}...'
                  : story.description,
            ),
            onTap: () => onStoryTap(position),
          ),
        );
      }
    }

    log(
      "Created $_validLocationCount markers out of ${_processedIds.length} unique stories",
    );

    if (locations.isNotEmpty) {
      final MapBounds bounds = MapBounds.fromLatLngList(locations);
      _mapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds.toBounds(), 50),
      );
    }
  }
}
