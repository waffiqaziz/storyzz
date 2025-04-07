import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
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

  Future<ApiResult<GeneralResponse>> register(User user) async {
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
        return GeneralResponse.fromJson(json);
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

  Future<ApiResult<GeneralResponse>> uploadStory({
    required String token,
    required String description,
    File? photoFile, // for mobile
    Uint8List? photoBytes, // for web
    required String fileName, // used in both cases
    double? lat,
    double? lon,
  }) async {
    return await safeApiCall(() async {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("$_baseUrl/stories"),
      );

      request.headers.addAll({'Authorization': 'Bearer $token'});
      request.fields['description'] = description;

      if (lat != null) request.fields['lat'] = lat.toString();
      if (lon != null) request.fields['lon'] = lon.toString();

      final extension = path.extension(fileName).toLowerCase();
      final mime = MediaType(
        'image',
        _getImageMimeType(extension),
      ); // get file extensions

      if (kIsWeb && photoBytes != null) {
        final multipart = http.MultipartFile.fromBytes(
          'photo',
          photoBytes,
          filename: fileName,
          contentType: mime,
        );
        request.files.add(multipart);
      } else if (photoFile != null) {
        final photoStream = http.ByteStream(photoFile.openRead());
        final photoLength = await photoFile.length();

        final multipart = http.MultipartFile(
          'photo',
          photoStream,
          photoLength,
          filename: path.basename(photoFile.path),
          contentType: mime,
        );
        request.files.add(multipart);
      } else {
        throw Exception('No image data provided');
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final json = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return GeneralResponse.fromJson(json);
      } else {
        final message = json['message'] ?? 'Unknown error occurred';
        throw Exception(message);
      }
    });
  }

  // helper function to determine MIME type from file extension
  String _getImageMimeType(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return 'jpeg';
      case '.png':
        return 'png';
      case '.gif':
        return 'gif';
      default:
        return 'jpeg';
    }
  }
}
