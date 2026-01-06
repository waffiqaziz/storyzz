import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storyzz/core/data/networking/models/story/list_story.dart';
import 'package:storyzz/core/data/networking/states/story_load_state.dart';

class MockListStory extends Mock implements ListStory {}

void main() {
  group('StoryLoadState', () {
    test('StoryLoadState.initial is created correctly', () {
      const state = StoryLoadState.initial();
      expect(state, isA<StoryLoadStateInitial>());
      expect(state.isInitial, true);
      expect(state.isLoading, false);
      expect(state.isLoaded, false);
      expect(state.isError, false);
      expect(state.errorMessage, null);
    });

    test('StoryLoadState.loading is created correctly', () {
      const state = StoryLoadState.loading();
      expect(state, isA<StoryLoadStateLoading>());
      expect(state.isInitial, false);
      expect(state.isLoading, true);
      expect(state.isLoaded, false);
      expect(state.isError, false);
      expect(state.errorMessage, null);
    });

    test('StoryLoadState.loaded is created correctly', () {
      final mockStory = MockListStory();
      final state = StoryLoadState.loaded([mockStory]);
      expect(state, isA<StoryLoadStateLoaded>());
      expect(state.isInitial, false);
      expect(state.isLoading, false);
      expect(state.isLoaded, true);
      expect(state.isError, false);
      expect(state.errorMessage, null);
      expect((state as StoryLoadStateLoaded).data, isA<List<ListStory>>());
    });

    test('StoryLoadState.error is created correctly', () {
      const state = StoryLoadState.error('Test Error');
      expect(state, isA<StoryLoadStateError>());
      expect(state.isInitial, false);
      expect(state.isLoading, false);
      expect(state.isLoaded, false);
      expect(state.isError, true);
      expect(state.errorMessage, 'Test Error');
    });
  });
}
