import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/data/networking/states/address_load_state.dart';
import 'package:storyzz/core/providers/address_provider.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/features/detail/presentation/widgets/story_location_map.dart';

class DetailFullScreenMap extends StatelessWidget {
  const DetailFullScreenMap({super.key});

  @override
  Widget build(BuildContext context) {
    final address = context.watch<AddressProvider>().state.getAddressOrFallback(
      context,
    );
    final story = context.read<AppProvider>().selectedStory!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            StoryLocationMap(
              latitude: story.lat!,
              longitude: story.lon!,
              title: story.name,
              location: address,
              height: MediaQuery.of(context).size.height,
              controlsEnabled: true,
            ),
            Positioned(
              top: 16,
              left: 16,
              child: FloatingActionButton.small(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                onPressed:
                    () => context.read<AppProvider>().closeFullScreenMap(),
                child: const Icon(Icons.close),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
