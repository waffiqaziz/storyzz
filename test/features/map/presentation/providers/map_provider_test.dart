import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storyzz/core/data/networking/models/story/list_story.dart';
import 'package:storyzz/features/map/presentations/providers/map_provider.dart';

import '../../../../tetsutils/data_dump.dart';
import '../../../../tetsutils/mock.dart';

void main() {
  late MockAuthProvider authProvider;
  late MockStoryProvider storyProvider;
  late MockMapService mapService;
  late MapProvider provider;

  setUpAll(() {
    registerFallbackValue(const LatLng(0, 0));
  });

  setUp(() {
    authProvider = MockAuthProvider();
    storyProvider = MockStoryProvider();
    mapService = MockMapService();

    when(() => mapService.markers).thenReturn(<Marker>{});
    when(() => mapService.getProcessedIds()).thenReturn(<String>{});
    when(() => mapService.getValidLocationCount()).thenReturn(0);

    provider = MapProvider(
      mapService: mapService,
      authProvider: authProvider,
      storyProvider: storyProvider,
    );
  });

  test('markers returns markers from MapService', () {
    final marker = Marker(markerId: const MarkerId('1'));

    when(() => mapService.markers).thenReturn({marker});

    expect(provider.markers, contains(marker));
  });

  test('toggleMapType switches between normal and satellite', () {
    expect(provider.selectedMapType, MapType.normal);

    provider.toggleMapType();
    expect(provider.selectedMapType, MapType.satellite);

    provider.toggleMapType();
    expect(provider.selectedMapType, MapType.normal);
  });

  test(
    'initData loads user and stories and updates markers when map ready',
    () async {
      final stories = <ListStory>[];

      when(() => authProvider.getUser()).thenAnswer((_) async {});
      when(() => authProvider.user).thenReturn(dumpTestUser);

      when(
        () => storyProvider.getStories(user: dumpTestUser),
      ).thenAnswer((_) async {});
      when(() => storyProvider.stories).thenReturn(stories);

      provider.isMapReady = true;

      await provider.initData();

      verify(() => authProvider.getUser()).called(1);
      verify(() => storyProvider.getStories(user: dumpTestUser)).called(1);
      verify(
        () => mapService.updateMarkers(
          stories,
          onStoryTap: any(named: 'onStoryTap'),
        ),
      ).called(1);
    },
  );

  test('onMapCreated sets map ready and updates markers', () {
    final controller = MockGoogleMapController();
    final stories = <ListStory>[];

    when(() => storyProvider.stories).thenReturn(stories);

    provider.onMapCreated(controller);

    expect(provider.isMapReady, true);
    verify(() => mapService.setController(controller)).called(1);
  });

  test('onStoryTap animates camera when lat/lon exist', () {
    provider.isMapReady = true;

    provider.onStoryTap(dumpTestlistStory1);

    verify(
      () => mapService.animateCameraToPosition(
        const LatLng(-6.2088, 106.8456),
        11,
      ),
    ).called(1);
  });
}
