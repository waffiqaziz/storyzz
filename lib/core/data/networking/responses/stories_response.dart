class StoriesResponse {
  final bool error;
  final String message;
  final List<ListStory> listStory;

  StoriesResponse({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory StoriesResponse.fromJson(Map<String, dynamic> json) {
    return StoriesResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
      listStory:
          (json['listStory'] as List<dynamic>)
              .map((e) => ListStory.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}

class ListStory {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final DateTime createdAt;
  final double? lat;
  final double? lon;

  ListStory({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    this.lat,
    this.lon,
  });

  factory ListStory.fromJson(Map<String, dynamic> json) {
    return ListStory(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      photoUrl: json['photoUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lat: (json['lat'] != null) ? (json['lat'] as num).toDouble() : null,
      lon: (json['lon'] != null) ? (json['lon'] as num).toDouble() : null,
    );
  }
}
