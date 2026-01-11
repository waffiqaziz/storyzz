import 'package:amazing_icons/outlined.dart';
import 'package:flutter/material.dart';
import 'package:storyzz/core/design/insets.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';

/// A widget that displays an error message when story data fails to load.
///
/// Shows a warning icon, the provided error message, and a retry button.
/// The retry action is triggered by the [onRetry] callback.
class StoryErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const StoryErrorView({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: Insets.all16,
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Icon(
              AmazingIconOutlined.danger,
              size: 64,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            Text(
              '${localizations.error_loading_stories} $errorMessage',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: .center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: Padding(
                padding: Insets.h24,
                child: Text(localizations.retry),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
