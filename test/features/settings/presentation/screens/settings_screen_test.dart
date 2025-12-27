import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/data/models/setting.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/core/providers/settings_provider.dart';
import 'package:storyzz/features/settings/presentation/screen/settings_screen.dart';

import '../../../../tetsutils/mock.dart';

void main() {
  late MockAppProvider mockAppProvider;
  late MockSettingsProvider mockSettingsProvider;

  final Uri uriRepository = Uri.parse('https://github.com/waffiqaziz/storyzz');
  final Uri uriFlutter = Uri.parse('https://flutter.dev');

  setUp(() {
    mockAppProvider = MockAppProvider();
    mockSettingsProvider = MockSettingsProvider();

    when(() => mockAppProvider.closeUploadFullScreenMap()).thenReturn(null);
    when(() => mockSettingsProvider.setLocale(any())).thenAnswer((_) async {});
    when(() => mockSettingsProvider.setTheme(any())).thenAnswer((_) async {});
    when(() => mockSettingsProvider.locale).thenReturn(const Locale('en'));
    when(() => mockSettingsProvider.setting).thenReturn(
      const Setting(isDark: false, locale: 'en'), // or whatever your model is
    );
  });

  setUpAll(() {
    registerFallbackValue(uriRepository);
    registerFallbackValue(uriFlutter);
  });

  Widget createTestWidget() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppProvider>.value(value: mockAppProvider),
        ChangeNotifierProvider<SettingsProvider>.value(
          value: mockSettingsProvider,
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: Scaffold(body: SettingsScreen()),
      ),
    );
  }

  testWidgets('tap switch theme called setTheme', (tester) async {
    await tester.pumpWidget(createTestWidget());

    final closeButton = find.byType(Switch).first;
    expect(closeButton, findsOneWidget);

    await tester.tap(closeButton);
    await tester.pump();

    verify(() => mockSettingsProvider.setTheme(any())).called(1);
  });

  testWidgets('tap logout tile calls openDialogLogOut', (tester) async {
    await tester.pumpWidget(createTestWidget());

    final tileFinder = find.text('Logout');
    expect(tileFinder, findsOneWidget);

    await tester.tap(tileFinder);
    await tester.pump();

    verify(() => mockAppProvider.openDialogLogOut()).called(1);
  });

  testWidgets('tap view source code opens github url', (tester) async {
    await tester.pumpWidget(createTestWidget());

    final tileFinder = find.text('Source Code');
    expect(tileFinder, findsOneWidget);

    await tester.tap(tileFinder);
    await tester.pump();
  });

  testWidgets('tap flutter button opens flutter website', (tester) async {
    await tester.pumpWidget(createTestWidget());

    final tileFinder = find.text('Built with Flutter');
    expect(tileFinder, findsOneWidget);

    await tester.tap(tileFinder);
    await tester.pump();
  });
}
