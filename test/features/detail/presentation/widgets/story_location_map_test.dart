import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/data/model/setting.dart';
import 'package:storyzz/core/data/networking/states/address_load_state.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/address_provider.dart';
import 'package:storyzz/core/providers/settings_provider.dart';
import 'package:storyzz/features/detail/presentation/widgets/story_location_map.dart';

import '../../../../tetsutils/mock.dart';

void main() {
  const testLatitude = 1.0;
  const testLongitude = 1.0;
  late MockAddressProvider mockAddressProvider;
  late MockSettingsProvider mockSettingsProvider;

  Widget createTestApp() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<AddressProvider>.value(
            value: mockAddressProvider,
          ),
          ChangeNotifierProvider<SettingsProvider>.value(
            value: mockSettingsProvider,
          ),
        ],
        child: Scaffold(
          body: StoryLocationMap(
            latitude: testLatitude,
            longitude: testLongitude,
            title: "Test Title",
            location: "Test Location",
          ),
        ),
      ),
    );
  }

  setUpAll(() {
    registerFallbackValue(AddressLoadStateInitial());
    registerFallbackValue(AddressLoadStateLoading());
  });

  setUp(() {
    mockSettingsProvider = MockSettingsProvider();
    mockAddressProvider = MockAddressProvider();
    when(
      () => mockSettingsProvider.setting,
    ).thenReturn(Setting(isDark: false, locale: "en"));
  });

  group('StoryLocationMap', () {
    testWidgets('should renders GoogleMap widget', (WidgetTester tester) async {
      when(
        () => mockAddressProvider.state,
      ).thenReturn(AddressLoadStateInitial());

      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      await tester.pump(const Duration(milliseconds: 600));
      expect(find.byType(GoogleMap), findsOneWidget);
    });

    testWidgets('should unfocus is called on pointer down', (
      WidgetTester tester,
    ) async {
      when(
        () => mockAddressProvider.state,
      ).thenReturn(AddressLoadStateInitial());

      final focusNode = FocusNode();
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<AddressProvider>.value(
                value: mockAddressProvider,
              ),
              ChangeNotifierProvider<SettingsProvider>.value(
                value: mockSettingsProvider,
              ),
            ],
            child: Scaffold(
              body: Column(
                children: [
                  TextField(focusNode: focusNode, autofocus: true),
                  StoryLocationMap(
                    key: const Key('map'), // optional
                    latitude: 1.0,
                    longitude: 1.0,
                    title: 'Test Title',
                    location: 'Test Location',
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 600));

      expect(focusNode.hasFocus, true);

      await tester.tap(find.byKey(const Key('map_listener')));
      await tester.pumpAndSettle();
      await tester.pump();

      expect(focusNode.hasFocus, false);
    });
  });
}
