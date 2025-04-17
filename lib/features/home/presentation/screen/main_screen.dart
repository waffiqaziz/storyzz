import 'package:flutter/material.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/features/home/presentation/screen/home_screen.dart';
import 'package:storyzz/features/map/presentation/screen/map_screen.dart';
import 'package:storyzz/features/settings/presentation/screen/settings_screen.dart';
import 'package:storyzz/features/upload_story/presentation/screen/upload_story_screen.dart';

/// A screen serves as main navigation hub for the app.
///
/// The [MainScreen] provides a responsive layout that adapts to different screen sizes.
/// - For mobile devices, it displays a [NavigationBar] at the bottom.
/// - For larger devices (like tablets), it shows a [NavigationRail] on the side.
///
/// It allows the user to switch between various screens:
/// - [HomeScreen]
/// - [MapStoryScreen]
/// - [UploadStoryScreen]
/// - [SettingsScreen]
///
/// Example usage:
/// ```dart
/// MainScreen(
///   onLogout: () { /* handle logout */ },
///   currentIndex: 0,
///   onTabChanged: (index) { /* handle tab change */ },
/// );
/// ```
class MainScreen extends StatelessWidget {
  final VoidCallback onLogout;
  final int currentIndex;
  final Function(int) onTabChanged;

  const MainScreen({
    super.key,
    required this.onLogout,
    required this.currentIndex,
    required this.onTabChanged,
  });

  /// Breakpoint for determining wide vs mobile layout.
  static const int tabletBreakpoint = 600;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < tabletBreakpoint;

    // the content to be displayed based on the selected tab index.
    Widget content = IndexedStack(
      index: currentIndex,
      children: [
        HomeScreen(onLogout: onLogout),
        MapStoryScreen(),
        UploadStoryScreen(),
        SettingsScreen(onLogout: onLogout),
      ],
    );

    return Scaffold(
      // use a mobile or tablet layout depending on the screen width.
      body:
          isMobile
              ? content
              : Row(
                children: [
                  // navigation rail for tablets and larger devices.
                  NavigationRail(
                    selectedIndex: currentIndex,
                    onDestinationSelected: onTabChanged,
                    labelType: NavigationRailLabelType.all,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home_filled),
                        label: Text(AppLocalizations.of(context)!.home),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.map_rounded),
                        label: Text(AppLocalizations.of(context)!.map),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.add_box_outlined),
                        label: Text(AppLocalizations.of(context)!.upload),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings),
                        label: Text(AppLocalizations.of(context)!.settings),
                      ),
                    ],
                  ),
                  const VerticalDivider(
                    width: 1,
                  ), // divider between nav and the content
                  Expanded(child: content),
                ],
              ),
      // bottom navigation bar for mobile devices.
      bottomNavigationBar:
          isMobile
              ? NavigationBar(
                selectedIndex: currentIndex,
                onDestinationSelected: onTabChanged,
                destinations: [
                  NavigationDestination(
                    icon: Icon(Icons.home_filled),
                    label: AppLocalizations.of(context)!.home,
                    tooltip: AppLocalizations.of(context)!.home,
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.map_rounded),
                    label: AppLocalizations.of(context)!.map,
                    tooltip: AppLocalizations.of(context)!.map,
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.add_box_outlined),
                    label: AppLocalizations.of(context)!.upload,
                    tooltip: AppLocalizations.of(context)!.upload,
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.settings),
                    label: AppLocalizations.of(context)!.settings,
                    tooltip: AppLocalizations.of(context)!.settings,
                  ),
                ],
              )
              : null,
    );
  }
}
