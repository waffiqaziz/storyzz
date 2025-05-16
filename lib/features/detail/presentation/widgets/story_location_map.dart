import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/providers/settings_provider.dart';
import 'package:storyzz/features/map/utils/map_style.dart';

/// Displays a Google Map centered on a story's location with optional controls and custom styling.
///
/// This widget:
/// - Waits 600ms before building the map to avoid errors during transitions (e.g. dialogs)
/// - Displays a marker at the provided latitude and longitude
/// - Adapts to dark/light theme using a custom map style
///
/// Parameters:
/// - [latitude]: Latitude of the story location
/// - [longitude]: Longitude of the story location
/// - [height]: Fixed height of the map container (default: 200.0)
/// - [borderRadius]: Optional border radius for the map container
/// - [controlsEnabled]: Enables zoom and location buttons (default: true)
class StoryLocationMap extends StatefulWidget {
  final double latitude;
  final double longitude;
  final double height;
  final BorderRadius? borderRadius;
  final bool controlsEnabled;
  final String title;
  final String location;

  const StoryLocationMap({
    super.key,
    required this.latitude,
    required this.longitude,
    this.height = 200.0,
    this.borderRadius,
    this.controlsEnabled = true,
    required this.title,
    required this.location,
  });

  @override
  State<StoryLocationMap> createState() => _StoryLocationMapState();
}

class _StoryLocationMapState extends State<StoryLocationMap> {
  @override
  Widget build(BuildContext context) {
    final isDark = context.select<SettingsProvider, bool>(
      (provider) => provider.setting?.isDark == true,
    );

    // create map marker for the story location
    final Set<Marker> markers = {
      Marker(
        markerId: MarkerId('story-location'),
        position: LatLng(widget.latitude, widget.longitude),
        infoWindow: InfoWindow(title: widget.title, snippet: widget.location),
      ),
    };

    return FutureBuilder(
      // delay map build slightly to prevent error when rendering during a transition or dialog show
      future: Future.delayed(
        const Duration(milliseconds: 600),
      ).then((_) => mounted),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return SizedBox(
            height: widget.height,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return Container(
          height: widget.height,
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
          ),
          child: Listener(
            key: const Key('map_listener'),
            onPointerDown: (_) => FocusScope.of(context).unfocus(),
            child:
                context
                        .mounted // to prevent error when navigating away from the page
                    ? GoogleMap(
                      gestureRecognizers: {
                        Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer(),
                        ),
                      },
                      style: isDark ? customStyleDark : customStyleLight,
                      mapType: MapType.normal,
                      markers: markers,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(widget.latitude, widget.longitude),
                        zoom: 11.0,
                      ),
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: widget.controlsEnabled,
                      zoomGesturesEnabled: true,
                    )
                    : const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
