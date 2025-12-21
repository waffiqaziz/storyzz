import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/providers/auth_provider.dart';
import 'package:storyzz/core/providers/story_provider.dart';
import 'package:storyzz/features/home/presentation/widgets/home_story_list_view.dart';

/// Main screen shown after user logs in.
///
/// Displays a scrollable list of stories and handles:
/// - Initial data loading (user + stories)
/// - Infinite scrolling (load more stories near bottom)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// State logic for [HomeScreen].
///
/// Manages story fetching, scroll-based pagination
class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initData();
    });
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  /// Loads current user and stories on initial frame render.
  ///
  /// Ensures [AuthProvider.getUser] is called, then triggers story load
  /// if user is available.
  void _initData() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.getUser();

    if (authProvider.user != null && mounted) {
      _loadStories();
    }
  }

  /// Fetches stories for the current user.
  ///
  /// Called during initial load and when reaching bottom of scroll.
  void _loadStories() {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user != null) {
      context.read<StoryProvider>().getStories(user: authProvider.user!);
    }
  }

  /// Listens for scroll events and loads more stories near bottom.
  ///
  /// Triggers a paginated fetch if not already loading and more
  /// stories are available.
  void _scrollListener() {
    if (_isNearBottomOfScroll()) {
      final authProvider = context.read<AuthProvider>();
      final storyProvider = context.read<StoryProvider>();

      if (!storyProvider.state.isLoading &&
          storyProvider.hasMoreStories &&
          authProvider.user != null) {
        storyProvider.getStories(user: authProvider.user!);
      }
    }
  }

  /// Returns true if scroll is within 500 pixels of the bottom.
  bool _isNearBottomOfScroll() {
    return _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<StoryProvider>(
        builder: (context, storyProvider, child) {
          return HomeStoriesListView(scrollController: _scrollController);
        },
      ),
    );
  }
}
