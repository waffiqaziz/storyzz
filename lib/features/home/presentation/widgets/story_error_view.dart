import 'package:flutter/material.dart';
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            size: 64,
            color: Colors.orange,
          ),
          const SizedBox(height: 16),
          Text(
            '${localizations.error_loading_stories} $errorMessage',
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(localizations.retry),
            ),
          ),
        ],
      ),
    );
  }
}
