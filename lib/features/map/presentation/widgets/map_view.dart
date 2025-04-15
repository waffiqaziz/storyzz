import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/features/map/utils/map_style.dart';
import 'package:storyzz/core/provider/settings_provider.dart';
import 'package:storyzz/features/map/controller/map_story_controller.dart';

/// A widget that displays a [GoogleMap] with dynamic theming, markers,
/// and map type, controlled via a [MapStoryController].
///
/// The map adapts to the app's theme by switching between dark and light styles.
/// It supports zoom gestures, controls, and shows the user's location button.
class MapView extends StatelessWidget {
  final MapStoryController controller;

  const MapView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // set style map based on theme
    final isDark = context.watch<SettingsProvider>().setting?.isDark == true;

    return GoogleMap(
      style: isDark ? customStyleDark : customStyleLight,
      mapType: controller.selectedMapType,
      markers: controller.markers,
      initialCameraPosition: const CameraPosition(
        target: LatLng(-2.014380, 118.152180),
        zoom: 4,
      ),
      myLocationButtonEnabled: true,
      zoomControlsEnabled: true,
      zoomGesturesEnabled: true,
      onMapCreated: controller.onMapCreated,
    );
  }
}
