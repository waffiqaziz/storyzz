import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/data/networking/states/address_load_state.dart';
import 'package:storyzz/core/providers/address_provider.dart';
import 'package:storyzz/features/detail/presentation/widgets/address_section_error.dart';
import 'package:storyzz/features/detail/presentation/widgets/address_section_formatted_address.dart';
import 'package:storyzz/features/detail/presentation/widgets/address_section_loading.dart';

class AddressSectionWeb extends StatelessWidget {
  const AddressSectionWeb({
    super.key,
    required this.latText,
    required this.lonText,
  });

  final String latText;
  final String lonText;

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressProvider>(
      builder: (context, addressProvider, child) {
        switch (addressProvider.state) {
          // show loading
          case AddressLoadStateLoading():
            return AddressSectionLoading();

          // show actual formatted addresss
          case AddressLoadStateLoaded(formattedAddress: final address):
            return AddressSectionFormattedAddress(
              address: address,
              latText: latText,
              lonText: lonText,
            );

          // shows not available if theres an error
          case AddressLoadStateError():
            return AddressSectionError(latText: latText, lonText: lonText);

          // show the latitude and longiture on initial
          case AddressLoadStateInitial():
            return Text(
              '$latText, $lonText',
              style: Theme.of(context).textTheme.bodySmall,
            );

          // should not show
          default:
            return Text('Unknown state: ${addressProvider.state}');
        }
      },
    );
  }
}
