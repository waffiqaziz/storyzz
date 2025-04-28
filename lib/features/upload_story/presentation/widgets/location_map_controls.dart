import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/features/upload_story/presentation/providers/upload_story_provider.dart';

/// A widget to shows buttons to controll the map
///
/// - Button to use current location
/// - Button to cancel select a location
class LocationMapControls extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onUseCurrentLocation;
  final VoidCallback onMove;

  const LocationMapControls({
    super.key,
    required this.isLoading,
    required this.onUseCurrentLocation,
    required this.onMove,
  });

  @override
  Widget build(BuildContext context) {
    final location = context.watch<UploadStoryProvider>().selectedLocation!;

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
          onPressed: onMove,
          icon: const Icon(Icons.center_focus_strong, size: 18),
          label: Text(AppLocalizations.of(context)!.center_map),
        ),
      ],
    );
  }
}
