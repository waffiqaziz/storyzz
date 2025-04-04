import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:storyzz/core/data/model/user.dart';
import 'package:storyzz/core/data/networking/responses/login_response.dart';
import 'package:storyzz/core/data/networking/responses/register_response.dart';
import 'package:storyzz/core/data/networking/responses/stories_response.dart';
import 'package:storyzz/core/data/networking/utils/api_utils.dart';

class ApiServices {
  static const String _baseUrl = "https://story-api.dicoding.dev/v1";
  final http.Client httpClient;

  ApiServices({required this.httpClient});

  Future<ApiResult<LoginResponse>> login(String email, String password) async {
    return await safeApiCall(() async {
      final response = await httpClient.post(
        Uri.parse("$_baseUrl/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "password": password}),
      );
      final body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LoginResponse.fromJson(body);
      } else {
        // extract error message from response body
        final errorMessage = body['message'] ?? "Login failed";
        throw Exception(errorMessage);
      }
    });
  }

  Future<ApiResult<RegisterResponse>> register(User user) async {
    return await safeApiCall(() async {
      final response = await httpClient.post(
        Uri.parse("$_baseUrl/register"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": user.name,
          "email": user.email,
          "password": user.password,
        }),
      );

      final json = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterResponse.fromJson(json);
      } else {
        // extract error message from response body
        final message = json['message'] ?? 'Unknown error occurred';
        throw Exception(message);
      }
    });
  }

  Future<ApiResult<StoriesResponse>> getStories({
    int? page,
    int? size,
    int location = 0,
    required User user,
  }) async {
    return await safeApiCall(() async {
      final queryParams = <String, String>{};
      if (page != null) queryParams['page'] = page.toString();
      if (size != null) queryParams['size'] = size.toString();
      queryParams['location'] = location.toString();

      final uri = Uri.parse(
        "$_baseUrl/stories",
      ).replace(queryParameters: queryParams);

      final response = await httpClient.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${user.token}',
        },
      );

      if (response.statusCode == 200) {
        return StoriesResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Failed to get stories. Status code: ${response.statusCode}',
        );
      }
    });
  }
}
