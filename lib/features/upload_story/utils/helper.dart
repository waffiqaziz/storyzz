import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/features/upload_story/data/model/country_coordinates.dart';

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

LatLng? getCountryCoordinates(String countryCode) {
  // Convert to uppercase for case-insensitive lookup
  return countryCoordinates[countryCode.toUpperCase()];
}
