import 'package:flutter/material.dart';

class AddressSectionFormattedAddress extends StatelessWidget {
  const AddressSectionFormattedAddress({
    super.key,
    required this.address,
    required this.latText,
    required this.lonText,
  });

  final String address;
  final String latText;
  final String lonText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(address, style: Theme.of(context).textTheme.bodyMedium),
        ),
        Text(
          '$latText, $lonText',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }
}
