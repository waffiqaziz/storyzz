import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:storyzz/core/data/networking/responses/stories_response.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/routes/my_route_delegate.dart';

class StoryCard extends StatelessWidget {
  final ListStory story;

  const StoryCard({super.key, required this.story});

  String _getTimeDifference(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('MMM d, yyyy · HH:mm');
    final formattedDate = dateFormat.format(story.createdAt);

    // calculate time difference
    final now = DateTime.now();
    final difference = now.difference(story.createdAt);
    String timeAgo;

    if (difference.inDays > 7) {
      timeAgo = formattedDate;
    } else if (difference.inDays > 0) {
      timeAgo =
          '${difference.inDays} ${difference.inDays == 1 ? localizations.d_ago_singular : localizations.d_ago_plural}';
    } else if (difference.inHours > 0) {
      timeAgo =
          '${difference.inHours} ${difference.inHours == 1 ? localizations.h_ago_singular : localizations.h_ago_plural}';
    } else if (difference.inMinutes > 0) {
      timeAgo =
          '${difference.inMinutes} ${difference.inMinutes == 1 ? localizations.m_ago_singular : localizations.m_ago_plural}';
    } else {
      timeAgo = localizations.just_now;
    }
    return timeAgo;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          context.read<MyRouteDelegate>().navigateToStoryDetail(story);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // story image with hero animation for smooth transitions
            Hero(
              tag: 'story-image-${story.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
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
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              story.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              _getTimeDifference(context),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
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
                    child: ReadMoreText(
                      story.description,
                      trimMode: TrimMode.Line,
                      trimLines: 2,
                      trimCollapsedText: localizations.show_more,
                      trimExpandedText: localizations.show_less,
                      style: TextStyle(fontSize: 14),
                      moreStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
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
