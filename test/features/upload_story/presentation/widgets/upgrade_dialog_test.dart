import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/features/upload_story/presentation/widgets/upgrade_dialog.dart';

import '../../../../tetsutils/mock.dart';

void main() {
  late MockAppProvider mockAppProvider;

  setUp(() {
    mockAppProvider = MockAppProvider();
    when(() => mockAppProvider.closeDialogLogOut()).thenReturn(null);
  });

  Widget createTestWidget() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppProvider>.value(value: mockAppProvider),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [Locale('en')],
        home: Scaffold(body: UpgradeDialog()),
      ),
    );
  }

  testWidgets('renders dialog with title and content', (tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Get Premium'), findsOneWidget);
    expect(
      find.text(
        'Upgrade to Storyzz Premium to enjoy additional features  adding location to your stories!',
      ),
      findsOneWidget,
    );
  });

  testWidgets('close button calls closeUpgradeDialog', (tester) async {
    await tester.pumpWidget(createTestWidget());

    final closeButton = find.text('Close');
    expect(closeButton, findsOneWidget);

    await tester.tap(closeButton);
    await tester.pump();

    verify(() => mockAppProvider.closeUpgradeDialog()).called(1);
  });

  testWidgets(
    'upgrade button calls closeUpgradeDialog and shows cooming soon',
    (tester) async {
      await tester.pumpWidget(createTestWidget());

      final upgradeButton = find.text('Upgrade');
      expect(upgradeButton, findsOneWidget);

      await tester.tap(upgradeButton);
      await tester.pump();

      verify(() => mockAppProvider.closeUpgradeDialog()).called(1);

      await tester.pump();
      expect(find.text('Upgrade feature coming soon!'), findsOneWidget);
    },
  );
}
