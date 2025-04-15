import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/provider/story_provider.dart';
import 'package:storyzz/features/map/presentation/layout/vertical_split_view.dart';
import 'package:storyzz/features/map/controller/map_story_controller.dart';
import 'package:storyzz/features/map/presentation/widgets/map_view.dart';
import 'package:storyzz/features/map/presentation/widgets/story_list_view.dart';

/// A responsive layout for landscape orientation that displays
/// a list of stories on the left and a map on the right side.
///
/// This layout uses a horizontal [VerticalSplitView] where:
/// - The story list occupies 25% of the width.
/// - The map view fills the remaining 75%.
class LandscapeLayout extends StatelessWidget {
  final MapStoryController controller;

  const LandscapeLayout({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final storyProvider = context.watch<StoryProvider>();
    final localizations = AppLocalizations.of(context)!;

    return VerticalSplitView(
      left: StoryListView(
        controller: controller,
        storyProvider: storyProvider,
        localizations: localizations,
      ),
      right: MapView(controller: controller),
      ratio: 0.25,
    );
  }
}
