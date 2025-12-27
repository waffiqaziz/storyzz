import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storyzz/core/data/networking/models/story/list_story.dart';
import 'package:storyzz/core/data/networking/models/story/stories_response.dart';
import 'package:storyzz/core/data/networking/states/story_load_state.dart';
import 'package:storyzz/core/data/networking/utils/api_utils.dart';
import 'package:storyzz/core/providers/story_provider.dart';

import '../../tetsutils/mock.dart';

void main() {
  late StoryProvider storyProvider;
  late MockStoryRepository mockRepository;
  late MockUser mockUser;

  final testStories = [
    ListStory(
      id: '1',
      name: 'Test 1',
      description: 'Description 1',
      photoUrl: 'url1',
      createdAt: DateTime.now(),
    ),
    ListStory(
      id: '2',
      name: 'Test 2',
      description: 'Description 2',
      photoUrl: 'url2',
      createdAt: DateTime.now(),
    ),
  ];

  setUp(() {
    mockRepository = MockStoryRepository();
    mockUser = MockUser();
    storyProvider = StoryProvider(mockRepository);
  });

  group('StoryProvider', () {
    test('should have initial state', () {
      expect(storyProvider.state, const StoryLoadState.initial());
      expect(storyProvider.stories, isEmpty);
      expect(storyProvider.hasMoreStories, true);
    });

    group('getStories', () {
      test('should load stories successfully', () async {
        when(
          () => mockRepository.getStories(
            page: any(named: 'page'),
            size: any(named: 'size'),
            user: mockUser,
          ),
        ).thenAnswer(
          (_) async => ApiResult.success(
            StoriesResponse(
              error: false,
              message: 'Success',
              listStory: testStories,
            ),
          ),
        );

        await storyProvider.getStories(user: mockUser);

        verify(
          () => mockRepository.getStories(page: 1, size: 10, user: mockUser),
        ).called(1);

        expect(storyProvider.stories, equals(testStories));
        expect(storyProvider.state, isA<StoryLoadState>());
        expect(storyProvider.hasMoreStories, false);
      });

      test('should handle error state', () async {
        when(
          () => mockRepository.getStories(
            page: any(named: 'page'),
            size: any(named: 'size'),
            user: mockUser,
          ),
        ).thenAnswer((_) async => ApiResult.error('Error message'));

        await storyProvider.getStories(user: mockUser);

        expect(storyProvider.state, isA<StoryLoadState>());
        expect(storyProvider.stories, isEmpty);
      });

      test('should handle pagination over page size', () async {
        final testTenStories = List.generate(
          10,
          (index) => ListStory(
            id: index.toString(),
            name: 'Test $index',
            description: 'Description $index',
            photoUrl: 'url$index',
            createdAt: DateTime.now(),
          ),
        );

        // First page
        when(
          () => mockRepository.getStories(page: 1, size: 10, user: mockUser),
        ).thenAnswer(
          (_) async => ApiResult.success(
            StoriesResponse(
              error: false,
              message: 'Success',
              listStory: testTenStories,
            ),
          ),
        );

        await storyProvider.getStories(user: mockUser);

        // should be have 10 stories
        expect(storyProvider.stories.length, equals(10));

        // Second page
        when(
          () => mockRepository.getStories(page: 2, size: 10, user: mockUser),
        ).thenAnswer(
          (_) async => ApiResult.success(
            StoriesResponse(
              error: false,
              message: 'Success',
              listStory: testTenStories,
            ),
          ),
        );

        await storyProvider.getStories(user: mockUser);

        expect(storyProvider.stories.length, equals(20));
      });

      test('should handle pagination under page size', () async {
        // First page
        when(
          () => mockRepository.getStories(page: 1, size: 10, user: mockUser),
        ).thenAnswer(
          (_) async => ApiResult.success(
            StoriesResponse(
              error: false,
              message: 'Success',
              listStory: testStories,
            ),
          ),
        );

        await storyProvider.getStories(user: mockUser);

        expect(storyProvider.stories.length, equals(2));
        expect(storyProvider.hasMoreStories, false);

        await storyProvider.getStories(user: mockUser);

        // stories length should still be 2 because no more stories were loaded
        expect(storyProvider.stories.length, equals(2));
      });
    });

    group('refreshStories', () {
      test('should refresh stories successfully', () async {
        when(
          () => mockRepository.getStories(
            page: any(named: 'page'),
            size: any(named: 'size'),
            user: mockUser,
          ),
        ).thenAnswer(
          (_) async => ApiResult.success(
            StoriesResponse(
              error: false,
              message: 'Success',
              listStory: testStories,
            ),
          ),
        );

        await storyProvider.refreshStories(user: mockUser);

        verify(
          () => mockRepository.getStories(page: 1, size: 10, user: mockUser),
        ).called(1);

        expect(storyProvider.stories, equals(testStories));
        expect(storyProvider.state, isA<StoryLoadState>());
      });
    });
  });
}
