import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/core/utils/helper.dart';
import 'package:storyzz/features/detail/presentation/widgets/author_info.dart';
import 'package:storyzz/features/detail/presentation/widgets/detail_image.dart';
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
class StoryDetailDialog extends StatefulWidget {
  const StoryDetailDialog({super.key});

  @override
  State<StoryDetailDialog> createState() => _StoryDetailDialogState();
}

class _StoryDetailDialogState extends State<StoryDetailDialog> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollbar = true;
  Timer? _someTimer;

  @override
  void initState() {
    super.initState();

    // hide the scrollbar if the user hasn't scrolled
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _someTimer = Timer(Duration(milliseconds: 800), () {
        if (mounted && _scrollController.offset == 0.0) {
          setState(() => _showScrollbar = false);
        }
      });
    });
  }

  @override
  void dispose() {
    _someTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final story = context.read<AppProvider>().selectedStory!;

    // use MediaQuery to get screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth > 800 ? 700.0 : screenWidth * 0.8;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<AppProvider>().closeDetailScreen();
          });
        }
      },
      child: Stack(
        children: [
          // The original dialog
          Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.symmetric(
              horizontal: (screenWidth - dialogWidth) / 2,
              vertical: 24,
            ),
            child: PointerInterceptor(
              child: Container(
                width: dialogWidth,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: .circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: _showScrollbar,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              _buildStoryImage(story.photoUrl),

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
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Exit button positioned relative to the screen
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: Icon(Icons.close_rounded, size: 28, color: Colors.white),
              onPressed: () {
                context.read<AppProvider>().closeDetailScreen();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryImage(String photoUrl) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 300, minWidth: double.infinity),
      child: GestureDetector(
        onTap: () => openUrl(photoUrl),
        child: DetailImage(photoUrl: photoUrl),
      ),
    );
  }
}
