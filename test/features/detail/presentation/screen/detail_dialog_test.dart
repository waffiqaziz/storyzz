import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/data/networking/models/story/list_story.dart';
import 'package:storyzz/core/data/networking/states/address_load_state.dart';
import 'package:storyzz/core/data/networking/states/geocoding_state.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/address_provider.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/core/providers/settings_provider.dart';
import 'package:storyzz/features/detail/presentation/providers/geocoding_provider.dart';
import 'package:storyzz/features/detail/presentation/screen/detail_dialog.dart';
import 'package:storyzz/features/detail/presentation/widgets/location_section.dart';

import '../../../../tetsutils/mock.dart';

void main() {
  late MockAddressProvider mockAddressProvider;
  late MockAppProvider mockAppProvider;
  late MockSettingsProvider mockSettingsProvider;
  late MockGeocodingProvider mockGeocodingProvider;

  List<String> launchedUrls = [];

  final listStory = ListStory(
    description: "Test Description",
    id: 'test-story-id',
    name: 'Test Story',
    lat: 37.7749,
    lon: -122.4194,
    photoUrl: 'https://example.com/image.jpg',
    createdAt: DateTime.now(),
  );

  setUp(() {
    mockAddressProvider = MockAddressProvider();
    mockAppProvider = MockAppProvider();
    mockSettingsProvider = MockSettingsProvider();
    mockGeocodingProvider = MockGeocodingProvider();

    launchedUrls = [];

    when(() => mockAppProvider.selectedStory).thenReturn(listStory);
    when(
      () => mockAddressProvider.state,
    ).thenReturn(AddressLoadStateLoaded('123 Test Street, City, Country'));
    when(
      () => mockAddressProvider.getAddressFromCoordinates(any(), any()),
    ).thenAnswer((_) async {});
    when(
      () => mockGeocodingProvider.fetchAddress(any(), any()),
    ).thenAnswer((_) async {});
    when(() => mockGeocodingProvider.state).thenReturn(
      GeocodingState.loaded(
        formattedAddress: "Address",
        placemark: Placemark(),
      ),
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/url_launcher'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'launch') {
              final String url = methodCall.arguments['url'] as String;
              launchedUrls.add(url);
              return true;
            } else if (methodCall.method == 'canLaunch') {
              return true;
            }
            return null;
          },
        );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/url_launcher'),
          null,
        );
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
          ChangeNotifierProvider<GeocodingProvider>.value(
            value: mockGeocodingProvider,
          ),
        ],
        child: Scaffold(body: StoryDetailDialog()),
      ),
    );
  }

  group('StoryDetailDialog', () {
    testWidgets(
      'should renders image, author info, description, and location map',
      (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        await tester.pumpAndSettle(const Duration(seconds: 1));

        expect(find.byType(Image), findsOneWidget);
        expect(find.text('Test Story'), findsOneWidget);
        expect(find.text('Test Description'), findsOneWidget);
        expect(find.byType(LocationSection), findsOneWidget);
      },
    );

    testWidgets('should calls closeDetail when close button is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final closeButton = find.byIcon(Icons.close_rounded);
      expect(closeButton, findsOneWidget);

      await tester.tap(closeButton);
      await tester.pumpAndSettle();

      verify(() => mockAppProvider.closeDetailScreen()).called(1);
    });

    testWidgets('should opens URL when image is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final gestureDetector = find.byType(GestureDetector).first;
      expect(gestureDetector, findsOneWidget);

      await tester.tap(gestureDetector);
      await tester.pumpAndSettle();

      expect(launchedUrls.length, 1);
      expect(launchedUrls.first, 'https://example.com/image.jpg');
    });

    testWidgets('shows loading indicator then loaded image', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byType(CircularProgressIndicator), findsNWidgets(1));

        await tester.pumpAndSettle();

        expect(find.byType(Image), findsOneWidget);
      });
    });
  });
}
