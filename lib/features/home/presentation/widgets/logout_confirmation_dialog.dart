import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/core/providers/auth_provider.dart';

/// A dialog that confirms whether the user wants to log out or not.
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
            appProvider.closeDialogLogOut();
          });
        }
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: Text(
          localizations.logout_confirmation,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
        ),
        content: Text(
          localizations.logout_confirmation_msg,
          style: TextStyle(fontSize: 16.0),
        ),
        actions: [
          TextButton(
            onPressed: () {
              appProvider.closeDialogLogOut();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.grey),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                appProvider.closeDialogLogOut();
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Text(localizations.logout),
            ),
          ),
        ],
      ),
    );
  }
}
