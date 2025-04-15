import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/provider/story_provider.dart';
import 'package:storyzz/features/map/controller/map_story_controller.dart';
import 'package:storyzz/features/map/presentation/layout/horizontal_split_view.dart';
import 'package:storyzz/features/map/presentation/widgets/map_view.dart';
import 'package:storyzz/features/map/presentation/widgets/story_list_view.dart';

/// A responsive layout for portrait orientation that displays
/// a map view on the top and a scrollable list of stories below.
///
/// This layout uses a vertical [Column] where:
/// - The map takes up 40% of the screen height.
/// - The story list occupies the remaining 60%.
class PortraitLayout extends StatefulWidget {
  final MapStoryController controller;

  const PortraitLayout({super.key, required this.controller});

  @override
  State<PortraitLayout> createState() => _PortraitLayoutState();
}

class _PortraitLayoutState extends State<PortraitLayout> {
  final GlobalKey<HorizontalSplitViewState> _splitViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final storyProvider = context.watch<StoryProvider>();
    final localizations = AppLocalizations.of(context)!;

    return HorizontalSplitView(
      key: _splitViewKey,
      top: MapView(controller: widget.controller),
      bottom: StoryListView(
        controller: widget.controller,
        storyProvider: storyProvider,
        localizations: localizations,
        onStoryTap: (story) {
          // call the controller's onStoryTap method
          widget.controller.onStoryTap(story);

          // expand the top view
          _splitViewKey.currentState?.expandTopView();
        },
      ),
      totalHeight: MediaQuery.of(context).size.height,
      ratio: 0.30,
    );
  }
}
