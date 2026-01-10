import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/auth_provider.dart';
import 'package:storyzz/core/utils/constants.dart';
import 'package:storyzz/features/map/presentations/controllers/map_story_controller.dart';
import 'package:storyzz/features/map/presentations/layouts/landscape_layout.dart';
import 'package:storyzz/features/map/presentations/layouts/potrait_layout.dart';
import 'package:storyzz/features/map/presentations/providers/map_provider.dart';

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
    final isLandscape = MediaQuery.of(context).size.width > mobileBreakpoint;
    final mapProvider = context.watch<MapProvider>();

    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
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
                mainAxisAlignment: .center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    authProvider.errorMessage,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: .center,
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
