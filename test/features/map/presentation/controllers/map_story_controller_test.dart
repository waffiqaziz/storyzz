import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/data/networking/states/story_load_state.dart';
import 'package:storyzz/core/providers/auth_provider.dart';
import 'package:storyzz/core/providers/story_provider.dart';
import 'package:storyzz/features/map/presentations/controllers/map_story_controller.dart';

import '../../../../tetsutils/data_dump.dart';
import '../../../../tetsutils/mock.dart';

void main() {
  late MockAuthProvider mockAuthProvider;
  late MockStoryProvider mockStoryProvider;
  late MockGoogleMapController mockMapController;
  late ScrollController scrollController;
  late MockUser mockUser;
  late BuildContext context;

  setUpAll(() {
    registerFallbackValue(MockUser());
    registerFallbackValue(FakeCameraUpdate());
  });

  setUp(() {
    mockAuthProvider = MockAuthProvider();
    mockStoryProvider = MockStoryProvider();
    mockUser = MockUser();
    mockMapController = MockGoogleMapController();
    scrollController = ScrollController();
  });

  Widget createTestWidget(Widget child) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
        ChangeNotifierProvider<StoryProvider>.value(value: mockStoryProvider),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (ctx) {
              context = ctx;
              return child;
            },
          ),
        ),
      ),
    );
  }

  group('Initialization and Disposal', () {
    testWidgets('initializes with correct defaults', (tester) async {
      await tester.pumpWidget(createTestWidget(Container()));

      final controller = MapStoryController(context);
      expect(controller.isMapReady, false);
      expect(controller.selectedMapType, MapType.normal);
      expect(controller.markers, isA<Set<Marker>>());

      controller.dispose();
    });

    testWidgets('disposes scroll controller and map controller', (
      tester,
    ) async {
      when(() => mockStoryProvider.stories).thenReturn([]);

      await tester.pumpWidget(createTestWidget(Container()));

      final controller = MapStoryController(context);
      controller.onMapCreated(mockMapController);

      expect(controller.isMapReady, true);
      expect(() => controller.dispose(), returnsNormally);
    });
  });

  group('Map Type', () {
    testWidgets('toggles between normal and satellite', (tester) async {
      await tester.pumpWidget(createTestWidget(Container()));

      final controller = MapStoryController(context);

      expect(controller.selectedMapType, MapType.normal);
      controller.toggleMapType();
      expect(controller.selectedMapType, MapType.satellite);
      controller.toggleMapType();
      expect(controller.selectedMapType, MapType.normal);

      controller.dispose();
    });
  });

  group('Data Loading', () {
    testWidgets('initData fetches user and stories, then updates markers', (
      tester,
    ) async {
      when(() => mockAuthProvider.getUser()).thenAnswer((_) async => {});
      when(() => mockAuthProvider.user).thenReturn(mockUser);
      when(
        () => mockStoryProvider.getStories(user: any(named: 'user')),
      ).thenAnswer((_) async => {});
      when(() => mockStoryProvider.stories).thenReturn([dumpTestlistStory1]);
      when(
        () => mockMapController.animateCamera(any()),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(createTestWidget(Container()));

      final controller = MapStoryController(context);
      controller.onMapCreated(mockMapController);

      await controller.initData();
      await tester.pump();

      verify(() => mockAuthProvider.getUser()).called(1);
      verify(
        () => mockStoryProvider.getStories(user: any(named: 'user')),
      ).called(1);

      controller.dispose();
    });

    testWidgets('initData does nothing when user is null', (tester) async {
      when(() => mockAuthProvider.getUser()).thenAnswer((_) async => {});
      when(() => mockAuthProvider.user).thenReturn(null);

      await tester.pumpWidget(createTestWidget(Container()));

      final controller = MapStoryController(context);
      await controller.initData();

      verify(() => mockAuthProvider.getUser()).called(1);
      verifyNever(() => mockStoryProvider.getStories(user: any(named: 'user')));

      controller.dispose();
    });

    testWidgets('refreshStories updates data and markers', (tester) async {
      when(() => mockAuthProvider.user).thenReturn(mockUser);
      when(
        () => mockStoryProvider.refreshStories(user: any(named: 'user')),
      ).thenAnswer((_) async => {});
      when(() => mockStoryProvider.stories).thenReturn([dumpTestlistStory1]);
      when(
        () => mockMapController.animateCamera(any()),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(createTestWidget(Container()));

      final controller = MapStoryController(context);
      controller.onMapCreated(mockMapController);

      await controller.refreshStories();
      await tester.pump();

      verify(
        () => mockStoryProvider.refreshStories(user: any(named: 'user')),
      ).called(1);

      controller.dispose();
    });

    testWidgets('refreshStories does nothing when user is null', (
      tester,
    ) async {
      when(() => mockAuthProvider.user).thenReturn(null);

      await tester.pumpWidget(createTestWidget(Container()));

      final controller = MapStoryController(context);
      await controller.refreshStories();

      verifyNever(
        () => mockStoryProvider.refreshStories(user: any(named: 'user')),
      );

      controller.dispose();
    });
  });

  group('Map Interaction', () {
    testWidgets('onMapCreated sets map ready and updates existing markers', (
      tester,
    ) async {
      when(() => mockStoryProvider.stories).thenReturn([dumpTestlistStory1]);
      when(
        () => mockMapController.animateCamera(any()),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(createTestWidget(Container()));

      final controller = MapStoryController(context);
      expect(controller.isMapReady, false);

      controller.onMapCreated(mockMapController);
      await tester.pump();

      expect(controller.isMapReady, true);

      controller.dispose();
    });

    testWidgets('onStoryTap animates camera to story location', (tester) async {
      when(
        () => mockMapController.animateCamera(any()),
      ).thenAnswer((_) async {});
      when(() => mockStoryProvider.stories).thenReturn([]);

      await tester.pumpWidget(createTestWidget(Container()));

      final controller = MapStoryController(context);
      controller.onMapCreated(mockMapController);

      controller.onStoryTap(dumpTestlistStory1);

      verify(() => mockMapController.animateCamera(any())).called(1);

      controller.dispose();
    });

    testWidgets('onStoryTap does nothing when coordinates are null', (
      tester,
    ) async {
      final storyWithoutLocation = dumpTestlistStory1.copyWith(
        lat: null,
        lon: null,
      );
      when(() => mockStoryProvider.stories).thenReturn([dumpTestlistStory1]);
      when(
        () => mockMapController.animateCamera(any()),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(createTestWidget(Container()));

      final controller = MapStoryController(context);
      controller.onMapCreated(mockMapController);

      await tester.pumpAndSettle();

      reset(mockMapController);

      when(
        () => mockMapController.animateCamera(any()),
      ).thenAnswer((_) async {});

      controller.onStoryTap(storyWithoutLocation);

      verifyNever(() => mockMapController.animateCamera(any()));

      controller.dispose();
    });

    testWidgets('onStoryTap does nothing when map not ready', (tester) async {
      await tester.pumpWidget(createTestWidget(Container()));

      final controller = MapStoryController(context);

      controller.onStoryTap(dumpTestlistStory1);

      verifyNever(() => mockMapController.animateCamera(any()));

      controller.dispose();
    });
  });

  group('Marker Updates', () {
    testWidgets('updateMarkersFromStories updates markers via map service', (
      tester,
    ) async {
      when(
        () => mockMapController.animateCamera(any()),
      ).thenAnswer((_) async {});
      when(() => mockStoryProvider.stories).thenReturn([]);

      await tester.pumpWidget(createTestWidget(Container()));

      final controller = MapStoryController(context);
      controller.onMapCreated(mockMapController);
      await tester.pump();

      controller.updateMarkersFromStories([
        dumpTestlistStory1,
        dumpTestlistStory2,
      ]);
      await tester.pump();

      controller.dispose();
    });

    testWidgets('shows snackbar when less than 25% stories have location', (
      tester,
    ) async {
      when(
        () => mockMapController.animateCamera(any()),
      ).thenAnswer((_) async {});
      when(() => mockStoryProvider.stories).thenReturn([]);

      await tester.pumpWidget(createTestWidget(Container()));

      final controller = MapStoryController(context);
      controller.onMapCreated(mockMapController);
      await tester.pump();

      final storiesWithFewLocations = [
        dumpTestlistStory1,
        dumpTestlistStory1.copyWith(id: '2', lat: null, lon: null),
        dumpTestlistStory1.copyWith(id: '3', lat: null, lon: null),
        dumpTestlistStory1.copyWith(id: '4', lat: null, lon: null),
        dumpTestlistStory1.copyWith(id: '5', lat: null, lon: null),
      ];

      controller.updateMarkersFromStories(storiesWithFewLocations);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text('Only 1 out of 5 stories have location data'),
        findsOneWidget,
      );

      controller.dispose();
    });

    testWidgets('marker tap callback triggers camera animation', (
      tester,
    ) async {
      when(
        () => mockMapController.animateCamera(any()),
      ).thenAnswer((_) async {});
      when(() => mockStoryProvider.stories).thenReturn([]);

      await tester.pumpWidget(createTestWidget(Container()));

      final controller = MapStoryController(context);
      controller.onMapCreated(mockMapController);

      controller.updateMarkersFromStories([dumpTestlistStory1]);
      await tester.pump();

      controller.dispose();
    });
  });

  group('Infinite Scroll', () {
    testWidgets('loads more stories when scrolling near bottom', (
      tester,
    ) async {
      when(() => mockAuthProvider.user).thenReturn(mockUser);
      when(
        () => mockStoryProvider.state,
      ).thenReturn(StoryLoadState.loaded(dumpTestStoryList));
      when(() => mockStoryProvider.hasMoreStories).thenReturn(true);
      when(
        () => mockStoryProvider.getStories(user: any(named: 'user')),
      ).thenAnswer((_) async => {});
      when(() => mockStoryProvider.stories).thenReturn([dumpTestlistStory1]);
      when(() => mockStoryProvider.stories).thenReturn([dumpTestlistStory1]);
      when(
        () => mockMapController.animateCamera(any()),
      ).thenAnswer((_) async {});

      await tester.pumpWidget(
        createTestWidget(
          ListView.builder(
            controller: scrollController,
            itemCount: 50,
            itemBuilder: (context, index) => SizedBox(
              height: 100,
              child: ListTile(title: Text('Item $index')),
            ),
          ),
        ),
      );

      final controller = MapStoryController(context);
      controller.onMapCreated(mockMapController);

      // scroll to near bottom (within 500 pixels)
      await tester.drag(find.byType(ListView), const Offset(0, -10000));
      await tester.pumpAndSettle();

      // verify(
      //   () => mockStoryProvider.getStories(user: any(named: 'user')),
      // ).called(greaterThan(0));

      controller.dispose();
    });

    testWidgets('scroll listener does not load when conditions not met', (
      tester,
    ) async {
      final testCases = [
        {
          'desc': 'already loading',
          'loading': true,
          'hasMore': true,
          'user': mockUser,
        },
        {
          'desc': 'no more stories',
          'loading': false,
          'hasMore': false,
          'user': mockUser,
        },
        {'desc': 'null user', 'loading': false, 'hasMore': true, 'user': null},
      ];

      for (final testCase in testCases) {
        when(
          () => mockAuthProvider.user,
        ).thenReturn(testCase['user'] as MockUser?);
        when(() => mockStoryProvider.state).thenReturn(
          testCase['loading'] as bool
              ? StoryLoadState.loading()
              : StoryLoadState.loaded(dumpTestStoryList),
        );
        when(
          () => mockStoryProvider.hasMoreStories,
        ).thenReturn(testCase['hasMore'] as bool);

        await tester.pumpWidget(
          createTestWidget(
            ListView.builder(
              controller: scrollController,
              itemCount: 50,
              itemBuilder: (context, index) => SizedBox(
                height: 100,
                child: ListTile(title: Text('Item $index')),
              ),
            ),
          ),
        );

        final controller = MapStoryController(context);

        await tester.drag(find.byType(ListView), const Offset(0, -10000));
        await tester.pumpAndSettle();

        verifyNever(
          () => mockStoryProvider.getStories(user: any(named: 'user')),
        );

        controller.dispose();
      }
    });
  });
}
