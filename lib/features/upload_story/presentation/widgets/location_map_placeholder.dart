import 'package:flutter/material.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';

/// Widget to shows a message "tap to select location"
///
/// Used when the app unable to get current location and user
/// can use alternative solution by manually selected the location.
class LocationMapPlaceholder extends StatelessWidget {
  const LocationMapPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surface.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                AppLocalizations.of(context)!.tap_to_select_location,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
