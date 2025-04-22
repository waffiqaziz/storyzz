import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/data/networking/states/address_load_state.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/provider/address_provider.dart';

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
  final String storyId;

  const AddressSection({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.storyId,
  });

  @override
  State<AddressSection> createState() => _AddressSectionState();
}

class _AddressSectionState extends State<AddressSection> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.red),
            const SizedBox(width: 8),
            Text(
              localizations.location,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Show readable address
        Consumer<AddressProvider>(
          builder: (context, addressProvider, child) {
            final latText =
                '${localizations.latitude}: ${widget.latitude.toStringAsFixed(6)}';
            final lonText =
                '${localizations.longitude}: ${widget.longitude.toStringAsFixed(6)}';

            switch (addressProvider.state) {
              // show loading
              case AddressLoadStateLoading():
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text("${localizations.loading_address}..."),
                    ],
                  ),
                );

              // show actual formatted addresss
              case AddressLoadStateLoaded(formattedAddress: final address):
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        address,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Text(
                      '$latText, $lonText',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                );

              // shows not available if theres an error
              case AddressLoadStateError():
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.address_not_available,
                      style: TextStyle(color: Colors.red[400], fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$latText, $lonText',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                );

              // show the latitude and longiture on initial
              case AddressLoadStateInitial():
                return Text(
                  '$latText, $lonText',
                  style: const TextStyle(fontSize: 14),
                );

              // should not show
              default:
                return Text('Unknown state: ${addressProvider.state}');
            }
          },
        ),
      ],
    );
  }
}
