import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/core/utils/helper.dart';
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
  final VoidCallback onBack;

  const StoryDetailScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final story = context.read<AppProvider>().selectedStory!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.story_details,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            onBack();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image
            Hero(
              tag: 'story-image-${story.id}',
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 200,
                  minWidth: double.infinity,
                ),
                child: Image.network(
                  story.photoUrl,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      constraints: BoxConstraints(minHeight: 350),
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
                  _buildAuthorInfo(context),
                  SizedBox(height: 16),

                  // description
                  Text(story.description, style: TextStyle(fontSize: 16)),
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
    );
  }

  Widget _buildAuthorInfo(BuildContext context) {
    final story = context.read<AppProvider>().selectedStory!;

    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            story.name.isNotEmpty ? story.name[0].toUpperCase() : '?',
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                formattedLocalTime(story.createdAt),
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
