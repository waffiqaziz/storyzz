import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/data/model/user.dart';
import 'package:storyzz/core/data/networking/responses/list_story.dart';
import 'package:storyzz/core/data/networking/states/story_load_state.dart';
import 'package:storyzz/core/design/widgets/language_dialog_screen.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/navigation/app_router.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/core/providers/auth_provider.dart';
import 'package:storyzz/core/providers/settings_provider.dart';
import 'package:storyzz/core/providers/story_provider.dart';
import 'package:storyzz/features/auth/presentation/screen/login_screen.dart';
import 'package:storyzz/features/auth/presentation/screen/register_screen.dart';
import 'package:storyzz/features/detail/presentation/screen/detail_dialog.dart';
import 'package:storyzz/features/detail/presentation/screen/detail_screen.dart';
import 'package:storyzz/features/home/presentation/screen/home_screen.dart';
import 'package:storyzz/features/map/presentation/screen/map_screen.dart';
import 'package:storyzz/features/map/provider/map_provider.dart';
import 'package:storyzz/features/notfound/presentation/screen/not_found_screen.dart';
import 'package:storyzz/features/settings/presentation/screen/settings_screen.dart';
import 'package:storyzz/features/upload_story/presentation/providers/upload_story_provider.dart';
import 'package:storyzz/features/upload_story/presentation/screen/upload_story_screen.dart';
import 'package:storyzz/features/upload_story/presentation/widgets/location_map_fullscreen.dart';
import 'package:storyzz/features/upload_story/presentation/widgets/upgrade_dialog.dart';

import '../../tetsutils/mock.dart';

