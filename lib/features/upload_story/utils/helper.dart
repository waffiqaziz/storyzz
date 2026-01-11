import 'package:flutter/material.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';

/// Used as helper to transform error message from location operation
/// into error message based on localization (english or indonesian)
String getLocalizedErrorMessage(BuildContext context, String error) {
  if (error.contains('Location services are disabled')) {
    return AppLocalizations.of(context)!.location_services_disabled;
  } else if (error.contains('Location permissions are denied')) {
    return AppLocalizations.of(context)!.location_permissions_denied;
  } else if (error.contains('permanently denied')) {
    return AppLocalizations.of(
      context,
    )!.location_permissions_permanently_denied;
  }
  return AppLocalizations.of(context)!.location_error;
}

typedef OnLocationEnabled = void Function(bool enabled);
