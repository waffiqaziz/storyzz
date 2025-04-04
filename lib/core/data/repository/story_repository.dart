import 'package:storyzz/core/data/networking/responses/stories_response.dart';
import 'package:storyzz/core/data/networking/services/api_services.dart';
import 'package:storyzz/core/data/networking/utils/api_utils.dart';

import '../model/user.dart';

class StoryRepository {
  final ApiServices _apiServices;

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
}
