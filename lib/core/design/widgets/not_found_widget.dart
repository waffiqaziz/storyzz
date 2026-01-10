import 'package:flutter/material.dart';
import 'package:storyzz/core/design/insets.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/navigation/app_router.dart';

class NotFoundWidget extends StatelessWidget {
  const NotFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Text(AppLocalizations.of(context)!.story_not_found),
            ElevatedButton(
              onPressed: () => context.navigateToHome(),
              child: Padding(
                padding: Insets.v16,
                child: Text(AppLocalizations.of(context)!.go_to_home),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
