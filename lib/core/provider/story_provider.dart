import 'package:flutter/material.dart';
import 'package:storyzz/core/data/model/user.dart';
import 'package:storyzz/core/data/networking/responses/list_story.dart';
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

  bool _isLoading = false;
  String _errorMessage = '';
  List<ListStory> _stories = [];
  bool _hasMoreStories = true;
  int _currentPage = 1;
  final int _pageSize = 10;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<ListStory> get stories => _stories;
  bool get hasMoreStories => _hasMoreStories;

  Future<void> getStories({required User user, bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _stories = [];
      _hasMoreStories = true;
    }

    if (!_hasMoreStories && !refresh) return;

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final result = await _repository.getStories(
      page: _currentPage,
      size: _pageSize,
      user: user,
    );

    if (result.data != null && !result.data!.error) {
      if (refresh) {
        // Freezed package create immutable ListStory so,
        // create a new mutable list instead of directly assigning,
        _stories = List<ListStory>.from(result.data!.listStory);
      } else {
        // create a new mutable list with all current items plus new ones
        _stories = [..._stories, ...result.data!.listStory];
      }
      _hasMoreStories = result.data!.listStory.length >= _pageSize;
      _currentPage++;
    } else if (result.message != null) {
      _errorMessage = result.message!;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshStories({required User user}) async {
    await getStories(user: user, refresh: true);
  }
}
