import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storyzz/core/data/model/user.dart';
import 'package:storyzz/core/data/networking/responses/general_response.dart';
import 'package:storyzz/core/data/networking/responses/stories_response.dart';
import 'package:storyzz/core/data/networking/utils/api_utils.dart';
import 'package:storyzz/core/data/repository/story_repository.dart';

import '../../../tetsutils/mock.dart';

void main() {
  late StoryRepository storyRepository;
  late MockApiServices mockApiServices;
  final mockFile = MockFile();

  setUp(() {
    mockApiServices = MockApiServices();
    storyRepository = StoryRepository(mockApiServices);

    when(
      () => mockFile.openRead(),
    ).thenAnswer((_) => Stream.value(Uint8List(0)));
    when(() => mockFile.length()).thenAnswer((_) async => 100);
    when(() => mockFile.path).thenReturn('test.jpg');
  });

  group('getStories', () {
    final user = User(name: 'test', token: 'token');
    final successResponse = ApiResult.success(
      StoriesResponse(error: false, message: 'Success', listStory: []),
    );

    test('should return stories when call is successful', () async {
      when(
        () => mockApiServices.getStories(
          page: any(named: 'page'),
          size: any(named: 'size'),
          location: any(named: 'location'),
          user: user,
        ),
      ).thenAnswer((_) async => successResponse);

      final result = await storyRepository.getStories(
        page: 1,
        size: 10,
        location: 1,
        user: user,
      );

      expect(result, equals(successResponse));
      verify(
        () => mockApiServices.getStories(
          page: 1,
          size: 10,
          location: 1,
          user: user,
        ),
      ).called(1);
    });

    test('should pass correct parameters to api service', () async {
      when(
        () => mockApiServices.getStories(
          page: 1,
          size: 1,
          location: 1,
          user: user,
        ),
      ).thenAnswer((_) async => successResponse);

      await storyRepository.getStories(
        user: user,
        page: 1,
        size: 1,
        location: 1,
      );

      verify(
        () => mockApiServices.getStories(
          page: 1,
          size: 1,
          location: 1,
          user: user,
        ),
      ).called(1);
    });
  });

  group('uploadStory', () {
    final successResponse = ApiResult.success(
      GeneralResponse(error: false, message: 'Success'),
    );
    const token = 'test-token';
    const description = 'test description';
    const fileName = 'test.jpg';
    final photoFile = mockFile;
    final photoBytes = Uint8List(0);

    test('should upload story with photo file successfully', () async {
      when(
        () => mockApiServices.uploadStory(
          token: any(named: 'token'),
          description: any(named: 'description'),
          photoFile: any(named: 'photoFile'),
          photoBytes: any(named: 'photoBytes'),
          fileName: any(named: 'fileName'),
          lat: any(named: 'lat'),
          lon: any(named: 'lon'),
        ),
      ).thenAnswer((_) async => successResponse);

      final result = await storyRepository.uploadStory(
        token: token,
        description: description,
        photoFile: photoFile,
        fileName: fileName,
      );

      expect(result, equals(successResponse));
      verify(
        () => mockApiServices.uploadStory(
          token: token,
          description: description,
          photoFile: photoFile,
          photoBytes: null,
          fileName: fileName,
          lat: null,
          lon: null,
        ),
      ).called(1);
    });

    test('should upload story with photo bytes successfully', () async {
      when(
        () => mockApiServices.uploadStory(
          token: any(named: 'token'),
          description: any(named: 'description'),
          photoFile: any(named: 'photoFile'),
          photoBytes: any(named: 'photoBytes'),
          fileName: any(named: 'fileName'),
          lat: any(named: 'lat'),
          lon: any(named: 'lon'),
        ),
      ).thenAnswer((_) async => successResponse);

      final result = await storyRepository.uploadStory(
        token: token,
        description: description,
        photoBytes: photoBytes,
        fileName: fileName,
        lat: 10.0,
        lon: 20.0,
      );

      expect(result, equals(successResponse));
      verify(
        () => mockApiServices.uploadStory(
          token: token,
          description: description,
          photoFile: null,
          photoBytes: photoBytes,
          fileName: fileName,
          lat: 10.0,
          lon: 20.0,
        ),
      ).called(1);
    });
  });
}
