import 'package:amazing_icons/amazing_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/core/providers/auth_provider.dart';

/// A dialog that confirms whether the user wants to logout or not.
/// It is shown when the user taps on the logout button in the app bar.
class LogoutConfirmationDialog extends StatelessWidget {
  const LogoutConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final appProvider = context.read<AppProvider>();
    final localizations = AppLocalizations.of(context)!;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            appProvider.closeLogoutDialog();
          });
        }
      },
      child: AlertDialog(
        icon: Icon(
          AmazingIconFilled.danger,
          color: Colors.amberAccent.shade200,
          size: 75,
        ),
        shape: RoundedRectangleBorder(borderRadius: .circular(16.0)),
        title: Text(
          localizations.logout_confirmation,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: .bold),
        ),
        content: Text(
          localizations.logout_confirmation_msg,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: .center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              appProvider.closeLogoutDialog();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.grey),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () async {
              await authProvider.logout();
              if (context.mounted) {
                appProvider.closeLogoutDialog();
                if (authProvider.logoutSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(localizations.logout_success)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(authProvider.errorMessage)),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerLowest,
            ),
            child: Text(
              localizations.logout,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
