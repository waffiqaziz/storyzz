// filepath: d:\pem\Dart\Flutter\intermediate\submission\storyzz\test\core\data\networking\responses\stories_response_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:storyzz/core/data/networking/responses/stories_response.dart';
import 'package:storyzz/core/data/networking/responses/list_story.dart';

void main() {
  group('StoriesResponse', () {
    test('fromJson should correctly parse JSON', () {
      final json = {
        'error': true,
        'message': 'This is an error message',
        'listStory': [
          {
            'id': '1',
            'name': 'Story 1',
            'description': 'Description 1',
            'photoUrl': 'url1',
            'createdAt': DateTime.now().toIso8601String(),
            'lat': 1.0,
            'lon': 2.0,
          },
          {
            'id': '2',
            'name': 'Story 2',
            'description': 'Description 2',
            'photoUrl': 'url2',
            'createdAt': DateTime.now().toIso8601String(),
          },
        ],
      };

      final storiesResponse = StoriesResponse.fromJson(json);

      expect(storiesResponse.error, true);
      expect(storiesResponse.message, 'This is an error message');
      expect(storiesResponse.listStory.length, 2);
      expect(storiesResponse.listStory[0], isA<ListStory>());
      expect(storiesResponse.listStory[0].id, '1');
      expect(storiesResponse.listStory[1].lat, null);
    });

    test('toJson should correctly convert to JSON', () {
      final now = DateTime.now();
      final storiesResponse = StoriesResponse(
        error: false,
        message: 'Success!',
        listStory: [
          ListStory(
            id: '1',
            name: 'Story 1',
            description: 'Description 1',
            photoUrl: 'url1',
            createdAt: now,
            lat: 1.0,
            lon: 2.0,
          ),
        ],
      );

      final json = storiesResponse.toJson();

      expect(json['error'], false);
      expect(json['message'], 'Success!');
      expect(json['listStory'].length, 1);
      expect(json['listStory'][0]['id'], '1');
    });
  });

  group('ListStory', () {
    test('fromJson should correctly parse JSON', () {
      final json = {
        'id': '1',
        'name': 'Story 1',
        'description': 'Description 1',
        'photoUrl': 'url1',
        'createdAt': DateTime.now().toIso8601String(),
        'lat': 1.0,
        'lon': 2.0,
      };

      final listStory = ListStory.fromJson(json);

      expect(listStory.id, '1');
      expect(listStory.name, 'Story 1');
      expect(listStory.description, 'Description 1');
      expect(listStory.photoUrl, 'url1');
      expect(listStory.lat, 1.0);
      expect(listStory.lon, 2.0);
    });

    test('toJson should correctly convert to JSON', () {
      final now = DateTime.now();
      final listStory = ListStory(
        id: '1',
        name: 'Story 1',
        description: 'Description 1',
        photoUrl: 'url1',
        createdAt: now,
        lat: 1.0,
        lon: 2.0,
      );

      final json = listStory.toJson();

      expect(json['id'], '1');
      expect(json['name'], 'Story 1');
      expect(json['description'], 'Description 1');
      expect(json['photoUrl'], 'url1');
      expect(json['lat'], 1.0);
      expect(json['lon'], 2.0);
      expect(DateTime.parse(json['createdAt'] as String), now);
    });
  });
}
