import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/data/networking/states/address_load_state.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/address_provider.dart';
import 'package:storyzz/features/detail/presentation/widgets/address_section_web.dart';

import '../../../../tetsutils/mock.dart';

void main() {
  const latText = 'Latitude: 1.000000';
  const lonText = 'Longitude: 1.000000';

  late MockAddressProvider mockAddressProvider;

  Widget createTestApp() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: ChangeNotifierProvider<AddressProvider>.value(
        value: mockAddressProvider,
        child: Scaffold(
          body: AddressSectionWeb(latText: latText, lonText: lonText),
        ),
      ),
    );
  }

  setUpAll(() {
    registerFallbackValue(AddressLoadStateInitial());
    registerFallbackValue(AddressLoadStateLoading());
  });

  setUp(() {
    mockAddressProvider = MockAddressProvider();
  });

  group('AddressSectionWeb', () {
    testWidgets('should renders initial state with latitude and longitude', (
      WidgetTester tester,
    ) async {
      when(
        () => mockAddressProvider.state,
      ).thenReturn(AddressLoadStateInitial());

      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      expect(
        find.text("Latitude: 1.000000, Longitude: 1.000000"),
        findsOneWidget,
      );
    });

    testWidgets('should renders loading state correctly', (
      WidgetTester tester,
    ) async {
      when(
        () => mockAddressProvider.state,
      ).thenReturn(AddressLoadStateLoading());

      await tester.pumpWidget(createTestApp());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading address...'), findsOneWidget);
    });

    testWidgets('should renders loaded state with formatted address', (
      WidgetTester tester,
    ) async {
      when(
        () => mockAddressProvider.state,
      ).thenReturn(AddressLoadStateLoaded('123 Test Street, City, Country'));

      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      expect(find.text('123 Test Street, City, Country'), findsOneWidget);
      expect(find.textContaining('Latitude'), findsOneWidget);
      expect(find.textContaining('Longitude'), findsOneWidget);
    });

    testWidgets('should renders error state correctly', (
      WidgetTester tester,
    ) async {
      when(
        () => mockAddressProvider.state,
      ).thenReturn(AddressLoadStateError("error"));

      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      expect(find.textContaining('Address not available'), findsOneWidget);
      expect(find.textContaining('Latitude'), findsOneWidget);
      expect(find.textContaining('Longitude'), findsOneWidget);
    });
  });
}
