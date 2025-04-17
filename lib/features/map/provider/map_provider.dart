import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:storyzz/core/data/networking/responses/list_story.dart';
import 'package:storyzz/core/provider/auth_provider.dart';
import 'package:storyzz/core/provider/story_provider.dart';
import 'package:storyzz/features/map/services/map_service.dart';

/// Manages map state, markers, and interactions for displaying user stories.
///
/// Handles:
/// - Map type toggling
/// - Scroll-based story loading
/// - Marker updates from story data
/// - Map readiness and camera animations
/// - Location warning logic
///
/// Requires [AuthProvider] and [StoryProvider].
/// Call [initData] to load initial data.
class MapProvider extends ChangeNotifier {
  final MapService _mapService = MapService();
  final AuthProvider _authProvider;
  final StoryProvider _storyProvider;
  final ScrollController scrollController = ScrollController();

  MapType _selectedMapType = MapType.normal;
  bool isMapReady = false;

  MapProvider({
    required AuthProvider authProvider,
    required StoryProvider storyProvider,
  }) : _authProvider = authProvider,
       _storyProvider = storyProvider {
    _setupScrollListener();
  }

  @override
  void dispose() {
    scrollController.dispose();
    if (isMapReady) {
      _mapService.disposeController();
    }
    super.dispose();
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 500) {
        _loadMoreStoriesIfNeeded();
      }
    });
  }

  MapType get selectedMapType => _selectedMapType;
  Set<Marker> get markers => _mapService.markers;

  /// Load more stories method
  void _loadMoreStoriesIfNeeded() {
    if (!_storyProvider.isLoading &&
        _storyProvider.hasMoreStories &&
        _authProvider.user != null) {
      _storyProvider.getStories(user: _authProvider.user!).then((_) {
        // update markers after loading more stories
        if (isMapReady) {
          updateMarkersFromStories(_storyProvider.stories);
        }
      });
    }
  }

  Future<void> initData() async {
    await _authProvider.getUser();

    if (_authProvider.user != null) {
      await _storyProvider.getStories(user: _authProvider.user!);

      if (isMapReady) {
        updateMarkersFromStories(_storyProvider.stories);
      }
    }
  }

  Future<void> refreshStories() async {
    if (_authProvider.user != null) {
      await _storyProvider.refreshStories(user: _authProvider.user!);

      if (isMapReady) {
        updateMarkersFromStories(_storyProvider.stories);
      }
    }
  }

  // change map type
  void toggleMapType() {
    if (_selectedMapType == MapType.normal) {
      _selectedMapType = MapType.satellite;
    } else {
      _selectedMapType = MapType.normal;
    }
    notifyListeners();
  }

  void updateMarkersFromStories(List<ListStory> stories) {
    _mapService.updateMarkers(
      stories,
      onStoryTap: (position) {
        _mapService.animateCameraToPosition(position, 15);
      },
    );

    // Store information about valid locations
    _validLocationCount = _mapService.getValidLocationCount();
    _processedIdsCount = _mapService.getProcessedIds().length;
    notifyListeners();
  }

  // Track location stats
  int _validLocationCount = 0;
  int _processedIdsCount = 0;

  bool get shouldShowLocationWarning =>
      _validLocationCount > 0 && _validLocationCount < _processedIdsCount / 4;

  String get locationWarningMessage =>
      "Only $_validLocationCount out of $_processedIdsCount stories have location data";

  // Map creation handler
  void onMapCreated(GoogleMapController controller) {
    _mapService.setController(controller);
    isMapReady = true;

    // Update markers if already have stories
    if (_storyProvider.stories.isNotEmpty) {
      updateMarkersFromStories(_storyProvider.stories);
    }

    notifyListeners();
  }

  // Handle story tap
  void onStoryTap(ListStory story) {
    if (story.lat != null && story.lon != null && isMapReady) {
      final position = LatLng(story.lat!, story.lon!);
      _mapService.animateCameraToPosition(position, 11);
    }
  }
}
