import 'package:flutter/material.dart';
import 'package:storyzz/core/data/networking/models/story/list_story.dart';
import 'package:storyzz/core/utils/helper.dart';

/// A card widget that displays a single story's image, title, timestamp,
/// and description. Optionally shows a location pin if the story has
/// geographical data.
///
/// This card is typically used in a list or feed of user-generated stories
/// with support for image loading, error handling, and text overflow styling.
class MapStoryCard extends StatelessWidget {
  final ListStory story;
  final bool showLocationIcon;

  /// Creates a [MapStoryCard] to display story details.
  ///
  /// The [story] parameter is required, while [showLocationIcon]
  /// defaults to `false`
  const MapStoryCard({
    required this.story,
    this.showLocationIcon = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  story.photoUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Center(child: Icon(Icons.broken_image, size: 64)),
                    );
                  },
                ),
              ),
              if (showLocationIcon)
                // show (pin point) icon if there's location on the story
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: .circular(12),
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        story.name,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(fontWeight: .bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        getTimeDifference(context, story.createdAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  story.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
