import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';

import '../../core/data/networking/responses/stories_response.dart'
    show ListStory;

class StoryDetailScreen extends StatelessWidget {
  final ListStory story;
  final VoidCallback onBack;

  const StoryDetailScreen({
    super.key,
    required this.story,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('MMMM d, yyyy · HH:mm');
    final formattedDate = dateFormat.format(story.createdAt);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.story_details,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: onBack),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image
            Hero(
              tag: 'story-image-${story.id}',
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  story.photoUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
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
                ),
              ),
            ),

            // content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // author info
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
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // description
                  Text(story.description, style: TextStyle(fontSize: 16)),

                  SizedBox(height: 24),

                  // location info if available
                  if (story.lat != null && story.lon != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              localizations.location,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${localizations.latitude}: ${story.lat?.toStringAsFixed(6)}, ${localizations.longitude}: ${story.lon?.toStringAsFixed(6)}',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 16),

                        // placeholder map
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              localizations.map_view,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
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
