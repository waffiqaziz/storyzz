import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/utils/helper.dart';

void main() {
  final now = DateTime.now();
  final dateFormat = DateFormat('MMMM d, yyyy · HH:mm');

  Widget createTestApp(Widget child) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: child,
    );
  }

  // Helper function to get a BuildContext with localizations
  Future<BuildContext> getLocalizationContext(WidgetTester tester) async {
    late BuildContext capturedContext;

    await tester.pumpWidget(
      createTestApp(
        Builder(
          builder: (BuildContext context) {
            capturedContext = context;
            return const Scaffold(body: SizedBox());
          },
        ),
      ),
    );

    // Make sure localizations are loaded
    await tester.pumpAndSettle();

    return capturedContext;
  }

  group('getTimeDifference', () {
    testWidgets('formats a date more than 7 days ago', (
      WidgetTester tester,
    ) async {
      final context = await getLocalizationContext(tester);

      final eightDaysAgo = now.subtract(const Duration(days: 8));
      final expected = dateFormat.format(eightDaysAgo);

      final result = getTimeDifference(context, eightDaysAgo);
      expect(result, expected);
    });

    testWidgets('formats yesterday with time only', (
      WidgetTester tester,
    ) async {
      final context = await getLocalizationContext(tester);
      final localizations = AppLocalizations.of(context)!;

      final yesterday = now.subtract(const Duration(days: 1));

      final result = getTimeDifference(context, yesterday);
      expect(result, startsWith(localizations.yesterday));
      expect(result, contains('·'));
      // Should contain time in HH:mm format
      expect(result, matches(RegExp(r'\d{2}:\d{2}')));
    });

    testWidgets('formats 2-7 days ago (plural)', (WidgetTester tester) async {
      final context = await getLocalizationContext(tester);

      final threeDaysAgo = now.subtract(const Duration(days: 3));

      final result = getTimeDifference(context, threeDaysAgo);
      expect(result, contains('3'));
      expect(result, contains(AppLocalizations.of(context)!.d_ago_plural));
    });

    testWidgets('formats a date within hours (plural)', (
      WidgetTester tester,
    ) async {
      final context = await getLocalizationContext(tester);

      final threeHoursAgo = now.subtract(const Duration(hours: 3));

      final result = getTimeDifference(context, threeHoursAgo);
      expect(result, contains('3'));
      expect(result, contains(AppLocalizations.of(context)!.h_ago_plural));
    });

    testWidgets('formats a date within hours (singular)', (
      WidgetTester tester,
    ) async {
      final context = await getLocalizationContext(tester);

      final oneHourAgo = now.subtract(const Duration(hours: 1));

      final result = getTimeDifference(context, oneHourAgo);
      expect(result, contains('1'));
      expect(result, contains(AppLocalizations.of(context)!.h_ago_singular));
    });

    testWidgets('formats a date within minutes (plural)', (
      WidgetTester tester,
    ) async {
      final context = await getLocalizationContext(tester);

      final tenMinutesAgo = now.subtract(const Duration(minutes: 10));

      final result = getTimeDifference(context, tenMinutesAgo);
      expect(result, contains('10'));
      expect(result, contains(AppLocalizations.of(context)!.m_ago_plural));
    });

    testWidgets('formats a date within minutes (singular)', (
      WidgetTester tester,
    ) async {
      final context = await getLocalizationContext(tester);

      final oneMinuteAgo = now.subtract(const Duration(minutes: 1));

      final result = getTimeDifference(context, oneMinuteAgo);
      expect(result, contains('1'));
      expect(result, contains(AppLocalizations.of(context)!.m_ago_singular));
    });

    testWidgets('formats a date within seconds as "just now"', (
      WidgetTester tester,
    ) async {
      final context = await getLocalizationContext(tester);

      final fewSecondsAgo = now.subtract(const Duration(seconds: 30));

      final result = getTimeDifference(context, fewSecondsAgo);
      expect(result, AppLocalizations.of(context)!.just_now);
    });
  });
}
