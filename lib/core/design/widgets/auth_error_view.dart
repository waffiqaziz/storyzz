import 'package:flutter/material.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';

/// Displays an error message related to authentication issues.
///
/// Useful when login fails or user session is invalid. Shows:
/// - An error icon
/// - The provided [errorMessage]
/// - A logout button for recovery or retry
///
/// Parameters:
/// - [errorMessage]: Message describing the auth error.
/// - [onLogout]: Callback triggered when the user presses the logout button.
class AuthErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onLogout;

  const AuthErrorView({
    super.key,
    required this.errorMessage,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error: $errorMessage',
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onLogout,
            child: Text(localizations.logout),
          ),
        ],
      ),
    );
  }
}
