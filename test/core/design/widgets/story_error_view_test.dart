import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storyzz/core/design/widgets/story_error_view.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';

void main() {
  Widget createTestApp(Widget child) {
    return MaterialApp(
      locale: Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: Scaffold(body: child),
    );
  }

  group('StoryErrorView', () {
    const testErrorMessage = 'Test error message';
    late bool retryCalled;

    setUp(() {
      retryCalled = false;
    });

    testWidgets('renders all components correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestApp(
          StoryErrorView(
            errorMessage: testErrorMessage,
            onRetry: () => retryCalled = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final localizedError =
          AppLocalizations.of(
            tester.element(find.byType(StoryErrorView)),
          )!.error_loading_stories;
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
      expect(find.text('$localizedError $testErrorMessage'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('triggers logout callback when button pressed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestApp(
          StoryErrorView(
            errorMessage: testErrorMessage,
            onRetry: () => retryCalled = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      expect(retryCalled, true);
    });
  });
}
