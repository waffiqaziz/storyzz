import 'package:flutter/material.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';

/// A fallback view displayed when no user data is available.
///
/// Shows a localized message indicating that user information
/// could not be retrieved or is missing.
class NoUserView extends StatelessWidget {
  const NoUserView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Center(child: Text(localizations.no_user_data));
  }
}