void main() {
  late MockAuthProvider mockAuthProvider;
  late MockAppProvider mockAppProvider;
  late MockSettingsProvider mockSettingsProvider;
  late MockStoryProvider mockStoryProvider;
  late MockMapProvider mockMapProvider;
  late MockUploadStoryProvider mockUploadStoryProvider;
  late AppRouter appRouter;

  Widget createWidgetUnderTest({String? initialLocation, double width = 1200}) {
    appRouter = AppRouter(
      authProvider: mockAuthProvider,
      appProvider: mockAppProvider,
    );

    if (initialLocation != null) {
      appRouter.router.go(initialLocation);
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
        ChangeNotifierProvider<AppProvider>.value(value: mockAppProvider),
        ChangeNotifierProvider<SettingsProvider>.value(
          value: mockSettingsProvider,
        ),
        ChangeNotifierProvider<StoryProvider>.value(value: mockStoryProvider),
        ChangeNotifierProvider<MapProvider>.value(value: mockMapProvider),
        ChangeNotifierProvider<UploadStoryProvider>.value(
          value: mockUploadStoryProvider,
        ),
      ],
      child: MediaQuery(
        data: MediaQueryData(size: Size(width, 800.0), devicePixelRatio: 1.0),
        child: MaterialApp.router(
          routerConfig: appRouter.router,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('id')],
        ),
      ),
    );
  }

  tearDown(() {
    reset(mockAuthProvider);
    reset(mockAppProvider);
    reset(mockSettingsProvider);
    reset(mockStoryProvider);
    reset(mockUploadStoryProvider);
    reset(mockMapProvider);
  });

  setUpAll(() {
    registerFallbackValue(
      User(name: 'Test User', email: 'test@example.com', token: 'test-token'),
    );

    registerFallbackValue(
      ListStory(
        id: '1',
        name: 'Test Story',
        description: 'Test Description',
        photoUrl: 'https://example.com/photo.jpg',
        createdAt: DateTime.now(),
      ),
    );
  });

  setUp(() {
    mockAuthProvider = MockAuthProvider();
    mockAppProvider = MockAppProvider();
    mockSettingsProvider = MockSettingsProvider();
    mockStoryProvider = MockStoryProvider();
    mockMapProvider = MockMapProvider();
    mockUploadStoryProvider = MockUploadStoryProvider();

    when(() => mockAppProvider.isLanguageDialogOpen).thenReturn(false);
    when(() => mockAppProvider.isRegister).thenReturn(false);
    when(() => mockAppProvider.isLogin).thenReturn(false);
    when(() => mockAppProvider.isFromDetail).thenReturn(false);
    when(() => mockAppProvider.selectedStory).thenReturn(null);
    when(() => mockAppProvider.isDialogLogOutOpen).thenReturn(false);
    when(() => mockAppProvider.isUpDialogOpen).thenReturn(false);
    when(() => mockAppProvider.isUploadFullScreenMap).thenReturn(false);
    when(() => mockAppProvider.isDetailFullScreenMap).thenReturn(false);

    when(() => mockAuthProvider.isLogged()).thenAnswer((_) async => false);
    when(() => mockAuthProvider.getUser()).thenAnswer((_) async => false);
    when(() => mockAuthProvider.user).thenReturn(null);
    when(() => mockAuthProvider.isLoggedIn).thenReturn(false);
    when(() => mockAuthProvider.isLoadingLogin).thenReturn(false);
    when(() => mockAuthProvider.isLoadingRegister).thenReturn(false);
    when(() => mockAuthProvider.errorMessage).thenReturn('');

    when(() => mockSettingsProvider.locale).thenReturn(const Locale('en'));

    when(() => mockStoryProvider.state).thenReturn(
      StoryLoadState.loaded([
        ListStory(
          id: '1',
          name: 'Test Story',
          description: 'Test Description',
          photoUrl: 'https://example.com/photo.jpg',
          createdAt: DateTime.now(),
        ),
      ]),
    );
    when(() => mockStoryProvider.hasMoreStories).thenReturn(true);
    when(() => mockStoryProvider.stories).thenReturn([
      ListStory(
        id: '1',
        name: 'Test Story',
        description: 'Test Description',
        photoUrl: 'https://example.com/photo.jpg',
        createdAt: DateTime.now(),
      ),
    ]);

    when(() => mockMapProvider.isMapReady).thenReturn(false);

    when(() => mockUploadStoryProvider.isLoading).thenReturn(false);
    when(() => mockUploadStoryProvider.caption).thenReturn('');
    when(() => mockUploadStoryProvider.includeLocation).thenReturn(false);
    when(() => mockUploadStoryProvider.showCamera).thenReturn(false);
    when(() => mockUploadStoryProvider.imageFile).thenReturn(null);
    when(() => mockUploadStoryProvider.isSuccess).thenReturn(true);
    when(() => mockUploadStoryProvider.errorMessage).thenReturn("");
    when(() => mockUploadStoryProvider.isCameraInitialized).thenReturn(false);
    when(() => mockUploadStoryProvider.isRequestingPermission).thenReturn(true);

    when(() => mockMapProvider.initData()).thenAnswer((_) async => true);
    when(() => mockMapProvider.shouldShowLocationWarning).thenReturn(false);
  });

  group('Authentication Redirects', () {
    testWidgets('Should redirect to login when not logged in', (tester) async {
      when(() => mockAuthProvider.isLogged()).thenAnswer((_) async => false);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('Should go to home when logged in', (tester) async {
      when(() => mockAuthProvider.isLogged()).thenAnswer((_) async => true);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets(
      'Should stay on login page when trying to access protected route but not logged in',
      (tester) async {
        when(() => mockAuthProvider.isLogged()).thenAnswer((_) async => false);

        await tester.pumpWidget(
          createWidgetUnderTest(initialLocation: '/settings'),
        );
        await tester.pumpAndSettle();

        expect(find.byType(LoginScreen), findsOneWidget);
        expect(find.byType(SettingsScreen), findsNothing);
      },
    );
  });

  group('Navigation between auth screens', () {
    testWidgets(
      'Should navigate from login to register when appProvider.isRegister is true',
      (tester) async {
        when(() => mockAuthProvider.isLogged()).thenAnswer((_) async => false);
        when(() => mockAppProvider.isRegister).thenReturn(true);

        await tester.pumpWidget(
          createWidgetUnderTest(initialLocation: '/login'),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RegisterScreen), findsOneWidget);
      },
    );

    testWidgets(
      'Should navigate from register to login when appProvider.isLogin is true',
      (tester) async {
        when(() => mockAuthProvider.isLogged()).thenAnswer((_) async => false);
        when(() => mockAppProvider.isRegister).thenReturn(false);
        when(() => mockAppProvider.isLogin).thenReturn(true);

        await tester.pumpWidget(
          createWidgetUnderTest(initialLocation: '/register'),
        );
        await tester.pumpAndSettle();

        expect(find.byType(LoginScreen), findsOneWidget);
      },
    );

    testWidgets('Should open language dialog from login screen', (
      tester,
    ) async {
      when(() => mockAuthProvider.isLogged()).thenAnswer((_) async => false);
      when(() => mockAppProvider.isLanguageDialogOpen).thenReturn(true);

      await tester.pumpWidget(createWidgetUnderTest(initialLocation: '/login'));
      await tester.pumpAndSettle();

      expect(find.byType(LanguageDialogScreen), findsOneWidget);
    });
  });

  group('Bottom navigation routing', () {
    setUp(() {
      // Set up for authenticated user
      when(() => mockAuthProvider.isLogged()).thenAnswer((_) async => true);
    });

    testWidgets('Should show correct screen for home tab index', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest(initialLocation: '/'));
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('Should show correct screen for map tab index', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(initialLocation: '/map'));
      await tester.pumpAndSettle();

      expect(find.byType(MapStoryScreen), findsOneWidget);
    });

    testWidgets('Should show correct screen for upload tab index', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(initialLocation: '/upload'),
      );
      await tester.pumpAndSettle();

      expect(find.byType(UploadStoryScreen), findsOneWidget);
    });

    testWidgets('Should show correct screen for settings tab index', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(initialLocation: '/settings'),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SettingsScreen), findsOneWidget);
    });
  });

  group('Story detail navigation', () {
    final testStory = ListStory(
      id: '1',
      name: 'Test Story',
      description: 'Test Description',
      photoUrl: 'https://example.com/photo.jpg',
      createdAt: DateTime.now(),
    );

    setUp(() {
      when(() => mockAuthProvider.isLogged()).thenAnswer((_) async => true);
    });

    testWidgets('Should able to open and close story detail screen', (
      tester,
    ) async {
      when(() => mockAuthProvider.isLogged()).thenAnswer((_) async => true);
      when(() => mockAuthProvider.isLoggedIn).thenReturn(true);
      when(() => mockAppProvider.selectedStory).thenReturn(testStory);
      when(() => mockAppProvider.isFromDetail).thenReturn(false);
      when(() => mockAppProvider.isDialogLogOutOpen).thenReturn(false);

      await tester.pumpWidget(createWidgetUnderTest(width: 400));

      // wait for initial navigation
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(StoryDetailScreen), findsOneWidget);

      // wait for animations complete
      await tester.pump(const Duration(milliseconds: 1000));

      // Simulate close story detail
      when(() => mockAppProvider.closeDetail()).thenAnswer((_) {
        when(() => mockAppProvider.selectedStory).thenReturn(null);
        when(() => mockAppProvider.isFromDetail).thenReturn(true);
        mockAppProvider.notifyListeners();
      });

      mockAppProvider.closeDetail();

      // manually trigger the router refresh
      // because using mocks and not real state management
      appRouter.router.refresh();

      // pump to trigger the router's redirect
      await tester.pump();

      // wait for all animations and async operations
      await tester.pumpAndSettle();

      expect(find.byType(StoryDetailDialog), findsNothing);
      expect(find.byType(StoryDetailScreen), findsNothing);
      expect(find.byType(HomeScreen), findsOneWidget);
    });
    
    testWidgets('Should able to open and close story detail dialoh', (
      tester,
    ) async {
      when(() => mockAuthProvider.isLogged()).thenAnswer((_) async => true);
      when(() => mockAuthProvider.isLoggedIn).thenReturn(true);
      when(() => mockAppProvider.selectedStory).thenReturn(testStory);
      when(() => mockAppProvider.isFromDetail).thenReturn(false);
      when(() => mockAppProvider.isDialogLogOutOpen).thenReturn(false);

      await tester.pumpWidget(createWidgetUnderTest(width: 1200));

      // wait for initial navigation
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(StoryDetailDialog), findsOneWidget);

      // wait for animations complete
      await tester.pump(const Duration(milliseconds: 1000));

      // Simulate close story detail
      when(() => mockAppProvider.closeDetail()).thenAnswer((_) {
        when(() => mockAppProvider.selectedStory).thenReturn(null);
        when(() => mockAppProvider.isFromDetail).thenReturn(true);
        mockAppProvider.notifyListeners();
      });

      mockAppProvider.closeDetail();

      // manually trigger the router refresh
      // because using mocks and not real state management
      appRouter.router.refresh();

      // pump to trigger the router's redirect
      await tester.pump();

      // wait for all animations and async operations
      await tester.pumpAndSettle();

      expect(find.byType(StoryDetailDialog), findsNothing);
      expect(find.byType(StoryDetailScreen), findsNothing);
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });

  group('Upload screen states', () {
    setUp(() {
      when(() => mockAuthProvider.isLogged()).thenAnswer((_) async => true);
    });

    testWidgets('Should show upgrade dialog when isUpDialogOpen is true', (
      tester,
    ) async {
      when(() => mockAppProvider.isUpDialogOpen).thenReturn(true);

      await tester.pumpWidget(
        createWidgetUnderTest(initialLocation: '/upload'),
      );
      await tester.pumpAndSettle();

      expect(find.byType(UpgradeDialog), findsOneWidget);
    });

    testWidgets(
      'Should show full screen map when isUploadFullScreenMap is true',
      (tester) async {
        when(() => mockAppProvider.isUploadFullScreenMap).thenReturn(true);

        await tester.pumpWidget(
          createWidgetUnderTest(initialLocation: '/upload'),
        );
        await tester.pumpAndSettle();

        expect(find.byType(MapFullScreen), findsOneWidget);
      },
    );
  });

  group('Error handling', () {
    setUp(() {
      when(() => mockAuthProvider.isLogged()).thenAnswer((_) async => true);
    });

    testWidgets('Should show 404 screen for invalid routes', (tester) async {
      when(() => mockAuthProvider.isLogged()).thenAnswer((_) async => true);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // navigate to the invalid route
      appRouter.router.go('/invalid-route');

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // handle WidgetsBinding has a post-frame callback scheduled
      // hande WidgetsBinding.instance.addPostFrameCallback
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(
        find.byType(NotFoundScreen, skipOffstage: false),
        findsOneWidget,
        reason: "The NotFoundScreen should be shown for invalid routes",
      );
    });
  });
}
