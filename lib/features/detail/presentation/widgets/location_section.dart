import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/data/networking/states/address_load_state.dart';
import 'package:storyzz/core/providers/address_provider.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/features/detail/presentation/widgets/address_section.dart';
import 'package:storyzz/features/detail/presentation/widgets/story_location_map.dart';

/// A section widget that displays the story's address and map location.
///
/// - Shows the formatted address via [AddressSection].
/// - Displays the story location using [StoryLocationMap].
/// - Fetches address asynchronously if not yet requested.
///
/// Parameters:
/// [story] provides the coordinates and ID for the location.
/// [mapControlsEnabled] toggles map interaction UI.
/// [mapKeyPrefix] is used to generate a unique [ValueKey] for the map.
class LocationSection extends StatefulWidget {
  final bool mapControlsEnabled;
  final String mapKeyPrefix;

  const LocationSection({
    super.key,
    this.mapControlsEnabled = true,
    this.mapKeyPrefix = 'detail',
  });

  @override
  State<LocationSection> createState() => _LocationSectionState();
}

class _LocationSectionState extends State<LocationSection> {
  bool _requestedAddress = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // get formatter address
    if (!_requestedAddress) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AddressProvider>().getAddressFromCoordinates(
          context.read<AppProvider>().selectedStory!.lat!,
          context.read<AppProvider>().selectedStory!.lon!,
        );
      });
      _requestedAddress = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final address = context.watch<AddressProvider>().state.getAddressOrFallback(
      context,
    );
    final story = context.read<AppProvider>().selectedStory!;

    return Column(
      crossAxisAlignment: .start,
      children: [
        const Divider(),
        const SizedBox(height: 16),

        // address
        AddressSection(latitude: story.lat!, longitude: story.lon!),

        const SizedBox(height: 16),

        // map
        Stack(
          children: [
            StoryLocationMap(
              key: ValueKey('${widget.mapKeyPrefix}-location-map-${story.id}'),
              latitude: story.lat!,
              longitude: story.lon!,
              height: 400.0,
              controlsEnabled: widget.mapControlsEnabled,
              title: story.name,
              location: address,
            ),

            // TODO: Future feature: Fullscreen map
            // Positioned(
            //   top: 12,
            //   left: 12,
            //   child: PointerInterceptor(
            //     child: FloatingActionButton.small(
            //       backgroundColor: Colors.white,
            //       foregroundColor: Colors.black,
            //       child: const Icon(Icons.fullscreen),
            //       onPressed: () {
            //         context.read<AppProvider>().openDetailFullScreenMap();
            //       },
            //     ),
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}
