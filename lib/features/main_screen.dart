import 'package:flutter/material.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/utils/constants.dart';
import 'package:storyzz/core/utils/tab_switcher';
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
class MainScreen extends StatefulWidget {
  final Widget child;
  final int currentIndex;
  final Function(int) onTabChanged;
  final VoidCallback onLogout;
  final Object? routeExtra;

  const MainScreen({
    super.key,
    required this.child,
    required this.currentIndex,
    required this.onTabChanged,
    required this.onLogout,
    this.routeExtra,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // We'll use this to prevent layout thrashing during transitions
  bool _isMobile = true;
  double _previousWidth = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // only update layout mode when width changes significantly to avoid flickering
    if ((screenWidth - _previousWidth).abs() > 5) {
      _isMobile = screenWidth < tabletBreakpoint;
      _previousWidth = screenWidth;
    }

    final content = AnimatedTabSwitcher(
      index: widget.currentIndex,
      children: [
        const HomeScreen(),
        const MapStoryScreen(),
        const UploadStoryScreen(),
        const SettingsScreen(),
      ],
    );

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 800),
        child: _isMobile
            ? content
            : Row(
                key: const ValueKey('desktop_layout'),
                children: [
                  NavigationRail(
                    selectedIndex: widget.currentIndex,
                    onDestinationSelected: widget.onTabChanged,
                    labelType: NavigationRailLabelType.all,
                    destinations: [
                      NavigationRailDestination(
                        icon: const Icon(Icons.home_filled),
                        label: Text(AppLocalizations.of(context)!.home),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(Icons.map_rounded),
                        label: Text(AppLocalizations.of(context)!.map),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(Icons.add_box_outlined),
                        label: Text(AppLocalizations.of(context)!.upload),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(Icons.settings_rounded),
                        label: Text(AppLocalizations.of(context)!.settings),
                      ),
                    ],
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: content),
                ],
              ),
      ),
      bottomNavigationBar: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: _isMobile
            ? NavigationBar(
                key: const ValueKey('bottom_nav'),
                selectedIndex: widget.currentIndex,
                onDestinationSelected: widget.onTabChanged,
                destinations: [
                  NavigationDestination(
                    icon: const Icon(Icons.home_filled),
                    label: AppLocalizations.of(context)!.home,
                    tooltip: AppLocalizations.of(context)!.home,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.map_rounded),
                    label: AppLocalizations.of(context)!.map,
                    tooltip: AppLocalizations.of(context)!.map,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.add_box_outlined),
                    label: AppLocalizations.of(context)!.upload,
                    tooltip: AppLocalizations.of(context)!.upload,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.settings_rounded),
                    label: AppLocalizations.of(context)!.settings,
                    tooltip: AppLocalizations.of(context)!.settings,
                  ),
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
