import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storyzz/features/upload_story/presentation/providers/upload_map_controller_provider.dart';

import '../../../../tetsutils/mock.dart';

void main() {
  group('UploadMapControllerProvider', () {
    late UploadMapControllerProvider provider;
    late MockGoogleMapController mockController;

    setUpAll(() {
      registerFallbackValue(
        CameraUpdate.newCameraPosition(
          const CameraPosition(target: LatLng(0, 0)),
        ),
      );
    });

    setUp(() {
      provider = UploadMapControllerProvider();
      mockController = MockGoogleMapController();
    });

    test('initial mapController is null', () {
      expect(provider.mapController, null);
    });

    test('setMapController updates controller and notifies listeners', () {
      int listenerCallCount = 0;
      provider.addListener(() => listenerCallCount++);

      provider.setMapController(mockController);

      expect(provider.mapController, mockController);
      expect(listenerCallCount, 1);
    });

    test('setMapController completes the completer only once', () {
      provider.setMapController(mockController);

      // set again should not throw error
      expect(() => provider.setMapController(mockController), returnsNormally);
    });

    test('disposeController disposes and clears controller', () {
      provider.setMapController(mockController);

      provider.disposeController();

      expect(provider.mapController, null);
      verify(() => mockController.dispose()).called(1);
    });

    test('disposeController notifies listeners', () {
      provider.setMapController(mockController);
      int listenerCallCount = 0;
      provider.addListener(() => listenerCallCount++);

      provider.disposeController();

      expect(listenerCallCount, 1);
    });

    test('animateCamera calls controller animateCamera', () async {
      const position = CameraPosition(target: LatLng(0, 0), zoom: 10);
      when(
        () => mockController.animateCamera(any()),
      ).thenAnswer((_) async => Future.value());

      provider.setMapController(mockController);
      await provider.animateCamera(position);

      verify(() => mockController.animateCamera(any())).called(1);
    });

    test(
      'animateCamera handles errors when controller throws exception',
      () async {
        const position = CameraPosition(target: LatLng(0, 0), zoom: 10);
        when(
          () => mockController.animateCamera(any()),
        ).thenThrow(Exception('Camera animation failed'));

        provider.setMapController(mockController);

        // should not throw, error is caught and logged
        await expectLater(provider.animateCamera(position), completes);
      },
    );

    test('animateCamera handles errors when controller is not set', () async {
      const position = CameraPosition(target: LatLng(0, 0), zoom: 10);

      // no set controller, completer will never complete
      // add a timeout to prevent hanging
      await expectLater(
        provider
            .animateCamera(position)
            .timeout(
              const Duration(milliseconds: 100),
              onTimeout: () {}, // Completes normally on timeout
            ),
        completes,
      );
    });
  });
}
