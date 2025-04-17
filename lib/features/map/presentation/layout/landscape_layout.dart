import 'package:flutter/material.dart';
import 'package:storyzz/features/map/presentation/layout/vertical_split_view.dart';
import 'package:storyzz/features/map/presentation/widgets/map_view.dart';
import 'package:storyzz/features/map/presentation/widgets/story_list_view.dart';

/// A responsive layout for landscape orientation that displays
/// a list of stories on the left and a map on the right side.
///
/// This layout uses a horizontal [VerticalSplitView] where:
/// - The story list occupies 25% of the width.
/// - The map view fills the remaining 75%.
class LandscapeLayout extends StatelessWidget {
  const LandscapeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return VerticalSplitView(
      left: StoryListView(),
      right: MapView(),
      ratio: 0.25,
    );
  }
}
