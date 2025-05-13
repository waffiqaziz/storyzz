import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storyzz/core/design/widgets/auth_error_view.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';

void main() {
  Widget createTestApp(Widget child) {
    return MaterialApp(
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

  group('AuthErrorView', () {
    const testErrorMessage = 'Test error message';
    late bool logoutCalled;

    setUp(() {
      logoutCalled = false;
    });

    testWidgets('renders all components correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestApp(
          AuthErrorView(
            errorMessage: testErrorMessage,
            onLogout: () => logoutCalled = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Error: $testErrorMessage'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('displays correct error message', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          AuthErrorView(
            errorMessage: testErrorMessage,
            onLogout: () => logoutCalled = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final textWidget = tester.widget<Text>(
        find.text('Error: $testErrorMessage'),
      );
      expect(textWidget.style?.fontSize, 16);
      expect(textWidget.textAlign, TextAlign.center);
    });

    testWidgets('shows localized logout text', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          AuthErrorView(
            errorMessage: testErrorMessage,
            onLogout: () => logoutCalled = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(AuthErrorView));
      final localizedLogout = AppLocalizations.of(context)!.logout;
      expect(find.text(localizedLogout), findsOneWidget);
    });

    testWidgets('triggers logout callback when button pressed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestApp(
          AuthErrorView(
            errorMessage: testErrorMessage,
            onLogout: () => logoutCalled = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      expect(logoutCalled, isTrue);
    });
  });
}
