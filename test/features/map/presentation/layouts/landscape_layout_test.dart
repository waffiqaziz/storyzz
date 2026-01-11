import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/data/models/setting.dart';
import 'package:storyzz/core/data/networking/states/story_load_state.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/core/providers/auth_provider.dart';
import 'package:storyzz/core/providers/settings_provider.dart';
import 'package:storyzz/core/providers/story_provider.dart';
import 'package:storyzz/features/map/presentations/layouts/landscape_layout.dart';
import 'package:storyzz/features/map/presentations/providers/map_provider.dart';
import 'package:storyzz/features/map/presentations/widgets/map_story_list_view.dart';

import '../../../../tetsutils/data_dump.dart';
import '../../../../tetsutils/mock.dart';

void main() {
  late MockMapProvider mockMapProvider;
  late MockAuthProvider mockAuthProvider;
  late MockStoryProvider mockStoryProvider;
  late MockSettingsProvider mockSettingsProvider;
  late MockAppProvider mockAppProvider;

  setUp(() {
    mockAuthProvider = MockAuthProvider();
    mockMapProvider = MockMapProvider();
    mockStoryProvider = MockStoryProvider();
    mockSettingsProvider = MockSettingsProvider();
    mockAppProvider = MockAppProvider();

    when(() => mockAuthProvider.user).thenReturn(null);
    when(() => mockMapProvider.isMapReady).thenReturn(false);
    when(() => mockMapProvider.selectedMapType).thenReturn(MapType.normal);
    when(() => mockMapProvider.scrollController).thenReturn(ScrollController());
    when(
      () => mockMapProvider.markers,
    ).thenReturn({Marker(markerId: MarkerId('123'))});
    when(() => mockStoryProvider.isLoadingMore).thenReturn(false);
    when(() => mockSettingsProvider.locale).thenReturn(const Locale('en'));
    when(
      () => mockSettingsProvider.setting,
    ).thenReturn(Setting(isDark: true, locale: 'en'));
    when(() => mockStoryProvider.stories).thenReturn(dumpTestStoryList);
    when(
      () => mockStoryProvider.state,
    ).thenReturn(StoryLoadState.loaded(dumpTestStoryList));
  });

  group('LandscapeLayout', () {
    testWidgets('renders all widgets', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
            ChangeNotifierProvider<AppProvider>.value(value: mockAppProvider),
            ChangeNotifierProvider<SettingsProvider>.value(
              value: mockSettingsProvider,
            ),
            ChangeNotifierProvider<StoryProvider>.value(
              value: mockStoryProvider,
            ),
            ChangeNotifierProvider<MapProvider>.value(value: mockMapProvider),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en')],
            home: Scaffold(body: LandscapeLayout()),
          ),
        ),
      );

      expect(find.byType(MapStoryListView), findsOneWidget);
      expect(find.byType(GoogleMap), findsOneWidget);
    });
  });
}
