import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:storyzz/core/data/networking/responses/list_story.dart';

part 'stories_response.freezed.dart';
part 'stories_response.g.dart';

@freezed
abstract class StoriesResponse with _$StoriesResponse {
  const factory StoriesResponse({
    required bool error,
    required String message,
    required List<ListStory> listStory,
  }) = _StoriesResponse;

  factory StoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$StoriesResponseFromJson(json);
}
