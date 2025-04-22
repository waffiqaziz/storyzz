import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/data/networking/states/story_load_state.dart';
import 'package:storyzz/core/provider/auth_provider.dart';
import 'package:storyzz/core/provider/story_provider.dart';
import 'package:storyzz/core/widgets/empty_story.dart';
import 'package:storyzz/core/widgets/story_error_view.dart';
import 'package:storyzz/features/home/presentation/widgets/home_story_card.dart';

/// A scrollable list view that displays stories in a card format with pull-to-refresh support.
///
/// This widget shows:
/// - A sliver app bar with refresh and logout actions
/// - A loading indicator while fetching stories
/// - An empty state if no stories are available
/// - A paginated list of [HomeStoryCard] widgets
///
/// Required parameters:
/// - [scrollController]: Controls scrolling and pagination
/// - [onLogout]: Callback to log out the user
class HomeStoriesListView extends StatelessWidget {
  final ScrollController scrollController;
  final VoidCallback onLogout;

  const HomeStoriesListView({
    super.key,
    required this.scrollController,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final storyProvider = context.read<StoryProvider>();

    return RefreshIndicator(
      onRefresh: () async {
        if (authProvider.user != null) {
          await storyProvider.refreshStories(user: authProvider.user!);
        }
      },
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          _buildAppBar(context),

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
            _buildStoryList(context),

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

  /// Refreshes the current user's stories list.
  ///
  /// Typically used in pull-to-refresh or retry flows.
  void _refreshStories(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user != null) {
      context.read<StoryProvider>().refreshStories(user: authProvider.user!);
    }
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      primary: true,
      forceElevated: false,
      title: Row(
        children: [
          Image.asset('assets/icon/icon.png', height: 30),
          const SizedBox(width: 8),
          const Text('Storyzz', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            _refreshStories(context);
          },
        ),
        const SizedBox(width: 4),
        IconButton(icon: const Icon(Icons.logout), onPressed: onLogout),
        const SizedBox(width: 8),
      ],
      elevation: 0,
    );
  }

  Widget _buildStoryList(BuildContext context) {
    final storyProvider = context.read<StoryProvider>();
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index >= storyProvider.stories.length) {
              return null;
            }

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 475),
                child: HomeStoryCard(story: storyProvider.stories[index]),
              ),
            );
          },
          childCount:
              storyProvider.stories.length +
              (storyProvider.state is StoryLoadStateLoading ? 1 : 0),
        ),
      ),
    );
  }
}
