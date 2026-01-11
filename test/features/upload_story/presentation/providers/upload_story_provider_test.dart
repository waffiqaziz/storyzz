import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storyzz/core/data/networking/models/general/general_response.dart';
import 'package:storyzz/core/data/networking/utils/api_utils.dart';
import 'package:storyzz/features/upload_story/presentation/providers/upload_story_provider.dart';

import '../../../../tetsutils/mock.dart';

void main() {
  group('UploadStoryProvider', () {
    late UploadStoryProvider provider;
    late MockStoryRepository mockRepository;
    late MockAppService mockAppService;

    setUpAll(() {
      registerFallbackValue(FakeCameraDescription());
    });

    setUp(() {
      mockRepository = MockStoryRepository();
      mockAppService = MockAppService();
      provider = UploadStoryProvider(
        storyRepository: mockRepository,
        appService: mockAppService,
      );
    });

    group('Initial State', () {
      test('has correct initial values', () {
        expect(provider.isLoading, false);
        expect(provider.errorMessage, null);
        expect(provider.isSuccess, false);
        expect(provider.caption, '');
        expect(provider.imageFile, null);
        expect(provider.showCamera, false);
        expect(provider.isCameraInitialized, false);
        expect(provider.isRequestingPermission, false);
        expect(provider.cameras, null);
        expect(provider.includeLocation, false);
        expect(provider.selectedLocation, null);
      });
    });

    group('Setters', () {
      test('setCaption updates caption and notifies listeners', () {
        int listenerCallCount = 0;
        provider.addListener(() => listenerCallCount++);

        provider.setCaption('Test caption');

        expect(provider.caption, 'Test caption');
        expect(listenerCallCount, 1);
      });

      test('setImageFile updates imageFile and notifies listeners', () {
        int listenerCallCount = 0;
        provider.addListener(() => listenerCallCount++);
        final mockFile = MockXFile();

        provider.setImageFile(mockFile);

        expect(provider.imageFile, mockFile);
        expect(listenerCallCount, 1);
      });

      test('setShowCamera updates showCamera and notifies listeners', () {
        int listenerCallCount = 0;
        provider.addListener(() => listenerCallCount++);

        provider.setShowCamera(true);

        expect(provider.showCamera, true);
        expect(listenerCallCount, 1);
      });

      test(
        'setCameraInitialized updates isCameraInitialized and notifies listeners',
        () {
          int listenerCallCount = 0;
          provider.addListener(() => listenerCallCount++);

          provider.setCameraInitialized(true);

          expect(provider.isCameraInitialized, true);
          expect(listenerCallCount, 1);
        },
      );

      test(
        'setRequestingPermission updates isRequestingPermission and notifies listeners',
        () {
          int listenerCallCount = 0;
          provider.addListener(() => listenerCallCount++);

          provider.setRequestingPermission(true);

          expect(provider.isRequestingPermission, true);
          expect(listenerCallCount, 1);
        },
      );

      test('setCameras updates cameras and notifies listeners', () {
        int listenerCallCount = 0;
        provider.addListener(() => listenerCallCount++);
        final cameras = <CameraDescription>[];

        provider.setCameras(cameras);

        expect(provider.cameras, cameras);
        expect(listenerCallCount, 1);
      });

      test(
        'toggleLocationIncluded updates includeLocation and notifies listeners',
        () {
          int listenerCallCount = 0;
          provider.addListener(() => listenerCallCount++);

          provider.toggleLocationIncluded(true);

          expect(provider.includeLocation, true);
          expect(listenerCallCount, 1);
        },
      );

      test(
        'setSelectedLocation updates selectedLocation and notifies listeners',
        () {
          int listenerCallCount = 0;
          provider.addListener(() => listenerCallCount++);
          const location = LatLng(1.0, 2.0);

          provider.setSelectedLocation(location);

          expect(provider.selectedLocation, location);
          expect(listenerCallCount, 1);
        },
      );
    });

    group('Reset Methods', () {
      test('reset clears main state properties', () {
        provider.setCaption('Test');
        provider.setImageFile(MockXFile());
        int listenerCallCount = 0;
        provider.addListener(() => listenerCallCount++);

        provider.reset();

        expect(provider.isLoading, false);
        expect(provider.isSuccess, false);
        expect(provider.errorMessage, null);
        expect(provider.caption, 'Test'); // keep the caption
        expect(provider.imageFile, null);
        expect(listenerCallCount, 1);
      });

      test('resetCamera clears camera-related state', () {
        provider.setShowCamera(true);
        provider.setCameraInitialized(true);
        provider.setRequestingPermission(true);
        int listenerCallCount = 0;
        provider.addListener(() => listenerCallCount++);

        provider.resetCamera();

        expect(provider.showCamera, false);
        expect(provider.isCameraInitialized, false);
        expect(provider.isRequestingPermission, false);
        expect(listenerCallCount, 1);
      });

      test('resetAll clears all state', () {
        provider.setCaption('Test');
        provider.setShowCamera(true);

        provider.resetAll();

        expect(provider.caption, 'Test');
        expect(provider.isLoading, false);
        expect(provider.showCamera, false);
      });
    });

    group('uploadStory', () {
      test('successful upload sets isSuccess to true', () async {
        final response = GeneralResponse(error: false, message: 'Success');
        when(
          () => mockRepository.uploadStory(
            token: any(named: 'token'),
            description: any(named: 'description'),
            photoFile: any(named: 'photoFile'),
            photoBytes: any(named: 'photoBytes'),
            fileName: any(named: 'fileName'),
            lat: any(named: 'lat'),
            lon: any(named: 'lon'),
          ),
        ).thenAnswer((_) async => ApiResult.success(response));

        await provider.uploadStory(
          token: 'token',
          description: 'description',
          fileName: 'file.jpg',
        );

        expect(provider.isSuccess, true);
        expect(provider.isLoading, false);
        expect(provider.errorMessage, null);
      });

      test('failed upload sets errorMessage', () async {
        when(
          () => mockRepository.uploadStory(
            token: any(named: 'token'),
            description: any(named: 'description'),
            photoFile: any(named: 'photoFile'),
            photoBytes: any(named: 'photoBytes'),
            fileName: any(named: 'fileName'),
            lat: any(named: 'lat'),
            lon: any(named: 'lon'),
          ),
        ).thenAnswer((_) async => ApiResult.error('Upload failed'));

        await provider.uploadStory(
          token: 'token',
          description: 'description',
          fileName: 'file.jpg',
        );

        expect(provider.isSuccess, false);
        expect(provider.isLoading, false);
        expect(provider.errorMessage, 'Upload failed');
      });
    });

    group('uploadStoryWithFile', () {
      test('uploads with bytes on web platform', () async {
        final mockFile = MockXFile();
        final bytes = Uint8List.fromList([1, 2, 3]);
        final response = GeneralResponse(error: false, message: 'Success');

        when(() => mockAppService.getKIsWeb()).thenReturn(true);
        when(() => mockFile.readAsBytes()).thenAnswer((_) async => bytes);
        when(() => mockFile.name).thenReturn('test.jpg');
        when(
          () => mockRepository.uploadStory(
            token: any(named: 'token'),
            description: any(named: 'description'),
            photoFile: any(named: 'photoFile'),
            photoBytes: any(named: 'photoBytes'),
            fileName: any(named: 'fileName'),
            lat: any(named: 'lat'),
            lon: any(named: 'lon'),
          ),
        ).thenAnswer((_) async => ApiResult.success(response));

        await provider.uploadStoryWithFile(
          token: 'token',
          description: 'description',
          imageFile: mockFile,
        );

        verify(() => mockFile.readAsBytes()).called(1);
        verify(
          () => mockRepository.uploadStory(
            token: 'token',
            description: 'description',
            photoBytes: bytes,
            fileName: 'test.jpg',
            lat: null,
            lon: null,
          ),
        ).called(1);
      });

      test('uploads with file on non-web platform', () async {
        final mockFile = MockXFile();
        final response = GeneralResponse(error: false, message: 'Success');

        when(() => mockAppService.getKIsWeb()).thenReturn(false);
        when(() => mockFile.path).thenReturn('/path/to/file.jpg');
        when(() => mockFile.name).thenReturn('file.jpg');
        when(
          () => mockRepository.uploadStory(
            token: any(named: 'token'),
            description: any(named: 'description'),
            photoFile: any(named: 'photoFile'),
            photoBytes: any(named: 'photoBytes'),
            fileName: any(named: 'fileName'),
            lat: any(named: 'lat'),
            lon: any(named: 'lon'),
          ),
        ).thenAnswer((_) async => ApiResult.success(response));

        await provider.uploadStoryWithFile(
          token: 'token',
          description: 'description',
          imageFile: mockFile,
        );

        verify(
          () => mockRepository.uploadStory(
            token: 'token',
            description: 'description',
            photoFile: any(named: 'photoFile'),
            fileName: 'file.jpg',
            lat: null,
            lon: null,
          ),
        ).called(1);
      });
    });
  });
}
