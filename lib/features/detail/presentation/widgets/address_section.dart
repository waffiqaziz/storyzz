import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/provider/address_provider.dart';

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
              case AddressLoadState.loading:
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

              case AddressLoadState.loaded:
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (addressProvider.formattedAddress != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          addressProvider.formattedAddress!,
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
              case AddressLoadState.error:
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

              case AddressLoadState.initial:
                return Text(
                  '$latText, $lonText',
                  style: const TextStyle(fontSize: 14),
                );
            }
          },
        ),
      ],
    );
  }
}
