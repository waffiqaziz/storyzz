import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/provider/auth_provider.dart';
import 'package:storyzz/core/provider/story_provider.dart';
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
/// - [storyProvider]: Provides story data and loading states
/// - [onRefresh]: Callback to trigger a manual refresh
/// - [onLogout]: Callback to log out the user
class StoriesListView extends StatelessWidget {
  final ScrollController scrollController;
  final StoryProvider storyProvider;
  final VoidCallback onRefresh;
  final VoidCallback onLogout;

  const StoriesListView({
    super.key,
    required this.scrollController,
    required this.storyProvider,
    required this.onRefresh,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();

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

          if (storyProvider.isLoading && storyProvider.stories.isEmpty)
            const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),

          if (storyProvider.stories.isEmpty && !storyProvider.isLoading)
            _buildEmptyState(context),

          if (storyProvider.stories.isNotEmpty) _buildStoryList(),

          if (storyProvider.isLoading && storyProvider.stories.isNotEmpty)
            const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
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
        IconButton(icon: const Icon(Icons.refresh), onPressed: onRefresh),
        const SizedBox(width: 4),
        IconButton(icon: const Icon(Icons.logout), onPressed: onLogout),
        const SizedBox(width: 8),
      ],
      elevation: 0,
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_stories, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.no_stories,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                AppLocalizations.of(context)!.pull_to_refresh,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryList() {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == storyProvider.stories.length &&
                storyProvider.isLoading) {
              return const Center(
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
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 475),
                child: HomeStoryCard(story: story),
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
