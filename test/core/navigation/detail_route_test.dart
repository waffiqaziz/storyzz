import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storyzz/core/data/networking/models/story/list_story.dart';
import 'package:storyzz/core/design/widgets/not_found_widget.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/navigation/app_router.dart';

import '../../tetsutils/mock.dart';

class MockBuildContext extends Mock implements BuildContext {}

class MockGoRouterState extends Mock implements GoRouterState {}

void main() {
  late AppRouter appRouter;
  late MockAppProvider mockAppProvider;
  late MockAuthProvider mockAuthProvider;
  late MockBuildContext mockContext;

  setUp(() {
    mockAppProvider = MockAppProvider();
    mockAuthProvider = MockAuthProvider();
    mockContext = MockBuildContext();

    when(() => mockAuthProvider.isLogged()).thenAnswer((_) async => true);
    when(() => mockAuthProvider.isLoggedIn).thenReturn(true);
    when(() => mockAuthProvider.addListener(any())).thenReturn(null);
    when(() => mockAuthProvider.removeListener(any())).thenReturn(null);

    // setup app route
    appRouter = AppRouter(
      authProvider: mockAuthProvider,
      appProvider: mockAppProvider,
    );
  });

  setUpAll(() {
    registerFallbackValue(MockBuildContext());
    registerFallbackValue(MockGoRouterState());
  });

  group('Detail route redirect logic', () {
    test(
      'should redirect to parent route when selectedStory is null and isFromDetail is true',
      () {
        when(() => mockAppProvider.selectedStory).thenReturn(null);
        when(() => mockAppProvider.isFromDetail).thenReturn(true);
        when(() => mockAppProvider.isDetailFullScreenMap).thenReturn(false);

        final detailRoute = appRouter.detailRoute('home');
        final redirectFunction = detailRoute.redirect!;

        final mockState = MockGoRouterState();
        when(() => mockState.pathParameters).thenReturn({'id': '123'});
        when(() => mockState.uri).thenReturn(Uri.parse('/home/story/123'));
        when(() => mockState.matchedLocation).thenReturn('/home/story/123');
        when(() => mockState.fullPath).thenReturn('/home/story/:id');

        final result = redirectFunction(mockContext, mockState);

        expect(result, '/home');
        verify(
          () => mockAppProvider.selectedStory,
        ).called(greaterThanOrEqualTo(1));
        verify(() => mockAppProvider.isFromDetail).called(1);
      },
    );

    testWidgets(
      'should redirect to parent route when selectedStory is null and isFromDetail is false',
      (tester) async {
        when(() => mockAppProvider.selectedStory).thenReturn(null);
        when(() => mockAppProvider.isFromDetail).thenReturn(false);
        when(() => mockAppProvider.isDetailFullScreenMap).thenReturn(false);

        final detailRoute = appRouter.detailRoute('map');
        final redirectFunction = detailRoute.redirect!;

        final mockState = MockGoRouterState();
        when(() => mockState.pathParameters).thenReturn({'id': '456'});
        when(() => mockState.uri).thenReturn(Uri.parse('/map/story/456'));
        when(() => mockState.matchedLocation).thenReturn('/map/story/456');
        when(() => mockState.fullPath).thenReturn('/map/story/:id');

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: const [
              AppLocalizations
                  .delegate, // Add your app's localizations delegate
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en')],
            home: Builder(
              builder: (context) {
                final result = redirectFunction(context, mockState);
                expect(result, '/map');
                return const Scaffold(body: SizedBox());
              },
            ),
          ),
        );

        // pump to execute post frame callbacks
        await tester.pump();
        // extra pump to show snackbar
        await tester.pump();

        // verify snackbar is shown
        expect(find.byType(SnackBar), findsOneWidget);

        // selectedStory is called 2 (inside if statement) + 1 (from log)
        verify(() => mockAppProvider.selectedStory).called(3);

        // isFromDetail is called 2 (inside if statement)
        verify(() => mockAppProvider.isFromDetail).called(2);
      },
    );

    test('should return null when selectedStory is not null', () {
      final testStory = ListStory(
        id: '1',
        name: 'Test Story',
        description: 'Test Description',
        photoUrl: 'https://example.com/photo.jpg',
        createdAt: DateTime.now(),
      );

      when(() => mockAppProvider.selectedStory).thenReturn(testStory);
      when(() => mockAppProvider.isFromDetail).thenReturn(false);
      when(() => mockAppProvider.isDetailFullScreenMap).thenReturn(false);

      final detailRoute = appRouter.detailRoute('');
      final redirectFunction = detailRoute.redirect!;

      final mockState = MockGoRouterState();
      when(() => mockState.pathParameters).thenReturn({'id': '1'});
      when(() => mockState.uri).thenReturn(Uri.parse('/story/1'));
      when(() => mockState.matchedLocation).thenReturn('/story/1');
      when(() => mockState.fullPath).thenReturn('/story/:id');

      final result = redirectFunction(mockContext, mockState);

      expect(result, null);
      verify(
        () => mockAppProvider.selectedStory,
      ).called(greaterThanOrEqualTo(1));
    });

    test('should use empty string for root route', () {
      when(() => mockAppProvider.selectedStory).thenReturn(null);
      when(() => mockAppProvider.isFromDetail).thenReturn(true);
      when(() => mockAppProvider.isDetailFullScreenMap).thenReturn(false);

      final detailRoute = appRouter.detailRoute('');
      final redirectFunction = detailRoute.redirect!;

      final mockState = MockGoRouterState();
      when(() => mockState.pathParameters).thenReturn({'id': '789'});
      when(() => mockState.uri).thenReturn(Uri.parse('/story/789'));
      when(() => mockState.matchedLocation).thenReturn('/story/789');
      when(() => mockState.fullPath).thenReturn('/story/:id');

      final result = redirectFunction(mockContext, mockState);

      expect(result, '/'); // should redirect to root
    });

    test('should handle settings route correctly', () {
      when(() => mockAppProvider.selectedStory).thenReturn(null);
      when(() => mockAppProvider.isFromDetail).thenReturn(true);
      when(() => mockAppProvider.isDetailFullScreenMap).thenReturn(false);

      final detailRoute = appRouter.detailRoute('settings');
      final redirectFunction = detailRoute.redirect!;

      final mockState = MockGoRouterState();
      when(() => mockState.pathParameters).thenReturn({'id': '999'});
      when(() => mockState.uri).thenReturn(Uri.parse('/settings/story/999'));
      when(() => mockState.matchedLocation).thenReturn('/settings/story/999');
      when(() => mockState.fullPath).thenReturn('/settings/story/:id');

      final result = redirectFunction(mockContext, mockState);

      expect(result, '/settings');
    });

    testWidgets('should return NotFoundWidget when persistedStory is null', (
      tester,
    ) async {
      when(() => mockAppProvider.selectedStory).thenReturn(null);
      when(() => mockAppProvider.isFromDetail).thenReturn(false);
      when(() => mockAppProvider.isDetailFullScreenMap).thenReturn(false);

      final detailRoute = appRouter.detailRoute('map');
      final pageBuilder = detailRoute.pageBuilder!;

      final mockState = MockGoRouterState();
      when(() => mockState.pathParameters).thenReturn({'id': '456'});
      when(() => mockState.uri).thenReturn(Uri.parse('/map/story/456'));
      when(() => mockState.matchedLocation).thenReturn('/map/story/456');
      when(() => mockState.fullPath).thenReturn('/map/story/:id');
      when(() => mockState.pageKey).thenReturn(const ValueKey('test'));

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // check peyrsistedStory
              final page = pageBuilder(context, mockState);

              expect(page, isA<MaterialPage>());
              expect((page as MaterialPage).child, isA<NotFoundWidget>());

              return const Scaffold(body: SizedBox());
            },
          ),
        ),
      );

      await tester.pump();
    });
  });
}
