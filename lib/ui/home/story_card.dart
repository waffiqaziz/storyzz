import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:storyzz/core/data/networking/responses/stories_response.dart';

class StoryCard extends StatelessWidget {
  final ListStory story;

  const StoryCard({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy · HH:mm');
    final formattedDate = dateFormat.format(story.createdAt);

    // Calculate time difference
    final now = DateTime.now();
    final difference = now.difference(story.createdAt);
    String timeAgo;

    if (difference.inDays > 7) {
      timeAgo = formattedDate;
    } else if (difference.inDays > 0) {
      timeAgo = '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      timeAgo = '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      timeAgo = '${difference.inMinutes}m ago';
    } else {
      timeAgo = 'Just now';
    }

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Navigate to story detail
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => StoryDetailScreen(story: story)
          //   )
          // );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Story image with hero animation for smooth transitions
            Hero(
              tag: 'story-image-${story.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    story.photoUrl,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          child: Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
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
                  ),
                ),
              ),
            ),

            // Story content
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Author and time
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
                              timeAgo,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (story.lat != 0 && story.lon != 0)
                        Tooltip(
                          message: 'Location available',
                          child: Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 18,
                          ),
                        ),
                    ],
                  ),

                  // Description
                  Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Text(
                      story.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14),
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
