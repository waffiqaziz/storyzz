import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/data/networking/responses/list_story.dart';
import 'package:storyzz/core/provider/auth_provider.dart';
import 'package:storyzz/core/provider/story_provider.dart';
import 'package:storyzz/core/routes/my_route_delegate.dart';
import 'package:storyzz/core/widgets/empty_story.dart';
import 'package:storyzz/core/widgets/story_error_view.dart';
import 'package:storyzz/features/map/presentation/widgets/map_story_card.dart';
import 'package:storyzz/features/map/provider/map_provider.dart';

/// A widget that displays a list of stories with support for
/// pull-to-refresh, loading states, error handling, and empty states.
///
/// Requires
/// - onStoryTap: handle and manage tap event via callback if needed
class MapStoryListView extends StatelessWidget {
  final Function(ListStory)? onStoryTap;

  const MapStoryListView({super.key, this.onStoryTap});

  void _refreshStories(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user != null) {
      context.read<StoryProvider>().refreshStories(user: authProvider.user!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapProvider = context.watch<MapProvider>();
    final storyProvider = context.watch<StoryProvider>();

    // error state view
    if (storyProvider.state.isError) {
      return Center(
        child: StoryErrorView(
          errorMessage: storyProvider.state.errorMessage!,
          onRetry: () => _refreshStories(context),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        mapProvider.refreshStories();
      },
      child: CustomScrollView(
        controller: mapProvider.scrollController,
        slivers: [
          // handle all story state
          if (storyProvider.state.isLoading && storyProvider.stories.isEmpty ||
              storyProvider.state.isInitial)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (storyProvider.state.isError)
            SliverFillRemaining(
              child: StoryErrorView(
                errorMessage: storyProvider.state.errorMessage!,
                onRetry: () => _refreshStories(context),
              ),
            )
          else if (storyProvider.stories.isEmpty)
            EmptyStory()
          else if (storyProvider.state.isLoaded)
            _buildSliverStoryList(context),

          // Loading indicator at bottom for pagination
          if (storyProvider.state.isLoading && storyProvider.stories.isNotEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }

  /// Builds a sliver list of stories with padding.
  Widget _buildSliverStoryList(BuildContext context) {
    final storyProvider = context.watch<StoryProvider>();

    return SliverPadding(
      padding: EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= storyProvider.stories.length) {
              return null;
            }

            final story = storyProvider.stories[index];
            return GestureDetector(
              onTap: () {
                // use the callback if provided,
                // on this case, it used on potrait layout
                if (onStoryTap != null) {
                  onStoryTap!(story); // used via callback
                } else {
                  context.read<MapProvider>().onStoryTap(story);
                }
              },
              onDoubleTap:
                  () => context.read<MyRouteDelegate>().navigateToStoryDetail(
                    story,
                  ),
              child: Card(
                margin: EdgeInsets.only(bottom: 16),
                child: MapStoryCard(
                  story: story,
                  showLocationIcon: story.lat != null && story.lon != null,
                ),
              ),
            );
          },
          childCount:
              storyProvider.stories.length +
              (storyProvider.state.isLoading ? 1 : 0),
        ),
      ),
    );
  }
}
