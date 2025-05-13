import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/design/widgets/language_dialog_screen.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/core/providers/settings_provider.dart';

import '../../../tetsutils/mock.dart';

void main() {
  late MockAppProvider mockAppProvider;
  late MockSettingsProvider mockSettingsProvider;

  setUp(() {
    mockAppProvider = MockAppProvider();
    mockSettingsProvider = MockSettingsProvider();

    when(() => mockSettingsProvider.locale).thenReturn(const Locale('en'));
    when(() => mockSettingsProvider.setLocale(any())).thenAnswer((_) async {});
    when(() => mockAppProvider.closeLanguageDialog()).thenReturn(null);
  });

  Widget createWidget() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppProvider>.value(value: mockAppProvider),
        ChangeNotifierProvider<SettingsProvider>.value(
          value: mockSettingsProvider,
        ),
      ],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Navigator(
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (_) => const LanguageDialogScreen(),
            );
          },
        ),
      ),
    );
  }

  Widget createWidgetDialog({required Widget child}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppProvider>.value(value: mockAppProvider),
        ChangeNotifierProvider<SettingsProvider>.value(
          value: mockSettingsProvider,
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    );
  }

  group('LanguageDialogScreen', () {
    testWidgets('displays both language options and Cancel button', (
      tester,
    ) async {
      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      expect(find.text('English'), findsOneWidget);
      expect(find.text('Indonesian'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('tap language triggers setLocale and closes dialog', (
      tester,
    ) async {
      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Indonesian'));
      await tester.pumpAndSettle();

      verify(() => mockSettingsProvider.setLocale('id')).called(1);
      verify(() => mockAppProvider.closeLanguageDialog()).called(1);
    });

    testWidgets('tap cancel closes dialog', (tester) async {
      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      verify(() => mockAppProvider.closeLanguageDialog()).called(1);
    });

    testWidgets('onPopInvokedWithResult triggers closeLanguageDialog on back', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidgetDialog(
          child: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => const LanguageDialogScreen(),
                      );
                    },
                    child: const Text('Open Dialog'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      Navigator.of(tester.element(find.byType(AlertDialog))).pop();
      await tester.pumpAndSettle();

      verify(() => mockAppProvider.closeLanguageDialog()).called(1);
    });
  });
}
