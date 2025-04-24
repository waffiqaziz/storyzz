import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/features/map/presentation/layout/horizontal_split_view.dart';
import 'package:storyzz/features/map/presentation/widgets/map_story_list_view.dart';
import 'package:storyzz/features/map/presentation/widgets/map_view.dart';
import 'package:storyzz/features/map/provider/map_provider.dart';

/// A responsive layout for portrait orientation that displays
/// a map view on the top and a scrollable list of stories below.
///
/// This layout uses a vertical [Column] where:
/// - The map takes up 40% of the screen height.
/// - The story list occupies the remaining 60%.
class PortraitLayout extends StatefulWidget {
  const PortraitLayout({super.key});

  @override
  State<PortraitLayout> createState() => _PortraitLayoutState();
}

class _PortraitLayoutState extends State<PortraitLayout> {
  final GlobalKey<HorizontalSplitViewState> _splitViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return HorizontalSplitView(
      key: _splitViewKey,
      top: MapView(),
      bottom: MapStoryListView(
        onStoryTap: (story) {
          context.read<MapProvider>().onStoryTap(story);

          // expand the top view
          _splitViewKey.currentState?.expandTopView();
        },
      ),
      totalHeight: MediaQuery.of(context).size.height,
      ratio: 0.30,
    );
  }
}
