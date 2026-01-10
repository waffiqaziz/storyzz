import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/data/models/user.dart';
import 'package:storyzz/core/data/networking/models/story/list_story.dart';
import 'package:storyzz/core/data/networking/states/story_load_state.dart';
import 'package:storyzz/core/design/widgets/empty_story.dart';
import 'package:storyzz/core/design/widgets/story_error_view.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/core/providers/auth_provider.dart';
import 'package:storyzz/core/providers/story_provider.dart';
import 'package:storyzz/features/home/presentation/widgets/home_story_card.dart';
import 'package:storyzz/features/home/presentation/widgets/home_story_list_view.dart';

import '../../../../tetsutils/data_dump.dart';
import '../../../../tetsutils/mock.dart';

void main() {
  group('HomeStoriesListView', () {
    late MockAuthProvider mockAuthProvider;
    late MockStoryProvider mockStoryProvider;
    late MockAppProvider mockAppProvider;
    late ScrollController scrollController;
    late MockAppService mockAppService;
    late User testUser;
    late List<ListStory> testStories;

    setUp(() {
      mockAuthProvider = MockAuthProvider();
      mockStoryProvider = MockStoryProvider();
      mockAppProvider = MockAppProvider();
      scrollController = ScrollController();
      mockAppService = MockAppService();

      testUser = dumpTestUser;

      testStories = dumpTestStoryList;

      // Default stubs
      when(() => mockAppService.getKIsWeb()).thenReturn(false);
      when(() => mockAuthProvider.user).thenReturn(testUser);
      when(
        () => mockStoryProvider.state,
      ).thenReturn(StoryLoadState.loaded(testStories));
      when(() => mockStoryProvider.stories).thenReturn(testStories);
      when(() => mockStoryProvider.hasMoreStories).thenReturn(true);
      when(() => mockStoryProvider.isLoadingMore).thenReturn(false);
      when(() => mockAppProvider.selectedStory).thenReturn(null);
      when(
        () => mockStoryProvider.getStories(
          user: any(named: 'user'),
          refresh: any(named: 'refresh'),
        ),
      ).thenAnswer((_) async => {});
      when(
        () => mockStoryProvider.refreshStories(user: any(named: 'user')),
      ).thenAnswer((_) async => {});
    });

    setUpAll(() {
      registerFallbackValue(dumpTestUser);
    });

    tearDown(() {
      scrollController.dispose();
    });

    Widget createTestWidget({double width = 1200}) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
          ChangeNotifierProvider<StoryProvider>.value(value: mockStoryProvider),
          ChangeNotifierProvider<AppProvider>.value(value: mockAppProvider),
        ],
        child: MediaQuery(
          data: MediaQueryData(size: Size(width, 800.0), devicePixelRatio: 1.0),
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en')],
            home: Scaffold(
              body: HomeStoriesListView(scrollController: scrollController),
            ),
          ),
        ),
      );
    }

    group('Initial Render Tests', () {
      testWidgets(
        'should render CustomScrollView with provided scrollController',
        (WidgetTester tester) async {
          await tester.pumpWidget(createTestWidget());
          await tester.pumpAndSettle();

          expect(find.byType(CustomScrollView), findsOneWidget);
          final customScrollView = tester.widget<CustomScrollView>(
            find.byType(CustomScrollView),
          );
          expect(customScrollView.controller, equals(scrollController));
        },
      );

      testWidgets('wide screen should not render SliverAppBar', (
        WidgetTester tester,
      ) async {
        when(() => mockAppService.getKIsWeb()).thenReturn(true);
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(SliverAppBar), findsNothing);
      });

      testWidgets('mobile should render SliverAppBar with correct title', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget(width: 500));
        await tester.pumpAndSettle();

        expect(find.byType(SliverAppBar), findsOneWidget);
        expect(find.text('Storyzz'), findsOneWidget);
      });

      testWidgets('should render RefreshIndicator', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(RefreshIndicator), findsOneWidget);
      });

      testWidgets('for mobile should show refresh button when no story is selected', (
        WidgetTester tester,
      ) async {
        when(() => mockAppProvider.selectedStory).thenReturn(null);

        await tester.pumpWidget(createTestWidget(width: 400));
        await tester.pumpAndSettle();
        await tester.pump();

        expect(find.byIcon(Icons.refresh), findsOneWidget);
      });

      testWidgets('should hide refresh button when story is selected', (
        WidgetTester tester,
      ) async {
        when(() => mockAppProvider.selectedStory).thenReturn(testStories[0]);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.refresh), findsNothing);
      });
    });

    group('State-based Rendering Tests', () {
      testWidgets('should show loading indicator when state is initial', (
        WidgetTester tester,
      ) async {
        when(
          () => mockStoryProvider.state,
        ).thenReturn(const StoryLoadState.initial());
        when(() => mockStoryProvider.stories).thenReturn([]);

        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets(
        'should show loading indicator when loading with empty stories',
        (WidgetTester tester) async {
          when(
            () => mockStoryProvider.state,
          ).thenReturn(const StoryLoadState.loading());
          when(() => mockStoryProvider.stories).thenReturn([]);

          await tester.pumpWidget(createTestWidget());
          await tester.pump();

          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        },
      );

      testWidgets('should show error view when state is error', (
        WidgetTester tester,
      ) async {
        const errorMessage = 'Failed to load stories';
        when(
          () => mockStoryProvider.state,
        ).thenReturn(const StoryLoadState.error(errorMessage));
        when(() => mockStoryProvider.stories).thenReturn([]);

        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        expect(find.byType(StoryErrorView), findsOneWidget);
        final context = tester.element(find.byType(StoryErrorView));
        final localizations = AppLocalizations.of(context)!;

        final expectedText =
            '${localizations.error_loading_stories} $errorMessage';

        expect(find.text(expectedText), findsOneWidget);
      });

      testWidgets('should show empty view when stories list is empty', (
        WidgetTester tester,
      ) async {
        when(
          () => mockStoryProvider.state,
        ).thenReturn(const StoryLoadState.loaded([]));
        when(() => mockStoryProvider.stories).thenReturn([]);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(EmptyStory), findsOneWidget);
      });

      testWidgets(
        'should render story list when state is loaded with stories',
        (WidgetTester tester) async {
          // set device resolution
          tester.view.physicalSize = const Size(1080, 2400);
          tester.view.devicePixelRatio = 1.0;

          await tester.pumpWidget(createTestWidget());
          await tester.pumpAndSettle();

          expect(find.byType(HomeStoryCard), findsNWidgets(2));
        },
      );

      testWidgets(
        'should show pagination loading indicator when isLoadingMore is true',
        (WidgetTester tester) async {
          when(() => mockStoryProvider.state.isLoaded).thenReturn(true);
          when(
            () => mockStoryProvider.state,
          ).thenReturn(StoryLoadState.loaded(testStories));
          when(() => mockStoryProvider.stories).thenReturn(testStories);
          when(() => mockStoryProvider.isLoadingMore).thenReturn(true);

          await tester.pumpWidget(createTestWidget());
          await tester.pump();

          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        },
      );
    });

    group('Story Card Rendering Tests', () {
      testWidgets('should render all story cards with correct data', (
        WidgetTester tester,
      ) async {
        // Set a larger screen size to ensure both cards are visible
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // Scroll down to ensure all items are built
        await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
        await tester.pump();

        expect(find.byType(HomeStoryCard), findsAtLeastNWidgets(2));

        // Check for text content
        expect(find.text(testStories[0].name), findsOneWidget);
        expect(find.text(testStories[1].name), findsOneWidget);

        // Reset view size
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });
      });

      testWidgets('should show location icon for story with coordinates', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.location_on), findsOneWidget);
      });

      testWidgets('should constrain story cards to max width of 475', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final constrainedBoxes = tester.widgetList<ConstrainedBox>(
          find.byType(ConstrainedBox),
        );

        bool hasMaxWidth475 = false;
        for (final box in constrainedBoxes) {
          if (box.constraints.maxWidth == 475) {
            hasMaxWidth475 = true;
            break;
          }
        }
        expect(hasMaxWidth475, isTrue);
      });
    });

    group('Scroll Listener Tests', () {
      testWidgets('should load more stories when scrolled near bottom', (
        WidgetTester tester,
      ) async {
        final manyStories = List.generate(
          5,
          (index) => ListStory(
            id: '$index',
            name: 'User $index',
            description: 'Story $index',
            photoUrl: 'https://example.com/photo$index.jpg',
            createdAt: DateTime.now(),
          ),
        );

        when(
          () => mockStoryProvider.state,
        ).thenReturn(StoryLoadState.loaded(manyStories));
        when(() => mockStoryProvider.stories).thenReturn(manyStories);
        when(() => mockStoryProvider.hasMoreStories).thenReturn(true);
        when(() => mockStoryProvider.isLoadingMore).thenReturn(false);
        when(() => mockAuthProvider.user).thenReturn(testUser);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        clearInteractions(mockStoryProvider);
        find.byType(Scrollable);
        await tester.drag(find.byType(Scrollable), const Offset(0, -1200));
        await tester.pump();
        await tester.drag(find.byType(Scrollable), const Offset(0, -1200));
        await tester.pump();

        // mush refresh the data
        verify(
          () => mockStoryProvider.getStories(user: testUser, refresh: false),
        ).called(greaterThanOrEqualTo(1));
      });

      testWidgets('should not load more when already loading', (
        WidgetTester tester,
      ) async {
        when(
          () => mockStoryProvider.state,
        ).thenReturn(const StoryLoadState.loading());
        when(() => mockStoryProvider.isLoadingMore).thenReturn(true);

        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        clearInteractions(mockStoryProvider);

        // simulate scroll
        await tester.drag(
          find.byType(CustomScrollView),
          const Offset(0, -1000),
        );
        await tester.pump();

        verifyNever(
          () => mockStoryProvider.getStories(
            user: any(named: 'user'),
            refresh: any(named: 'refresh'),
          ),
        );
      });

      testWidgets('should not load more when no more stories available', (
        WidgetTester tester,
      ) async {
        when(() => mockStoryProvider.hasMoreStories).thenReturn(false);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        clearInteractions(mockStoryProvider);

        // simulate scroll
        await tester.drag(
          find.byType(CustomScrollView),
          const Offset(0, -1000),
        );
        await tester.pumpAndSettle();

        verifyNever(
          () => mockStoryProvider.getStories(
            user: any(named: 'user'),
            refresh: any(named: 'refresh'),
          ),
        );
      });

      testWidgets('should not load more when user is null', (
        WidgetTester tester,
      ) async {
        when(() => mockAuthProvider.user).thenReturn(null);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        clearInteractions(mockStoryProvider);

        // simulate scroll
        await tester.drag(
          find.byType(CustomScrollView),
          const Offset(0, -1000),
        );
        await tester.pumpAndSettle();

        verifyNever(
          () => mockStoryProvider.getStories(
            user: any(named: 'user'),
            refresh: any(named: 'refresh'),
          ),
        );
      });
    });

    group('Pull to Refresh Tests', () {
      testWidgets('should refresh stories on pull down', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        clearInteractions(mockStoryProvider);

        // simulate pull to refresh
        await tester.drag(find.byType(RefreshIndicator), const Offset(0, 300));
        await tester.pumpAndSettle();

        verify(
          () => mockStoryProvider.refreshStories(user: testUser),
        ).called(1);
      });

      testWidgets('should not refresh when user is null', (
        WidgetTester tester,
      ) async {
        when(() => mockAuthProvider.user).thenReturn(null);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        clearInteractions(mockStoryProvider);

        // simulate pull to refresh
        await tester.drag(find.byType(RefreshIndicator), const Offset(0, 300));
        await tester.pumpAndSettle();

        verifyNever(
          () => mockStoryProvider.refreshStories(user: any(named: 'user')),
        );
      });
    });

    group('AppBar Action Tests', () {
      testWidgets('should refresh stories when refresh button is tapped', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        clearInteractions(mockStoryProvider);

        // tap refresh button
        await tester.tap(find.byIcon(Icons.refresh));
        await tester.pumpAndSettle();

        verify(
          () => mockStoryProvider.refreshStories(user: testUser),
        ).called(1);
      });
    });

    group('Error Retry Tests', () {
      testWidgets('should retry loading stories when retry button is tapped', (
        WidgetTester tester,
      ) async {
        const errorMessage = 'Network error';
        when(
          () => mockStoryProvider.state,
        ).thenReturn(const StoryLoadState.error(errorMessage));
        when(() => mockStoryProvider.stories).thenReturn([]);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        clearInteractions(mockStoryProvider);

        // rettry button
        final retryButton = find.descendant(
          of: find.byType(StoryErrorView),
          matching: find.byType(ElevatedButton).first,
        );

        // should found and simulate tap
        if (tester.any(retryButton)) {
          await tester.tap(retryButton);
          await tester.pumpAndSettle();

          verify(
            () => mockStoryProvider.refreshStories(user: testUser),
          ).called(1);
        }
      });
    });

    group('Story Card Interaction Tests', () {
      testWidgets('should open detail when story card is tapped', (
        WidgetTester tester,
      ) async {
        when(() => mockAppProvider.openDetailScreen(any())).thenReturn(null);

        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        // tap story card
        await tester.tap(find.byType(HomeStoryCard).first);
        await tester.pump();

        verify(
          () => mockAppProvider.openDetailScreen(testStories[0]),
        ).called(1);
      });
    });
  });
}
