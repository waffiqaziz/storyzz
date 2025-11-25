import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/data/networking/states/geocoding_state.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/geocoding_provider.dart';
import 'package:storyzz/features/detail/presentation/widgets/address_section_error.dart';

class AddressSectionMobile extends StatefulWidget {
  const AddressSectionMobile({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  @override
  State<AddressSectionMobile> createState() => _AddressSectionMobileState();
}

class _AddressSectionMobileState extends State<AddressSectionMobile> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GeocodingProvider>().fetchAddress(
        widget.latitude,
        widget.longitude,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Consumer<GeocodingProvider>(
      builder: (context, provider, child) {
        return provider.state.when(
          initial: () => Text(
            '${widget.latitude.toStringAsFixed(6)}, ${widget.longitude.toStringAsFixed(6)}',
            style: const TextStyle(fontSize: 14),
          ),

          // Loading state
          loading: () => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 8),
                Text("${localizations.loading_address}..."),
              ],
            ),
          ),

          // Loaded state - show formatted address
          loaded: (formattedAddress, placemark) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  formattedAddress,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Text(
                '${widget.latitude.toStringAsFixed(6)}, ${widget.longitude.toStringAsFixed(6)}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),

          // Error state
          error: (message) => AddressSectionError(
            latText: widget.latitude.toString(),
            lonText: widget.longitude.toString(),
          ),
        );
      },
    );
  }
}
