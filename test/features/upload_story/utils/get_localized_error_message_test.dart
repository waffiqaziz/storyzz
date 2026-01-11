import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/features/upload_story/utils/helper.dart';

import '../../../tetsutils/context_widget.dart';

void main() {
  late BuildContext testContext;

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: const [Locale('en')],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: TestContextWidget(
          onBuild: (context) {
            testContext = context;
          },
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

  group('getLocalizedErrorMessage', () {
    testWidgets(
      'location_services_disabled when error contains "Location services are disabled"',
      (tester) async {
        await pumpApp(tester);

        final result = getLocalizedErrorMessage(
          testContext,
          'Location services are disabled',
        );

        expect(
          result,
          AppLocalizations.of(testContext)!.location_services_disabled,
        );
      },
    );

    testWidgets(
      'location_permissions_denied when error contains "Location permissions are denied"',
      (tester) async {
        await pumpApp(tester);

        final result = getLocalizedErrorMessage(
          testContext,
          'Location permissions are denied',
        );

        expect(
          result,
          AppLocalizations.of(testContext)!.location_permissions_denied,
        );
      },
    );

    testWidgets(
      'location_permissions_permanently_denied when error contains "permanently denied"',
      (tester) async {
        await pumpApp(tester);

        final result = getLocalizedErrorMessage(
          testContext,
          'Permissions are permanently denied',
        );

        expect(
          result,
          AppLocalizations.of(
            testContext,
          )!.location_permissions_permanently_denied,
        );
      },
    );

    testWidgets('returns default location_error for unknown error', (
      tester,
    ) async {
      await pumpApp(tester);

      final result = getLocalizedErrorMessage(
        testContext,
        'Some unknown error happened',
      );

      expect(result, AppLocalizations.of(testContext)!.location_error);
    });
  });
}
