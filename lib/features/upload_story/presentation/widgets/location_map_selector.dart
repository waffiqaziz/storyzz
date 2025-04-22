import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/data/networking/states/address_load_state.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/provider/address_provider.dart';
import 'package:storyzz/core/provider/upload_story_provider.dart';
import 'package:storyzz/features/map/utils/map_style.dart';

/// A widget that allows users to optionally include and select a location
/// for a story upload using Google Maps.
///
/// This widget displays:
/// - A label with a toggle switch to include/exclude location.
/// - A Google Map for location selection when the toggle is on.
/// - A draggable marker for fine-tuning the selected location.
/// - A tap-to-select prompt if no location is currently selected.
/// - Latitude and longitude display of the selected location.
/// - A button to clear the selected location.
class LocationMapSelector extends StatelessWidget {
  const LocationMapSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final uploadProvider = context.watch<UploadStoryProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.location,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),

            // swich to show map view
            Switch(
              value: uploadProvider.includeLocation,
              onChanged: (value) {
                uploadProvider.toggleLocationIncluded(value);
              },
            ),
          ],
        ),
        if (uploadProvider.includeLocation) ...[
          const SizedBox(height: 16),
          AnimatedOpacity(
            opacity: uploadProvider.includeLocation ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 700),
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  // show map
                  GoogleMap(
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
                    initialCameraPosition: CameraPosition(
                      target:
                          uploadProvider.selectedLocation ??
                          const LatLng(-2.014380, 118.152180),
                      zoom: uploadProvider.selectedLocation != null ? 12 : 4,
                    ),
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: true,
                    zoomGesturesEnabled: true,
                    onTap: (position) {
                      uploadProvider.setSelectedLocation(position);

                      // get formatted address
                      context.read<AddressProvider>().getAddressFromCoordinates(
                        position.latitude,
                        position.longitude,
                      );
                    },
                  ),

                  // show touch icon if user not yet selected any location
                  if (uploadProvider.selectedLocation == null)
                    Positioned.fill(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.touch_app,
                              size: 40,
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.8),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.surface.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                AppLocalizations.of(
                                  context,
                                )!.tap_to_select_location,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (uploadProvider.selectedLocation != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                // latitude and longitude
                Expanded(
                  child: Text(
                    '${uploadProvider.selectedLocation!.latitude.toStringAsFixed(6)}, '
                    '${uploadProvider.selectedLocation!.longitude.toStringAsFixed(6)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),

                // button to clear the selected location.
                TextButton.icon(
                  onPressed: () {
                    uploadProvider.setSelectedLocation(null);
                  },
                  icon: const Icon(Icons.clear, size: 18),
                  label: Text(AppLocalizations.of(context)!.cancel),
                ),
              ],
            ),
          ],
        ],
      ],
    );
  }
}
