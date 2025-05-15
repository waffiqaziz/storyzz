// ignore_for_file: overridden_fields

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storyzz/features/detail/presentation/widgets/detail_image.dart';

class FakeImageLoadingProgress extends ImageChunkEvent {
  @override
  final int cumulativeBytesLoaded;

  @override
  final int? expectedTotalBytes;

  const FakeImageLoadingProgress(
    this.cumulativeBytesLoaded,
    this.expectedTotalBytes,
  ) : super(cumulativeBytesLoaded: 0, expectedTotalBytes: 0);
}

void main() {
  group('DetailImage', () {
    testWidgets('shows loading indicator while image is loading', (
      tester,
    ) async {
      final loadingProgress = const FakeImageLoadingProgress(50, 100);

      await tester.pumpWidget(
        MaterialApp(
          home: DetailImage(photoUrl: 'https://example.com/image.jpg'),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      final loadingBuilder = image.loadingBuilder!;
      final context = tester.element(find.byType(Image));

      final loadingWidget = loadingBuilder(
        context,
        const SizedBox(),
        loadingProgress,
      );

      // inject the result into the tree
      await tester.pumpWidget(MaterialApp(home: loadingWidget));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
