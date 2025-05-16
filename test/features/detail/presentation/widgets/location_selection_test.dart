import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/data/networking/responses/list_story.dart';
import 'package:storyzz/core/data/networking/states/address_load_state.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/address_provider.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/core/providers/settings_provider.dart';
import 'package:storyzz/features/detail/presentation/widgets/address_section.dart';
import 'package:storyzz/features/detail/presentation/widgets/location_section.dart';
import 'package:storyzz/features/detail/presentation/widgets/story_location_map.dart';

import '../../../../tetsutils/mock.dart';

void main() {
  late MockAddressProvider mockAddressProvider;
  late MockAppProvider mockAppProvider;
  late MockSettingsProvider mockSettingsProvider;
  final listStory = ListStory(
    description: "Test Description",
    id: 'test-story-id',
    name: 'Test Story',
    lat: 37.7749,
    lon: -122.4194,
    photoUrl: 'Test Url',
    createdAt: DateTime.now(),
  );

  setUp(() {
    mockAddressProvider = MockAddressProvider();
    mockAppProvider = MockAppProvider();
    mockSettingsProvider = MockSettingsProvider();

    when(() => mockAppProvider.selectedStory).thenReturn(listStory);
    when(
      () => mockAddressProvider.state,
    ).thenReturn(AddressLoadStateLoaded('123 Test Street, City, Country'));
    when(
      () => mockAddressProvider.getAddressFromCoordinates(any(), any()),
    ).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest({
    bool mapControlsEnabled = true,
    String mapKeyPrefix = 'test',
  }) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<AddressProvider>.value(
            value: mockAddressProvider,
          ),
          ChangeNotifierProvider<AppProvider>.value(value: mockAppProvider),
          ChangeNotifierProvider<SettingsProvider>.value(
            value: mockSettingsProvider,
          ),
        ],
        child: Scaffold(
          body: LocationSection(
            mapControlsEnabled: mapControlsEnabled,
            mapKeyPrefix: mapKeyPrefix,
          ),
        ),
      ),
    );
  }

  group('LocationSection', () {
    testWidgets('should requests address on first build and only once', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      verify(
        () => mockAddressProvider.getAddressFromCoordinates(37.7749, -122.4194),
      ).called(1);
    });

    testWidgets('should renders AddressSection with correct value', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final addressSectionFinder = find.byType(AddressSection);
      expect(addressSectionFinder, findsOneWidget);

      final AddressSection addressSection = tester.widget(addressSectionFinder);
      expect(addressSection.latitude, 37.7749);
      expect(addressSection.longitude, -122.4194);
      expect(addressSection.storyId, 'test-story-id');
    });

    testWidgets(
      'should renders StoryLocationMap with correct props and key',
      (WidgetTester tester) async {
        const testKeyPrefix = 'custom';
        await tester.pumpWidget(
          createWidgetUnderTest(mapKeyPrefix: testKeyPrefix),
        );
        await tester.pumpAndSettle();

        final mapFinder = find.byType(StoryLocationMap);
        expect(mapFinder, findsOneWidget);

        final StoryLocationMap map = tester.widget(mapFinder);
        expect(map.latitude, 37.7749);
        expect(map.longitude, -122.4194);
        expect(map.height, 400.0);
        expect(map.controlsEnabled, true);
        expect(map.title, 'Test Story');
        expect(map.location, '123 Test Street, City, Country');

        expect(
          (map.key as ValueKey).value,
          equals('$testKeyPrefix-location-map-test-story-id'),
        );
      },
    );

    testWidgets(
      'should passes mapControlsEnabled to StoryLocationMap',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createWidgetUnderTest(mapControlsEnabled: false),
        );
        await tester.pumpAndSettle();

        final mapFinder = find.byType(StoryLocationMap);
        expect(mapFinder, findsOneWidget);

        final StoryLocationMap map = tester.widget(mapFinder);
        expect(map.controlsEnabled, false);
      },
    );

    testWidgets('should renders divider and spacing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(Divider), findsOneWidget);
      expect(find.byType(SizedBox), findsAtLeastNWidgets(2));
    });
  });
}
