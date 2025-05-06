import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;
import 'package:storyzz/core/data/model/user.dart';
import 'package:storyzz/core/data/networking/responses/general_response.dart';
import 'package:storyzz/core/data/networking/responses/login_response.dart';
import 'package:storyzz/core/data/networking/responses/stories_response.dart';
import 'package:storyzz/core/data/networking/utils/api_utils.dart';

/// A service class responsible for handling API interactions, such as login, registration,
/// fetching stories, and uploading stories to the server.
///
/// The class provides methods for interacting with the story API (https://story-api.dicoding.dev/v1),
/// handling responses, and managing errors in a safe way.
class ApiServices {
  static const String _baseUrl = "https://story-api.dicoding.dev/v1";
  final http.Client httpClient;

  ApiServices({required this.httpClient});

  /// Logs the user in with the provided email and password.
  ///
  /// Sends a POST request to the "/login" endpoint to authenticate the user.
  /// If the login is successful, a [LoginResponse] is returned; otherwise,
  /// an error message is thrown.
  ///
  /// Parameters:
  /// - [email] The email address of the user.
  /// - [password] The password of the user.
  ///
  /// Returns a [ApiResult] containing either the login response or an error message.
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

  /// Registers a new user with the provided [User] details.
  ///
  /// Sends a POST request to the "/register" endpoint to create a new user.
  /// If registration is successful, a [GeneralResponse] is returned; otherwise,
  /// an error message is thrown.
  ///
  /// Parameters:
  /// - [user] The [User] object containing the user's registration details.
  ///
  /// Returns a [ApiResult] containing either the registration response or an error message.
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

  /// Fetches a list of stories from the API with optional pagination and location filtering.
  ///
  /// Sends a GET request to the "/stories" endpoint to retrieve stories. The request
  /// includes optional query parameters for pagination (page and size) and location (latitude/longitude).
  /// The [user] object is used to include the authorization token in the request headers.
  ///
  /// Parameters:
  /// - [page] Optional. The page number for pagination.
  /// - [size] Optional. The number of items per page for pagination.
  /// - [location] The location filter for stories (default is 0).
  /// - [user] The [User] object containing the authorization token.
  ///
  /// Returns a [ApiResult] containing either a [StoriesResponse] or an error message.
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

  /// Uploads a story with an optional image file.
  ///
  /// Sends a POST request to the "/stories" endpoint with a multipart request body.
  /// The request includes a description, location (latitude and longitude), and
  /// an image file (either as a `File` for mobile or `Uint8List` for web). If the upload is successful,
  /// a [GeneralResponse] is returned; otherwise, an error message is thrown.
  ///
  /// Parameters:
  /// - [token] The user's authentication token.
  /// - [description] The description of the story.
  /// - [photoFile] The image file for mobile (optional).
  /// - [photoBytes] The image bytes for web (optional).
  /// - [fileName] The file name of the image.
  /// - [lat] The latitude of the story location (optional).
  /// - [lon] The longitude of the story location (optional).
  ///
  /// Returns a [ApiResult] containing either the upload response or an error message.
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
      final mime = MediaType('image', _getImageMimeType(extension));

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

      // send the request and get the response
      final streamedResponse = await httpClient.send(request);

      // check if the response is successful
      final response = await http.Response.fromStream(streamedResponse);

      // handle the response
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final json = jsonDecode(response.body);
          return GeneralResponse.fromJson(json);
        } catch (e) {
          throw FormatException('Failed to decode response: ${response.body}');
        }
      } else {
        // extract error message
        String errorMessage;
        try {
          final json = jsonDecode(response.body);
          errorMessage = json['message'] ?? 'Unknown server error';
        } catch (e) {
          errorMessage = 'Server error: Status code ${response.statusCode}';
        }
        throw Exception(errorMessage);
      }
    });
  }

  /// Helper function to determine MIME type from file extension.
  ///
  /// [filePath] The path to the file (including the extension).
  ///
  /// Returns the MIME type corresponding to the file extension.
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
