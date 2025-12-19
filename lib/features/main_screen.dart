import 'package:amazing_icons/amazing_icons.dart';
import 'package:flutter/material.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/utils/constants.dart';
import 'package:storyzz/core/utils/tab_switcher.dart';
import 'package:storyzz/features/home/presentation/screen/home_screen.dart';
import 'package:storyzz/features/map/presentations/screens/map_screen.dart';
import 'package:storyzz/features/settings/presentation/screen/settings_screen.dart';
import 'package:storyzz/features/upload_story/presentation/screens/upload_story_screen.dart';

/// A screen serves as main navigation hub for the app.
///
/// The [MainScreen] provides a responsive layout that adapts to different screen sizes.
/// - For mobile devices, it displays a [NavigationBar] at the bottom.
/// - For larger devices like tablets, it shows a collapsed [NavigationRail] on the side.
/// - For wide screen like desktop, it shows a [NavigationDrawer] on the side.
///
/// It allows the user to switch between various screens:
/// - [HomeScreen]
/// - [MapStoryScreen]
/// - [UploadStoryScreen]
/// - [SettingsScreen]
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
  bool _isMobile = true;
  bool _isWide = false;
  double _previousWidth = 0;

  @override
  Widget build(BuildContext context) {
    _updateLayoutMode(context);
    final content = _buildContent();

    return Scaffold(
      body: _buildBody(content),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  void _updateLayoutMode(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if ((screenWidth - _previousWidth).abs() <= 5) return;

    setState(() {
      _isMobile = screenWidth < mobileBreakpoint;
      _isWide = screenWidth >= tabletBreakpoint;
      _previousWidth = screenWidth;
    });
  }

  Widget _buildContent() {
    return AnimatedTabSwitcher(
      index: widget.currentIndex,
      children: const [
        HomeScreen(),
        MapStoryScreen(),
        UploadStoryScreen(),
        SettingsScreen(),
      ],
    );
  }

  Widget _buildBody(Widget content) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      child: _isMobile ? content : _buildWideLayout(content),
    );
  }

  Widget _buildWideLayout(Widget content) {
    return Row(
      key: ValueKey('desktop_layout_${_isWide ? "wide" : "medium"}'),
      children: [
        _isWide ? _buildNavigationDrawer() : _buildNavigationRail(),
        if (!_isWide) const VerticalDivider(width: 1),
        Expanded(child: content),
      ],
    );
  }

  Widget _buildNavigationDrawer() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.20,
      child: NavigationDrawer(
        header: _buildDrawerHeader(),
        selectedIndex: widget.currentIndex,
        onDestinationSelected: widget.onTabChanged,
        surfaceTintColor: null,
        children: _buildDrawerDestinations(),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Image.asset('assets/icon/icon.png', height: 30),
          const SizedBox(width: 8),
          Text(
            'Storyzz',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  List<NavigationDrawerDestination> _buildDrawerDestinations() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return [
      _createDrawerDestination(
        icon: AmazingIconTwotone.home,
        selectedIcon: AmazingIconFilled.home,
        label: l10n.home,
        theme: theme,
      ),
      _createDrawerDestination(
        icon: AmazingIconTwotone.map1,
        selectedIcon: AmazingIconFilled.map1,
        label: l10n.map,
        theme: theme,
      ),
      _createDrawerDestination(
        icon: AmazingIconTwotone.addCircle,
        selectedIcon: AmazingIconFilled.addCircle,
        label: l10n.upload,
        theme: theme,
      ),
      _createDrawerDestination(
        icon: AmazingIconTwotone.setting2,
        selectedIcon: AmazingIconFilled.setting2,
        label: l10n.settings,
        theme: theme,
      ),
    ];
  }

  NavigationDrawerDestination _createDrawerDestination({
    required Function icon,
    required IconData selectedIcon,
    required String label,
    required ThemeData theme,
  }) {
    return NavigationDrawerDestination(
      icon: icon(
        size: 24,
        color: theme.colorScheme.secondaryFixedDim,
        opacity: 0.6,
      ),
      selectedIcon: Icon(selectedIcon),
      label: Text(label),
    );
  }

  Widget _buildNavigationRail() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return NavigationRail(
      selectedIndex: widget.currentIndex,
      onDestinationSelected: widget.onTabChanged,
      extended: false,
      labelType: NavigationRailLabelType.all,
      destinations: [
        _createRailDestination(
          icon: AmazingIconTwotone.home,
          selectedIcon: AmazingIconFilled.home,
          label: l10n.home,
          theme: theme,
        ),
        _createRailDestination(
          icon: AmazingIconTwotone.map1,
          selectedIcon: AmazingIconFilled.map1,
          label: l10n.map,
          theme: theme,
        ),
        _createRailDestination(
          icon: AmazingIconTwotone.addCircle,
          selectedIcon: AmazingIconFilled.addCircle,
          label: l10n.upload,
          theme: theme,
        ),
        _createRailDestination(
          icon: AmazingIconTwotone.setting2,
          selectedIcon: AmazingIconFilled.setting2,
          label: l10n.settings,
          theme: theme,
        ),
      ],
    );
  }

  NavigationRailDestination _createRailDestination({
    required Function icon,
    required IconData selectedIcon,
    required String label,
    required ThemeData theme,
  }) {
    return NavigationRailDestination(
      icon: icon(
        size: 24,
        color: theme.colorScheme.secondaryFixedDim,
        opacity: 0.6,
      ),
      selectedIcon: Icon(selectedIcon),
      label: Text(label),
    );
  }

  Widget _buildBottomNavigationBar() {
    if (!_isMobile) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(animation),
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: NavigationBar(
        key: const ValueKey('bottom_nav'),
        selectedIndex: widget.currentIndex,
        onDestinationSelected: widget.onTabChanged,
        destinations: [
          NavigationDestination(
            icon: const Icon(AmazingIconFilled.home),
            label: l10n.home,
            tooltip: l10n.home,
          ),
          NavigationDestination(
            icon: const Icon(AmazingIconFilled.map1),
            label: l10n.map,
            tooltip: l10n.map,
          ),
          NavigationDestination(
            icon: const Icon(AmazingIconFilled.addCircle),
            label: l10n.upload,
            tooltip: l10n.upload,
          ),
          NavigationDestination(
            icon: const Icon(AmazingIconFilled.setting2),
            label: l10n.settings,
            tooltip: l10n.settings,
          ),
        ],
      ),
    );
  }
}
