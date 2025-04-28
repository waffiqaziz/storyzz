import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/address_provider.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/features/upload_story/presentation/providers/upload_location_loading_provider.dart';
import 'package:storyzz/features/upload_story/presentation/providers/upload_map_controller_provider.dart';
import 'package:storyzz/features/upload_story/presentation/providers/upload_story_provider.dart';
import 'package:storyzz/features/upload_story/presentation/widgets/build_google_map.dart';
import 'package:storyzz/features/upload_story/presentation/widgets/location_error_display.dart';
import 'package:storyzz/features/upload_story/presentation/widgets/location_map_controls.dart';
import 'package:storyzz/features/upload_story/presentation/widgets/location_map_placeholder.dart';
import 'package:storyzz/features/upload_story/utils/helper.dart';

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
class LocationMapSelector extends StatefulWidget {
  const LocationMapSelector({super.key});

  @override
  State<LocationMapSelector> createState() => _LocationMapSelectorState();
}

class _LocationMapSelectorState extends State<LocationMapSelector> {
  @override
  Widget build(BuildContext context) {
    final uploadProvider = context.watch<UploadStoryProvider>();
    final locationLoadingProvider =
        context.watch<UploadLocationLoadingProvider>();

    // initial get the current position when the map is shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (uploadProvider.includeLocation &&
          uploadProvider.selectedLocation == null &&
          !locationLoadingProvider.isLoading &&
          locationLoadingProvider.errorMessage == null) {
        _getCurrentPosition(context);
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMapHeader(context, uploadProvider),

        // if location is included then shows the map
        if (uploadProvider.includeLocation) ...[
          const SizedBox(height: 16),
          _buildMapContainer(context, uploadProvider, locationLoadingProvider),
          if (uploadProvider.selectedLocation != null) ...[
            const SizedBox(height: 8),

            // shows get current location and cancel button
            LocationMapControls(
              isLoading: locationLoadingProvider.isLoading,

              // use current location
              onUseCurrentLocation: () => _getCurrentPosition(context),

              // move camera
              onMove: () async {
                if (!context.mounted) return;

                final controllerProvider =
                    context.read<UploadMapControllerProvider>();
                final location = uploadProvider.selectedLocation;

                if (location == null) return;

                await controllerProvider.animateCamera(
                  CameraPosition(target: location, zoom: 15),
                );
              },
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildMapHeader(
    BuildContext context,
    UploadStoryProvider uploadProvider,
  ) {
    return Row(
      children: [
        // location text
        Text(
          AppLocalizations.of(context)!.location,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const Spacer(),

        // switch button to shows map
        Switch(
          value: uploadProvider.includeLocation,
          onChanged: (value) {
            uploadProvider.toggleLocationIncluded(value);

            // if turning on and no location is set, try to get current position
            if (value &&
                uploadProvider.selectedLocation == null &&
                !context.read<UploadLocationLoadingProvider>().isLoading) {
              _getCurrentPosition(context);
            }
          },
        ),
      ],
    );
  }

  Widget _buildMapContainer(
    BuildContext context,
    UploadStoryProvider uploadProvider,
    UploadLocationLoadingProvider locationLoadingProvider,
  ) {
    return AnimatedOpacity(
      opacity: uploadProvider.includeLocation ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 700),
      child: Container(
        height: 250,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // show loading indicator if map is not ready
            if (locationLoadingProvider.isLoading &&
                uploadProvider.selectedLocation == null)
              const Center(child: CircularProgressIndicator())
            else ...[
              BuildGoogleMap(),

              // button to open full screen map
              Positioned(
                top: 12,
                left: 12,
                child: PointerInterceptor(
                  child: FloatingActionButton.small(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    onPressed: () {
                      context.read<AppProvider>().openFullScreenMap();
                    },
                    child: const Icon(Icons.fullscreen),
                  ),
                ),
              ),
            ],

            // show error message if unable to get location
            if (locationLoadingProvider.errorMessage != null &&
                uploadProvider.selectedLocation == null)
              LocationErrorDisplay(
                errorMessage: locationLoadingProvider.errorMessage!,
              ),

            // show placeholder if no location selected
            if (uploadProvider.selectedLocation == null &&
                !locationLoadingProvider.isLoading)
              LocationMapPlaceholder(),

            // show loading indicator when try to get current location
            if (locationLoadingProvider.isLoading &&
                uploadProvider.selectedLocation != null)
              _buildLoadingIndicator(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return Positioned(
      bottom: 16,
      left: 16,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Future<void> _getCurrentPosition(BuildContext context) async {
    final uploadProvider = context.read<UploadStoryProvider>();
    final locationLoadingProvider =
        context.read<UploadLocationLoadingProvider>();
    final uploadMapControllerProvider =
        context.read<UploadMapControllerProvider>();

    locationLoadingProvider.setIsLoading(true);
    locationLoadingProvider.setErrorMessage(null);

    try {
      final position = await _determinePosition(context);
      final latLng = LatLng(position.latitude, position.longitude);

      // set the new location in the provider
      uploadProvider.setSelectedLocation(latLng);

      // get formatted address for the marker info window
      if (context.mounted) {
        context.read<AddressProvider>().getAddressFromCoordinates(
          position.latitude,
          position.longitude,
        );
      }

      // Always animate the camera to the new position
      if (context.mounted) {
        await uploadMapControllerProvider.animateCamera(
          CameraPosition(target: latLng, zoom: 15),
        );
      }
    } catch (e) {
      // show error message unable to get location
      // whether the app can't get location permission or
      // theres an error when trying to get current location
      if (context.mounted) {
        locationLoadingProvider.setErrorMessage(
          getLocalizedErrorMessage(context, e.toString()),
        );
      }
    } finally {
      locationLoadingProvider.setIsLoading(false);
    }
  }

  Future<Position> _determinePosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
        return Future.error(
          AppLocalizations.of(context)!.location_services_disabled,
        );
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          return Future.error(
            AppLocalizations.of(context)!.location_permissions_denied,
          );
        }
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        return Future.error(
          AppLocalizations.of(context)!.location_permissions_permanently_denied,
        );
      }
    }

    // permissions is granted
    return await Geolocator.getCurrentPosition();
  }
}
