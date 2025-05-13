import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/design/widgets/language_selector.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/app_provider.dart';

import '../../../tetsutils/mock.dart';

void main() {
  late MockAppProvider mockAppProvider;

  Widget wrapWithMaterialApp({
    required Widget child,
    required AppProvider provider,
  }) {
    return ChangeNotifierProvider<AppProvider>.value(
      value: provider,
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('id')],
        home: Scaffold(body: child),
      ),
    );
  }

  setUp(() {
    mockAppProvider = MockAppProvider();
  });

  group('LanguageSelector', () {
    testWidgets('compact version triggers openLanguageDialog on icon press', (
      tester,
    ) async {
      when(() => mockAppProvider.openLanguageDialog()).thenAnswer((_) {});

      await tester.pumpWidget(
        wrapWithMaterialApp(
          provider: mockAppProvider,
          child: LanguageSelector(
            currentLanguageCode: 'en',
            onChanged: (_) {},
            isCompact: true,
          ),
        ),
      );

      final iconButton = find.byIcon(Icons.language_rounded);
      expect(iconButton, findsOneWidget);

      await tester.tap(iconButton);
      verify(() => mockAppProvider.openLanguageDialog()).called(1);
    });

    testWidgets(
      'full version shows dropdown and triggers onChanged on selection',
      (tester) async {
        String? selectedLanguage;

        await tester.pumpWidget(
          wrapWithMaterialApp(
            provider: mockAppProvider,
            child: LanguageSelector(
              currentLanguageCode: 'en',
              onChanged: (lang) => selectedLanguage = lang,
              isCompact: false,
            ),
          ),
        );

        await tester.tap(find.byType(DropdownButton2<String>));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Indonesian').last); // Localized string
        await tester.pumpAndSettle();

        expect(selectedLanguage, 'id');
      },
    );
  });
}
