import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/provider/auth_provider.dart';
import 'package:storyzz/core/provider/story_provider.dart';
import 'package:storyzz/features/map/controller/map_story_controller.dart';
import 'package:storyzz/features/map/presentation/layout/landscape_layout.dart';
import 'package:storyzz/features/map/presentation/layout/potrait_layout.dart';

/// A screen that displays stories on a map with either portrait or landscape layout,
/// depending on the screen width.
///
/// This screen handles:
/// - Initializing the [MapStoryController].
/// - Responding to authentication and story provider state.
/// - Switching between portrait and landscape layouts.
/// - Displaying errors, loading states, and user data validation.
class MapStoryScreen extends StatefulWidget {
  const MapStoryScreen({super.key});

  @override
  State<MapStoryScreen> createState() => _MapStoryScreenState();
}

class _MapStoryScreenState extends State<MapStoryScreen> {
  late MapStoryController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MapStoryController(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.initData();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    // determine if layout is landscape based on screen width
    final isLandscape = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/icon/icon.png', height: 30),
            SizedBox(width: 8),
            Text('Storyzz Map', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _controller.refreshStories,
            tooltip: localizations.refresh,
          ),
          SizedBox(width: 4),
          IconButton(
            icon: Icon(Icons.layers),
            onPressed: _controller.toggleMapType,
            tooltip: localizations.change_map_type,
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Consumer2<AuthProvider, StoryProvider>(
        builder: (context, authProvider, storyProvider, child) {
          // Loading state
          if (authProvider.isLoadingLogin) {
            return Center(child: CircularProgressIndicator());
          }

          // Error user state
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
                ],
              ),
            );
          }

          // User not found
          if (authProvider.user == null) {
            return Center(child: Text(localizations.no_user_data));
          }

          // Build layout based on orientation
          return isLandscape
              ? LandscapeLayout(controller: _controller)
              : PortraitLayout(controller: _controller);
        },
      ),
    );
  }
}
