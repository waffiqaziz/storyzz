import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';

/// A widget to shows buttons to controll the map
///
/// - Button to use current location
/// - Button to cancel select a location
class LocationMapControls extends StatelessWidget {
  final LatLng location;
  final bool isLoading;
  final VoidCallback onUseCurrentLocation;
  final VoidCallback onClear;

  const LocationMapControls({
    super.key,
    required this.location,
    required this.isLoading,
    required this.onUseCurrentLocation,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // show latitude and longitude
        Expanded(
          child: Text(
            '${location.latitude.toStringAsFixed(6)}, '
            '${location.longitude.toStringAsFixed(6)}',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),

        // button to use current location
        TextButton.icon(
          onPressed: isLoading ? null : onUseCurrentLocation,
          icon: const Icon(Icons.my_location, size: 18),
          label: Text(AppLocalizations.of(context)!.use_current_location),
        ),

        // button to clear the selected location
        TextButton.icon(
          onPressed: onClear,
          icon: const Icon(Icons.clear, size: 18),
          label: Text(AppLocalizations.of(context)!.cancel),
        ),
      ],
    );
  }
}
