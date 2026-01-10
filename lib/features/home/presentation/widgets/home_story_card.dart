import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:storyzz/core/data/networking/models/story/list_story.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/core/utils/helper.dart';

/// A tappable card displaying a preview of a story.
///
/// Includes:
/// - Hero image with loading/error fallback
/// - Author avatar and name
/// - Story timestamp
/// - Location indicator (if available)
/// - Truncated description with "show more/less"
///
/// Navigates to the story detail view when tapped.
///
/// - [story]: The `ListStory` object to render in the card.
class HomeStoryCard extends StatelessWidget {
  final ListStory story;

  const HomeStoryCard({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: .circular(12)),
      child: InkWell(
        onTap: () {
          context.read<AppProvider>().openDetailScreen(story);
        },
        borderRadius: .circular(12),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            // story image with hero animation for smooth transitions
            Hero(
              tag: 'story-image-${story.id}',
              child: ClipRRect(
                borderRadius: .vertical(top: Radius.circular(12)),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        // default height before image loads
                        minHeight: 500,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 400,
                          minWidth: double.infinity,
                        ),
                        child: Image.network(
                          story.photoUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.grey[200],
                              child: Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Colors.grey[300],
                                child: Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // story content
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  // author and time
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          story.name.isNotEmpty
                              ? story.name[0].toUpperCase()
                              : '?',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              story.name,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: .bold),
                            ),
                            Text(
                              getTimeDifference(context, story.createdAt),
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      if (story.lat != null && story.lon != null)
                        Tooltip(
                          message: localizations.location_available,
                          child: Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 18,
                          ),
                        ),
                    ],
                  ),

                  // description
                  Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      alignment: .topCenter,
                      child: ReadMoreText(
                        story.description,
                        trimMode: TrimMode.Line,
                        trimLines: 2,
                        trimCollapsedText: localizations.show_more,
                        trimExpandedText: localizations.show_less,
                        moreStyle: TextStyle(fontWeight: .bold),
                        lessStyle: TextStyle(fontWeight: .bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
