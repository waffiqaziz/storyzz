import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/data/networking/states/story_load_state.dart';
import 'package:storyzz/core/design/widgets/empty_story.dart';
import 'package:storyzz/core/design/widgets/story_error_view.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/core/providers/auth_provider.dart';
import 'package:storyzz/core/providers/story_provider.dart';
import 'package:storyzz/core/utils/helper.dart';
import 'package:storyzz/features/home/presentation/widgets/home_story_card.dart';

/// A scrollable list view that displays stories in a card format with pull-to-refresh support.
///
/// This widget shows:
/// - A sliver app bar with refresh actions
/// - A loading indicator while fetching stories
/// - An empty state if no stories are available
/// - A paginated list of [HomeStoryCard] widgets
///
/// Required parameters:
/// - [scrollController]: Controls scrolling and pagination
class HomeStoriesListView extends StatefulWidget {
  final ScrollController scrollController;

  const HomeStoriesListView({super.key, required this.scrollController});

  @override
  State<HomeStoriesListView> createState() => _HomeStoriesListViewState();
}

class _HomeStoriesListViewState extends State<HomeStoriesListView> {
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  /// Handles scroll events to trigger pagination when nearing the bottom of the list.
  void _onScroll() {
    if (_isBottom) {
      final storyProvider = context.read<StoryProvider>();
      final authProvider = context.read<AuthProvider>();

      // Prevent multiple calls - check if not already loading
      if (authProvider.user != null &&
          storyProvider.hasMoreStories &&
          !storyProvider.state.isLoading) {
        storyProvider.getStories(user: authProvider.user!, refresh: false);
      }
    }
  }

  /// Checks if the scroll position is near the bottom of the list.
  bool get _isBottom {
    if (!widget.scrollController.hasClients) {
      return false; // return false if no clients
    }

    final maxScroll = widget.scrollController.position.maxScrollExtent;
    final currentScroll = widget.scrollController.offset;
    final isAtBottom = currentScroll >= (maxScroll * 0.9);

    return isAtBottom;
  }

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
        controller: widget.scrollController,
        slivers: [
          if (context.isMobile) _buildAppBar(context),

          // handle all story state
          if ((storyProvider.state.isLoading &&
                  storyProvider.stories.isEmpty) ||
              storyProvider.state.isInitial)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (storyProvider.state.isError)
            SliverFillRemaining(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: StoryErrorView(
                  errorMessage: storyProvider.state.errorMessage!,
                  onRetry: () => _refreshStories(context),
                ),
              ),
            )
          else if (storyProvider.stories.isEmpty)
            EmptyStory()
          else if (storyProvider.state.isLoaded)
            _buildStoryList(context),

          // Loading indicator at bottom for pagination
          if (storyProvider.isLoadingMore)
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
          Image.asset('assets/icons/icon.png', height: 30),
          const SizedBox(width: 8),
          const Text('Storyzz', style: TextStyle(fontWeight: .bold)),
        ],
      ),
      actions: [
        if (context.watch<AppProvider>().selectedStory == null) ...[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _refreshStories(context);
            },
          ),
          const SizedBox(width: 4),
        ],
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
