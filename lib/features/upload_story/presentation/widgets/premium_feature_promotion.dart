import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/app_provider.dart';

/// Widget to promote premium features and prompt users to upgrade.
class PremiumFeaturePromotion extends StatelessWidget {
  const PremiumFeaturePromotion({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: .center,
          children: [
            Icon(
              Icons.location_on,
              size: 40,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 12),
            Text(
              localizations.premium_feature,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: .bold),
            ),
            const SizedBox(height: 8),
            Text(
              localizations.upgrade_to_add_location,
              textAlign: .center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                context.read<AppProvider>().openUpgradeDialog();
              },
              icon: Icon(Icons.star),
              label: Text(localizations.upgrade_now),
            ),
          ],
        ),
      ),
    );
  }
}
