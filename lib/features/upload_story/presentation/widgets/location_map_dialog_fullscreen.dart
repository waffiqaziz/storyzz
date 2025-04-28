import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/features/upload_story/presentation/providers/upload_story_provider.dart';
import 'package:storyzz/features/upload_story/presentation/widgets/build_google_map.dart';

class MapDialogFullScreen extends StatelessWidget {
  const MapDialogFullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<UploadStoryProvider>();
    if (provider.selectedLocation == null) return const SizedBox.shrink();

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          context.read<AppProvider>().closeFullScreenMap();
        }
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(48),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Circular Google Map
            ClipRRect(
              borderRadius: BorderRadius.circular(25), // Large value for circle
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: BuildGoogleMap(),
              ),
            ),

            // Close button positioned diagonally outside the map
            Positioned(
              top: -40,
              right: -40,
              child: PointerInterceptor(
                child: FloatingActionButton.small(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  onPressed: () {
                    context.read<AppProvider>().closeFullScreenMap();
                  },
                  child: const Icon(Icons.close),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
