import 'dart:io';
import 'dart:typed_data';

import 'package:storyzz/core/data/models/user.dart';
import 'package:storyzz/core/data/networking/api/services/story_api_services.dart';
import 'package:storyzz/core/data/networking/models/general/general_response.dart';
import 'package:storyzz/core/data/networking/models/story/stories_response.dart';
import 'package:storyzz/core/data/networking/utils/api_utils.dart';

class StoryRepository {
  final StoryApiServices _apiServices;

  StoryRepository(this._apiServices);

  Future<ApiResult<StoriesResponse>> getStories({
    int? page,
    int? size,
    int location = 0,
    required User user,
  }) async {
    return await _apiServices.getStories(
      page: page,
      size: size,
      location: location,
      user: user,
    );
  }

  Future<ApiResult<GeneralResponse>> uploadStory({
    required String token,
    required String description,
    File? photoFile,
    Uint8List? photoBytes,
    required String fileName,
    double? lat,
    double? lon,
  }) async {
    return await _apiServices.uploadStory(
      token: token,
      description: description,
      photoFile: photoFile,
      photoBytes: photoBytes,
      fileName: fileName,
      lat: lat,
      lon: lon,
    );
  }
}
