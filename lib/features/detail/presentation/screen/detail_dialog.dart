import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/core/utils/helper.dart';
import 'package:storyzz/features/detail/presentation/widgets/location_section.dart';

/// A dialog view that displays the details of a story, similar to the full-screen
/// `StoryDetailScreen`, but presented in a dialog. This is typically shown for
/// desktop view
///
/// Displays the following:
/// - Story image (with loading and error states)
/// - Author information (name, avatar, and timestamp)
/// - Full story description
/// - Map section (if location data is available)
///
/// Parameters:
/// - [story]: The story object to display
/// - [onClose]: Callback to handle closing the dialog
class StoryDetailDialog extends StatelessWidget {
  const StoryDetailDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final story = context.read<AppProvider>().selectedStory!;

    // use MediaQuery to get screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth > 800 ? 700.0 : screenWidth * 0.8;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<AppProvider>().closeDetail();
          });
        }
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
          horizontal: (screenWidth - dialogWidth) / 2,
          vertical: 24,
        ),
        child: Container(
          width: dialogWidth,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // header with close button
              _buildHeader(context, localizations),

              Divider(height: 1),

              // scrollable content
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStoryImage(story.photoUrl),

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
                            Text(
                              story.description,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 24),

                            // location info if available
                            if (story.lat != null && story.lon != null)
                              LocationSection(
                                mapControlsEnabled: false,
                                mapKeyPrefix: 'dialog',
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            localizations.story_details,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<AppProvider>().closeDetail();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStoryImage(String photoUrl) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 400, minWidth: double.infinity),
      child: Image.network(
        photoUrl,
        fit: BoxFit.contain,
        width: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 350,
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
              height: 350,
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
