import 'package:flutter/material.dart';
import 'package:storyzz/core/design/insets.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';

/// A placeholder widget displayed when there are no stories to show.
///
/// Uses a [SliverFillRemaining] layout to center an icon and message.
/// Typically shown in a scrollable view when the story list is empty.
class EmptyStory extends StatelessWidget {
  const EmptyStory({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Icon(Icons.auto_stories, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.no_stories,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: .bold),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: Insets.v16,
              child: Text(
                AppLocalizations.of(context)!.pull_to_refresh,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
