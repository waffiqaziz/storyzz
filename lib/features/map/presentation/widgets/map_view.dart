import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/providers/settings_provider.dart';
import 'package:storyzz/features/map/controller/map_story_controller.dart';
import 'package:storyzz/features/map/provider/map_provider.dart';
import 'package:storyzz/features/map/utils/map_style.dart';

/// A widget that displays a [GoogleMap] with dynamic theming, markers,
/// and map type, controlled via a [MapStoryController].
///
/// The map adapts to the app's theme by switching between dark and light styles.
/// It supports zoom gestures, controls, and shows the user's location button.
class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    // set style map based on theme
    final isDark = context.watch<SettingsProvider>().setting?.isDark == true;
    final mapProvider = context.watch<MapProvider>();

    return GoogleMap(
      gestureRecognizers: {
        Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
      },
      style: isDark ? customStyleDark : customStyleLight,
      mapType: mapProvider.selectedMapType,
      markers: mapProvider.markers,
      initialCameraPosition: const CameraPosition(
        target: LatLng(-2.014380, 118.152180),
        zoom: 4,
      ),
      myLocationButtonEnabled: true,
      zoomControlsEnabled: true,
      zoomGesturesEnabled: true,
      onMapCreated: mapProvider.onMapCreated,
    );
  }
}
