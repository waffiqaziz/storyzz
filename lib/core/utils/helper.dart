import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

/// Returns a localized time difference string based on the given [createdAt] date.
///
/// The function compares the current time with the provided [createdAt] and returns
/// a human-readable string representing the time difference in days, hours, or minutes.
///
/// If the difference is more than a week, it returns the formatted date (e.g., "Apr 14, 2025 · 22:54").
/// If the difference is within the past week, it returns the relative time (e.g., "3 days ago").
String getTimeDifference(BuildContext context, DateTime createdAt) {
  final localizations = AppLocalizations.of(context)!;
  final localeTag = Localizations.localeOf(context).toLanguageTag();
  final dateFormat = DateFormat('MMMM d, yyyy · HH:mm', localeTag);
  final formattedDate = dateFormat.format(createdAt);

  // calculate time difference
  final now = DateTime.now();
  final diff = now.difference(createdAt);
  String timeAgo;

  if (diff.inDays > 7) {
    timeAgo = formattedDate;
  } else if (diff.inDays > 1) {
    timeAgo =
        '${diff.inDays} ${diff.inDays == 1 ? localizations.d_ago_singular : localizations.d_ago_plural}';
  } else if (diff.inDays == 1) {
    final timeFormat = DateFormat('HH:mm', localeTag);
    timeAgo = '${localizations.yesterday} · ${timeFormat.format(createdAt)}';
  } else if (diff.inHours > 0) {
    timeAgo =
        '${diff.inHours} ${diff.inHours == 1 ? localizations.h_ago_singular : localizations.h_ago_plural}';
  } else if (diff.inMinutes > 0) {
    timeAgo =
        '${diff.inMinutes} ${diff.inMinutes == 1 ? localizations.m_ago_singular : localizations.m_ago_plural}';
  } else {
    timeAgo = localizations.just_now;
  }
  return timeAgo;
}

/// Opens a URL in the default web browser.
/// If the URL cannot be launched, an exception is thrown.
Future<void> openUrl(String urlString) async {
  final Uri uri = Uri.parse(urlString);
  if (!await launchUrl(uri)) {
    throw Exception('Could not launch $urlString');
  }
}

/// Format geocoding placemark into readable format
String formatAddress(Placemark placemark) {
  final parts = <String>[
    if (placemark.street?.isNotEmpty ?? false) placemark.street!,
    if (placemark.subLocality?.isNotEmpty ?? false) placemark.subLocality!,
    if (placemark.locality?.isNotEmpty ?? false) placemark.locality!,
    if (placemark.administrativeArea?.isNotEmpty ?? false)
      placemark.administrativeArea!,
    if (placemark.postalCode?.isNotEmpty ?? false) placemark.postalCode!,
    if (placemark.country?.isNotEmpty ?? false) placemark.country!,
  ];

  return parts.isNotEmpty ? parts.join(', ') : 'Unknown location';
}

/// Screensize helper
extension ResponsiveExt on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;

  bool get isMobile => screenWidth < mobileBreakpoint;
  bool get isTablet =>
      screenWidth >= mobileBreakpoint && screenWidth <= tabletBreakpoint;
  bool get isDesktop => screenWidth >= tabletBreakpoint;
}
