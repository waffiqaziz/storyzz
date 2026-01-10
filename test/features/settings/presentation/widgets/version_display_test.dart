import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/features/settings/presentation/widgets/version_display.dart';

import '../../../../tetsutils/mock.dart';

void main() {
  late MockAppService mockAppService;

  setUp(() {
    mockAppService = MockAppService();

    PackageInfo.setMockInitialValues(
      appName: 'Test App',
      packageName: 'com.test.app',
      version: '1.2.3',
      buildNumber: '42',
      buildSignature: '',
    );
  });

  Widget createWidgetUnderTest({required bool isWeb}) {
    when(() => mockAppService.getKIsWeb()).thenReturn(isWeb);

    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: Scaffold(body: VersionDisplay(appService: mockAppService)),
    );
  }

  group('VersionDisplay', () {
    testWidgets('should show nothing while loading package info', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest(isWeb: false));

      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(Text), findsNothing);
    });

    testWidgets(
      'should display version and build number for non-web platform',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(isWeb: false));
        await tester.pumpAndSettle();

        expect(find.byType(Text), findsOneWidget);
        expect(find.textContaining('1.2.3'), findsOneWidget);
        expect(find.textContaining('42'), findsOneWidget);
        expect(find.byType(Tooltip), findsNothing);

        verify(
          () => mockAppService.getKIsWeb(),
        ).called(greaterThanOrEqualTo(1));
      },
    );

    testWidgets(
      'should display last update date with tooltip for web platform',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(isWeb: true));
        await tester.pumpAndSettle();

        expect(find.byType(Tooltip), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);

        final now = DateTime.now();
        final expectedDate = DateFormat('MMM dd, yyyy', 'en').format(now);
        expect(find.textContaining(expectedDate), findsOneWidget);

        await tester.longPress(find.byType(Tooltip));
        await tester.pumpAndSettle();

        expect(find.textContaining('1.2.3'), findsOneWidget);

        verify(
          () => mockAppService.getKIsWeb(),
        ).called(greaterThanOrEqualTo(1));
      },
    );

    testWidgets('should use correct text style', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(isWeb: false));
      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.color, isNotNull);
      expect(find.byType(Center), findsOneWidget);
    });

    testWidgets('should format date according to locale for web', (
      tester,
    ) async {
      PackageInfo.setMockInitialValues(
        appName: 'Test App',
        packageName: 'com.test.app',
        version: '1.0.0',
        buildNumber: '1',
        buildSignature: '',
      );

      when(() => mockAppService.getKIsWeb()).thenReturn(true);

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en', ''), Locale('id', '')],
          locale: const Locale('id', ''),
          home: Scaffold(body: VersionDisplay(appService: mockAppService)),
        ),
      );
      await tester.pumpAndSettle();

      final now = DateTime.now();
      final expectedDate = DateFormat('MMM dd, yyyy', 'id').format(now);
      expect(find.textContaining(expectedDate), findsOneWidget);
    });
  });
}
