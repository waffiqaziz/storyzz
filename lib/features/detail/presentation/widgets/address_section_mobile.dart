import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/data/networking/states/geocoding_state.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/features/detail/presentation/providers/geocoding_provider.dart';
import 'package:storyzz/features/detail/presentation/widgets/address_section_error.dart';
import 'package:storyzz/features/detail/presentation/widgets/address_section_formatted_address.dart';
import 'package:storyzz/features/detail/presentation/widgets/address_section_loading.dart';

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
    final latText =
        '${localizations.latitude}: ${widget.latitude.toStringAsFixed(6)}';
    final lonText =
        '${localizations.longitude}: ${widget.longitude.toStringAsFixed(6)}';

    return Consumer<GeocodingProvider>(
      builder: (context, provider, child) {
        return provider.state.when(
          initial: () => Text(
            '$latText, $lonText',
            style: Theme.of(context).textTheme.bodySmall,
          ),

          // Loading state
          loading: () => AddressSectionLoading(),

          // Loaded state - show formatted address
          loaded: (formattedAddress, placemark) =>
              AddressSectionFormattedAddress(
                address: formattedAddress,
                latText: latText,
                lonText: lonText,
              ),

          // Error state
          error: (message) =>
              AddressSectionError(latText: latText, lonText: lonText),
        );
      },
    );
  }
}
