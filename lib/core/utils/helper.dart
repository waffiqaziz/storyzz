import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

/// Converts a [DateTime] object to a localized string format.
///
/// The returned string is formatted as "MMMM d, yyyy · HH:mm" (e.g., "April 14, 2025 · 22:54").
///
/// Example:
/// ```dart
/// String isoString = '2025-04-14T22:54:29.233Z';
/// DateTime createdAt = DateTime.parse(isoString);
/// String formattedTime = formattedLocalTime(createdAt);
/// print(formattedTime); // Output: "April 14, 2025 · 22:54"
/// ```
/// Parameters:
/// - [createdAt] is the [DateTime] object to be formatted.
String formattedLocalTime(DateTime createdAt) {
  return DateFormat('MMMM d, yyyy · HH:mm').format(createdAt.toLocal());
}

/// Returns a localized time difference string based on the given [createdAt] date.
///
/// The function compares the current time with the provided [createdAt] and returns
/// a human-readable string representing the time difference in days, hours, or minutes.
///
/// If the difference is more than a week, it returns the formatted date (e.g., "Apr 14, 2025 · 22:54").
/// If the difference is within the past week, it returns the relative time (e.g., "3 days ago").
String getTimeDifference(BuildContext context, DateTime createdAt) {
  final localizations = AppLocalizations.of(context)!;
  final dateFormat = DateFormat('MMM d, yyyy · HH:mm');
  final formattedDate = dateFormat.format(createdAt);

  // calculate time difference
  final now = DateTime.now();
  final difference = now.difference(createdAt);
  String timeAgo;

  if (difference.inDays > 7) {
    timeAgo = formattedDate;
  } else if (difference.inDays > 0) {
    timeAgo =
        '${difference.inDays} ${difference.inDays == 1 ? localizations.d_ago_singular : localizations.d_ago_plural}';
  } else if (difference.inHours > 0) {
    timeAgo =
        '${difference.inHours} ${difference.inHours == 1 ? localizations.h_ago_singular : localizations.h_ago_plural}';
  } else if (difference.inMinutes > 0) {
    timeAgo =
        '${difference.inMinutes} ${difference.inMinutes == 1 ? localizations.m_ago_singular : localizations.m_ago_plural}';
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
