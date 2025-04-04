import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/provider/auth_provider.dart';
import 'package:storyzz/core/provider/story_provider.dart';
import 'package:storyzz/ui/home/story_card.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const HomeScreen({super.key, required this.onLogout});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initData();

    // scroll listener for pagination
    _scrollController.addListener(_scrollListener);
  }

  void _initData() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.getUser();

    if (authProvider.user != null) {
      context.read<StoryProvider>().getStories(user: authProvider.user!);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      final authProvider = context.read<AuthProvider>();
      final storyProvider = context.read<StoryProvider>();

      if (!storyProvider.isLoading &&
          storyProvider.hasMoreStories &&
          authProvider.user != null) {
        storyProvider.getStories(user: authProvider.user!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.auto_stories),
            SizedBox(width: 8),
            Text('Storyzz', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              final authProvider = context.read<AuthProvider>();
              if (authProvider.user != null) {
                context.read<StoryProvider>().refreshStories(
                  user: authProvider.user!,
                );
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logOut(authProvider),
          ),
        ],
        elevation: 0,
      ),
      body: Consumer2<AuthProvider, StoryProvider>(
        builder: (context, authProvider, storyProvider, child) {
          // loading state
          if (authProvider.isLoadingLogin) {
            return Center(child: CircularProgressIndicator());
          }

          // error user state
          if (authProvider.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Error: ${authProvider.errorMessage}',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: widget.onLogout,
                    child: Text('LOGOUT'),
                  ),
                ],
              ),
            );
          }

          // user not found
          if (authProvider.user == null) {
            return Center(child: Text('User data not available'));
          }

          // error story state
          if (storyProvider.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 64,
                    color: Colors.orange,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Error loading stories: ${storyProvider.errorMessage}',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (authProvider.user != null) {
                        storyProvider.refreshStories(user: authProvider.user!);
                      }
                    },
                    child: Text('RETRY'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              if (authProvider.user != null) {
                await storyProvider.refreshStories(user: authProvider.user!);
              }
              return;
            },
            child:
                storyProvider.stories.isEmpty && !storyProvider.isLoading
                    ? _buildEmptyState()
                    : _buildStoryList(storyProvider),
          );
        },
      ),

      // add feature
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add story screen
          // Navigator.push(context, MaterialPageRoute(builder: (context) => AddStoryScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _logOut(AuthProvider authProvider) async {
    await authProvider.logout(); // handle via router delegate
    widget.onLogout();
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Logout success")));
  }

  Widget _buildEmptyState() {
    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.2),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_stories, size: 80, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No stories available',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Pull down to refresh or tap + to add a new story',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStoryList(StoryProvider storyProvider) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(16),
      itemCount:
          storyProvider.stories.length + (storyProvider.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == storyProvider.stories.length) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final story = storyProvider.stories[index];
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: StoryCard(story: story),
          ),
        );
      },
    );
  }
}
