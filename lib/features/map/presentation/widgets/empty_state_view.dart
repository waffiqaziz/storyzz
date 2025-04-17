import 'package:flutter/material.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';

/// Used to show emtpy view when no story is found
class EmptyState extends StatelessWidget {
  final AppLocalizations localizations;

  const EmptyState({super.key, required this.localizations});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.auto_stories, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              localizations.no_stories,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                localizations.pull_to_refresh,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
