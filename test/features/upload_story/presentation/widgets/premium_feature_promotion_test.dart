import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/features/upload_story/presentation/widgets/premium_feature_promotion.dart';

import '../../../../tetsutils/mock.dart';

void main() {
  late MockAppProvider mockAppProvider;

  setUp(() {
    mockAppProvider = MockAppProvider();
    when(() => mockAppProvider.openUpgradeDialog()).thenReturn(null);
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
        home: Scaffold(body: PremiumFeaturePromotion()),
      ),
    );
  }

  testWidgets('renders widget with all contents', (tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.byType(Card), findsOneWidget);
    expect(find.text('Premium Feature'), findsOneWidget);
    expect(
      find.text('Upgrade to Premium to add location to your stories'),
      findsOneWidget,
    );
    expect(find.text('Upgrade Now'), findsOneWidget);
  });

  testWidgets('upgrade button open upgrade dialog', (tester) async {
    await tester.pumpWidget(createTestWidget());

    final upgradeButton = find.text('Upgrade Now');
    expect(upgradeButton, findsOneWidget);

    await tester.tap(upgradeButton);
    await tester.pump();

    verify(() => mockAppProvider.openUpgradeDialog()).called(1);
  });
}
