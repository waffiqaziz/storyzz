import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/design/widgets/auth_error_view.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/core/providers/auth_provider.dart';
import 'package:storyzz/core/providers/story_provider.dart';
import 'package:storyzz/features/home/presentation/widgets/home_story_list_view.dart';

/// Main screen shown after user logs in.
///
/// Displays a scrollable list of stories and handles:
/// - Initial data loading (user + stories)
/// - Infinite scrolling (load more stories near bottom)
/// - Error handling and logout flow
///
/// - [onLogout]: Callback triggered after a successful logout.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// State logic for [HomeScreen].
///
/// Manages story fetching, scroll-based pagination, error views,
/// and logout feedback.
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

  /// Logs out the user and opens a confirmation dialog.
  void _logOut(AuthProvider authProvider) {
    context.read<AppProvider>().openDialogLogOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<AuthProvider, StoryProvider>(
        builder: (context, authProvider, storyProvider, child) {
          if (authProvider.errorMessage.isNotEmpty) {
            return AuthErrorView(
              errorMessage: authProvider.errorMessage,
              onLogout: () => _logOut(authProvider),
            );
          }

          // show list of story
          return HomeStoriesListView(
            scrollController: _scrollController,
            onLogout: () => _logOut(authProvider),
          );
        },
      ),
    );
  }
}
