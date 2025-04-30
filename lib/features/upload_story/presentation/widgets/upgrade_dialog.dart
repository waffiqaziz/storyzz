import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/app_provider.dart';

class UpgradeDialog extends StatelessWidget {
  const UpgradeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.read<AppProvider>();
    final localizations = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(localizations.get_premium),
      content: Text(localizations.premium_benefits_description),
      actions: [
        TextButton(
          onPressed: () => appProvider.closeUpgradeDialog(),
          child: Text(localizations.close),
        ),
        FilledButton(
          onPressed: () {
            appProvider.closeUpgradeDialog();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(localizations.coming_soon)));
          },
          child: Text(localizations.upgrade),
        ),
      ],
    );
  }
}
