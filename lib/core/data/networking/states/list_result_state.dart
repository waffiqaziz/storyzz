import 'package:storyzz/core/data/networking/responses/stories_response.dart';

sealed class ListStoriesState {}

class ListStoriesNoneState extends ListStoriesState {}

class ListStoriesLoadingState extends ListStoriesState {}

class ListStoriesErrorState extends ListStoriesState {
  final String error;

  ListStoriesErrorState(this.error);
}

class ListStoriesLoadedState extends ListStoriesState {
  final List<ListStory> data;

  ListStoriesLoadedState(this.data);
}
