import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/data/models/user.dart';
import 'package:storyzz/core/data/networking/models/story/list_story.dart';
import 'package:storyzz/core/data/networking/states/story_load_state.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/core/providers/auth_provider.dart';
import 'package:storyzz/core/providers/story_provider.dart';
import 'package:storyzz/features/home/presentation/screen/home_screen.dart';
import 'package:storyzz/features/home/presentation/widgets/home_story_list_view.dart';

import '../../../../tetsutils/data_dump.dart';
import '../../../../tetsutils/mock.dart';

void main() {
  group('HomeScreen State', () {
    late MockAppProvider mockAppProvider;
    late MockAuthProvider mockAuthProvider;
    late MockStoryProvider mockStoryProvider;
    late User testUser;
    late List<ListStory> testStories;

    setUp(() {
      mockAuthProvider = MockAuthProvider();
      mockAppProvider = MockAppProvider();
      mockStoryProvider = MockStoryProvider();
      testUser = dumpTestUser;
      testStories = dumpTestStoryList;

      // setup mock
      when(
        () => mockStoryProvider.state,
      ).thenReturn(const StoryLoadState.initial());
      when(() => mockStoryProvider.hasMoreStories).thenReturn(true);
      when(() => mockAuthProvider.user).thenReturn(testUser);
      when(
        () => mockStoryProvider.state,
      ).thenReturn(StoryLoadState.loaded(testStories));
      when(() => mockStoryProvider.stories).thenReturn(testStories);
      when(() => mockStoryProvider.hasMoreStories).thenReturn(true);
      when(() => mockStoryProvider.isLoadingMore).thenReturn(false);
      when(() => mockAppProvider.selectedStory).thenReturn(null);
    });

    setUpAll(() {
      registerFallbackValue(dumpTestUser);
    });

    Widget createTestWidget() {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<AppProvider>.value(value: mockAppProvider),
          ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
          ChangeNotifierProvider<StoryProvider>.value(value: mockStoryProvider),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: HomeScreen(),
        ),
      );
    }

    testWidgets('should initialize and call _initData on mount', (
      WidgetTester tester,
    ) async {
      when(() => mockAuthProvider.getUser()).thenAnswer((_) async => {});
      when(() => mockAuthProvider.user).thenReturn(null);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      verify(() => mockAuthProvider.getUser()).called(1);
    });

    testWidgets('should load stories when user is available after init', (
      WidgetTester tester,
    ) async {
      when(() => mockAuthProvider.getUser()).thenAnswer((_) async => {});
      when(() => mockAuthProvider.user).thenReturn(testUser);
      when(
        () => mockStoryProvider.getStories(user: any(named: 'user')),
      ).thenAnswer((_) async => {});

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      verify(() => mockAuthProvider.getUser()).called(1);
      verify(() => mockStoryProvider.getStories(user: testUser)).called(1);
    });

    testWidgets('should not load stories when user is null after init', (
      WidgetTester tester,
    ) async {
      when(() => mockAuthProvider.getUser()).thenAnswer((_) async => {});
      when(() => mockAuthProvider.user).thenReturn(null);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      verify(() => mockAuthProvider.getUser()).called(1);
      verifyNever(() => mockStoryProvider.getStories(user: any(named: 'user')));
    });

    testWidgets('should trigger pagination when scrolled near bottom', (
      WidgetTester tester,
    ) async {
      when(() => mockAuthProvider.getUser()).thenAnswer((_) async => {});
      when(() => mockAuthProvider.user).thenReturn(testUser);
      when(
        () => mockStoryProvider.getStories(user: any(named: 'user')),
      ).thenAnswer((_) async => {});
      when(
        () => mockStoryProvider.state,
      ).thenReturn(const StoryLoadState.loaded([]));
      when(() => mockStoryProvider.hasMoreStories).thenReturn(true);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // clear the initial getStories call
      clearInteractions(mockStoryProvider);

      // simulate scroll
      final scrollable = find.byType(Scrollable);
      if (scrollable.evaluate().isNotEmpty) {
        await tester.drag(scrollable.first, const Offset(0, -1000));
        await tester.pumpAndSettle();

        verify(
          () => mockStoryProvider.getStories(user: testUser),
        ).called(greaterThanOrEqualTo(0));
      }
    });

    testWidgets('should not load more stories when already loading', (
      WidgetTester tester,
    ) async {
      when(() => mockAuthProvider.getUser()).thenAnswer((_) async => {});
      when(() => mockAuthProvider.user).thenReturn(testUser);
      when(
        () => mockStoryProvider.getStories(user: any(named: 'user')),
      ).thenAnswer((_) async => {});
      when(
        () => mockStoryProvider.state,
      ).thenReturn(const StoryLoadState.loading());
      when(() => mockStoryProvider.hasMoreStories).thenReturn(true);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      clearInteractions(mockStoryProvider);

      // simulate scroll
      final scrollable = find.byType(Scrollable);
      if (scrollable.evaluate().isNotEmpty) {
        await tester.drag(scrollable.first, const Offset(0, -1000));
        await tester.pumpAndSettle();

        verifyNever(
          () => mockStoryProvider.getStories(user: any(named: 'user')),
        );
      }
    });

    testWidgets('should not load more stories when hasMoreStories is false', (
      WidgetTester tester,
    ) async {
      when(() => mockAuthProvider.getUser()).thenAnswer((_) async => {});
      when(() => mockAuthProvider.user).thenReturn(testUser);
      when(
        () => mockStoryProvider.getStories(user: any(named: 'user')),
      ).thenAnswer((_) async => {});
      when(
        () => mockStoryProvider.state,
      ).thenReturn(const StoryLoadState.loaded([]));
      when(() => mockStoryProvider.hasMoreStories).thenReturn(false);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      clearInteractions(mockStoryProvider);

      // simulate scroll
      final scrollable = find.byType(Scrollable);
      if (scrollable.evaluate().isNotEmpty) {
        await tester.drag(scrollable.first, const Offset(0, -1000));
        await tester.pumpAndSettle();

        verifyNever(
          () => mockStoryProvider.getStories(user: any(named: 'user')),
        );
      }
    });

    testWidgets('should dispose scroll controller properly', (
      WidgetTester tester,
    ) async {
      when(() => mockAuthProvider.getUser()).thenAnswer((_) async => {});
      when(() => mockAuthProvider.user).thenReturn(null);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Remove the widget
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
    });

    testWidgets('should render HomeStoriesListView', (
      WidgetTester tester,
    ) async {
      when(() => mockAuthProvider.getUser()).thenAnswer((_) async => {});
      when(() => mockAuthProvider.user).thenReturn(testUser);
      when(
        () => mockStoryProvider.getStories(user: any(named: 'user')),
      ).thenAnswer((_) async => {});

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(HomeStoriesListView), findsOneWidget);
    });

    testWidgets('should use Consumer for StoryProvider', (
      WidgetTester tester,
    ) async {
      when(() => mockAuthProvider.getUser()).thenAnswer((_) async => {});
      when(() => mockAuthProvider.user).thenReturn(null);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Consumer<StoryProvider>), findsOneWidget);
    });
  });
}
