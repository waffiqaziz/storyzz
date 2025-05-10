import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/core/providers/auth_provider.dart';
import 'package:storyzz/core/providers/story_provider.dart';
import 'package:storyzz/features/map/controller/map_story_controller.dart';
import 'package:storyzz/features/map/presentation/layout/landscape_layout.dart';
import 'package:storyzz/features/map/presentation/layout/potrait_layout.dart';
import 'package:storyzz/features/map/provider/map_provider.dart';

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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // initialize data
      context.read<MapProvider>().initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isLandscape = MediaQuery.of(context).size.width > 600;
    final mapProvider = context.watch<MapProvider>();

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
          if (context.watch<AppProvider>().selectedStory == null) ...[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: mapProvider.refreshStories,
              tooltip: localizations.refresh,
            ),
            SizedBox(width: 4),
            IconButton(
              icon: Icon(Icons.layers),
              onPressed: mapProvider.toggleMapType,
              tooltip: localizations.change_map_type,
            ),
            SizedBox(width: 8),
          ],
        ],
      ),
      body: Consumer2<AuthProvider, StoryProvider>(
        builder: (context, authProvider, storyProvider, child) {
          // Location warning snackbar
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mapProvider.shouldShowLocationWarning) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(mapProvider.locationWarningMessage),
                  duration: Duration(seconds: 3),
                  action: SnackBarAction(label: "OK", onPressed: () {}),
                ),
              );
            }
          });

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
          return isLandscape ? LandscapeLayout() : PortraitLayout();
        },
      ),
    );
  }
}
