import 'package:storyzz/core/data/models/user.dart';
import 'package:storyzz/core/data/networking/models/story/list_story.dart';

final dumpTestUser = const User(
  name: 'Test User',
  email: 'test@example.com',
  token: 'test-token',
  password: 'password123',
);

final dumpTestlistStory1 = ListStory(
  id: '1',
  name: 'My Name',
  description: 'Test story 1',
  photoUrl: 'https://example.com/photo1.jpg',
  createdAt: DateTime.now(),
  lat: -6.2088,
  lon: 106.8456,
);

final dumpTestlistStory2 = ListStory(
  id: '2',
  name: 'Your Name',
  description: 'Test story 2',
  photoUrl: 'https://example.com/photo2.jpg',
  createdAt: DateTime.now(),
);

final dumpTestStoryList = [dumpTestlistStory1, dumpTestlistStory2];
