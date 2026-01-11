import 'package:amazing_icons/outlined.dart' show AmazingIconOutlined;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/data/networking/states/address_load_state.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/address_provider.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/features/upload_story/presentation/providers/upload_location_loading_provider.dart';
import 'package:storyzz/features/upload_story/presentation/providers/upload_map_controller_provider.dart';
import 'package:storyzz/features/upload_story/presentation/providers/upload_story_provider.dart';
import 'package:storyzz/features/upload_story/presentation/widgets/build_google_map.dart';
import 'package:storyzz/features/upload_story/presentation/widgets/location_error_display.dart';
import 'package:storyzz/features/upload_story/presentation/widgets/location_map_controls.dart';
import 'package:storyzz/features/upload_story/presentation/widgets/location_map_placeholder.dart';
import 'package:storyzz/features/upload_story/presentation/widgets/location_map_selector.dart';

import '../../../../tetsutils/mock.dart';

void main() {
  late MockUploadStoryProvider mockUploadProvider;
  late MockUploadLocationLoadingProvider mockLocationLoadingProvider;
  late MockUploadMapControllerProvider mockMapControllerProvider;
  late MockAddressProvider mockAddressProvider;
  late MockAppProvider mockAppProvider;
  late MockOnLocationEnabled mockOnLocationEnabled;

  setUpAll(() {
    registerFallbackValue(const LatLng(0, 0));
    registerFallbackValue(const CameraPosition(target: LatLng(0, 0)));
  });

  setUp(() {
    mockUploadProvider = MockUploadStoryProvider();
    mockLocationLoadingProvider = MockUploadLocationLoadingProvider();
    mockMapControllerProvider = MockUploadMapControllerProvider();
    mockAddressProvider = MockAddressProvider();
    mockAppProvider = MockAppProvider();
    mockOnLocationEnabled = MockOnLocationEnabled();

    when(() => mockUploadProvider.includeLocation).thenReturn(false);
    when(() => mockUploadProvider.selectedLocation).thenReturn(null);
    when(() => mockLocationLoadingProvider.isLoading).thenReturn(false);
    when(() => mockLocationLoadingProvider.errorMessage).thenReturn(null);
    when(
      () => mockUploadProvider.toggleLocationIncluded(any()),
    ).thenReturn(null);
    when(() => mockUploadProvider.setSelectedLocation(any())).thenReturn(null);
    when(
      () => mockLocationLoadingProvider.setIsLoading(any()),
    ).thenReturn(null);
    when(
      () => mockLocationLoadingProvider.setErrorMessage(any()),
    ).thenReturn(null);
    when(
      () => mockMapControllerProvider.animateCamera(any()),
    ).thenAnswer((_) async => {});
    when(
      () => mockAddressProvider.getAddressFromCoordinates(any(), any()),
    ).thenAnswer((_) async => {});
    when(
      () => mockAddressProvider.state,
    ).thenReturn(const AddressLoadState.initial());
    when(() => mockAppProvider.openUploadMapFullScreen()).thenReturn(null);
  });

  Widget createTestWidget() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UploadStoryProvider>.value(
          value: mockUploadProvider,
        ),
        ChangeNotifierProvider<UploadLocationLoadingProvider>.value(
          value: mockLocationLoadingProvider,
        ),
        ChangeNotifierProvider<UploadMapControllerProvider>.value(
          value: mockMapControllerProvider,
        ),
        ChangeNotifierProvider<AddressProvider>.value(
          value: mockAddressProvider,
        ),
        ChangeNotifierProvider<AppProvider>.value(value: mockAppProvider),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: Scaffold(
          body: LocationMapSelector(
            onLocationEnabled: mockOnLocationEnabled.call,
          ),
        ),
      ),
    );
  }

  testWidgets('renders location header with switch', (tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.byType(Switch), findsOneWidget);
    expect(find.byType(Row), findsWidgets);
  });

  testWidgets('shows map when includeLocation is true', (tester) async {
    when(() => mockUploadProvider.includeLocation).thenReturn(true);

    await tester.pumpWidget(createTestWidget());
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.byType(AnimatedOpacity), findsOneWidget);
  });

  testWidgets('toggles location inclusion when switch is changed', (
    tester,
  ) async {
    await tester.pumpWidget(createTestWidget());

    await tester.tap(find.byType(Switch));

    verify(() => mockOnLocationEnabled(true)).called(1);
    verify(() => mockUploadProvider.toggleLocationIncluded(true)).called(1);
  });

  testWidgets('shows loading indicator when loading and no location', (
    tester,
  ) async {
    when(() => mockUploadProvider.includeLocation).thenReturn(true);
    when(() => mockLocationLoadingProvider.isLoading).thenReturn(true);

    await tester.pumpWidget(createTestWidget());

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('shows BuildGoogleMap when not loading and has location', (
    tester,
  ) async {
    when(() => mockUploadProvider.includeLocation).thenReturn(true);
    when(
      () => mockUploadProvider.selectedLocation,
    ).thenReturn(const LatLng(1.0, 1.0));
    when(() => mockLocationLoadingProvider.isLoading).thenReturn(false);

    await tester.pumpWidget(createTestWidget());

    expect(find.byType(BuildGoogleMap), findsOneWidget);
  });

  testWidgets('shows fullscreen button and opens fullscreen map', (
    tester,
  ) async {
    when(() => mockUploadProvider.includeLocation).thenReturn(true);
    when(
      () => mockUploadProvider.selectedLocation,
    ).thenReturn(const LatLng(1.0, 1.0));

    await tester.pumpWidget(createTestWidget());
    await tester.tap(find.byIcon(AmazingIconOutlined.maximize4));

    verify(() => mockAppProvider.openUploadMapFullScreen()).called(1);
  });

  testWidgets('shows error message when error occurs', (tester) async {
    when(() => mockUploadProvider.includeLocation).thenReturn(true);
    when(
      () => mockLocationLoadingProvider.errorMessage,
    ).thenReturn('Error occurred');

    await tester.pumpWidget(createTestWidget());

    expect(find.byType(LocationErrorDisplay), findsOneWidget);
  });

  testWidgets('shows placeholder when no location selected', (tester) async {
    when(() => mockUploadProvider.includeLocation).thenReturn(true);
    when(() => mockLocationLoadingProvider.isLoading).thenReturn(false);

    await tester.pumpWidget(createTestWidget());

    expect(find.byType(LocationMapPlaceholder), findsOneWidget);
  });

  testWidgets('shows LocationMapControls when location is selected', (
    tester,
  ) async {
    when(() => mockUploadProvider.includeLocation).thenReturn(true);
    when(
      () => mockUploadProvider.selectedLocation,
    ).thenReturn(const LatLng(1.0, 1.0));

    await tester.pumpWidget(createTestWidget());

    expect(find.byType(LocationMapControls), findsOneWidget);
  });

  testWidgets(
    'shows loading indicator at bottom when loading with existing location',
    (tester) async {
      when(() => mockUploadProvider.includeLocation).thenReturn(true);
      when(
        () => mockUploadProvider.selectedLocation,
      ).thenReturn(const LatLng(1.0, 1.0));
      when(() => mockLocationLoadingProvider.isLoading).thenReturn(true);

      await tester.pumpWidget(createTestWidget());

      expect(find.byType(CircularProgressIndicator), findsWidgets);
      expect(find.byType(Container), findsWidgets);
    },
  );

  testWidgets('animates camera when onMove is called', (tester) async {
    when(() => mockUploadProvider.includeLocation).thenReturn(true);
    when(
      () => mockUploadProvider.selectedLocation,
    ).thenReturn(const LatLng(1.0, 1.0));

    await tester.pumpWidget(createTestWidget());

    // find LocationMapControls and trigger onMove
    final controls = tester.widget<LocationMapControls>(
      find.byType(LocationMapControls),
    );
    controls.onMove();

    verify(() => mockMapControllerProvider.animateCamera(any())).called(1);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('flutter.baseflow.com/geolocator'),
          null,
        );
  });
}
