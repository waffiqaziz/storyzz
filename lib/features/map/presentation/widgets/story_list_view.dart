import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/data/networking/responses/list_story.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/provider/story_provider.dart';
import 'package:storyzz/core/routes/my_route_delegate.dart';
import 'package:storyzz/features/map/presentation/widgets/empty_state_view.dart';
import 'package:storyzz/features/map/presentation/widgets/map_story_card.dart';
import 'package:storyzz/features/map/provider/map_provider.dart';

/// A widget that displays a list of stories with support for
/// pull-to-refresh, loading states, error handling, and empty states.
///
/// Requires
/// - onStoryTap: handle and manage tap event via callback if needed
class StoryListView extends StatelessWidget {
  final Function(ListStory)? onStoryTap;

  const StoryListView({super.key, this.onStoryTap});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final mapProvider = context.watch<MapProvider>();
    final storyProvider = context.watch<StoryProvider>();

    // error state view
    if (storyProvider.errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning_amber_rounded, size: 64, color: Colors.orange),
            SizedBox(height: 16),
            Text(
              '${localizations.error_loading_stories} ${storyProvider.errorMessage}',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => mapProvider.refreshStories(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(localizations.retry),
              ),
            ),
          ],
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
          // show loading indicator if initial load is in progress
          if (storyProvider.isLoading && storyProvider.stories.isEmpty)
            SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),

          // show empty state if no stories found after loading
          if (storyProvider.stories.isEmpty && !storyProvider.isLoading)
            SliverToBoxAdapter(child: EmptyState(localizations: localizations)),

          // display list of stories
          if (storyProvider.stories.isNotEmpty) _buildSliverStoryList(context),

          // show loading indicator at the bottom when loading more
          if (storyProvider.isLoading && storyProvider.stories.isNotEmpty)
            SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
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
            if (index == storyProvider.stories.length &&
                storyProvider.isLoading) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              );
            }

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
              storyProvider.stories.length + (storyProvider.isLoading ? 1 : 0),
        ),
      ),
    );
  }
}
