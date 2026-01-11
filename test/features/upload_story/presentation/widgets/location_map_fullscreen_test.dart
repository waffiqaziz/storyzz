import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/data/networking/states/address_load_state.dart';
import 'package:storyzz/core/design/widgets/square_icon_button.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/address_provider.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/features/upload_story/presentation/providers/upload_story_provider.dart';
import 'package:storyzz/features/upload_story/presentation/widgets/build_google_map.dart';
import 'package:storyzz/features/upload_story/presentation/widgets/location_map_fullscreen.dart';

import '../../../../tetsutils/mock.dart';

void main() {
  late MockAddressProvider mockAddressProvider;
  late MockAppProvider mockAppProvider;
  late MockUploadStoryProvider mockUploadProvider;

  setUp(() {
    mockAppProvider = MockAppProvider();
    mockAddressProvider = MockAddressProvider();
    mockUploadProvider = MockUploadStoryProvider();

    when(() => mockAppProvider.closeUploadMapFullScreen()).thenReturn(null);
    when(
      () => mockUploadProvider.selectedLocation,
    ).thenReturn(LatLng(10, 10)); // set default not null
    when(
      () => mockAddressProvider.state,
    ).thenReturn(const AddressLoadState.initial());
  });

  Widget createTestWidget() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AddressProvider>.value(
          value: mockAddressProvider,
        ),
        ChangeNotifierProvider<AppProvider>.value(value: mockAppProvider),
        ChangeNotifierProvider<UploadStoryProvider>.value(
          value: mockUploadProvider,
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(body: MapFullScreen()),
      ),
    );
  }

  testWidgets('when no location renders nothing', (tester) async {
    when(() => mockUploadProvider.selectedLocation).thenReturn(null);
    await tester.pumpWidget(createTestWidget());

    expect(find.byType(SizedBox), findsOneWidget);
  });

  testWidgets('renders widget with all contents', (tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.byType(Stack), findsAtLeast(2));
    expect(find.byType(BuildGoogleMap), findsOneWidget);
    expect(find.byType(Positioned), findsOneWidget);
    expect(find.byType(PointerInterceptor), findsOneWidget);
    expect(find.byType(SquareIconAction), findsOneWidget);
  });

  testWidgets('close button open upgrade dialog', (tester) async {
    await tester.pumpWidget(createTestWidget());

    final closeButton = find.byType(SquareIconAction);
    expect(closeButton, findsOneWidget);

    await tester.tap(closeButton);
    await tester.pump();

    verify(() => mockAppProvider.closeUploadMapFullScreen()).called(1);
  });
}
