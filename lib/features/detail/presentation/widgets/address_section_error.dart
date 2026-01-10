import 'package:flutter/material.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';

class AddressSectionError extends StatelessWidget {
  const AddressSectionError({
    super.key,
    required this.latText,
    required this.lonText,
  });

  final String latText;
  final String lonText;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          localizations.address_not_available,
          style: TextStyle(color: Colors.red[400]),
        ),
        const SizedBox(height: 4),
        Text(
          '$latText, $lonText',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
