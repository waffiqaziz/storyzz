import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/data/networking/states/address_load_state.dart';
import 'package:storyzz/core/providers/address_provider.dart';
import 'package:storyzz/features/map/utils/map_style.dart';
import 'package:storyzz/features/upload_story/presentation/providers/upload_map_controller_provider.dart';
import 'package:storyzz/features/upload_story/presentation/providers/upload_story_provider.dart';

class BuildGoogleMap extends StatelessWidget {
  const BuildGoogleMap({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final uploadProvider = context.watch<UploadStoryProvider>();

    return context.mounted
        ? GoogleMap(
            gestureRecognizers: {
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
            style: isDark ? customStyleDark : customStyleLight,
            mapType: MapType.normal,
            markers: {
              if (uploadProvider.selectedLocation != null)
                Marker(
                  markerId: const MarkerId('story_location'),
                  position: uploadProvider.selectedLocation!,
                  draggable: true,
                  onDragEnd: (newPosition) {
                    uploadProvider.setSelectedLocation(newPosition);

                    // get formatted address for the new position
                    context.read<AddressProvider>().getAddressFromCoordinates(
                      newPosition.latitude,
                      newPosition.longitude,
                    );
                  },
                  infoWindow: InfoWindow(
                    // show formatted address as snippet
                    snippet: context
                        .watch<AddressProvider>()
                        .state
                        .getAddressOrFallback(context),
                  ),
                ),
            },

            // default position is Indonesian if unable to get current location
            initialCameraPosition: CameraPosition(
              target:
                  uploadProvider.selectedLocation ??
                  const LatLng(-2.014380, 118.152180), // Default to Indonesia
              zoom: uploadProvider.selectedLocation != null ? 15 : 4,
            ),

            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              context.read<UploadMapControllerProvider>().setMapController(
                controller,
              );
            },
            onTap: (position) {
              uploadProvider.setSelectedLocation(position);

              // get formatted address
              context.read<AddressProvider>().getAddressFromCoordinates(
                position.latitude,
                position.longitude,
              );
            },
          )
        : const SizedBox.shrink();
  }
}
