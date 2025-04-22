import 'package:flutter/material.dart';
import 'package:storyzz/core/data/model/user.dart';
import 'package:storyzz/core/data/networking/responses/list_story.dart';
import 'package:storyzz/core/data/networking/states/story_load_state.dart';
import 'package:storyzz/core/data/repository/story_repository.dart';

/// Manages the state of paginated user stories fetched from the server.
///
/// Handles:
/// - Fetching stories with pagination
/// - Refreshing story list
/// - Tracking loading state and error messages
/// - Exposing whether more stories are available
///
/// Depends on [StoryRepository] for data access.
class StoryProvider extends ChangeNotifier {
  final StoryRepository _repository;

  StoryProvider(this._repository);

  StoryLoadState _state = const StoryLoadState.initial();
  StoryLoadState get state => _state;

  List<ListStory> _stories = [];
  bool _hasMoreStories = true;
  int _currentPage = 1;
  final int _pageSize = 10;
  bool _isLoadingMore = false;
  List<ListStory> get stories => _stories;
  bool get hasMoreStories => _hasMoreStories;

  Future<void> getStories({required User user, bool refresh = false}) async {
    // return if already loading more items in pagination mode
    if (_isLoadingMore && !refresh) return;

    if (refresh) {
      _currentPage = 1;
      _stories = [];
      _hasMoreStories = true;
    }

    if (!_hasMoreStories && !refresh) return;

    // set loading flag based on is refresh or pagination
    if (refresh) {
      _state = const StoryLoadState.loading();
    } else {
      _isLoadingMore = true;
    }
    notifyListeners();

    try {
      final result = await _repository.getStories(
        page: _currentPage,
        size: _pageSize,
        user: user,
      );

      if (result.data != null && !result.data!.error) {
        if (refresh) {
          _stories = List<ListStory>.from(result.data!.listStory);
        } else {
          _stories = [..._stories, ...result.data!.listStory];
        }
        _hasMoreStories = result.data!.listStory.length >= _pageSize;
        _currentPage++;
        _state = StoryLoadState.loaded(_stories);
      } else if (result.message != null) {
        _state = StoryLoadState.error(result.message!);
      }
    } catch (e) {
      _state = StoryLoadState.error(e.toString());
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> refreshStories({required User user}) async {
    await getStories(user: user, refresh: true);
  }
}
