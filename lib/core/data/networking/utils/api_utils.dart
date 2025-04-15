import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart';

class ApiResult<T> {
  final T? data;
  final String? message;

  ApiResult._({this.data, this.message});

  factory ApiResult.success(T data) => ApiResult._(data: data);
  factory ApiResult.error(String message) => ApiResult._(message: message);
}

/// Handles API calls safely by catching various exceptions
/// and returning appropriate error messages.
Future<ApiResult<T>> safeApiCall<T>(Future<T> Function() apiCall) async {
  try {
    final result = await apiCall();
    return ApiResult.success(result);
  } on ClientException catch (e) {
    log("API Call Failed: ClientException - ${e.message}");
    return ApiResult.error(
      "Network request failed. Please check your connection.",
    );
  } on SocketException catch (e) {
    log("API Call Failed: SocketException - ${e.message}");
    return ApiResult.error(
      "No internet connection. Please check your network.",
    );
  } on TimeoutException {
    log("API Call Failed: TimeoutException");
    return ApiResult.error("The connection timed out. Please try again.");
  } on HttpException {
    log("API Call Failed: HttpException");
    return ApiResult.error("An HTTP error occurred. Please try again.");
  } on FormatException {
    log("API Call Failed: FormatException");
    return ApiResult.error("Invalid response format. Please contact support.");
  } on TypeError {
    log("API Call Failed: TypeError");
    return ApiResult.error(
      "Unexpected data type encountered. Please try again.",
    );
  } on PlatformException catch (e) {
    log("API Call Failed: PlatformException - ${e.message}");
    return ApiResult.error("A platform error occurred: ${e.message}");
  } on UnsupportedError {
    log("API Call Failed: UnsupportedError");
    return ApiResult.error(
      "Unsupported operation encountered. Please try again.",
    );
  } on RangeError {
    log("API Call Failed: RangeError");
    return ApiResult.error(
      "An out-of-bounds error occurred. Please try again.",
    );
  } on StateError {
    log("API Call Failed: StateError");
    return ApiResult.error(
      "Invalid state encountered during operation. Please try again.",
    );
  } on JsonUnsupportedObjectError {
    log("API Call Failed: JsonUnsupportedObjectError");
    return ApiResult.error("Failed to encode data to JSON. Please try again.");
  } catch (e, stackTrace) {
    log("API Call Failed: Unexpected error - $e", stackTrace: stackTrace);

    // remove "Exception: " prefix
    String errorMessage = e.toString();
    if (errorMessage.startsWith('Exception: ')) {
      errorMessage = errorMessage.replaceFirst('Exception: ', '');
    }

    return ApiResult.error(errorMessage);
  }
}
