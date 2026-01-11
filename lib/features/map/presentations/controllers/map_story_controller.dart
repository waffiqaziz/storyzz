import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/data/networking/models/story/list_story.dart';
import 'package:storyzz/core/providers/auth_provider.dart';
import 'package:storyzz/core/providers/story_provider.dart';
import 'package:storyzz/features/map/services/map_service.dart';

/// A controller that manages map-related functionality for the story map screen.
///
/// The [MapStoryController] handles:
/// - Managing the state of the map (such as the selected map type).
/// - Updating markers on the map based on story data.
/// - Listening for scroll events to load more stories when the user reaches the end of the list (pagination).
class MapStoryController {
  final BuildContext context;
  final ScrollController scrollController = ScrollController();
  final MapService _mapService = MapService();

  MapType selectedMapType = MapType.normal;
  bool isMapReady = false;

  /// Creates a [MapStoryController] with the provided [context].
  MapStoryController(this.context) {
    scrollController.addListener(_scrollListener);
  }

  /// Disposes the resources used by the controller, including the [ScrollController] and map controller.
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    if (isMapReady) {
      _mapService.disposeController();
    }
  }

  /// Listens to scroll events and triggers loading more stories when the user reaches the bottom.
  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 500) {
      final authProvider = context.read<AuthProvider>();
      final storyProvider = context.read<StoryProvider>();

      if (!storyProvider.state.isLoading &&
          storyProvider.hasMoreStories &&
          authProvider.user != null) {
        storyProvider.getStories(user: authProvider.user!).then((_) {
          // update markers after loading more stories
          if (isMapReady) {
            updateMarkersFromStories(storyProvider.stories);
          }
        });
      }
    }
  }

  /// Initializes the data by fetching the user information and stories.
  Future<void> initData() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.getUser();

    if (authProvider.user != null && context.mounted) {
      final storyProvider = context.read<StoryProvider>();
      await storyProvider.getStories(user: authProvider.user!);

      if (isMapReady) {
        updateMarkersFromStories(storyProvider.stories);
      }
    }
  }

  /// Refreshes the list of stories and updates the markers on the map.
  Future<void> refreshStories() async {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user != null) {
      final storyProvider = context.read<StoryProvider>();
      await storyProvider.refreshStories(user: authProvider.user!);

      if (isMapReady) {
        updateMarkersFromStories(storyProvider.stories);
      }
    }
  }

  /// Toggles the map type between normal and satellite.
  void toggleMapType() {
    selectedMapType = selectedMapType == MapType.normal
        ? MapType.satellite
        : MapType.normal;
  }

  /// Updates the markers on the map based on the provided list of stories.
  ///
  /// [stories] A list of stories to update markers for.
  void updateMarkersFromStories(List<ListStory> stories) {
    _mapService.updateMarkers(
      stories,
      onStoryTap: (position) {
        _mapService.animateCameraToPosition(position, 15);
      },
    );

    // show snackbar if only few markers
    final validLocationCount = _mapService.getValidLocationCount();
    final processedIds = _mapService.getProcessedIds();

    if (validLocationCount > 0 &&
        validLocationCount < processedIds.length / 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Only $validLocationCount out of ${processedIds.length} stories have location data",
          ),
          duration: Duration(seconds: 3),
          action: SnackBarAction(label: "OK", onPressed: () {}),
        ),
      );
    }
  }

  /// Called when the map is created, used to set the controller and update markers.
  void onMapCreated(GoogleMapController controller) {
    _mapService.setController(controller);
    isMapReady = true;

    // update markers when map ready
    final storyProvider = context.read<StoryProvider>();
    if (storyProvider.stories.isNotEmpty) {
      updateMarkersFromStories(storyProvider.stories);
    }
  }

  /// Handles tapping on a story and zooms the map to that location.
  void onStoryTap(ListStory story) {
    if (story.lat != null && story.lon != null && isMapReady) {
      final position = LatLng(story.lat!, story.lon!);
      _mapService.animateCameraToPosition(position, 15);
    }
  }

  /// Returns the current set of markers on the map.
  Set<Marker> get markers => _mapService.markers;
}
