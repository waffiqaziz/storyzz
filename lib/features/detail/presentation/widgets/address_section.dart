import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/address_provider.dart';
import 'package:storyzz/features/detail/presentation/widgets/address_section_mobile.dart';
import 'package:storyzz/features/detail/presentation/widgets/address_section_web.dart';

/// A widget that displays a formatted address for given coordinates.
///
/// It reacts to [AddressProvider] state and shows:
/// - a loading indicator while fetching,
/// - the formatted address once loaded,
/// - fallback coordinates or error messages if loading fails.
///
/// Parameters:
/// [latitude] and [longitude] are the coordinates to resolve.
/// [storyId] is used for tracking/address caching purposes.
class AddressSection extends StatefulWidget {
  final double latitude;
  final double longitude;

  const AddressSection({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<AddressSection> createState() => _AddressSectionState();
}

class _AddressSectionState extends State<AddressSection> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final latText =
        '${localizations.latitude}: ${widget.latitude.toStringAsFixed(6)}';
    final lonText =
        '${localizations.longitude}: ${widget.longitude.toStringAsFixed(6)}';

    if (kIsWeb) {
      debugPrint('[WEB] AddressSection: Using web implementation');
    } else {
      debugPrint('[MOBILE] AddressSection: Using mobile implementation');
    }
    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.red),
            const SizedBox(width: 8),
            Text(
              localizations.location,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: .bold),
            ),
          ],
        ),
        const SizedBox(height: 8),

        /// Readable address based on platform
        /// - for mobile use geocoding package
        /// - for website use geocoding rest API
        if (kIsWeb) ...[
          AddressSectionWeb(latText: latText, lonText: lonText),
        ] else ...[
          AddressSectionMobile(
            latitude: widget.latitude,
            longitude: widget.longitude,
          ),
        ],
      ],
    );
  }
}
