import 'package:flutter/material.dart';
import 'package:storyzz/ui/home/home_screen.dart';
import 'package:storyzz/ui/home/settings_screen.dart';

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

  // flag to handle width platform
  static const int tabletBreakpoint = 600;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < tabletBreakpoint;

    Widget content = IndexedStack(
      index: currentIndex,
      children: [
        HomeScreen(onLogout: onLogout),
        SettingsScreen(onLogout: onLogout),
      ],
    );

    return Scaffold(
      body:
          isMobile
              ? content
              : Row(
                children: [
                  NavigationRail(
                    selectedIndex: currentIndex,
                    onDestinationSelected: onTabChanged,
                    labelType: NavigationRailLabelType.all,
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.home_filled),
                        label: Text("Home"),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings),
                        label: Text("Settings"),
                      ),
                    ],
                  ),
                  const VerticalDivider(
                    width: 1,
                  ), // divider between nav and the content
                  Expanded(child: content),
                ],
              ),
      bottomNavigationBar:
          isMobile
              ? NavigationBar(
                selectedIndex: currentIndex,
                onDestinationSelected: onTabChanged,
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home_filled),
                    label: "Home",
                    tooltip: "Home",
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.settings),
                    label: "Settings",
                    tooltip: "Settings",
                  ),
                ],
              )
              : null,
    );
  }
}
