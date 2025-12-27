import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storyzz/core/data/networking/models/story/list_story.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/features/home/presentation/widgets/home_story_card.dart';

void main() {
  group('HomeStoryCard', () {
    late ListStory testStory;

    setUp(() {
      testStory = ListStory(
        id: '1',
        name: 'Test Story',
        description: 'This is a test story description',
        photoUrl: 'https://picsum.photos/600/400',
        createdAt: DateTime.now().subtract(Duration(hours: 2)),
        lat: 10.0,
        lon: 20.0,
      );
    });

    Widget createTestWidget({ListStory? story, bool showLocation = false}) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: Scaffold(
          body: SingleChildScrollView(
            child: HomeStoryCard(story: story ?? testStory),
          ),
        ),
      );
    }

    testWidgets('renders story card with all elements', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byType(Card), findsOneWidget);
      expect(find.text('Test Story'), findsOneWidget);
      expect(find.text('This is a test story description'), findsOneWidget);
      expect(find.byIcon(Icons.location_on), findsOneWidget);
    });

    testWidgets('hides location icon when lat/lon are null', (tester) async {
      final noLocationStory = testStory.copyWith(lat: null, lon: null);

      await tester.pumpWidget(createTestWidget(story: noLocationStory));

      expect(find.byIcon(Icons.location_on), findsNothing);
    });

    testWidgets('shows loading indicator with progress', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // image widget
      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);

      final Image image = tester.widget(imageFinder);
      final BuildContext context = tester.element(imageFinder);

      // test loadingBuilder when loadingProgress is null (image loaded)
      final childWidget = Container(key: Key('child'));
      final loadedWidget = image.loadingBuilder!(context, childWidget, null);
      expect(loadedWidget, equals(childWidget));

      // test loadingBuilder with progress (expectedTotalBytes != null)
      final loadingWithProgress = image.loadingBuilder!(
        context,
        Container(),
        ImageChunkEvent(cumulativeBytesLoaded: 50, expectedTotalBytes: 100),
      );
      await tester.pumpWidget(MaterialApp(home: loadingWithProgress));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      final CircularProgressIndicator progressIndicator = tester.widget(
        find.byType(CircularProgressIndicator),
      );
      expect(progressIndicator.value, 0.5);

      // test loadingBuilder with progress (expectedTotalBytes == null)
      final loadingWithoutTotal = image.loadingBuilder!(
        context,
        Container(),
        ImageChunkEvent(cumulativeBytesLoaded: 50, expectedTotalBytes: null),
      );
      await tester.pumpWidget(MaterialApp(home: loadingWithoutTotal));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      final CircularProgressIndicator indeterminateIndicator = tester.widget(
        find.byType(CircularProgressIndicator),
      );
      expect(indeterminateIndicator.value, isNull);
    });

    testWidgets('shows location icon when showLocationIcon is true', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(showLocation: true));

      expect(find.byIcon(Icons.location_on), findsOneWidget);
    });

    testWidgets('shows error icon on image load failure', (tester) async {
      await tester.pumpWidget(
        createTestWidget(story: testStory.copyWith(photoUrl: 'invalid-url')),
      );

      await tester.pump();
      expect(find.byIcon(Icons.broken_image), findsOneWidget);
    });
  });
}
