import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/features/detail/presentation/widgets/author_info.dart';
import 'package:storyzz/features/detail/presentation/widgets/detail_image.dart';
import 'package:storyzz/features/detail/presentation/widgets/location_section.dart';

/// A full-screen view that displays the details of a story including:
/// - Hero image (with transition animation)
/// - Author information (name, avatar, and timestamp)
/// - Full story description
/// - Map section (if location data is available)
///
/// Typically shown when a user selects a story from the list.
/// Its for mobile view.
///
/// Parameters:
/// - [story]: The story object to display
/// - [onBack]: Callback to handle back navigation
class StoryDetailScreen extends StatelessWidget {
  const StoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final story = context.read<AppProvider>().selectedStory!;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<AppProvider>().closeDetailScreen();
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            localizations.story_details,
            style: TextStyle(fontWeight: .bold),
          ),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<AppProvider>().closeDetailScreen();
              });
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              // Hero image
              Hero(
                tag: 'story-image-${story.id}',
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 200,
                    minWidth: double.infinity,
                  ),
                  child: DetailImage(photoUrl: story.photoUrl),
                ),
              ),

              // content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    // author info
                    AuthorInfo(),
                    SizedBox(height: 16),

                    // description
                    Text(story.description),
                    SizedBox(height: 24),

                    // location info if available
                    if (story.lat != null && story.lon != null)
                      LocationSection(
                        mapControlsEnabled: true,
                        mapKeyPrefix: 'detail',
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
