import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/features/upload_story/presentation/providers/upload_story_provider.dart';
import 'package:storyzz/features/upload_story/presentation/widgets/build_google_map.dart';

/// A widget that displays a fullscreen map with a close button.
/// The map is displayed in a circular shape, and the close button is positioned
class MapFullScreen extends StatelessWidget {
  const MapFullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<UploadStoryProvider>();
    if (provider.selectedLocation == null) return const SizedBox.shrink();

    return SafeArea(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Circular Google Map
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: BuildGoogleMap(),
          ),

          // Close button positioned diagonally outside the map
          Positioned(
            top: 16,
            left: 16,
            child: PointerInterceptor(
              child: FloatingActionButton.small(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                onPressed: () {
                  context.read<AppProvider>().closeUploadFullScreenMap();
                },
                child: const Icon(Icons.close),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
